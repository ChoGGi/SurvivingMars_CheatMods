local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_StarshipTroopers,
		"StarshipTroopers",
		StringFormat("%sEntities/StarshipTroopers.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","StarshipTroopers",
		"entity_name","StarshipTroopers",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Starship Troopers' Federation]],
		decal_entity = "StarshipTroopers",
		entity_name = "StarshipTroopers",
		id = "ChoGGi.Logos.StarshipTroopers",
		image = StringFormat("%sUI/StarshipTroopers.png",CurrentModPath),
	})
end
