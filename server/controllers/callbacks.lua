RegisterServerEvent('core:triggerCallback', function(name, ...)
    local src = source
    Core.TriggerCallback(name, src, function(...)
        TriggerClientEvent('core:serverCallback', src, name, ...)
    end, ...)
end)

Core.RegisterCallback = function(name, cb)
    Core.Callbacks[name] = cb
end

Core.TriggerCallback = function(name, source, cb, ...)
    if Core.Callbacks[name] then
        Core.Callbacks[name](source, cb, ...)
    end
end

Core.RegisterCallback('core:getUsableItems', function(src, cb)
    cb(Core.UsableItems)
end)