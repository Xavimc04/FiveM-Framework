RegisterNetEvent('core:client:loaded', function(playerData, playerSkin)
    SetEntityVisible(PlayerPedId(), false)
    Core.PlayerLoaded = true 
    Core.PlayerData = nil
    
    for i,v in pairs(Core.Glovebox) do 
        if Core.Glovebox[i].data then 
            Core.Glovebox[i] = {
                data = false,
                using = false,
            }
        end
    end

    while Core.PlayerData == nil do  
        Core.PlayerData = Core.Functions.CloneTable(playerData)  
        Wait(100)
    end

    if json.encode(Core.PlayerData.metadata.skin) ~= '[]' then   
        Core.Functions.Skin:LoadPlayerSkin(Core.PlayerData.metadata.skin) 
    else  
        Core.Functions.Skin:LoadPlayerSkin(nil, true) 
    end

    Core.Functions.RenderTextures(vector3(Core.PlayerData.metadata.position.x, Core.PlayerData.metadata.position.y, Core.PlayerData.metadata.position.z), 1)
    SetEntityCoords(PlayerPedId(), Core.PlayerData.metadata.position.x, Core.PlayerData.metadata.position.y, Core.PlayerData.metadata.position.z)
    SetEntityHeading(PlayerPedId(), Core.PlayerData.metadata.position.w) 


    FreezeEntityPosition(PlayerPedId(), false)

    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
    SetMaxWantedLevel(0)
    RemoveAllPedWeapons(PlayerPedId())
    SetEntityVisible(PlayerPedId(), true)
    ShutdownLoadingScreen()

    if Core.PlayerData.metadata.dead == true then 
        Core.Functions.KillPlayer()
        Core.Functions.SendNotify(Locales[Config.Core['locales']]['disconnected_dead'])
    end

    if Core.PlayerData.metadata.dimension ~= 0 then 
        Core.Functions.SendDimension(Core.PlayerData.metadata.dimension)
    end 

    TriggerServerEvent('core:onPlayerLoad')
end) 

RegisterNetEvent('core:sendAlert', function(message)
    Core.Functions.SendAlert(message)
end)

RegisterNetEvent('core:sendNotify', function(message)
    Core.Functions.SendNotify(message)
end)

RegisterNetEvent('core:useFood', function(prop, status)
    if not Config.PropPlacement[prop] then
        return
    end
    local food = prop
    RequestModel(food)
    while not HasModelLoaded(food) do
        Wait(1)
    end
    prop_food = CreateObject(GetHashKey(food), GetEntityCoords(PlayerPedId()), true, true, false)
    AttachEntityToEntity(prop_food, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), Config.PropPlacement[prop].boneIndex), Config.PropPlacement[prop].x, Config.PropPlacement[prop].y, Config.PropPlacement[prop].z, Config.PropPlacement[prop].xR, Config.PropPlacement[prop].yR, Config.PropPlacement[prop].zR, 1, 1, 0, 0, 2, 1)
    if status == 'hunger' then
        TriggerServerEvent("core:syncAnims", 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', {blendInSpeed = 8.0, blendOutSpeed = -8, duration = 2000, flag = 49, action = 'hunger', clear_as_second = true})
        Wait(3000)
        ClearPedSecondaryTask(PlayerPedId())
        DeleteObject(prop_food)
    elseif status == 'thirst' then
        TriggerServerEvent("core:syncAnims", 'mp_player_intdrink', 'loop_bottle', {blendInSpeed = 1.0, blendOutSpeed = -1.0, duration = 2000, flag = 49, action = 'thirst', clear_as_second = true})
        Wait(3000)
        ClearPedSecondaryTask(PlayerPedId())
        DeleteObject(prop_food)
    end
end)

