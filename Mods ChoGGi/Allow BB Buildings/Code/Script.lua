-- See LICENSE for terms

local mod_options = {}

-- build options list
local BuildingTemplates = BuildingTemplates
for id, item in pairs(BuildingTemplates) do
	if item.display_icon ~= ""
		and (item.disabled_in_environment1 ~= ""
		or item.disabled_in_environment2 ~= ""
		or item.disabled_in_environment3 ~= ""
		or item.disabled_in_environment4 ~= "")
	then
		mod_options["ChoGGi_" .. id] = id
	end
end

local mod_EnableMod

--~ function ChoGGi_Funcs.Common.SetBuildingTemplates(template, key, value)
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

	local ct = ClassTemplates.Building
	local bt = BuildingTemplates
	local die = DisabledInEnvironment
	local blank_die = {"","","",""}

	local options = CurrentModOptions
	for id in pairs(mod_options) do
		if options:GetProperty(id) then
			-- get proper id from list
			id = mod_options[id]
			SetBuildingTemplates(id, bt, ct)
			die[id] = blank_die
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
	if not UIColony then
		return
	end

	UnlockBuildings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
