-- See LICENSE for terms

local mod_BuildDist
local mod_PassChunks


-- fired when settings are changed/init
local function ModOptions()
	mod_BuildDist = CurrentModOptions:GetProperty("BuildDist")
	mod_PassChunks = CurrentModOptions:GetProperty("PassChunks")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local function StartupCode()
	CityGridConstruction[UICity].max_hex_distance_to_allow_build = mod_BuildDist
	GridConstructionController.max_hex_distance_to_allow_build = mod_BuildDist
	const.PassageConstructionGroupMaxSize = mod_PassChunks
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
