-- server/sv_buyhq.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- In-memory storage for gang HQs (for demonstration purposes)
local GangHQs = {}

RegisterNetEvent('qb-ganghq:server:attemptPurchaseHQ', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local gangData = Player.PlayerData.gang or {}  -- Assumes gang info is stored here
    if not gangData.rep or gangData.rep < Config.RequiredRepForPurchase then
        TriggerClientEvent('QBCore:Notify', src, "Not enough rep to purchase an HQ.", "error")
        return
    end

    if Player.PlayerData.money.cash < Config.HQPrice then
        TriggerClientEvent('QBCore:Notify', src, "Not enough cash to purchase an HQ.", "error")
        return
    end

    -- Deduct money and assign the HQ (for demo purposes, using in-memory storage)
    Player.Functions.RemoveMoney('cash', Config.HQPrice)
    GangHQs[gangData.name] = {
        owner = Player.PlayerData.citizenid,
        location = Config.HQLocation,
        rep = gangData.rep
    }

    TriggerClientEvent('QBCore:Notify', src, "Gang HQ purchased successfully!", "success")
end)
