QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-gangpanel:StartMission', function(gangName)
    local src = source
    local lastMission = MySQL.query.await('SELECT last_mission FROM gangs WHERE name = ?', { gangName })[1]?.last_mission or 0

    if os.time() - lastMission >= 21600 then -- 6 hours
        MySQL.update('UPDATE gangs SET last_mission = ? WHERE name = ?', { os.time(), gangName })
        TriggerClientEvent('qb-gangpanel:StartMissionClient', src, gangName)
    else
        TriggerClientEvent('qb-gangpanel:Notify', src, "You must wait before starting a new mission!")
    end
end)
