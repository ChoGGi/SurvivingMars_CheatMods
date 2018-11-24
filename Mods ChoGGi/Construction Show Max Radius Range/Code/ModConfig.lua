-- put this in script or change load order in metadata
ChoGGi_ShowMaxRadiusRange = {
	Option1 = true,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_ShowMaxRadiusRange = ChoGGi_ShowMaxRadiusRange

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_ShowMaxRadiusRange", "Construct: MaxRadiusRange")

	ModConfig:RegisterOption("ChoGGi_ShowMaxRadiusRange", "Option1", {
		name = "Show during construction",
		type = "boolean",
		default = ChoGGi_ShowMaxRadiusRange.Option1,
	})

	-- get saved options
	ChoGGi_ShowMaxRadiusRange.Option1 = ModConfig:Get("ChoGGi_ShowMaxRadiusRange", "Option1")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_ShowMaxRadiusRange" and option_id == "Option1" then
		ChoGGi_ShowMaxRadiusRange.Option1 = value
	end
end
