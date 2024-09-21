module mover_nft::mover_nft {

    use std::string::{Self, String};
    use std::vector;
    use std::option::{Self, Option};

    use sui::url::{Self, Url};
    use sui::display;
    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::vec_map::{Self, VecMap};
    use sui::transfer_policy::{Self, TransferPolicy, TransferPolicyCap};
    use sui::event;
    use sui::table_vec::{Self, TableVec};
    use sui::random::{Self, Random};

    use kiosk::royalty_rule as kiosk_royalty_rule;
    use kiosk::kiosk_lock_rule;
    use kiosk::personal_kiosk_rule;

    use mover_nft::utils;

    const E_INVALID_WHITELIST: u64 = 1;
    const E_EMPTY_POOL: u64 = 2;
    const E_NOT_LIVE: u64 = 3;
    const E_INVALID_INDEX: u64 = 4;

    /// One time witness is only instantiated in the init method
    struct MOVER_NFT has drop {}

    struct Tails has key, store {
        id: UID,
        name: String,
        description: String,
        number: u64,
        url: Url,
        attributes: VecMap<String, String>,
        level: u64,
        exp: u64,
        u64_padding: VecMap<String, u64>,
    }

    struct ManagerCap has key, store { id: UID }

    struct Royalty has key {
        id: UID,
        recipient: address,
        policy_cap: TransferPolicyCap<Tails>
    }


    #[lint_allow(self_transfer, share_owned)]
    fun init(otw: MOVER_NFT, ctx: &mut TxContext) {
        let publisher = sui::package::claim(otw, ctx);

        let display = display::new<Tails>(&publisher, ctx);
        display::add(&mut display, string::utf8(b"name"), string::utf8(b"{name}"));
        display::add(&mut display, string::utf8(b"description"), string::utf8(b"{description}"));
        display::add(&mut display, string::utf8(b"image_url"), string::utf8(b"{url}"));
        display::add(&mut display, string::utf8(b"attributes"), string::utf8(b"{attributes}"));
        display::add(&mut display, string::utf8(b"level"), string::utf8(b"{level}"));
        display::add(&mut display, string::utf8(b"exp"), string::utf8(b"{exp}"));
        display::update_version(&mut display);

        let manager_cap = ManagerCap { id: object::new(ctx) };

        let (policy, policy_cap) = transfer_policy::new<Tails>(&publisher, ctx);
        // 1. add royalty_rule
        kiosk_royalty_rule::add(&mut policy, &policy_cap, 1_000, 1_000_000_000); // MAX(10%, 1 SUI), MAX_BPS = 10_000

        // 2. add kiosk_lock_rule
        kiosk_lock_rule::add(&mut policy, &policy_cap);

        // 3. add personal_kiosk_rule
        personal_kiosk_rule::add(&mut policy, &policy_cap);

        let royalty = Royalty {
            id: object::new(ctx),
            recipient: @ADMIN,
            policy_cap
        };

        let sender = tx_context::sender(ctx);
        transfer::public_transfer(publisher, sender);
        transfer::public_transfer(display, sender);
        transfer::public_transfer(manager_cap, sender);
        transfer::public_share_object(policy);
        // transfer::public_transfer(policy_cap, sender);
        transfer::share_object(royalty);
    }

    entry fun withdraw_royalty(
        _manager_cap: &ManagerCap,
        royalty: &Royalty,
        policy: &mut TransferPolicy<Tails>,
        ctx: &mut TxContext,
    ) {
        let coin = transfer_policy::withdraw(policy, &royalty.policy_cap, option::none(), ctx);
        transfer::public_transfer(coin, royalty.recipient);
    }

    struct Pool has key {
        id: UID,
        tails: TableVec<Tails>,
        num: u64,
        is_live: bool,
    }

    entry fun new_pool(
        _manager_cap: &ManagerCap,
        ctx: &mut TxContext,
    ) {
        let pool = Pool {
            id: object::new(ctx),
            tails: table_vec::empty(ctx),
            num: 0,
            is_live: false,
        };
        transfer::share_object(pool);
    }

    entry fun close_pool(
        _manager_cap: &ManagerCap,
        pool: Pool,
    ) {
        let Pool {
            id,
            tails,
            num:_,
            is_live:_,
        } = pool;

        table_vec::destroy_empty(tails);
        object::delete(id);
    }

    struct NewManagerCapEvent has copy, drop {
        id: ID,
        sender: address
    }

    #[lint_allow(self_transfer)]
    entry fun new_manager_cap (
        _manager_cap: &ManagerCap,
        ctx: &mut TxContext,
    ) {
        let manager_cap = ManagerCap { id: object::new(ctx) };
        let sender = tx_context::sender(ctx);

        let new_manager_cap_event = NewManagerCapEvent {
            id: object::id(&manager_cap),
            sender
        };
        event::emit(new_manager_cap_event);

        transfer::public_transfer(manager_cap, sender);
    }

    entry fun deposit_nft(
        _manager_cap: &ManagerCap,
        pool: &mut Pool,
        name: String,
        number: u64,
        url: vector<u8>,
        attribute_keys: vector<String>,
        attribute_values: vector<String>,
        ctx: &mut TxContext,
    ) {
        let url = url::new_unsafe_from_bytes(url);
        let attributes = utils::from_vec_to_map(attribute_keys, attribute_values);
        let nft = new_nft(name, number, url, attributes, ctx);

        table_vec::push_back(&mut pool.tails, nft);
        pool.num = pool.num + 1;
    }

    fun new_nft(
        name: String,
        number: u64,
        url: Url,
        attributes: VecMap<String, String>,
        ctx: &mut TxContext,
    ): Tails {
        let description = string::utf8(b"Tails by Sui Mover 2024.");

        let nft = Tails {
            id: object::new(ctx),
            name,
            number,
            description,
            url,
            attributes,
            level: 1,
            exp: 0,
            u64_padding: vec_map::empty()
        };

        nft
    }

    struct Whitelist has key {
        id: UID,
        for: ID
    }

    entry fun issue_whitelist(
        _manager_cap: &ManagerCap,
        pool: &Pool,
        recipients: vector<address>,
        ctx: &mut TxContext,
    ) {
        while (!vector::is_empty(&recipients)) {
            let recipient = vector::pop_back<address>(&mut recipients);
            let id = object::id(pool);
            let wl = Whitelist{ id: object::new(ctx), for: id };
            transfer::transfer(wl, recipient);
        }
    }

    entry fun update_sale(
        _manager_cap: &ManagerCap,
        pool: &mut Pool,
        is_live: bool,
    ) {
        pool.is_live = is_live;
    }

    #[lint_allow(share_owned)]
    entry fun send_nfts(
        _manager_cap: &ManagerCap,
        pool: &mut Pool,
        policy: &TransferPolicy<Tails>,
        recipient: address,
        n: u64,
        ctx: &mut TxContext,
    ) {
        let (kiosk, kiosk_cap) = kiosk::new(ctx);

        while (n > 0) {
            let nft = table_vec::pop_back(&mut pool.tails);

            let mint_event = MintEvent {
                id: object::id(&nft),
                name: nft.name,
                description: nft.description,
                number: nft.number,
                url: nft.url,
                attributes: nft.attributes,
                sender: tx_context::sender(ctx)
            };
            event::emit(mint_event);

            kiosk::lock(&mut kiosk, &kiosk_cap, policy, nft);
            n = n - 1;
        };

        transfer::public_share_object(kiosk);
        transfer::public_transfer(kiosk_cap, recipient);
    }

    public(friend) fun withdraw_nfts(
        _manager_cap: &ManagerCap,
        pool: &mut Pool,
        n: u64
    ): vector<Tails> {
        let nfts = vector::empty<Tails>();
        while (n > 0) {
            let nft = table_vec::pop_back(&mut pool.tails);
            vector::push_back(&mut nfts, nft);
            n = n - 1;
        };
        nfts
    }

    // 1_000, 50_000, 250_000, 1_000_000, 5_000_000, 20_000_000
    fun get_level_exp(level: u64): u64 {
        let exp = if (level == 2) { 1_000 }
            else if (level == 3) { 50_000 }
            else if (level == 4) { 250_000 }
            else if (level == 5) { 1_000_000 }
            else if (level == 6) { 5_000_000 }
            else if (level == 7) { 20_000_000 }
            else { 0 };
        exp
    }

    entry fun update_pool_nft(
        manager_cap: &ManagerCap,
        pool: &mut Pool,
        index: u64,
        id: ID,
        level: u64,
        url: vector<u8>,
    ) {
        let nft = table_vec::borrow_mut(&mut pool.tails, index);
        update_nft(manager_cap, nft, id, level, url);
    }

    public(friend) fun update_nft(
        manager_cap: &ManagerCap,
        nft: &mut Tails,
        id: ID,
        level: u64,
        url: vector<u8>,
    ) {
        let exp = get_level_exp(level);
        assert!(object::id(nft) == id, E_INVALID_INDEX);
        nft.exp = exp;
        nft.url = url::new_unsafe_from_bytes(url);
        level_up(manager_cap, nft);
    }

    // Staking Related
    public fun update_image_url(
        _manager_cap: &ManagerCap,
        tails: &mut Tails,
        url: vector<u8>,
    ) {
        tails.url = url::new_unsafe_from_bytes(url);
    }

    struct ExpUpEvent has copy, drop {
        nft_id: ID,
        number: u64,
        exp_earn: u64
    }

    public fun nft_exp_up(
        _manager_cap: &ManagerCap,
        nft_mut: &mut Tails,
        exp: u64,
    ) {
        nft_mut.exp = nft_mut.exp + exp;

        let event = ExpUpEvent {
            nft_id: object::id(nft_mut),
            number: nft_mut.number,
            exp_earn: exp
        };
        event::emit(event);
    }

    struct ExpDownEvent has copy, drop {
        nft_id: ID,
        number: u64,
        exp_remove: u64
    }

    public fun nft_exp_down(
        _manager_cap: &ManagerCap,
        nft_mut: &mut Tails,
        exp: u64,
    ) {
        nft_mut.exp = nft_mut.exp - exp;

        let event = ExpDownEvent {
            nft_id: object::id(nft_mut),
            number: nft_mut.number,
            exp_remove: exp
        };
        event::emit(event);
    }

    struct LevelUpEvent has copy, drop {
        nft_id: ID,
        level: u64
    }

    public fun level_up(
        _manager_cap: &ManagerCap,
        nft_mut: &mut Tails,
    ): Option<u64> {
        let original_level = nft_mut.level;

        let level = if (nft_mut.exp >= get_level_exp(7)) { 7 }
                else if (nft_mut.exp >= get_level_exp(6)) { 6 }
                else if (nft_mut.exp >= get_level_exp(5)) { 5 }
                else if (nft_mut.exp >= get_level_exp(4)) { 4 }
                else if (nft_mut.exp >= get_level_exp(3)) { 3 }
                else if (nft_mut.exp >= get_level_exp(2)) { 2 }
                else { 1 };

        nft_mut.level = level;

        if (original_level != level) {
            let level_up_event = LevelUpEvent {
                nft_id: object::id(nft_mut),
                level: nft_mut.level
            };
            event::emit(level_up_event);
            return option::some(nft_mut.level)
        } else {
            return option::none()
        }
    }

    // User Entry
    struct MintEvent has copy, drop {
        id: ID,
        name: String,
        description: String,
        number: u64,
        url: Url,
        attributes: VecMap<String, String>,
        sender: address
    }

    public(friend) fun emit_mint_event(nft: &Tails, sender: address) {
        let mint_event = MintEvent {
            id: object::id(nft),
            name: nft.name,
            description: nft.description,
            number: nft.number,
            url: nft.url,
            attributes: nft.attributes,
            sender
        };
        event::emit(mint_event);
    }

    fun mint(
        pool: &mut Pool,
        whitelist_token: Whitelist,
        random: &Random,
        ctx: &mut TxContext,
    ): Tails {
        assert!(pool.is_live, E_NOT_LIVE);

        let len = table_vec::length(&pool.tails);
        assert!(len > 0, E_EMPTY_POOL);

        let Whitelist {id, for} = whitelist_token;
        object::delete(id);
        assert!(for == object::id(pool), E_INVALID_WHITELIST);

        let nft = if (len == 1) {
            table_vec::pop_back(&mut pool.tails)
        } else {
            let generator = random::new_generator(random, ctx);
            let i = random::generate_u64_in_range(&mut generator, 0, len-1);
            table_vec::swap(&mut pool.tails, i, len-1);
            table_vec::pop_back(&mut pool.tails)
        };

        let mint_event = MintEvent {
            id: object::id(&nft),
            name: nft.name,
            description: nft.description,
            number: nft.number,
            url: nft.url,
            attributes: nft.attributes,
            sender: tx_context::sender(ctx)
        };

        event::emit(mint_event);
        nft
    }

    entry fun free_mint_into_kiosk(
        pool: &mut Pool,
        policy: &TransferPolicy<Tails>,
        whitelist_token: Whitelist,
        kiosk: &mut Kiosk,
        kiosk_cap: &KioskOwnerCap,
        random: &Random,
        ctx: &mut TxContext,
    ) {
        let nft = mint(pool, whitelist_token, random, ctx);
        kiosk::lock(kiosk, kiosk_cap, policy, nft);
    }

    // Public Functions

    public fun tails_number(
        nft: &Tails,
    ): u64 {
        nft.number
    }

    public fun tails_level(
        nft: &Tails,
    ): u64 {
        nft.level
    }

    public fun tails_exp(
        nft: &Tails,
    ): u64 {
        nft.exp
    }

    public fun tails_attributes(
        nft: &Tails,
    ): VecMap<String, String> {
        nft.attributes
    }
}
