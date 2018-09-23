local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_Amazon,
		"Amazon",
		StringFormat("%sEntities/Amazon.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","Amazon",
		"entity_name","Amazon",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Amazon]],
		decal_entity = "Amazon",
		entity_name = "Amazon",
		id = "ChoGGi.Logos.Amazon",
		image = StringFormat("%sUI/Amazon.png",CurrentModPath),
	})
end
