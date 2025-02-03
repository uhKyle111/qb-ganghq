local QBCore = exports['qb-core']:GetCoreObject()
local GangFunds = {}

RegisterNetEvent("qb-ganghq:server:GetPanelData", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    if not gang then return end

    local members = {}
    for _, id in ipairs(QBCore.Functions.GetPlayers()) do
        local target = QBCore.Functions.GetPlayer(id)
        if target and target.PlayerData.gang.name == gang then
            table.insert(members, { id = id, name = target.PlayerData.charinfo.firstname .. " " .. target.PlayerData.charinfo.lastname, rank = target.PlayerData.gang.grade })
        end
    end

    TriggerClientEvent("qb-ganghq:client:SetPanelData", src, {
        gangName = gang,
        bankBalance = GangFunds[gang] or 0,
        members = members
    })
end)

RegisterNetEvent("qb-ganghq:server:DepositMoney", function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    if not gang then return end

    if Player.Functions.RemoveMoney("cash", amount, "Gang Deposit") then
        GangFunds[gang] = (GangFunds[gang] or 0) + amount
        TriggerClientEvent('QBCore:Notify', src, "Deposited $" .. amount .. " into gang bank.", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Not enough cash!", "error")
    end
end)
