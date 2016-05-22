

ATOM = LibStub('AceAddon-3.0'):NewAddon('ATOM', 'AceEvent-3.0', 'AceTimer-3.0')

function ATOM:OnInitialize()
	ATOM.LSB = LibStub('LibSharedMedia-3.0')
	ATOM:RegisterSharedMediaFonts()
	ATOM:ReplaceGameFonts()
	--ATOM:AdjustFrameColours()
	ATOM:CropAuraTextures()
	ATOM:ResetSettingsToDefaults()
	ATOM:SetView(2)
	--ATOM:BagItemGlow()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
end

function ATOM:OnEnable()
	ATOM:RegisterEvent('ADDON_LOADED')
	ATOM:RegisterEvent('MAIL_SHOW')
	ATOM:RegisterEvent('MERCHANT_SHOW')
	ATOM:RegisterEvent('GOSSIP_SHOW',    'QuestNPCAutomation')
	ATOM:RegisterEvent('QUEST_GREETING', 'QuestNPCAutomation')
	ATOM:RegisterEvent('QUEST_DETAIL',   'QuestNPCAutomation')
	ATOM:RegisterEvent('QUEST_ACCEPTED', 'QuestNPCAutomation')
	ATOM:RegisterEvent('QUEST_PROGRESS', 'QuestNPCAutomation')
	ATOM:RegisterEvent('QUEST_COMPLETE', 'QuestNPCAutomation')
	ATOM:RegisterEvent('QUEST_FINISHED', 'QuestNPCAutomation')
	ATOM:RegisterEvent('GOSSIP_CLOSED',  'QuestNPCAutomation')
end

function ATOM:ADDON_LOADED(event, addonName)
	if addonName == 'Dominos_Config' then
		ATOM:DominosIncreaseMaximumScale()
	end
end

function ATOM:MAIL_SHOW()
	if not _G['ZygorGuidesViewer'] then
		ATOM:Wait(ATOM.RetrieveMailItems)
	end
end

function ATOM:MERCHANT_SHOW()
	if not _G['ZygorGuidesViewer'] then
		ATOM:SellGreyItems()
	end
	ATOM:RepairItems()
end



--[[
	Cleaner timer function for delaying execution of functions.
--]]
function ATOM:Wait(delay, func)
	ATOM:ScheduleTimer(func or delay, func and delay or 0.5)
end

--[[
	Simple print function for outputing a string to
	the chat frame.
--]]
function ATOM:Print(...)
	ChatFrame1:AddMessage('ATOM: '..string.format(...))
end

--[[
	Custom print/dump function for outputing variables and
	strings to the chat frame.
--]]
function ATOM:Dump(...)
	UIParentLoadAddOn('Blizzard_DebugTools')
	if _G['DevTools_Dump'] then
		_G['DevTools_Dump'](...)
	else
		print(...)
	end
end


--[[
	Reset CVars to preferred settings. This is really only needed
	when setting up the client/character for the first time.
--]]
function ATOM:ResetSettingsToDefaults()
	local settings = {
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
		playerStatusText = 1,
		targetStatusText = 1,
		showToastOnline = 1,
		showToastOffline = 0,
		scriptErrors = 1,
	}
	for key, value in pairs(settings) do
		SetCVar(key, value)
	end
end


--[[
	Explicitly switch between views.
--]]
function ATOM:SetVolume(level)
	if level then
		ATOM.volumeLevel = level
	else
		ATOM.volumeLevel = ATOM.volumeLevel == 100 and 10 or 100
	end
	SetCVar('Sound_MasterVolume', ATOM.volumeLevel / 100)
	ATOM:Print('VOLUME CHANGED TO %d', ATOM.volumeLevel)
end


--[[
	Explicitly switch between views.
--]]
function ATOM:SetView(index)
	if index then
		ATOM.viewIndex = index
	else
		ATOM.viewIndex = ATOM.viewIndex == 3 and 2 or 3
	end
	-- Calling SetView twice will prevent the slow transition and
	-- instead switch immediately to the view
	SetView(ATOM.viewIndex)
	SetView(ATOM.viewIndex)
end


--[[
	Show the scoreboard when in Battleground.
--]]
function ATOM:ShowScore()
	WorldStateScoreFrame:Show()
end


--[[
	Buy a stack of items from a vendor. This will by pass the
	purchase confirmation given by some merchants.
--]]
function ATOM:Buy(name, quantity)
	local slot
	for slot = 1, GetMerchantNumItems() do
		if name == GetMerchantItemInfo(slot) then
			BuyMerchantItem(slot, quantity or 1)
			break
		end
	end
end


