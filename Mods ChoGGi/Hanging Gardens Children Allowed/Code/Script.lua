-- See LICENSE for terms

local function StartupCode()
	BuildingTemplates.HangingGardens.usable_by_children = true
	ClassTemplates.Building.HangingGardens.usable_by_children = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
