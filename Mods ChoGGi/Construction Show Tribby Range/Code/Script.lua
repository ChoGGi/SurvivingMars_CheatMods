-- See LICENSE for terms

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local purple = purple
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits

local options
local mod_EnableGrid
local mod_DistFromCursor
local mod_GridOpacity
local mod_GridScale

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableGrid = options:GetProperty("Option1")
	mod_DistFromCursor = options:GetProperty("DistFromCursor") * 1000
	mod_GridOpacity = options:GetProperty("GridOpacity")
	mod_GridScale = options:GetProperty("GridScale")
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

local grids_visible

local function ShowGrids()
	SuspendPassEdits("CursorBuilding.GameInit.Construction Show Tribby Range")
	ShowHexRanges(UICity, "TriboelectricScrubber")

	-- edit grids
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOf(obj, "TriboelectricScrubber") then
			if IsKindOf(range, "RangeHexMultiSelectRadius") then
				range:SetOpacity(mod_GridOpacity)
				range.ChoGGi_visible = true
			end

			for i = 1, #range.decals do
				local decal = range.decals[i]
				decal:SetColorModifier(purple)
				decal:SetScale(mod_GridScale)
			end
		end
	end

	ResumePassEdits("CursorBuilding.GameInit.Construction Show Tribby Range")
	grids_visible = true
end

local function HideGrids()
	SuspendPassEdits("CursorBuilding.Done.Construction Show Tribby Range")
	HideHexRanges(UICity, "TriboelectricScrubber")
	ResumePassEdits("CursorBuilding.Done.Construction Show Tribby Range")
	grids_visible = false
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	orig_CursorBuilding_GameInit(...)
	if mod_EnableGrid then
		ShowGrids()
	end
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if not mod_EnableGrid then
		return orig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

	SuspendPassEdits("CursorBuilding.UpdateShapeHexes.Construction Show Tribby Range")
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if range.SetVisible and IsKindOf(obj, "TriboelectricScrubber") then
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
	ResumePassEdits("CursorBuilding.UpdateShapeHexes.Construction Show Tribby Range")

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return orig_CursorBuilding_Done(...)
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011485, "Construction Show Tribby Range"),
	ActionId = "ChoGGi.ConstructionShowTribbyRange.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 1",
	replace_matching_id = true,
	ActionBindable = true,
}
