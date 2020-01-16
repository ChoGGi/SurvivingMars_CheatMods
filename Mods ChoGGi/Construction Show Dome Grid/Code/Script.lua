-- See LICENSE for terms

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local reddish = -46777 -- lighter red than "red"

local options
local mod_EnableGrid
local mod_DistFromCursor
local mod_GridOpacity
local mod_SelectDome
local mod_SelectOutside
local mod_GridScale

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableGrid = options:GetProperty("Option1")
	mod_DistFromCursor = options:GetProperty("DistFromCursor") * 1000
	mod_GridOpacity = options:GetProperty("GridOpacity")
	mod_SelectDome = options:GetProperty("SelectDome")
	mod_SelectOutside = options:GetProperty("SelectOutside")
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
	SuspendPassEdits("CursorBuilding.GameInit.Construction Show Dome Grid")
	ShowHexRanges(nil, "Dome")

	-- edit grids
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOf(obj, "Dome") then
			if IsKindOf(range, "RangeHexMultiSelectRadius") then
				range:SetOpacity(mod_GridOpacity)
				range.ChoGGi_visible = true
			end

			for i = 1, #range.decals do
				local decal = range.decals[i]
				decal:SetColorModifier(reddish)
				decal:SetScale(mod_GridScale)
			end

		end
	end

	ResumePassEdits("CursorBuilding.GameInit.Construction Show Dome Grid")
	grids_visible = true
end
local function HideGrids()
	SuspendPassEdits("CursorBuilding.Done.Construction Show Dome Grid")
	HideHexRanges(nil, "Dome")
	ResumePassEdits("CursorBuilding.Done.Construction Show Dome Grid")
	grids_visible = false
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	orig_CursorBuilding_GameInit(self, ...)
	if mod_EnableGrid and self.template:IsKindOf("Dome") then
		ShowGrids()
	end
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if not (mod_EnableGrid or self.template:IsKindOf("Dome")) then
		return orig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

	SuspendPassEdits("CursorBuilding.UpdateShapeHexes.Construction Show Dome Grid")
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if range.SetVisible and IsKindOf(obj, "Dome") then
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
	ResumePassEdits("CursorBuilding.UpdateShapeHexes.Construction Show Dome Grid")

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return orig_CursorBuilding_Done(...)
end

local function AddRanges()
	SuspendPassEdits("SelectionAdded.Construction Show Dome Grid")
	ShowHexRanges(nil, "Dome")
	ResumePassEdits("SelectionAdded.Construction Show Dome Grid")
end

function OnMsg.SelectionAdded(obj)
	if not obj then
		return
	end

	if mod_SelectDome and obj:IsKindOf("Dome")
		or mod_SelectOutside and obj:IsKindOf("DomeOutskirtBld") and not obj:IsKindOf("StorageDepot")
	then
		-- needs a slight delay, or last selected dome will lose it's selection radius
		CreateRealTimeThread(AddRanges)
	end
end

function OnMsg.SelectionRemoved()
	SuspendPassEdits("SelectionRemoved.Construction Show Dome Grid")
	HideHexRanges(nil, "Dome")
	ResumePassEdits("SelectionRemoved.Construction Show Dome Grid")
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011488, "Construction Show Dome Range"),
	ActionId = "ChoGGi.ConstructionShowDomeRange.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 4",
	replace_matching_id = true,
	ActionBindable = true,
}
