--|| INSTALATIION MANUAL || --
-- https://studio-players.gitbook.io/

--------------------------------------------------------------------------------------------------------------------------------

Config = {

    --------------
    --  TOOLS   --
    --------------

    Debug = false,          -- It start up debug mode which will print into console if the player passes through conditions (It must be all small true/false)
    Notifications = true,   -- This disable/enable notifications like 'You've paid xx$' etc.
    Experimental = 2,       -- This enables experimental feature that should improve performance. It's not tested properly! (Use it only if SA-Money-v2 has heavy impact on your server)
    -- Levels of experimental boost - 0 - Off, 1 - Medium boost, 2 - High boost (Recommended), 3 - Ultra boost
    -- Levels 1 & 3 might glitch on very slow servers

    --------------------------
    --  INVENTORY SETTINGS  --
    --------------------------

    Framework = 'qb-core',      -- Don't touch this. Change it only if you have renamed qb
    Inventory = 'qb-inventory',        -- Set it to name of your inventory resource you use, for example qb-inventory (PS,LJ,QB), ox_inventory, codem-inventory
    -- For custom inventory use 'custom' and change functions in functions.lua
    -----

    oldInv = false,              -- If you use new inventory system, which doesn't use functions, but exports instead set it to false.
    -- For example: core_inventory, old qb-inventory, lj-inventory etc.
    -----

    RefreshTime = 100,      -- This change how fast your inventory will be refreshed after buy. (100 = 100ms +-).
    -- Change this only if you have slow server or slow inventory system. LJ, QB Inventories work with 100ms, qs-inventory needs more around +200
    ItemProp = true, --This enables/disables making a prop on floor

    ---------------------------
    --  OVERWEIGHT SYSTEM    --
    ---------------------------
    -- This function will take care of your inventory weight, so if player has full inventory, this prevent to dissapear money. 
    -- Disable this if your inventory doesn't have exports("GetTotalWeight", GetTotalWeight)
    -- Disable if you are using (core_inventory, ox_inventory, codem_inventory and qs-inventory)
    Overweight = true,              -- true = enabled (this prevent to dissapear money)
    MaxInventoryWeight = 120000,    -- You find that in your qb-inventory > config.lua

    ------
    AutoRefresh = 1000, -- 1000ms = 1s (It's not exactly 1s). Sets how quickly money are refreshed | Lower number = worse optimization
    VersionCheck = true, -- Here is an option to disable the print of versions in the console.
}

--------------------------------------------------------------------------------------------------------------------------------

------------------
--  CURRENCIES  --
------------------

--This function add more currencies to work as item.
--To make more currencies follow our documentation >> https://studio-players.gitbook.io/

Money = { 
    Currencies = {
        [1] = {
            currency = 'cash',
            item = 'cash',
            prop = 'prop_cash_pile_02',
        },
        --[[ [2] = {
            currency = 'blackmoney',
            item = 'black',
            prop = 'prop_cash_pile_02',
            --chance = 1.0, -- 0.7 = 70% chance to success / 30% to call a cops (DOESN'T WORK FOR NOW)
        },
        [3] = {
            currency = 'printedbills',
            item = 'printedbills',
            prop = 'prop_cash_pile_02',
            --chance = 1.0, -- 0.7 = 70% chance to success / 30% to call a cops (DOESN'T WORK FOR NOW)
        }, ]]
    }
}

--------------------------------------------------------------------------------------------------------------------------------
--This is just a fuse if you for example update QB-Core and forgot to add a cash item. It create that item after script starts.
--If you forgot to add an item and item doesn't exists, the inventory automatically removes it from inventory after joining. 
--This fuse will ensure that this never happens.

--Please still add item into QB-core/shared/items.lua!! If the script fails or something happens and this script doesn't start
--and the player joins he loses his money if you don't have that item also in qb-core/shared/items.lua
Item = {
    enabled = true, --This option disable this fuse. Use it only if you are getting errors in console. (Older QB-Core)
    name = 'cash',
    label = 'cash',
    weight = 0,
    type = 'item',
    image = 'cash.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'Just a cash bruh.'
}
--QB-Core/shared/items.lua has a priority
--------------------------------------------------------------------------------------------------------------------------------
