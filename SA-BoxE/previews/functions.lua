local QBCore = exports[Config.Framework]:GetCoreObject()

function SA_Notify(data)
    local data = data
    if data == 'NotAuthorized' then
        QBCore.Functions.Notify(Lang:t('doors.NotAuthorized'), 'error', 7500)
    end
end