--[[
	Destroy any heirlooms found in the players bags.
--]]
function ATOM:DestroyHeirlooms()
	local bag, slot
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local name = GetContainerItemLink(bag, slot)
			if name and string.find(name, 'ffe6cc80') then
				ATOM:Print(name..' destroyed.')
				PickupContainerItem(bag, slot)
				DeleteCursorItem()
			end
		end
	end
end


--[[
	Handle mount selection in an intelligent way.
--]]
function ATOM:Mount(mountName)
	if IsMounted() then
		return Dismount()
	end
	local currentMapAreaID = GetCurrentMapAreaID()
	-- Mount for the Temple of Ahn'Qiraji
	if currentMapAreaID == 766 then
		return CastSpellByName('Red Qiraji Battle Tank')
	end
	-- Mount for Nagrand in Draenor
	if currentMapAreaID == 950 then
		return CastSpellByName('Garrison Ability')
	end
	if IsSwimming() then
		-- Mount for Vashj'ir
		if currentMapAreaID == 610 or currentMapAreaID == 612 or currentMapAreaID == 615 then
			return CastSpellByName("Vashj'ir Seahorse")
		end
		-- Mount for The Anglers (walk on water)
		if GetSpellInfo('Azure Water Strider') then
			return CastSpellByName('Azure Water Strider')
		end
	end
	local mountType
	for i=1, C_MountJournal.GetNumMounts() do
		if mountName == C_MountJournal.GetMountInfo(i) then
			mountType = select(5, C_MountJournal.GetMountInfoExtra(i))
			break
		end
	end
	if mountType then
		if IsFlyableArea() then
			if mountType == 248 then
				return CastSpellByName(mountName)
			end
		else
			return CastSpellByName(mountName)
		end
	end
	if IsControlKeyDown() then
		return CastSpellByName("Ashes of Al'ar")
	end
	C_MountJournal.Summon(0)
end


--[[
	Sell junk (grays).
--]]
function ATOM:SellGreyItems()
	local bag, slot
	local totalprofit = 0
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local _, count, _, quality, _, _, link = GetContainerItemInfo(bag, slot)
			if link and quality == 0 then
				local vendorPrice = select(11, GetItemInfo(link))
				if vendorPrice > 0 then
					totalprofit = totalprofit + vendorPrice*count
					UseContainerItem(bag, slot)
				end
			end
		end
	end
	if totalprofit > 0 then
		ATOM:Print('|cff80ff80TOTAL PROFIT OF |cffffff80%s|cff80ff80 ON SOLD GREYS|r', GetMoneyString(totalprofit))
	end
end


--[[
	Repair damaged gear.
--]]
function ATOM:RepairItems()
	if CanMerchantRepair() then
		local repairAllCost, canRepair = GetRepairAllCost()
		if canRepair and repairAllCost <= GetMoney() then
			RepairAllItems()
			ATOM:Print('|cff80ff80REPAIRS COMPLETED FOR |cffffff80%s|r', GetMoneyString(repairAllCost))
		end
	end
end


--[[
	Collect items and gold from Mailbox.
--]]
function ATOM:RetrieveMailItems()
	local function CollectableItem(index)
		local _, _, _, _, money, CODAmount, _, itemCount = GetInboxHeaderInfo(index)
		if money > 0 or (itemCount and itemCount > 0) and CODAmount <= 0 then
			return index
		end
	end
	local checkMailbox
	function CheckMailbox(index)
		if not InboxFrame:IsVisible() or index <= 0 then
			if select(2, GetInboxNumItems()) == 0 then
				MiniMapMailFrame:Hide()
			end
			return
		end
		if CollectableItem(index) then
			AutoLootMailItem(index)
		end
		ATOM:Wait(function()
			CheckMailbox(CollectableItem(index) or (index - 1))
		end)
	end
	CheckMailbox(GetInboxNumItems())
end


--[[
	Provide optional automation of accepting and turning in quests.
--]]
function ATOM:QuestNPCAutomation(event, ...)
	if not IsControlKeyDown() then
		return
	end
	if event == 'GOSSIP_SHOW' then
		if GetNumGossipOptions() > 0 then
			--return
		end
		for i=1, GetNumGossipAvailableQuests() do
			SelectGossipAvailableQuest(i)
		end
		for i=1, GetNumGossipActiveQuests() do
			SelectGossipActiveQuest(i)
		end
	end
	if event == 'QUEST_GREETING' then
		if GetNumGossipOptions() > 0 then
			--return
		end
		for i=1, GetNumAvailableQuests() do
			SelectAvailableQuest(i)
		end
		for i=1, GetNumActiveQuests() do
			SelectActiveQuest(i)
		end
	end
	if event == 'QUEST_DETAIL' then
		if not QuestGetAutoAccept() then
			AcceptQuest()
		end
	end
	if event == 'QUEST_PROGRESS' then
		if IsQuestCompletable() then
			CompleteQuest()
		end
	end
	if event == 'QUEST_COMPLETE' then
		if GetNumQuestChoices() == 0 then
			GetQuestReward(nil)
		end
	end
	if event == 'QUEST_FINISHED' or event == 'GOSSIP_CLOSED' then
		--//
	end
