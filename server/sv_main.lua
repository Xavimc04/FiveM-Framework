Core = {}
Core.Functions = {}
Core.UsableItems = {}
Core.PickUps = {}
Core.Commands = {}
Core.Callbacks = {}
Events = exports['fm_security']:get()

-- @on resource stop
AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res then return end
    for i = 1, #Core.Players do
        Core.Functions.SavePlayer(Core.Players[i].source)
    end 
end)

-- @security
RegisterNetEvent('fm_security:reSync', function(ev)
    Events = ev
end)

-- @import
getCoreData = function()
    return Core 
end