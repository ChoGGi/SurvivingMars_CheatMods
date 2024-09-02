-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
}
local c = #mod_options

local BuildingTemplates = BuildingTemplates
for id, item in pairs(BuildingTemplates) do
	if item.display_icon ~= ""
		and (item.disabled_in_environment1 ~= ""
		or item.disabled_in_environment2 ~= ""
		or item.disabled_in_environment3 ~= ""
		or item.disabled_in_environment4 ~= "")
	then
		local icon = item.display_icon and "\n\n<image " .. item.display_icon .. ">" or ""
		c = c + 1
		mod_options[c] = PlaceObj("ModItemOptionToggle", {
			"name", "ChoGGi_" .. id,
			"DisplayName", T(item.display_name),
			"Help", table.concat(T(item.description) .. T("\n\n") .. T(id) .. T(icon)),
			"DefaultValue", false,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
