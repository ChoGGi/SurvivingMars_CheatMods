-- See LICENSE for terms

local options
local mod_Option1
local mod_DistFromCursor
local mod_GridOpacity

-- fired when settings are changed/init
local function ModOptions()
	mod_Option1 = options.Option1
	mod_DistFromCursor = options.DistFromCursor * 1000
	mod_GridOpacity = options.GridOpacity
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_ConstructionShowDroneGrid" then
		return
	end

	ModOptions()
end

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local IsKindOfClasses = IsKindOfClasses
local pairs = pairs
local green = green
local yellow = yellow
local white = white
local CleanupHexRanges = CleanupHexRanges

local classes = {"SupplyRocket", "DroneHub", "RCRover"}

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

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(...)
	end
	local UICity = UICity
	ShowHexRanges(UICity, "SupplyRocket")
	ShowHexRanges(UICity, "DroneHub")
	-- function ShowHexRanges(city, class, cursor_obj, bind_func, single_obj)
	ShowHexRanges(UICity, "RCRover", nil, "GetSelectionRadiusScale_OverrideChoGGi")

	-- change colours
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOfClasses(obj, classes) then
			if IsKindOf(range, "RangeHexMultiSelectRadius") then
				range:SetOpacity(mod_GridOpacity)
			end

			if IsKindOf(obj, "SupplyRocket") then
				for i = 1, #range.decals do
					range.decals[i]:SetColorModifier(green)
				end
			elseif IsKindOf(obj, "RCRover") then
				for i = 1, #range.decals do
					range.decals[i]:SetColorModifier(yellow)
				end
			elseif IsKindOf(obj, "DroneHub") then
				for i = 1, #range.decals do
					range.decals[i]:SetColorModifier(white)
				end
			end
		end
	end

	return orig_CursorBuilding_GameInit(...)
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	-- skip if disabled or not a RequiresMaintenance building
	if not mod_Option1 then
		return orig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOfClasses(obj, classes) and IsKindOf(range, "RangeHexMultiSelectRadius") then
			if range_limit and cursor_pos:Dist2D(obj:GetPos()) > range_limit then
				range:SetVisible(false)
			else
				range:SetVisible(true)
			end
		end
	end

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	local UICity = UICity
	HideHexRanges(UICity, "SupplyRocket")
	HideHexRanges(UICity, "DroneHub")
	HideHexRanges(UICity, "RCRover")

	return orig_CursorBuilding_Done(...)
end
