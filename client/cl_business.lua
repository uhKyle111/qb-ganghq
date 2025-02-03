-- client/cl_business.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Refresh Businesses List
local function RefreshBusinesses(businesses)
    SendNUIMessage({ action = 'updateBusinesses', businesses = businesses })
end

-- Listen for Business Updates from the server
RegisterNetEvent('qb-ganghq:client:updateBusinesses', function(businesses)
    RefreshBusinesses(businesses)
end)

-- Fetch businesses on demand
RegisterNetEvent('qb-ganghq:client:requestBusinesses', function()
    TriggerServerEvent('qb-ganghq:server:getBusinesses')
end)
