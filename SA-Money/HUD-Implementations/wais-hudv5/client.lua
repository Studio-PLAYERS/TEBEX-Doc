wFramework = nil

if Config.Framework.Framework == "esx" then
    if Config.Framework.NewCore then
        wFramework = exports[Config.Framework.ResourceName]:getSharedObject()
    else
        CreateThread(function()
            while wFramework == nil do
                TriggerEvent(Config.Framework.SharedEvent, function(obj) wFramework = obj end)
                Wait(10)
            end
        end)
    end
elseif Config.Framework.Framework == "qbcore" then
    wFramework = exports[Config.Framework.ResourceName]:GetCoreObject()
end

local p = PlayerId()
local PlayerData = {}
local carhudtype, speedtype, maptype, statusbartype = nil, nil, nil, nil
local nuiloaded, pauseMenuActive, radarHideForTrigger, hudHideForTrigger, playerLoaded, blackList, blackListControl, inCar, inRadioTalking, cinematicMode = false, false, false, false, false, false, false, false, false, false
local hunger, thirst, stamina, stress = 0, 0, 0, 0
local job2, gang = {}, {}
local lightState
seatbeltOn = false
beltIgnore = false
local deadState = false
local updateOldType = true


local screen = {
	x = 0,
	y = 0
}

-----------------------------------------------------------------------------------------
-- EVENT'S --
-----------------------------------------------------------------------------------------

RegisterNetEvent('wais:pload:v5', function()
    PlayerDataLoaded()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData, job2, gang = {}, {}, {}
	resetNewJobs()
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    PlayerData, job2, gang = {}, {}, {}
	resetNewJobs()
end)

RegisterNetEvent('wais:updateCurrentPlayers', function(players, maxplayers)
    SendNUIMessage({
        type = "UPDATE_CURRENT_PLAYERS",
        players = players,
        maxplayers = maxplayers
    })
end)

RegisterNetEvent('esx:setAccountMoney', function()
	Wait(500)
    PlayerData = Config.Framework.Framework == "esx" and wFramework.GetPlayerData() or wFramework.Functions.GetPlayerData()
	
	if not Config.MoneySettings.qs_inventory then
		SendNUIMessage({
			type = "UPDATE_CASH",
			cash = getPlayerCash(),
			firstTime = false,
		})
	end

    SendNUIMessage({
        type = "UPDATE_BANK",
        bank = getBankMoney(),
        firstTime = false,
    })
end)

RegisterNetEvent('wais:checkInventory', function(items)
    local moneyCount = 0
    for k,v in pairs(items) do
        if v.name == Config.MoneySettings.moneyItemName then
            moneyCount = moneyCount + v.count
        end
    end

    SendNUIMessage({
        type = "UPDATE_CASH",
        cash = moneyCount,
        firstTime = false,
    })
end)

if not Config.MoneySettings.ox_inventory and Config.Framework.Framework ~= "qbcore" then
    RegisterNetEvent('esx:addInventoryItem', function(item, count, showNotification)
        Wait(500)
		updateESXItems()
    end)

    RegisterNetEvent('esx:removeInventoryItem', function(item, count, showNotification)
        Wait(500)
		updateESXItems()
    end)
end

RegisterNetEvent("QBCore:Player:SetPlayerData", function(val)
    PlayerData = val
	if Config.MoneySettings.moneyItem then
		if not Config.MoneySettings.qs_inventory then
			for k, v in pairs(PlayerData.items) do
				if v.name == Config.MoneySettings.moneyItemName then
					SendNUIMessage({
						type = "UPDATE_CASH",
						cash = v.amount,
						firstTime = false,
					})
					break
				end
			end
		else
			local inventory = exports['qs-inventory']:getUserInventory()
			for k,v in pairs(inventory) do
				if v.name == Config.MoneySettings.moneyItemName then
					SendNUIMessage({
						type = "UPDATE_CASH",
						cash = v.amount,
						firstTime = false,
					})
					break
				end
			end
		end
	else
		SendNUIMessage({
            type = "UPDATE_CASH",
            cash = PlayerData.money['cash'],
			firstTime = false,
        })
	end

	SendNUIMessage({
        type = "UPDATE_BANK",
        bank = PlayerData.money['bank'],
        firstTime = false,
    })
end)

