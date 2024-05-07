--|| INSTALATIION MANUAL || --
-- https://studio-players.gitbook.io/

--------------------------------------------------------------------------------------------------------------------------------

Config = {

    Framework = 'qb-core',  -- Don't touch this. Change it only if you have renamed qb
    Inventory = 'qb',       -- Set it to inv that you use qb (PS,LJ,QB), ox (Ox Inventory), codem (CodeM-Inventory)
    Debug = false,          -- It start up debug mode which will print into console if the player passes through conditions (It must be all small true/false)
    Notifications = true,   -- This disable/enable notifications like 'You've paid xx$' etc.
    Experimental = 0,       -- This enables experimental feature that should improve performance. It's not tested properly! (Use it only if SA-Money-v2 has heavy impact on your server)
    -- Levels of experimental boost - 0 - Off, 1 - Medium boost, 2 - High boost (Recommended), 3 - Ultra boost
    -- Levels 1 & 3 might glitch on very slow servers
    ItemCash = 'cash',      -- Name of your item what are you using
    RefreshTime = 100,      -- This change how fast your inventory will be refreshed after buy. (100 = 100ms +-).
    -- Change this only if you have slow server or slow inventory system. LJ, QB Inventories work with 100ms, qs-inventory needs more around +200

    ------

    ItemProp = true, --This enables/disables making a prop on floor
    ItemPropName = 'prop_cash_crate_01', --'prop_cash_pile_02',

    ------------------------
    -- Overweight system
    ------------------------
    -- This function will take care of your inventory weight, so if player has full inventory, this prevent to dissapear money. 
    -- Disable this if your inventory doesn't have exports("GetTotalWeight", GetTotalWeight)
    -- Disable if you are using (core-inventory, ox_inventory, codem_inventory and qs-inventory)
    Overweight = true,              -- true = enabled (this prevent to dissapear money)
    MaxInventoryWeight = 120000,    -- You find that in your qb-inventory > config.lua

    ------
    AutoRefresh = 1000, -- 1000ms = 1s (It's not exactly 1s). Sets how quickly money are refreshed | Lower number = worse optimization
    VersionCheck = true, -- Here is an option to disable the print of versions in the console.
}

--------------------------------------------------------------------------------------------------------------------------------

--This function add more currencies to work as item.
--Has got impact on performance VV !! To work this you have to create a new currency in QB-Core and also you have to edit player.lua by our manual
--More in our documentation >> https://studio-players.gitbook.io/
Another = { 
    Enabled = false, -- This enable function.
    Currencies = {
        [1] = {
            currency = 'blackmoney',
            item = 'black',
            prop = 'prop_cash_pile_02',
            --chance = 1.0, -- 0.7 = 70% chance to success / 30% to call a cops (DOESN'T WORK FOR NOW)
        },
        --[[ [2] = {
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
