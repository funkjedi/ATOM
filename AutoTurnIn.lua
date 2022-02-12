local addonName, ATOM = ...
local Module = ATOM:NewModule('AutoTurnIn')

local activeInteraction
local QuestFrame_OnShow

function Module:OnEnable()
    self:RegisterEvent('GOSSIP_CLOSED', 'CharacterInteraction')
    self:RegisterEvent('GOSSIP_SHOW', 'CharacterInteraction')
    self:RegisterEvent('QUEST_COMPLETE', 'CharacterInteraction')
    self:RegisterEvent('QUEST_DETAIL', 'CharacterInteraction')
    self:RegisterEvent('QUEST_FINISHED', 'CharacterInteraction')
    self:RegisterEvent('QUEST_GREETING', 'CharacterInteraction')
    self:RegisterEvent('QUEST_PROGRESS', 'CharacterInteraction')
    QuestFrame:HookScript('OnShow', QuestFrame_OnShow)
end

function Module:OnDisable()
    self:UnregisterEvent('GOSSIP_CLOSED', 'CharacterInteraction')
    self:UnregisterEvent('GOSSIP_SHOW', 'CharacterInteraction')
    self:UnregisterEvent('QUEST_COMPLETE', 'CharacterInteraction')
    self:UnregisterEvent('QUEST_DETAIL', 'CharacterInteraction')
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
    if IsControlKeyDown() then
        activeInteraction = true
    end

    if event == 'QUEST_FINISHED' or event == 'GOSSIP_CLOSED' then
        ATOM:Wait(function()
            activeInteraction = nil
        end)
        return
    end

    if activeInteraction then
        self[event](self, ...)
    end
end

function Module:QUEST_GREETING()
    for i = 1, GetNumAvailableQuests() do
        SelectAvailableQuest(i)
    end

    for i = 1, GetNumActiveQuests() do
        local title, isComplete = GetActiveTitle(i)

        if isComplete then
            SelectActiveQuest(i)
        end
    end
end

function Module:GOSSIP_SHOW()
    for i = 1, C_GossipInfo.GetNumAvailableQuests() do
        C_GossipInfo.SelectAvailableQuest(i)
    end

    local quests = C_GossipInfo.GetActiveQuests()

    for i, quest in ipairs(quests) do
        if quest.isComplete then
            C_GossipInfo.SelectActiveQuest(i)
        end
    end
end

function Module:QUEST_DETAIL()
    if not QuestGetAutoAccept() then
        AcceptQuest()
    end
end

function Module:QUEST_PROGRESS()
    if IsQuestCompletable() then
        CompleteQuest()
    end
end

function Module:QUEST_COMPLETE()
    if not GetQuestID() or GetNumQuestChoices() > 1 then
        return
    end

    QuestDetailAcceptButton_OnClick()
    GetQuestReward(max(QuestInfoFrame.itemChoice, 1))
end

function Module:QuestCompleted(questID)
    ATOM:Dump(C_QuestLog.IsQuestFlaggedCompleted(questID))
end
