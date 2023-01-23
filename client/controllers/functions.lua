-- @ Request model function 
-- @ Params: model hash
Core.Functions.RequestModel = function(modelHash)
    modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(4)
		end
	end

	if cb ~= nil then
		cb()
	end
end

-- @ Set player coords 
-- @ Params: table with coords 
Core.Functions.SetCoords = function(position)
    local x = position.x
    local y = position.y
    local z = position.z 

    SetEntityCoords(PlayerPedId(), x, y, z) 
end

Core.Functions.GetConnectedPlayers = function(position)
    return Core.SvPlayers 
end

-- @ Send a simple alert
-- @ Params: message
Core.Functions.SendAlert = function(message)
	exports['fm_notifications']:Notify(message)
end

-- @ Send a simple alert
-- @ Params: message
Core.Functions.SendNotify = function(message, time)
	exports['fm_notifications']:NotifyNew(message, time)
end

-- @ Help notification
-- @ Params: message
Core.Functions.HelpNotify = function(message, auto_center)
	exports['fm_notifications']:Notify(message, 10)
end

-- @ Creates a new menu
-- @ Params: resource_name, table 
Core.Functions.CreateMenu = function(table, cb, title) 
    exports['fm_menu']:CreateMenu(table, cb, title) 
end

-- @ Make a conversation using native text
-- @ Params: Table of texts and times
Core.Functions.CreateConversation = function(table)
    local self = {}

    self.currentIndx = 1
    self.isConversating = true
    
    function self.getStatus()
        return self.isConversating
    end
    
    function self.conversation()
        if self.isConversating then
            CreateThread(function()
                Core.Functions.NativeText(table[self.currentIndx].msg, table[self.currentIndx].time)
                Wait(table[self.currentIndx].time)
                self.currentIndx = self.currentIndx + 1
                if not table[self.currentIndx] then
                    self.isConversating = false
                    return
                end
                return self.conversation()
            end)
        end
    end
    self.conversation()

    return self
end

-- @ Close the menu
-- @ Params: none
Core.Functions.CloseMenu = function() 
    exports['fm_menu']:CloseMenu()
end

-- @ Get item or weapon label
-- @ Params: item value
Core.Functions.GetItemLabel = function(item)
    if Config.Items[item] then 
        return Config.Items[item].label 
    elseif Config.Weapons[item] then 
        return Config.Weapons[item].label
    end

    return false 
end

-- @ Get item or weapon label
-- @ Params: item value
Core.Functions.GetItemData = function(item)
    if Config.Items[item] then 
        return Config.Items[item] 
    elseif Config.Weapons[item] then 
        return Config.Weapons[item]
    end

    return false 
end

-- @ Get all config
-- @ Params: none
Core.Functions.GetConfig = function()
    return Config 
end

-- @ Returns playerdata on client
-- @ Params: none
Core.Functions.GetPlayerData = function() 
	return Core.PlayerData
end

-- @ Customize the number
-- @ Params: number
Core.Functions.GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())..right
end

-- @ Clone player ped
-- @ Params: none 
Core.Functions.ClonePed = function() 
    CreateThread(function()
        Core.Functions.Blur(true)
        local heading = GetEntityHeading(PlayerPedId())
        SetFrontendActive(true)
        ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)
    
        Wait(1000) 
        SetMouseCursorVisibleInMenus(false)
        ReplaceHudColourWithRgba(117, 0, 0, 0, 0)
        PlayerPedPreview = ClonePed(PlayerPedId(), heading, true, false)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedPreview))
        SetEntityCoords(PlayerPedPreview, x, y, z - 10)
        FreezeEntityPosition(PlayerPedPreview, true)
        SetEntityVisible(PlayerPedPreview, false, false)
        NetworkSetEntityInvisibleToNetwork(PlayerPedPreview, false)
        Wait(200)
        SetPedAsNoLongerNeeded(PlayerPedPreview)
        GivePedToPauseMenu(PlayerPedPreview, 1)
        SetPauseMenuPedLighting(true)
        SetPauseMenuPedSleepState(true)

        print('el clon es este: '..PlayerPedPreview)
        return PlayerPedPreview
    end)
