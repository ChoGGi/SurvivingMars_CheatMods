-- See LICENSE for terms

local mod_EnableMod
local mod_SanityAmount

local function UpdateBuildings()
	local amount = 0
	if mod_EnableMod then
		amount = mod_SanityAmount
	end

	-- New buildings
	-- Not sure why it does both of them, but that's how SmartHome works
	-- sanity_increase happens on Colonist:Rest() while sanity_change happens from ServiceBase/StatsChangeBase:Service()
	ChoGGi_Funcs.Common.SetBuildingTemplates("Arcology", "sanity_change", amount)
	ChoGGi_Funcs.Common.SetBuildingTemplates("Arcology", "sanity_increase", amount)

	-- Existing buildings
	local objs = UIColony:GetCityLabels("Arcology")
	for i = 1, #objs do
		local obj = objs[i]
		obj.sanity_change = amount
		obj.sanity_increase = amount
	end

end

-- New games
OnMsg.CityStart = UpdateBuildings
-- Saved ones
OnMsg.LoadGame = UpdateBuildings

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_SanityAmount = CurrentModOptions:GetProperty("SanityAmount") * const.Scale.Stat

	if UIColony then
		UpdateBuildings()
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
