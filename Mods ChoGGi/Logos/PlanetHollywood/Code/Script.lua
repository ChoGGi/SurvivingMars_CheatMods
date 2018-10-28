local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- wrapping in a pcall removes an error from the log (doesn't seem to matter either way)
pcall(function()
	-- needs to happen before the decal object is placed
	DelayedLoadEntity(
		Mods.ChoGGi_Logos_PlanetHollywood,
		"PlanetHollywood",
		StringFormat("%sEntities/PlanetHollywood.ent",CurrentModPath)
	)

	PlaceObj("Decal", {
		"name","PlanetHollywood",
		"entity_name","PlanetHollywood",
	})
end)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Planet Hollywood]],
		decal_entity = "PlanetHollywood",
		entity_name = "PlanetHollywood",
		id = "ChoGGi.Logos.PlanetHollywood",
		image = StringFormat("%sUI/PlanetHollywood.png",CurrentModPath),
	})
end
