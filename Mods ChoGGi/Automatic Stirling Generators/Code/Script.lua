-- See LICENSE for terms

local mod_EnableMod
local mod_Shift1
local mod_Shift2
local mod_Shift3

local function UpdateBuildings(class, toggle)
	local blds = UIColony:GetCityLabels(class)
	for i = 1, #blds do
		blds[i]:SetOpenState(toggle)
	end
end

local function UpdateStirlings()
	if not mod_EnableMod then
		return
	end

	if CurrentWorkshift == 1 then
		UpdateBuildings("StirlingGenerator", mod_Shift1)
		UpdateBuildings("AdvancedStirlingGenerator", mod_Shift1)
	elseif CurrentWorkshift == 2 then
		UpdateBuildings("StirlingGenerator", mod_Shift2)
		UpdateBuildings("AdvancedStirlingGenerator", mod_Shift2)
	elseif CurrentWorkshift == 3 then
		UpdateBuildings("StirlingGenerator", mod_Shift3)
		UpdateBuildings("AdvancedStirlingGenerator", mod_Shift3)
	end

end

-- New games
OnMsg.CityStart = UpdateStirlings
-- Saved ones
OnMsg.LoadGame = UpdateStirlings
-- Work shift changed
OnMsg.NewWorkshift = UpdateStirlings

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_Shift1 = options:GetProperty("Shift1")
	mod_Shift2 = options:GetProperty("Shift2")
	mod_Shift3 = options:GetProperty("Shift3")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateStirlings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
