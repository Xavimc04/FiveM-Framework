Core.SavePlayers = function()
    for i = 1, #Core.Players do 
        Core.Functions.SavePlayer(Core.Players[i].source)
    end 

    SetTimeout(60000 * Config.Core['save_interval'], Core.InitPaycheck)
end

Core.SavePlayers()