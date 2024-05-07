-- { 17movement.net } --
-- QBCore Handlers:
TriggerEvent("__cfx_export_qb-core_GetCoreObject", function(getCore)
    Core = getCore()
    Config.Framework = "QBCore"
end)

-- ESX Handlers:
TriggerEvent("__cfx_export_es_extended_getSharedObject", function(getCore)
    Core = getCore()
    Config.Framework = "ESX"
end)

local esxLoaded = false
CreateThread(function()
    Citizen.Wait(2500) -- Wait Until Core Load

    if Core == nil then
        TriggerEvent("esx:getSharedObject", function(obj)
            Core = obj
            Config.Framework = "ESX"
        end)
    end

    if Config.Framework == "QBCore" then
        local MyPlayer = Core.Functions.GetPlayerData()
        while MyPlayer == nil or MyPlayer.metadata == nil do
            MyPlayer = Core.Functions.GetPlayerData()
            Citizen.Wait(100)
        end

        RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
            MyStatus.DisplayHud = false
        end)

        MyStatus.DisplayHud = true
        MyStatus.Hunger = MyPlayer.metadata.hunger / 100
        MyStatus.Thirst = MyPlayer.metadata.thirst / 100
        MyStatus.Stress = MyPlayer.metadata.stress / 100
        MyStatus.Cash = MyPlayer.money['cash']
        MyStatus.Bank = MyPlayer.money['bank']
        if not MyPlayer.job.label then MyPlayer.job.label = MyPlayer.job.name end
        if not MyPlayer.job.grade.label then MyPlayer.job.grade.label = MyPlayer.job.grade.name end
        MyStatus.Job = MyPlayer.job.label
        MyStatus.Grade = MyPlayer.job.grade.label

        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
            MyPlayer.job = job
            if not MyPlayer.job.label then MyPlayer.job.label = MyPlayer.job.name end
            if not MyPlayer.job.grade.label then MyPlayer.job.grade.label = MyPlayer.job.grade.name end
            MyStatus.Job = MyPlayer.job.label
            MyStatus.Grade = MyPlayer.job.grade.label
        end)

        RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
            MyStatus.Hunger = newHunger / 100
            MyStatus.Thirst = newThirst / 100
        end)

        RegisterNetEvent('seatbelt:client:ToggleSeatbelt', function() -- Triggered in smallresources
            MyStatus.BeltsState = not MyStatus.BeltsState
        end)

        -- Stress system
        if Config.EnableStress then
            RegisterNetEvent('hud:client:UpdateStress', function(newStress)
                MyStatus.Stress = newStress / 100
            end)
        end

        RegisterNetEvent('hud:client:OnMoneyChange', function(type, amount, isMinus)
            MyPlayer = Core.Functions.GetPlayerData()

            if not NuiLoaded then
                return print("Waiting for NUI load. THIS IS NOT ERROR! Report it ONLY if you still see this message!")
            end

            local newCash, newBank = MyPlayer.money['cash'], MyPlayer.money['bank']
            local cashIncome = newCash - MyStatus.Cash
            if cashIncome ~= 0 then
                local formatted = FormatMoney(cashIncome, true)

                SendNUIMessage({
                    action = "CashTransaction",
                    value = formatted
                })
            end

            local bankIncome = newBank - MyStatus.Bank
            if bankIncome ~= 0 then
                local formatted = FormatMoney(bankIncome, true)

                SendNUIMessage({
                    action = "BankTransaction",
                    value = formatted
                })
            end

            MyStatus.Cash = newCash
            MyStatus.Bank = newBank
        end)

        RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
            MyPlayer = Core.Functions.GetPlayerData()
            MyStatus.Cash = MyPlayer.money['cash']
            MyStatus.Bank = MyPlayer.money['bank']
            MyStatus.DisplayHud = true
        end)
    elseif Config.Framework == "ESX" then
        CreateThread(function()
            while Core.GetPlayerData() == nil do
                Citizen.Wait(1000)
            end
            Citizen.Wait(1500)

            LoadEsx()
        end)

        RegisterNetEvent("esx:onPlayerLogout", function()
            MyStatus.DisplayHud = false
            esxLoaded = false
        end)

        RegisterNetEvent('esx:setJob', function(job)
            MyStatus.Job = job.label
            MyStatus.Grade = job.grade_label
            TriggerServerEvent("17mov_Hud:RequestSocietyMoney")
        end)

        RegisterNetEvent("esx:playerLoaded", function()
            Citizen.Wait(1500)
            LoadEsx()
        end)

        -- https://github.com/qbcore-framework/qb-smallresources/blob/fb448e62b4a47aec8cf72cabb87991bf10b08df7/client/seatbelt.lua#L234
        -- RegisterCommand('toggleseatbelt', function()
        --     if not IsPedInAnyVehicle(PlayerPedId(), false) or IsPauseMenuActive() then return end
        --     local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPedId()))
        --     if class == 8 or class == 13 or class == 14 then return end
        --     MyStatus.BeltsState = not MyStatus.BeltsState
        -- end, false)
        -- RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', Config.SeatBeltsKey)

        RegisterNetEvent("esx:setAccountMoney")
        AddEventHandler("esx:setAccountMoney", function()
            Citizen.Wait(500) -- Wait until PlayerData refresh
            local PlayerData = Core.GetPlayerData()
            local newCash, newBank, newDirtMoney
            local cashIncome, bankIncome, dirtMoneyIncome
            if not NuiLoaded then
                return print("Waiting for NUI load. THIS IS NOT ERROR! Report it ONLY if you still see this message!")
            end

            for _, account in pairs(PlayerData.accounts) do
                if account.name == "money" then
                    newCash = account.money
                    cashIncome = newCash - MyStatus.Cash
                    if cashIncome ~= 0 then
                        local formatted = FormatMoney(cashIncome, true)

                        SendNUIMessage({
                            action = "CashTransaction",
                            value = formatted
                        })
                    end
                elseif account.name == "bank" then
                    newBank = account.money
                    bankIncome = newBank - MyStatus.Bank
                    if bankIncome ~= 0 then
                        local formatted = FormatMoney(bankIncome, true)

                        SendNUIMessage({
                            action = "BankTransaction",
                            value = formatted
                        })
                    end
                elseif account.name == "black_money" then
                    newDirtMoney = account.money
                    dirtMoneyIncome = newDirtMoney - MyStatus.DirtMoney
                    if dirtMoneyIncome ~= 0 then
                        local formatted = FormatMoney(dirtMoneyIncome, true)

                        SendNUIMessage({
                            action = "DirtMoneyTransaction",
                            value = formatted
                        })
                    end
                end
            end

            MyStatus.Cash = newCash
            MyStatus.Bank = newBank
            MyStatus.DirtMoney = newDirtMoney
        end)

        RegisterNetEvent("17mov_Hud:updateSocietyMoney", function(newMoney)
            if MyStatus.SocietyMoney ~= nil and newMoney ~= nil then
                local income = newMoney - MyStatus.SocietyMoney
                if income ~= 0 then
                    local formatted = FormatMoney(income, true)

                    SendNUIMessage({
                        action = "SocietyMoneyTransaction",
                        value = formatted
                    })
                end
            end

            MyStatus.SocietyMoney = newMoney
        end)
    else
        MyStatus.DisplayHud = true
        print("STANDALONE - You need to configure everything manually")
    end

    MyStatus.VoiceRange = GetConvar('voice_defaultVoiceMode', '2') .. "/" .. Config.MaxVoiceMode

    RegisterNetEvent('pma-voice:setTalkingMode', function(mode)
        MyStatus.VoiceRange = mode .. "/" .. Config.MaxVoiceMode
    end)

    AddEventHandler("SaltyChat_VoiceRangeChanged", function(range, index, availableVoiceRanges)
        MyStatus.VoiceRange = index .. "/" .. Config.MaxVoiceMode
    end)

    RegisterNetEvent('hud:setRadio', function(value)
        UpdateRadio(value)
    end)

    RegisterNetEvent("17mov_HUD:pma-Voice:SetRadioChannel", function(radio)
        UpdateRadio(radio)
    end)

    RegisterNetEvent("SaltyChat_TalkStateChange", function(boolean)
        MyStatus.IsTalking = boolean
    end)

    StartHudThread()