local function updateMoney()
	local PlayerData = wFramework.Functions.GetPlayerData()
	
	SendNUIMessage({
		type = "UPDATE_CASH",
		cash = PlayerData.money['cash'],
		firstTime = false,
	})
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	CreateThread(function()
		while true do
			Wait(1000)
			updateMoney()
		end
	end)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	CreateThread(function()
		while true do
			Wait(1000)
			updateMoney()
		end
	end)
end)

RegisterNetEvent('wais:updateOldMoney', function(PlayerData)
	SendNUIMessage({
		type = "UPDATE_CASH",
		cash = PlayerData.money['cash'],
		firstTime = false,
	})
end)

RegisterNetEvent('esx:setJob', function()
	Wait(1000)
    PlayerData = Config.Framework.Framework == "esx" and wFramework.GetPlayerData() or wFramework.Functions.GetPlayerData()
	SendNUIMessage({
		type  = "UPDATE_JOB",
		label = ('%s - %s'):format(PlayerData.job.label, PlayerData.job.grade_label)
	})
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
	Wait(500)
	SendNUIMessage({
		type  = "UPDATE_JOB",
        label = ('%s - %s'):format(PlayerData.job.label, PlayerData.job.grade.name)
	})
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
	gang = gang
	SendNUIMessage({
		type = "UPDATE_GANG",
		gang = gang.name == "none" and nil or ('%s - %s'):format(gang.name, gang.grade.name)
	})
end)

RegisterNetEvent('wais:set:job2', function(job)
	job2 = job
	SendNUIMessage({
		type = "UPDATE_JOB2",
		job = type(job2) == "table" and ('%s - %s'):format(job2.name, job2.label) or job2
	})
end)

RegisterNetEvent('wais:set:gang', function(gang)
	gang = gang
	SendNUIMessage({
		type = "UPDATE_GANG",
		gang = gang.name == "none" and nil or ('%s - %s'):format(gang.name, gang.label)
	})
end)

