local resourceName = 'qb-core'

if not GetResourceState(resourceName):find('start') then return end

if Config.AutomaticTransactionsDeletion then
    SetTimeout(0, function()
        MySQL.query("delete from fd_advanced_banking_accounts_transactions where created_at < now() - interval 30 DAY",
            {},
            function() end)
    end)
end

SetTimeout(0, function()
    core = exports[resourceName]:GetCoreObject()
    local isQBX = GetResourceState('qbx_core'):find('start') or false

    local Jobs = core.Shared.Jobs
    local Gangs = core.Shared.Gangs
    local dontAllowMinus = core.Config?.Money?.DontAllowMinus

    if isQBX then
        Jobs = require '@qbx_core.shared.jobs'
        Gangs = require '@qbx_core.shared.gangs'
        local QBConfig = require '@qbx_core.config.server'

        dontAllowMinus = QBConfig.money.dontAllowMinus
    end

    function bridge.getPlayer(source)
        return isQBX and exports.qbx_core:GetPlayer(source) or core.Functions.GetPlayer(source)
    end

    function bridge.getPlayerByCitizenId(identifier)
        return isQBX and exports.qbx_core:GetPlayerByCitizenId(identifier) or
            core.Functions.GetPlayerByCitizenId(identifier)
    end

    RegisterNetEvent("QBCore:Server:PlayerLoaded", function(player)
        local src = source

        if not player then
            player = bridge.getPlayer(src)
        end

        createDefaultAccountOrSync(player.PlayerData.source)

        core.Functions.AddPlayerMethod(player.PlayerData.source, 'AddMoney', function(moneytype, amount, reason, data)
            reason = reason or locale('not_provided')
            amount = tonumber(amount)

            if amount < 0 then
                return false
            end

            amount = math.floor(amount)

            local player = bridge.getPlayer(player.PlayerData.source)

            if not player.PlayerData.money[moneytype] then
                return false
            end

            local typ = exports['SA-Money-v2']:MoneyChecker(moneytype)
            if typ then
                if player.PlayerData.money[moneytype] == player.PlayerData.money[typ] then
                    exports['SA-Money-v2']:AddMoney(player.PlayerData, amount, reason, typ)
                end
            else
                player.PlayerData.money[moneytype] = player.PlayerData.money[moneytype] + amount
            end

            if not player.Offline then
                player.Functions.SetPlayerData('money', player.PlayerData.money)

                if moneytype == 'bank' and not data?.skipTransaction then
                    CreateThread(function()
                        if not data then
                            data = {}
                        end
                        if reason:find('<!>') then
                            local customFrom, splitReason = reason:match('^(.-)<!>(.+)')
                            data.from = customFrom
                            reason = splitReason
                        end

                        handleDepositToPersonalAccount(player.PlayerData.source, amount,
                            player.PlayerData.money[moneytype], reason, data)
                    end)
                end

                if amount > 100000 then
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen',
                        '**' ..
                        GetPlayerName(player.PlayerData.source) ..
                        ' (citizenid: ' ..
                        player.PlayerData.citizenid ..
                        ' | id: ' ..
                        player.PlayerData.source ..
                        ')** $' ..
                        amount ..
                        ' (' ..
                        moneytype ..
                        ') added, new ' ..
                        moneytype .. ' balance: ' .. player.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
                else
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen',
                        '**' ..
                        GetPlayerName(player.PlayerData.source) ..
                        ' (citizenid: ' ..
                        player.PlayerData.citizenid ..
                        ' | id: ' ..
                        player.PlayerData.source ..
                        ')** $' ..
                        amount ..
                        ' (' ..
                        moneytype ..
                        ') added, new ' ..
                        moneytype .. ' balance: ' .. player.PlayerData.money[moneytype] .. ' reason: ' .. reason)
                end

                TriggerClientEvent('hud:client:OnMoneyChange', player.PlayerData.source, moneytype, amount, false)
                TriggerClientEvent('QBCore:Client:OnMoneyChange', player.PlayerData.source, moneytype, amount, "add",
                    reason)
                TriggerEvent('QBCore:Server:OnMoneyChange', player.PlayerData.source, moneytype, amount, "add", reason)

                return true
            end

            return false
        end)

        core.Functions.AddPlayerMethod(player.PlayerData.source, 'RemoveMoney', function(moneytype, amount, reason, data)
            reason = reason or locale('not_provided')
            amount = tonumber(amount)

            if amount < 0 then
                return false
            end

            amount = math.floor(amount)

            local player = bridge.getPlayer(player.PlayerData.source)

            if not player.PlayerData.money[moneytype] then
                return false
            end

            for _, mtype in pairs(dontAllowMinus) do
                if mtype == moneytype then
                    if (player.PlayerData.money[moneytype] - amount) < 0 then
                        return false
                    end
                end
            end

            local typ = exports['SA-Money-v2']:MoneyChecker(moneytype)
            if typ then
                if player.PlayerData.money[moneytype] == player.PlayerData.money[typ] then
                    exports['SA-Money-v2']:RemoveMoney(player.PlayerData, amount, reason, typ)
                end
            else
                player.PlayerData.money[moneytype] = player.PlayerData.money[moneytype] - amount
            end

            if not player.Offline then
                local isFrozen = isPersonalAccountFrozenFromSource(player.PlayerData.source)

                if isFrozen then
                    return false
                end

                player.Functions.SetPlayerData('money', player.PlayerData.money)

                if moneytype == 'bank' and not data?.skipTransaction then
                    CreateThread(function()
                        if not data then
                            data = {}
                        end

                        if reason:find('<!>') then
                            local customTo, splitReason = reason:match('^(.-)<!>(.+)$')
                            data.to = customTo
                            reason = splitReason
                        end

                        handleWithdrawFromPersonalAccount(player.PlayerData.source, amount,
                            player.PlayerData.money[moneytype], reason, data)
                    end)
                end

                if amount > 100000 then
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red',
                        '**' ..
                        GetPlayerName(player.PlayerData.source) ..
                        ' (citizenid: ' ..
                        player.PlayerData.citizenid ..
                        ' | id: ' ..
                        player.PlayerData.source ..
                        ')** $' ..
                        amount ..
                        ' (' ..
                        moneytype ..
                        ') removed, new ' ..
                        moneytype .. ' balance: ' .. player.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
                else
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red',
                        '**' ..
                        GetPlayerName(player.PlayerData.source) ..
                        ' (citizenid: ' ..
                        player.PlayerData.citizenid ..
                        ' | id: ' ..
                        player.PlayerData.source ..
                        ')** $' ..
                        amount ..
                        ' (' ..
                        moneytype ..
                        ') removed, new ' ..
                        moneytype .. ' balance: ' .. player.PlayerData.money[moneytype] .. ' reason: ' .. reason)
                end

                TriggerClientEvent('hud:client:OnMoneyChange', player.PlayerData.source, moneytype, amount, true)

                if moneytype == 'bank' then
                    TriggerClientEvent('qb-phone:client:RemoveBankMoney', player.PlayerData.source, amount)
                end

                TriggerClientEvent('QBCore:Client:OnMoneyChange', player.PlayerData.source, moneytype, amount, "remove",
                    reason)
                TriggerEvent('QBCore:Server:OnMoneyChange', player.PlayerData.source, moneytype, amount, "remove", reason)

                return true
            end

            return false
        end)

        processOverdueInvoices(player.PlayerData.source)
    end)

    AddEventHandler("QBCore:Server:OnMoneyChange", function(source, moneytype, amount, action, reason)
        if moneytype ~= 'bank' then
            return false
        end

        if action ~= 'set' then
            return false
        end

        forceSetPersonalBalance(source, amount, reason)
    end)

    function bridge.getIdentifier(source)
        local player = bridge.getPlayer(source)

        if player then
            return player.PlayerData.citizenid, player
        end

        return false
    end

    function bridge.getSourceFromIdentifier(identifier)
        local player = bridge.getPlayerByCitizenId(identifier)

        if player then
            return player.PlayerData.source, player
        end

        return false
    end

    function bridge.isPlayerOnline(source)
        local player = bridge.getPlayer(source)

        if player then
            return true
        end

        return false
    end

    function bridge.currentSociety(source, isGang)
        local player = bridge.getPlayer(source)

        if player then
            if isGang then
                return player.PlayerData.gang.name
            end

            return player.PlayerData.job.name
        end

        return false
    end

    function bridge.currentSocietyWithGrade(source, isGang)
        local player = bridge.getPlayer(source)

        if player then
            if isGang then
                return player.PlayerData.gang.name, player.PlayerData.gang.grade.level
            end

            return player.PlayerData.job.name, player.PlayerData.job.grade.level
        end

        return false
    end

    function bridge.getJobLabel(job)
        return Jobs[job]?.label or nil
    end

    function bridge.isPlayerBoss(source, isGang)
        local player = bridge.getPlayer(source)

        if player then
            if isGang then
                return player.PlayerData.gang.isboss
            end

            return player.PlayerData.job.isboss
        end

        return false
    end

    function bridge.firstLastName(source)
        local player = bridge.getPlayer(source)

        if player then
            return ('%s %s'):format(player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname)
        end

        return source
    end

    function bridge.getAccountAmount(source, account)
        local player = bridge.getPlayer(source)

        if player then
            return player.PlayerData.money[account] or false
        end

        return false
    end

    function bridge.setAccountAmount(source, account, amount, reason, data)
        local player = bridge.getPlayer(source)

        if player then
            return player.Functions.SetMoney(account, amount, reason, data)
        end

        return false
    end

    function bridge.removeMoney(source, account, amount, reason, data)
        local player = bridge.getPlayer(source)

        if player then
            return player.Functions.RemoveMoney(account, amount, reason, data)
        end

        return false
    end

    function bridge.addMoney(source, account, amount, reason, data)
        local player = bridge.getPlayer(source)

        if player then
            return player.Functions.AddMoney(account, amount, reason, data)
        end

        return false
    end

    function bridge.notify(source, message, type)
        TriggerClientEvent('QBCore:Notify', source, message, type)
    end

    function bridge.getJobs()
        local societys = {}

        if Config.UseSocietyAccounts then
            for k, v in pairs(Jobs) do
                societys[k] = v
            end
        end

        if Config.UseGangAccounts then
            for k, v in pairs(Gangs) do
                societys[k] = v
            end
        end

        return societys
    end

    function bridge.isStaff(source, permission)
        return core.Functions.HasPermission(source, permission)
    end

    function bridge.getPlayersByGrade(job, grade)
        return MySQL.query.await([[
            SELECT
                *
            FROM
                players
            WHERE
                (JSON_CONTAINS(job, ?, '$.name') AND
                JSON_CONTAINS(job, ?, '$.grade.level'))
            OR
                (JSON_CONTAINS(gang, ?, '$.name') AND
                JSON_CONTAINS(gang, ?, '$.grade.level'))
        ]], { ('"%s"'):format(job), ('%s'):format(grade) })
    end

    function bridge.createLog(source, data)
        TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', 0, data.message, false)
    end

    function bridge.trackedPlayerUsed(source, identifier, coords, type)
        Citizen.CreateThread(function()
            local players = core.Functions.GetQBPlayers()
            for _, v in pairs(players) do
                if v and v.PlayerData.job.name == "police" then
                    bridge.notify(v.PlayerData.source, ('%s used %s, at %s'):format(identifier, type, coords), 'error')
                end
            end
        end)
    end

    AddEventHandler('QBCore:Server:UpdateObject', function()
        QB = exports[resourceName]:GetCoreObject()
        core = QB

        TriggerEvent("fd_banking:UpdateObject")
    end)
