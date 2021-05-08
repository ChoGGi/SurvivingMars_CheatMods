-- See LICENSE for terms

local table = table

local mod_EnableMod
local mod_DroneHubRange
local mod_DroneHubRangeDefault

local orig_CommandCenterMaxRadius = const.CommandCenterMaxRadius

--~ local SetPropertyProp = ChoGGi.ComFuncs.SetPropertyProp
local SetPropertyProp = ChoGGi.ComFuncs.SetPropertyProp or function(obj, prop_id, value_id, value)
	if not obj or obj and not obj:IsKindOf("PropertyObject") then
		return
	end

	local props = obj.properties
	local idx = table.find(props, "id", prop_id)
	if not idx then
		return
	end

	props[idx][value_id] = value
end

local function SetModOptions()
	if not mod_EnableMod then
		const.CommandCenterMaxRadius = orig_CommandCenterMaxRadius
		ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxRadius", orig_CommandCenterMaxRadius)
		return
	end

	const.CommandCenterMaxRadius = mod_DroneHubRange
	ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxRadius", mod_DroneHubRange)

	-- default range of new hubs
	DroneHub.UIWorkRadius = mod_DroneHubRangeDefault
	DroneHub.work_radius = mod_DroneHubRangeDefault

	local objs = UICity.labels.DroneHub or ""
	for i = 1, #objs do
		local obj = objs[i]
		SetPropertyProp(obj, "UIWorkRadius", "max", mod_DroneHubRange)
		obj:SetWorkRadius(mod_DroneHubRange)
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DroneHubRange = CurrentModOptions:GetProperty("DroneHubRange")
	mod_DroneHubRangeDefault = CurrentModOptions:GetProperty("DroneHubRangeDefault")

	SetPropertyProp(DroneHub, "UIWorkRadius", "max", mod_DroneHubRange)


	-- make sure we're in-game
	if not UICity then
		return
	end

	SetModOptions()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = SetModOptions
OnMsg.LoadGame = SetModOptions
