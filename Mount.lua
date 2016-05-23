

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
