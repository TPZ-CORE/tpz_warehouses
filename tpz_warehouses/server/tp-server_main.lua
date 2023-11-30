
TPZ         = {}
TPZInv      = exports.tpz_inventory:getInventoryAPI()

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_warehouses:requestWarehouseLocationData")
AddEventHandler("tpz_warehouses:requestWarehouseLocationData", function(currentIndex)
  local _source         = source
  local xPlayer         = TPZ.GetPlayer(_source)

  local identifier      = xPlayer.getIdentifier()
  local charidentifier  = xPlayer.getCharacterIdentifier()
  
  local containerName   = identifier .. "_" .. charidentifier

  exports["ghmattimysql"]:execute("SELECT id FROM containers WHERE name = @name", { ["@name"] = currentIndex .. "_" .. containerName}, function(result)
  
    if result[1] and result[1].id then
      TriggerClientEvent('tpz_warehouses:updateWarehouseLocationData', _source, result[1].id)
    else
      TriggerClientEvent('tpz_warehouses:updateWarehouseLocationData', _source, nil)
    end

  end)

end)

RegisterServerEvent("tpz_warehouses:buyWarehouse")
AddEventHandler("tpz_warehouses:buyWarehouse", function(warehouse, title, cost, weight, currency)
  local _source         = source

  local xPlayer         = TPZ.GetPlayer(_source)

	local identifier      = xPlayer.getIdentifier()
	local charidentifier  = xPlayer.getCharacterIdentifier()

  local containerName   = identifier .. "_" .. charidentifier

  if currency == "dollars" then
    local money = xPlayer.getAccount(0)

    if cost <= money then
  
      xPlayer.removeAccount(0, cost)
  
      local Parameters = { ['name'] = warehouse .. "_" .. containerName, ['weight'] = weight }
      exports.ghmattimysql:execute("INSERT INTO `containers` ( `name`, `weight`) VALUES ( @name, @weight)", Parameters)
  
      TriggerClientEvent("tpz_core:sendRightTipNotification", _source, "~q~You successfully bought " .. title .. " for ~o~$" ..cost .. " dollars.", 3000)

      TriggerEvent("tpz_inventory:registerContainerInventory", warehouse .. "_" .. containerName, weight) -- Register the new container on tpz_inventory.

    else
      TriggerClientEvent("tpz_core:sendRightTipNotification", _source, Locales['NOT_ENOUGH_MONEY'], 3000)
    end

  else

    local gold = xPlayer.getAccount(2)

    if cost <= gold then
  
      xPlayer.removeAccount(2, cost)
  
      local Parameters = { ['name'] = warehouse .. "_" .. containerName, ['weight'] = weight }
      exports.ghmattimysql:execute("INSERT INTO `containers` ( `name`, `weight`) VALUES ( @name, @weight)", Parameters)
  
      TriggerClientEvent("tpz_core:sendRightTipNotification", _source, "~q~You successfully bought " .. title .. " for ~o~(G) " ..cost .. " Gold.", 3000)

      TriggerEvent("tpz_inventory:registerContainerInventory", warehouse .. "_" .. containerName, weight) -- Register the new container on tpz_inventory.

    else
      TriggerClientEvent("tpz_core:sendRightTipNotification", _source, Locales['NOT_ENOUGH_GOLD_MONEY'], 3000)
    end

  end

end)

RegisterServerEvent("tpz_warehouses:sellWarehouse")
AddEventHandler("tpz_warehouses:sellWarehouse", function(warehouse, title, currentId, cost)
  local _source         = source
  local xPlayer         = TPZ.GetPlayer(_source)

  exports.ghmattimysql:execute("DELETE FROM containers WHERE id = @id", { ["id"] = currentId })

  local sellAmount = cost * Config.SellWarehouseTAX / 100
  xPlayer.addAccount(0, sellAmount)

  TriggerClientEvent("tpz_core:sendRightTipNotification", _source, string.format(Locales['SOLD_WAREHOUSE'], title, sellAmount, 3000))

end)

RegisterServerEvent("tpz_warehouses:createWarehouseKeys")
AddEventHandler("tpz_warehouses:createWarehouseKeys", function(warehouse, currentId)
  local _source         = source

  local xPlayer         = TPZ.GetPlayer(_source)

	--local identifier      = xPlayer.getIdentifier()
	--local charidentifier  = xPlayer.getCharacterIdentifier()
  local lastname        = xPlayer.getLastName()

  TPZInv.addItem(_source, Config.WarehouseKeyItem, 1, lastname .. " #" .. currentId, { keyId = currentId })

  TriggerClientEvent("tpz_core:sendRightTipNotification", _source, Locales['CREATED_KEY_COPY'], 3000)
end)