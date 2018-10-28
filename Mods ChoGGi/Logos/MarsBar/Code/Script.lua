local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_MarsBar,
		"MarsBar",
		StringFormat("%sEntities/MarsBar.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","MarsBar",
		"entity_name","MarsBar",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Mars Bar]],
		decal_entity = "MarsBar",
		entity_name = "MarsBar",
		id = "ChoGGi.Logos.MarsBar",
		image = StringFormat("%sUI/MarsBar.png",CurrentModPath),
	})
end
