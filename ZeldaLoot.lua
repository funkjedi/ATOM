local addonName, ATOM = ...
local Module = ATOM:NewModule('ZeldaLoot')

local colourQualitySounds = {
    [select(4, GetItemQualityColor(2))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\2.mp3',
    [select(4, GetItemQualityColor(3))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\3.mp3',
    [select(4, GetItemQualityColor(4))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\4.mp3',
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

function Module:CHAT_MSG_LOOT(event, msg)
    local name = string.match(msg, '|h%[([^%]]+)%]|h')
    local colour = string.match(msg, '|c(%x+)|H')

    if name and not ignoredItems[name] and colour and colourQualitySounds[colour] then
        PlaySoundFile(colourQualitySounds[colour])
    end
end
