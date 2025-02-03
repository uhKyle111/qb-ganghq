RegisterNUICallback("closePanel", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeDashboard" })
    cb("ok")
end)

RegisterNetEvent("qb-ganghq:client:updateDashboard", function(data)
    SendNUIMessage({
        action = "updateOverview",
        data = data
    })
end)

RegisterNetEvent("qb-ganghq:client:updateMembers", function(members)
    SendNUIMessage({
        action = "updateMembers",
        members = members
    })
end)
