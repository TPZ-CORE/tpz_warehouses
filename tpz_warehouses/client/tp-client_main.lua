

local ClientData = { currentIndex = nil, currentId = 0, requestedCheck = false, checked = false, bought = false }

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_warehouses:updateWarehouseLocationData')
AddEventHandler("tpz_warehouses:updateWarehouseLocationData", function(warehouseId)

    ClientData.bought  = false

    -- If does warehouse exist and has bought.
    if warehouseId then
        ClientData.currentId = warehouseId
        ClientData.bought    = true 
    end

    ClientData.checked = true

end)

-----------------------------------------------------------
--[[ Threads  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
    CreatePrompts()

    while true do
        Citizen.Wait(0)
        local sleep  = true
        local player = PlayerPedId()
        local coords = GetEntityCoords(PlayerPedId())

        local isDead = IsEntityDead(player)

        if not isDead then

            for index, warehouseConfig in pairs(Config.Locations) do
               
                if not warehouseConfig.BlipHandle and warehouseConfig.Blips.Enabled then
                    AddBlip(index)
                end

                local coordsDist = vector3(coords.x, coords.y, coords.z)
                local coordsStore = vector3(warehouseConfig.Coords.x, warehouseConfig.Coords.y, warehouseConfig.Coords.z)
                local distance = #(coordsDist - coordsStore)

                -- Creating marker on the warehouse location (If enabled).
                if warehouseConfig.Marker.Enabled and distance <= warehouseConfig.Marker.DisplayDistance then
                    sleep = false
                    local dr, dg, db, da = warehouseConfig.Marker.RGBA.r, warehouseConfig.Marker.RGBA.g, warehouseConfig.Marker.RGBA.b, warehouseConfig.Marker.RGBA.a
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, warehouseConfig.Coords.x, warehouseConfig.Coords.y, warehouseConfig.Coords.z , 0, 0, 0, 0, 0, 0, 1.7, 1.7, 0.4, dr, dg, db, da, 0, 0, 2, 0, 0, 0, 0)
                end

                if distance <= warehouseConfig.ActionDistance then
                    sleep = false
                    
                    ClientData.currentIndex = index

                    if not ClientData.checked and not ClientData.requestedCheck then
                        ClientData.requestedCheck = true
                        TriggerServerEvent("tpz_warehouses:requestWarehouseLocationData", index)
                    end

                    if ClientData.checked then

                        local label = CreateVarString(10, 'LITERAL_STRING', string.format(Locales['WAREHOUSE_BUYING_PROMPT_DISPLAY'], warehouseConfig.Title, warehouseConfig.Price, warehouseConfig.GoldPrice, warehouseConfig.WeightLabel))

                        if ClientData.bought then
                            label = CreateVarString(10, 'LITERAL_STRING', warehouseConfig.Title)
                        end

                        PromptSetActiveGroupThisFrame(Prompts, label)

                        for i, prompt in pairs (PromptsList) do

                            PromptSetVisible(prompt.prompt, 0)

                            if ClientData.bought then

                                if prompt.action == "OPEN_PERSONAL_WAREHOUSE" or prompt.action == "OPEN_OTHER_WAREHOUSE" or prompt.action == "CREATE_WAREHOUSE_KEYS" or prompt.action == "SELL_WAREHOUSE" then
                                    PromptSetVisible(prompt.prompt, 1)
                                end

                            else

                                if prompt.action == "OPEN_OTHER_WAREHOUSE" or prompt.action == "BUY_WAREHOUSE" or prompt.action == "BUY_GOLD_WAREHOUSE" then
                                    PromptSetVisible(prompt.prompt, 1)
                                end

                            end

                            if PromptHasHoldModeCompleted(prompt.prompt) then

                                if prompt.action == "OPEN_PERSONAL_WAREHOUSE" then

                                    local nearestPlayers = GetNearestPlayers(2.5)

                                    local foundPlayer = false
    
                                    for _, player in pairs(nearestPlayers) do
                                        if player ~= PlayerId() then
                                            foundPlayer = true
                                        end
                                    end
    
                                    Wait(250)
    
                                    if not foundPlayer then

                                        TriggerEvent("tpz_inventory:openInventoryContainerById", ClientData.currentId, warehouseConfig.Title, false)

                                        Wait(2000)
                                    else
                                        TriggerEvent("tpz_core:sendRightTipNotification", Locales['SOMEONE_CLOSE'], 3000)
                                    end

                                elseif prompt.action == "OPEN_OTHER_WAREHOUSE" then

                                    local inputData = {
                                        title = "Warehouse - Open Warehouse ",
                                        desc = Locales['KEY_INPUT'],
                                        buttonparam1 = "ACCEPT",
                                        buttonparam2 = "DECLINE"
                                    }
                                    
                                    TriggerEvent("tp_inputs:getTextInput", inputData, function(cb)

                                        local inputId = tonumber(cb)
    
                                        if inputId ~= nil and inputId ~= 0 and inputId > 0 then
    
                                            TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_warehouses:hasWarehouseKey", function(hasKey)
    
                                                Wait(1000)
    
                                                if hasKey then
    
                                                    local nearestPlayers = GetNearestPlayers(2.5)
    
                                                    local foundPlayer = false
                    
                                                    for _, player in pairs(nearestPlayers) do
                                                        if player ~= PlayerId() then
                                                            foundPlayer = true
                                                        end
                                                    end
                    
                                                    Wait(250)
                                                    
                                                    if not foundPlayer then
    
                                                        TriggerEvent("tpz_inventory:openInventoryContainerById", inputId, warehouseConfig.Title, false)

                                                        Wait(2000)
                                                    else
                                                        TriggerEvent("tpz_core:sendRightTipNotification", Locales['SOMEONE_CLOSE'], 3000)
                                                    end
                                                end
                                            end, cb)
    
                                        else
                                           TriggerEvent("tpz_core:sendRightTipNotification", Locales['NOT_VALID_WAREHOUSE_KEY_INPUT'], 3000)
                                        end
    
                                    end) 

                                elseif prompt.action == "CREATE_WAREHOUSE_KEYS" then

                                    local inputData = {
                                        title = "Warehouse - Keys",
                                        desc = Locales['create_key_copy'],
                                        buttonparam1 = "ACCEPT",
                                        buttonparam2 = "DECLINE"
                                    }
                                
                                    TriggerEvent("tp_inputs:getButtonInput", inputData, function(cb)
    
                                        if cb == "ACCEPT" then
                                            TriggerServerEvent("tpz_warehouses:createWarehouseKeys", index, ClientData.currentId)
    
                                            Wait(4000)
                                        end
                                    end) 

                                elseif prompt.action == "SELL_WAREHOUSE" then

                                    local inputData = {
                                        title = "Warehouse - Sell ",
                                        desc = "Are you sure you want to sell your warehouse? You will receive " .. Config.SellWarehouseTax .. "% of the default price.",
                                        buttonparam1 = "ACCEPT",
                                        buttonparam2 = "DECLINE"
                                    }

                                    TriggerEvent("tp_inputs:getButtonInput", inputData, function(cb)
                                        if cb == "ACCEPT" then

                                            TriggerServerEvent("tpz_warehouses:sellWarehouse", index, warehouseConfig.Title, ClientData.currentId, warehouseConfig.Price)

                                            Wait(4000)

                                            ClientData.requestedCheck = false
                                            ClientData.checked        = false
                                        end

                                    end) 

                                elseif prompt.action == "BUY_WAREHOUSE" then

                                    local inputData = {
                                        title = "Warehouse - Buy ",
                                        desc = "Are you sure you want to buy this warehouse? The cost is $" .. warehouseConfig.Price .. " dollars.",
                                        buttonparam1 = "ACCEPT",
                                        buttonparam2 = "DECLINE"
                                    }
    
                                    TriggerEvent("tp_inputs:getButtonInput", inputData, function(cb)
    
                                        if cb == "ACCEPT" then
 
                                            TriggerServerEvent("tpz_warehouses:buyWarehouse", index, warehouseConfig.Title, warehouseConfig.Price, warehouseConfig.Weight, "dollars")
                                            Wait(4000)

                                            ClientData.requestedCheck = false
                                            ClientData.checked        = false
                                        end
                                    end) 

                                elseif prompt.action == "BUY_GOLD_WAREHOUSE" then

                                    local inputData = {
                                        title = "Warehouse - Buy ",
                                        desc = "Are you sure you want to buy this warehouse? The cost is (G) " .. warehouseConfig.GoldPrice .. " Gold.",
                                        buttonparam1 = "ACCEPT",
                                        buttonparam2 = "DECLINE"
                                    }
    
                                    TriggerEvent("tp_inputs:getButtonInput", inputData, function(cb)
    
                                        if cb == "ACCEPT" then

                                            TriggerServerEvent("tpz_warehouses:buyWarehouse", index, warehouseConfig.Title, warehouseConfig.GoldPrice, warehouseConfig.Weight, "gold")
                                            Wait(4000)

                                            ClientData.requestedCheck = false
                                            ClientData.checked        = false
                                        end
                                    end) 

                                end

                                Wait(2000)

                            end
    
                        end 
                    end
                end

            end
        end

        if sleep then
            ClientData = {currentIndex = nil, currentId = 0, requestedCheck = false, checked = false, bought = false}
            Citizen.Wait(1250)
        end
    end
end)