RegisterNetEvent('esx_status:onTick', function(status)
	for k,v in pairs(status) do
		if v.name == "hunger" then
			hunger = v.percent
		end
		if v.name == "thirst" then
			thirst = v.percent
		end
		if v.name == "stress" then
			stress = v.percent
		end
	end
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
	hunger = newHunger
	thirst = newThirst
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

RegisterNetEvent('wais:change:deadstate', function(state)
	deadState = state
end)

RegisterNetEvent('pma-voice:setTalkingMode', function(ranges)
	SendNUIMessage({
		type  = "UPDATE_MIC_DISTANCE",
		distance = Config.VoiceSettings.pma[ranges].meter
	})
end)

RegisterNetEvent('pma-voice:radioActive', function(talking)
	inRadioTalking = talking
end)

RegisterNetEvent('SaltyChat_TalkStateChanged', function(status)
    SendNUIMessage({
		type  = 'UPDATE_MIC',
		state = status,
		radio = inRadioTalking
	})
end)

RegisterNetEvent('SaltyChat_RadioTrafficStateChanged', function(x, isSending)
	inRadioTalking = isSending
end)

RegisterNetEvent('SaltyChat_VoiceRangeChanged', function(range)
	SendNUIMessage({
		type  = "UPDATE_MIC_DISTANCE",
		distance = Config.VoiceSettings.saltychat.ranges[tostring(range)].meter,
	})
end)

RegisterNetEvent('wais:addNotification', function(typee, title, text, time)
	local typee = typee == "primary" and "info" or typee or "info"
	local title = title or "Notification"
	local text  = text or "Enter text"
	local time  = time or 5000

	SendNUIMessage({
		type = "ADD_NOTIFICATION",
		ntype = typee,
		title = title,
		text = text,
		time = time,
	})
end)

RegisterNetEvent('wais:hideHud', function(boolean)
	if type(boolean) == "string" then
		if boolean == "true" then
			boolean = true
		else
			boolean = false
		end
	end

	hudHideForTrigger = boolean
	SendNUIMessage({
		type = "HIDE_BODY",
		state = boolean,
	})
end)

RegisterNetEvent('wais:hideRadar', function(boolean)
	if type(boolean) == "string" then
		if boolean == "true" then
			boolean = true
		else
			boolean = false
		end
	end

	radarHideForTrigger = boolean
end)

AddEventHandler('onClientResourceStart', function(resName)
    if (GetCurrentResourceName() == resName) then
        while true do
            if nuiloaded and wFramework ~= nil then
                PlayerDataLoaded()
                break
            end
            Wait(1)
        end
    end
end)

-----------------------------------------------------------------------------------------
-- NUI CALLBACK'S --
-----------------------------------------------------------------------------------------

RegisterNUICallback('nuiloaded', function(data, cb)
    nuiloaded = true
	carhudtype = data.carhudtype
	speedtype = data.speedtype
	maptype = data.maptype
	statusbartype = data.statusbartype

    SendNUIMessage({
        type = "DEFAULT_VERIABLES",
        symbol = Config.MoneySettings.formatSymbol,
        prefix = Config.MoneySettings.formatPrefix,
        clock = Config.ClockType,
        useStress = Config.StressSystem,
        showOnlyInCar = Config.ShowMapOnlyInTheCar,
		exitcustomization = Config.Keybind.editormode.key,
		disablebelt = Config.DisableBeltSystem,
		disableeditor = Config.DissableEditorMode,
    })

	SendNUIMessage({
		type = "SEND_KEYBINDS",
		keybinds = Config.Keybinds
	})

	SendNUIMessage({
		type  = "UPDATE_MIC_DISTANCE",
		distance = Config.VoiceSettings.saltychat.use and Config.VoiceSettings.saltychat.ranges[Config.VoiceSettings.saltychat.default].meter or Config.VoiceSettings.pma[1].meter
	})

    cb('ok')
end)

RegisterNUICallback('setcarhud', function(data, cb)
	carhudtype = data.hud
	cb('ok')
end)

RegisterNUICallback('setmaptype', function(data, cb)
	maptype = data.map
	buildmap()
	cb('ok')
end)

RegisterNUICallback('setspeedtype', function(data, cb)
	speedtype = data.speed
	cb('ok')
end)

RegisterNUICallback('setstatusbartype', function(data, cb)
	statusbartype = data.statusbar
	buildmap()
	cb('ok')
end)

RegisterNUICallback('cinematicmode', function(data, cb)
	cinematicMode = data.state
	cb('ok')
end)

RegisterNUICallback('closeSettings', function(data, cb)
	SendNUIMessage({
		type = "SETTINGS_MENU",
		state = false
	})
	SetNuiFocus(false, false)
	cb('ok')
end)

RegisterNUICallback('closeEditorMode', function(data, cb)
	SendNUIMessage({
		type = "CUSTOMIZATION_MENU",
		state = false
	})
	SetNuiFocus(false, false)
	cb('ok')
end)

-----------------------------------------------------------------------------------------
-- FUNCTION'S --
-----------------------------------------------------------------------------------------

function PlayerDataLoaded()
    local pr = promise:new()
    p = PlayerId()
	screen.x, screen.y = GetActiveScreenResolution()
    PlayerData = Config.Framework.Framework == "esx" and wFramework.GetPlayerData() or wFramework.Functions.GetPlayerData()

    while PlayerData.job == nil do
        PlayerData = Config.Framework.Framework == "esx" and wFramework.GetPlayerData() or wFramework.Functions.GetPlayerData()
        Wait(500)
    end

	while not nuiloaded do
		Wait(750)
	end

	if Config.Framework.Framework == "qbcore" then
		thirst = PlayerData.metadata["thirst"] ~= nil and PlayerData.metadata["thirst"] or 0
		hunger = PlayerData.metadata["hunger"] ~= nil and PlayerData.metadata["hunger"] or 0
		stress = PlayerData.metadata["stress"] ~= nil and PlayerData.metadata["stress"] or 0
		if PlayerData.gang ~= nil then
			gang = PlayerData.gang
			SendNUIMessage({
				type = "UPDATE_GANG",
				gang = gang.name == "none" and nil or ('%s - %s'):format(gang.name, gang.grade.name)
			})
		end
	end

    SendNUIMessage({
        type = "PLAYER_LOADED",
        playerId = GetPlayerServerId(PlayerId()),
    })

    SendNUIMessage({
        type = "UPDATE_CASH",
        cash = getPlayerCash(),
        firstTime = true,
    })
    
    SendNUIMessage({
        type = "UPDATE_BANK",
        bank = getBankMoney(),
        firstTime = true,
    })

    SendNUIMessage({
		type  = "UPDATE_JOB",
		label = Config.Framework.Framework == "esx" and ('%s - %s'):format(PlayerData.job.label, PlayerData.job.grade_label) or ('%s - %s'):format(PlayerData.job.label, PlayerData.job.grade.name)
	})

    TriggerServerEvent('wais:requestCurrentPlayers')
    playerLoaded = true
	buildmap()

    pr:resolve(true)
    return Citizen.Await(pr)
end

function getPlayerCash()
    local pr = promise:new()

    if Config.MoneySettings.moneyItem then
		if Config.Framework.Framework == "esx" then
			for k, v in pairs(PlayerData.inventory) do
				if v.name == Config.MoneySettings.moneyItemName then
					pr:resolve(Config.MoneySettings.qs_inventory and v.amount or v.count)
					break
				end
			end
			pr:resolve(0)
		elseif Config.Framework.Framework == "qbcore" then
			for k, v in pairs(PlayerData.items) do
				if v.name == Config.MoneySettings.moneyItemName then
					pr:resolve(v.amount)
					break
				end
			end
			pr:resolve(0)
		end
    else
        if Config.Framework.Framework == "esx" then
			if Config.MoneySettings.oldMoney then
				TriggerServerEvent('wais:getOldMoney')
			else
				for k,v in pairs(PlayerData.accounts) do
					if v.name == 'money' then
						pr:resolve(v.money)
						break
					end
				end
			end
			pr:resolve(0)
        elseif Config.Framework.Framework == "qbcore" then
            pr:resolve(PlayerData.money["cash"])
        end
	end

    return Citizen.Await(pr)
end

function getBankMoney()
    local pr = promise:new()
	if Config.Framework.Framework == "esx" then
		for k,v in pairs(PlayerData.accounts) do
			if v.name == 'bank' then
				pr:resolve(v.money)
				break
			end
		end
	elseif Config.Framework.Framework == "qbcore" then
		pr:resolve(PlayerData.money["bank"])
	end
    return Citizen.Await(pr)
end

function updateESXItems()
	PlayerData = Config.Framework.Framework == "esx" and wFramework.GetPlayerData() or wFramework.Functions.GetPlayerData()
	for k, v in pairs(PlayerData.inventory) do
		if v.name == Config.MoneySettings.moneyItemName then
			SendNUIMessage({
				type = "UPDATE_CASH",
				cash = Config.MoneySettings.qs_inventory and v.amount or v.count,
				firstTime = false,
			})
			break
		end
	end
end

function hasBlackListVehicle(model, blacklistType)
	local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPedId()))
    if class == 8 or class == 13 or class == 14 then 
		beltIgnore = true
	end
	for k, v in pairs(Config.BlackListVehicle) do
		if GetHashKey(k) == model then
			blackList = v[blacklistType]
			beltIgnore = v.belt
			break
		end
	end
	blackListControl = true
	return false
