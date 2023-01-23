RegisterNetEvent(Events['friends:sendRequest'], function(TargetId)
    local Player = Core.Functions.GetPlayerById(source)
    local TargetPlayer = Core.Functions.GetPlayerFromPermId(TargetId)

    if TargetPlayer.permid ~= Player.permid then 
        if TargetPlayer then 
            TriggerClientEvent('friends:receiveRequest', TargetPlayer.source, Player.identity.firstname..' '..Player.identity.lastname, Player.source)
        end 
    end 
end)

RegisterNetEvent(Events['friends:acceptRequest'], function(targetName, targetId) 
    local Player = Core.Functions.GetPlayerById(source)
    local TargetPlayer = Core.Functions.GetPlayerById(targetId)

    Player.addFriend(TargetPlayer.license, TargetPlayer.identity.firstname..' '..TargetPlayer.identity.lastname, TargetPlayer.permid)
    TargetPlayer.addFriend(Player.license, Player.identity.firstname..' '..Player.identity.lastname, Player.permid) 

    Player.sendNotify((Locales[Config.Core['locales']]['friend_accepted_from']):format(TargetPlayer.identity.firstname, TargetPlayer.identity.lastname))
    TargetPlayer.sendNotify((Locales[Config.Core['locales']]['friend_accepted_by']):format(Player.identity.firstname, Player.identity.lastname)) 
end)