end)

-- Money formatting function
function FormatMoney(amount, isIncome)
    local isMinus = amount < 0
    amount = math.abs(amount)
    local formatted = tostring(amount)
    local k = 0

    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then break end
        Wait(0)
    end

    formatted = "$" .. formatted

    if isMinus then
        formatted = "-" .. formatted
    elseif not isMinus and isIncome then
        formatted = "+" .. formatted
    end

    return formatted
end

-- Getting ServerID
function GetServerId()
    local player = PlayerId()
    return GetPlayerServerId(player)
end

-- Should display speedometer?
function ShouldDisplaySpeedometer(vehicle)
    -- Blacklisting by model
    local model = GetEntityModel(vehicle)

    for i = 1, #Config.BlacklistedVehicleModels, 1 do
        if Config.BlacklistedVehicleModels[i] == model then
            return false
        end
    end

    -- Blacklisting by class
    local vehicleClass = GetVehicleClass(vehicle)

    for i = 1, #Config.BlacklistedVehicleClasses, 1 do
        if Config.BlacklistedVehicleClasses[i] == vehicleClass then
            return false
        end
    end

    return true
end

local function updateMoney()
    local PlayerData = Core.Functions.GetPlayerData()
    local newCash = PlayerData.money['cash']
    local cashIncome = newCash - MyStatus.Cash
    if cashIncome ~= 0 then
        local formatted = FormatMoney(cashIncome, true)

        SendNUIMessage({
            action = "CashTransaction",
            value = formatted
        })
        MyStatus.Cash = newCash
    end
