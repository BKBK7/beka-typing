local players = {}

local dotCycle = {".", "..", "..."}
local currentDotIndex = 1
local currentDot = dotCycle[currentDotIndex]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        currentDotIndex = (currentDotIndex % #dotCycle) + 1
        currentDot = dotCycle[currentDotIndex]
    end
end)

Citizen.CreateThread(function()
	while true do
		local localPlayerPed = PlayerPedId()
		local localCoords = GetEntityCoords(localPlayerPed)
	
		for serverId, data in pairs(players) do
			if data.open then
				local otherPlayer = GetPlayerFromServerId(serverId)
				if NetworkIsPlayerActive(otherPlayer) then
					local otherPed = GetPlayerPed(otherPlayer)
					if DoesEntityExist(otherPed) then
						local otherCoords = GetEntityCoords(otherPed)
						local headCoords = IsPedMale(otherPed) and GetWorldPositionOfEntityBone(otherPed, 167) or GetWorldPositionOfEntityBone(otherPed, 247)
						if #(localCoords - otherCoords) < 8.0 then
							DrawText3Dot(headCoords.x, headCoords.y, headCoords.z, currentDot)
						end
					end
				end
			end
		end
		Citizen.Wait(0)
	end
end)

function DrawText3Dot(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z+0.23)
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFontForCurrentCommand(1)
        SetTextColor(255, 255, 255, 255)
        SetTextCentre(true)
        DisplayText(CreateVarString(10, "LITERAL_STRING", '~o~[~r~'..text..'~o~]~r~'), _x, _y)
    end
end

RegisterNetEvent("beka-typing:client:updateState")
AddEventHandler("beka-typing:client:updateState", function(serverId, open)
    if not players[serverId] then
        players[serverId] = {}
    end
    players[serverId].open = open
end)

-- TriggerServerEvent('beka-typing:server:typingStatus', true)