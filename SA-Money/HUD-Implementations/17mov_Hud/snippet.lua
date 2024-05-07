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