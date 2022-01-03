-- See LICENSE for terms

-- 2147483647 is 2982 Sols 14h, but for some reason GameTime() doesn't reach it till 2983 20h
-- can't be bothered to find out why...

-- used below to check for rollover
local min_time = 2980 * const.Scale.sols
-- 2147483647
local max_int = max_int

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- when true add max_int time
local add_time

-- There's other stuff to fix, but for now this will fix most of it
local ChoOrig_GameTime = GameTime
function GameTime()
	if not mod_EnableMod or not add_time then
		return ChoOrig_GameTime()
	end
	return ChoOrig_GameTime() + max_int
end


local function TestTime()
	if UIColony.day > 2981 and min_time > ChoOrig_GameTime() then
		add_time = true
	end
end

-- could do NewDay, but that'll take a few hours to update, and this won't take any noticeable cpu
OnMsg.NewHour = TestTime
-- update on load instead of waiting for NewHour
OnMsg.LoadGame = TestTime
