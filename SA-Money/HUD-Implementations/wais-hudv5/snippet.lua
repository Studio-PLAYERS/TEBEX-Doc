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