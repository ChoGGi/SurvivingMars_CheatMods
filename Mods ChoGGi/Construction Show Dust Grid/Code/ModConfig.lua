-- put this in script or change load order in metadata
ChoGGi_ConstructionShowDustGrid = {
	Option1 = true,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_ConstructionShowDustGrid = ChoGGi_ConstructionShowDustGrid

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_ConstructionShowDustGrid", "Construct: DustGrid")

	ModConfig:RegisterOption("ChoGGi_ConstructionShowDustGrid", "Option1", {
		name = "Show during construction",
		type = "boolean",
		default = ChoGGi_ConstructionShowDustGrid.Option1,
	})

	-- get saved options
	ChoGGi_ConstructionShowDustGrid.Option1 = ModConfig:Get("ChoGGi_ConstructionShowDustGrid", "Option1")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_ConstructionShowDustGrid" and option_id == "Option1" then
		ChoGGi_ConstructionShowDustGrid.Option1 = value
	end
end
