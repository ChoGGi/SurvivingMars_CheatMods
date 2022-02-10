-- See LICENSE for terms

local mod_EnableMod

--~ function ChoGGi.ComFuncs.SetBuildingTemplates(template, key, value)
local function SetBuildingTemplates(template, key, value, bt, ct)
	if bt[template] then
		bt[template][key] = value
	end
	if ct[template] then
		ct[template][key] = value
	end
end

local function UnlockBuildings()
	if not mod_EnableMod then
		return
	end


	local ct = ClassTemplates.Building
	local bt = BuildingTemplates
	for id in pairs(bt) do
		SetBuildingTemplates(id, "disabled_in_environment1", "", bt, ct)
		SetBuildingTemplates(id, "disabled_in_environment2", "", bt, ct)
		SetBuildingTemplates(id, "disabled_in_environment3", "", bt, ct)
		SetBuildingTemplates(id, "disabled_in_environment4", "", bt, ct)
	end

	-- sigh
	local DisabledInEnvironment = DisabledInEnvironment
	for _, item in pairs(DisabledInEnvironment) do
		for i = 1, 4 do
			item[i] = ""
		end
	end

end
OnMsg.CityStart = UnlockBuildings
OnMsg.LoadGame = UnlockBuildings

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not UICity then
		return
	end

	UnlockBuildings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
