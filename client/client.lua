MVS_C = exports["maV_core"]:getSharedObject()

MVS_LOCAL = {
    all_blips = {},
}

CreateThread(function()
    TriggerServerEvent('maV-warehouse:SourceSync')

end)

RegisterNetEvent('maV-warehouse:Sync', function(a)
    for k,v in pairs(a) do
        if MVS.Warehouse[k] ~= nil then
            MVS.Warehouse[k] = v
            MVS.Warehouse[k].coords = vector3(v.coords.x,v.coords.y,v.coords.z)
            MVS.Warehouse[k].blip.sprite = 473
        end
    end
    Create_Refresh_Blip()
end)


Create_Refresh_Blip = function()

    if #MVS_LOCAL.all_blips > 0 then
        for i=1, #MVS_LOCAL.all_blips do
            RemoveBlip(MVS_LOCAL.all_blips[i])	
        end
        MVS_LOCAL.all_blips = {}
    end
   

    for k,v in pairs(MVS.Warehouse) do
		name = ""
		
		if v.name ~= nil then
			name = v.name
		else
			name =  TranslateCap('warehouse_text', k)
		end
		
		local blip = AddBlipForCoord(v.coords)
		SetBlipSprite (blip, v.blip.sprite)
		SetBlipDisplay(blip, v.blip.display)
		SetBlipScale  (blip, v.blip.scale)
		SetBlipColour (blip, v.blip.colour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(blip)
		table.insert(MVS_LOCAL.all_blips, blip)

		
				
	end
end

CreateThread(function()
    while true do 
        wait = 2000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for k,v in pairs(MVS.Warehouse) do 
            if #(pedCoords - v.coords) < 4 then
                wait = 1
                local text = ""
                if v.name ~= nil then
                    text = v.name
                else
                    text =  TranslateCap('warehouse_text', k)
                end

                if #(pedCoords - v.coords) < 1.5 then
                    text = "[E] "..text
                    if IsControlJustReleased(1, 51)  then
                        Open_Warehouse(k)
                    end
                end
                DrawText3D(v.coords.x, v.coords.y, v.coords.z, text)
            end
        end
        Wait(wait)
    end
end)

Open_Warehouse = function(k)
    MVS_C.TriggerServerCallback('maV-warehouse:Open_Warehouse', {k}, function(d)
        if d == "2" then
            Open_Warehouse_Purchasing(k)
        else
            Open_Warehouse_Menu(k)
        end
    
    end)
end


Open_Warehouse_Purchasing = function(k)
    lib.registerContext({
        id = 'purchasing',
        title = TranslateCap('warehouse_text', k),
        options = {
            {
                title = TranslateCap('warehouse_buy_menu_buy_now', MVS.Warehouse[k].price),
                icon = 'check',
                onSelect = function()
                    Warehouse_Name(k)
                end,
                
            },
            {
                title = TranslateCap('warehouse_buy_menu_cancel'),
                icon = 'x',
                onSelect = function()
                    
                end,
               
            },
        }
    })
    lib.showContext('purchasing')

end


Warehouse_Name = function(k)
    local input = lib.inputDialog(TranslateCap('warehouse_text', k), {
        {type = 'input', label = TranslateCap('warehouse_input_warehouse_name'),  required = true, min = 4, max = 25, icon = 'hashtag'},
        {type = 'input', password = true, label = TranslateCap('warehouse_input_warehouse_password'),  required = true, min = 4, max = 8, icon = 'lock'},
        {type = 'checkbox', label = TranslateCap('warehouse_input_warehouse_checkbox'),  required = true},
    })

    if not input then

    else
        data = {
            {
                OwnerIdentifier = "",
                coords = MVS.Warehouse[k].coords,
                price = MVS.Warehouse[k].price,
                name = input[1],
                password = input[2],
                blip =  MVS.Warehouse[k].blip
            },
            k
        }
        MVS_C.TriggerServerCallback('maV-warehouse:Buy_Warehouse', data, function(ss)
            if ss then
                MVS.Notify(
                    'Success',
                    TranslateCap('warehouse_buy_complated'),
                    'success'
                )
            else
                MVS.Notify(
                    'Success',
                    TranslateCap('warehouse_buy_no_money'),
                    'success'
                )
            end
        end)
    end
end


Open_Warehouse_Menu = function(k)
    lib.registerContext({
        id = 'purchasing',
        title = MVS.Warehouse[k].name,
        options = {
            {
                title = TranslateCap('warehouse_open'),
                icon = 'check',
                onSelect = function()
                    Open_Warehouse_Inventory(k)
                end,
                
            },
            {
                title = TranslateCap('warehouse_open_cancel'),
                icon = 'x',
                onSelect = function()
                    
                end,
               
            },
        }
    })
    lib.showContext('purchasing')

end

Open_Warehouse_Inventory = function(k)
    local input = lib.inputDialog(MVS.Warehouse[k].name, {
        {type = 'input', password = true, label = TranslateCap('warehouse_open_password'),  required = true, icon = 'lock'},
    })


    if not input then

    else
        MVS_C.TriggerServerCallback('maV-warehouse:CheckPassword', {k, input[1]}, function(dd)
            if dd then
                MVS.OpenStash(k)
            else
                MVS.Notify(
                    'Error',
                    TranslateCap('warehouse_open_not_password'),
                    'error'
                )
            end
        
        end)
    end
end




function DrawText3D(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.30, 0.30)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 250
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end