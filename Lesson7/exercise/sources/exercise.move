module exercise::exercise {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    use mover_nft::mover_nft::{Self, Tails, ManagerCap};

    struct Registry has key {
        id: UID,
        manager_cap: ManagerCap,
    }

    entry fun create_registry(manager_cap: ManagerCap, ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            manager_cap
        };

        transfer::share_object(registry);
    }

    public fun earn_exp_mut(registry: &Registry, nft_mut: &mut Tails) {
        mover_nft::nft_exp_up(&registry.manager_cap, nft_mut, 1_000);
    }

    public fun earn_exp(registry: &Registry, nft: Tails): Tails {
        mover_nft::nft_exp_up(&registry.manager_cap, &mut nft, 1_000);
        nft
    }

    public fun level_up(registry: &Registry, nft: Tails): Tails {
        mover_nft::level_up(&registry.manager_cap, &mut nft);
        nft
    }
}
