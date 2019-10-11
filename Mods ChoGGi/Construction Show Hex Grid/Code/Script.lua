-- See LICENSE for terms

local mod_Option1

-- fired when settings are changed/init
local function ModOptions()
	mod_Option1 = CurrentModOptions.Option1
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

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if mod_Option1 then
		SetPostProcPredicate("hexgrid", true)
	end
	return orig_CursorBuilding_GameInit(...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	SetPostProcPredicate("hexgrid", false)
	return orig_CursorBuilding_Done(...)
end
