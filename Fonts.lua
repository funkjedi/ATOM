
local addonName, ATOM = ...
local Module = ATOM:NewModule('Fonts')

local Media = LibStub('LibSharedMedia-3.0')

local ReplaceGameFonts, SetFont


function Module:OnInitialize()
	Media:Register(Media.MediaType.FONT, 'Lato',      'Interface\\AddOns\\Atom\\Fonts\\Lato\\Lato-Regular.ttf')
	Media:Register(Media.MediaType.FONT, 'Lato Bold', 'Interface\\AddOns\\Atom\\Fonts\\Lato\\Lato-Bold.ttf')
	ReplaceGameFonts()
end


function SetFont(fontPath, fontFamily, fontHeight, fontFlags)
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


function ReplaceGameFonts()
	local NORMAL = Media:Fetch(Media.MediaType.FONT, 'Lato')
	local STRONG = Media:Fetch(Media.MediaType.FONT, 'Lato Bold')

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

	-- Additional changes
	SetFont(NORMAL, ChatFontNormal, 13)
	SetFont(STRONG, FocusFontSmall, 12)
	SetFont(STRONG, TextStatusBarTextLarge, 12)
end
