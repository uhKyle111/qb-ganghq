-- server/sv_business.lua
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-ganghq:server:getBusinesses', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Player.PlayerData.gang then
        local businesses = GetGangBusinesses(Player.PlayerData.gang.name)
        TriggerClientEvent('qb-ganghq:client:updateBusinesses', src, businesses)
    end
end)
