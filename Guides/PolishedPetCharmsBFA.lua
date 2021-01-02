
--[[

GUIDE SYNTAX:

|noway             no waypoint even if there's coords
|c                 force complete
|n                 force no complete
|future            if quest-related, then don't worry if the quest isn't in the log


ZGV.Sync.SharedGuide = ZGV.GuideProto:New("SHARED\\Select a guide","step\nSelect an guide to continue")
ZGV:SetGuide(ZGV.Sync.SharedGuide)

--]]


local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end

ZygorGuidesViewer.GuideMenuTier = "BFA"


-- https://www.wowhead.com/item=163036/polished-pet-charm#comments
ZygorGuidesViewer:RegisterGuide("Pets & Mounts Guide\\Farming Guides\\Battle for Azeroth\\Polished Pet Charms",{
	author="support@zygorguides.com",
	description="\nPolished Pet Charms can be gathered from BFA zones.",
	},[[
	step
		map Drustvar/0 24.27,48.32
		Enter the cave |goto Drustvar/0 24.69,48.94 < 5 |walk
		click Stolen Thornspeaker Cache##298920
		|tip Inside the cave.
	step
		map Drustvar/0 25.75,19.94
		kill Gorging Raven##137468
		|tip They fly around the chest and one of them has the Merchant's Key in its claws.
		collect Merchant's Key##163710 |only if not completedq(53357)
		click Merchant's Chest##2
	step
		map Stormsong Valley/0 67.22,43.21
		click Sunken Strongbox##282153
		|tip Underwater.
	step
		map Stormsong Valley/0 34.65,67.98
		kill Poacher Zane##141286
	step
		map Tiragarde Sound/0 56.03,33.19
		Follow the path |goto Tiragarde Sound/0 54.32,30.45 < 10 |only if walking
		Jump across the rocks |goto 55.30,31.26 < 10 |only if walking
		Continue across the rocks |goto 55.54,31.71 < 5 |only if walking
		|tip Running through this area may flag you for PvP.
		click Precarious Noble Cache
	step
		map Vol'dun/0 26.48,45.35
		click Abandoned Bobber##294318
		click Sandsunken Treasure##294319
	step
		map Vol'dun/0 40.57,85.74
		Follow the path |goto Vol'dun/0 38.68,82.62 < 10 |only if walking
		Follow the path up |goto 39.15,83.17 < 5 |only if walking
		Continue following the path |goto 40.52,84.04 < 10 |only if walking
		Cross the bridge |goto 40.60,84.88 < 10 |only if walking
		click Deadwood Chest##294317
	step
		map Zuldazar/0 71.83,16.78
		Enter the cave |goto Zuldazar/0 71.25,17.52 < 5 |walk
		click The Exile's Lament##284455
		|tip Inside the cave.
	step
		Congratulations, you have gathered your Polished Pet Charms for the day!
]])
