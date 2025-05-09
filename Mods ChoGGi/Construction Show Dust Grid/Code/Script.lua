-- See LICENSE for terms

-- local some globals
local table, pairs = table, pairs
local CleanupHexRanges = CleanupHexRanges
local HideHexRanges = HideHexRanges
local ShowBuildingHexes = ShowBuildingHexes
local DoneObject = DoneObject
local IsKindOfClasses = IsKindOfClasses
local IsKindOf = IsKindOf
local IsValid = IsValid
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local HexGridGetObjects = HexGridGetObjects
local WorldToHex = WorldToHex
local InvalidPos = InvalidPos()

local RGBtoColour = ChoGGi.ComFuncs.RGBtoColour
local RangeHexMultiSelectRadius_cls

local mod_EnableGrid
local mod_DistFromCursor
local mod_ShowConSites
local mod_GridOpacity
local mod_GridScale
local mod_HexColour

local classes = {}
local classes_c = 0

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableGrid = options:GetProperty("Option1")
	mod_DistFromCursor = options:GetProperty("DistFromCursor") * 1000
	mod_ShowConSites = options:GetProperty("ShowConSites")
	mod_GridOpacity = options:GetProperty("GridOpacity")
	mod_GridScale = options:GetProperty("GridScale")

	mod_HexColour = RGBtoColour(options:GetProperty("HexColour"))

	local idx = table.find(classes, "ConstructionSite")
	if mod_ShowConSites and not idx then
		classes_c = classes_c + 1
		classes[classes_c] = "ConstructionSite"
	elseif not mod_ShowConSites and idx then
		table.remove(classes, idx)
		classes_c = #classes
	end

	-- build dust list in ModsReloaded for modded buildings
	-- modoptions fires first and may add ConstructionSite
	if classes_c < 2 then
		RangeHexMultiSelectRadius_cls = RangeHexMultiSelectRadius

		local g_Classes = g_Classes

		local skip_pods = {
			ArkPod = true,
			DropPod = true,
			SupplyPod = true,
		}
		-- dust gens and rockets, but not supply pods
		local BuildingTemplates = BuildingTemplates
		for id in pairs(BuildingTemplates) do
			local o = g_Classes[id]
			if o and o.GetDustRadius and not skip_pods[o.class] then
				classes_c = classes_c + 1
				classes[classes_c] = id
			end
		end
		-- custom
		classes_c = classes_c + 1
		classes[classes_c] = "LanderRocketBase"
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function ShowBuildingHexesSite(bld, is_rocket)
	if not bld.destroyed then
		local g_HexRanges = g_HexRanges
		CleanupHexRanges(bld)
		local obj = RangeHexMultiSelectRadius_cls:new()

		-- the site is the res pile, we want the rocket pos
		local bld_pos
		if is_rocket then
			local a = bld:GetAttaches("Shapeshifter")
			if a and a[1] then
				bld_pos = a[1]:GetPos()
			end
		end
		bld_pos = bld_pos or bld:GetPos()

		obj:SetPos(bld_pos:SetStepZ()) -- avoid attaching it in air in case of landing rockets
		g_HexRanges[bld] = g_HexRanges[bld] or {}
		local range = g_HexRanges[bld]
		range[#range+1] = obj
		g_HexRanges[obj] = bld
		obj.bind_to = "GetDustRadius"
		if bld.building_class_proto.GetDustRadius then
			obj:SetScale(bld.building_class_proto:GetDustRadius())
		else
			local g_c = g_Classes
			local radius = g_c[bld.building_class] and g_c[bld.building_class].GetDustRadius
			if radius then
				obj:SetScale(radius(bld))
			else
				-- SupplyRocketBuilding
				obj:SetScale(RocketBase:GetDustRadius())
			end
		end
	end
end

local grids_visible

local function ShowGrids()
	SuspendPassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Dust Grid")

	local ObjectGrid = ActiveGameMap.object_hex_grid.grid
	local labels = UICity.labels
	for i = 1, classes_c do
		local objs = labels[classes[i]] or ""
		-- loop through them all and add the grid
		for j = 1, #objs do
			local obj = objs[j]
			-- add hex to all buildings
			local range = g_HexRanges[obj]
			if obj:GetPos() ~= InvalidPos and
				(not range or range and range.bind_to ~= "GetDustRadius")
			then

				if obj:IsKindOf("ConstructionSite") then
					-- skip showing dust for rockets on pads
					local is_rocket = obj.building_class_proto:IsKindOf("SupplyRocketBuilding")
					local landing_site
					if is_rocket then
						local q, r = WorldToHex(obj:GetPos())
						local objs = HexGridGetObjects(ObjectGrid, q, r)
						-- only actual rockets have a .landing_site so we need to check the obj grid for a pad
						for k = 1, #objs do
							if objs[k]:IsKindOf("LandingPad") then
								landing_site = IsValid(objs[k])
								break
							end
						end
					end

					if table.find(classes, obj.building_class) and
						(not is_rocket or is_rocket and not landing_site)
					then
						ShowBuildingHexesSite(obj, is_rocket)
					end
				else
					local is_rocket = obj:IsKindOf("RocketBase")
					if not is_rocket
						or is_rocket and not IsValid(obj.landing_site.landing_pad)
					then
						ShowBuildingHexes(obj, "RangeHexMultiSelectRadius", "GetDustRadius")
					end
				end
			end
		end
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
				-- If other range mods are installed we don't want them red as well
				if range.bind_to == "GetDustRadius" then
					for i = 1, #range.decals do
						local decal = range.decals[i]
						decal:SetColorModifier(mod_HexColour)
						decal:SetScale(mod_GridScale)
					end
				end
			end
		end
	end

	ResumePassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Dust Grid")
	grids_visible = true
end

local function HideGrids()
	SuspendPassEdits("ChoGGi.CursorBuilding.Done.Construction Show Dust Grid")

	local UICity = UICity
	for i = 1, classes_c do
		HideHexRanges(UICity, classes[i])
	end

	-- any ConstructionSite finished while grids up
	local g_HexRanges = g_HexRanges
	for obj1, obj2 in pairs(g_HexRanges) do
		if not IsValid(obj1) then
			for i = #(obj2 or ""), 1, -1 do
				DoneObject(obj2[i])
				table.remove(obj2, i)
			end
			g_HexRanges[obj1] = nil
		end
	end

	ResumePassEdits("ChoGGi.CursorBuilding.Done.Construction Show Dust Grid")
	grids_visible = false
end

-- add grid hexes
local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	orig_CursorBuilding_GameInit(...)
	if mod_EnableGrid then
		ShowGrids()
	end
end

-- update visibility
local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if not (mod_EnableGrid or self.template:IsKindOf("RequiresMaintenance")) then
		return orig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

--~ ex(self)
--~ ex(classes)

	SuspendPassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Dust Grid")
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if range.SetVisible and range.bind_to == "GetDustRadius"
			and IsValid(obj) and IsKindOfClasses(obj, classes)
		then
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
	ResumePassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Dust Grid")

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return orig_CursorBuilding_Done(...)
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011585, "Construction Show Dust Range"),
	ActionId = "ChoGGi.ConstructionShowDustGrid.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 2",
	replace_matching_id = true,
	ActionBindable = true,
}
