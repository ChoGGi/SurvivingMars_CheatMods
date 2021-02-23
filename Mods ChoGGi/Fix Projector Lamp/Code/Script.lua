-- See LICENSE for terms

local function StartupCode()
	local bt = BuildingTemplates
	bt.LampProjector.build_category = "Outside Decorations"
	bt.LampProjector.group = "Outside Decorations"
	bt.LampProjector.label1 = ""
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
