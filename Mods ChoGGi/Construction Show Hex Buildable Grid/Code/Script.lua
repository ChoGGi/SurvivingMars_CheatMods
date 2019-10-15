-- See LICENSE for terms

local options
local mod_Option1

-- fired when settings are changed/init
local function ModOptions()
	mod_Option1 = options:GetProperty("Option1")
	local u = ChoGGi.UserSettings
	u.DebugGridOpacity = options:GetProperty("DebugGridOpacity")
	u.DebugGridSize = options:GetProperty("DebugGridSize")
	if ChoGGi.SettingFuncs.WriteSettings then
		ChoGGi.SettingFuncs.WriteSettings()
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
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
