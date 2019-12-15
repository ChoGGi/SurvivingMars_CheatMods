-- See LICENSE for terms

local mod_BuildDist
local mod_PassChunks

local function SetOptions()
	if UICity then
		CityGridConstruction[UICity].max_hex_distance_to_allow_build = mod_BuildDist
	end
	GridConstructionController.max_hex_distance_to_allow_build = mod_BuildDist
	const.PassageConstructionGroupMaxSize = mod_PassChunks
end

-- fired when settings are changed/init
local function ModOptions()
	mod_BuildDist = CurrentModOptions:GetProperty("BuildDist")
	mod_PassChunks = CurrentModOptions:GetProperty("PassChunks")

	SetOptions()
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

-- set options on new/load game
OnMsg.CityStart = SetOptions
OnMsg.LoadGame = SetOptions
