function AddCustom(src, item, amount, reason)
    exports['qb-inventory']:AddItem(src, item, amount)
end

function RemCustom(src, item, amount, reason)
    exports['qb-inventory']:RemoveItem(src, item, amount, slot)
end

function SA_Payment(data)
    local src = data.src
    local amount = data.amount
    local name = data.name
    if Config.Notifications then
        if name == 'PaymentNotify' then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('notifications.paid', {money = amount}), 'success')

        elseif name == 'NotEnoughMoney' then
            TriggerClientEvent('QBCore:Notify', source, Lang:t('notifications.enoughmoney'), 'error')

        elseif name == 'RecievedNotify' then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('notifications.recieved', {money = amount}), 'success')

        elseif name == 'FullInventory' then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('notifications.FullInventory', {money = amount}), 'success')

        elseif name == 'Error' then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('notifications.error'), 'error')

        end
    end
end

function SA_Migration(data)
    local name = data.name
    local src = data.src

    if name == 'Done' then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('migration.done'), 'success')
    elseif name == 'Error' then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('migration.error'), 'error')
    elseif name == 'Progress' then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('migration.progress', {progress = data.progress, accounts = data.max}), 'primary')
    end
end