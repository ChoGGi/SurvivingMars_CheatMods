-- See LICENSE for terms

local mod_EnableMod

local function UnlockBuildings()
	if not mod_EnableMod then
		return
	end

	local BuildingTemplates = BuildingTemplates
	for _, template in pairs(BuildingTemplates) do
		template.disabled_in_environment1 = ""
		template.disabled_in_environment2 = ""
		template.disabled_in_environment3 = ""
		template.disabled_in_environment4 = ""
	end

end

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


OnMsg.CityStart = UnlockBuildings
OnMsg.LoadGame = UnlockBuildings
