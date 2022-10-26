local addonName, ATOM = ...
local Module = ATOM:NewModule('Textures')

local CropAuraTextures, DarkenFrames

function Module:OnInitialize()
    DarkenFrames()
    -- hooksecurefunc('TargetFrame_UpdateAuras', CropAuraTextures)
end

function CropAuraTextures(self)
    local name = self:GetName()
    local frame
    for i = 1, MAX_TARGET_BUFFS do
        frame = _G[name .. 'Buff' .. i .. 'Icon']
        if frame then
            frame:SetTexCoord(0.06, 0.94, 0.06, 0.94)
        end
    end
end

local function ChangeVertexColor(t, value, alpha)
    if not t then
        return
    end

    value = value or 64
    alpha = alpha or 1

    t:SetVertexColor(value / 255, value / 255, value / 255, alpha)
end

local function ConfigureActionButton(bu)
    if not bu then
        return
    end

    local name = bu:GetName()

    local ic = _G[name .. 'Icon']
    local co = _G[name .. 'Count']
    local ho = _G[name .. 'HotKey']
    local na = _G[name .. 'Name']
    local nt = _G[name .. 'NormalTexture']
    local fob = _G[name .. 'FlyoutBorder']
    local fobs = _G[name .. 'FlyoutBorderShadow']

    co:Hide()
    na:Hide()

    ho:SetFont(DAMAGE_TEXT_FONT, 18, 'OUTLINE')

    ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    ic:SetPoint('TOPLEFT', bu, 'TOPLEFT', 2, -2)
    ic:SetPoint('BOTTOMRIGHT', bu, 'BOTTOMRIGHT', -2, 2)

    ChangeVertexColor(nt)
    ChangeVertexColor(bu.RightDivider)

    if bu.SlotBackground then
        bu.SlotBackground:SetTexture([[Interface\AddOns\ATOM\Textures\ButtonBackdrop]])
    end

    if fob then
        fob:SetTexture(nil)
    end

    if fobs then
        fobs:SetTexture(nil)
    end
end

function DarkenFrames()
    ChangeVertexColor(MainMenuBar.BorderArt)
    ChangeVertexColor(MainMenuBar.EndCaps.RightEndCap, 120)
    ChangeVertexColor(MainMenuBar.EndCaps.LeftEndCap, 120)

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        ConfigureActionButton(_G['ActionButton' .. i])
        ConfigureActionButton(_G['MultiBarLeftButton' .. i])
        ConfigureActionButton(_G['MultiBarRightButton' .. i])
        ConfigureActionButton(_G['MultiBarBottomLeftButton' .. i])
        ConfigureActionButton(_G['MultiBarBottomRightButton' .. i])
    end
end
