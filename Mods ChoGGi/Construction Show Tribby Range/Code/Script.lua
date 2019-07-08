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
	if id ~= "ChoGGi_ConstructionShowTribbyRange" then
		return
	end

	ModOptions()
end

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local purple = purple

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if not mod_Option1 then
		return orig_CursorBuilding_GameInit(...)
	end

	ShowHexRanges(UICity, "TriboelectricScrubber")

	-- change colour
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOf(obj, "TriboelectricScrubber") then
			if IsKindOf(range, "RangeHexMultiSelectRadius") then
				range:SetOpacity(mod_GridOpacity)
			end

			if IsKindOf(obj, "TriboelectricScrubber") then
				for i = 1, #range.decals do
					range.decals[i]:SetColorModifier(purple)
				end
			end
		end
	end

	return orig_CursorBuilding_GameInit(...)
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if mod_Option1 then
		local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
		local cursor_pos = self:GetPos()

		local g_HexRanges = g_HexRanges
		for range, obj in pairs(g_HexRanges) do
			if IsKindOf(obj, "TriboelectricScrubber") and range:IsKindOf("RangeHexMultiSelectRadius") then
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
	HideHexRanges(UICity, "TriboelectricScrubber")
	return orig_CursorBuilding_Done(...)
end
