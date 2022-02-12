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
        petBattleRoundsCompleted = nil
        ATOM:Print(('Pet Battle finished after |cff00ff00%s|r rounds.'):format(petBattleRoundsCompleted))
    end
end
