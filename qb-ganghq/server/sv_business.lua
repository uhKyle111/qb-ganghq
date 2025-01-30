QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-gangpanel:CreateBusiness', function(gangName, businessType)
    local src = source
    local rep = MySQL.query.await('SELECT rep FROM gangs WHERE name = ?', { gangName })[1]?.rep or 0

    if rep >= 50 then
        MySQL.insert('INSERT INTO gang_businesses (gang, type) VALUES (?, ?)', { gangName, businessType })
        TriggerClientEvent('qb-gangpanel:Notify', src, "Business created successfully!")
    else
        TriggerClientEvent('qb-gangpanel:Notify', src, "Not enough gang reputation!")
    end
end)
