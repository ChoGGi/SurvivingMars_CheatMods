-- See LICENSE for terms

local mod_id = "ChoGGi_ConstructionShowDustGrid"
local mod = Mods[mod_id]
local mod_Option1 = mod.options and mod.options.Option1 or true

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_Option1 = mod.options.Option1
end

-- local whatever globals we call
local HideHexRanges = HideHexRanges
local CleanupHexRanges = CleanupHexRanges
local PlaceObject = PlaceObject
local table_insert = table.insert

local dust_gens = {}
local c = 0
-- just in case mods add custom dust buildings
function OnMsg.ModsReloaded()
	local g_Classes = g_Classes
  local BuildingTemplates = BuildingTemplates

	for id in pairs(BuildingTemplates) do
		local o = g_Classes[id]
		if o and o:IsKindOf("DustGenerator") then
			c = c + 1
			dust_gens[c] = id
		end
	end
end

-- copy n paste from Lua\UI\InGameInterface.lua (pretty much)
local function ShowBuildingHexes(bld)
	if bld:IsValidPos() and not bld.destroyed then
		local g_HexRanges = g_HexRanges

		CleanupHexRanges(bld, "GetDustRadius")
		local obj = PlaceObject("RangeHexMultiSelectRadius")
		obj:SetPos(bld:GetPos():SetStepZ()) -- avoid attaching it in air in case of landing rockets
		g_HexRanges[bld] = g_HexRanges[bld] or {}
		table_insert(g_HexRanges[bld], obj)
		g_HexRanges[obj] = bld
		obj.bind_to = "GetDustRadius"
		obj:SetScale(bld:GetDustRadius())
		for i = 1, #obj.decals do
			obj.decals[i]:SetColorModifier(16775073, 1500)
		end
	end
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(self)
	end
--~ ex(dust_gens)
	local labels = UICity.labels

	local rockets = labels.SupplyRocket or ""
	for i = 1, #rockets do
		ShowBuildingHexes(rockets[i])
	end

	for i = 1, #dust_gens do
		local cls = labels[dust_gens[i]] or ""
		for j = 1, #cls do
			ShowBuildingHexes(cls[j])
		end
	end

	return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()
	local UICity = UICity
	HideHexRanges(UICity, "SupplyRocket")
	for i = 1, #dust_gens do
		HideHexRanges(UICity, dust_gens[i])
	end

	return orig_CursorBuilding_Done(self)
end
