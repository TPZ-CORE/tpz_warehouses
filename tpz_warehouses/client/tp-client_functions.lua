
Prompts       = GetRandomIntInRange(0, 0xffffff)
PromptsList   = {}

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for i, v in pairs(Config.Locations) do
        if v.BlipHandle then
            RemoveBlip(v.BlipHandle)
        end
    end

end)


-----------------------------------------------------------
--[[ Blips  ]]--
-----------------------------------------------------------

AddBlip = function(index)
    local data = Config.Locations[index]

    data.BlipHandle = N_0x554d9d53f696d002(1664425300, data.Coords.x, data.Coords.y, data.Coords.z)

    SetBlipSprite(data.BlipHandle, data.Blips.Sprite, 1)
    SetBlipScale(data.BlipHandle, 0.1)
    Citizen.InvokeNative(0x9CB1A1623062F402, data.BlipHandle, data.Blips.Title)

end


-----------------------------------------------------------
--[[ Prompts  ]]--
-----------------------------------------------------------

CreatePrompts = function()

    for index, tprompt in pairs (Config.PromptsKeys) do

        local str      = tprompt.label
        local keyPress = tprompt.key
    
        local dPrompt = PromptRegisterBegin()
        PromptSetControlAction(dPrompt, keyPress)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(dPrompt, str)
        PromptSetEnabled(dPrompt, 1)
        PromptSetVisible(dPrompt, 1)
        PromptSetStandardMode(dPrompt, 1)
        PromptSetHoldMode(dPrompt, 1000)
        PromptSetGroup(dPrompt, Prompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, dPrompt, true)
        PromptRegisterEnd(dPrompt)
    
        table.insert(PromptsList, {prompt = dPrompt, action = index})
    end

end

-----------------------------------------------------------
--[[ General Functions  ]]--
-----------------------------------------------------------

function GetNearestPlayers(distance)
	local closestDistance = distance
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local closestPlayers = {}

	for _, player in pairs(GetActivePlayers()) do
		local target = GetPlayerPed(player)

		if target ~= playerPed then
			local targetCoords = GetEntityCoords(target, true, true)
			local distance = #(targetCoords - coords)

			if distance < closestDistance then
				table.insert(closestPlayers, player)
			end
		end
	end
	return closestPlayers
end