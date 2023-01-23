-- @ Connection handler
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source 
    deferrals.defer()
    deferrals.update((Locales[Config.Core['locales']]['check_banlist']):format(name))

    local license  = "Not Connected" 

    for k,v in pairs(GetPlayerIdentifiers(player)) do  
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = string.sub(v, 9) 
        end
    end
    
    deferrals.done()
end) 

AddEventHandler('playerDropped', function(reason)
    if Core.Players[source] then 
        Core.Functions.LeavePlayer(source) 
    end
end)

-- @ Use item
RegisterNetEvent('core:useItem', function(item, inventorySlot)  
    Core.Functions.UseItem(source, item, inventorySlot)
end)

-- @ Create pickups
RegisterNetEvent('core:createPickUp', function(type, value, quant, coords, complete, slot, remove, object, additional) 
    local Player = Core.Functions.GetPlayerById(source)
    local successful = false
 
    if additional then 
        successful = true 
    else
        if remove == nil or remove then 
            if type == 'money' then 
                successful = Player.removeAccountMoney('money', quant)
            elseif type == 'item' then 
                successful = Player.removeInventoryItem(value, quant, slot) 
            elseif type == 'weapon' then 
                successful = Player.removeInventoryItem(value, 1, slot)
            end
        end
    end

    if successful then
        if type ~= 'weapon' then 
            table.insert(Core.PickUps, { 
                object = object,
                type = type,
                value = value,
                quant = quant,
                coords = coords,
                complete = complete,
                propIdentifier = Core.Functions.GetRandomSerial()
            })
        else
            table.insert(Core.PickUps, { 
                object = object,
                type = type,
                value = value,
                quant = quant,
                coords = coords,
                complete = complete,
                propIdentifier = Core.Functions.GetRandomSerial()
            })
        end

        TriggerClientEvent('core:syncPickUps', -1, Core.PickUps)
    else
        print("[^2fm_core^7] ^7[^1ERROR^7] [^3core:createPickUp^7] ^7Player ^5"..GetPlayerName(Player.source).."^7 tried to create a pickup but ^1failed^7")
    end
end)

-- @ Delete pickup
RegisterNetEvent('core:deletePickUp', function(pickupId, pickupData, obj) 
    local Player = Core.Functions.GetPlayerById(source) 

    if pickupData.type == 'money' then 
        Player.addAccountMoney('money', pickupData.quant)
    elseif pickupData.type == 'item' then  
        Player.addInventoryItem(pickupData.value, pickupData.quant, pickupData.complete)
    elseif pickupData.type == 'weapon' then  
        Player.addInventoryItem(pickupData.value, pickupData.quant, pickupData.complete)
    end

    table.remove(Core.PickUps, pickupId)
    TriggerClientEvent('core:syncPickUps', -1, Core.PickUps, obj)
end)

-- @ Set player dead status 
RegisterNetEvent(Events['core:setDeadStatus'], function(bool) 
    local Player = Core.Functions.GetPlayerById(source) 
    Player.setDead(bool)
end)

-- @ Send player to bucket
RegisterNetEvent(Events['core:sendToBucket'], function(dimensionId, vehicle)  
    local Player = Core.Functions.GetPlayerById(source) 
    Player.sendDimension(dimensionId)
    exports['pma-voice']:updateRoutingBucket(source, dimensionId)

    if vehicle ~= nil then 
        SetEntityRoutingBucket(NetworkGetEntityFromNetworkId(vehicle), dimensionId)
    end
end)

RegisterNetEvent(Events['core:revivePlayer'], function(id)
    local player = Core.Functions.GetPlayerById(id)
    player.clientEvent('core:revivePlayer')
end)

-- @ Tick status
RegisterNetEvent('core:tickStatus', function()
    local Player = Core.Functions.GetPlayerById(source)

    if Player then 
        Player.removeStatus('hunger', 1)
        Player.removeStatus('thirst', 1)
    end
end)

-- @ Set component to weapon  
RegisterNetEvent(Events['core:setWeaponComponent'], function(slot, component, value) 
    local Player = Core.Functions.GetPlayerById(source) 
    
    Player.setWeaponData(component, value, slot)
end)

-- @ Remove item from inventory  
RegisterNetEvent(Events['core:removeInventoryItem'], function(item, quant, slot)  
    local Player = Core.Functions.GetPlayerById(source) 
    local inventorySlot = nil 

    if slot then 
        inventorySlot = slot 
    end
    
    Player.removeInventoryItem(item, quant, inventorySlot)
end)

-- @ Add item from inventory  
RegisterNetEvent(Events['core:addInventoryItem'], function(item, quant)  
    local Player = Core.Functions.GetPlayerById(source)  
    Player.addInventoryItem(item, quant)
    print("received")
end)

-- @ Remove money  
RegisterNetEvent('core:removeAccountMoney', function(account, quant)  
    local Player = Core.Functions.GetPlayerById(source)  
    Player.removeAccountMoney(item, quant)
end)

-- @ Switch item from my inventory to other  
RegisterNetEvent('core:switchItem', function(item, quant, targetId, complete, slot)   
    local Player = Core.Functions.GetPlayerById(source)  
    local Target = Core.Functions.GetPlayerById(targetId)

    if Target then  
        if slot ~= nil then 
            Player.removeInventoryItem(item, quant, slot) 
        else
            Player.removeInventoryItem(item, quant) 
        end

        if complete ~= nil then  
            Target.addInventoryItem(item, tonumber(quant), complete) 
        end
    end
end)

-- @ Change player Skin  
RegisterNetEvent('core:playerSkin:save', function(playerSkin)  
    local Player = Core.Functions.GetPlayerById(source)    
    Player.saveSkin(playerSkin)
end)

-- @ Handlers 
RegisterNetEvent('core:onPlayerLoad', function()
    for i,v in pairs(Core.Commands) do
        TriggerClientEvent('chat:addSuggestion', source, '/'..i, v.suggest.help, v.suggest.args)
    end
end)

RegisterNetEvent('core:syncAnims', function(animDict, anim, options)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent('core:syncAnim', -1, source, animDict, anim, options)
    if options.action and options.action == 'hunger' then
        exports['xsound']:PlayUrlPos(-1, source.."eat", "https://cdn.discordapp.com/attachments/923222710073585744/963445500785348648/sonidocomer.mp3", 0.5, coords, false)
        exports['xsound']:Distance(-1, source.."eat", 3.0)
        Wait(2000)
        exports['xsound']:Destroy(-1, source.."hunger")
    elseif options.action and options.action == 'thirst' then
        exports['xsound']:PlayUrlPos(-1, source.."drink", "https://cdn.discordapp.com/attachments/923222710073585744/963435297373294632/sonidobeber.mp3", 0.5, coords, false)
        exports['xsound']:Distance(-1, source.."drink", 3.0)
        Wait(2000)
        exports['xsound']:Destroy(-1, source.."drink")
    end
end)