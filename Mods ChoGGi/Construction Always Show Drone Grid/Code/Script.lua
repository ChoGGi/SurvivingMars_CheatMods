
-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
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
	local UICity = UICity
	ShowHexRanges(UICity, "SupplyRocket")
	ShowHexRanges(UICity, "DroneHub")
	ShowHexRanges(UICity, "RCRover", nil, "GetSelectionRadiusScale_OverrideChoGGi")

	-- change colours
	for range,obj in pairs(g_HexRanges) do
		if IsKindOf(obj,"SupplyRocket") then
			for i = 1, #range.decals do
				range.decals[i]:SetColorModifier(green)
			end
		elseif IsKindOf(obj,"RCRover") then
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
