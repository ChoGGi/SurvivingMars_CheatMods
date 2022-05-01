-- See LICENSE for terms

local mod_PlaygroundPerk

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_PlaygroundPerk = CurrentModOptions:GetProperty("PlaygroundPerk")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function StartupCode()
	BuildingTemplates.HangingGardens.usable_by_children = true
	ClassTemplates.Building.HangingGardens.usable_by_children = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local ChoOrig_Service = Service.Service
function Service:Service(unit, ...)
	if mod_PlaygroundPerk and unit.age_trait == "Child" then
		unit.playground_visit = true
	end
	return ChoOrig_Service(self, unit, ...)
end

