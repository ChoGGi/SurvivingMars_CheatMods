-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local colony = UIColony
	if not colony then
		return
	end

	local options = CurrentModOptions
	local func = options:GetProperty("TechResearched") and colony.SetTechResearched or colony.SetTechDiscovered

	local TechDef = TechDef
	for id, item in pairs(TechDef) do
		if item.group ~= "Breakthroughs" then
			if options:GetProperty(id) then
				func(colony, id)
			end
		end
	end

end
OnMsg.ApplyModOptions = ModOptions

end

local function UpdateResearch()
	if CurrentModOptions:GetProperty("AlwaysApplyOptions") then
		ModOptions()
	end
end

OnMsg.ModsReloaded = UpdateResearch
OnMsg.CityStart = UpdateResearch
OnMsg.LoadGame = UpdateResearch
