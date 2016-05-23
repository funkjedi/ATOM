
local addonName, ATOM = ...
local Module = ATOM:NewModule('Textures')

local CropAuraTextures, DarkenFrames


function Module:OnInitialize()
	hooksecurefunc('TargetFrame_UpdateAuras', CropAuraTextures)
end


function CropAuraTextures(self)
	local name = self:GetName()
	local frame
	for i = 1, MAX_TARGET_BUFFS do
		frame = _G[name..'Buff'..i..'Icon']
		if frame then
			frame:SetTexCoord(0.06, 0.94, 0.06, 0.94)
		end
	end
end


function DarkenFrames()
	local function ChangeFrame(frame)
		if frame then
			frame:SetVertexColor(.05, .05, .05)
		end
	end

	ChangeFrame(PlayerFrameTexture)
	ChangeFrame(PlayerFrameAlternateManaBarBorder)
	ChangeFrame(PlayerFrameAlternateManaBarLeftBorder)
	ChangeFrame(PlayerFrameAlternateManaBarRightBorder)
	--ChangeFrame(AlternatePowerBarBorder)
	--ChangeFrame(AlternatePowerBarLeftBorder)
	--ChangeFrame(AlternatePowerBarRightBorder)
	ChangeFrame(TargetFrameTextureFrameTexture)
	ChangeFrame(PetFrameTexture)
	ChangeFrame(PartyMemberFrame1Texture)
	ChangeFrame(PartyMemberFrame2Texture)
	ChangeFrame(PartyMemberFrame3Texture)
	ChangeFrame(PartyMemberFrame4Texture)
	ChangeFrame(PartyMemberFrame1PetFrameTexture)
	ChangeFrame(PartyMemberFrame2PetFrameTexture)
	ChangeFrame(PartyMemberFrame3PetFrameTexture)
	ChangeFrame(PartyMemberFrame4PetFrameTexture)
	ChangeFrame(FocusFrameTextureFrameTexture)
	ChangeFrame(TargetFrameToTTextureFrameTexture)
	ChangeFrame(FocusFrameToTTextureFrameTexture)
	ChangeFrame(Boss1TargetFrameTextureFrameTexture)
	ChangeFrame(Boss2TargetFrameTextureFrameTexture)
	ChangeFrame(Boss3TargetFrameTextureFrameTexture)
	ChangeFrame(Boss4TargetFrameTextureFrameTexture)
	ChangeFrame(Boss5TargetFrameTextureFrameTexture)
	ChangeFrame(Boss1TargetFrameSpellBarBorder)
	ChangeFrame(Boss2TargetFrameSpellBarBorder)
	ChangeFrame(Boss3TargetFrameSpellBarBorder)
	ChangeFrame(Boss4TargetFrameSpellBarBorder)
	ChangeFrame(Boss5TargetFrameSpellBarBorder)
	--ChangeFrame(select(5, ShardBarFrameShard1:GetRegions()))
	--ChangeFrame(select(5, ShardBarFrameShard2:GetRegions()))
	--ChangeFrame(select(5, ShardBarFrameShard3:GetRegions()))
	--ChangeFrame(select(5, ShardBarFrameShard4:GetRegions()))
	--ChangeFrame(select(1, BurningEmbersBarFrame:GetRegions()))
	--ChangeFrame(select(1, BurningEmbersBarFrameEmber1:GetRegions()))
	--ChangeFrame(select(1, BurningEmbersBarFrameEmber2:GetRegions()))
	--ChangeFrame(select(1, BurningEmbersBarFrameEmber3:GetRegions()))
	--ChangeFrame(select(1, BurningEmbersBarFrameEmber4:GetRegions()))
	ChangeFrame(select(1, PaladinPowerBar:GetRegions()))
	--ChangeFrame(select(1, ComboPoint1:GetRegions()))
	--ChangeFrame(select(1, ComboPoint2:GetRegions()))
	--ChangeFrame(select(1, ComboPoint3:GetRegions()))
	--ChangeFrame(select(1, ComboPoint4:GetRegions()))
	--ChangeFrame(select(1, ComboPoint5:GetRegions()))
	ChangeFrame(CastingBarFrameBorder)
	ChangeFrame(FocusFrameSpellBarBorder)
	ChangeFrame(TargetFrameSpellBarBorder)
end

