# Package

0xde4b05571fc9788431781cb771db1d68d4c14d50edf1c6f3da9dd2e98c022278

# Registry

0xc1de09bdb99bc633b38ffe98897112d5cee2ec89bd7cccabeddfe146206a8396

# Create Registry

sui client ptb \
--assign manager_cap @0x4d06314aaf3af94e2d53bcde7b4f99aa2fb1adfbb51378b74306530463582784 \
--move-call 0xde4b05571fc9788431781cb771db1d68d4c14d50edf1c6f3da9dd2e98c022278::exercise::create_registry manager_cap \
--gas-budget 100000000

# Exercise 1

`earn_exp` to get 1000 exp

<!-- sui client ptb \
--assign registry @0xc1de09bdb99bc633b38ffe98897112d5cee2ec89bd7cccabeddfe146206a8396 \
--assign kiosk @0x90df9555659e8d1fe6a57e8c1f1c67a2a093b0ba3ae3de23da2a46d3d3b4b599 \
--assign kiosk_cap @0x4854d1d173f8b13d7449e6081159a543d3dfaa3f466f7c80a0b1f73ac561de00 \
--assign tails @0xc43ba72aba8c53be3285efb99a14e579167186d2e4b5e9a653d3ca6dcfc9df6e \
--move-call 0x2::kiosk::borrow_val"<0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589::mover_nft::Tails>" kiosk kiosk_cap tails --assign result \
--move-call 0xde4b05571fc9788431781cb771db1d68d4c14d50edf1c6f3da9dd2e98c022278::exercise::earn_exp registry result.0 --assign return_nft \
--move-call 0x2::kiosk::return_val"<0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589::mover_nft::Tails>" kiosk return_nft result.1 \
--gas-budget 100000000 -->

# Exercise 2

`level_up` to level 2

<!-- sui client ptb \
--assign registry @0xc1de09bdb99bc633b38ffe98897112d5cee2ec89bd7cccabeddfe146206a8396 \
--assign kiosk @0x90df9555659e8d1fe6a57e8c1f1c67a2a093b0ba3ae3de23da2a46d3d3b4b599 \
--assign kiosk_cap @0x4854d1d173f8b13d7449e6081159a543d3dfaa3f466f7c80a0b1f73ac561de00 \
--assign tails @0xc43ba72aba8c53be3285efb99a14e579167186d2e4b5e9a653d3ca6dcfc9df6e \
--move-call 0x2::kiosk::borrow_val"<0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589::mover_nft::Tails>" kiosk kiosk_cap tails --assign result \
--move-call 0xde4b05571fc9788431781cb771db1d68d4c14d50edf1c6f3da9dd2e98c022278::exercise::level_up registry result.0 --assign return_nft \
--move-call 0x2::kiosk::return_val"<0x27321bc52766f3ed3f809524ca0149bdbbf01f7f18bdccc261eab2dc5fa14589::mover_nft::Tails>" kiosk return_nft result.1 \
--gas-budget 100000000 -->
