-- See LICENSE for terms

local mod_EnableMod
local mod_DroneHubRange
local mod_DroneHubRangeDefault
local mod_UpdateExistingHubs

local ChoOrig_CommandCenterMaxRadius = const.CommandCenterMaxRadius

local SetPropertyProp = ChoGGi.ComFuncs.SetPropertyProp

local function SetHubRange()
	-- defaults
	if not mod_EnableMod then
		const.CommandCenterMaxRadius = ChoOrig_CommandCenterMaxRadius
		ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxRadius", ChoOrig_CommandCenterMaxRadius)
		DroneHub.UIWorkRadius = ChoOrig_CommandCenterMaxRadius
		DroneHub.work_radius = ChoOrig_CommandCenterMaxRadius
		SetPropertyProp(DroneHub, "UIWorkRadius", "max", ChoOrig_CommandCenterMaxRadius)
		return
	end

	-- probably useless
	const.CommandCenterMaxRadius = mod_DroneHubRange
	ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxRadius", mod_DroneHubRange)

	-- default range of new hubs
	DroneHub.UIWorkRadius = mod_DroneHubRangeDefault
	DroneHub.work_radius = mod_DroneHubRangeDefault
	SetPropertyProp(DroneHub, "UIWorkRadius", "max", mod_DroneHubRange)
	DroneHub.service_area_max = mod_DroneHubRange

	-- update existing hubs
	local objs = UICity.labels.DroneHub or ""
	for i = 1, #objs do
		local obj = objs[i]
		SetPropertyProp(obj, "UIWorkRadius", "max", mod_DroneHubRange)
		obj.service_area_max = mod_DroneHubRange
		if mod_UpdateExistingHubs then
			obj:SetWorkRadius(mod_DroneHubRange)
			obj.UIWorkRadius = mod_DroneHubRange
		end
	end
end
OnMsg.CityStart = SetHubRange
OnMsg.LoadGame = SetHubRange

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DroneHubRange = CurrentModOptions:GetProperty("DroneHubRange")
	mod_DroneHubRangeDefault = CurrentModOptions:GetProperty("DroneHubRangeDefault")
	mod_UpdateExistingHubs = CurrentModOptions:GetProperty("UpdateExistingHubs")

	-- make sure we're in-game
	if not UICity then
		return
	end

	SetHubRange()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- update newly built
function OnMsg.BuildingInit(obj)
	if not IsKindOf(obj, "DroneHub") then
		return
	end

	SetPropertyProp(obj, "UIWorkRadius", "max", mod_DroneHubRange)
	obj.service_area_max = mod_DroneHubRange
	obj:SetWorkRadius(mod_DroneHubRange)
	obj.UIWorkRadius = mod_DroneHubRange
end
