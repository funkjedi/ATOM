
local addonName, ATOM = ...

ATOM = LibStub('AceAddon-3.0'):NewAddon(ATOM, addonName, 'AceEvent-3.0', 'AceConsole-3.0', 'AceTimer-3.0')

ATOM:SetDefaultModuleLibraries('AceEvent-3.0', 'AceConsole-3.0', 'AceTimer-3.0')

_G['ATOM'] = ATOM;


function ATOM:OnEnable()
	--LibStub('AceEvent-3.0').frame:HookScript('OnEvent', function(f,e) print(e) end)
	self:RegisterEvent('CHAT_MSG_PET_BATTLE_COMBAT_LOG')
	self:RegisterChatCommand('atom', 'SlashCommand')
end

function ATOM:CHAT_MSG_PET_BATTLE_COMBAT_LOG(event, msg)
	if msg and msg:match('^Round') then
		ATOM:Print(msg)
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

function ATOM:Clear()
	ChatFrame1:Clear()
end

function ATOM:Wait(delay, func)
	ATOM:ScheduleTimer(func or delay, func and delay or 0.5)
end

function ATOM:SlashCommand(msg)
	local cmd, offset = self:GetArgs(msg)
	local args = msg:sub(offset)
	if cmd == 'move' then
		SetCVar('autoInteract', GetCVar('autoInteract') ~= '1' and '1' or '0')
	elseif cmd == 'quest' then
		self:GetModule('Quest'):QuestCompleted(args)
	elseif cmd == 'scoreboard' then
		WorldStateScoreFrame:Show()
	elseif cmd == 'vol' then
		self:SetVolume(args ~= '' and tonumber(args) or false)
	elseif cmd == 'wago' then
		self:GetModule('Wago'):ShowWindow()
	elseif cmd == 'way' then
		self:SetUserWaypoint(args)
	end
end


function ATOM:DestroyItems(useGameTooltip)
	local items = {
		'Blue Qiraji Resonating Crystal',
		'Book of the Ages',
		'Charred Recipe',
		'Dew of Eternal Morning',
		'Green Qiraji Resonating Crystal',
		'Idol',
		'Jewel of Maddening Whispers',
		'Red Qiraji Resonating Crystal',
		'Scarab',
		'Singing Crystal',
		'Thorny Loop',
		'Warped Warning Sign',
		'Yellow Qiraji Resonating Crystal',
		"Qiraji Lord's Insignia",
	}
	if useGameTooltip then
		items = {
			select(1, GameTooltip:GetItem())
		}
	end
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


function ATOM:MarkTarget(index)
	if not GetRaidTargetIndex('target') then
		SetRaidTarget('target', index or 8)
		PlaySoundFile(567458)
	end
end


function ATOM:SetUserWaypoint(cmd)
	local x, y = self:GetArgs(cmd, 2)

	x = tonumber(x) * 100 / 10000
	y = tonumber(y) * 100 / 10000

	local currentMapAreaID = C_Map.GetBestMapForUnit('player')
	C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(currentMapAreaID, x, y))
	C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end


function ATOM:ShortenNameplateUnitName(unitId, unitFrame, envTable)
	local function abbriviateName(fullName, maxLength)
		local nameParts = { strsplit(' ', fullName) }
		for i = #nameParts, 1, -1 do
			-- dont abbreviate last names or words less than 5 characters
			if not (i == #nameParts or nameParts[i]:len() < 5) then
				nameParts[i] = nameParts[i]:sub(1, 1) .. '.'
			end
			-- stop abbriviating if the parts fit within the length of the
			-- original truncated unitName that was set for the nameplate
			if table.concat(nameParts, ' '):len() < maxLength then
				break
			end
		end
		return table.concat(nameParts, ' ')
	end

	local unitName = unitFrame.healthBar.unitName:GetText() or ''
	local maxLength = unitName:len()
	local plateFrame = C_NamePlate.GetNamePlateForUnit(unitId)
	local fullName = plateFrame and plateFrame.namePlateUnitName or unitName

	if fullName ~= unitName then
		-- ignore everything after the first comma
		fullName = select(1, strsplit(',', fullName))
		unitFrame.healthBar.unitName:SetText(abbriviateName(fullName, maxLength))
	end
end

--[[
function (self, unitId, unitFrame, envTable)
    local unitName = unitFrame.healthBar.unitName:GetText()
    local plateFrame = C_NamePlate.GetNamePlateForUnit(unitId)

    if plateFrame and plateFrame.namePlateUnitName ~= unitName then
        unitName = plateFrame.namePlateUnitName:gsub('(%S+) ', function (t) return t:sub(1, 1) .. '. ' end)
        unitFrame.healthBar.unitName:SetText(unitName)
    end
end
]]
