

exports.tpz_core:rServerAPI().addNewCallBack("tpz_warehouses:hasWarehouseKey", function(source, cb, id)
    local _source = source

	local keyItem = TPZInv.getItemQuantity(_source, Config.WarehouseKeyItem)

    if keyItem and keyItem > 0 then

        local inventory = TPZInv.getInventoryContents(_source)

        for k, v in pairs (inventory) do
            
            if v.item == Config.WarehouseKeyItem then
    
                if tonumber(v.metadata.keyId) == tonumber(id) then

                    exports["ghmattimysql"]:execute("SELECT name FROM containers WHERE id = @id", { ["@id"] = tonumber(id)}, function(result)

                        if result[1] then
                            cb(true)
                            return
                        else
                            TriggerClientEvent("tpz_core:sendRightTipNotification", _source, Locales['NOT_CORRECT_KEYS'], 3000)
                        end
                
                    end)

                end

            end
        end
    else

        TriggerClientEvent("tpz_core:sendRightTipNotification", _source, Locales['NO_KEYS'], 3000)

        cb(false)
        return
    end

    cb(false)
end)