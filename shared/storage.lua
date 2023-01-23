Config.Jobs = {
    ['unemployed'] = {
        label = 'Desempleado', 
        ranks = {
            [0] = {
                salary = 300, 
                name = 'Nini'
            }
        }
    },
    ['refueler'] = {
        label = 'Repostador', 
        ranks = {
            [0] = {
                salary = 400, 
                name = 'Empleado'
            }
        }
    },
    ['pizza'] = {
        label = 'Pizzero', 
        ranks = {
            [0] = {
                salary = 400, 
                name = 'Empleado'
            }
        }
    },
    ['police'] = {
        label = 'LSPD', 
        ranks = {
            [0] = {
                salary = 600, 
                name = 'Recluta'
            },
            [1] = {
                salary = 700, 
                name = 'Cabo'
            }, 
            [2] = {
                salary = 900, 
                name = 'Capitán'
            }, 
            [3] = {
                salary = 1200, 
                name = 'Comisario'
            }
        }
    }, 
}

Config.Ranks = {
    ['user'] = {
        label = 'Usuario', 
        level = 0
    }, 
    ['support'] = {
        label = 'Soporte', 
        level = 1
    }, 
    ['mod'] = {
        label = 'Moderador', 
        level = 2
    }, 
    ['admin'] = {
        label = 'Administrador', 
        level = 3
    }, 
    ['master'] = {
        label = 'Game Master', 
        level = 4
    }, 
    ['root'] = {
        label = 'Root', 
        level = 5
    }, 
}

Config.Accounts = {
    ['money'] = {
        label = 'Efectivo', 
        giveable = true, 
        inventory = true 
    },  
    ['coin'] = {
        label = 'Coins', 
        giveable = false, 
        inventory = false 
    }
}

Config.PropPlacement = {
    ['ng_proc_food_chips01c'] = {
        boneIndex = 18905,
        x = 0.15,
        y = 0.08,
        z = -0.009,
        xR = -10.6,
        yR = -718.82,
        zR = 28.97,
    },
    ['prop_amb_donut'] = {
        boneIndex = 18905,
        x = 0.16,
        y = 0.02,
        z = 0.02,
        xR = 0.0,
        yR = 0.22,
        zR = 0.0,
    },
    ['sf_prop_sf_apple_01a'] = {
        boneIndex = 18905,
        x = 0.13,
        y = 0.009,
        z = 0.03,
        xR = 0.0,
        yR = -344.97,
        zR = 513.42,
    },
    ['prop_pineapple'] = {
        boneIndex = 18905,
        x = 0.07,
        y = 0.06,
        z = 0.03,
        xR = 0.0,
        yR = -133.38,
        zR = -112.54,
    },
    ['prop_cs_burger_01'] = {
        boneIndex = 18905,
        x = 0.07,
        y = 0.06,
        z = 0.03,
        xR = 0.0,
        yR = -133.38,
        zR = -112.54,
    },
    ['prop_cs_hotdog_01'] = {
        boneIndex = 18905,
        x = 0.07,
        y = 0.06,
        z = 0.03,
        xR = 0.0,
        yR = -133.38,
        zR = -112.54,
    },
    ['ng_proc_sodacan_01b'] = {
        boneIndex = 18905,
        x = 0.11,
        y = 0.03,
        z = 0.059,
        xR = 0.0,
        yR = -836.27,
        zR = -828.19,
    },
    ['prop_ecola_can'] = {
        boneIndex = 18905,
        x = 0.15,
        y = 0.035,
        z = 0.009,
        xR = 0.0,
        yR = -836.265,
        zR = -828.19,
    },
    ['prop_orang_can_01'] = {
        boneIndex = 18905,
        x = 0.15,
        y = 0.035,
        z = 0.009,
        xR = 0.0,
        yR = -836.265,
        zR = -828.19,
    },
    ['prop_food_cb_juice01'] = {
        boneIndex = 18905,
        x = 0.11,
        y = 0.03,
        z = 0.059,
        xR = 0.0,
        yR = -836.27,
        zR = -828.19,
    },
    ['ba_prop_club_water_bottle'] = {
        boneIndex = 18905,
        x = 0.11,
        y = 0.03,
        z = 0.059,
        xR = 0.0,
        yR = -836.27,
        zR = -828.19,
    },
}

