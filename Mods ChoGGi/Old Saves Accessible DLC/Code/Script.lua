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


local function StartupCode()
	if not mod_EnableMod then
		return
	end

	for id in pairs(g_AvailableDlc) do
		g_AccessibleDlc[id] = true
	end

end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
