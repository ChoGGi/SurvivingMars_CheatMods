-- put this in script or change load order in metadata
DomeTeleporters = {
	BuildDist = GridConstructionController.max_hex_distance_to_allow_build,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local DomeTeleporters = DomeTeleporters

	-- setup menu options
	ModConfig:RegisterMod("DomeTeleporter", "Dome Tunnels")

	ModConfig:RegisterOption("DomeTeleporter", "BuildDist", {
		name = "How many hexes you can build",
		type = "number",
		min = 1,
		max = 1000,
		step = 5,
		default = DomeTeleporters.BuildDist,
	})

	-- get saved options
	DomeTeleporters.BuildDist = ModConfig:Get("DomeTeleporter", "BuildDist")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "DomeTeleporter" then
		if option_id == "BuildDist" then
			DomeTeleporters.BuildDist = value
			CityDomeTeleporterConstruction[UICity].max_hex_distance_to_allow_build = value
			CityDomeTeleporterConstruction[UICity].max_range = value
			-- I don't think anymore will spawn once one has, but whatever
			DomeTeleporterConstructionController.max_hex_distance_to_allow_build = value
			DomeTeleporterConstructionController.max_range = value
		end
	end
end
