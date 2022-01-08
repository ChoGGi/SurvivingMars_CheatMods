-- See LICENSE for terms

-- local whatever globals we call
local table = table
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local IsKindOfClasses = IsKindOfClasses
local pairs = pairs
local CleanupHexRanges = CleanupHexRanges
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local DoneObject = DoneObject
local InvalidPos = InvalidPos()

local RGBtoColour = ChoGGi.ComFuncs.RGBtoColour

local mod_EnableGrid
local mod_DistFromCursor
local mod_GridOpacity
local mod_GridScale
local mod_HexColourDroneHub
local mod_HexColourRCRover
local mod_HexColourSupplyRocket
local mod_HexColourElevator
local mod_HexColourDroneHubExtender

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

	mod_HexColourDroneHub = RGBtoColour(options:GetProperty("HexColourDroneHub"))
	mod_HexColourRCRover = RGBtoColour(options:GetProperty("HexColourRCRover"))
	mod_HexColourSupplyRocket = RGBtoColour(options:GetProperty("HexColourSupplyRocket"))
	mod_HexColourElevator = RGBtoColour(options:GetProperty("HexColourElevator"))
	mod_HexColourDroneHubExtender = RGBtoColour(options:GetProperty("HexColourDroneHubExtender"))
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local classes
local classes_o = {
	"ConstructionSite",
	"DroneHub",
	"RCRover",
	"RocketBase",
}
classes = classes_o
local classes_p = {
	"ConstructionSite",
	"DroneHub",
	"DroneHubExtender",
	"Elevator",
	"RCRover",
	"RocketBase",
}
local picard_active
local grids_visible

local ChoOrig_ShowBuildingHexes = ShowBuildingHexes
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
	return ChoOrig_ShowBuildingHexes(bld, hex_range_class, bind_func, ...)
end

-- GetSelectionRadiusScale normally returns 0 unless you have that rover selected
function RCRover:GetSelectionRadiusScale_OverrideChoGGi()
	return self.work_radius
end

local function ShowGrids()
	if picard_active ~= false and picard_active ~= true then
		picard_active = g_AccessibleDlc.picard
	end

	if picard_active then
		classes = classes_p
	else
		classes = classes_o
	end

	SuspendPassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Drone Grid")

	local UICity = UICity
	ShowHexRanges(UICity, "SupplyRocket")
	ShowHexRanges(UICity, "DroneHub")
	if picard_active then
		ShowHexRanges(UICity, "Elevator")
		ShowHexRanges(UICity, "DroneHubExtender")
	end
	-- function ShowHexRanges(city, class, cursor_obj, bind_func, single_obj)
	ShowHexRanges(UICity, "RCRover", nil, "GetSelectionRadiusScale_OverrideChoGGi")
	-- so far space race is only dlc that adds more commander rovers
	if g_AvailableDlc.gagarin then
		-- seekers/etc
		ClassDescendantsList("RCRover", function(name)
			ShowHexRanges(UICity, name, nil, "GetSelectionRadiusScale_OverrideChoGGi")
		end)
	end

	-- edit grids
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOfClasses(obj, classes) then
			local is_site = obj:IsKindOf("ConstructionSite")
			if not is_site or (is_site and table.find(classes, obj.building_class)) then
				if IsKindOf(range, "RangeHexMultiSelectRadius") then
					range:SetOpacity(is_site and 100 or mod_GridOpacity)
					range.ChoGGi_visible = true
				end

				--
				if obj:IsKindOf("DroneHub") then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(mod_HexColourDroneHub)
						decal:SetScale(mod_GridScale)
					end
				elseif obj:IsKindOf("RCRover") then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(mod_HexColourRCRover)
						decal:SetScale(mod_GridScale)
					end
				elseif obj:IsKindOf("RocketBase") then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(mod_HexColourSupplyRocket)
						decal:SetScale(mod_GridScale)
					end
				elseif obj:IsKindOf("DroneHubExtender") then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(mod_HexColourDroneHubExtender)
						decal:SetScale(mod_GridScale)
					end
				elseif obj:IsKindOf("Elevator") then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(mod_HexColourElevator)
						decal:SetScale(mod_GridScale)
					end
				end
				--
			end
		end
	end

	ResumePassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Drone Grid")
	grids_visible = true
end
local function HideGrids()
	SuspendPassEdits("ChoGGi.CursorBuilding.Done.Construction Show Drone Grid")
	local UICity = UICity
	HideHexRanges(UICity, "SupplyRocket")
	HideHexRanges(UICity, "DroneHub")
	HideHexRanges(UICity, "RCRover")
	if picard_active then
		HideHexRanges(UICity, "Elevator")
		HideHexRanges(UICity, "DroneHubExtender")
	end
	-- so far space race is only dlc that adds more commander rovers
	if g_AvailableDlc.gagarin then
		-- seekers/etc
		ClassDescendantsList("RCRover", function(name)
			HideHexRanges(UICity, name)
		end)
	end
	ResumePassEdits("ChoGGi.CursorBuilding.Done.Construction Show Drone Grid")
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

	SuspendPassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Drone Grid")
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if range.SetVisible and IsValid(obj) and IsKindOfClasses(obj, classes) then
			local is_site = obj:IsKindOf("ConstructionSite")
			if not is_site or (is_site and table.find(classes, obj.building_class)) then
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
	ResumePassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Drone Grid")

	return ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return ChoOrig_CursorBuilding_Done(...)
end

local function CleanList(list)
	for i = #(list or ""), 1, -1 do
		DoneObject(list[i])
		table.remove(list, i)
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
