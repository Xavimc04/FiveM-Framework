Core.Player.CreatePlayerFunctions = function(PlayerData)
    local self = {}
    
    self.source = PlayerData.source 
    self.license = PlayerData.license
    self.steam = PlayerData.steam 
    self.permid = PlayerData.permid 
    self.identity = PlayerData.identity
    self.accounts = PlayerData.accounts
    self.inventory = PlayerData.inventory
    self.metadata = PlayerData.metadata

    self.sendAlert = function(message)
        if message then
            TriggerClientEvent('core:sendAlert', self.source, message)
        end
    end

    self.sendNotify = function(message)
        if message then
            TriggerClientEvent('core:sendNotify', self.source, message)
        end
    end

    self.clientEvent = function(eventName, ...)
        TriggerClientEvent(eventName, self.source, ...)
    end

    self.dataToClient = function()
        local TableData = {
            source = self.source, 
            license = self.license, 
            steam = self.steam, 
            permid = self.permid, 
            identity = self.identity, 
            accounts = self.accounts, 
            inventory = self.inventory,  
            metadata = self.metadata 
        }

        self.clientEvent('core:renewData', TableData)
    end
    
    self.getLicense = function()
        return self.license 
    end

    self.getSteam = function()
        return self.steam 
    end

    self.getPermId = function()
        return self.permid
    end

    self.getIdentity = function()
        return self.identity
    end

    self.getName = function()
        return self.identity.firstname..' '..self.identity.lastname 
    end

    self.getNationality = function()
        return self.identity.nationality 
    end

    self.getAccounts = function()
        return self.accounts 
    end

    self.getAccountMoney = function(account)
        if self.accounts[account] then 
            return self.accounts[account]
        end

        return Core.Functions.DebugPrint('Attempted to get a nonexistent account')
    end

    self.addAccountMoney = function(account, money)
        local money = tonumber(money)

        if Config.Accounts[account] and money > 0 then 
            if self.accounts[account] then 
                self.accounts[account] = self.accounts[account] + money 
            else
                self.accounts[account] = money  
            end

            self.dataToClient()
        else
            return Core.Functions.DebugPrint('Attempted to add money to a nonexistent account or missing value')
        end
    end

    self.setAccountMoney = function(account, money)
        local money = tonumber(money)

        if Config.Accounts[account] and money >= 0 then 
            self.accounts[account] = money
            self.dataToClient()
        else
            return Core.Functions.DebugPrint('Attempted to add money to a nonexistent account or missing value')
        end
    end

    self.removeAccountMoney = function(account, money)
        local money = tonumber(money)

        if Config.Accounts[account] and money >= 0 then 
            if self.accounts[account] then  
                self.accounts[account] = self.accounts[account] - money 

                if self.accounts[account] < 0 then 
                    self.accounts[account] = 0 
                end

                self.dataToClient()
                return true
            end
        else
            return Core.Functions.DebugPrint('Attempted to add money to a nonexistent account or missing value')
        end
    end

    self.getSkin = function()
        return self.metadata.skin  
    end

    self.isDead = function()
        return self.metadata.dead
    end

    self.setDead = function(bool)
        self.metadata.dead = bool 
        self.dataToClient()
    end

    self.getStatus = function()
        return {
            hunger = self.metadata.hunger, 
            thirst = self.metadata.thirst 
        }
    end

    self.setStatus = function(status, value)
        if status then 
            if value ~= nil and tonumber(value) >= 0 then 
                if status == 'hunger' then 
                    self.metadata.hunger = tonumber(value)
                elseif status == 'thirst' then 
                    self.metadata.thirst = tonumber(value) 
                end

                self.dataToClient()
            end 
        end 
    end

    self.removeStatus = function(status, quant)
        if status then 
            if quant ~= nil and tonumber(quant) >= 0 then 
                if status == 'hunger' then 
                    self.metadata.hunger = self.metadata.hunger - tonumber(quant)

                    if self.metadata.hunger < 0 then 
                        self.metadata.hunger = 0 
                    end

                    self.dataToClient()
                    return true 
                elseif status == 'thirst' then 
                    self.metadata.thirst = self.metadata.thirst - tonumber(quant)

                    if self.metadata.thirst < 0 then 
                        self.metadata.thirst = 0 
                    end

                    self.dataToClient()
                    return true 
                end
            end 
        end 
    end

    self.addStatus = function(status, quant)
        if status then 
            if quant ~= nil and tonumber(quant) >= 0 then 
                if status == 'hunger' then 
                    self.metadata.hunger = self.metadata.hunger + tonumber(quant)

                    if self.metadata.hunger > 100 then 
                        self.metadata.hunger = 100 
                    end

                    self.dataToClient()
                    return true 
                elseif status == 'thirst' then 
                    self.metadata.thirst = self.metadata.thirst + tonumber(quant)

                    if self.metadata.thirst > 100 then 
                        self.metadata.thirst = 100 
                    end

                    self.dataToClient()
                    return true 
                end
            end 
        end 
    end

    self.updateCoords = function(coords)
        self.metadata.position = coords 
        self.dataToClient() 
    end

    self.saveSkin = function(playerSkin) 
        self.metadata.skin = playerSkin 
        self.dataToClient() 
    end

    self.getJob = function()
        return self.metadata.job 
    end

    self.setJob = function(job, rank)
        if Config.Jobs[job] then 
            if Config.Jobs[job].ranks[tonumber(rank)] then 
                self.metadata.job.label = Config.Jobs[job].label 
                self.metadata.job.value = job
                self.metadata.job.rank.level = tonumber(rank)
                self.metadata.job.rank.salary = Config.Jobs[job].ranks[tonumber(rank)].salary
                self.metadata.job.rank.name = Config.Jobs[job].ranks[tonumber(rank)].name

                self.dataToClient()
                return true 
            end
        end

        return Core.Functions.DebugPrint('This job/rank does not exist or missing value') 
    end

    self.getRank = function()
        return self.metadata.rank 
    end

    self.setRank = function(rank)
        if Config.Ranks[rank] then 
            self.metadata.rank = rank 
            self.dataToClient()
            return true 
        end

        return Core.Functions.DebugPrint('This rank does not exist or missing value')
    end

    self.hasPerms = function(rank) 
        if Config.Ranks[rank] then 
            if Config.Ranks[self.getRank()].level >= Config.Ranks[rank].level then 
                return true 
            else
                return false 
            end
        end

        return Core.Functions.DebugPrint('This rank does not exist or missing value') 
    end

    self.getInventory = function()
        return self.inventory 
    end

    self.generateInventorySlots = function()
        if #self.inventory == 0 then
            for i = 1, Config.Core['inventory'].slots do 
                self.inventory[i] = {
                    slot = i, 
                    item = false, 
                    type = false, 
                    data = {}
                }
            end
        end

        return true 
    end 

    self.switchItemToSlot = function(from, to) 
        local toSlot = self.inventory[to] 
        local fromSlot = self.inventory[from]
        self.inventory[from] = toSlot
        self.inventory[from].slot = from
        self.inventory[to] = fromSlot
        self.inventory[to].slot = to

        return self.dataToClient()  
    end

    self.setInventory = function(inventoryTable)
        print("executing")
        self.inventory = inventoryTable 

        return self.dataToClient()
    end

    self.getFreeSlot = function() 
        for i,v in pairs(self.inventory) do  
            if not v.item then  
                return i 
            end
        end 

        return false 
    end

    self.getAvailableSlotFromItem = function(item) 
        if Config.Items[item] then 
            for i,v in pairs(self.inventory) do 
                if v.item == item and v.info.quant < Config.Items[item].max then 
                    return v
                end
            end 
        end

        return false 
    end
    
    self.addInventoryItem = function(value, quant, complete)
        local doesExist = false 
 
        if #self.inventory ~= Config.Core['inventory'].slots then 
            self.generateInventorySlots()
        end 
        
        if Config.Items[value] or Config.Weapons[value] then   
            doesExist = true  
            local hasItem = self.getAvailableSlotFromItem(value)

            if not hasItem then 
                local amountToAdd
                
                if Config.Items[value] then 
                    if quant > Config.Items[value].max then 
                        amountToAdd = Config.Items[value].max
                    else
                        amountToAdd = quant
                    end 
                else
                    amountToAdd = 1
                end 

                local Slot = self.getFreeSlot()

                if Slot then
                    if(Config.Items[value]) then
                        if complete ~= nil then  
                            self.inventory[Slot] = {
                                slot = Slot, 
                                item = value, 
                                type = 'item', 
                                info = {
                                    quant = amountToAdd, 
                                    identifier = complete.identifier
                                } 
                            }
                        else
                            self.inventory[Slot] = {
                                slot = Slot, 
                                item = value, 
                                type = 'item', 
                                info = {
                                    quant = amountToAdd, 
                                    identifier = Core.Functions.GetRandomSerial()
                                } 
                            }
                        end

                        self.dataToClient() 
                    else 
                        if complete ~= nil then 
                            self.inventory[Slot] = {
                                slot = Slot, 
                                item = value, 
                                type = 'weapon', 
                                info = { 
                                    quant = 1, 
                                    bullets = complete.info.bullets,  
                                    supressor = complete.info.supressor, 
                                    flashlight = complete.info.flashlight, 
                                    scope = complete.info.scope, 
                                    identifier = complete.info.identifier
                                } 
                            }
                        else
                            self.inventory[Slot] = {
                                slot = Slot, 
                                item = value, 
                                type = 'weapon', 
                                info = { 
                                    quant = 1, 
                                    bullets = quant,  
                                    supressor = false, 
                                    flashlight = false, 
                                    scope = false, 
                                    identifier = Core.Functions.GetRandomSerial()
                                } 
                            }
                        end

                        self.dataToClient() 
                    end
                else  
                    TriggerClientEvent('core:additionalPickup', self.source, value, quant, complete)  
                    self.sendNotify(Locales['no_free_slot'])
                end

                local remainingAmount = quant - amountToAdd 
            
                if(Config.Items[value]) then
                    if(remainingAmount > 0 ) then  
                        if self.getFreeSlot() then
                            return self.addInventoryItem(value, remainingAmount) 
                        end
                    end
                end
            else 
                if (hasItem.info.quant + quant) <= Config.Items[value].max then
                    self.inventory[hasItem.slot].info.quant = self.inventory[hasItem.slot].info.quant + quant  
                    self.dataToClient()
                else  
                    local quantToCarry = Config.Items[value].max - hasItem.info.quant 
                    local quantToCall = quant - quantToCarry 
                    local newSlot = self.getFreeSlot()
                    
                    self.inventory[hasItem.slot].info.quant = self.inventory[hasItem.slot].info.quant + quantToCarry
                    self.dataToClient() 

                    if newSlot then   
                        return self.addInventoryItem(value, quantToCall)
                    else
                        return self.sendNotify(Locales[Config.Core['locales']]['paycheck_received'])
                    end 
                end 
            end
        end

        if not doesExist then 
            return Core.Functions.DebugPrint('This item does not exist or missing value') 
        end
    end

    self.getItemsInSlot = function(value)
        local usedSlots = {}

        for i,v in pairs(self.inventory) do
            if v.item == value then
                table.insert(usedSlots, self.inventory[i])
            end 
        end

        if #usedSlots > 0 then
            return usedSlots
        end

        return false
    end

    self.removeInventoryItem = function(value, quant, inventorySlot) 
        local doesExist = false 
 
        if #self.inventory ~= Config.Core['inventory'].slots then 
            self.generateInventorySlots()
        end 
 
        if Config.Items[value] or Config.Weapons[value] then 
            doesExist = true 

            local itemsOnTable = self.getItemsInSlot(value)

            if itemsOnTable then 
                for i,v in pairs(itemsOnTable) do   
                    local slot = v.slot 

                    if inventorySlot then 
                        slot = inventorySlot 
                    end 
 
                    if (v.info.quant - quant) > 0 then 
                        self.inventory[slot].info.quant = self.inventory[slot].info.quant - quant  
                        self.dataToClient()
                        return true
                    else 
                        local remainingToRemove = quant - v.info.quant

                        self.inventory[slot] = {
                            slot = slot, 
                            item = false, 
                            type = false, 
                            data = {} 
                        }

                        self.clientEvent('core:removeFromGlovebox', value, v.info.identifier)

                        if remainingToRemove > 0 then 
                            self.removeInventoryItem(value, remainingToRemove)
                        end
                        self.dataToClient()
                        return true  
                    end
                end
            else
                return false 
            end
        end

        if not doesExist then 
            return Core.Functions.DebugPrint('This item does not exist or missing value') 
        end
    end

    self.setWeaponData = function(type, value, slot) 
        for i,v in pairs(self.inventory) do 
            if v.slot == slot then 
                if v.type == 'weapon' then 
                    if type == 'bullets' then 
                        self.inventory[v.slot].info.bullets = value 
                    elseif type == 'suppressor' then 
                        self.inventory[v.slot].info.supressor = value
                    elseif type == 'flash' then 
                        self.inventory[v.slot].info.flashlight = value
                    elseif type == 'scope' then 
                        self.inventory[v.slot].info.scope = value 
                    end 

                    return self.dataToClient() 
                end
            end
        end

        return false 
    end

	self.getFriends = function()
		return self.metadata.friends    
	end

	self.addFriend = function(license, name, permid)
        if self.metadata.friends == nil then 
            self.metadata.friends = {}
        end

        if #self.metadata.friends > 0 then 
            for i,v in pairs(self.metadata.friends) do 
                if v.permid == permid then 
                    return false 
                end
            end
        end

		table.insert(self.metadata.friends, { id = tonumber(#self.metadata.friends + 1), permid = permid, license = license, name = name }) 
		return self.dataToClient()  
	end

    self.kick = function(reason)
        DropPlayer(self.source, (Locales[Config.Core['locales']]['kick_message']):format(reason))
    end

    self.sendDimension = function(dimensionId)
        SetPlayerRoutingBucket(self.source, dimensionId)
        self.metadata.dimension = dimensionId 
        self.dataToClient() 
    end

    self.getDimension = function()
        if self.metadata.dimension == nil then 
            self.metadata.dimension = 0 
        end

        return self.metadata.dimension
    end

    self.getExperience = function()
        return {
            level = self.metadata.level, 
            xp = self.metadata.xp 
        }
    end

    self.setLevel = function(int)
        if self.metadata.level == nil then 
            self.metadata.level = 0

            if self.metadata.xp == nil then 
                self.metadata.xp = 0
            end
        end

        self.metadata.level = int 
        self.dataToClient()
    end

	self.addLevel = function(int)
        if self.metadata.level == nil then 
            self.metadata.level = 0

            if self.metadata.xp == nil then 
                self.metadata.xp = 0
            end
        end

        self.metadata.level = self.metadata.level + int 
        self.dataToClient()
    end

    self.removeLevel = function(int)
        if self.metadata.level == nil then 
            self.metadata.level = 0

            if self.metadata.xp == nil then 
                self.metadata.xp = 0
            end

            return 
        end

        if self.metadata.level - int >= 0 then 
            self.metadata.level = self.metadata.level - int
        else
            self.metadata.level = 0
        end

        self.dataToClient()
    end

    self.setXp = function(int)
        if self.metadata.xp == nil then 
            self.metadata.xp = 0

            if self.metadata.level == nil then 
                self.metadata.level = 0 
            end
        end

        self.metadata.xp = int 
        self.dataToClient()
    end

    self.addXp = function(int)
        if self.metadata.xp == nil then 
            self.metadata.xp = 0

            if self.metadata.level == nil then
                self.metadata.level = 0
            end
        end

        if self.metadata.xp + int >= 100 then
            self.addLevel(1)
            self.metadata.xp = 0 
        else
            self.metadata.xp = self.metadata.xp + int  
        end

        self.dataToClient()
    end

    self.removeXp = function(int)
        if self.metadata.xp == nil then 
            self.metadata.xp = 0

            if self.metadata.level == nil then 
                self.metadata.level = 0 
            end

            return 
        end

        if self.metadata.xp - int >= 0 then 
            self.metadata.xp = self.metadata.xp - int
        else
            self.metadata.xp = 0
        end

        self.dataToClient()
    end

    self.addLicense = function(license)
        if not self.hasLicense(license) then
            self.metadata.licenses[license] = true
            return true
        else
            return false
        end
    end

    self.removeLicense = function(license)
        if self.hasLicense(license) then
            self.metadata.licenses[license] = nil
            return true
        else
            return false
        end
    end

    self.getLicenses = function()
        return self.metadata.licenses
    end

    self.hasLicense = function(license)
        if self.metadata.licenses[license] then
            return true
        end
        return false
    end

    -- @duty
    self.setDuty = function(bool)
        self.metadata.duty = bool

        self.dataToClient()
    end

    self.getDuty = function()
        return self.metadata.duty
    end

    -- @bills
    self.getBills = function(category) -- category -> opcional
        if category then
            for i,v in pairs(self.metadata.bills) do
                if v.category == category then
                    return v
                end
            end
        else
            return self.metadata.bills
        end
    end

    self.addBill = function(price, reason, title, category)
        if not price or not reason or not title or not category then
            return false
        end
        local billId = #self.metadata.bills + 1
        self.metadata.bills[billId] = {
            id = billId,
            price = price,
            reason = reason,
            title = title,
            category = category
        }
        self.dataToClient()
        return true
    end

    self.removeBill = function(billId)
        if not billId then
            return false
        end
        self.metadata.bills[billId] = nil
        self.dataToClient()
        return true
    end 

    -- Donatior / premiumFunctions
    self.isPremium = function()
        local today = os.time()
        local daysLeft = os.difftime(today, self.metadata.donator) / (24 * 60 * 60)

        --[[ If the player has more than 10 years, he's permanent. ]]
        if daysLeft > 3650 then
            return true, 'Premium', self.metadata.donator
        elseif daysLeft > 0 then
            return true, 'Donator', self.metadata.donator
        elseif daysLeft <= 0 then
            return false, "Not premium", self.metadata.donator
        end
    end

    self.setPremium = function(days)
        if type(days) == 'number' then
            local premiumExpiracyDate = os.date("*t")
            today.day = today.day + days
    
            self.metadata.donator = premiumExpiracyDate

            return true
        end

        return false
    end

    self.setLastVehicle = function(table)
        if type(table) ~= 'table' then
            return error("setLastVehicle is receiving a "..type(table).." instead of table")
        end
        self.metadata.lastVehicle = table
        return true
    end

    self.getLastVehicle = function(key)
        if key then
            return self.metadata.lastVehicle[key]
        end

        return self.metadata.lastVehicle
    end

    return self 
end