-- See LICENSE for terms

local mod_ToggleBushes
local mod_EnableVegetation

local function ToggleFunc(veg)
	SuspendPassEdits("ChoGGi.ToggleVisibleVegetation.ToggleTrees")
	for i = 1, #veg do
		veg[i]:SetVisible(mod_EnableVegetation)
	end
	ResumePassEdits("ChoGGi.ToggleVisibleVegetation.ToggleTrees")
end

local function ToggleTrees()
	-- get list of veg
	local veg = mod_ToggleBushes and MapGet("map", "VegetationBillboardObject")
		or MapGet("map", "VegetationTree_01", "VegetationTree_02", "VegetationTree_03", "VegetationTree_04")
	if #veg == 0 then
		return
	end

	-- don't toggle if already set
	if mod_EnableVegetation and not veg[1]:GetVisible() then
		ToggleFunc(veg)
	elseif not mod_EnableVegetation and veg[1]:GetVisible() then
		ToggleFunc(veg)
	end
end
OnMsg.CityStart = ToggleTrees
OnMsg.LoadGame = ToggleTrees

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ToggleBushes = CurrentModOptions:GetProperty("ToggleBushes")
	mod_EnableVegetation = CurrentModOptions:GetProperty("EnableVegetation")

	-- make sure we're in-game
	if not UICity then
		return
	end

	ToggleTrees()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
