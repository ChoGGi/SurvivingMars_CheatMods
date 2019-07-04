-- See LICENSE for terms

local options
local mod_Option1

-- fired when settings are changed/init
local function ModOptions()
	mod_Option1 = options.Option1
	local u = ChoGGi.UserSettings
	u.DebugGridOpacity = options.DebugGridOpacity
	u.DebugGridSize = options.DebugGridSize
	ChoGGi.SettingFuncs.WriteSettings()
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_ConstructionShowHexBuildableGrid" then
		return
	end

	ModOptions()
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if mod_Option1 then
		ChoGGi.ComFuncs.BuildableHexGrid(true)
	end
	return orig_CursorBuilding_GameInit(...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	ChoGGi.ComFuncs.BuildableHexGrid(false)
	return orig_CursorBuilding_Done(...)
end
