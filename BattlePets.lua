local addonName, ATOM = ...
local Module = ATOM:NewModule('BattlePets')

local petBattleRoundTitle, petBattleRoundsCompleted

function Module:OnEnable()
    petBattleRoundTitle = PetBattleFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
    petBattleRoundTitle:SetPoint('BOTTOM', PetBattleFrame.TopVersusText, 'TOP', 1, 2)
    petBattleRoundTitle:SetText('Round')
    petBattleRoundTitle:Hide()

    self:RegisterEvent('PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE')
    self:RegisterEvent('PET_BATTLE_CLOSE')
end

function Module:PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE(event, round)
    petBattleRoundsCompleted = tonumber(round) and round + 1 or '?'

    PetBattleFrame.TopVersusText:SetPoint('TOP', PetBattleFrame, 'TOP', -1, -17)
    PetBattleFrame.TopVersusText:SetFontObject('Game24Font')
    PetBattleFrame.TopVersusText:SetText(petBattleRoundsCompleted)
    petBattleRoundTitle:Show()
end

function Module:PET_BATTLE_CLOSE()
    PetBattleFrame.TopVersusText:SetPoint('TOP', PetBattleFrame, 'TOP', 0, -6)
    PetBattleFrame.TopVersusText:SetFontObject('GameFont_Gigantic')
    PetBattleFrame.TopVersusText:SetText(PET_BATTLE_UI_VS)
    petBattleRoundTitle:Hide()

    if petBattleRoundsCompleted then
        ATOM:Print(('Pet Battle finished after |cff00ff00%s|r rounds.'):format(petBattleRoundsCompleted - 1))
        petBattleRoundsCompleted = nil
    end
end

function Module:GetActivePowerlevelingBattlePetTrainer()
    local worldQuests = {
        [41935] = 'Beasts of Burden',
        [41990] = 'Chopped',
        [41860] = 'Dealing with Satyrs',
        [42442] = 'Fight Night: Amalia',
        [40299] = 'Fight Night: Bodhi Sunwayver',
        [40298] = 'Fight Night: Sir Galveston',
        [40277] = 'Fight Night: Tiffany Nelson',
        [41944] = 'Jarrun\'s Ladder',
        [40278] = 'My Beast\'s Bidding',
        [41687] = 'Snail Fight!',
        [41895] = 'The Master of Pets',
        [40282] = 'Tiny Poacher, Tiny Animals',
        [40280] = 'Training with Bredda',
        [40279] = 'Training with Durian',
        [42159] = 'Training with the Nightwatchers',
    }

    local powerlevelingBattlePetWorldQuest

    for questID, questTitle in pairs(worldQuests) do
        local timeRemaining = C_TaskQuest.GetQuestTimeLeftMinutes(questID)

        if timeRemaining and timeRemaining > 5 then
            powerlevelingBattlePetWorldQuest = questID
        end
    end

    if powerlevelingBattlePetWorldQuest then
        local questTitle = C_TaskQuest.GetQuestInfoByQuestID(powerlevelingBattlePetWorldQuest)
        local questMapInfo = C_Map.GetMapInfo(C_TaskQuest.GetQuestZoneID(powerlevelingBattlePetWorldQuest))

        ATOM:Print('The powerleveling Battle Pet World Quest: |c00b4ff00%s|r in |c00b4ff00%s|r', questTitle, questMapInfo.name)
    else
        ATOM:Print('There are currently no powerleveling Battle Pet trainers up.')
    end
end
