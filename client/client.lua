-----------------------------------------------------------------------------------------
---                                        INIT                                       ---
-----------------------------------------------------------------------------------------

ESX				= nil
localVehId		= 0
savedVehicle	= 0
isTheCarOwner 	= false
keyFobOpen 		= false

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("esx_locksystem:UpdateVehicles")
end)

-----------------------------------------------------------------------------------------
---                                        EVENTS                                     ---
-----------------------------------------------------------------------------------------

RegisterNetEvent("esx_locksystem:setIsOwner")
AddEventHandler("esx_locksystem:setIsOwner", function(callback)
	if callback == true then
		isTheCarOwner = true
	else
		isTheCarOwner = false
	end	
end)

RegisterNetEvent('esx_locksystem:notify')
AddEventHandler('esx_locksystem:notify', function(text, duration)
	Notify(text, duration)
end)

-----------------------------------------------------------------------------------------
---                                     FUNCTIONS                                     ---
-----------------------------------------------------------------------------------------

function doLockSystemToggleLocks()
	local ply = GetPlayerPed(-1)
	local pos = GetEntityCoords(ply)
	local vehicle = GetClosestVehicle(pos['x'], pos['y'], pos['z'], 5.001, 0, 70)
	local hasKey = false
	local myID = GetPlayerServerId(PlayerId())
	isInside = false
	
	if(IsPedInAnyVehicle(ply, true))then
		localVehId = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		isInside = true
	else
		if (vehicle ~= 0) then	
			localVehId = vehicle
			savedVehicle = vehicle
		elseif (vehicle ~= 0) and (savedVehicle == vehicle) then
			localVehId = vehicle
		elseif (vehicle ~= 0) and (savedVehicle ~= vehicle) then
			localVehId = vehicle			
		elseif (vehicle == 0) then
			localVehId = savedVehicle
		end
	end
		
	if(localVehId and localVehId ~= 0)then
		local localVehPlateTest = GetVehicleNumberPlateText(localVehId)
		if localVehPlateTest ~= nil then
			local localVehPlate = string.lower(localVehPlateTest)
			local newVehPlate = string.gsub(tostring(localVehPlate), "%s", "")
			local localVehLockStatus = GetVehicleDoorLockStatus(localVehId)
			TriggerServerEvent("esx_locksystem:haveKeys", myID, newVehPlate)
			Wait(250)
			if isTheCarOwner then
				if(time > timer)then
					if(IsPedInAnyVehicle(ply, true))then
						toggleLocksInVehicle(ply, localVehLockStatus, localVehId)
					else
						toggleLocksOutsideVehicle(ply, localVehLockStatus, localVehId)
					end
				else
					TriggerEvent("esx_locksystem:notify", _U("lock_cooldown", (timer / 1000)))
				end
			else
				TriggerEvent("esx_locksystem:notify", _U("not_owned"))
			end
		else
			TriggerEvent("esx_locksystem:notify", _U("could_not_find_plate"))
		end
	end
end

function toggleLocksInVehicle(ply, localVehLockStatus, localVehId)
	if localVehLockStatus <= 2 then
		lockVehicle()
	elseif localVehLockStatus > 2 then
		unlockVehicle()
	end
end

function toggleLocksOutsideVehicle(ply, localVehLockStatus, localVehId)
	if localVehLockStatus <= 2 then
	
		local lib = "anim@mp_player_intmenu@key_fob@"
		local anim = "fob_click"

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(ply, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		end)

		Wait(250)
		lockVehicle(ply, localVehId)
	elseif localVehLockStatus > 2 then
	
		local lib = "anim@mp_player_intmenu@key_fob@"
		local anim = "fob_click"

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(ply, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		end)

		Wait(250)
		unlockVehicle(ply, localVehId)
	end
end

function lockVehicle(ply, localVehId)
	SetVehicleDoorsLocked(localVehId, 4)
	SetVehicleDoorsLockedForAllPlayers(localVehId, 1)
	RollUpWindow(localVehId, 0)
	RollUpWindow(localVehId, 1)
	RollUpWindow(localVehId, 2)
	RollUpWindow(localVehId, 3)
	TriggerEvent("esx_locksystem:notify", _U("vehicle_locked"))
	time = 0
end

function unlockVehicle(localVehId)
	SetVehicleDoorsLocked(localVehId, 1)
	SetVehicleDoorsLockedForAllPlayers(localVehId, false)
	TriggerEvent("esx_locksystem:notify", _U("vehicle_unlocked"))
	time = 0
end

function getRandomMsg()
    msgNb = math.random(1, #Config.randomMsg)
    return Config.randomMsg[msgNb]
end

function Notify(text, duration)
	if(Config.notification)then
		if(Config.notification == 1)then
			if(not duration)then
				duration = 0.080
			end
			SetNotificationTextEntry("STRING")
			AddTextComponentString(text)
			Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_LIFEINVADER", "CHAR_LIFEINVADER", true, 1, "ESX LockSystem" .. _VERSION, "\"Lock All Your Doors\"", duration)
			DrawNotification_4(false, true)
		elseif(Config.notification == 2)then
			TriggerEvent('chatMessage', '^1ESX LockSystem' .. _VERSION, {255, 255, 255}, text)
		else
			return
		end
	else
		return
	end
end

-----------------------------------------------------------------------------------------
---                                      THREADS                                      ---
-----------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
		local myID = GetPlayerServerId(PlayerId())
		TriggerServerEvent("esx_locksystem:UpdateVehicles", myID)
		Wait(30000)
    end
end)

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
    while true do
		Wait(0)
		
		if (Config.useKeyFob) then
		
			if (isTheCarOwner) then
				SendNUIMessage({type = 'carConnected'})
				
				if (GetIsVehicleEngineRunning(localVehId)) then
					SendNUIMessage({type = 'engineOn'})
				else
					SendNUIMessage({type = 'engineOff'})
				end

				if (GetVehicleDoorLockStatus > 2) then
					SendNUIMessage({type = 'locked'})
				else
					SendNUIMessage({type = 'unlocked'})
				end

			else
				SendNUIMessage({type = 'carDisconnected'})
				SendNUIMessage({type = 'engineOff'})
				SendNUIMessage({type = 'unlocked'})
			end
		end

		if(IsControlJustPressed(1, Config.hotkey))then
			if(Config.useKeyFob) then
				if(keyFobOpen) then
					SetNuiFocus(false, false)
					SendNUIMessage({type = 'closeAll'})
					keyFobOpen = false
				else
					SetNuiFocus(true, true)
					SendNUIMessage({type = 'openKeyFob'})
					keyFobOpen = true
				end
			else
				doLockSystemToggleLocks()
			end
        end
    end
end)

Citizen.CreateThread(function()
    timer = Config.lockTimer * 1000
    time = 0
	while true do
		Wait(1000)
		time = time + 1000
	end
end)

if(Config.disableCar_NPC)then
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            local ped = GetPlayerPed(-1)
            if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
                local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
                local lock = GetVehicleDoorLockStatus(veh)
                if lock == 7 then
                    SetVehicleDoorsLocked(veh, 2)
                end
                local pedd = GetPedInVehicleSeat(veh, -1)
                if pedd then
                    SetPedCanBeDraggedOut(pedd, false)
                end
            end
        end
    end)
end


