local addonName, ATOM = ...
local Module = ATOM:NewModule('System')

local defaultCVarValues = {
    autoDismountFlying = 1,
    autoLootDefault = 1,
    assistAttack = 1,
    rotateMinimap = 0,
    screenEdgeFlash = 1,
    threatPlaySounds = 1,
    emphasizeMySpellEffects = 1,
    autoQuestWatch = 1,
    autoQuestProgress = 1,
    mapFade = 0,
    UnitNameOwn = 1,
    UnitNameNPC = 1,
    UnitNameEnemyPetName = 0,
    UnitNameFriendlyPetName = 0,
    UnitNameFriendlySpecialNPCName = 0,
    -- playerStatusText = 1,
    -- targetStatusText = 1,
    showToastOnline = 1,
    showToastOffline = 0,
    scriptErrors = 1,
}

local viewIndex, disableOrderHallCommandBar

function Module:OnInitialize()
    for key, value in pairs(defaultCVarValues) do
        SetCVar(key, value)
    end

    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()

    hooksecurefunc('OrderHall_LoadUI', disableOrderHallCommandBar)
    hooksecurefunc('OrderHall_CheckCommandBar', disableOrderHallCommandBar)

    self:SetView(2)

    -- inject a frame/texture with ZygorGuideViewer minimap icon so Leatrix can detect the texture
    local zygorMinimapIcon = CreateFrame('Frame', 'LeatrixZygorGuidesViewerMapIcon', UIParent)
    zygorMinimapIcon.texture = zygorMinimapIcon:CreateTexture('ZygorGuidesViewerMapIconIcon', 'BACKGROUND')
    zygorMinimapIcon.texture:SetTexture('Interface\\AddOns\\ATOM\\Textures\\ZygorMinimapIcon')
    zygorMinimapIcon:Show()

    hooksecurefunc(WorldMapFrame, 'Show', disableZygorMapButtonAndMenu)
end

function disableOrderHallCommandBar()
    if OrderHallCommandBar then
        OrderHallCommandBar:SetScript('OnShow', nil)
        OrderHallCommandBar:SetScript('OnHide', nil)
        OrderHallCommandBar:UnregisterAllEvents()
        OrderHallCommandBar:Hide()
    end
end

function disableZygorMapButtonAndMenu()
    if ZygorWorldMapMenu then
        ZygorWorldMapMenu:Hide()
        ZygorPoiMapButton:Hide()
    end
end

function Module:SetView(index)
    if index then
        viewIndex = index
    else
        viewIndex = viewIndex == 3 and 2 or 3
    end

    -- Calling SetView twice will prevent the slow transition and
    -- instead switch immediately to the view
    SetView(viewIndex)
    SetView(viewIndex)
end

function Module:SetVolume(volumeLevel)
    if volumeLevel == false then
        volumeLevel = tonumber(GetCVar('Sound_MasterVolume')) > 0.5 and 10 or 100
    end

    SetCVar('Sound_MasterVolume', volumeLevel / 100)
    ATOM:Print('Volume set to |cff00ff00%d|r', volumeLevel)
end

--[[
-- Temporary fix for 5.3.0 addon errors related to the changes to
-- the PlaySound and sound kits ids being required
local origPlaySound = PlaySound
function PlaySound(snd, a0, a1, a2)
    pcall(function() origPlaySound(snd, a0, a1, a2) end)
end
]]
