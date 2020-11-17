
local addonName, ATOM = ...
local Module = ATOM:NewModule('Merchant')

local RepairItems, SellGreyItems


function Module:OnEnable()
	self:RegisterEvent('MERCHANT_SHOW')
end

function Module:OnDisable()
	self:UnregisterEvent('MERCHANT_SHOW')
end

function Module:MERCHANT_SHOW()
	RepairItems()
	if not _G['ZygorGuidesViewer'] --[[ and not select(4, GetAddOnInfo('TradeSkillMaster_Vendoring')) ]] then
		SellGreyItems()
	end
end


function RepairItems()
	if CanMerchantRepair() then
		local repairAllCost, canRepair = GetRepairAllCost()
		if canRepair and repairAllCost <= GetMoney() then
			RepairAllItems()
			ATOM:Print('|cff80ff80REPAIRS COMPLETED FOR |cffffff80%s|r', GetMoneyString(repairAllCost))
		end
	end
end


function SellGreyItems()
	local bag, slot
	local totalprofit = 0
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local _, count, _, quality, _, _, link = GetContainerItemInfo(bag, slot)
			if link and quality == 0 then
				local vendorPrice = select(11, GetItemInfo(link))
				if vendorPrice > 0 then
					totalprofit = totalprofit + vendorPrice*count
					UseContainerItem(bag, slot)
				end
			end
		end
	end
	if totalprofit > 0 then
		ATOM:Print('|cff80ff80TOTAL PROFIT OF |cffffff80%s|cff80ff80 ON SOLD GREYS|r', GetMoneyString(totalprofit))
	end
end


--[[
	Buy a stack of items from a vendor. This will by pass the
	purchase confirmation given by some merchants.
--]]
function ATOM:BuyItem(name, quantity)
	local slot
	for slot = 1, GetMerchantNumItems() do
		if name == GetMerchantItemInfo(slot) then
			BuyMerchantItem(slot, quantity or 1)
			break
		end
	end
end