end

-- @ Update player clone
-- @ Params: none 
Core.Functions.UpdateClone = function() 
    PlayerPedPreview = ClonePed(PlayerPedId(), 0, false, true)
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedPreview))
    SetEntityCoords(PlayerPedPreview, x, y, z - 10)
    FreezeEntityPosition(PlayerPedPreview, true)
    SetEntityVisible(PlayerPedPreview, false, false)
    NetworkSetEntityInvisibleToNetwork(PlayerPedPreview, false)
    Wait(200)
    SetPedAsNoLongerNeeded(PlayerPedPreview)
    GivePedToPauseMenu(PlayerPedPreview, 1)
    SetPauseMenuPedLighting(true)
    SetPauseMenuPedSleepState(true)
end 

-- @ Send to other dimension/bucket
-- @ Params: number
Core.Functions.SendDimension = function(dimensionId)
    local Player = PlayerPedId()
    local vehicle = nil 
    
    if IsPedInAnyVehicle(Player) then  
        vehicle = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(Player))
    end

    TriggerServerEvent(Events['core:sendToBucket'], dimensionId, vehicle)
end

-- @ Delete player clone
-- @ Params: none 
Core.Functions.DeleteClone = function()
    if PlayerPedPreview then 
        DeleteEntity(PlayerPedPreview)
        SetFrontendActive(false)
        Core.Functions.Blur(false)
        ReplaceHudColourWithRgba(117, 0, 0, 0, 186)
    end 
end

-- @ Toggle blur effect
-- @ Params: bool
Core.Functions.Blur = function(bool)
	if bool == true then 
        StartScreenEffect('MenuMGIn', 1, true)  
    else
        StopScreenEffect('MenuMGIn')
    end
end

