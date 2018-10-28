local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_TerranDominion,
		"TerranDominion",
		StringFormat("%sEntities/TerranDominion.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","TerranDominion",
		"entity_name","TerranDominion",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Terran Dominion]],
		decal_entity = "TerranDominion",
		entity_name = "TerranDominion",
		id = "ChoGGi.Logos.TerranDominion",
		image = StringFormat("%sUI/TerranDominion.png",CurrentModPath),
	})
end
