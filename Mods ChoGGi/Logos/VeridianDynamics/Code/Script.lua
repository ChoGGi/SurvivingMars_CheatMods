local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_VeridianDynamics,
		"VeridianDynamics",
		StringFormat("%sEntities/VeridianDynamics.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","VeridianDynamics",
		"entity_name","VeridianDynamics",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Veridian Dynamics]],
		decal_entity = "VeridianDynamics",
		entity_name = "VeridianDynamics",
		id = "ChoGGi.Logos.VeridianDynamics",
		image = StringFormat("%sUI/VeridianDynamics.png",CurrentModPath),
	})
end
