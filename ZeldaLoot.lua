local addonName, ATOM = ...
local Module = ATOM:NewModule('ZeldaLoot')

local colorQuality = {
    [select(4, GetItemQualityColor(2))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\2.mp3',
    [select(4, GetItemQualityColor(3))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\3.mp3',
    [select(4, GetItemQualityColor(4))] = 'Interface\\AddOns\\ATOM\\Sounds\\ZeldaLoot\\4.mp3',
}

function Module:OnEnable()
    self:RegisterEvent('CHAT_MSG_LOOT')
end

function Module:OnDisable()
    self:UnregisterEvent('CHAT_MSG_LOOT')
end

function Module:CHAT_MSG_LOOT(event, msg)
    for color in msg:gmatch('ff[%da-f][%da-f][%da-f][%da-f][%da-f][%da-f]') do
        if colorQuality[color] then
            PlaySoundFile(colorQuality[color])
            break
        end
    end
end
