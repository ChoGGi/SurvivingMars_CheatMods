-- See LICENSE for terms

local dust_gens = {}
local dust_gens_c = 0

-- local some globals
local pairs = pairs
local table_find = table.find
local table_remove = table.remove
local CleanupHexRanges = CleanupHexRanges
local HideHexRanges = HideHexRanges
local ShowBuildingHexes = ShowBuildingHexes
local DoneObject = DoneObject
local IsKindOfClasses = IsKindOfClasses
local IsKindOf = IsKindOf
local InvalidPos = InvalidPos()

-- mod options
local options
local mod_Option1
local mod_DistFromCursor
local mod_ShowConSites
local mod_GridOpacity

local function CleanList(list)
	local ranges = list or ""
	for i = #ranges, 1, -1 do
		DoneObject(ranges[i])
		table_remove(ranges, i)
	end
end

local function ModOptions()
	mod_Option1 = options.Option1
	mod_DistFromCursor = options.DistFromCursor * 1000
	mod_ShowConSites = options.ShowConSites
	mod_GridOpacity = options.GridOpacity

	local idx = table_find(dust_gens, "ConstructionSite")
	if mod_ShowConSites and not idx then
		dust_gens_c = dust_gens_c + 1
		dust_gens[dust_gens_c] = "ConstructionSite"
	elseif not mod_ShowConSites and idx then
		dust_gens_c = dust_gens_c - 1
		table_remove(dust_gens, idx)
	end
end

local RangeHexMultiSelectRadius_cls

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()

	-- build dust list in ModsReloaded for modded buildings
	-- modoptions fires first and may add ConstructionSite
	if dust_gens_c < 2 then
		RangeHexMultiSelectRadius_cls = RangeHexMultiSelectRadius

		local g_Classes = g_Classes

		local BuildingTemplates = BuildingTemplates
		for id in pairs(BuildingTemplates) do
			local o = g_Classes[id]
			-- dust gens and rockets, but not supply pods
			if o and o.GetDustRadius and not o:IsKindOf("SupplyRocket") then
				dust_gens_c = dust_gens_c + 1
				dust_gens[dust_gens_c] = id
			end
		end
		-- no need to add all the diff rockets, just the base class'll do
		dust_gens_c = dust_gens_c + 1
		dust_gens[dust_gens_c] = "SupplyRocket"
		dust_gens_c = dust_gens_c + 1
		dust_gens[dust_gens_c] = "SupplyRocketBuilding"
	end
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_ConstructionShowDustGrid" then
		return
	end

	ModOptions()
end

local function ShowBuildingHexesSite(bld)
	if not bld.destroyed then
		local g_HexRanges = g_HexRanges
		CleanupHexRanges(bld)
		local obj = RangeHexMultiSelectRadius_cls:new()
--~ 		obj:SetOpacity(mod_GridOpacity)

		-- the site is the res pile, we want the rocket pos
		local bld_pos
		local rock_site = bld.building_class_proto:IsKindOf("SupplyRocketBuilding")
		if rock_site then
			local a = bld:GetAttaches("Shapeshifter")
			if a and a[1] then
				bld_pos = a[1]:GetPos()
			else
				bld_pos = bld:GetPos()
			end
		else
			bld_pos = bld:GetPos()
		end

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
				obj:SetScale(SupplyRocket:GetDustRadius())
			end
		end
	end
end

-- add grid hexes
local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(...)
	end

	local labels = UICity.labels
	for i = 1, dust_gens_c do
		local objs = labels[dust_gens[i]] or ""
		-- loop through them all and add the grid
		for j = 1, #objs do
			local obj = objs[j]
			local obj_pos = obj:GetPos()
			-- add hex to all buildings
			if obj_pos ~= InvalidPos and not g_HexRanges[obj] then
				if obj:IsKindOf("ConstructionSite") then
					if table_find(dust_gens, obj.building_class) then
						ShowBuildingHexesSite(obj)
					end
				else
					ShowBuildingHexes(obj, "RangeHexMultiSelectRadius", "GetDustRadius")
				end
			end
		end
	end

	-- change colour
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOfClasses(obj, dust_gens) then
			if IsKindOf(range, "RangeHexMultiSelectRadius") then
				range:SetOpacity(mod_GridOpacity)
			end

			if obj:IsKindOf("ConstructionSite") then
				for i = 1, #range.decals do
					range.decals[i]:SetColorModifier(-2143)
				end
			else
				for i = 1, #range.decals do
					range.decals[i]:SetColorModifier(-5576)
				end
			end

		end
	end


	return orig_CursorBuilding_GameInit(...)
end

-- update visibility
local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	-- skip if disabled or not a RequiresMaintenance building
	if not (mod_Option1 or self.template:IsKindOf("RequiresMaintenance")) then
		return orig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()
	local g_HexRanges = g_HexRanges

--~ ex(self)
--~ ex(dust_gens)
	local labels = UICity.labels

--~ 	local g_HexRanges = g_HexRanges
--~ 	for range, obj in pairs(g_HexRanges) do
--~ 		if IsKindOfClasses(obj, dust_gens) then
--~ 		end
--~ 	end
	-- replace with above ranges stuff

	for i = 1, dust_gens_c do
		local objs = labels[dust_gens[i]] or ""
		-- loop through them all and add the grid
		for j = 1, #objs do
			local obj = objs[j]
			-- change vis for any outside the range
			local is_site = obj:IsKindOf("ConstructionSite")
			if not is_site or is_site and obj.building_class_proto.GetDustRadius then
				local range = g_HexRanges[obj]
				if range and range[1] and range[1].decals then
					if range_limit and cursor_pos:Dist2D(obj:GetPos()) > range_limit then
						range[1]:SetVisible(false)
					else
						range[1]:SetVisible(true)
					end
				end
			end

		end
	end

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	local UICity = UICity
	for i = 1, dust_gens_c do
		HideHexRanges(UICity, dust_gens[i])
	end

	-- any ConstructionSite finished while grids up
	local g_HexRanges = g_HexRanges
	for obj1, obj2 in pairs(g_HexRanges) do
		if not IsValid(obj1) then
			CleanList(obj2)
			g_HexRanges[obj1] = nil
		end
	end

	return orig_CursorBuilding_Done(...)
end
