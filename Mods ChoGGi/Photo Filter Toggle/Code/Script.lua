-- See LICENSE for terms

local SetSceneParam = SetSceneParam
local Min = Min
local Lerp = Lerp
local SetDOFParams = SetDOFParams
local sqrt = sqrt

local options
local photos = {}
local photo_c = 0
local settings = {}
local settings_c = 0

local PhotoFilterPresetMap = PhotoFilterPresetMap
for id in pairs(PhotoFilterPresetMap) do
	if id ~= "None" then
		photo_c = photo_c + 1
		photos[photo_c] = id
	end
end

-- add settings
local white_list = {
	fogDensity = true,
	bloomStrength = true,
	exposure = true,
	vignette = true,
	depthOfField = true,
	focusDepth = true,
	defocusStrength = true,
	fogDensity = true,
}

local function ApplyFilter()
	if not UIColony then
		return
	end

	options = CurrentModOptions

	local apply
	for i = 1, photo_c do
		local filter = photos[i]
		if options:GetProperty(filter) then
			apply = filter
		end
	end

	apply = PhotoFilterPresetMap[apply]
	if apply then
		g_PhotoFilter = apply:GetShaderDescriptor()
	else
		g_PhotoFilter = false
	end
	PP_Rebuild()

	local hr = hr

	local shared_props = {
		depthOfField = options:GetProperty("depthOfField"),
		focusDepth = options:GetProperty("focusDepth"),
		defocusStrength = options:GetProperty("defocusStrength"),
	}

	for i = 1, settings_c do
		local setting = settings[i]
		local prop_id = setting.id
		local mod_setting = options:GetProperty(prop_id)

		-- pretty much copypasta from PhotoMode.lua
		if prop_id == "fogDensity" then
			SetSceneParam(1, "FogGlobalDensity", mod_setting, 0, 0)
		elseif prop_id == "bloomStrength" then
			SetSceneVectorParam(1, "Bloom", 0, mod_setting, 0, 0)
		elseif prop_id == "exposure" then
			SetSceneParam(1, "GlobalExposure", mod_setting, 0, 0)
		elseif prop_id == "vignette" then
			SetSceneParam(1, "Vignette", mod_setting, 0, 0)
		elseif prop_id == "depthOfField" or prop_id == "focusDepth" or prop_id == "defocusStrength" then
			local detail = 3
			local focus_depth = Lerp(hr.NearZ, hr.FarZ, shared_props.focusDepth ^ detail, 100 ^ detail)
			local dof = Lerp(0, hr.FarZ - hr.NearZ, shared_props.depthOfField ^ detail, 100 ^ detail)
			local strength = sqrt(shared_props.defocusStrength * 100)
			SetDOFParams(strength, Max(focus_depth - dof / 3, hr.NearZ), Max(focus_depth - dof / 6, hr.NearZ), strength, Min(focus_depth + dof / 3, hr.FarZ), Min(focus_depth + dof * 2 / 3, hr.FarZ), 0)
		end

	end

end

-- load default/saved settings
function OnMsg.ModsReloaded()
	-- can't call it right away
	local filter_settings = PhotoModeObject:GetProperties()

	for i = 1, #filter_settings do
		local filter_setting = filter_settings[i]
		if white_list[filter_setting.id] then
			settings_c = settings_c + 1
			settings[settings_c] = filter_setting
		end
	end

	ApplyFilter()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ApplyFilter()
end

OnMsg.CityStart = ApplyFilter
OnMsg.LoadGame = ApplyFilter
OnMsg.AfterLightmodelChange = ApplyFilter
