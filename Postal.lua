
local addonName, ATOM = ...
local Module = ATOM:NewModule('Postal')

local CollectableItem, CheckMailbox


function Module:OnEnable()
	self:RegisterEvent('MAIL_SHOW')
end

function Module:OnDisable()
	self:UnregisterEvent('MAIL_SHOW')
end

function Module:MAIL_SHOW()
	if not _G['ZygorGuidesViewer'] then
		ATOM:Wait(function() CheckMailbox(GetInboxNumItems()) end)
	end
end


function CollectableItem(index)
	local _, _, _, _, money, CODAmount, _, itemCount = GetInboxHeaderInfo(index)
	if money > 0 or (itemCount and itemCount > 0) and CODAmount <= 0 then
		return index
	end
end


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
	ATOM:Wait(function() CheckMailbox(CollectableItem(index) or (index - 1)) end)
end
