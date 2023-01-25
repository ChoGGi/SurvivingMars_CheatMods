-- See LICENSE for terms

local mod_Shift1
local mod_Shift2
local mod_Shift3

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Shift1 = CurrentModOptions:GetProperty("Shift1")
	mod_Shift2 = CurrentModOptions:GetProperty("Shift2")
	mod_Shift3 = CurrentModOptions:GetProperty("Shift3")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function pause()
	UIColony:SetGameSpeed(0)
	UISpeedState = "pause"
end

function OnMsg.NewWorkshift(workshift)
	if mod_Shift1 and workshift == 1 then
		pause()
	elseif mod_Shift2 and workshift == 2 then
		pause()
	elseif mod_Shift3 and workshift == 3 then
		pause()
	end
end
