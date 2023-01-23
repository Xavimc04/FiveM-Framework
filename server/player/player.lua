Core.Players = {}
Core.Player = {}

Core.Player.Init = function(playerId, data, identity)
    local PlayerData = {}

    if playerId ~= nil then 
        if data ~= nil then 
            PlayerData.permid = data.permid
            PlayerData.license = data.license
            PlayerData.accounts = json.decode(data.accounts)
            PlayerData.inventory = json.decode(data.inventory)
            PlayerData.identity = json.decode(data.identity)
            PlayerData.metadata = json.decode(data.metadata)

            Core.Player.VerifyData(playerId, PlayerData)
        else
            Core.Player.VerifyData(playerId, nil, identity, true)
        end
    else
        return false 
    end
end

Core.Player.VerifyData = function(playerId, PlayerData, identity, newPlayer)
    PlayerData = PlayerData ~= nil and PlayerData or {}

    PlayerData.source = playerId 
    PlayerData.steam = GetPlayerName(playerId)
    PlayerData.permid = PlayerData.permid or 'Desconocida'  
    PlayerData.license = PlayerData.license or Core.Functions.GetPlayerLicense(playerId)
    PlayerData.identity = PlayerData.identity or {}
    PlayerData.identity.firstname = PlayerData.identity.firstname or identity.Firstname 
    PlayerData.identity.lastname = PlayerData.identity.lastname or identity.Lastname 
    PlayerData.identity.height = PlayerData.identity.height or identity.Height 
    PlayerData.identity.birth = PlayerData.identity.birth or identity.Birth 
    PlayerData.identity.nationality = PlayerData.identity.nationality or identity.Nationality 
    PlayerData.accounts = PlayerData.accounts or Config.Default['accounts']
    PlayerData.inventory = PlayerData.inventory or {}

    PlayerData.metadata = PlayerData.metadata or {}

    -- @Metadata: Licenses
    PlayerData.metadata.licenses = PlayerData.metadata.licenses or {}

    -- @Metadata: PlayerSkin 
    PlayerData.metadata.skin = PlayerData.metadata.skin or {}

    -- @Metadata: Dead 
    PlayerData.metadata.dead = PlayerData.metadata.dead or false 

    -- @Metadata: Bucket 
    PlayerData.metadata.dimension = PlayerData.metadata.dimension or 0 

    -- @Metadata: Friends 
    PlayerData.metadata.friends = PlayerData.metadata.friends or {} 

    -- @Metadata: Status
    PlayerData.metadata.hunger = PlayerData.metadata.hunger or 100 
    PlayerData.metadata.thirst = PlayerData.metadata.thirst or 100

    -- @Metadata: Duty
    PlayerData.metadata.duty = PlayerData.metadata.duty or false

    -- @Metadata: Bills
    PlayerData.metadata.bills = PlayerData.metadata.bills or {}

    -- @Metadata: Job, Position, Rank
    PlayerData.metadata.job = PlayerData.metadata.job or {}
    PlayerData.metadata.job.label = PlayerData.metadata.job.label or Config.Default['job'].label
    PlayerData.metadata.job.value = PlayerData.metadata.job.value or Config.Default['job'].value
    PlayerData.metadata.job.rank = PlayerData.metadata.job.rank or {}
    PlayerData.metadata.job.rank.level = PlayerData.metadata.job.rank.level or Config.Default['job'].rank.level
    PlayerData.metadata.job.rank.salary = PlayerData.metadata.job.rank.salry or Config.Default['job'].rank.salary
    PlayerData.metadata.job.rank.name = PlayerData.metadata.job.rank.name or Config.Default['job'].rank.name
    PlayerData.metadata.position = PlayerData.metadata.position or Config.Default['position'] 
    PlayerData.metadata.rank = PlayerData.metadata.rank or 'user'
    
    PlayerData.metadata.donator = PlayerData.metadata.donator or os.time{day=1, year=1800, month=1} -- It's equal to 792849600


    -- @Metadata: Player level
    PlayerData.metadata.level = PlayerData.metadata.level or 0
    PlayerData.metadata.xp = PlayerData.metadata.xp or 0 
    
    -- @lastVehicle
    PlayerData.metadata.lastVehicle = PlayerData.metadata.lastVehicle or {}

    if newPlayer then 
        local done = MySQL.insert('INSERT INTO `players`(`license`, `accounts`, `inventory`, `identity`, `metadata`) VALUES(?, ?, ?, ?, ?)', {
            PlayerData.license, 
            json.encode(PlayerData.accounts), 
            json.encode(PlayerData.inventory),  
            json.encode(PlayerData.identity), 
            json.encode(PlayerData.metadata),  
        })

        if done then 
            local queryResult = MySQL.query.await('SELECT `permid` FROM `players` WHERE `license` = ?', {
                PlayerData.license 
            })

            if #queryResult > 1 then
                PlayerData.permid = queryResult[#queryResult].permid   
            else
                PlayerData.permid = queryResult[1].permid  
            end
        end

        Core.Functions.DebugPrint('A new player has been created on database, say hello to ^1'..PlayerData.identity.firstname..'^7!')
    else
        Core.Functions.DebugPrint(PlayerData.identity.firstname..' has been joined with this server id: ^1'..PlayerData.source..'^7')
    end 

    local Player = Core.Player.CreatePlayerFunctions(PlayerData)
    Core.Players[PlayerData.source] = Player 

    Player.generateInventorySlots()

    TriggerClientEvent('core:client:loaded', PlayerData.source, PlayerData, PlayerData.metadata.skin)
    TriggerEvent('core:server:loaded', PlayerData.source, PlayerData)
    TriggerClientEvent('core:client:updateClientPlayers', -1, PlayerData, Core.Players)
end