RegisterNetEvent('core:syncAnim', function(playerId, animDict, anim, options)
    local ped = GetPlayerPed(GetPlayerFromServerId(playerId))
    RequestAnimDict(animDict)  
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
    TaskPlayAnim(ped, animDict, anim, (options.blendInSpeed or 8.0), (options.blendOutSpeed or -8), (options.duration or 2000), (options.flag or 0), 0, 0, 0, 0)
    if options.clear_as_second then
        Wait(1000)
        ClearPedSecondaryTask(PlayerPedId())
    end
end)

RegisterNetEvent('core:renewData', function(newData)
    Core.PlayerData = newData  
    
    -- He metido esta vaina por si se rompe el code :)
    TriggerEvent('interface:refreshInventory')
end)

RegisterNetEvent('core:client:updateClientPlayers', function(newPlayerData, completeData) 
    if newPlayerData then 
        Core.SvPlayers[newPlayerData.source] = newPlayerData 
    end

    if completeData then 
        Core.SvPlayers = completeData 
    end
end)

RegisterNetEvent('core:syncPickUps', function(newPickUps, object)
    SetEntityAsMissionEntity(object, false, false)
    DeleteObject(object)
    Core.PickUps = newPickUps
end)

RegisterNetEvent("core:revivePlayer", function()
    Core.Functions.RevivePlayer()
end)

RegisterNetEvent('core:killPlayer', function()
    Core.Functions.KillPlayer()
end)

RegisterNetEvent('core:spawnVehicle', function(model)
    local Player = PlayerPedId()
    local pCoords = GetEntityCoords(Player)

    Core.Functions.SpawnVehicle(model, pCoords, GetEntityHeading(Player), function(pVehicle)
        TaskWarpPedIntoVehicle(Player, pVehicle, -1)
    end)
end)

RegisterNetEvent('core:deleteInArea', function(radius)
    Core.Functions.DeleteVehiclesInArea(radius)
end)

RegisterNetEvent('core:fixVehicle', function()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    SetVehicleFixed(vehicle)
end)

RegisterNetEvent('core:nativeText', function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time or 1, 1)
end)

RegisterNetEvent('core:tpm', function()
    local blipMarker = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blipMarker) then
        Core.Functions.SendNotify("Selecciona un punto en el mapa.")
        return 'marker'
    end

    local ped, coords = PlayerPedId(), GetBlipInfoIdCoord(blipMarker)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldCoords = GetEntityCoords(ped)

    local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
    local found = false
    if vehicle > 0 then
        FreezeEntityPosition(vehicle, true)
    else
        FreezeEntityPosition(ped, true)
    end

    for i = Z_START, 0, -25.0 do
        local z = i
        if (i % 2) ~= 0 then
            z = Z_START - i
        end

        NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
        local curTime = GetGameTimer()
        while IsNetworkLoadingScene() do
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end
        NewLoadSceneStop()
        SetPedCoordsKeepVehicle(ped, x, y, z)

        while not HasCollisionLoadedAroundEntity(ped) do
            RequestCollisionAtCoord(x, y, z)
            if GetGameTimer() - curTime > 1000 then
                break
            end
            Wait(0)
        end

        found, groundZ = GetGroundZFor_3dCoord(x, y, z, false);
        if found then
            Wait(0)
            SetPedCoordsKeepVehicle(ped, x, y, groundZ)
            break
        end
        Wait(0)
    end

    if vehicle > 0 then
        FreezeEntityPosition(vehicle, false)
    else
        FreezeEntityPosition(ped, false)
    end

    if not found then
        SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
        return false
    end

    SetPedCoordsKeepVehicle(ped, x, y, groundZ)
    return true
end)

RegisterNetEvent('core:additionalPickup', function(value, quant, complete) 
    local type

    if Config.Items[value] then 
        type = 'item'
    elseif Config.Weapons[value] then 
        type = 'weapon'
    end
 
    Core.Functions.PlayAnimation('pickup_object', 'pickup_low', 2000) 
    Core.Functions.SendNotify('¡No tienes espacio en los bolsillos y se está cayendo todo!')
    Core.Functions.CreatePickUp(type, value, quant, GetEntityCoords(PlayerPedId()), complete, nil, false, true)
end)