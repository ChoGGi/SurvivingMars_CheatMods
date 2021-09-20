-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print("Underground Cheats: B&B DLC is missing!")
	return
end

--~ local RetMapType = ChoGGi.ComFuncs.RetMapType
local function RetMapType()
	local UIColony = UIColony
	if not UIColony then
		return
	end
	local map_id = UICity.map_id

	if map_id == UIColony.underground_map_id then
		return "underground"
	elseif map_id == UIColony.surface_map_id then
		return "surface"
	else
		return "asteroid"
	end
end


local mod_EnableMod
local mod_LightTripodRadius
local mod_SupportStrutRadius

local function UpdateObjs()
	if not mod_EnableMod or RetMapType() ~= "underground" then
		return
	end

	-- lights
	BuildingTemplates.LightTripod.reveal_range = mod_LightTripodRadius
	ClassTemplates.Building.LightTripod.reveal_range = mod_LightTripodRadius
	local UpdateRevealObject = UnitRevealDarkness.UpdateRevealObject
	local objs = UICity.labels.LightTripod or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.reveal_range = mod_LightTripodRadius
		UpdateRevealObject(obj)
	end

	-- struts
	SupportStruts.work_radius = mod_SupportStrutRadius
	objs = UICity.labels.SupportStruts or ""
	for i = 1, #objs do
		objs[i].work_radius = mod_SupportStrutRadius
	end
end


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_LightTripodRadius = CurrentModOptions:GetProperty("LightTripodRadius")
	mod_SupportStrutRadius = CurrentModOptions:GetProperty("SupportStrutRadius")

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateObjs()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

OnMsg.CityStart = UpdateObjs
OnMsg.LoadGame = UpdateObjs
-- switch between different maps
OnMsg.ChangeMapDone = UpdateObjs
