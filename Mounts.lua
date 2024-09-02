local addonName, ATOM = ...
local Module = ATOM:NewModule('Mounts')

-- LuaFormatter off
local uiMapIDs = {
    AhnQiraji = {
        -- [203] = 'Vashjir',
    },
    Vashjir = {
        [203] = 'Vashjir',
        [201] = 'Kelpthar Forest',
        [204] = 'Abyssal Depths',
        [205] = 'Shimmering Expanse',
    },
} -- LuaFormatter on

local function getMountID(name)
    if not name then
        return
    end

    for index, mountID in ipairs(C_MountJournal.GetMountIDs()) do
        local mountName = C_MountJournal.GetMountInfoByID(mountID)

        if string.find(mountName:lower(), name:lower()) then
            return mountID
        end
    end
end

local GROUND_MOUNT = getMountID('Mechacycle Model W')
local RED_QIRAJI_BATTLE_TANK = getMountID('Red Qiraji Battle Tank')
local SEA_TURTLE = getMountID('Sea Turtle')
local VASHJIR_SEAHORSE = getMountID('Vashj\'ir Seahorse')

function Module:Mount(mountName)
    if IsMounted() then
        return Dismount()
    end

    local mountID = getMountID(mountName)

    -- Mount for Temple of Ahn'Qiraji
    if uiMapIDs.AhnQiraji[playerUiMapID] then
        return C_MountJournal.SummonByID(RED_QIRAJI_BATTLE_TANK)
    end

    -- Mount for Nagrand in Draenor
    -- if currentMapAreaID == 950 then
    --     return CastSpellByName('Garrison Ability')
    -- end

    -- Mount for Vashj'ir (increases swim speed by 450%)
    if IsSwimming() and uiMapIDs.Vashjir[playerUiMapID] then
        return C_MountJournal.SummonByID(VASHJIR_SEAHORSE)
    end

    -- Mount for Swimming (increases swim speed by ~325%)
    if IsSwimming() and IsControlKeyDown() then
        return C_MountJournal.SummonByID(SEA_TURTLE)
    end

    -- If no mount was specified load on of the
    -- favourite mounts from the mount journal
    if not mountID then
        return C_MountJournal.SummonByID(0)
    end

    local mountTypeID = select(5, C_MountJournal.GetMountInfoExtraByID(mountID))

    local flyingMountTypeIDs = {
        [247] = '[Disc of the Red Flying Cloud]',
        [248] = 'Most flying mounts',
    }

    if flyingMountTypeIDs[mountTypeID] and not IsFlyableArea() then
        return C_MountJournal.SummonByID(GROUND_MOUNT)
    end

    if mountTypeID == 424 and not IsFlyableArea() and not IsAdvancedFlyableArea() then
        return C_MountJournal.SummonByID(GROUND_MOUNT)
    end

    return C_MountJournal.SummonByID(mountID)
end
