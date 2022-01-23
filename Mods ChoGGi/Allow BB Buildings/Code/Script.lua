-- See LICENSE for terms

local mod_EnableMod

--~ function ChoGGi.ComFuncs.SetBuildingTemplates(template, key, value)
local function SetBuildingTemplates(template, key, value, bt, ct)
	bt[template][key] = value
	ct[template][key] = value
end

local function UnlockBuildings()
	if not mod_EnableMod then
		return
	end

	local ct = ClassTemplates.Building
	local bt = BuildingTemplates
	for _, template in pairs(bt) do
		SetBuildingTemplates(template, "disabled_in_environment1", "", bt, ct)
		SetBuildingTemplates(template, "disabled_in_environment2", "", bt, ct)
		SetBuildingTemplates(template, "disabled_in_environment3", "", bt, ct)
		SetBuildingTemplates(template, "disabled_in_environment4", "", bt, ct)
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

	-- make sure we're in-game
	if not UICity then
		return
	end

	UnlockBuildings()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