end


--[[
	Register fonts with LibSharedMedia.
--]]
function ATOM:RegisterSharedMediaFonts()
	local fonts = {
		['Lato']            = 'Lato\\Lato-Regular',
		['Lato Bold']       = 'Lato\\Lato-Bold',
		['Myriad Pro']      = 'MyriadPro\\MyriadPro-Regular',
		['Myriad Pro Bold'] = 'MyriadPro\\MyriadPro-Bold',
	}
	for fontName, fontPath in pairs(fonts) do
		ATOM.LSB:Register(ATOM.LSB.MediaType.FONT, fontName, 'Interface\\AddOns\\Atom\\Fonts\\'..fontPath..'.ttf')
	end
end


--[[
	Replace the in-game fonts.
--]]
function ATOM:ReplaceGameFonts()
	local NORMAL = 'Interface\\AddOns\\Atom\\Fonts\\Lato\\Lato-Regular.ttf'
	local STRONG = 'Interface\\AddOns\\Atom\\Fonts\\Lato\\Lato-Bold.ttf'

	local function SetFont(fontPath, fontFamily, fontHeight, fontFlags)
		local _, height, flags = fontFamily:GetFont()
		if type(fontHeight) == 'string' then
			fontFlags = fontHeight
			fontHeight = nil
		end
		if type(fontHeight) == 'boolean' then
			fontHeight = height
		end
		if not fontHeight then
			fontHeight = height
			if fontHeight < 16 then
				fontHeight = fontHeight * 1.2
			end
		end
		fontFamily:SetFont(fontPath, fontHeight, fontFlags or flags)
	end

	-- Extracted from FrameXML/Fonts.xml
	UNIT_NAME_FONT       = NORMAL
	STANDARD_TEXT_FONT   = NORMAL
	DAMAGE_TEXT_FONT     = STRONG

	-- Extracted from FrameXML/FontStyles.xml
	UNIT_NAME_FONT_ROMAN = NORMAL

	-- Extracted from FrameXML/Fonts.xml
	-- /Ui/FontFamily[Member/Font[@font='Fonts\FRIZQT__.TTF']]/@name
	SetFont(NORMAL, SystemFont_Small)
	SetFont(STRONG, SystemFont_Outline_Small)
	SetFont(NORMAL, SystemFont_Outline)
	SetFont(STRONG, SystemFont_InverseShadow_Small)
	SetFont(NORMAL, SystemFont_Med2)
	SetFont(NORMAL, SystemFont_Med3)
	SetFont(NORMAL, SystemFont_Shadow_Med3)
	SetFont(NORMAL, SystemFont_Huge1)
	SetFont(NORMAL, SystemFont_Huge1_Outline)
	SetFont(NORMAL, SystemFont_OutlineThick_Huge2)
	SetFont(STRONG, SystemFont_OutlineThick_Huge4)
	SetFont(STRONG, SystemFont_OutlineThick_WTF)
	SetFont(NORMAL, NumberFont_GameNormal)
	SetFont(NORMAL, NumberFont_OutlineThick_Mono_Small, 'OUTLINE')
	SetFont(NORMAL, Game30Font)
	SetFont(STRONG, SpellFont_Small)
	SetFont(NORMAL, InvoiceFont_Med)
	SetFont(NORMAL, InvoiceFont_Small)
	SetFont(NORMAL, Tooltip_Med)
	SetFont(STRONG, Tooltip_Small)
	SetFont(STRONG, AchievementFont_Small)
	SetFont(NORMAL, ReputationDetailFont)
	SetFont(NORMAL, FriendsFont_Normal)
	SetFont(NORMAL, FriendsFont_Small)
	SetFont(NORMAL, FriendsFont_Large)
	SetFont(STRONG, GameFont_Gigantic)
	SetFont(NORMAL, ChatBubbleFont)

	-- Extracted from SharedXML/Fonts.xml
	-- /Ui/FontFamily[Member/Font[@font='Fonts\ARIALN.TTF']]/@name
	SetFont(NORMAL, NumberFont_Shadow_Small)
	SetFont(STRONG, NumberFont_OutlineThick_Mono_Small)
	SetFont(NORMAL, NumberFont_Shadow_Med)
	SetFont(NORMAL, NumberFont_Normal_Med)
	SetFont(STRONG, NumberFont_Outline_Med)
	SetFont(STRONG, NumberFont_Outline_Large)
	SetFont(STRONG, FriendsFont_UserText)
	SetFont(NORMAL, ChatBubbleFont)

	-- Extracted from SharedXML/Fonts.xml
	-- /Ui/FontFamily[Member/Font[@font='Fonts\MORPHEUS.ttf']]/@name
	SetFont(NORMAL, Fancy16Font)
	SetFont(STRONG, QuestFont_Huge)
	SetFont(NORMAL, QuestFont_Outline_Huge)
	SetFont(STRONG, QuestFont_Super_Huge)
	SetFont(NORMAL, QuestFont_Super_Huge_Outline)
	SetFont(NORMAL, SplashHeaderFont)
	SetFont(NORMAL, QuestFont_Enormous)
	SetFont(NORMAL, DestinyFontLarge)
	SetFont(NORMAL, CoreAbilityFont)
	SetFont(NORMAL, DestinyFontHuge)
	SetFont(NORMAL, QuestFont_Shadow_Small)
	SetFont(NORMAL, MailFont_Large, 15)

	-- Extracted from SharedXML/Fonts.xml
	-- /Ui/FontFamily[Member/Font[@font='Fonts\skurri.ttf']]/@name
	SetFont(STRONG, NumberFont_Outline_Huge)

	-- Extracted from FrameXML/SharedFonts.xml
	-- /Ui/FontFamily[Member/Font[@font='Fonts\FRIZQT__.TTF']]/@name
	SetFont(NORMAL, SystemFont_Tiny)
	SetFont(STRONG, SystemFont_Shadow_Small)
	SetFont(NORMAL, SystemFont_Small2)
	SetFont(NORMAL, SystemFont_Shadow_Small2)
	SetFont(NORMAL, SystemFont_Shadow_Med1_Outline)
	SetFont(NORMAL, SystemFont_Shadow_Med1)
	SetFont(NORMAL, SystemFont_Large)
	SetFont(NORMAL, SystemFont_Shadow_Large_Outline)
	SetFont(NORMAL, SystemFont_Shadow_Med2)
	SetFont(NORMAL, SystemFont_Shadow_Large)
	SetFont(NORMAL, SystemFont_Shadow_Large2)
	SetFont(STRONG, SystemFont_Shadow_Huge1)
	SetFont(NORMAL, SystemFont_Huge2)
	SetFont(NORMAL, SystemFont_Shadow_Huge2)
	SetFont(STRONG, SystemFont_Shadow_Huge3)
	SetFont(NORMAL, SystemFont_Shadow_Outline_Huge2)
	SetFont(NORMAL, SystemFont_Med1)
	SetFont(NORMAL, SystemFont_OutlineThick_WTF2)
	SetFont(STRONG, GameTooltipHeader)

	-- Extracted from SharedXML/ShardFonts.xml
	-- /Ui/FontFamily[Member/Font[@font='Fonts\MORPHEUS.TTF']]/@name
	SetFont(NORMAL, QuestFont_Large)

	-- Custom changes
	SetFont(NORMAL, ChatFontNormal, 13)
	SetFont(STRONG, FocusFontSmall, 12)
	SetFont(STRONG, TextStatusBarTextLarge, 12)
