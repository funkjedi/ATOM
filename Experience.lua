local addonName, ATOM = ...
local Module = ATOM:NewModule('Experience')

local data = nil
local defaults = { profile = { showXPGainMessage = true } }

local function InitializeData()
    if not data then
        data = {
            xp = { gain = 0, last_mob = 0, last_gain = UnitXP('player'), initial = UnitXP('player'), accumulated = 0, session = 0 },
            started = time(),
            time_played = { total = 0, level = 0 },
        }
    end
end

function Module:OnInitialize()
    self.db = ATOM.db:RegisterNamespace('Experience', defaults)
end

function Module:OnEnable()
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('TIME_PLAYED_MSG')
    self:RegisterEvent('PLAYER_XP_UPDATE')
    self:RegisterEvent('PLAYER_LEVEL_UP')
    self:RegisterEvent('CHAT_MSG_COMBAT_XP_GAIN')
    self:RegisterEvent('PLAYER_LOGIN')

    -- Start 1-second timer for tracking play time
    self.timer = self:ScheduleRepeatingTimer('OnTimer', 1)
end

function Module:PLAYER_LOGIN()
    RequestTimePlayed()
    self:UnregisterEvent('PLAYER_LOGIN')
end

function Module:PLAYER_ENTERING_WORLD()
    InitializeData()
end

function Module:TIME_PLAYED_MSG(event, total, level)
    InitializeData()
    data.time_played.total = total
    data.time_played.level = level
end

function Module:PLAYER_XP_UPDATE()
    InitializeData()
    local player_xp = UnitXP('player')
    local required = UnitXPMax('player')
    data.xp.gain = player_xp - data.xp.last_gain
    if data.xp.gain < 0 then
        data.xp.gain = 0
    end
    data.xp.last_gain = player_xp
    data.xp.session = player_xp - data.xp.initial + data.xp.accumulated

    -- Show XP gain notification (skip if Zygor is loaded as it has its own XP display)
    if self.db.profile.showXPGainMessage and data.xp.gain > 0 and not _G['ZygorGuidesViewer'] then
        local percentage = math.floor(10000 * (player_xp / required) + 0.5) / 100
        print(format('|cffbbbbffXP|r: +%d (%.1f%%) - %.1f%% to\n|cff00ff88Level %d|r: %s', data.xp.gain, data.xp.gain / required * 100,
            percentage, UnitLevel('player') + 1, self:MakeProgressBar(percentage, 100, 20)))
    end
end

function Module:PLAYER_LEVEL_UP()
    InitializeData()
    data.time_played.level = 0
    data.xp.accumulated = data.xp.accumulated + UnitXPMax('player') - data.xp.initial
    data.xp.initial = 0
end

function Module:CHAT_MSG_COMBAT_XP_GAIN(event, msg)
    InitializeData()
    -- Extract XP from messages like "You gain 150 experience"
    -- Used for kills-to-level calculation
    local kill_xp = msg:match('(%d+) experience')
    if kill_xp then
        data.xp.last_mob = tonumber(kill_xp)
        if data.xp.last_mob < 0 then
            data.xp.last_mob = 0
        end
    end
end

function Module:OnTimer()
    if data then
        data.time_played.total = data.time_played.total + 1
        data.time_played.level = data.time_played.level + 1
    end
end

function Module:MakeProgressBar(cur, max, len)
    local filled = math.floor(cur / max * len)
    return '|cffffff00[|cff00ff00' .. strrep('||', filled) .. '|cff666666' .. strrep('||', len - filled) .. '|cffffff00]|r'
end

function Module:FormatTime(duration)
    if not duration or duration < 0 then
        return 'N/A'
    end

    local days = math.floor(duration / 86400)
    local hours = math.floor(duration / 3600) - (days * 24)
    local minutes = math.floor(duration / 60) - (days * 1440) - (hours * 60)
    local seconds = duration % 60

    local timeText = ''
    if days ~= 0 then
        timeText = timeText .. format('%dd ', days)
    end
    if days ~= 0 or hours ~= 0 then
        timeText = timeText .. format('%dh ', hours)
    end
    if days ~= 0 or hours ~= 0 or minutes ~= 0 then
        timeText = timeText .. format('%dm ', minutes)
    end
    timeText = timeText .. format('%ds', seconds)

    return timeText
end

function Module:GetExperience()
    InitializeData()
    local current = UnitXP('player')
    local required = UnitXPMax('player')
    local remaining = required - current
    local percentage = math.floor(10000 * (current / required) + 0.5) / 100
    local rested = GetXPExhaustion() or 0
    local played = data.time_played.total

    local session = { gained = data.xp.session, duration = time() - data.started, last_gain = data.xp.gain, last_mob = data.xp.last_mob }
    session.per_hour = session.gained / session.duration * 3600
    session.time_to_level = session.gained == 0 and -1 or math.ceil((required - current) / session.gained * session.duration)

    local level = { duration = data.time_played.level, per_hour = current / data.time_played.level * 3600 }
    level.time_to_level = current == 0 and -1 or math.ceil((required - current) / current * level.duration)

    local gains_to_level = session.last_gain ~= 0 and math.ceil(remaining / session.last_gain) or 'N/A'
    local kills_to_level = session.last_mob ~= 0 and math.ceil(remaining / session.last_mob) or 'N/A'

    return {
        current = current,
        required = required,
        remaining = remaining,
        percentage = percentage,
        rested = rested,
        played = played,
        session = session,
        level = level,
        gains_to_level = gains_to_level,
        kills_to_level = kills_to_level,
    }
end

function Module:Reset()
    data = nil
    InitializeData()
    ATOM:Print('Experience: Session data reset.')
end

function Module:ShowStats()
    local function output(title, message)
        print(format('|cffbbbbff%s|r%s', title, message))
    end

    local stats = self:GetExperience()
    output('Total time played: ', self:FormatTime(stats.played))
    output('Time played this level: ', self:FormatTime(stats.level.duration))
    output('Time played this session: ', self:FormatTime(stats.session.duration))
    output('Total XP required: ', tostring(stats.required))
    output('Rested XP: ', tostring(stats.rested))
    output('XP gained this level: ', format('%d (%.1f%%)', stats.current, stats.percentage))
    output('XP needed to level: ', format('%d (%.1f%%)', stats.remaining, 100 - stats.percentage))
    output('XP gained this session: ', tostring(stats.session.gained))
    output(format('Kills to level (at %d XP): ', stats.session.last_mob), tostring(stats.kills_to_level))
    output(format('Gains to level (at %d XP): ', stats.session.last_gain), tostring(stats.gains_to_level))
    output('XP/hr this level: ', format('%d', stats.level.per_hour))
    output('XP/hr this session: ', format('%d', stats.session.per_hour))
    output('Time to level (level): ', self:FormatTime(stats.level.time_to_level))
    output('Time to level (session): ', self:FormatTime(stats.session.time_to_level))
end
