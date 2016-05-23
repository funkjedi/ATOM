
local addonName, ATOM = ...
local Module = ATOM:NewModule('AutoTurnIn')

local activeInteraction
local QuestFrame_OnShow


function Module:OnEnable()
	self:RegisterEvent('GOSSIP_CLOSED',  'CharacterInteraction')
	self:RegisterEvent('GOSSIP_SHOW',    'CharacterInteraction')
	self:RegisterEvent('QUEST_ACCEPTED', 'CharacterInteraction')
	self:RegisterEvent('QUEST_COMPLETE', 'CharacterInteraction')
	self:RegisterEvent('QUEST_DETAIL',   'CharacterInteraction')
	self:RegisterEvent('QUEST_FINISHED', 'CharacterInteraction')
	self:RegisterEvent('QUEST_GREETING', 'CharacterInteraction')
	self:RegisterEvent('QUEST_PROGRESS', 'CharacterInteraction')
	QuestFrame:HookScript('OnShow', QuestFrame_OnShow)
end

function Module:OnDisable()
	self:UnregisterEvent('GOSSIP_CLOSED',  'CharacterInteraction')
	self:UnregisterEvent('GOSSIP_SHOW',    'CharacterInteraction')
	self:UnregisterEvent('QUEST_ACCEPTED', 'CharacterInteraction')
	self:UnregisterEvent('QUEST_COMPLETE', 'CharacterInteraction')
	self:UnregisterEvent('QUEST_DETAIL',   'CharacterInteraction')
	self:UnregisterEvent('QUEST_FINISHED', 'CharacterInteraction')
	self:UnregisterEvent('QUEST_GREETING', 'CharacterInteraction')
	self:UnregisterEvent('QUEST_PROGRESS', 'CharacterInteraction')
end


function QuestFrame_OnShow()
	-- Some quest givers don't fire GOSSIP_SHOW, QUEST_GREETING and QUEST_DETAIL
	-- and immediately display the quest with accept and decline buttons
	if not activeInteraction and QuestFrameAcceptButton:IsVisible() then
		if IsControlKeyDown() then
			activeInteraction = true
			Module:QUEST_DETAIL()
		end
	end
end


function Module:CharacterInteraction(event, ...)
	if event == 'QUEST_GREETING' or event == 'GOSSIP_SHOW' then
		if IsControlKeyDown() then
			activeInteraction = true
			self:QUEST_GREETING()
		end
		return
	end
	if event == 'QUEST_FINISHED' or event == 'GOSSIP_CLOSED' then
		self:QUEST_FINISHED()
		return
	end
	if activeInteraction then
		self[event](self, ...)
	end
end


function Module:QUEST_GREETING()
	if GetNumGossipOptions() > 0 then
		--return
	end
	for i=1, GetNumGossipAvailableQuests() do
		SelectGossipAvailableQuest(i)
	end
	for i=1, GetNumGossipActiveQuests() do
		SelectGossipActiveQuest(i)
	end
	for i=1, GetNumAvailableQuests() do
		SelectAvailableQuest(i)
	end
	for i=1, GetNumActiveQuests() do
		SelectActiveQuest(i)
	end
end


function Module:QUEST_DETAIL()
	if not QuestGetAutoAccept() then
		AcceptQuest()
	end
end


function Module:QUEST_ACCEPTED(questLogID)
	if GetNumPartyMembers() > 0 then
		SelectQuestLogEntry(questLogID)
		if GetQuestLogPushable() then
			QuestLogPushQuest()
		end
	end
end


function Module:QUEST_PROGRESS()
	if IsQuestCompletable() then
		CompleteQuest()
	end
end


function Module:QUEST_COMPLETE()
	if GetNumQuestChoices() == 0 then
		GetQuestReward(nil)
	end
end


function Module:QUEST_FINISHED()
	activeInteraction = nil
end
