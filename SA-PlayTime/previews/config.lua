Config = {}

Config.Framework = 'esx'  -- qb-core/esx | Don't touch this. Change it only if you have renamed qb or you use ESX
Config.Debug = false --Command for me to debug script. It print to console passes trough conditions. true/false

Config.Language = 'en' --Language: 'en' or 'cs'
Config.ThreadIncrease = 1 --This value mean how often is playtime increased 1 = 1min, default 5 = 5min, that means every 5 minutes will be added 5 minutes to playtime

Config.Command = 'playtime' -- Command which will display playtime

-- ---------------
-- VVV PLAYERS VVV
-- ---------------
-- Usage: '/playtime char' It shows playtime of the player's character
-- Usage: '/playtime acc' It shows playtime of the player's account

Config.Permissions = {
    'admin',
    'god',
}
-- -------------
-- VVV ADMIN VVV
-- -------------
-- Usage: '/playtime char ID' for example '/playtime char 1' will display playtime of Player with ID 1 on his character
-- Usage: '/playtime acc ID' for example '/playtime acc 1' will display playtime of Player with ID 1 on his account

Config.VersionCheck = true