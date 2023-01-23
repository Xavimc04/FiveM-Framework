Core = {}
Core.PlayerLoaded = false 
Core.PlayerData = nil 
Core.PickUps = {} 
Core.Functions = {} 
Core.SvPlayers = {} 
Core.Callbacks = {}
Core.RegisteredItems = {}
Events = {}

-- @ Pickups loop
CreateThread(function()
    while true do
        local msec = 1000 
        
        if Core.PlayerLoaded then 
            local Player = PlayerPedId()
            local pCoords = GetEntityCoords(Player) 
    
            for i,v in pairs(Core.PickUps) do  
                if #(pCoords - v.coords.xyz) < 2.5 then  
                    msec = 0

                    local label = Core.Functions.GetItemLabel(v.value) or v.value   

                    if Core.Functions.GetItemData(v.value) then
                        if Core.Functions.GetItemData(v.value).specialId then  
                            label = Core.Functions.GetItemLabel(v.value)..'~w~ (~p~'..v.complete.identifier..'~w~)'
                        end 
                    end

                    Core.Functions.FloatingText('Presiona ~p~E~w~ para coger ~p~'..label, vector3(v.coords.x, v.coords.y, v.coords.z - 0.7))

                    if IsControlJustPressed(0, 38) then 
                        TriggerServerEvent('core:deletePickUp', i, v, v.object) 
                        Core.Functions.PlayAnimation('pickup_object', 'pickup_low', 2000) 
                        Wait(2000)
                    end
                end
            end
        end

        Wait(msec) 
    end
end)

-- @ Main loop
-- @ Don't touch the wait, pls...
CreateThread(function()
    while true do
        local msec = 1000
        local Player = PlayerPedId()

        -- @ Set bullets when shooting and remove weapon if does not exist...
        if IsPedArmed(Player, 4) then
            msec = 10
            if IsPedShooting(Player) then  
                local weaponFounded = false 

                for i,v in pairs(Core.PlayerData.inventory) do 
                    if GetSelectedPedWeapon(Player) == GetHashKey(v.item) then 
                        weaponFounded = true 
                        local newBullets = GetPedAmmoByType(Player, GetPedAmmoTypeFromWeapon(Player, GetHashKey(v.item)))
                        TriggerServerEvent(Events['core:setWeaponComponent'], v.slot, 'bullets', newBullets) 
                    end
                end

                if not weaponFounded then  
                    RemoveAllPedWeapons(PlayerPedId(), false)
                end
            end
        end 

        -- @ Anti get weapons
        if IsPedArmed(Player, 4) then
            local weaponFounded = false 

            for i,v in pairs(Core.PlayerData.inventory) do 
                if GetSelectedPedWeapon(Player) == GetHashKey(v.item) then 
                    weaponFounded = true
                end
            end

            if not weaponFounded then  
                RemoveAllPedWeapons(PlayerPedId(), false)
            end
        end

        -- onPlayerDeath 
        if IsEntityDead(Player) or IsPlayerDead(Player) then
            Core.Functions.KillPlayer()
        end 

        Wait(msec)
    end
end)

-- @ Glovebox 
CreateThread(function()
    for i = 1, Config.Core['glovebox'] do     
        RegisterCommand('slot'..i, function()
            local slotId = i 

            if Core.PlayerData ~= nil then 
                local playerInv = Core.PlayerData.inventory
    
                for i,v in pairs(playerInv) do 
                    if v.slot == slotId then 
                        if v.item then 
                            if Config.Items[v.item] then 
                                TriggerServerEvent('core:useItem', v.item, v.slot)
                            elseif Config.Weapons[v.item] then
                                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('weapon_unarmed') then    
                                    GiveWeaponToPed(PlayerPedId(), GetHashKey(v.item), v.info.bullets, false, true)  
                                    SetPedAmmoByType(PlayerPedId(), GetPedAmmoTypeFromWeapon(PlayerPedId(), GetHashKey(v.item)), v.info.bullets)
                                    Core.Functions.SetAllWeaponComponents(v)   
                                elseif GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(v.item) then   
                                    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(v.item))  
                                else
                                    Core.Functions.SendNotify(Locales[Config.Core['locales']]['keep_gun_before'])
                                end  
                            end 
                        end
    
                        break 
                    end
                end
            end 
        end)

        RegisterKeyMapping('slot'..i, Locales[Config.Core['locales']]['glovebox_slot']..i, 'keyboard', tostring(i))
    end
end)

-- @import
getCoreData = function()
    return Core 
end

-- @securityEvents
RegisterNetEvent('fm_security:sync', function(ev)
    Events = ev
end)