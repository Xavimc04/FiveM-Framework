Core.InitPaycheck = function()
    for i = 1, #Core.Players do 
        local Player = Core.Functions.GetPlayerById(Core.Players[i].source) 

        Player.addAccountMoney('money', Player.getJob().rank.salary)
        Player.sendNotify((Locales[Config.Core['locales']]['paycheck_received']):format(Player.getJob().rank.name, Player.getJob().rank.salary))
    end 

    SetTimeout(60000 * Config.Core['paycheck'], Core.InitPaycheck)
end

Core.InitPaycheck()