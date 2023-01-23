if Config.Core['inventory'].enable then 
    RegisterCommand('inventory', function()
        Core.Functions.OpenInventory()
    end)

    RegisterKeyMapping('inventory', Locales[Config.Core['locales']]['open_inv'], 'keyboard', 'F2')
end 