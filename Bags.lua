
local addonName, ATOM = ...
local Module = ATOM:NewModule('Bags')

local frameHooked = {}
local enableGlow, updateBagItems


function Module:OnInitialize()
    if not _G['Bagnon'] then
        hooksecurefunc('ContainerFrame_Update', updateBagItems)
    end
end


function enableGlow(self)
    local quality = select(4, GetContainerItemInfo( self:GetParent():GetID(), self:GetID() ))
    if quality and quality > LE_ITEM_QUALITY_COMMON then
        self.NewItemTexture:SetAtlas(NEW_ITEM_ATLAS_BY_QUALITY[quality])
        self.NewItemTexture:SetAlpha(.8)
        self.NewItemTexture:Show()
    end
end


function updateBagItems(frame)
    local name = frame:GetName()
    local itemButtonName, itemButton
    for i=1, frame.size, 1 do
        itemButtonName = name..'Item'..i
        itemButton = _G[itemButtonName]
        if not frameHooked[itemButtonName] then
            frameHooked[itemButtonName] = true
            itemButton:HookScript('OnEnter', enableGlow)
            itemButton:HookScript('OnLeave', enableGlow)
        end
        enableGlow(itemButton)
    end
end


function ATOM:DestroyHeirlooms()
    local bag, slot
    for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            local name = GetContainerItemLink(bag, slot)
            if name and string.find(name, 'ffe6cc80') then
                ATOM:Print(name..' destroyed.')
                PickupContainerItem(bag, slot)
                DeleteCursorItem()
            end
        end
    end
end
