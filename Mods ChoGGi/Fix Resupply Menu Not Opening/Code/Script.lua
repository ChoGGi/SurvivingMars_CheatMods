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

	local defs = ResupplyItemDefinitions
	for i = #defs, 1, -1 do
		local def = defs[i]
		if not def.pack then
			print("Fix Resupply Menu Not Opening Borked cargo:", def.id)
			table.remove(defs, i)
		end
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
