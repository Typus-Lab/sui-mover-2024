package=0x95a59510bbc3bca1575939c510483013fc614fdaefb5793b361bd3bd4479270d
registry=0x99f6f8fb47010aebb2e09885cdf80d483e36e7a14809e3de21b373588e362d42
exercise=0x511edb2a3177c9bb9b2637661f319cf490f9f46642675ef87299528516762ffa
publisher=0xec9eabc0b6574c680b5e0fb7e9f7d5d937058d2344db6db9bd637bebfb7106cb
lorem_ipsum=
test_dynamic_field_gas_fee=
test_vector_gas_fee=

# sui client call --package $package --module main --function create_dynamic_field --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function create_dynamic_object_field --args $registry --gas-budget 100000000

# sui client call --package $package --module main --function create_mint_lorem_ipsum_proof_table --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function mint_lorem_ipsum --args $publisher $registry 0x8 --gas-budget 100000000
# sui client call --package $package --module main --function stake_lorem_ipsum_with_dynamic_field --args $registry $lorem_ipsum --gas-budget 100000000
# sui client call --package $package --module main --function unstake_lorem_ipsum_with_dynamic_field --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function stake_lorem_ipsum_with_dynamic_object_field --args $registry $lorem_ipsum --gas-budget 100000000
# sui client call --package $package --module main --function unstake_lorem_ipsum_with_dynamic_object_field --args $registry --gas-budget 100000000

# sui client call --package $package --module main --function test_dynamic_field_gas_fee --args 1000 --gas-budget 10000000000
# sui client call --package $package --module main --function test_vector_gas_fee --args 10000 --gas-budget 10000000000
# sui client call --package $package --module main --function test_dynamic_field_gas_fee_2 --args $test_dynamic_field_gas_fee 1000 --gas-budget 10000000000
# sui client call --package $package --module main --function test_vector_gas_fee_2 --args $test_vector_gas_fee 1000 --gas-budget 100000000

# sui client call --package $package --module main --function create_chimera_linked_object_table --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function create_chimera --args $registry 0x8 --gas-budget 100000000
