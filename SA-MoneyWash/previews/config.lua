Config = {}

Config = {
    Debug = false,
    Language = 'en',
    VersionCheck = true,
    
    InventoryCompatibility = true, 
    -- Set it to false if you get an error (calling export 'GetInventoryData') in the server console.
    
    -- Controls
    Target = true,      -- Enables/Disables target on peds
    Box = true,         -- Enables/Disables box or polyzone on peds
    PressKey = 38,      -- 38 = E | Key which trigger box. All keys are registere here https://docs.fivem.net/docs/game-references/controls/#controls

    -- Settings
    Cooldown = 60,      -- How often players can make a new tickets.
    Ticket = 'ticket',  -- Name of the item
    Loop = 60,          -- How often will be ticketed sent to database, this prevent loss of data when server crashes
    VAT = false,        -- false - Disabled / true - Enabled | Use SA-VAT system
    VATID = 'Dealer'    -- ID in VAT system
}

MarkedBills = {
    item = 'markedbills',    -- Currency/Items that you use for illegal activities
    default = true,          -- Use default qb-core's markedbills, that has worth in description
    -- False = Will use amount of item to set worth
    -- True = Will use worth in the description of the item
}

Locations = {
    [1] = {
        -- Ped settings
        coords = vector4(111.06, -236.7, 55.24, 195.6),
        ped = 'a_m_m_mexlabor_01',
        anim = 'idle_b',
        dict = 'amb@world_human_smoking@male@male_b@idle_a',

        -- Money settings 
        slots = 4,                  -- Inventory settings
        processamount = 5,          -- How much $ of the worth will be process in one cycle | (Doesn't work for default markedbills, it automatically remove 1)
        time = 40,                  -- How much time in seconds it takes to proccess processamount
        worth = 55,                 -- How much % do you get from worth    
    },
    [2] = {
        -- Ped settings
        coords = vector4(-1658.3, -1097.58, 13.14, 225.79),
        ped = 'a_m_m_mexlabor_01',
        anim = 'idle_b',
        dict = 'amb@world_human_smoking@male@male_b@idle_a',
        
        -- Money settings 
        slots = 1,                  -- Inventory settings
        processamount = 10,         -- How much $ of the worth will be process in one cycle | (Doesn't work for default markedbills, it automatically remove 1)
        time = 80,                  -- How much time in seconds it takes to proccess processamount
        worth = 55,                 -- How much % do you get from worth    
    },
    -- 
    [3] = {
        -- Ped settings
        coords = vector4(430.29, -1559.58, 32.82, 289.34),
        ped = 'a_m_m_mexlabor_01',
        anim = 'idle_b',
        dict = 'amb@world_human_smoking@male@male_b@idle_a',
        
        -- Money settings 
        slots = 1,                  -- Inventory settings
        processamount = 15,         -- How much $ of the worth will be process in one cycle | (Doesn't work for default markedbills, it automatically remove 1)
        time = 20,                  -- How much time in seconds it takes to proccess processamount
        worth = 55,                 -- How much % do you get from worth    
    },
}

LaunderyItems = {
    ["metalscrap"] = {
        wait = 120, -- It's in seconds
        reward = 3,
    },
    ["copper"] = {
        wait = 500, -- It's in seconds
        reward = 2,
    },
    ["iron"] = {
        wait = 500, -- It's in seconds
        reward = 2,
    },
    ["aluminum"] = {
        wait = 500, -- It's in seconds
        reward = 2,
    },
    ["steel"] = {
        wait = 500, -- It's in seconds
        reward = 2,
    },
    ["glass"] = {
        wait = 500, -- It's in seconds
        reward = 2,
    },
    ["lockpick"] = {
        wait = 10000, -- It's in seconds
        reward = 150,
    },
    ["screwdriverset"] = {
        wait = 10000, -- It's in seconds
        reward = 300,
    },
    ["electronickit"] = {
        wait = 10000, -- It's in seconds
        reward = 300,
    },
    ["radioscanner"] = {
        wait = 10000, -- It's in seconds
        reward = 850,
    },
    ["gatecrack"] = {
        wait = 10000, -- It's in seconds
        reward = 600,
    },
    ["trojan_usb"] = {
        wait = 10000, -- It's in seconds
        reward = 1000,
    },
    ["weed_brick"] = {
        wait = 5000, -- It's in seconds
        reward = 250,
    },
    ["phone"] = {
        wait = 2000, -- It's in seconds
        reward = 750,
    },
    ["radio"] = {
        wait = 2000, -- It's in seconds
        reward = 180,
    },
    ["handcuffs"] = {
        wait = 2000, -- It's in seconds
        reward = 400,
    },
    ["10kgoldchain"] = {
        wait = 10000, -- It's in seconds
        reward = 3000,
    },
}