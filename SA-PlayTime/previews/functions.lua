local function NotifySystem(src, text, typ)
    if ESX then
        -- ESX
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end
        xPlayer.showNotification(text) 
    else
        -- QB-Core
        TriggerClientEvent('QBCore:Notify', src, text, typ)
    end
end

function Notify(event, src, data)
    if event == 'WrongID' then
        NotifySystem(src, Translations.notifications.wrongid, 'error')
    elseif event == 'AccountAdminCommand' then
        NotifySystem(src, 'ID: ' .. data.ID .. Translations.notifications.playtimeplayer .. data.playtime .. Translations.notifications.acc, 'success')
    elseif event == 'AccountPlayerCommand' then
        NotifySystem(src, Translations.notifications.playtime .. data.playtime .. Translations.notifications.acc, 'success')
    elseif event == 'PlayerAdminCommand' then
        NotifySystem(src, 'ID: ' .. data.ID .. Translations.notifications.playtimeplayer .. data.playtime .. Translations.notifications.char, 'success')
    elseif event == 'PlayerCommand' then
        NotifySystem(src, Translations.notifications.playtime .. data.playtime .. Translations.notifications.char, 'success')
    end
end