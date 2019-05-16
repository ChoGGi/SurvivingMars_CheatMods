-- See LICENSE for terms

local mod_id = "ChoGGi_ConstructionShowHexBuildableGrid"
local mod = Mods[mod_id]
local mod_Option1 = mod.options and mod.options.Option1 or true

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_Option1 = mod.options.Option1
	local u = ChoGGi.UserSettings
	u.DebugGridOpacity = mod.options.DebugGridOpacity
	u.DebugGridSize = mod.options.DebugGridSize
	ChoGGi.SettingFuncs.WriteSettings()
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(self)
	end
	ChoGGi.ComFuncs.BuildableHexGrid(true)
	return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()
	ChoGGi.ComFuncs.BuildableHexGrid(false)
	return orig_CursorBuilding_Done(self)
end
