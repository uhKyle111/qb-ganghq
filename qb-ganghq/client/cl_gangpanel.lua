RegisterNetEvent('qb-gangpanel:SyncGangData', function(gangName, data)
    SendNUIMessage({ action = "updateGangData", gang = gangName, data = data })
end)

RegisterNUICallback('modifyMember', function(data)
    TriggerServerEvent('qb-gangpanel:ModifyMember', data.action, data.gang, data.playerId)
end)

RegisterNUICallback('createBusiness', function(data)
    TriggerServerEvent('qb-gangpanel:CreateBusiness', data.gang, data.businessType)
end)
