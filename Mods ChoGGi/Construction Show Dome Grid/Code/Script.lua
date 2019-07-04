-- See LICENSE for terms

local options
local mod_Option1
local mod_DistFromCursor
local mod_GridOpacity
local mod_SelectDome
local mod_SelectOutside

-- fired when settings are changed/init
local function ModOptions()
	mod_Option1 = options.Option1
	mod_DistFromCursor = options.DistFromCursor * 1000
	mod_GridOpacity = options.GridOpacity
	mod_SelectDome = options.SelectDome
	mod_SelectOutside = options.SelectOutside
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_ConstructionShowDomeGrid" then
		return
	end

	ModOptions()
end

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local yellow = yellow

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	if mod_Option1 and self.template:IsKindOf("Dome") then
		ShowHexRanges(nil, "Dome")
	end
	return orig_CursorBuilding_GameInit(self, ...)
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if mod_Option1 and self.template:IsKindOf("Dome") then
		local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
		local cursor_pos = self:GetPos()

		local g_HexRanges = g_HexRanges
		for range, obj in pairs(g_HexRanges) do
			if IsKindOf(obj, "Dome") and range:IsKindOf("RangeHexMultiSelectRadius") then
				if range_limit and cursor_pos:Dist2D(obj:GetPos()) > range_limit then
					range:SetVisible(false)
				else
					range:SetVisible(true)
				end
			end
		end
	end

	return orig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideHexRanges(nil, "Dome")
	return orig_CursorBuilding_Done(...)
end

function OnMsg.SelectionAdded(obj)
	if not obj then
		return
	end

	if mod_SelectDome and obj:IsKindOf("Dome")
		or mod_SelectOutside and obj:IsKindOf("DomeOutskirtBld") and not obj:IsKindOf("StorageDepot")
	then
		-- needs a slight delay, or last selected dome will lose it's selection radius
		CreateRealTimeThread(ShowHexRanges, nil, "Dome")
	end
end

function OnMsg.SelectionRemoved()
	HideHexRanges(nil, "Dome")
end
