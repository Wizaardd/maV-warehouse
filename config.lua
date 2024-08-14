MVS = {}

MVS.Settings = {
    Locale = "en",
    Warehouse_Buy_Money_Type = "bank", -- cash
    Inventory = "qb-inventory", -- ox_inventory, other

    OxInventorySettings = {
        slots = 50,
        weight = 10000
    }
}


MVS.Notify = function(a,b,c)
    lib.notify({
        title = a,
        description = b,
        type = c
    })
end

MVS.OpenStash = function(k)

    if MVS.Settings == "qb-inventory" then
        local other = {}
        other.maxweight = 10000 
        other.slots = 50 
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "Stash_"..MVS.Warehouse[k].name.."_"..k, other)
        TriggerEvent("inventory:client:SetCurrentStash", "Stash_"..MVS.Warehouse[k].name.."_"..k)    
    elseif MVS.Settings == "ox_inventory" then
        exports.ox_inventory:openInventory('stash', {id=MVS.Warehouse[k].name..""..k})
    elseif MVS.Settings == "other" then
        -- you code
    end
end




MVS.Warehouse = {
    [1] = {
        coords = vector3(159.21, -2944.57, 7.24),
        price = 2000,
        blip = {
            sprite = 474,
            display = 4,
            scale = 0.5,
            colour = 3
        }
    },
    [2] = {
        coords = vector3(159.24, -2928.29, 7.24),
        price = 2000,
        blip = {
            sprite = 474,
            display = 4,
            scale = 0.5,
            colour = 3
        }
    }
}