end


--[[
	Recolour the Player and Target frames making them darker.
--]]
function ATOM:AdjustFrameColours()
	local function ColourFrame(frame)
		if frame then
			frame:SetVertexColor(.05, .05, .05)
		end
	end

	ColourFrame(PlayerFrameTexture)
	ColourFrame(PlayerFrameAlternateManaBarBorder)
	ColourFrame(PlayerFrameAlternateManaBarLeftBorder)
	ColourFrame(PlayerFrameAlternateManaBarRightBorder)
	--ColourFrame(AlternatePowerBarBorder)
	--ColourFrame(AlternatePowerBarLeftBorder)
	--ColourFrame(AlternatePowerBarRightBorder)
	ColourFrame(TargetFrameTextureFrameTexture)
	ColourFrame(PetFrameTexture)
	ColourFrame(PartyMemberFrame1Texture)
	ColourFrame(PartyMemberFrame2Texture)
	ColourFrame(PartyMemberFrame3Texture)
	ColourFrame(PartyMemberFrame4Texture)
	ColourFrame(PartyMemberFrame1PetFrameTexture)
	ColourFrame(PartyMemberFrame2PetFrameTexture)
	ColourFrame(PartyMemberFrame3PetFrameTexture)
	ColourFrame(PartyMemberFrame4PetFrameTexture)
	ColourFrame(FocusFrameTextureFrameTexture)
	ColourFrame(TargetFrameToTTextureFrameTexture)
	ColourFrame(FocusFrameToTTextureFrameTexture)
	ColourFrame(Boss1TargetFrameTextureFrameTexture)
	ColourFrame(Boss2TargetFrameTextureFrameTexture)
	ColourFrame(Boss3TargetFrameTextureFrameTexture)
	ColourFrame(Boss4TargetFrameTextureFrameTexture)
	ColourFrame(Boss5TargetFrameTextureFrameTexture)
	ColourFrame(Boss1TargetFrameSpellBarBorder)
	ColourFrame(Boss2TargetFrameSpellBarBorder)
	ColourFrame(Boss3TargetFrameSpellBarBorder)
	ColourFrame(Boss4TargetFrameSpellBarBorder)
	ColourFrame(Boss5TargetFrameSpellBarBorder)
	--ColourFrame(select(5, ShardBarFrameShard1:GetRegions()))
	--ColourFrame(select(5, ShardBarFrameShard2:GetRegions()))
	--ColourFrame(select(5, ShardBarFrameShard3:GetRegions()))
	--ColourFrame(select(5, ShardBarFrameShard4:GetRegions()))
	--ColourFrame(select(1, BurningEmbersBarFrame:GetRegions()))
	--ColourFrame(select(1, BurningEmbersBarFrameEmber1:GetRegions()))
	--ColourFrame(select(1, BurningEmbersBarFrameEmber2:GetRegions()))
	--ColourFrame(select(1, BurningEmbersBarFrameEmber3:GetRegions()))
	--ColourFrame(select(1, BurningEmbersBarFrameEmber4:GetRegions()))
	ColourFrame(select(1, PaladinPowerBar:GetRegions()))
	--ColourFrame(select(1, ComboPoint1:GetRegions()))
	--ColourFrame(select(1, ComboPoint2:GetRegions()))
	--ColourFrame(select(1, ComboPoint3:GetRegions()))
	--ColourFrame(select(1, ComboPoint4:GetRegions()))
	--ColourFrame(select(1, ComboPoint5:GetRegions()))
	ColourFrame(CastingBarFrameBorder)
	ColourFrame(FocusFrameSpellBarBorder)
	ColourFrame(TargetFrameSpellBarBorder)
