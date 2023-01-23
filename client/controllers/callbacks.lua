Core.TriggerCallback = function(name, cb, ...)
    Core.Callbacks[name] = cb
    TriggerServerEvent('core:triggerCallback', name, ...)
end

RegisterNetEvent('core:serverCallback', function(name, ...)
    Core.Callbacks[name](...)
    Core.Callbacks[name] = nil
end)