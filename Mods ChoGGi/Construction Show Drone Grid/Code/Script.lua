-- See LICENSE for terms

-- local whatever globals we call
local table_find = table.find
local table_remove = table.remove
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local IsKindOfClasses = IsKindOfClasses
local pairs = pairs
local CleanupHexRanges = CleanupHexRanges
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local DoneObject = DoneObject
local green = green
local yellow = yellow
local cyan = cyan
local InvalidPos = InvalidPos()

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

local classes = {"SupplyRocket", "DroneHub", "RCRover", "ConstructionSite"}

local orig_ShowBuildingHexes = ShowBuildingHexes
function ShowBuildingHexes(bld, hex_range_class, bind_func, ...)
  if bld and bld:IsKindOf("RCRover") and bld:IsValidPos() and not bld.destroyed then
		CleanupHexRanges(bld, bind_func)
		local obj = g_Classes[hex_range_class]:new()
		obj:SetPos(bld:GetPos():SetStepZ())
		local g_HexRanges = g_HexRanges
		g_HexRanges[bld] = g_HexRanges[bld] or {}
		local range = g_HexRanges[bld]
		range[#range+1] = obj
		g_HexRanges[obj] = bld
		obj.bind_to = bind_func
		obj:SetScale(bld[bind_func](bld))
		return
	end
	return orig_ShowBuildingHexes(bld, hex_range_class, bind_func, ...)
end

-- GetSelectionRadiusScale normally returns 0 unless you have that rover selected
function RCRover:GetSelectionRadiusScale_OverrideChoGGi()
	return self.work_radius
end

local grids_visible

local function ShowGrids()
	SuspendPassEdits("CursorBuilding.GameInit.Construction Show Drone Grid")

	local UICity = UICity
	ShowHexRanges(UICity, "SupplyRocket")
	ShowHexRanges(UICity, "DroneHub")
	-- function ShowHexRanges(city, class, cursor_obj, bind_func, single_obj)
	ShowHexRanges(UICity, "RCRover", nil, "GetSelectionRadiusScale_OverrideChoGGi")

	-- edit grids
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOfClasses(obj, classes) then
			local is_site = obj:IsKindOf("ConstructionSite")
			if not is_site or (is_site and table_find(classes, obj.building_class)) then
				if IsKindOf(range, "RangeHexMultiSelectRadius") then
					range:SetOpacity(is_site and 100 or mod_GridOpacity)
					range.ChoGGi_visible = true
				end

				if obj:IsKindOf("DroneHub") then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(cyan)
						decal:SetScale(mod_GridScale)
					end
				elseif obj:IsKindOf("RCRover") then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(yellow)
						decal:SetScale(mod_GridScale)
					end
				elseif obj:IsKindOf("SupplyRocket") then
--~ 				else
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(green)
						decal:SetScale(mod_GridScale)
					end
				end
			end
		end
	end

	ResumePassEdits("CursorBuilding.GameInit.Construction Show Drone Grid")
	grids_visible = true
end
local function HideGrids()
	SuspendPassEdits("CursorBuilding.Done.Construction Show Drone Grid")
	local UICity = UICity
	HideHexRanges(UICity, "SupplyRocket")
	HideHexRanges(UICity, "DroneHub")
	HideHexRanges(UICity, "RCRover")
	ResumePassEdits("CursorBuilding.Done.Construction Show Drone Grid")
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

	SuspendPassEdits("CursorBuilding.UpdateShapeHexes.Construction Show Drone Grid")
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if range.SetVisible and IsValid(obj) and IsKindOfClasses(obj, classes) then
			local is_site = obj:IsKindOf("ConstructionSite")
			if not is_site or (is_site and table_find(classes, obj.building_class)) then
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
	end
	ResumePassEdits("CursorBuilding.UpdateShapeHexes.Construction Show Drone Grid")

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return orig_CursorBuilding_Done(...)
end

local function CleanList(list)
	for i = #(list or ""), 1, -1 do
		DoneObject(list[i])
		table_remove(list, i)
	end
end

-- just in case
function OnMsg.SaveGame()
	local g_HexRanges = g_HexRanges
	for obj, list in pairs(g_HexRanges) do
		if obj.GetPos and obj:GetPos() == InvalidPos then
			CleanList(list)
			g_HexRanges[obj] = nil
		end
	end
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011487, "Construction Show Drone Range"),
	ActionId = "ChoGGi.ConstructionShowDroneRange.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 3",
	replace_matching_id = true,
	ActionBindable = true,
}
