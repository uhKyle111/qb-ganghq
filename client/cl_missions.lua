-- cl_missions.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Ensure MissionConfig.lua is loaded before this script in your fxmanifest.lua

local missionActive = false
local missionNPC = nil
local missionBlip = nil

local function startMission()
    if missionActive then
        QBCore.Functions.Notify("A mission is already active!", "error")
        return
    end

    missionActive = true

    local dropOffCoords = MissionConfig.DropOffCoords
    local npcModel = GetHashKey(MissionConfig.NPCModel)

    -- Load NPC Model
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(1)
    end

    -- Spawn NPC
    missionNPC = CreatePed(4, npcModel, dropOffCoords.x, dropOffCoords.y, dropOffCoords.z, 0.0, false, true)
    SetEntityAsMissionEntity(missionNPC, true, true)
    SetBlockingOfNonTemporaryEvents(missionNPC, true)
    SetPedFleeAttributes(missionNPC, 0, 0)
    SetPedCombatAttributes(missionNPC, 46, 1)
    SetPedKeepTask(missionNPC, true)

    -- Create Blip ("radar_stash_house")
    missionBlip = AddBlipForCoord(dropOffCoords.x, dropOffCoords.y, dropOffCoords.z)
    SetBlipSprite(missionBlip, 677)
    SetBlipScale(missionBlip, 1.0)
    SetBlipColour(missionBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mission Drop-Off")
    EndTextCommandSetBlipName(missionBlip)

    -- Set GPS waypoint
    SetNewWaypoint(dropOffCoords.x, dropOffCoords.y)

    -- Assign NPC interaction via qb-target
    exports['qb-target']:AddTargetEntity(missionNPC, {
        options = {
            {
                type = "client",
                event = "qb-ganghq:client:completeMission",
                icon = "fas fa-box",
                label = "Drop Off Package",
            },
        },
        distance = 2.5
    })

    -- Notify player
    QBCore.Functions.Notify("Mission Started! Deliver the package along with your " .. MissionConfig.RequiredItemDisplay .. ".", "success")

    -- Send mission details to the UI (displaying the required item)
    SendNUIMessage({
        action = "updateMissions",
        data = {
            objective = "Deliver the package to the contact",
            timer = "10:00",
            description = "Find the NPC at the marked location, then hand over the package along with your " .. MissionConfig.RequiredItemDisplay .. ".",
            item = MissionConfig.RequiredItemDisplay,
            location = { x = dropOffCoords.x, y = dropOffCoords.y, z = dropOffCoords.z }
        }
    })
end

-- Event to start a mission manually (trigger via command or tablet)
RegisterNetEvent("qb-ganghq:client:startMission", function()
    startMission()
end)

-- Command to add a mission (for testing or admin use)
RegisterCommand("addmission", function()
    -- Send a pending mission update to the UI
    SendNUIMessage({
        action = "updateMissions",
        data = {
            objective = "Pending Mission...",
            timer = "Awaiting Start...",
            description = "A new mission is available. Start it now!",
            item = MissionConfig.RequiredItemDisplay
        }
    })

    QBCore.Functions.Notify("Mission Added", "primary")

    -- Optional delay for UI effect
    Wait(2000)

    -- Trigger the actual mission start
    TriggerEvent("qb-ganghq:client:startMission")
end, false)

-- Function to complete the mission
RegisterNetEvent("qb-ganghq:client:completeMission", function()
    if missionActive and missionNPC then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local npcCoords = GetEntityCoords(missionNPC)

        if #(playerCoords - npcCoords) < 2.5 then
            -- Show a progress bar simulating the handover process
            QBCore.Functions.Progressbar("handover_item", "Handing over your " .. MissionConfig.RequiredItemDisplay .. "...", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- onComplete callback
                QBCore.Functions.Notify("Item handover complete!", "success")
                -- Trigger the server event after progress completes
                TriggerServerEvent("qb-ganghq:server:rewardMission")
                
                -- Clean up mission elements
                if missionBlip then
                    RemoveBlip(missionBlip)
                end
                if DoesEntityExist(missionNPC) then
                    DeleteEntity(missionNPC)
                end
                missionActive = false

                -- Update the UI to clear the mission
                SendNUIMessage({
                    action = "updateMissions",
                    data = { 
                        objective = "No active mission", 
                        timer = "--:--", 
                        description = "Waiting for a new mission...",
                        item = "None"
                    }
                })
            end, function() -- onCancel callback (optional)
                QBCore.Functions.Notify("Handover canceled.", "error")
            end)
        else
            QBCore.Functions.Notify("You must be near the NPC to drop off the package!", "error")
        end
    else
        QBCore.Functions.Notify("No active mission to complete.", "error")
    end
end)
