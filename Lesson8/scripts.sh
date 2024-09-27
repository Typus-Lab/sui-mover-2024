package=
publisher=
registry=
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
# sui client call --package $package --module main --function test_vector_gas_fee --args 1000 --gas-budget 100000000
# sui client call --package $package --module main --function test_dynamic_field_gas_fee_2 --args $test_dynamic_field_gas_fee 1000 --gas-budget 10000000000
# sui client call --package $package --module main --function test_vector_gas_fee_2 --args $test_vector_gas_fee 1000 --gas-budget 100000000

# sui client call --package $package --module main --function create_chimera_linked_object_table --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function create_chimera --args $registry 0x8 --gas-budget 100000000