Core.Functions.Round = function(num, numDecimalPlaces)
    local mult = 10 ^ (numRoundNumber or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- @ Open player inventory
-- @ Params: none
-- @ Unfunctional, it's using old version from glovebox. 
Core.Functions.OpenInventory = function()
    Core.TriggerCallback('core:getUsableItems', function(usableItems) 
        local Inventory = {}
    
        -- @ Accounts 
        for i,v in pairs(Core.PlayerData.accounts) do 
            if Config.Accounts[i].inventory then 
                table.insert(Inventory, {
                    label = Config.Accounts[i].label..': ~g~'..Core.Functions.GroupDigits(v)..'$', sub = { 
                        { label = Locales[Config.Core['locales']]['give'], value = 'give_money' }, 
                        { input = Locales[Config.Core['locales']]['quantity'], type = "number", button = Locales[Config.Core['locales']]['drop'], value = 'drop_money' },  
                    }
                })
            end 
        end 

        -- @ Items and Weapons
        if #Core.PlayerData.inventory > 0 then  
            for i,v in pairs(Core.PlayerData.inventory) do  
                if v.item then
                    local myItem = {}
    
                    if v.type == 'item' then  
                        if usableItems[v.item] ~= nil then 
                            table.insert(myItem, { label = Locales[Config.Core['locales']]['use'], value = 'use' })
                        end 
    
                        table.insert(myItem, { input = Locales[Config.Core['locales']]['quantity'], type = "number", button = Locales[Config.Core['locales']]['drop'], value = 'drop_item' })
                    elseif v.type == 'weapon' then 
                        table.insert(myItem, { label = Locales[Config.Core['locales']]['drop'], value = 'drop_weapon' })
                    end
    
                    table.insert(myItem, { label = Locales[Config.Core['locales']]['give'], value = 'give' })
    
                    if not Core.Functions.Glovebox().ItemInGlovebox(v.item) then  
                        table.insert(myItem, { label = Locales[Config.Core['locales']]['assign_key'], value = 'asign' })
                    else
                        local inGlovebox = Core.Functions.Glovebox().ItemInGlovebox(v.item) 
     
                        if inGlovebox.info.identifier == v.info.identifier then
                            table.insert(myItem, { label = Locales[Config.Core['locales']]['remove_key'], value = 'remove' })
    
                            if v.type == 'weapon' then 
                                table.insert(myItem, { label = Locales[Config.Core['locales']]['customize'], value = 'customize' })
                            end
                        end
                    end
    
                    if v.type == 'item' then 
                        local string = Core.Functions.GetItemLabel(v.item)

                        if Config.Items[v.item].specialId then  
                            string = Core.Functions.GetItemLabel(v.item).." ("..v.info.identifier..")"
                        end
                        table.insert(Inventory, 
                            {
                                label = string, 
                                complete = v, 
                                slot = v.slot, 
                                id = i,
                                identifier = v.info.identifier, 
                                item = v.item, 
                                role = v.info.quant, 
                                type = 'item', 
                                sub = myItem
                            }
                        )
                    elseif v.type == 'weapon' then 
                        table.insert(Inventory, 
                            {
                                label = Core.Functions.GetItemLabel(v.item), 
                                slot = v.slot, 
                                complete = v, 
                                id = i, 
                                type = 'weapon', 
                                item = v.item, 
                                role = v.info.bullets,
                                sub = myItem
                            }
                        )
                    end 
                end 
            end
        end 
    
        -- @ Create menu and response
        Core.Functions.CreateMenu(Inventory, function(data)
            if data.parent then  
                if data.element.value == 'use' then 
                    TriggerServerEvent('core:useItem', data.parent.item, data.parent.slot) 
                    Wait(40)
                    Core.Functions.OpenInventory()
                elseif data.element.value == 'customize' then 
                    Core.Functions.CustomizeWeapon(data.parent.complete)
                elseif data.element.value == 'drop_money' then 
                    if data.input ~= nil and tonumber(data.input) > 0 and tonumber(data.input) <= tonumber(Core.PlayerData.accounts.money) then 
                        Core.Functions.CreatePickUp('money', Locales[Config.Core['locales']]['cash'], tonumber(data.input), GetEntityCoords(PlayerPedId()))
                        Core.Functions.PlayAnimation('pickup_object', 'pickup_low', 2000) 
                    end
    
                    Core.Functions.CloseMenu()
                elseif data.element.value == 'drop_item' then 
                    if data.input ~= nil and tonumber(data.input) > 0 and tonumber(data.input) <= tonumber(data.parent.role) then  
                        local table = { identifier = data.parent.identifier }
                        Core.Functions.CreatePickUp('item', data.parent.item, tonumber(data.input), GetEntityCoords(PlayerPedId()), table, data.parent.slot)
                        Core.Functions.PlayAnimation('pickup_object', 'pickup_low', 2000) 
                        Core.Functions.CloseMenu()
                    end
                elseif data.element.value == 'drop_weapon' then 
                    if Core.Functions.Glovebox().ItemInGlovebox(data.parent.item) then 
                        Core.Functions.Glovebox().RemoveItemFromSlot(data.parent.item, data.parent.complete.info.identifier)
                    end
                    
                    Core.Functions.PlayAnimation('pickup_object', 'pickup_low', 2000)
                    Core.Functions.CreatePickUp('weapon', data.parent.item, data.parent.role, GetEntityCoords(PlayerPedId()), data.parent.complete, data.parent.slot)
                    Core.Functions.CloseMenu()
                elseif data.element.value == 'asign' then 
                    Core.Functions.Glovebox().AsignItemToSlot(data.parent.complete)
                    Wait(40)
                    Core.Functions.OpenInventory()
                elseif data.element.value == 'remove' then 
                    Core.Functions.Glovebox().RemoveItemFromSlot(data.parent.item, data.parent.complete.info.identifier) 
                    Wait(40)
                    Core.Functions.OpenInventory()
                elseif data.element.value == 'give' then   
                    if data.parent.type ~= 'weapon' then 
                        if data.input ~= nil and tonumber(data.input) > 0 and tonumber(data.input) <= tonumber(data.parent.role) then   
                            Core.Functions.GiveItemToNearbyPlayer(data.parent.item, data.input, { identifier = data.parent.identifier }, data.parent.slot)
                        end
                    else 
                        Core.Functions.GiveItemToNearbyPlayer(data.parent.item, 1, data.parent.complete, data.parent.slot)
                    end
                end 
            end 
        end, Locales[Config.Core['locales']]['inventory'])
    end)
end

Core.Functions.CreatePickUp = function(type, value, quant, coords, complete, slot, remove, additional)
    complete = complete or nil 
    slot = slot or nil 
    remove = remove or nil 
    additional = additional or false 

    if type == 'money' then  
        Core.Functions.SpawnObject('bkr_prop_moneypack_01a', coords, function(obj)
            SetEntityAsMissionEntity(obj, true, false)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            SetEntityCollision(obj, false, true)
            SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
            TriggerServerEvent('core:createPickUp', type, value, quant, coords, complete, slot, remove, obj)
        end)

    else
        local item = Core.Functions.GetItemData(value)
        local prop = item.prop or 'bkr_prop_duffel_bag_01a'

        Core.Functions.SpawnObject(prop, coords, function(obj)
            SetEntityAsMissionEntity(obj, true, false)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            SetEntityCollision(obj, false, true)
            SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
            TriggerServerEvent('core:createPickUp', type, value, quant, coords, complete, slot, remove, obj, additional)
        end)
    end 
end

-- @ Give item to nearby player 
-- @ Params item 
Core.Functions.GiveItemToNearbyPlayer = function(itemLabel, itemQuant, complete, slot)
    local Player = PlayerPedId()
    local closestPlayer = Core.Functions.GetNearestPlayer() 

    if closestPlayer ~= nil then  
        local closestPlayerId = GetPlayerServerId(closestPlayer)
        local closestPlayerPed = GetPlayerPed(closestPlayer)

        if IsPedOnFoot(closestPlayerPed) and not IsEntityDead(closestPlayerPed) and not IsPedFalling(closestPlayerPed) then 
            if complete ~= nil then 
                TriggerServerEvent('core:switchItem', itemLabel, itemQuant, closestPlayerId, complete, slot) 
            else
                TriggerServerEvent('core:switchItem', itemLabel, itemQuant, closestPlayerId, nil, slot) 
            end 

            Core.Functions.SendNotify(Locales[Config.Core['locales']]['give_item']..itemQuant..' '..Core.Functions.GetItemLabel(itemLabel))
        end 
    else
        return Core.Functions.SendNotify(Locales[Config.Core['locales']]['no_players_nearby'])
    end
end 

-- @ Open glovebox items
-- @ Params: none 
Core.Functions.OpenGlovebox = function()
    local gloveboxItems = {}

    for i,v in pairs(Core.Glovebox) do 
        if v.data then  
            table.insert(gloveboxItems, {
                label = Core.Functions.GetItemLabel(v.data.item), item = v.data.item, role = i, sub = {
                    { label = Locales[Config.Core['locales']]['remove_key'], value = 'remove' }
                } 
            })
        else
            table.insert(gloveboxItems, {
                label = Locales[Config.Core['locales']]['unallocated_space'], role = i 
            })
        end
    end

    Core.Functions.CreateMenu(gloveboxItems, function(data)
        if data.element.value == 'remove' then 
            Core.Functions.Glovebox().RemoveItemFromSlot(data.parent.item) 
            Wait(40)
            Core.Functions.OpenGlovebox()
        end
    end, Locales[Config.Core['locales']]['quick_access'])
end

-- @ Get all server vehicles 
-- @ Params: none 
Core.Functions.GetVehicles = function()
    return GetGamePool('CVehicle')
end

Core.Functions.GetPeds = function(onlyOtherPeds)
    local peds, myPed, pool = {}, PlayerPedId(), GetGamePool('CPed')

	for i=1, #pool do
        if ((onlyOtherPeds and pool[i] ~= myPed) or not onlyOtherPeds) then
			peds[#peds + 1] = pool[i]
        end
    end

	return peds
end

-- @ Get all server objects 
-- @ Params: none 
Core.Functions.GetObjects = function()
    return GetGamePool('CObject')
end

-- @ Get active players
-- @ Params: 
Core.Functions.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
    local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				players[#players + 1] = returnPeds and ped or player
			end
		end
	end

	return players
end

Core.Functions.GetNearestPlayer = function()
    local ped = nil
    local distance = 3.0
    local me = PlayerPedId()

    for i,v in pairs(GetActivePlayers()) do 
        local targetPed = GetPlayerPed(v)
        local localDistance = #(GetEntityCoords(me) - GetEntityCoords(targetPed))
        if (localDistance < distance ) and me ~= targetPed then
            ped = v
        end
    end
    
    return ped
end

-- @ Get vehicles in area
-- @ Params: coordsToSearch, maxDistance 
Core.Functions.GetVehiclesInArea = function(coords, maxDistance)
	return Core.Functions.EnumerateEntitiesInarea(Core.Functions.GetVehicles(), false, coords, maxDistance)
end

-- @ Get vehicles in area
-- @ Params: coordsToSearch, maxDistance 
Core.Functions.GetPlayersInDistance = function(coords, maxDistance)
	return Core.Functions.EnumerateEntitiesInarea(Core.Functions.GetPlayers(), false, coords, maxDistance)
end

-- @ Enumerate entities in area
-- @ Params: Entities table, isPlayers, coordsToSearch, maxDistance
Core.Functions.EnumerateEntitiesInarea = function(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

-- @ Delete a vehicle 
-- @ Params: vehicle as entity
Core.Functions.DeleteVehicle = function(veh)
	SetEntityAsMissionEntity(veh, false, true)
    DeleteVehicle(veh)
end

-- @ Spawns a vehicle
-- @ Params: vehicleModel, coordinates, vehicleCallback
Core.Functions.SpawnVehicle = function(model, coords, heading, callback, bool) 
    if not IsModelInCdimage(model) then 
        return 
    end

    RequestModel(model) 

    while not HasModelLoaded(model) do
        Wait(10)
    end

    bool = bool or true 
    local vehicle = CreateVehicle(model, vector3(coords.x, coords.y, coords.z), heading, bool, true) 
    
    if bool then
        local id = NetworkGetNetworkIdFromEntity(vehicle)
        SetNetworkIdCanMigrate(id, true)
        SetEntityAsMissionEntity(vehicle, true, false)  
    end

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(model)
    SetVehRadioStation(vehicle, 'OFF')
    RequestCollisionAtCoord(coords.xyz) 

    while not DoesEntityExist(vehicle) do 
        Wait(100)
    end 

    if callback then
        callback(vehicle)
    end
    return vehicle
end

-- @ Spawns a local vehicle, other players can't see it.
-- @ Params: vehicleModel, coordinates, vehicleCallback
Core.Functions.SpawnLocalVehicle = function(model, coords, heading, callback)
    Core.Functions.SpawnVehicle(model, coords, heading, callback, false)
end

-- @ Spawns a object
-- @ Params: object, coordinates, objCallback
Core.Functions.SpawnObject = function(object, coords, cb, networked)
	local model = type(object) == 'number' and object or GetHashKey(object)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	networked = networked == nil and true or networked

	CreateThread(function()
		Core.Functions.RequestModel(model)

		local obj = CreateObject(model, vector.xyz, networked, false, true)
		if cb then
			cb(obj)
		end
	end)
end

-- @ Spawns a local object, other players can't see it.
-- @ Params: object, coordinates, vehicleCallback
Core.Functions.SpawnLocalObject = function(object, coords, cb)
	Core.Functions.SpawnObject(object, coords, cb, false)
end

-- @ Delete all vehicles in area 
-- @ Params: radius
Core.Functions.DeleteVehiclesInArea = function(radius)
    radius = tonumber(radius) + 0.01
    local vehicles = Core.Functions.GetVehiclesInArea(GetEntityCoords(PlayerPedId()), radius)

    for i,v in ipairs(vehicles) do
        local attempt = 0

        while not NetworkHasControlOfEntity(v) and attempt < 100 and DoesEntityExist(v) do
            Wait(100)
            NetworkRequestControlOfDoor(v)
            attempt = attempt + 1
        end

        if DoesEntityExist(v) and NetworkHasControlOfEntity(v) then
            Core.Functions.DeleteVehicle(v) 
        end
    end
end 

-- @ Requests animation 
-- @ Params: animation dict
Core.Functions.RequestAnimDict = function(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Wait(2)
		end
	end
end

-- @ Get key number by string
-- @ Params: keyString
Core.Functions.GetKeyNumber = function(key)
    Keys = {
        ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
        ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
        ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
        ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
        ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
        ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
        ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
        ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
        ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
    }

    return Keys[string.upper(key)]
end

Core.Functions.GetClosestObject = function(coords, modelFilter)
	return Core.Functions.GetClosestEntity(Core.Functions.GetObjects(), false, coords, modelFilter)
end

Core.Functions.GetClosestVehicle = function(coords, modelFilter)
	return Core.Functions.GetClosestEntity(Core.Functions.GetVehicles(), false, coords, modelFilter)
end

Core.Functions.GetClosestPed = function(coords, modelFilter)
    return Core.Functions.GetClosestEntity(Core.Functions.GetPeds(true), false, coords, modelFilter)
end

Core.Functions.GetClosestPlayer = function(coords, modelFilter)
    return Core.Functions.GetClosestEntity(Core.Functions.GetPlayers(true, true), false, coords, modelFilter)
end

Core.Functions.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

-- @ Play animation
-- @ Params: animationDict, animation, seconds to end animation 
Core.Functions.PlayAnimation = function(dict, anim, secondsToClear) 
    local Player = PlayerPedId()
    Core.Functions.RequestAnimDict(dict)
    TaskPlayAnim(Player, dict, anim,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(secondsToClear)
    ClearPedTasks(Player)
end

-- @ Set weapon component
-- @ Params: weapon, component
Core.Functions.SetWeaponComponent = function(weapon, component, slot)
    local Player = PlayerPedId()
    if not HasPedGotWeaponComponent(Player, weapon, Config.Weapons[weapon][component]) then 
        GiveWeaponComponentToPed(Player, GetHashKey(weapon), Config.Weapons[weapon][component])
        TriggerServerEvent(Events['core:setWeaponComponent'], slot, component, true)
        TriggerServerEvent(Events['core:removeInventoryItem'], component, 1)
    else
        RemoveWeaponComponentFromPed(Player, GetHashKey(weapon), Config.Weapons[weapon][component])
        TriggerServerEvent(Events['core:setWeaponComponent'], slot, component, false)
        TriggerServerEvent(Events['core:addInventoryItem'], component, 1)
    end
end

-- @ Get if weapon has an specific component 
-- @ Params: weapon, component
Core.Functions.HasComponentSetted = function(weapon, component) 
    if HasPedGotWeaponComponent(PlayerPedId(), weapon, Config.Weapons[weapon][component]) then 
        return true 
    end

    return false 
end

-- @ Weapon data
-- @ Params: wepon data
Core.Functions.SetAllWeaponComponents = function(weapon_data)  
    if weapon_data.info.supressor then 
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon_data.item), Config.Weapons[weapon_data.item]['suppressor'])
    end

    if weapon_data.info.flashlight then 
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon_data.item), Config.Weapons[weapon_data.item]['flash'])
    end

    if weapon_data.info.scope then 
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon_data.item), Config.Weapons[weapon_data.item]['scope'])
    end 
