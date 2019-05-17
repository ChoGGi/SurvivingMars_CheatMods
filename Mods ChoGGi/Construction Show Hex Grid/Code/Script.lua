-- See LICENSE for terms

local mod_id = "ChoGGi_ConstructionShowHexGrid"
local mod = Mods[mod_id]
local mod_Option1 = mod.options and mod.options.Option1 or true

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_Option1 = mod.options.Option1
end

-- for some reason mod options aren't retrieved before this script is loaded...
local function StartupCode()
	mod_Option1 = mod.options.Option1
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(self)
	end
	SetPostProcPredicate("hexgrid", true)
	return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()
	SetPostProcPredicate("hexgrid", false)
	return orig_CursorBuilding_Done(self)
end
