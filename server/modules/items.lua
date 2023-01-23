-- @ Status items
CreateThread(function()
    for i,v in pairs(Config.Items) do 
        if v.status ~= nil then 
            Core.Functions.RegisterUsableItem(i, function(src, slot) 
                local Player = Core.Functions.GetPlayerById(src) 
    
                if Player then 
                    if slot ~= nil then 
                        Player.removeInventoryItem(i, 1, slot) 
                    else
                        Player.removeInventoryItem(i, 1)
                    end
                    
                    Player.addStatus(v.status, v.percent)
                    TriggerClientEvent('core:useFood', src, v.prop, v.status)
                end
            end)
        end
    end
end)