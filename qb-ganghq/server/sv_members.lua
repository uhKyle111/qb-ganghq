QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-gangpanel:ModifyMember', function(action, gangName, playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(playerId)

    if Player then
        if action == "hire" then
            Player.Functions.SetJob("gang", { gang = gangName, grade = 0 })
            MySQL.insert('INSERT INTO gang_members (gang, citizenid) VALUES (?, ?)', { gangName, Player.PlayerData.citizenid })
        elseif action == "fire" then
            Player.Functions.SetJob("unemployed", {})
            MySQL.query.await('DELETE FROM gang_members WHERE citizenid = ?', { Player.PlayerData.citizenid })
        elseif action == "promote" then
            Player.Functions.SetJob("gang", { gang = gangName, grade = math.min(Player.PlayerData.job.grade + 1, 5) })
        elseif action == "demote" then
            Player.Functions.SetJob("gang", { gang = gangName, grade = math.max(Player.PlayerData.job.grade - 1, 0) })
        end
    end
end)
