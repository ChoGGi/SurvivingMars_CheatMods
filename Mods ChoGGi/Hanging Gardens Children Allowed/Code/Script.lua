-- See LICENSE for terms

local mod_PlaygroundPerk

-- fired when settings are changed/init
local function ModOptions()
	mod_PlaygroundPerk = CurrentModOptions:GetProperty("PlaygroundPerk")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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

