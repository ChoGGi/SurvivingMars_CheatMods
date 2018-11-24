-- put this in script or change load order in metadata
ChoGGi_ConstructionShowMapSectors = {
	Option1 = true,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_ConstructionShowMapSectors = ChoGGi_ConstructionShowMapSectors

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_ConstructionShowMapSectors", "Construct: MapSectors")

	ModConfig:RegisterOption("ChoGGi_ConstructionShowMapSectors", "Option1", {
		name = "Show during construction",
		type = "boolean",
		default = ChoGGi_ConstructionShowMapSectors.Option1,
	})

	-- get saved options
	ChoGGi_ConstructionShowMapSectors.Option1 = ModConfig:Get("ChoGGi_ConstructionShowMapSectors", "Option1")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_ConstructionShowMapSectors" and option_id == "Option1" then
		ChoGGi_ConstructionShowMapSectors.Option1 = value
	end
end
