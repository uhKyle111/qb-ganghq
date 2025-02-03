-- client/cl_gangpanel.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Use configuration values for initial setup
local propModel = "hei_prop_dlc_tablet"  
local panelCoords = Config.GangPanelLocation  
local zOffset = Config.GangPanelZOffset       
local desiredHeading = Config.GangPanelHeading  
local spawnedProp = nil

------------------------------------------------
-- Function: spawnOrUpdateProp
-- Spawns the dashboard prop if it doesn't exist or updates its position/rotation.
------------------------------------------------
local function spawnOrUpdateProp()
    local model = GetHashKey(propModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end

    local newCoords = vector3(panelCoords.x, panelCoords.y, panelCoords.z + zOffset)

    if DoesEntityExist(spawnedProp) then
        -- Update the existing prop
        SetEntityCoords(spawnedProp, newCoords.x, newCoords.y, newCoords.z, false, false, false, false)
        SetEntityHeading(spawnedProp, desiredHeading)
        SetEntityRotation(spawnedProp, 0.0, 0.0, desiredHeading, 2, true)
    else
        -- Create a new prop
        spawnedProp = CreateObject(model, newCoords.x, newCoords.y, newCoords.z, false, false, false)
        SetEntityHeading(spawnedProp, desiredHeading)
        SetEntityRotation(spawnedProp, 0.0, 0.0, desiredHeading, 2, true)
        PlaceObjectOnGroundProperly(spawnedProp)
    end

    -- Register the prop with qb-target for interaction
    exports['qb-target']:AddTargetEntity(spawnedProp, {
        options = {
            {
                type = "client",
                event = "qb-ganghq:client:openDashboard",
                icon = "fas fa-tablet-alt",
                label = "Open Gang Dashboard"
            },
        },
        distance = 2.5,
    })
end

------------------------------------------------
-- Initial Prop Spawn on Resource Start
------------------------------------------------
Citizen.CreateThread(function()
    spawnOrUpdateProp()
end)

------------------------------------------------
-- Event: Open Gang Dashboard (triggered via qb-target)
------------------------------------------------
RegisterNetEvent('qb-ganghq:client:openDashboard', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openDashboard"
    })
end)

------------------------------------------------
-- Admin Commands for Adjusting the Dashboard Prop
------------------------------------------------

-- /setGangPanelPos: Sets the panel's position and heading to the admin's current location.
RegisterCommand('setGangPanelPos', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    panelCoords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
    desiredHeading = playerHeading
    spawnOrUpdateProp()

    QBCore.Functions.Notify("Gang Panel position updated to: " ..
        string.format("%.2f, %.2f, %.2f", panelCoords.x, panelCoords.y, panelCoords.z) ..
        " with heading " .. desiredHeading, "success")
end, false)

-- /setGangPanelZOffset [offset]: Adjusts the vertical offset.
RegisterCommand('setGangPanelZOffset', function(source, args, rawCommand)
    local offset = tonumber(args[1])
    if offset then
        zOffset = offset
        spawnOrUpdateProp()
        QBCore.Functions.Notify("Gang Panel Z Offset updated to: " .. zOffset, "success")
    else
        QBCore.Functions.Notify("Usage: /setGangPanelZOffset [offset]", "error")
    end
end, false)

-- /rotateGangPanel [heading]: Adjusts the panel's rotation.
RegisterCommand('rotateGangPanel', function(source, args, rawCommand)
    local rotation = tonumber(args[1])
    if rotation then
        desiredHeading = rotation
        spawnOrUpdateProp()
        QBCore.Functions.Notify("Gang Panel heading updated to: " .. desiredHeading, "success")
    else
        QBCore.Functions.Notify("Usage: /rotateGangPanel [heading]", "error")
    end
end, false)

------------------------------------------------
-- Auto-Respawn Check: If the prop is missing, respawn it.
------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        if not DoesEntityExist(spawnedProp) then
            QBCore.Functions.Notify("Gang Panel missing, respawning...", "error")
            spawnOrUpdateProp()
        end
    end
end)
