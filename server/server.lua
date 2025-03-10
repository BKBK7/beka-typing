RegisterNetEvent('beka-typing:server:typingStatus', function(open)
    TriggerClientEvent("beka-typing:client:updateState", -1, source, open)
end)

AddEventHandler('playerDropped', function()
    TriggerClientEvent("beka-typing:client:updateState", -1, source, false)
end)
