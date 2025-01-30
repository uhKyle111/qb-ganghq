QBCore = exports['qb-core']:GetCoreObject()
GangPanel = {}

-- Load all gangs on resource start
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        GangPanel.LoadGangs()
    end
end)

-- Load gangs from database
function GangPanel.LoadGangs()
    local result = MySQL.query.await('SELECT * FROM gangs')
    if result then
        for _, gang in pairs(result) do
            GangPanel[gang.name] = gang
        end
    end
end

-- Save gang data
function GangPanel.SaveGang(gangName, data)
    MySQL.update('UPDATE gangs SET data = ? WHERE name = ?', { json.encode(data), gangName })
end

-- Fetch gang data
QBCore.Functions.CreateCallback('qb-gangpanel:GetGangData', function(source, cb, gangName)
    cb(GangPanel[gangName] or {})
end)

RegisterNetEvent('qb-gangpanel:UpdateGangData', function(gangName, data)
    local src = source
    if GangPanel[gangName] then
        GangPanel[gangName] = data
        GangPanel.SaveGang(gangName, data)
        TriggerClientEvent('qb-gangpanel:SyncGangData', -1, gangName, data)
    end
end)
