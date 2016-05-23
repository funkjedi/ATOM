
local addonName, ATOM = ...

ATOM = LibStub('AceAddon-3.0'):NewAddon(ATOM, addonName, 'AceEvent-3.0', 'AceTimer-3.0')

ATOM:SetDefaultModuleLibraries('AceEvent-3.0', 'AceTimer-3.0')

_G['ATOM'] = ATOM;



function ATOM:OnEnable()
	ATOM:RegisterEvent('ADDON_LOADED')
end

function ATOM:ADDON_LOADED(event, addonName)
	if addonName == 'Dominos_Config' then
		ATOM:DominosIncreaseMaximumScale()
	end
end



function ATOM:Print(...)
	ChatFrame1:AddMessage('ATOM: '..string.format(...))
end

function ATOM:Dump(...)
	UIParentLoadAddOn('Blizzard_DebugTools')
	if _G['DevTools_Dump'] then
		_G['DevTools_Dump'](...)
	else
		print(...)
	end
end

function ATOM:Wait(delay, func)
	ATOM:ScheduleTimer(func or delay, func and delay or 0.5)
end


--[[
	Show the scoreboard when in Battleground.
--]]
function ATOM:ShowScore()
	WorldStateScoreFrame:Show()
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
