
local addonName, ATOM = ...

ATOM = LibStub('AceAddon-3.0'):NewAddon(ATOM, addonName, 'AceEvent-3.0', 'AceTimer-3.0')

ATOM:SetDefaultModuleLibraries('AceEvent-3.0', 'AceTimer-3.0')

_G['ATOM'] = ATOM;


function ATOM:OnEnable()
	--LibStub('AceEvent-3.0').frame:HookScript('OnEvent', function(f,e) print(e) end)
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


function ATOM:DestroyItems()
	local items = {
		'Dew of Eternal Morning',
		'Warped Warning Sign',
		'Book of the Ages',
		'Singing Crystal',
		'Charred Recipe',
		'Idol',
		'Scarab',
	}
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local name = GetContainerItemLink(bag,slot)
			if name then
				for _, item in ipairs(items) do
					if string.find(name,item) then
						PickupContainerItem(bag,slot)
						DeleteCursorItem()
					end
				end
			end
		end
	end
end


--[[
	Mark a target.
--]]
function ATOM:MarkTarget(index)
	if not GetRaidTargetIndex('target') then
		SetRaidTarget('target', index or 8)
		PlaySoundFile('Sound\\interface\\AlarmClockWarning3.ogg')
	end
end