end

-- @ Get if player has an item on inventory
-- @ Params: item
Core.Functions.HasInventoryItem = function(item) 
    for i,v in pairs(Core.PlayerData.inventory) do 
        if v.item == item then 
            return v.info.quant  
        end
    end

    return false 
end

-- @ Set all weapon data (used for inventory)
-- @ Params: weapon data
Core.Functions.CustomizeWeapon = function(data_weapon)   
    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(data_weapon.item) then 
        Core.Functions.CreateMenu({
            { label = Locales[Config.Core['locales']]['alternate_flash'], toggleable = true, value = 'flash' }, 
            { label = Locales[Config.Core['locales']]['alternate_silencer'], toggleable = true, value = 'suppressor' },
            { label = Locales[Config.Core['locales']]['alternate_sight'], toggleable = true, value = 'scope' }, 
        }, function(data)
            if data.element.toggleable ~= nil then  
                if Config.Weapons[data_weapon.item][data.element.value] ~= nil then
                    if not Core.Functions.HasComponentSetted(data_weapon.item, data.element.value) then 
                        if Core.Functions.HasInventoryItem(data.element.value) then 
                            Core.Functions.SetWeaponComponent(data_weapon.item, data.element.value, data_weapon.slot)
                        else
                            Core.Functions.SendNotify(Locales[Config.Core['locales']]['no_item'])
                        end 
                    else
                        Core.Functions.SetWeaponComponent(data_weapon.item, data.element.value, data_weapon.slot)
                    end
                else
                    Core.Functions.SendNotify(Locales[Config.Core['locales']]['no_sight'])
                end 
            end
        end, Locales[Config.Core['locales']]['weapon_upgrades'])
    else
        Core.Functions.SendNotify(Locales[Config.Core['locales']]['no_weapon'])
    end
