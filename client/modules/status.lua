Core.Status = function()
    local self = {}

    self.initTick = function()  
        if Core.PlayerLoaded then  
            TriggerServerEvent('core:tickStatus')
        end

        if Core.PlayerData ~= nil then  
            if Core.PlayerData.metadata.hunger < 10 and Core.PlayerData.metadata.hunger > 0 then 
                Core.Functions.SendNotify('~r~'..Locales[Config.Core['locales']]['hungry'])
            end

            if Core.PlayerData.metadata.thirst < 10 and Core.PlayerData.metadata.thirst > 0 then 
                Core.Functions.SendNotify('~r~'..Locales[Config.Core['locales']]['thirsty'])
            end

            if Core.PlayerData.metadata.hunger == 0 or Core.PlayerData.metadata.thirst == 0 then 
                if Core.PlayerData.metadata.dead == false then 
                    Core.Functions.KillPlayer()
                    Core.Functions.SendNotify('~r~'..Locales[Config.Core['locales']]['fainting'])
                end 
            end 
        end
        
        SetTimeout(60000 * Config.Core['status'].tick, self.initTick)
    end

    return self 
end

Core.Status().initTick()