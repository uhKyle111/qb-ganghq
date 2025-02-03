-- client/cl_buyhq.lua
local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - Config.HQLocation)
        
        if distance < (Config.HQRadius + 1.0) then
            sleep = 5
            DrawMarker(2, Config.HQLocation.x, Config.HQLocation.y, Config.HQLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.HQRadius, Config.HQRadius, 0.5, 255, 215, 0, 100, false, true, 2, false, nil, nil, false)
            if distance < Config.HQRadius then
                QBCore.Functions.DrawText3D(Config.HQLocation.x, Config.HQLocation.y, Config.HQLocation.z + 0.5, "[E] Purchase Gang HQ")
                if IsControlJustReleased(0, 38) then  -- 38 = E key
                    TriggerServerEvent('qb-ganghq:server:attemptPurchaseHQ')
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)