end

function SettingsMenu()
	if Config.DisableSettingsMenu then return end
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "SETTINGS_MENU",
		state = true
	})
end

function Customization() 
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "CUSTOMIZATION_MENU",
		state = true
	})
end

function buildmap()
	if maptype == "squared" then
		RequestStreamedTextureDict("squaremap", false)
		if not HasStreamedTextureDictLoaded("squaremap") then
			Wait(150)
		end
		SetMinimapClipType(0)
		AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
		AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")

		if screen.y == 1080 and screen.x == 2560 then 
			SetMinimapComponentPosition("minimap", "L", "B", -0.175, -0.007, 0.1638, 0.183)
			SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0, 0.0, 0.128, 0.20)
			SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.175, 0.025, 0.270, 0.300)
		elseif screen.y == 1440 and screen.x == 3440 then
			SetMinimapComponentPosition("minimap", "L", "B", -0.175, -0.007, 0.1638, 0.183)
			SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0, 0.0, 0.128, 0.20)
			SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.175, 0.025, 0.270, 0.300)
		else
			SetMinimapComponentPosition("minimap", "L", "B", 0.0, -0.007, 0.1638, 0.183)
			SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0, 0.0, 0.128, 0.20)
			SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.0, statusbartype == "old" and 0.0 or 0.025, 0.262, 0.300)
		end

		SetBlipAlpha(GetNorthRadarBlip(), 0)
		SetRadarBigmapEnabled(true, false)
		SetMinimapClipType(0)
		Wait(50)
		SetRadarBigmapEnabled(false, false)
		Wait(1200)
	elseif maptype == "rounded" then

		local x = -0.025
		local y = 0.015 -- Old value -0.015
		local w = 0.16
		local h = 0.25

		RequestStreamedTextureDict("circlemap", false)
		if not HasStreamedTextureDictLoaded("circlemap") then
			Wait(150)
		end

		SetMinimapClipType(1)
		AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

		if screen.y == 1080 and screen.x == 2560 then 
			SetMinimapComponentPosition('minimap', 'L', 'B', -0.160, 0.025, w, h)
			SetMinimapComponentPosition('minimap_mask', 'L', 'B', x + 0.17, y + 0.09, 0.072, 0.162)
			SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.175, 0.025, 0.18, 0.22)
		elseif screen.y == 1440 and screen.x == 3440 then
			SetMinimapComponentPosition('minimap', 'L', 'B', -0.160, 0.025, w, h)
			SetMinimapComponentPosition('minimap_mask', 'L', 'B', x + 0.17, y + 0.09, 0.072, 0.162)
			SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.175, 0.025, 0.18, 0.22)
		else
			SetMinimapComponentPosition('minimap', 'L', 'B', 0.0, y, w, h)
			SetMinimapComponentPosition('minimap_mask', 'L', 'B', x + 0.17, y + 0.09, 0.072, 0.162)
			SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.010, 0.00, 0.18, 0.22)
		end

		SetBlipAlpha(GetNorthRadarBlip(), 0)
		SetMinimapClipType(1)
		SetRadarBigmapEnabled(true, false)
		Wait(50)
		SetRadarBigmapEnabled(false, false)
	end

	Wait(2500)

	if IsBigmapActive() then
		SetRadarBigmapEnabled(false, false)
		SetBigmapActive(false, false)
	end
