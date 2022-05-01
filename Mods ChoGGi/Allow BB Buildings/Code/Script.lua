-- See LICENSE for terms

local mod_EnableMod

--~ function ChoGGi.ComFuncs.SetBuildingTemplates(template, key, value)
local function SetBuildingTemplates(template, bt, ct)
	bt = bt[template]
	if bt then
		bt.disabled_in_environment1 = ""
		bt.disabled_in_environment2 = ""
		bt.disabled_in_environment3 = ""
		bt.disabled_in_environment4 = ""
		ct = ct[template]
		ct.disabled_in_environment1 = ""
		ct.disabled_in_environment2 = ""
		ct.disabled_in_environment3 = ""
		ct.disabled_in_environment4 = ""
	end
end

local function UnlockBuildings()
	if not mod_EnableMod then
		return
	end

	local die = DisabledInEnvironment
	local blank_die = {"","","",""}

	local ct = ClassTemplates.Building
	local bt = BuildingTemplates
	for id in pairs(bt) do
		SetBuildingTemplates(id, bt, ct)
		die[id] = blank_die
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
	if not UIColony then
		return
	end

	UnlockBuildings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
