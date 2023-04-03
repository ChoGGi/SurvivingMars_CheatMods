-- See LICENSE for terms

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	if CurrentModOptions:GetProperty("EnableMod") then
		DialogsHidingPauseDlg.HUD = true
	else
		DialogsHidingPauseDlg.HUD = nil
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
