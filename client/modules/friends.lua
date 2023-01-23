-- @threads
CreateThread(function()
    while true do 
        local msec = 1000 
        local Player = PlayerPedId()
        local pCoords = GetEntityCoords(Player)   

        if Core.PlayerData then  
            for i,v in pairs(GetActivePlayers()) do 
                local TargetId = GetPlayerPed(v) 
                
                if TargetId ~= Player then 
                    if #(pCoords - GetEntityCoords(TargetId)) < 5 then 
                        msec = 0

                        local TargetCoords = GetEntityCoords(TargetId)

                        for b,c in pairs(Core.SvPlayers) do  
                            if c.source == GetPlayerServerId(v) then 
                                local Friend = false  

                                if json.encode(Core.PlayerData.metadata.friends) ~= '[]' then 
                                    for m,n in pairs(Core.PlayerData.metadata.friends) do 
                                        if n.license == c.license then 
                                            Core.Functions.FloatingText("~p~#"..c.permid..' ~w~'..c.identity.firstname..' '..c.identity.lastname, vector3(TargetCoords.x, TargetCoords.y, TargetCoords.z + 1))
                                            Friend = true  
                                        end

                                        if m == #Core.PlayerData.metadata.friends and not Friend then 
                                            Core.Functions.FloatingText("~p~#"..c.permid..' ~w~ '..Locales[Config.Core['locales']]['friend_unknown'], vector3(TargetCoords.x, TargetCoords.y, TargetCoords.z + 1))
                                        end
                                    end
                                else 
                                    Core.Functions.FloatingText("~p~#"..c.permid..' ~w~ '..Locales[Config.Core['locales']]['friend_unknown'], vector3(TargetCoords.x, TargetCoords.y, TargetCoords.z + 1))
                                end
                            end 
                        end 
                    end 
                end
            end 
        end
        
        Wait(msec)
    end
end)

RegisterCommand(Config.Core['friend_command'], function(source, args)
    if #args == 1 and tonumber(args[1]) > 0 then
        local founded = false
        for i,v in pairs(Core.Functions.GetPlayerData().metadata.friends) do
            if v.permid == args[1] then
                founded = true
            end
        end
        if founded then
            Core.Functions.SendNotify("Ya tienes a este jugador en tu lista de amigos.")
        else
            TriggerServerEvent(Events['friends:sendRequest'], tonumber(args[1]))
        end
    end
end) 

RegisterNetEvent('friends:receiveRequest', function(playerName, playerId) 
    Core.Functions.CreateMenu({
        { label = Locales[Config.Core['locales']]['yes'], value = 'yes' }, 
        { label = Locales[Config.Core['locales']]['no'], value = 'no' }, 
    }, function(data)
        if data.element.value == 'yes' then 
            TriggerServerEvent(Events['friends:acceptRequest'], playerName, playerId)
            Core.Functions.CloseMenu()
        end
    end, (Locales[Config.Core['locales']]['friend_accept']):format(playerName)) 
end) 