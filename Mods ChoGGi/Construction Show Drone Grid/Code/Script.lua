-- See LICENSE for terms

local mod_id = "ChoGGi_ConstructionShowDroneGrid"
local mod = Mods[mod_id]
local mod_Option1 = mod.options and mod.options.Option1 or true

local function ModOptions()
	mod_Option1 = mod.options.Option1
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local green = green
local yellow = yellow
local CleanupHexRanges = CleanupHexRanges
local table_insert = table.insert

local orig_ShowBuildingHexes = ShowBuildingHexes
function ShowBuildingHexes(bld, hex_range_class, bind_func, ...)
  if IsKindOf(bld, "RCRover") and bld:IsValidPos() and not bld.destroyed then
		CleanupHexRanges(bld, bind_func)
		local obj = g_Classes[hex_range_class]:new()
		obj:SetPos(bld:GetPos():SetStepZ())
		local g_HexRanges = g_HexRanges
		g_HexRanges[bld] = g_HexRanges[bld] or {}
		table_insert(g_HexRanges[bld], obj)
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
function CursorBuilding:GameInit()
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(self)
	end
	local UICity = UICity
	ShowHexRanges(UICity, "SupplyRocket")
	ShowHexRanges(UICity, "DroneHub")
	-- function ShowHexRanges(city, class, cursor_obj, bind_func, single_obj)
	ShowHexRanges(UICity, "RCRover", nil, "GetSelectionRadiusScale_OverrideChoGGi")

	-- change colours
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOf(obj, "SupplyRocket") then
			for i = 1, #range.decals do
				range.decals[i]:SetColorModifier(green)
			end
		elseif IsKindOf(obj, "RCRover") then
			for i = 1, #range.decals do
				range.decals[i]:SetColorModifier(yellow)
			end
		end
	end

	return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()
	local UICity = UICity
	HideHexRanges(UICity, "SupplyRocket")
	HideHexRanges(UICity, "DroneHub")
	HideHexRanges(UICity, "RCRover")

	return orig_CursorBuilding_Done(self)
end
