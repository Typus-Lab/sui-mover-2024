package=0x4133cacd2cdd298b4474f2bb2af0c7da8e415d126473c1dc9b6277de3c0f7587
publisher=0xf91d231658149382891995fac15e2bda4343ce9d1e4fe04c5a7f79454c022da1
registry=0x868568ea2164160010c2162421b4149cc60800a757c17829c8705a5e7f5110df
lorem_ipsum=

# sui client call --package $package --module main --function create_dynamic_field --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function create_dynamic_object_field --args $registry --gas-budget 100000000

# sui client call --package $package --module main --function create_mint_lorem_ipsum_proof_table --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function mint_lorem_ipsum --args $publisher $registry 0x8 --gas-budget 100000000
# sui client call --package $package --module main --function stake_lorem_ipsum_with_dynamic_field --args $registry $lorem_ipsum --gas-budget 100000000
# sui client call --package $package --module main --function unstake_lorem_ipsum_with_dynamic_field --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function stake_lorem_ipsum_with_dynamic_object_field --args $registry $lorem_ipsum --gas-budget 100000000
# sui client call --package $package --module main --function unstake_lorem_ipsum_with_dynamic_object_field --args $registry --gas-budget 100000000

# sui client call --package $package --module main --function create_chimera_linked_object_table --args $registry --gas-budget 100000000
# sui client call --package $package --module main --function create_chimera --args $registry 0x8 --gas-budget 100000000
