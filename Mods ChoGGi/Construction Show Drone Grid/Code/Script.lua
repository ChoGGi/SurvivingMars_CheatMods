-- See LICENSE for terms

local mod_id = "ChoGGi_ConstructionShowDroneGrid"
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
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local green = green
local yellow = yellow

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
