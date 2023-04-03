-- See LICENSE for terms

local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass

local mod_EnableMod

local IsValid = IsValid
local SetBldMaintenance = ChoGGi.ComFuncs.UpdateBuildings or function(obj, value)
	if not IsValid(obj) then
		return
	end

	if value then
		obj:SetBase("disable_maintenance", 1)
	else
		obj.accumulate_maintenance_points = true
		obj.maintenance_resource_type = BuildingTemplates[RetTemplateOrClass(obj)].maintenance_resource_type
		obj:SetBase("disable_maintenance", 0)
		obj:ResetMaintenanceState()
	end

end

local function DisableMain(label, toggle)
	local objs = UIColony.city_labels.labels[label] or ""
	for i = 1, #objs do
		SetBldMaintenance(objs[i], toggle)
	end
end

local function UpdateBuildings()
	if not mod_EnableMod then
		-- enable main if duststorm
		DisableMain("MOXIE", false)
		DisableMain("MoistureVaporator", false)
		return
	end

	if g_DustStorm then
		DisableMain("MOXIE", true)
		DisableMain("MoistureVaporator", true)
	else
		DisableMain("MOXIE", false)
		DisableMain("MoistureVaporator", false)
	end

end
OnMsg.CityStart = UpdateBuildings
OnMsg.LoadGame = UpdateBuildings
OnMsg.DustStorm = UpdateBuildings
OnMsg.DustStormEnded = UpdateBuildings

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UIColony then
		return
	end

	UpdateBuildings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
