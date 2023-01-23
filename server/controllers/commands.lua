Core.Functions.CreateCommand('setjob', function(src, args, player)
    if #args == 3 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then 
            Target.setJob(args[2], tonumber(args[3])) 
        end
    end
end, {help = Locales[Config.Core['locales']]['command_give_job'], args = {
    {name = "ID", help = "ID"},
    {name = Locales[Config.Core['locales']]['command_job'], help = Locales[Config.Core['locales']]['command_job']},
    {name = Locales[Config.Core['locales']]['command_rank'], help = Locales[Config.Core['locales']]['command_rank']},
}}, {has_perms = true, type = "admin", rank = "mod"})

Core.Functions.CreateCommand('setrank', function(src, args, player)
    if #args == 2 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then 
            Target.setRank(args[2]) 
        end  
    end
end, {help = Locales[Config.Core['locales']]['command_give_perms'], args = {
    {name = "ID", help = "ID"},
    {name = Locales[Config.Core['locales']]['command_rank'], help = Locales[Config.Core['locales']]['command_rank']},
}}, {has_perms = true, type = "admin", rank = "root"})

Core.Functions.CreateCommand('giveitem', function(src, args, player)
    if #args == 3 then
        local quant = tonumber(args[3])
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then
            Target.addInventoryItem(args[2], tonumber(quant))
        end  
    end
end, {help = Locales[Config.Core['locales']]['command_give_item'], args = {
    {name = "ID", help = "ID"},
    {name = Locales[Config.Core['locales']]['command_item'], help = Locales[Config.Core['locales']]['command_item']},
    {name = Locales[Config.Core['locales']]['quantity'], help = Locales[Config.Core['locales']]['quantity']},
}}, {has_perms = true, type = "admin", rank = "mod"})