end

Core.Functions.CloneTable = function(t)
	if type(t) ~= 'table' then return t end

	local meta = getmetatable(t)
	local target = {}

	for k,v in pairs(t) do
		if type(v) == 'table' then
			target[k] = Core.Functions.CloneTable(v) 
		else
			target[k] = v
		end
	end

	setmetatable(target, meta)

	return target
end

Core.Functions.RenderTextures = function(coords, time)
    NewLoadSceneStartSphere(coords, 1000, 0)
    DoScreenFadeOut(time)
    Wait(time)
    DoScreenFadeIn(time)
    return true
end

-- @ Create floating text
-- @ Params: text, coords
Core.Functions.FloatingText = function(text, coords)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	local scale = (0.8 / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.40 * scale)
	SetTextFont(0)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

Core.Functions.RoundNumber = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

Core.Functions.RemoveSpaces = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Core.Functions.AddPropToEntity = function(entity, prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local x,y,z = table.unpack(GetEntityCoords(entity))
  
    Core.Functions.RequestModel(prop1)
  
    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, entity, GetPedBoneIndex(entity, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(prop1)
    return prop
end

Core.Functions.SetVehicleProps = function(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for extraId,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(extraId), 0)
				else
					SetVehicleExtra(vehicle, tonumber(extraId), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

Core.Functions.MySplit = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

Core.Functions.GetVehicleProps = function(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		return { 
			model             = GetEntityModel(vehicle),

			plate             = Core.Functions.RemoveSpaces(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = Core.Functions.RoundNumber(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = Core.Functions.RoundNumber(GetVehicleEngineHealth(vehicle), 1),
			tankHealth        = Core.Functions.RoundNumber(GetVehiclePetrolTankHealth(vehicle), 1),

			fuelLevel         = Core.Functions.RoundNumber(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = Core.Functions.RoundNumber(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,

			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleLivery(vehicle)
		}
	else
		return
	end
end

Core.Functions.GetGlovebox = function() 
    return Core.Glovebox
end

Core.Functions.NativeText = function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time or 1, 1)
end

Core.Functions.ChatMessage = function(color, icon, subtitle, timestamp, msg)
    color = color or 'white'
    icon = icon or 'fa-solid fa-globe'
    subtitle = subtitle or 'Sistema'
    timestamp = timestamp or ''
    msg = msg or 'No se ha proporcionado un texto'
	TriggerEvent('chat:addMessage', { templateId =  'ccChat', multiline =  false, args = { color, icon, subtitle, timestamp, msg } })
end

Core.Functions.GetOnVector = function(table)
    return vector3(table.x, table.y, table.z - 1)
end

Core.Functions.DebugPrint = function(msg)
    if Config.Debug then
        print("[^5fm_core^7] ^2DEBUG^7 - "..msg)
    end
end