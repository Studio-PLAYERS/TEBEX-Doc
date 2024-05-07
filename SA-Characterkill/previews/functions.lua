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

function Notify(event, src)
    if event == 'NotFound' then
        NotifySystem(src, Translations.notify.notfound, 'error')
    elseif event == 'InvalidFormat' then
        NotifySystem(src, Translations.notify.InvalidFormat, 'error')
    elseif event == 'WrongSecureWord' then
        NotifySystem(src, Translations.notify.WrongSecureWord, 'error')
    elseif event == 'Deleted' then
        NotifySystem(src, Translations.notify.deleted, 'success')
    end
end