end

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    CreateThread(function()
        Wait(2000)
        while true do
            Wait(1000)
            updateMoney()
        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    CreateThread(function()
        Wait(2000)
        while true do
            Wait(1000)
            updateMoney()
        end
    end)
end)

-- Stress system
if Config.EnableStress then
    local lastNotificationTime = 0

    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)

            if vehicle ~= 0 and DoesEntityExist(vehicle) then
                local speed = GetEntitySpeed(vehicle) * SpeedMultiplier

                if speed > Config.StressingSpeed then
                    TriggerServerEvent('hud:server:GainStress', 1)
                    TriggerEvent("esx_status:add", "stress", math.random(5000, 10000))

                    -- Showing only one nottification per 5 minutes to avoid spam
                    local currentTime = GetGameTimer()
                    if currentTime - lastNotificationTime > 300000 then
                        TriggerEvent('17mov_Hud:ShowNotification', Config.Lang['AddingStress'])
                        lastNotificationTime = currentTime
                    end
                end
            end

            Wait(10000)
        end
    end)

    if Config.AddStressWhileShooting then
        CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local weapon = GetSelectedPedWeapon(ped)
                local timeout = 1000

                if weapon ~= GetHashKey("WEAPON_UNARMED") then
                    if IsPedShooting(ped) then
                        TriggerServerEvent('hud:server:GainStress', 1)
                        TriggerEvent("esx_status:add", "stress", math.random(5000, 10000))

                        -- Showing only one nottification per 5 minutes to avoid spam
                        local currentTime = GetGameTimer()
                        if currentTime - lastNotificationTime > 300000 then
                            TriggerEvent('17mov_Hud:ShowNotification', Config.Lang['AddingStress'])
                            lastNotificationTime = currentTime
                        end
                        Wait(100)
                    end
                    timeout = 0
                end
                Wait(timeout)
            end
        end)
    end

    function GetStressEffect(stressAmount)
        for i = 1, #Config.StressEffects, 1 do
            if stressAmount >= Config.StressEffects[i].Min and stressAmount <= Config.StressEffects[i].Max then
                return Config.StressEffects[i]
            end
        end

        return {
            Timeout = 60000,
            Blur = 1000
        }
    end

    CreateThread(function()
        while true do
            local stress = MyStatus.Stress * 100
            local stressEffect = GetStressEffect(stress)

            if stressEffect.RagdollTime then
                local ped = PlayerPedId()

                if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                    local coords = GetEntityForwardVector(ped)
                    SetPedToRagdollWithFall(ped, stressEffect.RagdollTime, stressEffect.RagdollTime, 1, coords.x,
                        coords.y, coords.z, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                end
            end

            if stress >= Config.MinimumStressForEffects then
                TriggerScreenblurFadeIn(500.0)
                Wait(stressEffect.Blur)
                TriggerScreenblurFadeOut(500.0)
            end

            Wait(stressEffect.Timeout)
        end
    end)
end

function LoadEsx()
    if esxLoaded then return end
    esxLoaded = true
    local PlayerData = Core.GetPlayerData()

    while PlayerData == nil or PlayerData.accounts == nil do
        PlayerData = Core.GetPlayerData()
        Wait(50)
    end

    for _, account in pairs(PlayerData.accounts) do
        if account.name == "money" then
            MyStatus.Cash = account.money
        elseif account.name == "bank" then
            MyStatus.Bank = account.money
        elseif account.name == "black_money" then
            MyStatus.DirtMoney = account.money
        end
    end

    TriggerServerEvent("17mov_Hud:RequestSocietyMoney")

    MyStatus.DisplayHud = true
    MyStatus.Job = PlayerData.job.label
    MyStatus.Grade = PlayerData.job.grade_label

    -- Stress system
    if Config.EnableStress then
        local stressFound = false
        TriggerEvent('esx_status:getStatus', "stress", function()
            stressFound = true
        end)

        if not stressFound then
            print("REGISTERING STRESS STATUS")
            TriggerEvent('esx_status:registerStatus', 'stress', 0, '#CFAD0F', function()
                return false
            end, function(status)
                status.remove(20)
            end)
        end


        RegisterNetEvent('esx_status:onTick', function(data)
            for k, v in pairs(data) do
                if v.name == 'stress' then
                    MyStatus.Stress = v.percent / 100
                end
            end
        end)
    end

    AddEventHandler('esx_status:loaded', function(status)
        Citizen.Wait(1000)
        local hungerFound = false
        TriggerEvent('esx_status:getStatus', "hunger", function()
            hungerFound = true
        end)

        if not hungerFound then
            print("REGISTERING HUNGER STATUS")
            TriggerEvent('esx_status:registerStatus', 'hunger', 0, '#CFAD0F', function()
                return false
            end, function(status)
                status.remove(100)
            end)
        end

        local thirstFound = false
        TriggerEvent('esx_status:getStatus', "thirst", function()
            thirstFound = true
        end)

        if not thirstFound then
            print("REGISTERING THIRST STATUS")
            TriggerEvent('esx_status:registerStatus', 'thirst', 0, '#CFAD0F', function()
                return false
            end, function(status)
                status.remove(100)
            end)
        end
    end)

    RegisterNetEvent('esx_status:onTick', function(data)
        for k, v in pairs(data) do
            if v.name == 'hunger' then
                MyStatus.Hunger = v.percent / 100
            elseif v.name == 'thirst' then
                MyStatus.Thirst = v.percent / 100
            end
        end
    end)
end

-- UpdateBeltsState(
--     state: boolean
-- )
function UpdateBeltsState(state)
    MyStatus.BeltsState = state
end

exports("UpdateBeltsState", UpdateBeltsState)
RegisterNetEvent("17mov_Hud:UpdateBeltsState", UpdateBeltsState)

-- GetBeltsState(
--     cb: function(beltsState)
-- )
function GetBeltsState(cb)
    if cb then
        return cb(MyStatus.BeltsState)
    end

    return MyStatus.BeltsState
end

exports("GetBeltsState", GetBeltsState)
RegisterNetEvent("17mov_Hud:GetBeltsState", GetBeltsState)

-- ToggleDisplay(
--     state: boolean
-- )
function ToggleDisplay(state)
    MyStatus.DisplayHud = state
end

exports("ToggleDisplay", ToggleDisplay)
RegisterNetEvent("17mov_Hud:ToggleDisplay", ToggleDisplay)

-- Notify(
--     text: string (Notification text),
--     type: string (Notify type. Values: ["info", "error", "success"]),
--     title: string (Notify title),
--     time: number (How long notification should be displaying (in ms))
-- )
exports("ShowNotification", Notify)
RegisterNetEvent('17mov_Hud:ShowNotification', Notify)

-- ShowHelpNotification(
--     text: string (text to display)
-- )
exports("ShowHelpNotification", ShowHelpNotification)
RegisterNetEvent('17mov_Hud:ShowHelpNotification', ShowHelpNotification)

exports("ShowHelpNotificationWhile", ShowHelpNotificationWhile)
RegisterNetEvent('17mov_Hud:ShowHelpNotificationWhile', ShowHelpNotificationWhile)

exports("HideHelpNotification", HideHelpNotification)
RegisterNetEvent('17mov_Hud:HideHelpNotification', HideHelpNotification)

-- StartProgress(
--     action: {
--         duration: number (Progress bar time (in ms)),
--         label: string (Progress bar text),
--         useWhileDead: boolean (Can be used while player is dead?)
--         canCancel: boolean (Is can be canceled?),
--         controlDisables: {
--             disableMovement: boolean (Disable movement controls?),
--             disableCarMovement: boolean (Disable car movement controls?),
--             disableMouse: boolean (Disable mouse controls?),
--             disableCombat: boolean (Disable combat controls?),
--         },
--         animation: {
--             animDict: string (Animation dict),
--             anim: string (Animation name),
--             flags: number (Animation flags),
--             task: string (Scenario name),
--         },
--         prop: {
--             model: number (Model hash),
--             bone: string (Bone name),
--             coords: vector3 (Attachment offsets coords),
--             rotation: vector3 (Attachment rotation),
--         },
--         propTwo: {
--             model: number (Model hash),
--             bone: string (Bone name),
--             coords: vector3 (Attachment offsets coords),
--             rotation: vector3 (Attachment rotation),
--         },
--     }
--     onStart: function()
--     onTick: function()
--     onFinish: function(wasCancelled)
-- )
exports("StartProgress", StartProgress)
RegisterNetEvent('17mov_Hud:StartProgress', StartProgress)

-- StopProgress()
exports("StopProgress", StopProgress)
RegisterNetEvent('17mov_Hud:StopProgress', StopProgress)

-- Progress support for QBCore
if Config.Framework == "QBCore" then
    RegisterNetEvent('progressbar:client:ToggleBusyness', function(bool)
        IsDoingAction = bool
    end)

    RegisterNetEvent('progressbar:client:progress', function(action, finish)
        StartProgress(action, nil, nil, finish)
    end)

    RegisterNetEvent('progressbar:client:ProgressWithStartEvent', function(action, start, finish)
        StartProgress(action, start, nil, finish)
    end)

    RegisterNetEvent('progressbar:client:ProgressWithTickEvent', function(action, tick, finish)
        StartProgress(action, nil, tick, finish)
    end)

    RegisterNetEvent('progressbar:client:ProgressWithStartAndTick', function(action, start, tick, finish)
        StartProgress(action, start, tick, finish)
    end)

    RegisterNetEvent('progressbar:client:cancel', function()
        StopProgress()
    end)

    local function Progress(action, finish)
        StartProgress(action, nil, nil, finish)
    end
    exports('Progress', Progress)

    local function ProgressWithStartEvent(action, start, finish)
        StartProgress(action, start, nil, finish)
    end
    exports('ProgressWithStartEvent', ProgressWithStartEvent)

    local function ProgressWithTickEvent(action, tick, finish)
        StartProgress(action, nil, tick, finish)
    end
    exports('ProgressWithTickEvent', ProgressWithTickEvent)

    local function ProgressWithStartAndTick(action, start, tick, finish)
        StartProgress(action, start, tick, finish)
    end
    exports('ProgressWithStartAndTick', ProgressWithStartAndTick)

    local function isDoingSomething()
        return IsDoingAction
    end
    exports('isDoingSomething', isDoingSomething)
end

-- Hide Radar
exports("HideRadar", function(state)
    HiddenByExport = state
end)

-- OpenSettings()
exports("OpenSettings", OpenSettings)
RegisterNetEvent("17mov_Hud:OpenSettings", OpenSettings)

-- Get current HUD colors
function GetTheme(cb)
    if cb then
        cb(Config.DefaultColors)
    end
end

exports("GetTheme", GetTheme)
RegisterNetEvent("17mov_Hud:GetTheme", GetTheme)

-- Or get colors with every update from setting
-- RegisterNetEvent("17mov_Hud:UpdateTheme", function(theme)
--     local lightmode = theme['dark']
--     print("Lightmode - Primary color:", lightmode['--color-primary'])
--     print("Lightmode - Secondary color:", lightmode['--color-secondary'])
--     print("Lightmode - Text Primary color:", lightmode['--color-text-primary'])
--     print("Lightmode - Text Secondary color:", lightmode['--color-text-secondary'])
--     print("Lightmode - Transparent color:", lightmode['--color-transparent'])
--
--     local darkmode = theme['dark']
--     print("Darkmode - Primary color:", darkmode['--color-primary'])
--     print("Darkmode - Secondary color:", darkmode['--color-secondary'])
--     print("Darkmode - Text Primary color:", darkmode['--color-text-primary'])
--     print("Darkmode - Text Secondary color:", darkmode['--color-text-secondary'])
--     print("Darkmode - Transparent color:", darkmode['--color-transparent'])
-- end)

function FuelGetter(vehicle)
    -- You can change your fuel level here if you want.
    -- NOTE: value must be between <0.0, 1.0>
    return GetVehicleFuelLevel(vehicle) / 100
end

-- Get
function GetSettings(cb)
    if cb and type(cb) == "function" then
        cb(Config.CurrentSettings)
    end
end

exports("GetSettings", GetSettings)
RegisterNetEvent("17mov_Hud:GetSettings", GetSettings)

-- Or get settings with every update
-- RegisterNetEvent("17mov_Hud:UpdateSettings", function(settings)
-- print(settings)
-- end)

-- { 17movement.net } --
