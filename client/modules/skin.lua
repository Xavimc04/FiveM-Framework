Core.Functions.Skin = {
    playerSkin = Core.Functions.CloneTable(Config.Default['model']),
} 

function Core.Functions.Skin:LoadPlayerSkin(playerSkin, isNew) 
    local doesExist = false 

    if playerSkin ~= nil then  
        self.playerSkin = Core.Functions.CloneTable(playerSkin)    
    end 

    TriggerEvent('skinchanger:loadSkin', self.playerSkin) 

    if isNew then 
        TriggerEvent('fm_clothing:openMenu')
    end
end

function Core.Functions.Skin:GetClothingData(required)
    local clothingTable = {} 
    local skinChangerData = exports['skinchanger']:GetSkinChangerData() 
    local clothingData, clothingMaxValues = skinChangerData.components, skinChangerData.vals 

    if required then 
        for i,v in pairs(clothingData) do 
            for b = 0, #required do 
                if v.name == required[b] then 
                    local currentComponent = v.value 

                    if currentComponent == 0 then 
                        currentComponent = GetPedPropIndex(PlayerPedId(), v.componentId)
                    end

                    table.insert(clothingTable, {
                        componentLabel = v.label, 
                        componentValue = v.name, 
                        currentComponent = currentComponent, 
                        minTexture = v.min, 
                        maxTexture = clothingMaxValues[v.name], 
                        textureValue = v.textureof 
                    })
                end
            end
        end
    else
        for i,v in pairs(clothingData) do
            local currentComponent = v.value 

            if currentComponent == 0 then 
                currentComponent = GetPedPropIndex(PlayerPedId(), v.componentId)
            end

            table.insert(clothingTable, {
                componentLabel = v.label, 
                componentValue = v.name, 
                currentComponent = currentComponent, 
                minTexture = v.min, 
                maxTexture = clothingMaxValues[v.name], 
                textureValue = v.textureof 
            })
        end
    end

    return clothingTable
end 

function Core.Functions.Skin:SetPreviewSkin(data, playerClone) 
    TriggerEvent('skinchanger:getSkin', function(skin)
        skin[data.component.componentValue] = tonumber(data.component.currentComponent)
        TriggerEvent('skinchanger:loadSkin', skin)  
        Core.Functions.UpdateClone()
    end) 
end

function Core.Functions.Skin:SaveCurrentSkin()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('core:playerSkin:save', skin)
    end)
end