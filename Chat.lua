local addonName, ATOM = ...
local Module = ATOM:NewModule('Chat')

function Module:OnEnable()
    self:RegisterEvent('CHAT_MSG_SYSTEM')
    self:RegisterChatCommand('atom', 'SlashCommand')
    self:RegisterChatCommand('clear', 'Clear')
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
    local safeMsg = ATOM.safestr(msg)

    if string.find(safeMsg, 'You have been outbid on') then
        ATOM:RaidWarning(safeMsg)
        PlaySound(5958) -- // Time is money, friend.
    end
end

function Module:Clear()
    DEFAULT_CHAT_FRAME:Clear()
end

function Module:SlashCommand(msg)
    local cmd, args = msg:match('^(%S+)%s*(.*)')

    if cmd == 'clear' then
        self:Clear()
    elseif cmd == 'count' then
        ATOM:CreateItemCountFrame(args)
    elseif cmd == 'countdown' then
        C_PartyInfo.DoCountdown(tonumber(args) * 60)
    elseif cmd == 'bags' then
        ATOM:GetModule('Bags'):ExportBagItems()
    elseif cmd == 'destroy' then
        ATOM:GetModule('Bags'):DestroyItems(args == 'true')
    elseif cmd == 'dialogui' then
        DialogueUI_ShowSettingsFrame()
    elseif cmd == 'mark' then
        ATOM:GetModule('Macros'):MarkTarget(args ~= '' and args or nil)
    elseif cmd == 'mount' then
        ATOM:GetModule('Mounts'):Mount(args)
    elseif cmd == 'move' then
        SetCVar('autoInteract', GetCVar('autoInteract') ~= '1' and '1' or '0')
    elseif cmd == 'powerleveling' then
        ATOM:GetModule('BattlePets'):GetActivePowerlevelingBattlePetTrainer()
    elseif cmd == 'quest' then
        ATOM:GetModule('Quest'):QuestCompleted(args)
    elseif cmd == 'scoreboard' then
        WorldStateScoreFrame:Show()
    elseif cmd == 'solves' then
        ATOM:TolvirSolves()
    elseif cmd == 'screenshot' then
        Screenshot()
    elseif cmd == 'target' then
        ATOM:GetModule('Macros'):UpdateTargetMacro(args)
    elseif cmd == 'underlight' then
        ATOM:GetModule('Bags'):ReactivateUnderlightAngler()
    elseif cmd == 'view' then
        ATOM:GetModule('System'):SetView(args ~= '' and tonumber(args) or false)
    elseif cmd == 'volume' then
        ATOM:GetModule('System'):SetVolume(args ~= '' and tonumber(args) or false)
    elseif cmd == 'wago' then
        ATOM:GetModule('Wago'):ShowWindow()
    elseif cmd == 'xp' then
        if args == 'reset' then
            ATOM:GetModule('Experience'):Reset()
        else
            ATOM:GetModule('Experience'):ShowStats()
        end
    elseif cmd == 'way' then
        ATOM:SetUserWaypoint(args)
    else
        ATOM:Print('Available commands:')
        ATOM:Print('  bags, clear, count, countdown,')
        ATOM:Print('  destroy, dialogui, mark, mount,')
        ATOM:Print('  move, powerleveling, quest,')
        ATOM:Print('  scoreboard, screenshot, solves,')
        ATOM:Print('  target, underlight, view, volume,')
        ATOM:Print('  wago, way, xp')
    end
end
