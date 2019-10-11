-- See LICENSE for terms

local options
local mod_PlaygroundPerk

-- fired when settings are changed/init
local function ModOptions()
	mod_PlaygroundPerk = options.PlaygroundPerk
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local function StartupCode()
	BuildingTemplates.HangingGardens.usable_by_children = true
	ClassTemplates.Building.HangingGardens.usable_by_children = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local orig_Service = Service.Service
function Service:Service(unit, ...)
	if mod_PlaygroundPerk and unit.age_trait == "Child" then
		unit.playground_visit = true
	end
	return orig_Service(self, unit, ...)
end

