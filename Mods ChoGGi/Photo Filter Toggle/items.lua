-- See LICENSE for terms

local table = table
local T = T

local properties = {}
local c = 0

-- add filters
local PhotoFilterPresetMap = PhotoFilterPresetMap
for id, item in pairs(PhotoFilterPresetMap) do
	if id ~= "None" then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", table.concat(T(3454,"Photo Filter") .. ": " .. T(item.displayName)),
			"Help", table.concat(T(item.desc) .. T(302535920012032, [[


<yellow>Only enable one filter (whichever is last will be used).</yellow>]])),
			"DefaultValue", false,
		})
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

local filter_settings = PhotoModeObject:GetProperties()

for i = 1, #filter_settings do
	local setting = filter_settings[i]
	if white_list[setting.id] then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionNumber", {
			"name", setting.id,
			"DisplayName", table.concat(T(" ") .. T(setting.name)),
			"Help", T(302535920012033, "Adjust settings for selected photo filter."),
			"DefaultValue", setting.default,
			"MinValue", setting.min,
			"MaxValue", setting.max,
			"StepSize", setting.step or 1,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties