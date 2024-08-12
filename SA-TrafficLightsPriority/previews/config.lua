Config = {
    Debug = false,            -- It start up debug mode which will print into console if the player passes through conditions (It must be all small true/false)
    VersionCheck = true,     -- Here is an option to disable the print of versions in the console.

    Everbody = false,        -- This makes it comfortable for everybody. If is anybody in car and stop in front of traffic lights.
    Mode = 'stop',           -- Set to (stop/drive)
    -- 'stop' = green turns out only if player stop the vehicle. 
    -- 'drive' = green turns out when he drive

    AllowedCarsState = true, -- This disable allowed cars | false = disabled.
    Siren = true,            -- true = ON, false = OFF
    -- true = Siren ON > Cars can drive through traffic on green with siren on, otherwise traffic will behave the same.
    -- false = Siren OFF > Selected cars can drive through traffic on with/without siren on.

    Settings = {
        Duration = 5,        -- 5 = 5 Seconds
        Range = 60.0,        -- It has to be number with dot > examples: 10.0 ; 20.0
    },

    ---------------------

    AllowedCars = {
        'police',
        'police2',
        'police3',
        'police4',
        'policeb',
        'policet',
        'FBI',
        'fbi2',
        'riot',
        'riot2',
        'cognoscenti2',
        'firetruk',
        'ambulance',
        'apoliceu',
        'apoliceu2',
        'apoliceu6',
        'apoliceu7',
        'apoliceu9',
        'apoliceu10',
        'apoliceu13',
        'apoliceu14',
        'apoliceu15',
        'apoliceub',
        'centurionlspd',
    },

    --------------------------------------

    Props = {
        'prop_traffic_01a',
        'prop_traffic_01b',
        'prop_traffic_01d',
        'prop_traffic_02a',
        'prop_traffic_02b',
        'prop_traffic_03a',
        'prop_traffic_03b',
    },

}