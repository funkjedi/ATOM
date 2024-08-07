local addonName, ATOM = ...
local Module = ATOM:NewModule('Fonts')

local Media = LibStub('LibSharedMedia-3.0')

local SetFont, ReplaceGameFonts

local fontFamilies = {
    ['Accidental Presidency'] = [[Interface\AddOns\ATOM\Fonts\Accidental-Presidency.ttf]],
    ['Antarian'] = [[Interface\Addons\ATOM\Fonts\Antarian.ttf]],
    ['Anton'] = [[Interface\Addons\ATOM\Fonts\Anton-Regular.ttf]],
    ['Audiowide'] = [[Interface\Addons\ATOM\Fonts\Audiowide-Regular.ttf]],
    ['Bowlby One SC'] = [[Interface\AddOns\ATOM\Fonts\BowlbyOneSC-Regular.ttf]],
    ['DoHyeon'] = [[Interface\Addons\ATOM\Fonts\DoHyeon-Regular.ttf]],
    ['Droid Sans'] = [[Interface\AddOns\ATOM\Fonts\DroidSans.ttf]],
    ['Exo2'] = [[Interface\Addons\ATOM\Fonts\Exo2-Regular.ttf]],
    ['Geo'] = [[Interface\Addons\ATOM\Fonts\Geo-Regular.ttf]],
    ['Good Brush'] = [[Interface\Addons\ATOM\Fonts\GoodBrush.otf]],
    ['Lato'] = [[Interface\Addons\ATOM\Fonts\Lato-Regular.ttf]],
    ['Lato Bold'] = [[Interface\Addons\ATOM\Fonts\Lato-Bold.ttf]],
    ['Monda'] = [[Interface\Addons\ATOM\Fonts\Monda-Regular.ttf]],
    ['Myriad Pro'] = [[Interface\AddOns\ATOM\Fonts\MyriadPro-Regular.ttf]],
    ['Myriad Pro Bold'] = [[Interface\AddOns\ATOM\Fonts\MyriadPro-Bold.ttf]],
    ['NewsCycle'] = [[Interface\Addons\ATOM\Fonts\NewsCycle-Regular.ttf]],
    ['NewsCycle Bold'] = [[Interface\Addons\ATOM\Fonts\NewsCycle-Bold.ttf]],
    ['Nova Square'] = [[Interface\Addons\ATOM\Fonts\NovaSquare.ttf]],
    ['Nunito'] = [[Interface\Addons\ATOM\Fonts\Nunito-Regular.ttf]],
    ['Nunito Bold'] = [[Interface\Addons\ATOM\Fonts\Nunito-Bold.ttf]],
    ['Nunito Extra Bold'] = [[Interface\Addons\ATOM\Fonts\Nunito-ExtraBold.ttf]],
    ['Open Sans Condensed Bold'] = [[Interface\Addons\ATOM\Fonts\OpenSansCondensed-Bold.ttf]],
    ['Orbitron'] = [[Interface\Addons\ATOM\Fonts\Orbitron-Regular.ttf]],
    ['Proxima Nova Condensed'] = [[Interface\Addons\ATOM\Fonts\ProximaNovaCondensed-Regular.otf]],
    ['Proxima Nova Condensed Bold'] = [[Interface\Addons\ATOM\Fonts\ProximaNovaCondensed-Bold.otf]],
    ['Quantico'] = [[Interface\Addons\ATOM\Fonts\Quantico-Regular.ttf]],
    ['Roboto'] = [[Interface\Addons\ATOM\Fonts\Roboto-Regular.ttf]],
    ['Teko'] = [[Interface\Addons\ATOM\Fonts\Teko-Regular.ttf]],
    ['Titillium Web'] = [[Interface\Addons\ATOM\Fonts\TitilliumWeb-Regular.ttf]],
    ['Ubuntu'] = [[Interface\Addons\ATOM\Fonts\Ubuntu-Regular.ttf]],
    ['VT323'] = [[Interface\Addons\ATOM\Fonts\VT323-Regular.ttf]],
}

local NORMAL = fontFamilies['Lato']
local STRONG = fontFamilies['Lato Bold']

local SCALE_FOR_FONTS = 1

-- this must be done this way because TSM removes itself
-- from the AceAddon.addons table OnInitialize
local AceAddon = LibStub('AceAddon-3.0')
local AceAddon_NewAddon = AceAddon.NewAddon
local TSM

function AceAddon:NewAddon(...)
    local addon = AceAddon_NewAddon(self, ...)
    if addon.name == 'TradeSkillMaster' then
        TSM = addon
    end
    return addon
end

hooksecurefunc('CreateFrame', function(frameType, name)
    if not name then
        return
    end

    if frameType == 'Button' and string.match(name, '^TSMTabGroup') then
        hooksecurefunc(_G[name], 'SetFontString', function(self, fontString)
            fontString:SetFont(TSMAPI.Design:GetContentFont(), 15)
        end)
    end
end)

