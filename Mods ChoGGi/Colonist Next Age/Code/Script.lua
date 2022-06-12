-- See LICENSE for terms

local pairs = pairs

local mod_options = {}

local ColonistAgeGroups = const.ColonistAgeGroups
for id in pairs(ColonistAgeGroups) do
	mod_options[id] = 0
end

local mod_EnableMod
local mod_ChangeDeathAge
local mod_MinDeathAge
local mod_MaxDeathAge

local function UpdateAges()
	if not mod_EnableMod then
		return
	end

	-- new colonists
	for id in pairs(mod_options) do
		Colonist["MinAge_" .. id] = mod_options[id]
	end

	local objs = UIColony:GetCityLabels("Colonist")
	for i = 1, #objs do
		local obj = objs[i]

		if mod_ChangeDeathAge then
			if mod_MinDeathAge == 0 and mod_MaxDeathAge == 0 then
				-- function Colonist:GameInit()
				obj:SetBase("death_age", obj.MinAge_Senior + 5 + obj:Random(10) + obj:Random(5) + obj:Random(5))
			else
				-- max > min is probably a bad idea
				if mod_MinDeathAge > mod_MaxDeathAge then
					mod_MaxDeathAge = mod_MinDeathAge + 1
				end
				obj:SetBase("death_age", obj:Random(mod_MinDeathAge, mod_MaxDeathAge))
			end
		end

		for id in pairs(mod_options) do
			obj["MinAge_" .. id] = mod_options[id]
		end
	end
end
OnMsg.CityStart = UpdateAges
OnMsg.LoadGame = UpdateAges

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_ChangeDeathAge = options:GetProperty("ChangeDeathAge")
	mod_MinDeathAge = options:GetProperty("MinDeathAge")
	mod_MaxDeathAge = options:GetProperty("MaxDeathAge")

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateAges()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

