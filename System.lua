
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
	--playerStatusText = 1,
	--targetStatusText = 1,
	showToastOnline = 1,
	showToastOffline = 0,
	scriptErrors = 1,
}

local volumeLevel, viewIndex


function Module:OnInitialize()
	for key, value in pairs(defaultCVarValues) do
		SetCVar(key, value)
	end
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	ATOM:SetView(2)
end


function ATOM:SetView(index)
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


function ATOM:SetVolume(level)
	if level then
		volumeLevel = level
	else
		volumeLevel = volumeLevel == 100 and 10 or 100
	end
	SetCVar('Sound_MasterVolume', volumeLevel / 100)
	ATOM:Print('Volume Level %d', volumeLevel)
end