function Module:OnInitialize()
    for fontName, fontFile in pairs(fontFamilies) do
        Media:Register(Media.MediaType.FONT, fontName, fontFile)
    end

    ReplaceGameFonts()
end

function Module:OnEnable()
    if TSM then
        TSM.db.profile.design.fonts = { content = NORMAL, bold = STRONG }
    end
end

function SetFont(fontPath, fontFamily, fontHeight, fontFlags)
    if fontFamily then
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

            -- if fontHeight < 16 then
            --    fontHeight = fontHeight * 1.1
            -- end
        end

        fontFamily:SetFont(fontPath, fontHeight * SCALE_FOR_FONTS, fontFlags or flags)
    end
end

function ReplaceGameFonts()
    -- See: https://github.com/Gethe/wow-ui-source/blob/live
    -- See: https://www.freeformatter.com/xpath-tester.html

    -- Extracted from AddOns/Blizzard_Fonts_Frame/Mainline/Fonts.xml
    UNIT_NAME_FONT = NORMAL
    STANDARD_TEXT_FONT = NORMAL
    DAMAGE_TEXT_FONT = STRONG

    -- Extracted from AddOns/Blizzard_FontStyles_Frame/Mainline/FontStyles.xml
    UNIT_NAME_FONT_ROMAN = NORMAL

    -- Extracted from AddOns/Blizzard_Fonts_Frame/Mainline/Fonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\FRIZQT__.TTF']]/@name
    SetFont(STRONG, SystemFont_Outline_Small)
    SetFont(NORMAL, SystemFont_Outline)
    SetFont(STRONG, SystemFont_InverseShadow_Small)
    SetFont(NORMAL, SystemFont_Huge1)
    SetFont(NORMAL, SystemFont_Huge1_Outline)
    SetFont(NORMAL, SystemFont_OutlineThick_Huge2)
    SetFont(STRONG, SystemFont_OutlineThick_Huge4)
    SetFont(STRONG, SystemFont_OutlineThick_WTF)
    SetFont(NORMAL, NumberFont_GameNormal)
    SetFont(NORMAL, NumberFont_OutlineThick_Mono_Small, 'OUTLINE')
    SetFont(STRONG, Number12Font_o1)
    SetFont(NORMAL, NumberFont_Small)
    SetFont(STRONG, Game15Font_o1)
    SetFont(NORMAL, MailFont_Large, 15)
    SetFont(STRONG, SpellFont_Small)
    SetFont(NORMAL, InvoiceFont_Med)
    SetFont(NORMAL, InvoiceFont_Small)
    SetFont(STRONG, AchievementFont_Small)
    SetFont(NORMAL, ReputationDetailFont)
    SetFont(STRONG, GameFont_Gigantic)
    SetFont(NORMAL, ChatBubbleFont)
    SetFont(NORMAL, SystemFont_NamePlateFixed, 10)
    SetFont(NORMAL, SystemFont_LargeNamePlateFixed, 10)
    SetFont(NORMAL, SystemFont_NamePlate, 10)
    SetFont(NORMAL, SystemFont_LargeNamePlate, 10)
    SetFont(NORMAL, SystemFont_NamePlateCastBar, 10)
    SetFont(NORMAL, Game19Font)
    SetFont(NORMAL, Game21Font)
    SetFont(NORMAL, Game22Font)

    -- changing font height does nothing when instead using a font
    -- that is naturally smaller than default STRONG fonr
    SetFont(fontFamilies['Myriad Pro Bold'], SystemFont_NamePlateCastBar)

    -- Extracted from AddOns/Blizzard_Fonts_Frame/Mainline/Fonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\FRIZQT__.ttf']]/@name
    SetFont(NORMAL, Game11Font_Shadow)
    SetFont(NORMAL, Game11Font)
    SetFont(NORMAL, Game12Font)
    SetFont(NORMAL, Game13Font)
    SetFont(NORMAL, Game13FontShadow)
    SetFont(NORMAL, Game15Font)
    SetFont(NORMAL, Game15Font_Shadow)
    SetFont(NORMAL, Game18Font)
    SetFont(NORMAL, Game20Font)
    SetFont(NORMAL, Game24Font)
    SetFont(NORMAL, Game27Font)
    SetFont(NORMAL, Game32Font)
    SetFont(NORMAL, Game36Font)
    SetFont(NORMAL, Game40Font)
    SetFont(NORMAL, Game42Font)
    SetFont(NORMAL, Game46Font)
    SetFont(NORMAL, Game48Font)
    SetFont(NORMAL, Game48FontShadow)
    SetFont(NORMAL, Game60Font)
    SetFont(NORMAL, Game120Font)
    SetFont(STRONG, Game11Font_o1)
    SetFont(STRONG, Game12Font_o1)
    SetFont(STRONG, Game13Font_o1)

    -- Extracted from AddOns/Blizzard_Fonts_Frame/Mainline/Fonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\ARIALN.TTF']]/@name
    SetFont(STRONG, NumberFont_OutlineThick_Mono_Small)
    SetFont(STRONG, Number12Font_o1)
    SetFont(NORMAL, NumberFont_Small)
    SetFont(NORMAL, Number11Font)
    SetFont(NORMAL, Number12Font)
    SetFont(NORMAL, Number12FontOutline)
    SetFont(NORMAL, Number13Font, 12)
    SetFont(NORMAL, PriceFont, 12)
    SetFont(NORMAL, Number15Font)
    SetFont(NORMAL, Number16Font)
    SetFont(NORMAL, Number18Font)
    SetFont(NORMAL, NumberFont_Normal_Med, 13)

    -- Extracted from AddOns/Blizzard_Fonts_Frame/Mainline/Fonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\MORPHEUS.TTF']]/@name
    SetFont(NORMAL, Fancy12Font)
    SetFont(NORMAL, Fancy14Font)
    SetFont(NORMAL, Fancy16Font)
    SetFont(NORMAL, Fancy18Font)
    SetFont(NORMAL, Fancy20Font)
    SetFont(NORMAL, Fancy24Font)
    SetFont(NORMAL, Fancy27Font)
    SetFont(NORMAL, Fancy30Font)
    SetFont(NORMAL, Fancy32Font)
    SetFont(NORMAL, Fancy36Font)
    SetFont(NORMAL, Fancy40Font)
    SetFont(NORMAL, Fancy48Font)

    -- Extracted from AddOns/Blizzard_Fonts_Frame/Mainline/Fonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\MORPHEUS.ttf']]/@name
    SetFont(NORMAL, Fancy22Font)
    SetFont(NORMAL, QuestFont_Outline_Huge)
    SetFont(STRONG, QuestFont_Super_Huge)
    SetFont(NORMAL, QuestFont_Super_Huge_Outline)
    SetFont(NORMAL, SplashHeaderFont)
    SetFont(NORMAL, QuestFont_Enormous)
    SetFont(NORMAL, DestinyFontMed)
    SetFont(NORMAL, DestinyFontLarge)
    SetFont(NORMAL, CoreAbilityFont)
    SetFont(NORMAL, OrderHallTalentRowFont)
    SetFont(NORMAL, DestinyFontHuge)
    SetFont(NORMAL, QuestFont_Shadow_Small)

    -- Extracted from AddOns/Blizzard_Fonts_Frame/Mainline/Fonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\skurri.ttf']]/@name
    SetFont(STRONG, NumberFont_Outline_Huge)

    -- Extracted from AddOns/Blizzard_Fonts_Glue/GlueFonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\ARIALN.TTF']]/@name
    SetFont(NORMAL, EditBoxFont_Large)
    SetFont(NORMAL, NumberFont_OutlineThick_Med1)
    SetFont(NORMAL, NumberFont_OutlineThick_Med2)

    -- Extracted from AddOns/Blizzard_Fonts_Glue/GlueFonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\MORPHEUS.ttf']]/@name
    SetFont(NORMAL, FactionName_Shadow_Medium)
    SetFont(NORMAL, FactionName_Shadow_Large)
    SetFont(NORMAL, FactionName_Shadow_Huge)

    -- Extracted from AddOns/Blizzard_Fonts_Shared/SharedFonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\FRIZQT__.TTF']]/@name
    SetFont(NORMAL, SystemFont_Tiny2)
    SetFont(NORMAL, SystemFont_Tiny)
    SetFont(STRONG, SystemFont_Shadow_Small)
    SetFont(STRONG, Game10Font_o1)
    SetFont(NORMAL, SystemFont_Small)
    SetFont(NORMAL, SystemFont_Small2)
    SetFont(NORMAL, SystemFont_Shadow_Small2)
    SetFont(NORMAL, SystemFont_Shadow_Small_Outline)
    SetFont(NORMAL, SystemFont_Shadow_Small2_Outline)
    SetFont(STRONG, SystemFont_Shadow_Med1_Outline)
    SetFont(NORMAL, SystemFont_Shadow_Med1, true)
    SetFont(NORMAL, SystemFont_Med2)
    SetFont(NORMAL, SystemFont_Med3)
    SetFont(NORMAL, SystemFont_Shadow_Med3)
    SetFont(STRONG, SystemFont_Shadow_Med3_Outline)
    SetFont(NORMAL, SystemFont_Large)
    SetFont(STRONG, SystemFont_Shadow_Large_Outline)
    SetFont(NORMAL, SystemFont_Shadow_Med2)
    SetFont(STRONG, SystemFont_Shadow_Med2_Outline)
    SetFont(NORMAL, SystemFont_Shadow_Large)
    SetFont(NORMAL, SystemFont_Large2)
    SetFont(NORMAL, SystemFont_Shadow_Large2)
    SetFont(NORMAL, SystemFont_Shadow_Large2_Outline)
    SetFont(NORMAL, SystemFont_Shadow_Huge1)
    SetFont(NORMAL, SystemFont_Shadow_Huge1_Outline)
    SetFont(NORMAL, SystemFont_Huge2)
    SetFont(NORMAL, SystemFont_Shadow_Huge2)
    SetFont(STRONG, SystemFont_Shadow_Huge2_Outline)
    SetFont(NORMAL, SystemFont_Shadow_Huge3)
    SetFont(STRONG, SystemFont_Shadow_Outline_Huge3)
    SetFont(NORMAL, SystemFont_Huge4)
    SetFont(NORMAL, SystemFont_Shadow_Huge4)
    SetFont(STRONG, SystemFont_Shadow_Huge4_Outline)
    SetFont(NORMAL, SystemFont_World)
    SetFont(STRONG, SystemFont_World_ThickOutline)
    SetFont(STRONG, SystemFont22_Outline)
    SetFont(STRONG, SystemFont22_Shadow_Outline)
    SetFont(NORMAL, SystemFont_Med1)
    SetFont(NORMAL, SystemFont_WTF2)
    SetFont(STRONG, SystemFont_Outline_WTF2)
    SetFont(NORMAL, GameTooltipHeader)
    SetFont(NORMAL, System_IME)
    SetFont(NORMAL, Tooltip_Med)
    SetFont(NORMAL, Tooltip_Small)
    SetFont(NORMAL, System15Font)
    SetFont(NORMAL, Game30Font)
    SetFont(NORMAL, FriendsFont_Normal)
    SetFont(NORMAL, FriendsFont_11)
    SetFont(NORMAL, FriendsFont_Small)
    SetFont(NORMAL, FriendsFont_Large)

    -- Extracted from AddOns/Blizzard_Fonts_Shared/SharedFonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\FRIZQT__.ttf']]/@name
    SetFont(NORMAL, Game17Font_Shadow)
    SetFont(NORMAL, Game16Font)
    SetFont(NORMAL, Game32Font_Shadow2)
    SetFont(NORMAL, Game36Font_Shadow2)
    SetFont(NORMAL, Game40Font_Shadow2)
    SetFont(NORMAL, Game46Font_Shadow2)
    SetFont(NORMAL, Game52Font_Shadow2)
    SetFont(NORMAL, Game58Font_Shadow2)
    SetFont(NORMAL, Game69Font_Shadow2)
    SetFont(NORMAL, Game72Font)
    SetFont(NORMAL, Game72Font_Shadow)

    -- Extracted from AddOns/Blizzard_Fonts_Shared/SharedFonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\ARIALN.TTF']]/@name
    SetFont(NORMAL, SystemFont16_Shadow_ThickOutline)
    SetFont(NORMAL, SystemFont18_Shadow_ThickOutline)
    SetFont(NORMAL, SystemFont22_Shadow_ThickOutline)
    SetFont(NORMAL, NumberFont_Shadow_Tiny)
    SetFont(NORMAL, NumberFont_Shadow_Small)
    SetFont(NORMAL, NumberFont_Shadow_Med)
    SetFont(NORMAL, NumberFont_Shadow_Large)
    SetFont(STRONG, FriendsFont_UserText)
    SetFont(STRONG, NumberFont_Outline_Med)
    SetFont(STRONG, NumberFont_Outline_Large)

    -- Extracted from AddOns/Blizzard_Fonts_Shared/SharedFonts.xml
    -- /Ui/FontFamily[Member/Font[@font='Fonts\MORPHEUS.ttf']]/@name
    -- SetFont(NORMAL, QuestFont_Large)
    -- SetFont(NORMAL, QuestFont_Huge)
    SetFont(NORMAL, QuestFont_30)
    SetFont(NORMAL, QuestFont_39)

    -- Additional changes
    SetFont(NORMAL, ChatFontNormal, 13)
    SetFont(STRONG, FocusFontSmall, 12)
    SetFont(STRONG, TextStatusBarTextLarge, 12)

    for i = 1, 10 do
        SetFont(NORMAL, _G['ChatFrame' .. i], 13)
    end

    SetFont(NORMAL, CommunitiesFrame.Chat.MessageFrame, 13)

    -- for _, button in pairs(PaperDollTitlesPane.buttons) do
    --     button.text:SetFontObject(GameFontHighlightSmallLeft)
    -- end
end
