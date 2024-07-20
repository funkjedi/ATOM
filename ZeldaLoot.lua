local addonName, ATOM = ...
local Module = ATOM:NewModule('ZeldaLoot')

local colourQualitySounds = {
    [select(4, GetItemQualityColor(2))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\2.mp3', -- Uncommon
    [select(4, GetItemQualityColor(3))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\3.mp3', -- Rare
    [select(4, GetItemQualityColor(4))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\4.mp3', -- Epic
    [select(4, GetItemQualityColor(5))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\5.mp3', -- Legendary
}

local ignoredItems = {
    ['Anima Gossamer'] = true,
    ['Anima Webbing'] = true,
    ['Genesis Mote'] = true,
    ['Progenitor Essentia'] = true,
    ['Protoflesh'] = true,
    ['Sandworn Relic'] = true,
    ['Silken Protofiber'] = true,
}

function Module:OnEnable()
    self:RegisterEvent('CHAT_MSG_LOOT')
end

function Module:OnDisable()
    self:UnregisterEvent('CHAT_MSG_LOOT')
end

function Module:CHAT_MSG_LOOT(event, msg, _, _, _, unitName)
    local item = string.match(msg, '|h%[([^%]]+)%]|h')
    local colour = string.match(msg, '|c(%x+)|H')

    local name, realm = UnitName('player')
    local player = name .. '-' .. (realm or GetRealmName())

    local validItem = name and not ignoredItems[item]
    local validColour = colour and colourQualitySounds[colour]
    local validPlayer = unitName == player or unitName == name

    if validItem and validColour and validPlayer then
        PlaySoundFile(colourQualitySounds[colour])
    end
end
