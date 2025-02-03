-- server/sv_members.lua
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-ganghq:server:manageMember', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local gangData = Player.PlayerData.gang or {}
    if gangData.name ~= data.gangName then
        TriggerClientEvent('QBCore:Notify', src, "Invalid gang data.", "error")
        return
    end

    if gangData.role ~= "Leader" then
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission.", "error")
        return
    end

    if data.action == "promote" then
        -- Add promotion logic here
        TriggerClientEvent('QBCore:Notify', src, "Member promoted.", "success")
    elseif data.action == "demote" then
        -- Add demotion logic here
        TriggerClientEvent('QBCore:Notify', src, "Member demoted.", "success")
    elseif data.action == "kick" then
        -- Add kick logic here
        TriggerClientEvent('QBCore:Notify', src, "Member kicked.", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Invalid action.", "error")
    end
end)
