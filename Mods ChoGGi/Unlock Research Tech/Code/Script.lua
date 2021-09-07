-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local UIColony = UIColony
	if not UIColony then
		return
	end

	local options = CurrentModOptions
	local func = options:GetProperty("TechResearched") and UIColony.SetTechResearched or UIColony.SetTechDiscovered

	local TechDef = TechDef
	for id, item in pairs(TechDef) do
		if item.group ~= "Breakthroughs" then
			if options:GetProperty(id) then
				func(UIColony, id)
			end
		end
	end

end
OnMsg.ApplyModOptions = ModOptions

local function UpdateResearch()
	if CurrentModOptions:GetProperty("AlwaysApplyOptions") then
		ModOptions()
	end
end

OnMsg.ModsReloaded = UpdateResearch
OnMsg.CityStart = UpdateResearch
OnMsg.LoadGame = UpdateResearch