Config.Items = {
    ['monster'] = {
        label = 'Monster Energy', 
        status = 'thirst', 
        percent = 30,   
        stackable = true, 
        prop = 'ng_proc_sodacan_01b', 
        max = 10,
    }, 
    ['water'] = {
        label = 'Botella de agua', 
        status = 'thirst', 
        percent = 45,   
        stackable = true, 
        prop = 'ba_prop_club_water_bottle', 
        max = 10,
    }, 
    ['chips'] = {
        label = 'Bolsa de patatas', 
        status = 'hunger', 
        percent = 20,   
        stackable = true, 
        prop = 'ng_proc_food_chips01c', 
        max = 10 
    }, 
    ['bread'] = {
        label = 'Bocadillo', 
        status = 'hunger', 
        percent = 20,   
        stackable = true, 
        prop = 'v_res_fa_bread03', 
        max = 10 
    }, 
    ['cocacola'] = {
        label = 'Coca-Cola', 
        status = 'thirst', 
        percent = 30, 
        stackable = true,  
        prop = 'prop_ecola_can',  
        max = 10 
    }, 
    ['fanta'] = {
        label = 'Fanta de naranja', 
        status = 'thirst', 
        percent = 30, 
        stackable = true,  
        prop = 'prop_orang_can_01',  
        max = 10 
    }, 
    ['donut'] = {
        label = 'Donut', 
        status = 'hunger', 
        percent = 30,  
        stackable = true,  
        prop = 'prop_amb_donut', 
        max = 10 
    }, 
    ['banana'] = {
        label = 'Plátano', 
        status = 'hunger', 
        percent = 10,  
        stackable = true,  
        prop = 'v_res_tre_banana', 
        max = 10 
    }, 
    ['orange'] = {
        label = 'Naranja', 
        status = 'hunger', 
        percent = 15,  
        stackable = true,  
        prop = 'sf_prop_sf_apple_01a',
        max = 10 
    }, 
    ['apple'] = {
        label = 'Manzana', 
        status = 'hunger', 
        percent = 10,  
        stackable = true,
        prop = 'sf_prop_sf_apple_01a',
        max = 10 
    },  
    ['piña'] = {
        label = 'Piña', 
        status = 'hunger', 
        percent = 10,  
        stackable = true,
        prop = 'prop_pineapple',
        max = 10 
    },
    ['hotdog'] = {
        label = 'Perrito Caliente', 
        status = 'hunger', 
        percent = 30,  
        stackable = true,
        prop = 'prop_cs_hotdog_01',
        max = 10 
    },
    ['burger'] = {
        label = 'Hamburguesa', 
        status = 'hunger', 
        percent = 30,  
        stackable = true,
        prop = 'prop_cs_burger_01',
        max = 10 
    }, 
    ['juice'] = {
        label = 'Zumo de piña', 
        status = 'thirst', 
        percent = 30,   
        stackable = true, 
        prop = 'prop_food_cb_juice01', 
        max = 10 
    }, 
    ['flash'] = {
        label = 'Linterna de Arma',
        stackable = false, 
        canRemove = true,
        prop = 'w_me_flashlight_flash',
        max = 1 
    }, 
    ['suppressor'] = {
        label = 'Silenciador',
        stackable = false, 
        canRemove = true, 
        max = 1 
    }, 
    ['handcuff'] = {
        label = 'Esposas',
        stackable = false, 
        canRemove = true, 
        prop = 'prop_cs_cuffs_01',
        max = 1
    },
    ['meth'] = {
        label = 'Metanfetamina',
        stackable = true, 
        canRemove = true, 
        prop = 'prop_meth_bag_01',
        max = 30
    },
    ['coke'] = {
        label = 'Cocaína',
        stackable = true, 
        canRemove = true, 
        prop = 'bkr_prop_coke_cutblock_01',
        max = 20
    },
    ['weed'] = {
        label = 'Marihuana',
        stackable = true, 
        canRemove = true, 
        prop = 'prop_weed_block_01',
        max = 50
    },
    ['handcuffkey'] = {
        label = 'Llave de Esposas',
        stackable = false, 
        canRemove = true,
        prop = 'prop_cs_keys_01',
        max = 1
    },
    ['scope'] = {
        label = 'Mira de Arma',
        stackable = false, 
        canRemove = true,
        prop = 'w_at_scope_macro',
        max = 1 
    }, 
    ['bandage'] = {
        label = 'Vendas',
        stackable = false, 
        canRemove = true,
        prop = 'prop_ld_health_pack',
        max = 1
    },  
    ['carkey'] = {
        label = 'Llave de vehiculo',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'p_car_keys_01', 
        max = 1 
    },
    ['garagekey'] = {
        label = 'Mando de garaje',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'lr_prop_carkey_fob', 
        max = 1 
    },
    ['propertykey'] = {
        label = 'Llave de Propiedad',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'prop_cs_keys_01', 
        max = 1 
    }, 
    ['bankcard'] = {
        label = 'Mastercard',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'prop_cs_business_card', 
        max = 1 
    },
    ['idcard'] = {
        label = 'DNI',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'p_ld_id_card_01', 
        max = 1 
    }, 
    ['carlicense'] = {
        label = 'Carnet de Coche',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'p_ld_id_card_01', 
        max = 1 
    },
    ['trucklicense'] = {
        label = 'Carnet de Camión',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'p_ld_id_card_01', 
        max = 1 
    }, 
    ['flylicense'] = {
        label = 'Carnet de Vuelo',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'p_ld_id_card_01', 
        max = 1 
    }, 
    ['weaponlicense'] = {
        label = 'Licencia de armas',
        stackable = false, 
        canRemove = true, 
        specialId = true, 
        prop = 'p_ld_id_card_01', 
        max = 1 
    },
    ['phone'] = {
        label = "Teléfono",
        stackable = false,
        canRemove = true,
        specialId = true,
        prop = 'prop_phone_proto',
        max = 1
    },
    ['firstaidkit'] = {
        label = "Botiquín",
        stackable = true,
        canRemove = false,
        specialId = false,
        prop = 'xm_prop_x17_bag_med_01a',
        max = 3
    },
    ['axe'] = {
        label = "Hacha",
        stackable = false,
        canRemove = true,
        specialId = false,
        prop = 'prop_tool_fireaxe',
        max = 1
    },
    ['binoculars'] = {
        label = "Prismaticos",
        stackable = true,
        canRemove = false,
        specialId = false,
        prop = 'v_serv_ct_binoculars',
        max = 2
    },
    ['property_lock'] = {
        label = "Cerradura",
        stackable = false,
        canRemove = true,
        specialId = false,
        prop = 'prop_cs_padlock',
        max = 2
    },
    ['portable_charger'] = {
        label = "Cargador Portátil",
        stackable = true,
        canRemove = true,
        specialId = false,
        prop = 'vw_prop_casino_phone_01b_handle',
        max = 1
    }
}


