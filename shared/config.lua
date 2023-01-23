Config = {
    Debug = true,
    Default = {
        ['accounts'] = { money = 2000, coin = 0 }, 
        ['job'] = {
            label = 'Desempleado', 
            value = 'unemployed',
            rep = 0,
            rank = {
                level = 0, 
                salary = 300, 
                name = 'Nini'
            }
        },
        ['position'] = { 
            x = 204.0, 
            y = -919.76, 
            z = 29.68, 
            w = 90.0 
        }, 
        ['model'] = {
            sex          = 0,
            face         = 0,
            skin         = 0,
            beard_1      = 0,
            beard_2      = 0,
            beard_3      = 0,
            beard_4      = 0,
            hair_1       = 0,
            hair_2       = 0,
            hair_color_1 = 0,
            hair_color_2 = 0,
            tshirt_1     = 0,
            tshirt_2     = 0,
            torso_1      = 0,
            torso_2      = 0,
            decals_1     = 0,
            decals_2     = 0,
            arms         = 0,
            pants_1      = 0,
            pants_2      = 0,
            shoes_1      = 0,
            shoes_2      = 0,
            mask_1       = 0,
            mask_2       = 0,
            bproof_1     = 0,
            bproof_2     = 0,
            chain_1      = 0,
            chain_2      = 0,
            helmet_1     = 0,
            helmet_2     = 0,
            glasses_1    = 0,
            glasses_2    = 0,
        }
    }, 
    Core = {
        ['locales'] = "es",
        ['debug'] = true, 
        ['inventory'] = {
            slots = 20, 
            enable = false -- Can't enable it, it's using oldest version from glovebox and inventory :)    
        }, 
        ['status'] = {
            tick = 2
        }, 
        ['paycheck'] = 15, 
        ['save_interval'] = 15, 
        ['glovebox'] = 4, 
        ['friend_command'] = 'friend'
    },
    Factions = {
        permissions = {'handcuff', 'sendToJail', 'revive', 'searchInventory', 'fine'}
    }
}