-- See LICENSE for terms

local mod_EnableMod
local mod_DisplayMsg

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DisplayMsg = CurrentModOptions:GetProperty("DisplayMsg")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end
	ChoGGi_Funcs.Common.DisastersStop()

	if mod_DisplayMsg then
		ChoGGi_Funcs.Common.MsgWait(
			T(0000, "Stopping any current disasters.<newline><newline>Timers will still show, but will disappear after countdown."),
			T(0000, "Stop Current Disasters")
		)
	end

end
