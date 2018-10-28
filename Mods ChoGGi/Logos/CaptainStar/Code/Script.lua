local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_CaptainStar,
		"CaptainStar",
		StringFormat("%sEntities/CaptainStar.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","CaptainStar",
		"entity_name","CaptainStar",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Captain Star]],
		decal_entity = "CaptainStar",
		entity_name = "CaptainStar",
		id = "ChoGGi.Logos.CaptainStar",
		image = StringFormat("%sUI/CaptainStar.png",CurrentModPath),
	})
end
