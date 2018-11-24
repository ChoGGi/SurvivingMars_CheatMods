-- put this in script or change load order in metadata
ChoGGi_ConstructionShowDroneGrid = {
	Option1 = true,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_ConstructionShowDroneGrid = ChoGGi_ConstructionShowDroneGrid

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_ConstructionShowDroneGrid", "Construct: DroneGrid")

	ModConfig:RegisterOption("ChoGGi_ConstructionShowDroneGrid", "Option1", {
		name = "Show during construction",
		type = "boolean",
		default = ChoGGi_ConstructionShowDroneGrid.Option1,
	})

	-- get saved options
	ChoGGi_ConstructionShowDroneGrid.Option1 = ModConfig:Get("ChoGGi_ConstructionShowDroneGrid", "Option1")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_ConstructionShowDroneGrid" and option_id == "Option1" then
		ChoGGi_ConstructionShowDroneGrid.Option1 = value
	end
end
