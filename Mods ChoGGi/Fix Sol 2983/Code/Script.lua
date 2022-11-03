-- See LICENSE for terms

-- 2147483647 is 2982 Sols 14h, but for some reason GameTime() doesn't reach it till 2983 20h
-- Can't be bothered to find out why...

-- Used below to check for overflow (we want it below 2981 since that's when I start testing)
local min_time = 2980 * const.Scale.sols
-- 2147483647 * 2
local max_int2 = max_int * 2
-- When true add max_int2 time
local add_time = false

-- Considering how much this func is called... keep it simple (stupid.gif)
local ChoOrig_GameTime = GameTime
function GameTime()
	if add_time then
		return ChoOrig_GameTime() + max_int2
	end

	return ChoOrig_GameTime()
end

-- Could do NewDay, but that'll take a few hours to update, and this won't take any noticeable cpu
function OnMsg.NewHour()
	if not add_time and UIColony.day > 2981 and min_time > ChoOrig_GameTime() then
		add_time = true
	end
end

-- Update on load instead of waiting for NewHour
function OnMsg.LoadGame()
	-- If loading another save
	add_time = false
	-- Check time
	if UIColony.day > 2981 and min_time > ChoOrig_GameTime() then
		add_time = true
	end
end
