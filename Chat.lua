local addonName, ATOM = ...
local Module = ATOM:NewModule('Chat')

function Module:OnEnable()
    self:RegisterEvent('CHAT_MSG_SYSTEM')
end

function ATOM:Print(...)
    DEFAULT_CHAT_FRAME:AddMessage('|cffffff00ATOM:|r ' .. string.format(...))
end

function ATOM:Dump(...)
    UIParentLoadAddOn('Blizzard_DebugTools')

    if _G['DevTools_Dump'] then
        _G['DevTools_Dump'](...)
    else
        print(...)
    end
end

function ATOM:RaidWarning(msg, color)
    RaidBossEmoteFrame.slot1:Hide()
    RaidNotice_AddMessage(RaidBossEmoteFrame, msg, color or ChatTypeInfo['RAID_BOSS_EMOTE'])
end

function ATOM:MakeChatProgressBar(step, steps)
    local barWidth = 40
    local barsForCompletedSteps = floor(step / steps * barWidth)

    return ('|cffffff00[|cff00ff00%s|r|cff666666%s|r]|r'):format(strrep('||', barsForCompletedSteps),
        strrep('||', barWidth - barsForCompletedSteps))
end

function Module:CHAT_MSG_SYSTEM(event, msg)
    if string.find(msg, 'You have been outbid on') then
        ATOM:RaidWarning(msg)
        PlaySound(5958) -- // Time is money, friend.
    end
end
