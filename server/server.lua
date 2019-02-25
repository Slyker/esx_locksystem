owners = {}

RegisterServerEvent("esx_locksystem:UpdateVehicles")
AddEventHandler("esx_locksystem:UpdateVehicles", function(myID)
    local src = source
    local srcIdentifier = GetPlayerIdentifiers(src)[1]
    MySQL.Async.fetchAll("SELECT `plate`, `owner` FROM owned_vehicles",{}, function(data)
        for k,v in pairs(data) do
            local plate = string.lower(v.plate)
            owners[plate] = v.owner
        end
    end)
	
	Wait(2000)
	
    for plate, plyIdentifier in pairs(owners) do
        if(plyIdentifier == srcIdentifier)then
            local _plate = plate
            TriggerClientEvent("esx_locksystem:newVehicle", src, _plate, nil, nil)
			Wait(100)
        end
    end
end)

RegisterServerEvent("esx_locksystem:haveKeys")
AddEventHandler("esx_locksystem:haveKeys", function(myID, localVehPlate)
	local src = source
    targetIdentifier = GetPlayerIdentifiers(myID)[1]
    local hasKey = false

    for plate, identifier in pairs(owners) do
        if((string.gsub(tostring(plate), "%s", "") == tostring(localVehPlate)) and (tostring(identifier) == tostring(targetIdentifier)))then
            hasKey = true
            break
        end
    end

    if hasKey == true then
		callback = true
		TriggerClientEvent("esx_locksystem:setIsOwner", src, callback)
    else
		callback = false
		TriggerClientEvent("esx_locksystem:setIsOwner", src, callback)
    end
end)