Core.Functions.CreateCommand('givemoney', function(src, args, player)
    if #args == 3 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then 
            Target.addAccountMoney(args[2], tonumber(args[3]))
        end  
    end 
end, {help = Locales[Config.Core['locales']]['command_give_money'], args = {
    {name = "ID", help = "ID"},
    {name = Locales[Config.Core['locales']]['account'], help = Locales[Config.Core['locales']]['account']},
    {name = Locales[Config.Core['locales']]['quantity'], help = Locales[Config.Core['locales']]['quantity']},
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('setmoney', function(src, args, player)
    if #args == 3 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then 
            Target.setAccountMoney(args[2], tonumber(args[3]))
        end  
    end 
end, {help = Locales[Config.Core['locales']]['command_set_money'], args = {
    {name = "ID", help = "ID"},
    {name = Locales[Config.Core['locales']]['account'], help = Locales[Config.Core['locales']]['account']},
    {name = Locales[Config.Core['locales']]['quantity'], help = Locales[Config.Core['locales']]['quantity']},
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('heal', function(src, args, player)
    if #args == 1 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then 
            Target.setStatus('hunger', 100)
            Target.setStatus('thirst', 100)
        end  
    end 
end, {help = Locales[Config.Core['locales']]['command_heal'], args = {
    {name = "ID", help = "ID"},
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('revive', function(src, args, player)
    if #args == 0 then
        player.setStatus('hunger', 100)
        player.setStatus('thirst', 100)

        player.clientEvent('core:revivePlayer')
    elseif #args == 1 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then 
            Target.setStatus('hunger', 100)
            Target.setStatus('thirst', 100)

            Target.clientEvent('core:revivePlayer')
        end  
    end
end, {help = Locales[Config.Core['locales']]['command_revive'], args = {
    {name = "ID", help = "ID"},
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('kill', function(src, args, player)
    if #args == 1 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then  
            Target.clientEvent('core:killPlayer')
        end  
    end
end, {help = Locales[Config.Core['locales']]['command_kill'], args = {
    {name = "ID", help = "ID"},
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('skin', function(src, args, player)
    if #args == 1 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then  
            Target.clientEvent('fm_clothing:openMenu') 
        end 
    else
        player.clientEvent('fm_clothing:openMenu') 
    end 
end, {help = Locales[Config.Core['locales']]['command_open_skin_menu'], args = {
    {name = "ID", help = "ID"},
}}, {has_perms = true, type = "admin", rank = "mod"})

Core.Functions.CreateCommand('car', function(src, args, player)
    if #args == 1 then 
        TriggerClientEvent('core:spawnVehicle', player.source, args[1]) 
    else
        player.sendNotify(Locales[Config.Core['locales']]['incorrect_format_car'])
    end
end, {help = Locales[Config.Core['locales']]['command_spawn_vehicle'], args = {
    {name = Locales[Config.Core['locales']]['command_model'], help = Locales[Config.Core['locales']]['command_model']},
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('dv', function(src, args, player)
    TriggerClientEvent('core:deleteInArea', player.source, tonumber(args[1]) or 1) 
end, {help = Locales[Config.Core['locales']]['command_dv'], args = {
    {name = Locales[Config.Core['locales']]['command_dist'], help = Locales[Config.Core['locales']]['command_dist']},
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('givecar', function(src, args, player)
    if #args == 2 then 
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then  
            Target.clientEvent('core:spawnVehicle', args[2])
        end  
    else
        player.sendNotify(Locales[Config.Core['locales']]['incorrect_format_givecar'])
    end 
end, {help = Locales[Config.Core['locales']]['command_give_car'], args = {
    {name = "ID", help = "ID"},
    {name = Locales[Config.Core['locales']]['command_model'], help = Locales[Config.Core['locales']]['command_model']}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('noclip', function(src, args, player)
    player.clientEvent('noclip:ToggleNoClip')
end, {help = Locales[Config.Core['locales']]['command_noclip'], args = {}}, {has_perms = true, type = "admin", rank = "mod"})

Core.Functions.CreateCommand('kick', function(src, args, player)
    if #args >= 2 then
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then
            local reason = table.concat(args, ' ', 2)
            Target.kick(reason)
        else
            player.sendNotify(Locales[Config.Core['locales']]['no_connected_player'])
        end
    else
        player.sendNotify(Locales[Config.Core['locales']]['incorrect_format_kick'])
    end
end, {help = Locales[Config.Core['locales']]['command_kick'], args = {
    {name = "ID", help = "ID"},
    {name = Locales[Config.Core['locales']]['command_reason'], help = Locales[Config.Core['locales']]['command_reason']}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('goto', function(src, args, player)
    if #args == 1 then
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then  
            local Target_Coords = GetEntityCoords(GetPlayerPed(Target.source))
            local Player = GetPlayerPed(src)
            SetEntityCoords(Player, Target_Coords)
        end
    end 
end, {help = Locales[Config.Core['locales']]['command_goto'], args = {
    {name = "ID", help = "ID"}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('bring', function(src, args, player)
    if #args == 1 then
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then  
            local Player_Coords = GetEntityCoords(GetPlayerPed(src))
            local Target = GetPlayerPed(Target.source)
            SetEntityCoords(Target, Player_Coords)
        end
    end 
end, {help = Locales[Config.Core['locales']]['command_bring'], args = {
    {name = "ID", help = "ID"}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('freeze', function(src, args, player)
    if #args == 1 then
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then  
            local Target = GetPlayerPed(Target.source)
            FreezeEntityPosition(Target, true)
        end
    end 
end, {help = Locales[Config.Core['locales']]['command_freeze'], args = {
    {name = "ID", help = "ID"}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('unfreeze', function(src, args, player)
    if #args == 1 then
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target then  
            local Target = GetPlayerPed(Target.source)
            FreezeEntityPosition(Target, false)
        end
    end
end, {help = Locales[Config.Core['locales']]['command_unfreeze'], args = {
    {name = "ID", help = "ID"}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('saveall', function(src, args, player)
    for i,v in pairs(Core.Players) do 
        Core.Functions.SavePlayer(Core.Players[i].source)
    end 
end, {help = Locales[Config.Core['locales']]['command_saveall'], args = {
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('fix', function(src, args, player)
    player.clientEvent('core:fixVehicle')
end, {help = Locales[Config.Core['locales']]['command_fixveh'], args = {
}}, {has_perms = true, type = "admin", rank = "mod"})

Core.Functions.CreateCommand('tpm', function(src, args, player)
    player.clientEvent('core:tpm')
end, {help = "Teletransporte a un punto", args = {}}, {has_perms = true, type = "admin", rank = "mod"})

Core.Functions.CreateCommand('tp', function(src, args, player)
    if args[1] and args[2] and args[3] then
        local ply = GetPlayerPed(src)
        SetEntityCoords(ply, tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
        player.sendNotify("Te has hecho TP")
    else
        player.sendNotify("Te faltan argumentos")
    end
end, {help = "TP a coords XYZ", args = {
    {name = "X", help = "X"},
    {name = "Y", help = "Y"},
    {name = "Z", help = "Z"}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('setdimension', function(src, args, player)
    if #args == 2 then
        local Target = Core.Functions.GetPlayerFromPermId(tonumber(args[1]))

        if Target and tonumber(args[2]) >= 0 then   
            Target.sendDimension(tonumber(args[2]))
            exports['pma-voice']:updateRoutingBucket(Target.source, tonumber(args[2])) 
        end
    end 
end, {help = Locales[Config.Core['locales']]['command_bring'], args = {
    {name = "ID", help = "ID"} ,
    {name = "Dimension", help = "Dimension"}
}}, {has_perms = true, type = "admin", rank = "admin"})

Core.Functions.CreateCommand('syncEvents', function(src, args, player)
    Events = exports['fm_security']:get()
    TriggerClientEvent('fm_security:sync', -1, exports['fm_security']:get())
    player.sendNotify("Eventos sincronizados")
end, {help = "Sincroniza los eventos", args = {}}, {has_perms = true, type = "admin", rank = "master"})