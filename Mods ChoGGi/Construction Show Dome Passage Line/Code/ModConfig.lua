-- put this in script or change load order in metadata
ChoGGi_ConstructionShowDomePassageLine = {
	Option1 = true,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_ConstructionShowDomePassageLine = ChoGGi_ConstructionShowDomePassageLine

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_ConstructionShowDomePassageLine", "Construct: DomePassageLine")

	ModConfig:RegisterOption("ChoGGi_ConstructionShowDomePassageLine", "Option1", {
		name = "Show during construction",
		type = "boolean",
		default = ChoGGi_ConstructionShowDomePassageLine.Option1,
	})

	-- get saved options
	ChoGGi_ConstructionShowDomePassageLine.Option1 = ModConfig:Get("ChoGGi_ConstructionShowDomePassageLine", "Option1")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_ConstructionShowDomePassageLine" and option_id == "Option1" then
		ChoGGi_ConstructionShowDomePassageLine.Option1 = value
	end
end
