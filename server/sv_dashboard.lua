-- server/sv_dashboard.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Example: Update Gang Reputation
RegisterNetEvent('qb-ganghq:server:updateRep', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player and Player.PlayerData.gang then
        local gangId = Player.PlayerData.gang.id

        exports.ghmattimysql:execute('UPDATE gangs SET rep = rep + @rep WHERE id = @gang_id', {
            ['@rep'] = amount,
            ['@gang_id'] = gangId
        }, function()
            TriggerClientEvent('QBCore:Notify', src, 'Gang reputation updated.', 'success')
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are not in a gang.', 'error')
    end
end)
