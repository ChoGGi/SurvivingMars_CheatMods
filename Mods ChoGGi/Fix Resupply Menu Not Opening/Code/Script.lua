-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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
