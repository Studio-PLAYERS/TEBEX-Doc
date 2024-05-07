--[[        TEMPLATES         ]]--

--BASIC TEMPLATES
--You can combine most of things. If you find a bug contact us on Discord.
--[[ 
    [1] = {
        ["enabled"] = true,
        ['coords'] = vector4(-57.0654, -1097.0039, 26.4224, 205.0292),
        ['sizeY'] = 3, -- Size of box
        ['sizeX'] = 2, --Size of box
        --['sizeZ'] = 5, --SizeZ is optionable don't have to be there. Default is 2
        ['message'] = '[E] to trigger Test', --Text what you want
        ['side'] = 'left', --Left/Right
        ['Trigger'] = 'Test', --Custom name what you set up in events.lua, if you don't need just leave it blank.
    },
    [2] = {
        ["enabled"] = true,
        ['coords'] = vector4(-69.6077, -1088.9026, 26.5622, 40.0142),
        ['sizeY'] = 5, -- Size of box
        ['sizeX'] = 5, -- Size of box
        ['sizeZ'] = 5, -- Size of box
        ['message'] = 'to trigger Test2', --Text what you want
        ['side'] = 'left', --Left/Right
        ['Trigger'] = 'Test2', --Custom name what you set up in events.lua, if you don't need just leave it blank.
    }, 
]]

Shared.BoxEs = {
    [1] = {
        ["enabled"] = true,
        ['coords'] = vector4(-57.0654, -1097.0039, 26.4224, 205.0292),
        ['sizeY'] = 3, -- Size of box
        ['sizeX'] = 2, --Size of box
        --SizeZ don't have to be there. Default is 2
        ['message'] = 'to trigger Test', --Text what you want
        ['side'] = 'left', --Left/Right
        ['Trigger'] = 'Test', --Custom name what you set up in events.lua, if you don't need just leave it blank.
    },
}