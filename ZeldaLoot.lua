local addonName, ATOM = ...
local Module = ATOM:NewModule('ZeldaLoot')

local colourQualities = {
    [select(4, GetItemQualityColor(2))] = { sound = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\2.mp3', interval = 2 },
    [select(4, GetItemQualityColor(3))] = { sound = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\3.mp3', interval = 2 },
    [select(4, GetItemQualityColor(4))] = { sound = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\4.mp3', interval = 2 },
    [select(4, GetItemQualityColor(5))] = { sound = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\5.mp3', interval = 7 },
    [select(4, GetItemQualityColor(6))] = { sound = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\6.mp3', interval = 15 },
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

    if not item or ignoredItems[item] then
        return
    end

    local colour = string.match(msg, '|c(%x+)|H')
    local colourQuality = colour and colourQualities[colour]

    if not colourQuality then
        return
    end

    local player, realm = UnitName('player')
    local playerID = player .. '-' .. (realm or GetRealmName())

    if player ~= unitName and playerID ~= unitName then
        return
    end

    -- avoid spamming the same sound
    if (colourQuality.timestamp ~= nil) then
        if (time() - colourQuality.timestamp < colourQuality.interval) then
            return
        end
    end

    colourQuality.timestamp = time()
    PlaySoundFile(colourQuality.sound)
end
