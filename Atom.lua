

ATOM = LibStub('AceAddon-3.0'):NewAddon('ATOM', 'AceEvent-3.0', 'AceTimer-3.0')

function ATOM:OnInitialize()
	ATOM.LSB = LibStub('LibSharedMedia-3.0')
	ATOM:RegisterSharedMediaFonts()
	ATOM:ReplaceGameFonts()
	ATOM:ResetSettingsToDefaults()
	ATOM:SetView(2)
end

function ATOM:OnEnable()
	ATOM:RegisterEvent('MAIL_SHOW')
	ATOM:RegisterEvent('MERCHANT_SHOW')
end

function ATOM:MAIL_SHOW()
	if not _G['ZygorGuidesViewer'] then
		ATOM:Wait(ATOM.CollectMail)
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
		autoQuestWatch = 0,
    autoQuestProgress = 0,
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
		ATOM.volumeLevel = ATOM.volumeLevel == 100 and 25 or 100
	end
	SetCVar('Sound_MasterVolume', ATOM.volumeLevel / 100)
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
	return CastSpellByName('Frosty Flying Carpet')
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
		ATOM:Print('Total profit of %s on sold greys.', GetMoneyString(totalprofit))
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
			ATOM:Print('Repairs completed for %s.', GetMoneyString(repairAllCost))
		end
	end
end


--[[
	Collect items and gold from Mailbox.
--]]
function ATOM:CollectMail()
	local function CollectableItem(index)
		local _, _, _, _, money, CODAmount, _, itemCount = GetInboxHeaderInfo(index)
		if money > 0 or (itemCount and itemCount > 0) and CODAmount <= 0 then
			return index
		end
	end
	local checkMailbox
	function CheckMailbox(index)
		if not InboxFrame:IsVisible() or index <= 0 then
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
	Register fonts with LibSharedMedia.
--]]
function ATOM:RegisterSharedMediaFonts()
	local fonts = {
		['Lato']            = 'Lato\\Lato-Regular',
		['Lato Bold']       = 'Lato\\Lato-Bold',
		['Myriad Pro']      = 'Myriad_Pro\\MyriadPro-Regular',
		['Myriad Pro Bold'] = 'Myriad_Pro\\MyriadPro-Bold',
	}
	for fontName, fontPath in pairs(fonts) do
		ATOM.LSB:Register(ATOM.LSB.MediaType.FONT, fontName, 'Interface\\AddOns\\Atom\\Fonts\\'..fontPath..'.ttf')
	end
end


