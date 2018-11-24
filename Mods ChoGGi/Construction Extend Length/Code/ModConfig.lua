-- put this in script or change load order in metadata
ConstructionExtendLength = {
	BuildDist = 500,
	PassChunks = 500,
}

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ConstructionExtendLength = ConstructionExtendLength

	-- setup menu options
	ModConfig:RegisterMod("ConstructionExtendLength", "Construction Length")

	ModConfig:RegisterOption("ConstructionExtendLength", "BuildDist", {
		name = "How many hexes you can build",
		type = "number",
		min = 0,
		max = 1000,
		step = 25,
		default = ConstructionExtendLength.BuildDist,
	})
	ModConfig:RegisterOption("ConstructionExtendLength", "PassChunks", {
		name = "Passage length if bent",
		type = "number",
		min = 0,
		max = 1000,
		step = 25,
		default = ConstructionExtendLength.PassChunks,
	})

	-- get saved options
	ConstructionExtendLength.BuildDist = ModConfig:Get("ConstructionExtendLength", "BuildDist")
	ConstructionExtendLength.PassChunks = ModConfig:Get("ConstructionExtendLength", "PassChunks")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ConstructionExtendLength" then
		if option_id == "PassChunks" then
			ConstructionExtendLength.PassChunks = value
			const.PassageConstructionGroupMaxSize = value
		elseif option_id == "BuildDist" then
			GridConstructionController.max_hex_distance_to_allow_build = value
			ConstructionExtendLength.BuildDist = value
		end
	end
end
