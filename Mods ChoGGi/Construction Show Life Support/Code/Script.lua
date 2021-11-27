-- See LICENSE for terms

local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local SetObjWaterMarkers = SetObjWaterMarkers
local MapGet = MapGet
local table = table

local hexes_visible
local life_support
local life_support_c = 0

local mod_EnableMod
local mod_DistFromCursor
local mod_HexOpacity

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_DistFromCursor = options:GetProperty("DistFromCursor") * 1000
	mod_HexOpacity = options:GetProperty("HexOpacity")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function HideHexes(skip)
	if not skip then
		SuspendPassEdits("ChoGGi.CursorBuilding.Done.Construction Show Life Support")
	end

	for i = 1, life_support_c do
		SetObjWaterMarkers(life_support[i], false)
	end

	if not skip then
		ResumePassEdits("ChoGGi.CursorBuilding.Done.Construction Show Life Support")
	end
	hexes_visible = false
end

local function ShowHexes()
	SuspendPassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Life Support")

	-- skip pipes and any buildings in domes
	life_support = MapGet("map", "LifeSupportGridObject", function(o)
		if not o:IsKindOf("LifeSupportGridElement") and not o.parent_dome then
			return true
		end
	end)
	local temp_list = MapGet("map", "ConstructionSite", function(o)
		if o.building_class_proto and not o.parent_dome
			and o.building_class_proto:IsKindOf("LifeSupportGridObject")
		then
			return true
		end
	end)
	table.iappend(life_support, temp_list)

	life_support_c = #life_support
	for i = 1, life_support_c do
		local building = life_support[i]
		-- show hexes
		SetObjWaterMarkers(building, true)
		-- set opacity
		building:ForEachAttach("GridTileWater", function(marker)
			marker:SetOpacity(mod_HexOpacity)
		end)
	end

	ResumePassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Life Support")
	hexes_visible = true
end

local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	ChoOrig_CursorBuilding_GameInit(...)
	if mod_EnableMod then
		ShowHexes()
	end
end

local ChoOrig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if not mod_EnableMod then
		return ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

	SuspendPassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Life Support")

	-- set visible
	for i = 1, life_support_c do
		local building = life_support[i]
		local visible = true
		if range_limit and cursor_pos:Dist2D(building:GetPos()) > range_limit then
			visible = false
		end
		building:ForEachAttach("GridTileWater", function(marker)
			if marker:GetVisible() ~= visible then
				marker:SetVisible(visible)
			end
		end)
	end

	ResumePassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Life Support")

	return ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideHexes()
	return ChoOrig_CursorBuilding_Done(...)
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011722, "Construction Show Life Support"),
	ActionId = "ChoGGi.ConstructionShowLifeSupport.ToggleHex",
	OnAction = function()
		if hexes_visible then
			HideHexes()
		else
			ShowHexes()
		end
	end,
	ActionShortcut = "Numpad 9",
	replace_matching_id = true,
	ActionBindable = true,
}