--[[
	Based on the font replacement done in tekticles.
	https://github.com/TekNoLogic/tekticles
--]]
function ATOM:ReplaceGameFonts(font)
	font = font or 'MyriadPro'

	local NORMAL     = 'Interface\\AddOns\\Atom\\Fonts\\'..font..'\\'..font..'-Regular.ttf'
	local BOLD       = 'Interface\\AddOns\\Atom\\Fonts\\'..font..'\\'..font..'-Bold.ttf'
	local BOLDITALIC = 'Interface\\AddOns\\Atom\\Fonts\\'..font..'\\'..font..'-BoldItalic.ttf'
	local ITALIC     = 'Interface\\AddOns\\Atom\\Fonts\\'..font..'\\'..font..'-Italic.ttf'
	local NUMBER     = 'Interface\\AddOns\\Atom\\Fonts\\'..font..'\\'..font..'-Bold.ttf'

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}

	UNIT_NAME_FONT     = NORMAL
	DAMAGE_TEXT_FONT   = NUMBER
	STANDARD_TEXT_FONT = NORMAL

	--[[
		Set various font, text and frame options. This helper function
		simplifies the process of replace the majority of the Game fonts and styles.
	--]]
	local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
		obj:SetFont(font, size, style)
		if sr and sg and sb then
			obj:SetShadowColor(sr, sg, sb)
		end
		if sox and soy then
			obj:SetShadowOffset(sox, soy)
		end
		if r and g and b then
			obj:SetTextColor(r, g, b)
		elseif r then
			obj:SetAlpha(r)
		end
	end

	-- Base fonts
	SetFont(AchievementFont_Small,                BOLD, 12)
	SetFont(FriendsFont_Large,                  NORMAL, 15, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Normal,                 NORMAL, 13, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Small,                  NORMAL, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_UserText,               NUMBER, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameTooltipHeader,                    BOLD, 15, 'OUTLINE')
	SetFont(GameFont_Gigantic,                    BOLD, 32, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameNormalNumberFont,                 BOLD, 11)
	SetFont(InvoiceFont_Med,                    ITALIC, 13, nil, 0.15, 0.09, 0.04)
	SetFont(InvoiceFont_Small,                  ITALIC, 11, nil, 0.15, 0.09, 0.04)
	SetFont(MailFont_Large,                     ITALIC, 15, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1)
	SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER, 13, 'OUTLINE')
	SetFont(NumberFont_Outline_Huge,            NUMBER, 30, 'THICKOUTLINE', 30)
	SetFont(NumberFont_Outline_Large,           NUMBER, 17, 'OUTLINE')
	SetFont(NumberFont_Outline_Med,             NUMBER, 15, 'OUTLINE')
	SetFont(NumberFont_Shadow_Med,              NORMAL, 14)
	SetFont(NumberFont_Shadow_Small,            NORMAL, 12)
	SetFont(QuestFont_Shadow_Small,             NORMAL, 16)
	SetFont(QuestFont_Large,                    NORMAL, 16)
	SetFont(QuestFont_Huge,                       BOLD, 19, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(QuestFont_Shadow_Huge,                BOLD, 19, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(QuestFont_Super_Huge,                 BOLD, 24)
	SetFont(ReputationDetailFont,                 BOLD, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SpellFont_Small,                      BOLD, 11)
	SetFont(SystemFont_InverseShadow_Small,       BOLD, 11)
	SetFont(SystemFont_Large,                   NORMAL, 17)
	SetFont(SystemFont_Med1,                    NORMAL, 13)
	SetFont(SystemFont_Med2,                    ITALIC, 14, nil, 0.15, 0.09, 0.04)
	SetFont(SystemFont_Med3,                    NORMAL, 15)
	SetFont(SystemFont_OutlineThick_Huge2,      NORMAL, 22, 'THICKOUTLINE')
	SetFont(SystemFont_OutlineThick_Huge4,  BOLDITALIC, 27, 'THICKOUTLINE')
	SetFont(SystemFont_OutlineThick_WTF,    BOLDITALIC, 31, 'THICKOUTLINE', nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SystemFont_Outline_Small,           NUMBER, 13, 'OUTLINE')
	SetFont(SystemFont_Shadow_Huge1,              BOLD, 20)
	SetFont(SystemFont_Shadow_Huge3,              BOLD, 25)
	SetFont(SystemFont_Shadow_Large,            NORMAL, 17)
	SetFont(SystemFont_Shadow_Med1,             NORMAL, 13)
	SetFont(SystemFont_Shadow_Med2,             NORMAL, 14)
	SetFont(SystemFont_Shadow_Med3,             NORMAL, 15)
	SetFont(SystemFont_Shadow_Outline_Huge2,    NORMAL, 22, 'OUTLINE')
	SetFont(SystemFont_Shadow_Small,              BOLD, 11)
	SetFont(SystemFont_Small,                   NORMAL, 12)
	SetFont(SystemFont_Tiny,                    NORMAL, 11)
	SetFont(Tooltip_Med,                        NORMAL, 13)
	SetFont(Tooltip_Small,                        BOLD, 12)
	SetFont(WhiteNormalNumberFont,                BOLD, 11)

	-- Derived fonts
	SetFont(BossEmoteNormalHuge,     BOLDITALIC, 27, 'THICKOUTLINE')
	SetFont(CombatTextFont,              NORMAL, 26)
	SetFont(ErrorFont,                   ITALIC, 16, nil, 60)
	SetFont(QuestFontNormalSmall,          BOLD, 13, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(WorldMapTextFont,        BOLDITALIC, 31, 'THICKOUTLINE',  40, nil, nil, 0, 0, 0, 1, -1)

	for i=1,7 do
		local f = _G['ChatFrame'..i]
		local font, size = f:GetFont()
		f:SetFont(NORMAL, size)
	end

	for i=1,MAX_CHANNEL_BUTTONS do
		local f = _G['ChannelButton'..i..'Text']
		f:SetFontObject(GameFontNormalSmallLeft)
	end

	for _,butt in pairs(PaperDollTitlesPane.buttons) do
		butt.text:SetFontObject(GameFontHighlightSmallLeft)
	end
end
