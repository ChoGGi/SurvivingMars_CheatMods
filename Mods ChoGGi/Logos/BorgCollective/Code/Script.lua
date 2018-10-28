local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_BorgCollective,
		"BorgCollective",
		StringFormat("%sEntities/BorgCollective.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","BorgCollective",
		"entity_name","BorgCollective",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Borg Collective]],
		decal_entity = "BorgCollective",
		entity_name = "BorgCollective",
		id = "ChoGGi.Logos.BorgCollective",
		image = StringFormat("%sUI/BorgCollective.png",CurrentModPath),
	})
end
