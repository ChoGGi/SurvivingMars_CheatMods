local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.Something_Oh_So_Unique,
		"Logo",
		StringFormat("%sEntities/Logo.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","Logo",
		"entity_name","Logo",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Logo]],
		decal_entity = "Logo",
		entity_name = "Logo",
		id = "ChoGGi.Logos.Logo",
		image = StringFormat("%sUI/Logo.png",CurrentModPath),
	})
end
