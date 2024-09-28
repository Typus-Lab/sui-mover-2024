package=0x0d0b8de6834045f24acae61d09c2e655aede6a6d926c361bdabcc7b34d057870
publisher=0x0a7660c17671e8aacffc2b4863a5b3d11e10b305681bd17cabf5967bc04bfb68
registry=0xeb66e96624adbb278053709fe8821c4277947c157e4f487b4d69b1c8f8c859bf
lorem_ipsum=
test_dynamic_field_gas_fee=
test_vector_gas_fee=
exercise=0x7f28be992790f3d8666ac04d10095549e89f127e3cad95b88035b825586f67e7

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
sui client call --package $package --module main --function create_chimera --args $registry 0x8 --gas-budget 100000000
