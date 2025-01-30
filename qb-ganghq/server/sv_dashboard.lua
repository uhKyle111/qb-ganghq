QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-gangpanel:GetDashboard', function(gangName)
    local src = source
    local members = MySQL.query.await('SELECT * FROM gang_members WHERE gang = ?', { gangName })
    local businesses = MySQL.query.await('SELECT * FROM gang_businesses WHERE gang = ?', { gangName })
    local missions = MySQL.query.await('SELECT * FROM gang_missions WHERE gang = ?', { gangName })

    TriggerClientEvent('qb-gangpanel:ReceiveDashboard', src, {
        members = members,
        businesses = businesses,
        missions = missions
    })
end)
