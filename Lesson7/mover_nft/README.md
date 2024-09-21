# Package

0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589

# TransferPolicy

0x9d7f0ec42b5b1b790c893f2679c4edc1efe1d5f20ca63cf23c2460b0042d74d8

# Pool

0xbc583ae6c5a185ae1d74e7f979f0f57b3b579abc54b6d1141bf4f1889d98ec10

<!--
royalty: 0xee94872c0fcf932879f8930ad1278eeea4691addfdbabef102e77fd1c54a5f32
display: 0x3ca76d3381e5942031f340f13c7850cb91232a7edf0d29e9eb9ffc71c932699e
publisher: 0x423220a776633a10a301f2b9224c75a156ddd4e52f66b04a3a62a8b8e7de98d0
managerCap: 0x8a357290ced4b6e35451dbed568d16a499437934c5e1947fd7f637d68b5cff18
-->

# new_manager_cap

```
sui client ptb \
--assign manager_cap @0x8a357290ced4b6e35451dbed568d16a499437934c5e1947fd7f637d68b5cff18 \
--move-call 0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589::mover_nft::new_manager_cap manager_cap \
--gas-budget 100000000
```

```
sui client ptb \
--assign kiosk @0x90df9555659e8d1fe6a57e8c1f1c67a2a093b0ba3ae3de23da2a46d3d3b4b599 \
--assign kiosk_cap @0x4854d1d173f8b13d7449e6081159a543d3dfaa3f466f7c80a0b1f73ac561de00 \
--assign tails @0xc43ba72aba8c53be3285efb99a14e579167186d2e4b5e9a653d3ca6dcfc9df6e \
--move-call 0x2::kiosk::borrow_mut"<0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589::mover_nft::Tails>" kiosk kiosk_cap tails --assign result \
--assign manager_cap @0x8a357290ced4b6e35451dbed568d16a499437934c5e1947fd7f637d68b5cff18 \
--move-call 0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589::mover_nft::nft_exp_up manager_cap result 1000 \
--gas-budget 100000000
```
