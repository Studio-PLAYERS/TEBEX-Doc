local QBCore = exports['qb-core']:GetCoreObject()

function Notify(message, typ)
    QBCore.Functions.Notify(message, typ)
end

function OpenMenu(data)
    exports['qb-menu']:openMenu(data)
end

function AddTarget(ped, index)
    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = 'client',
                event = 'SA-MoneyWash:client:OpenMainMenu',
                icon = 'fa-solid fa-dollar-sign',
                label = Lang:t('TargetAndBox.open'),
                entity = ped,
                index = index
            },
        },
        distance = 3.0
    })
end

function DrawText(message)
    exports['qb-core']:DrawText('[E] ' .. message, 'left')
end

function HideText()
    exports['qb-core']:HideText()
end

function KeyPressed(key)
    exports['qb-core']:KeyPressed(key)
end