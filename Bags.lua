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
    local quality = select(4, GetContainerItemInfo(self:GetParent():GetID(), self:GetID()))

    if quality and quality > Enum.ItemQuality.Common then
        self.NewItemTexture:SetAtlas(NEW_ITEM_ATLAS_BY_QUALITY[quality])
        self.NewItemTexture:SetAlpha(.8)
        self.NewItemTexture:Show()
    end
end

function updateBagItems(frame)
    local name = frame:GetName()
    local itemButtonName, itemButton
    for i = 1, frame.size, 1 do
        itemButtonName = name .. 'Item' .. i
        itemButton = _G[itemButtonName]
        if not frameHooked[itemButtonName] then
            frameHooked[itemButtonName] = true
            itemButton:HookScript('OnEnter', enableGlow)
            itemButton:HookScript('OnLeave', enableGlow)
        end
        enableGlow(itemButton)
    end
end

function Module:DestroyItems()
    if CursorHasItem() then
        return
    end

    -- LuaFormatter off
    local destroyItems = {
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

    local protectedItems = {
        ['Korthian Armaments'] = true,
    }

    -- LuaFormatter on
    for bagID = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bagID) do
            local itemLink = GetContainerItemLink(bagID, slot) or ''

            local itemName = string.match(itemLink, '|h%[([^%]]+)%]|h')
            local quality = select(4, GetContainerItemInfo(bagID, slot))

            -- check if item is an heirloom
            if quality == 7 and not protectedItems[itemName] then
                PickupContainerItem(bagID, slot)
                DeleteCursorItem()
            end

            -- check if item in on the destroy list
            for _, destroyItemName in ipairs(destroyItems) do
                if itemName == destroyItemName then
                    PickupContainerItem(bagID, slot)
                    DeleteCursorItem()
                end
            end
        end
    end
end
