-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod
		-- Not much point if it isn't the right mystery
		or UIColony.mystery_id ~= "MarsgateMystery"
	then
		return
	end

	local registers = UIColony.mystery.seq_player.registers
	-- What the game checks for
	if registers._malfunctions
		and registers._malfunctions > 1
	then
		UIColony.mystery.enable_rover_repair = true
	end

end

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
