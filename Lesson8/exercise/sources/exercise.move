module exercise::exercise {
    use sui::dynamic_field;

    use lesson::main::{Self, Exercise, Registry, LoremIpsum};

    const KAccessCap: vector<u8> = b"access_cap";

    public struct EXERCISE has drop {}

    public struct KeyBox has key, store {
        id: UID,
    }

    fun init(otw: EXERCISE, ctx: &mut TxContext) {
        // TODO: gain and keep AccessCap in KeyBox
    }

    entry fun mint_lorem_ipsum(
        key_box: &KeyBox,
        registry: &mut Registry,
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
        key_box: &KeyBox,
        exercise: &mut Exercise,
        lorem_ipsum: LoremIpsum,
        ctx: &TxContext,
    ) {
        // TODO: borrow AccessCap from KeyBox
        main::public_stake_lorem_ipsum(
            access_cap,
            exercise,
            lorem_ipsum,
            ctx,
        );
    }
}