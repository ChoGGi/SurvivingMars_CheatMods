-- See LICENSE for terms

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local RGBtoColour = ChoGGi.ComFuncs.RGBtoColour

local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits

local mod_EnableGrid
local mod_DistFromCursor
local mod_GridOpacity
local mod_GridScale
local mod_HexColour

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableGrid = options:GetProperty("Option1")
	mod_DistFromCursor = options:GetProperty("DistFromCursor") * 1000
	mod_GridOpacity = options:GetProperty("GridOpacity")
	mod_GridScale = options:GetProperty("GridScale")

	mod_HexColour = RGBtoColour(options:GetProperty("HexColour"))
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local grids_visible

local function ShowGrids()
	SuspendPassEdits("ChoGGi.CursorBuilding.GameInit.Show Heater Range")
	ShowHexRanges(UICity, "SubsurfaceHeater")

	-- edit grids
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOf(obj, "SubsurfaceHeater") then
			if IsKindOf(range, "RangeHexMultiSelectRadius") then
				range:SetOpacity(mod_GridOpacity)
				range.ChoGGi_visible = true
			end

			for i = 1, #range.decals do
				local decal = range.decals[i]
				decal:SetColorModifier(mod_HexColour)
				decal:SetScale(mod_GridScale)
			end
		end
	end

	ResumePassEdits("ChoGGi.CursorBuilding.GameInit.Show Heater Range")
	grids_visible = true
end

local function HideGrids()
	SuspendPassEdits("ChoGGi.CursorBuilding.Done.Show Heater Range")
	HideHexRanges(UICity, "SubsurfaceHeater")
	ResumePassEdits("ChoGGi.CursorBuilding.Done.Show Heater Range")
	grids_visible = false
end

local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	ChoOrig_CursorBuilding_GameInit(...)
	if mod_EnableGrid then
		ShowGrids()
	end
end

local ChoOrig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if not mod_EnableGrid then
		return ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

	SuspendPassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Show Heater Range")
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if range.SetVisible and IsKindOf(obj, "SubsurfaceHeater") then
			if range_limit and cursor_pos:Dist2D(obj:GetPos()) > range_limit then
				-- GetVisible() always returns true (for ranges?)
				if range.ChoGGi_visible then
					range:SetVisible(false)
					range.ChoGGi_visible = false
				end
			else
				if not range.ChoGGi_visible then
					range:SetVisible(true)
					range.ChoGGi_visible = true
				end
			end
		end
	end
	ResumePassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Show Heater Range")

	return ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return ChoOrig_CursorBuilding_Done(...)
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011602, "Construction Show Heater Range"),
	ActionId = "ChoGGi.ConstructionShowHeaterRange.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 7",
	replace_matching_id = true,
	ActionBindable = true,
}
