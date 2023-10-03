return PlaceObj("ModDef", {
	"title", "Enable Console",
	"id", "ChoGGi_EnableConsole",
	"steam_id", "1747675475",
	"pops_any_uuid", "92acde1d-8642-4ae5-a748-03b9759178ab",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
This will enable the console and the console log text (turn off in mod options).
Press Enter or Tilde to show console.

This is NOT meant to be used with Expanded Cheat Menu, which is what you should be using if you're modding.


Some commands:
-- Add 5 Billion
UIColony.funds:ChangeFunding(5 * 1000000000)
-- Delete selected object (some stuff doesn't have a selection circle)
DoneObject(SelectedObj)
-- Uncover map
CheatMapExplore("deep scanned")
-- Unlock all buildings in build menu
CheatUnlockAllBuildings()
-- Spawn ten random colonists
CheatSpawnNColonists(10)
-- Spawn an asteroid
ReconCenter:CheatTriggerAsteroidUnlocked()
-- Unlock underground
UIColony:UnlockUnderground()
-- Move selected object to mouse cursor
SelectedObj:SetPos(GetCursorWorldPos())
-- Examine selected object (you need my library mod for this cmd)
OpenExamine(SelectedObj)

-- Unlock all tech in research tree
CheatUnlockAllTech()
-- Research all tech
CheatResearchAll()
-- Research current tech
CheatResearchCurrent()
-- Reset research costs (intentional misspelling)
UIColony.tech_status.MartianCopyrithgts.researched = 1
UIColony.tech_status.MartianPatents.researched = 1
-- Scan all breakthroughs on surface map
CheatUnlockBreakthroughs()
-- Unlock all breakthrough techs
CheatUnlockAllBreakthroughs()
]],
})