end


--[[
	Crop the buff/debuff aura textures to remove border.
--]]
function ATOM:CropAuraTextures()
	hooksecurefunc('TargetFrame_UpdateAuras', function(self)
		local name = self:GetName()
		local frame
		for i = 1, MAX_TARGET_BUFFS do
			frame = _G[name..'Buff'..i..'Icon']
			if frame then
				frame:SetTexCoord(0.06, 0.94, 0.06, 0.94)
			end
		end
	end)
end


--[[
	Always display a glow around quality items.
--]]
function ATOM:BagItemGlow()
	local function enableGlow(self)
		local quality = select(4, GetContainerItemInfo( self:GetParent():GetID(), self:GetID() ))
		if quality and quality > LE_ITEM_QUALITY_COMMON then
			self.NewItemTexture:SetAtlas(NEW_ITEM_ATLAS_BY_QUALITY[quality])
			self.NewItemTexture:SetAlpha(.8)
			self.NewItemTexture:Show()
		end
	end
	local isItemButtonHooked = {}
	hooksecurefunc('ContainerFrame_Update', function(frame)
		local name = frame:GetName()
		local itemButton
		for i=1, frame.size, 1 do
			itemButton = _G[name..'Item'..i]
			if not isItemButtonHooked[i] then
				isItemButtonHooked[i] = true
				itemButton:HookScript('OnEnter', enableGlow)
				itemButton:HookScript('OnLeave', enableGlow)
			end
			enableGlow(itemButton)
		end
	end)
end


--[[
	Increase the maximum scale for Dominors Bars from 150% to 300%.
--]]
function ATOM:DominosIncreaseMaximumScale()
	if _G['Dominos'] and _G['Dominos'].Menu then
		local function Slider_OnShow(self)
			self:SetValue(self:GetParent().owner:GetScale()*100)
		end
		local function Slider_UpdateValue(self, value)
			self:GetParent().owner:SetFrameScale(value/100)
		end
		_G['Dominos'].Menu.Panel.NewScaleSlider = function(self)
			return self:NewSlider('Scale', 50, 300, 1, Slider_OnShow, Slider_UpdateValue)
		end
	end
end
