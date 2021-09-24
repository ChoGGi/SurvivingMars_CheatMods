-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function StartupCode()
	if not mod_EnableMod then
		return
	end

 local templates = BuildingTemplates
 for _, template in pairs(templates) do
		template.dome_forbidden = false
 end
 local templates = ClassTemplates.Building
 for _, template in pairs(templates) do
		template.dome_forbidden = false
 end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
