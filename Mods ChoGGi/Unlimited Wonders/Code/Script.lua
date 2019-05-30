-- See LICENSE for terms

local function StartupCode()
	local BuildingTemplates = BuildingTemplates
	for _, bld in pairs(BuildingTemplates) do
		bld.wonder = nil
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