end

function resetNewJobs()
	SendNUIMessage({
		type = "UPDATE_JOB2",
		job = nil
	})

	SendNUIMessage({
		type = "UPDATE_GANG",
		gang = nil
	})
end

-----------------------------------------------------------------------------------------
-- COMMAND'S --
-----------------------------------------------------------------------------------------

if Config.KeyMaaping then
	RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', 'b')
	RegisterCommand('seatbelt', ToggleSeatbelt)

	RegisterKeyMapping('settingseenu', 'Open Settings Menu', 'keyboard', 'g')
	RegisterCommand('settingseenu', SettingsMenu)
end

-----------------------------------------------------------------------------------------
-- THREAD'S --
-----------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local vhc = IsPedInAnyVehicle(ped, false)
		local maxHealth = GetEntityMaxHealth(ped)
		local heal = maxHealth == 175 and (GetEntityHealth(ped) + 25) - 100 or GetEntityHealth(ped) - 100
		local armour = GetPedArmour(ped)
        local sleep = Config.RefreshTimes.hud
        local pos = GetEntityCoords(ped)

		if playerLoaded then
			if not IsPauseMenuActive() then
				local weapon = GetSelectedPedWeapon(ped)
				local ammo = GetAmmoInPedWeapon(ped, weapon)
				local _, ammoclip = GetAmmoInClip(ped, weapon)
				local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
				local markedBlips = GetFirstBlipInfoId(8)
				local remaining = markedBlips ~= 0 and math.floor((#(GetBlipCoords(markedBlips) - pos) * 0.621371)) or 0

				SetPedConfigFlag(ped, 35, false)

				if vhc then
					sleep = Config.RefreshTimes.carhud
					local door = false
					local veh = GetVehiclePedIsIn(ped, false)
					model = GetEntityModel(veh)
					if not blackList and not blackListControl then
						hasBlackListVehicle(GetEntityModel(veh), "carhud")
					end
					if not blackList then
						local bodydamage
						local enginedamage
						local oil
						local rpm = 0
						local gear
						local maxgear
						local speed = GetEntitySpeed(veh)
						local fuel = Config.GetVehicleFuelLevel(veh)
						local _,lightson,highbeams = GetVehicleLightsState(veh)
						if GetVehicleDoorAngleRatio(veh, 0) ~= 0 or GetVehicleDoorAngleRatio(veh, 1) ~= 0 or GetVehicleDoorAngleRatio(veh, 2) ~= 0 or GetVehicleDoorAngleRatio(veh, 3) ~= 0 or GetVehicleDoorAngleRatio(veh, 4) ~= 0 or GetVehicleDoorAngleRatio(veh, 5) ~= 0 then
							door = true
						end
						if lightson == 1 or highbeams == 1 then
							lightState = true
						else
							lightState = false
						end

						if carhudtype == "new" or carhudtype == "old" then
							bodydamage = math.floor(GetVehicleBodyHealth(veh))
							enginedamage = math.floor(GetVehicleEngineHealth(veh))
							oil = math.floor(GetVehiclePetrolTankHealth(veh))

							rpm = GetVehicleCurrentRpm(veh)
							gear = GetVehicleCurrentGear(veh)
							maxgear = GetVehicleHighGear(veh)

						end

						SendNUIMessage({
							type = "VEHICLE_STATUS",
							speed = speed,
							fuel = math.floor(fuel) > 100 and 100 or math.floor(fuel),
							rpm = math.floor(rpm * 9),
							gear = gear,
							maxgear = maxgear,
							
							door = door,
							seatbelt = seatbeltOn,
							light = lightState,
							engine = GetIsVehicleEngineRunning(veh),
							handbrake = GetVehicleHandbrake(veh),

							engineDamage = enginedamage,
							bodyDamage = bodydamage,
							oilValue = oil,
						})

						if not inCar then
							inCar = true
							TriggerEvent('EnteredVehicle')
							SendNUIMessage({
								type = "PLAYER_INCAR"
							})
						end

					end
				else
					sleep = Config.RefreshTimes.hud
					model = nil
					blackList = false
					beltIgnore = false
					if inCar then
						lastFrameVehiclespeed2 = 0
						lastFrameVehiclespeed = 0
						newvehicleBodyHealth = 0
						currentvehicleBodyHealth = 0
						frameBodyChange = 0
						seatbeltOn = false
						inCar = false
						blackListControl = false
						SendNUIMessage({
							type = "PLAYER_OUTCAR"
						})
					end
				end

				if Config.ShowMapOnlyInTheCar then
					if inCar then
						SendNUIMessage({
							type = "UPDATE_LOCATION",
							streetTitle = GetStreetNameFromHashKey(street1),
							streetName = GetStreetNameFromHashKey(street2),
							remaining = IsWaypointActive(),
							remainingDistance = remaining
						})
					end
				else
					SendNUIMessage({
						type = "UPDATE_LOCATION",
						streetTitle = GetStreetNameFromHashKey(street1),
						streetName = GetStreetNameFromHashKey(street2),
						remaining = IsWaypointActive(),
						remainingDistance = remaining
					})
				end
				
				if not IsEntityInWater(ped) then
					stamina = 100 - GetPlayerSprintStaminaRemaining(p)
				end

				if IsEntityInWater(ped) then
					stamina = GetPlayerUnderwaterTimeRemaining(p) * 10
				end

				SendNUIMessage({
					type 	= "UPDATE_STATUS",
					health  = deadState and 0 or heal > 100 and 100 or heal < 0 and 0 or heal,
					armour  = armour,
					hunger  = math.floor(hunger) > 100 and 100 or math.floor(hunger) < 0 and 0 or math.floor(hunger),
					thirst  = math.floor(thirst) > 100 and 100 or math.floor(thirst) < 0 and 0 or math.floor(thirst),
                    stamina = math.floor(stamina) > 100 and 100 or math.floor(stamina) < 0 and 0 or math.floor(stamina),
                    inwater = IsEntityInWater(ped),
					stress = stress
				})

				SendNUIMessage({
					type = "UPDATE_WEAPON",
					label = Config.Weapons[weapon] ~= nil and Config.Weapons[weapon].label or weapon,
                    image = Config.Weapons[weapon] ~= nil and Config.Weapons[weapon].image or weapon,
					ammo = ammoclip,
					clip = ammo - ammoclip,
				})

				if not pauseMenuActive then
					pauseMenuActive = true
					if not hudHideForTrigger then
						SendNUIMessage({
							type = "PAUSEMENU_STATE",
							state = false
						})
					end
				end
			else
				if not hudHideForTrigger then
					pauseMenuActive = false
					SendNUIMessage({
						type = "PAUSEMENU_STATE",
						state = true
					})
				end
			end

			if not Config.VoiceSettings.saltychat.use then
				SendNUIMessage({
					type  = 'UPDATE_MIC',
					state = NetworkIsPlayerTalking(p),
					radio = inRadioTalking
				})
			end

		end

		Wait(sleep)
	end
end)

CreateThread(function()
	while true do
		if not Config.KeyMaaping then
			if IsControlJustPressed(0, Config.Keybind.belt) then
				ToggleSeatbelt()
			end

			if IsControlJustPressed(0, Config.Keybind.settings_menu) then
				SettingsMenu()
			end
		end

		if IsControlJustPressed(0, Config.Keybind.editormode.modifier) and not Config.DissableEditorMode then
			Customization()
		end

		if inCar and seatbeltOn then
			DisableControlAction(0, 75, true)
		end
		
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)

		if cinematicMode then
			DisplayRadar(false)
		else
			if not radarHideForTrigger then
				if Config.ShowMapOnlyInTheCar then
					if inCar then
						if Config.PostalMap then
							SetRadarZoom(1100)
						end
						DisplayRadar(true)
					else
						DisplayRadar(false)
					end
				else
					if Config.PostalMap then
						SetRadarZoom(1100)
					end
					DisplayRadar(true)
				end
			else
				DisplayRadar(false)
			end
		end

		Wait(1)
	end
end)

if not Config.DisableBeltSystem then
	CreateThread(function()
		while true do
			local sleep = 7500
			if (inCar) and not seatbeltOn and not beltIgnore then
				TriggerEvent('InteractSound_CL:PlayOnOne', 'beltalarm', 0.25)
			end
			Wait(sleep)
		end
	end)
end

CreateThread(function()
	while true do
		if playerLoaded then
			x,_ = GetActiveScreenResolution()
			if screen.x < x then
				screen.x = x
				buildmap()
			end
		end
		Wait(5000)
	end
end)