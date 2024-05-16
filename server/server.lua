MVS_C = exports["maV_core"]:getSharedObject()



maV_Warehouse = {}
WarehouseData = LoadResourceFile(GetCurrentResourceName(), "./data/warehouse.json") 
maV_Warehouse = json.decode(WarehouseData)

RegisterNetEvent('maV-warehouse:SourceSync', function()
    TriggerClientEvent('maV-warehouse:Sync', source, maV_Warehouse)
end)

MVS_C.RegisterServerCallback('maV-warehouse:Open_Warehouse', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local warehousenumber = data[1]
    local warehouse = MVS.Warehouse[warehousenumber]

    if maV_Warehouse[warehousenumber] ~= nil then
        cb(maV_Warehouse[warehousenumber])
    else
        cb("2")
    end
end)


AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        for k,v in pairs(maV_Warehouse) do
            local stash = {
                id = v.name..""..k,
                label = v.name.."_"..k,
                slots = 50,
                weight = 100000,
                owner = false
            }
             
            exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
        end
    end

end)


MVS_C.RegisterServerCallback('maV-warehouse:Buy_Warehouse', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local warehousenumber = data[2]
    local warehouse = MVS.Warehouse[warehousenumber]
    local money = 0
    if MVS.Settings.Warehouse_Buy_Money_Type == "bank" then money = xPlayer.getBank() else money = xPlayer.getMoney() end

    if maV_Warehouse[warehousenumber] == nil then
        if money >= warehouse.price then
            if MVS.Settings.Warehouse_Buy_Money_Type == "bank" then  xPlayer.removeBank(warehouse.price) else  xPlayer.removeMoney(warehouse.price) end

            data[1].OwnerIdentifier = xPlayer.identifier
            maV_Warehouse[warehousenumber] = data[1]
            SaveResourceFile(GetCurrentResourceName(), "./data/warehouse.json", json.encode(maV_Warehouse, { indent = true }), -1)
            TriggerClientEvent('maV-warehouse:Sync', -1, maV_Warehouse)
            cb(true)
        else
            cb(false)
        end
        
    end
end)


MVS_C.RegisterServerCallback('maV-warehouse:CheckPassword', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local warehousenumber = data[1]
    local warehouse = MVS.Warehouse[warehousenumber]

    if maV_Warehouse[warehousenumber] ~= nil then
        if maV_Warehouse[warehousenumber].password == data[2] then
            cb(true)
        else
            cb(false)
        end
    end

end)