-- See LICENSE for terms

-- we can't update mod options on our own, so we'll store per-game for now
GlobalVar("g_ChoGGi_LandscapeSizes",false)

local mod_id = "ChoGGi_AdjustLandscapingSize"
local mod = Mods[mod_id]

-- technically we only go down to 100, but whatever
LandscapeTerraceController.brush_radius_min = 1
LandscapeTextureController.brush_radius_min = 1
LandscapeRampController.brush_radius_min = 1

local step_size
local cursor_building
local construct_type
local function AdjustSize(size)
	local ctrl
	if construct_type == "Terrace" then
		ctrl = CityLandscapeTerrace[UICity]
	elseif construct_type == "Texture" then
		ctrl = CityLandscapeTexture[UICity]
	elseif construct_type == "Ramp" then
		ctrl = CityLandscapeRamp[UICity]
	end
	if not ctrl then
		return
	end

	if not step_size then
		step_size = mod.options.StepSize * guim
	end

	if size == "larger" then
		size = g_ChoGGi_LandscapeSizes[construct_type] + step_size
	elseif size == "smaller" then
		size = g_ChoGGi_LandscapeSizes[construct_type] - step_size
	end
	if size < 100 then
		size = 100
	end
	-- update saved
	g_ChoGGi_LandscapeSizes[construct_type] = size

	-- update brush
	ctrl.brush_radius = size
	ctrl.brush_radius_max = size
	-- update visual size right away instead of when mouse is moved
	ctrl:UpdateCursor(ctrl.last_pos)
end

do -- add shortcut actions
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions
	c = c + 1
	Actions[c] = {ActionName = "AdjustLand: Larger",
		ActionId = "ChoGGi.AdjustLand.Larger",
		OnAction = function()
			AdjustSize("larger")
		end,
		ActionShortcut = "Shift-E",
		ActionBindable = true,
		ActionMode = "AdjustLandscapingSize",
	}

	c = c + 1
	Actions[c] = {ActionName = "AdjustLand: Smaller",
		ActionId = "ChoGGi.AdjustLand.Smaller",
		OnAction = function()
			AdjustSize("smaller")
		end,
		ActionShortcut = "Shift-Q",
		ActionBindable = true,
		ActionMode = "AdjustLandscapingSize",
	}
end

local shortcuts_mode
local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	local name = self.template and self.template.template_name
	if name == "LandscapeTerrace" or name == "LandscapeRamp" or name:sub(1,16) == "LandscapeTexture" then
		if name == "LandscapeTerrace" then
			construct_type = "Terrace"
		elseif name == "LandscapeRamp" then
			construct_type = "Ramp"
		else
			construct_type = "Texture"
		end
		cursor_building = self
		shortcuts_mode = XShortcutsTarget and XShortcutsTarget:GetActionsMode()
		XShortcutsSetMode("AdjustLandscapingSize")
	end
	return orig_CursorBuilding_GameInit(self,...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done(...)
	construct_type = false
	cursor_building = false
	-- go back to normal controls
	if shortcuts_mode then
		XShortcutsSetMode(shortcuts_mode)
		shortcuts_mode = false
	end
	return orig_CursorBuilding_Done(self,...)
end

local function StartupCode()
	if not g_ChoGGi_LandscapeSizes then
		g_ChoGGi_LandscapeSizes = {
			Terrace = 10 * guim,
			Texture = 10 * guim,
			Ramp = 10 * guim,
		}
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end
	step_size = (mod.options.StepSize or 5) * guim
end

-- override limits
function OnMsg.ClassesGenerate()

	local table_remove = table.remove
	local ignore_status
	local orig_UpdateConstructionStatuses = LandscapeConstructionController.UpdateConstructionStatuses
	function LandscapeConstructionController:UpdateConstructionStatuses(...)
		local ret = orig_UpdateConstructionStatuses(self,...)

		-- skip doing this if ecm option is also enabled (since it does the same)
		if mod.options.RemoveLandScapingLimits and not ChoGGi.UserSettings.RemoveLandScapingLimits then
			if not ignore_status then
				local cs = ConstructionStatus
				ignore_status = {
					[cs.LandscapeTooLarge] = true,
					[cs.LandscapeUnavailable] = true,
					[cs.LandscapeLowTerrain] = true,
					[cs.BlockingObjects] = true,
					[cs.LandscapeRampUnlinked] = true,
				}
			end

			local statuses = self.construction_statuses or ""
			for i = 1, #statuses do
				local status = statuses[i]
				if ignore_status[status] then
					status.type = "warning"
				end
			end
		end

		return ret
	end
end
