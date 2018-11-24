-- put this in script or change load order in metadata
ChoGGi_ConstructionShowHexGrid = {
	Option1 = true,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_ConstructionShowHexGrid = ChoGGi_ConstructionShowHexGrid

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_ConstructionShowHexGrid", "Construct: HexGrid")

	ModConfig:RegisterOption("ChoGGi_ConstructionShowHexGrid", "Option1", {
		name = "Show during construction",
		type = "boolean",
		default = ChoGGi_ConstructionShowHexGrid.Option1,
	})

	-- get saved options
	ChoGGi_ConstructionShowHexGrid.Option1 = ModConfig:Get("ChoGGi_ConstructionShowHexGrid", "Option1")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_ConstructionShowHexGrid" and option_id == "Option1" then
		ChoGGi_ConstructionShowHexGrid.Option1 = value
	end
end
