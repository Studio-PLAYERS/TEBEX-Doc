Config = {
    Language = 'en',        -- Here you can change language. Translations are in folder locale
    Framework = 'qb-core',  -- qb-core/esx | Don't touch this. Change it only if you have renamed qb or you use ESX
    Debug = false,          -- Command for me to debug script. It print to console passes trough conditions. true/false
    Rights = 'admin',       -- Here you can set a rights for this command
    CharKill = "ck",        -- Name of command which will remove your character from database (Through ID Player/Citizen ID)  ------ (ck)

    -----------------------------------------------------------------

    Wipe = 'wipe', -- Removes all players 
    WipeRights = 'god', -- Rights for wipe command
    WipeSecureWord = 'NeverGonnaGiveYouUp', -- This word you have to use to confirm wipe /wipe NeverGonnaGiveYouUp

    -----------------------------------------------------------------

    -- This message shows up to players that was on server and they were kicked out due wipe
    WipeMessage = 'Server is currently wiping all of your hard gained stuff :Wink:. See ya after blackout.' ,

    -----------------------------------------------------------------
    VersionCheck = true,
}

Delete = {
    --------------------------------------
    --      QB-Core Database Tables     --
    --------------------------------------
    
    'players',                -- Remove Player from DB
    'playerskins',            -- Remove Player skins from DB
    'player_vehicles',        -- Remove Player vehicles from DB
    'player_outfits',         -- Remove Player outfits from DB
    'player_contacts',        -- Remove Player contacts from DB
    'player_houses',          -- Remove Player houses from DB
    'player_mails',           -- Remove Player mails from DB 
    'apartments',             -- Remove Player apartments from DB
    'bank_accounts',          -- Remove Player bank accounts from DB
    'bank_statements',        -- Remove Player bank statements from DB



    ----------------------------------
    --      ESX Database Tables     --
    ----------------------------------
    
    --[[ 'addon_account_data',
    'banking',
    'billing',
    'datastore_data',
    'owned_vehicles',
    'rented_vehicles',
    'society_moneywash',
    'users',
    'user_licenses',  ]]
    

    
    --To add own remove just follow format (Removes thanks to CitizenID if isn't CID in the table it wouldn't remove anything)
    --'name_of_the_DB'
}


--THIS FEATURE IS UNDER DEVELOPMENT
--[[ Item = { 
    enabled = true, --This option disables/enables players to do CK with the item with the authorization of the admin.
    Radius = 5.0, --Radius how far can people do a CK

    ----------------------------------------------------------------------------------------------------------------------
    ItemCreation = true, --This option disable the fuse. Disable it only if you are getting errors in console. (Older QB-Core)
    name = 'black_bag',
    label = 'Black Bag',
    weight = 0,
    type = 'item',
    image = 'blackbag.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'Just a black bag, maybe for body? or rubbish :)',
    ----------------------------------------------------------------------------------------------------------------------
}
 ]]