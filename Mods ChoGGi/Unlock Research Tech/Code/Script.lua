-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions()

	local UICity = UICity
	if not UICity then
		return
	end

	local options = CurrentModOptions
	local func = options:GetProperty("TechResearched") and UICity.SetTechResearched or UICity.SetTechDiscovered

	local TechDef = TechDef
	for id, item in pairs(TechDef) do
		if item.group ~= "Breakthroughs" then
			if options:GetProperty(id) then
				func(UICity, id)
			end
		end
	end

end

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function UpdateResearch()
	if CurrentModOptions:GetProperty("AlwaysApplyOptions") then
		ModOptions()
	end
end

OnMsg.ModsReloaded = UpdateResearch
OnMsg.CityStart = UpdateResearch
OnMsg.LoadGame = UpdateResearch