-- Meterle los props para pdoer spawnearlas en network. 
Config.Weapons = {
    -- @melee
    ['weapon_dagger'] = {
        label = 'Daga', 
        perms = 'user', 
        prop = 'w_me_dagger', 
    }, 
    ['weapon_crowbar'] = {
        label = 'Palanca', 
        perms = 'user', 
        prop = 'w_me_crowbar', 
    }, 
    ['weapon_flashlight'] = {
        label = 'Linterna', 
        perms = 'user', 
        prop = 'w_me_flashlight', 
    },  
    ['weapon_golfclub'] = {
        label = 'Palo de golf', 
        perms = 'user', 
        prop = 'w_me_gclub', 
    },   
    ['weapon_hammer'] = {
        label = 'Martillo', 
        perms = 'user', 
        prop = 'w_me_hammer', 
    },
    ['weapon_hatchet'] = {
        label = 'Hacha', 
        perms = 'user', 
        prop = 'w_me_hatchet', 
    },
    ['weapon_knuckle'] = {
        label = 'Nudillos', 
        perms = 'user', 
        prop = 'w_me_knuckle', 
    },
    ['weapon_knife'] = {
        label = 'Cuchillo', 
        perms = 'user', 
        prop = 'w_me_knife_01', 
    },
    ['weapon_bat'] = {
        label = 'Bate', 
        perms = 'user', 
        prop = 'w_me_bat',
    },
    ['weapon_machete'] = {
        label = 'Machete', 
        perms = 'user', 
        prop = 'prop_ld_w_me_machette',
    },
    ['weapon_switchblade'] = {
        label = 'Navaja', 
        perms = 'user', 
        prop = 'w_me_switchblade',
    },
    ['weapon_nightstick'] = {
        label = 'Porra', 
        perms = 'user', 
        prop = 'w_me_nightstick',
    },
    ['weapon_wrench'] = {
        label = 'Llave inglesa', 
        perms = 'user', 
        prop = 'prop_tool_wrench',
    },
    ['weapon_poolcue'] = {
        label = 'Taco de billar',
        perms = 'user',
        prop = 'prop_pool_cue',
    },
    -- @pistols
    ['weapon_pistol'] = {
        label = 'Pistola 8MM', 
        perms = 'user',  
        prop = 'w_pi_pistol',
        ['flash'] = 'COMPONENT_AT_PI_FLSH', 
        ['suppressor'] = 'COMPONENT_AT_PI_SUPP_02', 
    },
    ['weapon_combatpistol'] = {
        label = 'Pistola de Combate', 
        perms = 'user',  
        prop = 'w_pi_combatpistol',
        ['flash'] = 'COMPONENT_AT_PI_FLSH', 
        ['suppressor'] = 'COMPONENT_AT_PI_SUPP', 
    },
    ['weapon_appistol'] = {
        label = 'Pistola ametralladora', 
        perms = 'user',  
        prop = 'w_pi_appistol',
        ['flash'] = 'COMPONENT_AT_PI_FLSH', 
        ['suppressor'] = 'COMPONENT_AT_PI_SUPP', 
    },
    ['weapon_stungun'] = {
        label = 'Taser', 
        perms = 'user',  
        prop = 'w_pi_stungun'
    },
    ['weapon_pistol50'] = {
        label = 'Pistola de 50 Cal', 
        perms = 'user',  
        prop = 'w_pi_pistol50',
        ['flash'] = 'COMPONENT_AT_PI_FLSH', 
        ['suppressor'] = 'COMPONENT_AT_AR_SUPP_02', 
    },
    ['weapon_vintagepistol'] = {
        label = 'Pistola Vintage', 
        perms = 'user',  
        prop = 'w_pi_vintage_pistol',
        ['suppressor'] = 'COMPONENT_AT_PI_SUPP', 
    },
    ['weapon_flaregun'] = {
        label = 'Pistola de bengalas', 
        perms = 'user',  
        prop = 'w_pi_flaregun'
    },
    -- @submachine guns
    ['weapon_microsmg'] = {
        label = 'Micro Smg', 
        perms = 'user',  
        prop = 'w_sb_microsmg',
        ['flash'] = 'COMPONENT_AT_PI_FLSH',
        ['scope'] = 'COMPONENT_AT_SCOPE_MACRO',
        ['suppressor'] = 'COMPONENT_AT_AR_SUPP_02',
    },
    ['weapon_smg'] = {
        label = 'SMG', 
        perms = 'user',  
        prop = 'w_sb_smg',
        ['flash'] = 'COMPONENT_AT_AR_FLSH',
        ['scope'] = 'COMPONENT_AT_SCOPE_MACRO_02',
        ['suppressor'] = 'COMPONENT_AT_PI_SUPP',
    },
    ['weapon_machinepistol'] = {
        label = 'Tec 9', 
        perms = 'user',  
        prop = 'w_sb_compactsmg',
        ['suppressor'] = 'COMPONENT_AT_PI_SUPP',
    },
    -- @assault rifles
    ['weapon_assaultrifle'] = {
        label = 'AK-47', 
        perms = 'user',  
        prop = 'w_ar_assaultrifle',
        ['flash'] = 'COMPONENT_AT_AR_FLSH', 
        ['suppressor'] = 'COMPONENT_AT_AR_SUPP_02', 
        ['scope'] = 'COMPONENT_AT_SCOPE_MACRO' 
    },
    ['weapon_carbinerifle'] = {
        label = 'Carabina', 
        perms = 'user',  
        prop = 'w_ar_carbinerifle',
        ['flash'] = 'COMPONENT_AT_AR_FLSH', 
        ['suppressor'] = 'COMPONENT_AT_AR_SUPP', 
        ['scope'] = 'COMPONENT_AT_SCOPE_MEDIUM' 
    },
    -- @light machine guns
    ['weapon_gusenberg'] = {
        label = 'Thompson', 
        perms = 'user',  
        prop = 'w_sb_gusenberg'
    },
    -- @snipers
    ['weapon_sniperrifle'] = {
        label = 'Rifle francotirador', 
        perms = 'user',  
        prop = 'w_sr_sniperrifle',
        ['suppressor'] = 'COMPONENT_AT_AR_SUPP_02', 
        ['scope'] = 'COMPONENT_AT_SCOPE_LARGE' 
    },
    ['weapon_marksmanrifle'] = {
        label = 'Rifle de cazador', 
        perms = 'user',  
        prop = 'w_sr_marksmanriflemk2',
        ['flash'] = 'COMPONENT_AT_AR_FLSH',
        ['suppressor'] = 'COMPONENT_AT_AR_SUPP'
    },
    -- @heavy
    ['weapon_firework'] = {
        label = 'Cañón artificial', 
        perms = 'root',  
        prop = 'w_lr_firework'
    },
}