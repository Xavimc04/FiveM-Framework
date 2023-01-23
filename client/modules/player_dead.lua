Core.Functions.RevivePlayer = function()
    local Player = PlayerPedId()
    local pCoords = GetEntityCoords(Player) 

    NetworkResurrectLocalPlayer(pCoords.x, pCoords.y, pCoords.z, GetEntityHeading(Player), true, false)
    Core.Functions.SetCoords(pCoords)
    SetPlayerInvincible(Player, false)
    ClearPedBloodDamage(Player) 
    TriggerServerEvent(Events['core:setDeadStatus'], false)
end

Core.Functions.KillPlayer = function() 
    SetEntityHealth(PlayerPedId(), 0)
    TriggerServerEvent(Events['core:setDeadStatus'], true)
end