end)

if Config.EnableQBGivecash then
    lib.addCommand('givecash', {
        help = locale('givecash_help_tip'),
        params = {
            {
                name = 'target',
                type = 'playerId',
                help = locale('givecash_help_param'),
            },
            {
                name = 'amount',
                type = 'number',
                help = locale('givecash_help_param2'),
            }
        },
    }, function(source, args, raw)
        local src = source
        local Player = core.Functions.GetPlayer(src)
        if not Player then return end
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local target = core.Functions.GetPlayer(tonumber(args.target))
        if not target then return TriggerClientEvent('QBCore:Notify', src, locale('givecash_no_user'), 'error') end
        local targetPed = GetPlayerPed(tonumber(args.target))
        local targetCoords = GetEntityCoords(targetPed)
        local amount = tonumber(args.amount)
        if not amount then return TriggerClientEvent('QBCore:Notify', src, locale('givecash_no_amount'), 'error') end
        if amount <= 0 then return TriggerClientEvent('QBCore:Notify', src, locale('givecash_no_zero'), 'error') end
        if #(playerCoords - targetCoords) > 5 then return TriggerClientEvent('QBCore:Notify', src, locale('givecash_no_nearby'), 'error') end
        if Player.PlayerData.money.cash < amount then return TriggerClientEvent('QBCore:Notify', src, locale('not_enough_money'), 'error') end
        Player.Functions.RemoveMoney('cash', amount, 'cash transfer')
        target.Functions.AddMoney('cash', amount, 'cash transfer')
        TriggerClientEvent('QBCore:Notify', src, locale('givecash_give_money', amount), 'success')
        TriggerClientEvent('QBCore:Notify', target.PlayerData.source, locale('givecash_receive_money', amount), 'success')
    end)
end