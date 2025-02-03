-- client/cl_members.lua
local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('manageMembers', function()
    -- Open the member management UI (this example uses NUI)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openMembersPanel"
    })
end, false)
