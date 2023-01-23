Core.Glovebox = {}

Core.Functions.Glovebox = function()
    local self = {}  

    self.GenerateSlots = function()
        for i = 1, Config.Core['glovebox'] do  
            Core.Glovebox[i] = {
                data = false   
            }    
        end
    end 

    self.UseSlot = function(slotId) 
        if Core.Glovebox[slotId].data then 
            if Config.Items[Core.Glovebox[slotId].data.item] then 
                TriggerServerEvent('core:useItem', Core.Glovebox[slotId].data.item, Core.Glovebox[slotId].data.slot)
            elseif Config.Weapons[Core.Glovebox[slotId].data.item] then
                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('weapon_unarmed') then    
                    GiveWeaponToPed(PlayerPedId(), GetHashKey(Core.Glovebox[slotId].data.item), Core.Glovebox[slotId].data.info.bullets, false, true)  
                    SetPedAmmoByType(PlayerPedId(), GetPedAmmoTypeFromWeapon(PlayerPedId(), GetHashKey(Core.Glovebox[slotId].data.item)), Core.Glovebox[slotId].data.info.bullets)
                    Core.Functions.SetAllWeaponComponents(Core.Glovebox[slotId].data)  
                    Core.Glovebox[slotId].using = true  
                elseif GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(Core.Glovebox[slotId].data.item) then   
                    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Core.Glovebox[slotId].data.item)) 
                    Core.Glovebox[slotId].using = false     
                else
                    Core.Functions.SendNotify(Locales[Config.Core['locales']]['keep_gun_before'])
                end  
            end

            exports['fm_hotbar']:Update()
        else
            Core.Functions.SendNotify(Locales[Config.Core['locales']]['empty_slot'])
        end
    end 

    self.AsignItemToSlot = function(itemData)  
        local FreeSlot = self.GetFreeSlot()

        if FreeSlot then 
            Core.Glovebox[FreeSlot].data = itemData 
            exports['fm_hotbar']:Update()
        else
            Core.Functions.SendNotify(Locales[Config.Core['locales']]['no_free_slots'])
        end
    end

    self.RemoveItemFromSlot = function(item, identifier) 
        for i,v in pairs(Core.Glovebox) do
            if v.data then 
                if v.data.item == item and v.data.info.identifier == identifier then 
                    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(item) then
                        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(item)) 
                    end

                    Core.Glovebox[i].data = false  
                    exports['fm_hotbar']:Update()
                end
            end 
        end
    end
    
    self.ModifySlotData = function(newData, identifier)  
        for i,v in pairs(Core.Glovebox) do
            if v.data then  
                if v.data.info.identifier == identifier then   
                    Core.Glovebox[i].data = newData 
                    return true 
                end
            end
        end

        return false
    end 

    self.ModifyBulletsFromSlot = function(slot, bullets) 
        Core.Glovebox[slot].data.info.bullets = bullets
    end 

    self.ItemInGlovebox = function(item)
        for i,v in pairs(Core.Glovebox) do
            if v.data then 
                if v.data.item == item then 
                    return v.data  
                end
            end
        end

        return false 
    end

    self.GetFreeSlot = function()  
        for i = 1, #Core.Glovebox do  
            if not Core.Glovebox[i].data then  
                return i 
            end
        end

        return false 
    end 

    self.GetGlovebox = function()
        return Core.Glovebox
    end

    return self 
end

Core.Functions.Glovebox().GenerateSlots()