local mod_id = "ChoGGi_ConstructionExtendLength"
local mod = Mods[mod_id]
local mod_BuildDist = mod.options and mod.options.BuildDist or 500
local mod_PassChunks = mod.options and mod.options.PassChunks or 500

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	const.PassageConstructionGroupMaxSize = mod.options.PassChunks
	CityGridConstruction[UICity].max_hex_distance_to_allow_build = mod.options.BuildDist
	GridConstructionController.max_hex_distance_to_allow_build = mod.options.BuildDist
end

local function SomeCode()
	CityGridConstruction[UICity].max_hex_distance_to_allow_build = mod_BuildDist
	GridConstructionController.max_hex_distance_to_allow_build = mod_BuildDist
	const.PassageConstructionGroupMaxSize = mod_PassChunks
end

-- new games
OnMsg.CityStart = SomeCode
-- loaded games
OnMsg.LoadGame = SomeCode
