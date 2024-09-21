module mover_nft::utils {
    use std::vector;
    use sui::vec_map::{Self, VecMap};

    friend mover_nft::mover_nft;

    const E_INVALID_LENGTH: u64 = 0;

    public(friend) fun from_vec_to_map<K: copy + drop, V: drop>(
        keys: vector<K>,
        values: vector<V>,
    ): VecMap<K, V> {
        assert!(vector::length(&keys) == vector::length(&values), E_INVALID_LENGTH);

        let i = 0;
        let n = vector::length(&keys);
        let map = vec_map::empty<K, V>();

        while (i < n) {
            let key = vector::pop_back(&mut keys);
            let value = vector::pop_back(&mut values);

            vec_map::insert(
                &mut map,
                key,
                value,
            );

            i = i + 1;
        };

        map
    }
}