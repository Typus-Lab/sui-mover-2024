module lesson::main {
    use std::string::String;
    use std::type_name::{Self, TypeName};

    use sui::dynamic_field;
    use sui::dynamic_object_field;
    use sui::random::Random;
    use sui::table;
    use sui::package::Publisher;
    use sui::types;

    use lesson::linked_object_table::{Self, LinkedObjectTable};

    const KDynamicField: vector<u8> = b"dynamic_field";
    const KDynamicObjectField: vector<u8> = b"dynamic_object_field";
    const KLoremIpsum: vector<u8> = b"lorem_ipsum";

    public struct MAIN has drop {}

    public struct Registry has key, store {
        id: UID,
    }

    public struct Exercise has key, store {
        id: UID,
    }

    fun init(otw: MAIN, ctx: &mut TxContext) {
        sui::package::claim_and_keep(otw, ctx);
        transfer::share_object(Registry {
            id: object::new(ctx),
        });
        transfer::share_object(Exercise {
            id: object::new(ctx),
        });
    }

    public struct DynamicFieldData has store {
        data: String,
    }
    entry fun create_dynamic_field(
        registry: &mut Registry,
    ) {
        dynamic_field::add(
            &mut registry.id,
            KDynamicField.to_string(),
            DynamicFieldData {
                data: b"this data is stored with dynamic field".to_string(),
            },
        );
    }

    public struct DynamicObjectFieldData has key, store {
        id: UID,
        data: String,
    }
    entry fun create_dynamic_object_field(
        registry: &mut Registry,
        ctx: &mut TxContext,
    ) {
        dynamic_object_field::add(
            &mut registry.id,
            KDynamicObjectField.to_string(),
            DynamicObjectFieldData {
                id: object::new(ctx),
                data: b"this data is stored with dynamic object field".to_string(),
            },
        );
    }

    public struct LoremIpsum has key, store {
        id: UID,
        magic: String,
    }

    public struct MintLoremIpsumProof has store {
        user: address,
    }

    entry fun create_mint_lorem_ipsum_proof_table(
        registry: &mut Registry,
        ctx: &mut TxContext,
    ) {
        dynamic_object_field::add(
            &mut registry.id,
            b"mint_lorem_ipsum_proof_table".to_string(),
            table::new<address, MintLoremIpsumProof>(ctx),
        );
    }

    entry fun mint_lorem_ipsum(
        _: &Publisher,
        registry: &mut Registry,
        random: &Random,
        ctx: &mut TxContext,
    ) {
        let mint_lorem_ipsum_proof_table = dynamic_object_field::borrow_mut(
            &mut registry.id,
            b"mint_lorem_ipsum_proof_table".to_string(),
        );
        assert!(!table::contains(mint_lorem_ipsum_proof_table, ctx.sender()), 0);
        table::add(mint_lorem_ipsum_proof_table, ctx.sender(), MintLoremIpsumProof { user: ctx.sender() });

        let mut generator = random.new_generator(ctx);
        let number = generator.generate_u64();
        let mut magic = b"https://reurl.cc/VM7oxb?number=".to_string();
        magic.append(number.to_string());
        transfer::transfer(
            LoremIpsum {
                id: object::new(ctx),
                magic,
            },
            ctx.sender(),
        );
    }

    entry fun stake_lorem_ipsum_with_dynamic_field(
        registry: &mut Registry,
        lorem_ipsum: LoremIpsum,
        ctx: &TxContext,
    ) {
        let mut key  = KLoremIpsum.to_string();
        key.append(b"_0x".to_string());
        key.append(ctx.sender().to_string());
        dynamic_field::add(
            &mut registry.id,
            key,
            lorem_ipsum
        );
    }

    entry fun unstake_lorem_ipsum_with_dynamic_field(
        registry: &mut Registry,
        ctx: &TxContext,
    ) {
        let mut key  = KLoremIpsum.to_string();
        key.append(b"_0x".to_string());
        key.append(ctx.sender().to_string());
        let lorem_ipsum: LoremIpsum = dynamic_field::remove(
            &mut registry.id,
            key,
        );
        transfer::transfer(lorem_ipsum, ctx.sender());
    }

    entry fun stake_lorem_ipsum_with_dynamic_object_field(
        registry: &mut Registry,
        lorem_ipsum: LoremIpsum,
        ctx: &TxContext,
    ) {
        let mut key  = KLoremIpsum.to_string();
        key.append(b"_0x".to_string());
        key.append(ctx.sender().to_string());
        dynamic_object_field::add(
            &mut registry.id,
            key,
            lorem_ipsum
        );
    }

    entry fun unstake_lorem_ipsum_with_dynamic_object_field(
        registry: &mut Registry,
        ctx: &TxContext,
    ) {
        let mut key  = KLoremIpsum.to_string();
        key.append(b"_0x".to_string());
        key.append(ctx.sender().to_string());
        let lorem_ipsum: LoremIpsum = dynamic_object_field::remove(
            &mut registry.id,
            key,
        );
        transfer::transfer(lorem_ipsum, ctx.sender());
    }

    public struct TestDynamicFieldGasFee has key, store {
        id: UID,
    }
    entry fun test_dynamic_field_gas_fee(
        mut count: u64,
        ctx: &mut TxContext,
    ) {
        let mut t = TestDynamicFieldGasFee {
            id: object::new(ctx),
        };
        while (count > 0) {
            dynamic_field::add(&mut t.id, count, count);
            count = count - 1;
        };
        transfer::share_object(t);
    }
    entry fun test_dynamic_field_gas_fee_2(
        t: &mut TestDynamicFieldGasFee,
        mut count: u64,
    ) {
        while (count > 0) {
            let value = dynamic_field::borrow_mut<u64, u64>(&mut t.id, count);
            *value = *value + 1;
            count = count - 1;
        };
    }

    public struct TestVectorGasFee has key, store {
        id: UID,
        data: vector<u64>,
    }
    entry fun test_vector_gas_fee(
        mut count: u64,
        ctx: &mut TxContext,
    ) {
        let mut t = TestVectorGasFee {
            id: object::new(ctx),
            data: vector[],
        };
        while (count > 0) {
            t.data.push_back(count);
            count = count - 1;
        };
        transfer::share_object(t);
    }
    entry fun test_vector_gas_fee_2(
        t: &mut TestVectorGasFee,
        mut count: u64,
    ) {
        while (count > 0) {
            *&mut t.data[count - 1] = t.data[count - 1] + 1;
            count = count - 1;
        };
    }

    public struct AccessCap has store {
        otw: TypeName,
    }

    public fun gain_access_capability<OTW: drop>(otw: &OTW): AccessCap {
        // authority check?
        assert!(types::is_one_time_witness(otw), 0);
        AccessCap {
            otw: type_name::get<OTW>(),
        }
    }

    public fun public_mint_lorem_ipsum(
        access_cap: &AccessCap,
        registry: &mut Registry,
        ctx: &mut TxContext,
    ): LoremIpsum {
        let mint_lorem_ipsum_proof_table = dynamic_object_field::borrow_mut(
            &mut registry.id,
            b"mint_lorem_ipsum_proof_table".to_string(),
        );
        assert!(!table::contains(mint_lorem_ipsum_proof_table, ctx.sender()), 0);
        table::add(mint_lorem_ipsum_proof_table, ctx.sender(), MintLoremIpsumProof { user: ctx.sender() });

        let mut magic = b"https://reurl.cc/VM7oxb?otw=".to_string();
        magic.append(access_cap.otw.into_string().to_string());

        LoremIpsum {
            id: object::new(ctx),
            magic,
        }
    }

    public fun public_stake_lorem_ipsum(
        _: &AccessCap,
        exercise: &mut Exercise,
        lorem_ipsum: LoremIpsum,
        ctx: &TxContext,
    ) {
        let mut key  = KLoremIpsum.to_string();
        key.append(b"_0x".to_string());
        key.append(ctx.sender().to_string());
        dynamic_object_field::add(
            &mut exercise.id,
            key,
            lorem_ipsum
        );
    }

    public struct Chimera has key, store {
        id: UID,
        a: u8,
        b: u16,
        c: u32,
        d: u64,
        e: bool,
        f: vector<u8>,
    }

    entry fun create_chimera_linked_object_table(
        registry: &mut Registry,
        ctx: &mut TxContext,
    ) {
        dynamic_object_field::add(
            &mut registry.id,
            b"chimera_linked_object_table".to_string(),
            linked_object_table::new<address, Chimera>(ctx),
        );
    }

    entry fun create_chimera(
        registry: &mut Registry,
        random: &Random,
        ctx: &mut TxContext,
    ) {
        let chimera_linked_object_table = dynamic_object_field::borrow_mut(
            &mut registry.id,
            b"chimera_linked_object_table".to_string(),
        );
        let mut generator = random.new_generator(ctx);
        let chimera = Chimera {
            id: object::new(ctx),
            a: generator.generate_u8(),
            b: generator.generate_u16(),
            c: generator.generate_u32(),
            d: generator.generate_u64(),
            e: generator.generate_bool(),
            f: generator.generate_bytes(10),
        };
        linked_object_table::push_back(chimera_linked_object_table, object::id_address(&chimera), chimera);
    }

    public(package) fun get_chimera_bcs(
        registry: &Registry,
    ): vector<vector<u8>> {
        let mut result = vector[];
        let chimera_linked_object_table: &LinkedObjectTable<address, Chimera> = dynamic_object_field::borrow(
            &registry.id,
            b"chimera_linked_object_table".to_string(),
        );
        let mut first = chimera_linked_object_table.front();
        while (first.is_some()) {
            let key = *first.borrow();
            let chimera = chimera_linked_object_table.borrow(key);
            result.push_back(std::bcs::to_bytes(chimera));
            first = chimera_linked_object_table.next(key);
        };

        result
    }
}