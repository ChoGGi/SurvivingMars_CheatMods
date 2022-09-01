-- See LICENSE for terms

local IsKindOf = IsKindOf
local PlaceObj = PlaceObj
local T = T
local table = table

local properties = {
	PlaceObj("ModItemOptionNumber", {
		"name", "AutoPerformance",
		"DisplayName", T(0000, " Auto Performance"),
		"Help", T(0000, "Performance value when no colonists."),
		"DefaultValue", 100,
		"MinValue", 1,
		"MaxValue", 1000,
		"StepSize", 10,
	}),
}
local c = 1

local g_Classes = g_Classes
local BuildingTemplates = BuildingTemplates
for id, item in pairs(BuildingTemplates) do
	local cls_obj = g_Classes[item.template_class]
	if cls_obj and IsKindOf(cls_obj, "Factory") then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", T(item.display_name),
			"Help", table.concat(T(item.description) .. "\n\n<image " .. item.display_icon .. ">"),
			"DefaultValue", true,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties
