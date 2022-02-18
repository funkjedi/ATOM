local addonName, ATOM = ...
local Module = ATOM:NewModule('Macros')

local raidTargetIndex = 0

function Module:OnEnable()
    self:RegisterChatCommand('mtar', 'TargetMacroSlashCommand')
end

function Module:CreateOrUpdateMacro(name, body, icon)
    local macroID = GetMacroIndexByName(name)

    if macroID ~= 0 then
        return EditMacro(macroID, name, icon or select(2, GetMacroInfo(name)), body or '')
    end

    return CreateMacro(name, icon or 'INV_MISC_QUESTIONMARK', body or '', false)
end

function Module:UpdateTargetMacro(name)
    local body = [[
/tar %s
/cleartarget [noexists][dead]
/stopmacro [noexists][dead]
/atom mark
]]

    if not name then
        body = '/atom mark'
    end

    self:CreateOrUpdateMacro('TARGET', body:format(name), 'ACHIEVEMENT_HALLOWEEN_SMILEY_01')
end

function Module:TargetMacroSlashCommand(msg)
    self:UpdateTargetMacro(self:GetArgs(msg))
end

function Module:MarkTarget(index)
    local cycle = index == 'cycle'

    if cycle then
        index = raidTargetIndex < 8 and raidTargetIndex + 1 or 1
        raidTargetIndex = index
    else
        index = tonumber(index) or 8
    end

    if GetRaidTargetIndex('target') ~= index then
        SetRaidTarget('target', index)

        if not cycle then
            PlaySoundFile(567458)
        end
    end
end

function Module:PickPocketMark()
    if IsSpellInRange('Pick Pocket') then
        self:MarkTarget('cycle')
    end
end
