local mod_id = "ChoGGi_ConstructionExtendLength"
local mod = Mods[mod_id]
local mod_BuildDist = mod.options and mod.options.BuildDist or 500
local mod_PassChunks = mod.options and mod.options.PassChunks or 500

local function ModOptions()
	mod_BuildDist = mod.options.BuildDist
	mod_PassChunks = mod.options.PassChunks

	CityGridConstruction[UICity].max_hex_distance_to_allow_build = mod_BuildDist
	GridConstructionController.max_hex_distance_to_allow_build = mod_BuildDist
	const.PassageConstructionGroupMaxSize = mod_PassChunks
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions
