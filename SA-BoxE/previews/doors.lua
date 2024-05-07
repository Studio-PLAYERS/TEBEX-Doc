--[[        TEMPLATES         ]]--

--BASIC TEMPLATES
--You can combine most of things. If you find a bug contact us on Discord.
--TEMPLATE FOR DOORS
--[[ 
    [1] = {
        ["enabled"] = true,
        ['coords'] = vector4(-60.6077, -1078.9026, 26.5622, 40.0142),
        ['sizeY'] = 5, -- Size of box
        ['sizeX'] = 5, -- Size of box
        --['sizeZ'] = 5, --SizeZ is optionable don't have to be there. Default is 2
        ['side'] = 'left', --Left/Right

        ['unlock'] = '[E] Unlock', --Text to unlock
        --['lock'] = '[E] Lock', --Text to lock is optionable
        ['isDoor'] = true, --It starts qb-doorlock mode
        ['OneTime'] = true, --This is for one use. It automatically locks door after 2s by default or by Timer what you set below
        ['Timer'] = 1000, --This lock your door automatically after 1000 = 1s +-
        ['DoorID'] = '', --Here should be name of doors
    },
    [2] = {
        ["enabled"] = true,
        ['coords'] = vector4(-38.4101, -1108.5775, 26.4688, 143.6674),
        ['sizeY'] = 3, -- Size of box
        ['sizeX'] = 2, -- Size of box
        ['unlock'] = 'Control of gate', --Text to unlock and lock
        ['side'] = 'left', --Left/Right
        ['isDoor'] = true, --It starts qb-doorlock mode
        ['DoorID'] = 'PDM-Entrance', --Here should be name of doors
    },
}
]]

Shared.Doors = {
    --Put here code
    [1] = {
        ["enabled"] = true,
        ['coords'] = vector4(-60.61, -1093.79, 26.63, 251.62),
        ['sizeY'] = 3, -- Size of box
        ['sizeX'] = 2, -- Size of box
        ['side'] = 'left', --Left/Right
        ['unlock'] = 'Unlock', --Text to unlock
        ['isDoor'] = true, --It starts qb-doorlock mode
        ['OneTime'] = false, --This is for one use. It automatically locks door after 2s by default or by Timer what you set below
        ['Timer'] = 1000, --This lock your door automatically after 1000 = 1s +-
        ['DoorID'] = 'PDM-PDM_1', --Here should be name of doors
    },
}