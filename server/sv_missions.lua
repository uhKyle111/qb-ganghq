-- sv_missions.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Ensure MissionConfig.lua is loaded before this script

RegisterNetEvent("qb-ganghq:server:rewardMission", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local requiredItem = MissionConfig.RequiredItem
        local requiredQuantity = MissionConfig.RequiredQuantity
        local itemInfo = Player.Functions.GetItemByName(requiredItem)

        if itemInfo and itemInfo.amount >= requiredQuantity then
            -- Remove the required item (the specified quantity)
            Player.Functions.RemoveItem(requiredItem, requiredQuantity)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[requiredItem], "remove")

            -- Instead of money, reward with gang reputation
            local repReward = MissionConfig.RepReward
            -- (Assumes you have a function to add reputation; adjust as needed)
            if Player.Functions.AddRep then
                Player.Functions.AddRep(repReward)
            else
                -- If no built-in function, you may need to update your data manually.
                print("AddRep function not found, please implement gang rep update.")
            end

            -- Optionally give a bonus item
            local bonusItems = MissionConfig.BonusItems
            local randomItem = bonusItems[math.random(#bonusItems)]
            Player.Functions.AddItem(randomItem, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randomItem], "add")

            TriggerClientEvent('QBCore:Notify', src, "You delivered your " .. MissionConfig.RequiredItemDisplay .. " and received " .. repReward .. " gang rep and a " .. randomItem .. "!", "success")
        else
            -- The player did not have the required item in the required quantity
            TriggerClientEvent('QBCore:Notify', src, "You do not have your " .. MissionConfig.RequiredItemDisplay .. " (x" .. requiredQuantity .. ") to complete the mission!", "error")
        end
    end
end)
