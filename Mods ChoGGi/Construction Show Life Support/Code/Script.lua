-- See LICENSE for terms


-- local whatever globals we call
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local SetObjWaterMarkers = SetObjWaterMarkers

local hexes_visible
local temp_list
local temp_list_c = 0

local options
local mod_EnableMod
local mod_DistFromCursor
local mod_HexOpacity

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_DistFromCursor = options:GetProperty("DistFromCursor") * 1000
	mod_HexOpacity = options:GetProperty("HexOpacity")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function HideHexes(skip)
	if not skip then
		SuspendPassEdits("ChoGGi.CursorBuilding.Done.Construction Show Life Support")
	end

	for i = 1, temp_list_c do
		SetObjWaterMarkers(temp_list[i], false)
	end

	if not skip then
		ResumePassEdits("ChoGGi.CursorBuilding.Done.Construction Show Life Support")
	end
	hexes_visible = false
end

local function ShowHexes()
	SuspendPassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Life Support")

	-- skip pipes and any buildings in domes
	temp_list = MapGet("map", "LifeSupportGridObject", function(o)
		if not o:IsKindOf("LifeSupportGridElement") and not o.parent_dome then
			return true
		end
	end)

	temp_list_c = #temp_list
	for i = 1, temp_list_c do
		local building = temp_list[i]
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

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	orig_CursorBuilding_GameInit(...)
	if mod_EnableMod then
		ShowHexes()
	end
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if not mod_EnableMod then
		return orig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

	SuspendPassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Life Support")

	-- set visible
	for i = 1, temp_list_c do
		local building = temp_list[i]
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

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideHexes()
	return orig_CursorBuilding_Done(...)
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
