-- @ Returns the player license 
-- @ Params: playerSrc
Core.Functions.GetPlayerLicense = function(playerId)
    if playerId then 
        return string.sub(GetPlayerIdentifiers(playerId)[2], 9)
    end
end

-- @ Returns player functions
-- @ Params: playerId
Core.Functions.GetPlayerById = function(playerId)
    if Core.Players[playerId] then 
        return Core.Players[playerId]
    end
end

-- @ Returns id
-- @ Params: permId
Core.Functions.GetPlayerFromPermId = function(permid)
    for k,v in pairs(Core.Players) do
        if(v.permid == permid) then
            return Core.Players[k]
        end
    end 
end

-- @ Debug pring
-- @ Params: message
Core.Functions.DebugPrint = function(message)
    if Config.Core['debug'] then 
        print('^1Core^7: '..message)
    end
end

-- @ Get player coords
-- @ Params: playerId 
Core.Functions.UpdateClassCoords = function(playerId)
    local Player = Core.Functions.GetPlayerById(playerId)

	if Player then 
        local Coords = {
            x = GetEntityCoords(GetPlayerPed(Player.source)).x, 
            y = GetEntityCoords(GetPlayerPed(Player.source)).y, 
            z = GetEntityCoords(GetPlayerPed(Player.source)).z
        }

        Player.updateCoords(Coords)
	end 
end

-- @ Manual player save
-- @ Params: playerId
Core.Functions.LeavePlayer = function(playerId)
    local Player = Core.Functions.GetPlayerById(playerId)
    Core.Functions.UpdateClassCoords(Player.source) 
    
    MySQL.query('UPDATE players SET accounts = ?, inventory = ?, metadata = ? WHERE permid = ?', {
        json.encode(Player.accounts), 
        json.encode(Player.inventory), 
        json.encode(Player.metadata),
        Player.permid,
    })

    Core.Functions.DebugPrint((Locales[Config.Core['locales']]['player_saved']):format(Player.source))
    Core.Players[Player.source] = nil 
    TriggerClientEvent('core:client:updateClientPlayers', -1, nil, Core.Players)
end

-- @ Manual player save
-- @ Params: playerId
Core.Functions.SavePlayer = function(playerId)
    local Player = Core.Functions.GetPlayerById(playerId)
    Core.Functions.UpdateClassCoords(Player.source) 
    
    MySQL.query('UPDATE players SET accounts = ?, inventory = ?, metadata = ? WHERE permid = ?', {
        json.encode(Player.accounts), 
        json.encode(Player.inventory), 
        json.encode(Player.metadata),
        Player.permid
    })

    Core.Functions.DebugPrint((Locales[Config.Core['locales']]['player_saved']):format(Player.source))
end

-- @ Create usable item
-- @ Params: item, cb
Core.Functions.RegisterUsableItem = function(item, cb)
    Core.UsableItems[item] = {
        use = cb 
    }
end

-- @ Use item
-- @ Params: playerSrc, item 
Core.Functions.UseItem = function(src, item, slot)   
    if Core.UsableItems[item] then 
        Core.UsableItems[item].use(src, slot)
    else
        Core.Functions.DebugPrint(Locales[Config.Core['locales']]['item_not_registered'])
    end
end

-- @ Get random serial number (used in weapons and items)
-- @ Params: None 
Core.Functions.GetRandomSerial = function() 
    local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local lowerCase = "abcdefghijklmnopqrstuvwxyz"
    local numbers = "0123456789"
    
    local characterSet = upperCase .. lowerCase .. numbers
    
    local keyLength = 10
    local output = ""
    
    for	i = 1, keyLength do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end

    return output
end

Core.Functions.MySplit = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

Core.Functions.CreateCommand = function(name, callback, suggest, data)
    if Core.Commands[name] then
        Core.Functions.DebugPrint(Locales[Config.Core['locales']]['command_already_registered'])
        TriggerClientEvent('chat:removeSuggestion', -1, '/'..name)
    end

    if suggest then
        if not suggest.args then 
            suggest.args = {} 
        end
        if not suggest.help then 
            suggest.help = '' 
        end

        TriggerClientEvent('chat:addSuggestion', -1, '/'..name, suggest.help, suggest.args)
    end

    Core.Commands[name] = {
        callback = callback,
        suggest = suggest,
        data = data
    }

    RegisterCommand(name, function(source, args, raw)
        local Player = Core.Functions.GetPlayerById(source)
        if data.has_perms then
            if data.type == 'admin' then
                if source == 0 or Player ~= nil and Player.hasPerms(data.rank) then
                    callback(source, args, Player)
                else
                    Player.sendNotify("~r~No puedes ejecutar este comando.")
                end
            elseif data.type == 'job' then
                if Player ~= nil and Player.getJob().value == data.rank then
                    callback(source, args, Player)
                else
                    Player.sendNotify("~r~No puedes ejecutar este comando.")
                end
            elseif data.type == 'faction' then
                local memberData, factionData, factionId = exports['fm_factions']:isPlayerInAnyFaction(Player.permid)
                if memberData and factionId == data.rank then
                    callback(source, args, Player)
                else
                    Player.sendNotify("~r~No puedes ejecutar este comando.")
                end
            end
        else
            callback(source, args, Player)
        end
    end, false)
end

Core.Functions.ChatMessage = function(pid, color, icon, subtitle, timestamp, msg)
    color = color or 'white'
    icon = icon or 'fa-solid fa-globe'
    subtitle = subtitle or 'Sistema'
    timestamp = timestamp or ''
    msg = msg or 'No se ha proporcionado un texto'
    TriggerClientEvent('chat:addMessage', pid, { templateId =  'ccChat', multiline =  false, args = { color, icon, subtitle, timestamp, msg } })
end