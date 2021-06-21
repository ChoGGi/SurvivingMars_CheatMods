-- See LICENSE for terms

local table = table

local mod_EnableMod
local mod_DroneHubRange
local mod_DroneHubRangeDefault
local mod_UpdateExistingHubs

local orig_CommandCenterMaxRadius = const.CommandCenterMaxRadius

local SetPropertyProp = ChoGGi.ComFuncs.SetPropertyProp

local function SetModOptions()
	-- defaults
	if not mod_EnableMod then
		const.CommandCenterMaxRadius = orig_CommandCenterMaxRadius
		ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxRadius", orig_CommandCenterMaxRadius)
		DroneHub.UIWorkRadius = orig_CommandCenterMaxRadius
		DroneHub.work_radius = orig_CommandCenterMaxRadius
		SetPropertyProp(DroneHub, "UIWorkRadius", "max", orig_CommandCenterMaxRadius)
		return
	end

	-- probably useless
	const.CommandCenterMaxRadius = mod_DroneHubRange
	ChoGGi.ComFuncs.SetConstsG("CommandCenterMaxRadius", mod_DroneHubRange)

	-- default range of new hubs
	DroneHub.UIWorkRadius = mod_DroneHubRangeDefault
	DroneHub.work_radius = mod_DroneHubRangeDefault
	SetPropertyProp(DroneHub, "UIWorkRadius", "max", mod_DroneHubRange)

	-- update existing hubs
	local objs = UICity.labels.DroneHub or ""
	for i = 1, #objs do
		local obj = objs[i]
		SetPropertyProp(obj, "UIWorkRadius", "max", mod_DroneHubRange)
		if mod_UpdateExistingHubs then
			obj:SetWorkRadius(mod_DroneHubRange)
			obj.UIWorkRadius = mod_DroneHubRange
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DroneHubRange = CurrentModOptions:GetProperty("DroneHubRange")
	mod_DroneHubRangeDefault = CurrentModOptions:GetProperty("DroneHubRangeDefault")
	mod_UpdateExistingHubs = CurrentModOptions:GetProperty("UpdateExistingHubs")

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
