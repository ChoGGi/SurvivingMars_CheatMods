-- See LICENSE for terms

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

local add_time

-- could do newday, but that'll take a few hours to update, and this won't intruduce much of any lag
function OnMsg.NewHour(hour)
	if hour > 19 and UIColony.day > 2982 then
		add_time = true
	end
end
-- update on load
function OnMsg.LoadGame()
	if UIColony.day > 2982 and UIColony.hour > 19 then
		add_time = true
	end
end

-- There's other stuff to fix, but for now this will fix some of it
local ChoOrig_GameTime = GameTime
function GameTime()
	if not mod_EnableMod then
		return ChoOrig_GameTime()
	end

	local time = ChoOrig_GameTime()
	if add_time then
		-- 32bit signed int...
		time = time + 2147483647
	end

	return time
end
