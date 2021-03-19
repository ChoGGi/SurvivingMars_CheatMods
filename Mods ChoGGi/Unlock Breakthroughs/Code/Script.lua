-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions()

	local UICity = UICity
	if not UICity then
		return
	end

	local options = CurrentModOptions
	local func = options:GetProperty("BreakthroughsResearched") and UICity.SetTechResearched or UICity.SetTechDiscovered
	local bt = Presets.TechPreset.Breakthroughs
	for i = 1, #bt do
		local id = bt[i].id
		if options:GetProperty(id) then
			func(UICity, id)
		end
	end

end

local function UpdateBreakthroughs()
	if CurrentModOptions:GetProperty("AlwaysApplyOptions") then
		ModOptions()
	end
end

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.ModsReloaded = UpdateBreakthroughs
OnMsg.CityStart = UpdateBreakthroughs
OnMsg.LoadGame = UpdateBreakthroughs
