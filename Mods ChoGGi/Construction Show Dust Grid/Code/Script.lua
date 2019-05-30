-- See LICENSE for terms

local mod_id = "ChoGGi_ConstructionShowDustGrid"
local mod = Mods[mod_id]
local mod_Option1 = mod.options and mod.options.Option1 or true
local mod_DistFromCursor = (mod.options and mod.options.DistFromCursor or 0) * 1000

local function ModOptions()
	mod_Option1 = mod.options.Option1
	mod_DistFromCursor = mod.options.DistFromCursor * 1000
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

-- local some globals
local pairs = pairs
local HideHexRanges = HideHexRanges
local ShowBuildingHexes = ShowBuildingHexes
local GetTerrainCursor = GetTerrainCursor
local InvalidPos = InvalidPos()

local dust_gens = {}
local dust_gens_c = 0
-- just in case mods add custom dust buildings
function OnMsg.ModsReloaded()
	if dust_gens_c > 0 then
		return
	end

	local g_Classes = g_Classes
	local BuildingTemplates = BuildingTemplates

	for id in pairs(BuildingTemplates) do
		local o = g_Classes[id]
		-- dust gens and rockets, but not supply pods
		if o and o.GetDustRadius and not o:IsKindOf("SupplyPod") then
			dust_gens_c = dust_gens_c + 1
			dust_gens[dust_gens_c] = id
		end
	end
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	-- skip if disable or not a dusty building
	if not (mod_Option1 or self.template:IsKindOf("RequiresMaintenance")) then
		return orig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = GetTerrainCursor()
	local g_HexRanges = g_HexRanges

--~ ex(self)
--~ ex(dust_gens)
	local labels = UICity.labels

	for i = 1, dust_gens_c do
		local objs = labels[dust_gens[i]] or ""
		-- loop through them all and add the grid
		for j = 1, #objs do
			local obj = objs[j]
			local obj_pos = obj:GetPos()
			-- add hex to all buildings
			if obj_pos ~= InvalidPos and not g_HexRanges[obj] then
				ShowBuildingHexes(obj, "RangeHexMultiSelectRadius", "GetDustRadius")
			end
			-- change vis for any outside the range
			local range = g_HexRanges[obj]
			if range and range[1] then
				range = range[1]
				if range_limit and cursor_pos:Dist2D(obj_pos) > range_limit then
					range:SetVisible(false)
				else
					range:SetVisible(true)
					for k = 1, #range.decals do
						-- light yellow
						range.decals[k]:SetColorModifier(-2143)
					end
				end
			end

		end
	end

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done(...)
	local UICity = UICity
	for i = 1, dust_gens_c do
		HideHexRanges(UICity, dust_gens[i])
	end

	return orig_CursorBuilding_Done(self, ...)
end
