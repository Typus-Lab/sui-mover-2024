module exercise::exercise {
    use sui::dynamic_field;
    use sui::table;

    use lesson::main::{Self, Exercise, Registry};

    const KAccessCap: vector<u8> = b"access_cap";

    public struct EXERCISE has drop {}

    public struct KeyBox has key, store {
        id: UID,
    }

    fun init(otw: EXERCISE, ctx: &mut TxContext) {
        // TODO: gain and keep AccessCap in KeyBox
    }

    entry fun mint_lorem_ipsum(
        key_box: KeyBox,
        registry: &Registry,
        ctx: &mut TxContext,
    ) {
        // TODO: borrow AccessCap from KeyBox
        let lorem_ipsum = main::public_mint_lorem_ipsum(
            access_cap,
            registry,
            ctx,
        );
        // TODO: transfer LoremIpsum to sender
    }

    entry fun stake_lorem_ipsum(
        key_box: KeyBox,
        exercise: &mut Exercise,
        ctx: &mut TxContext,
    ) {
        // TODO: borrow AccessCap from KeyBox
        let lorem_ipsum = main::public_stake_lorem_ipsum(
            access_cap,
            exercise,
            lorem_ipsum,
            ctx,
        );
    }
}