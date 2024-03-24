-- See LICENSE for terms

local Resources = Resources
local T = T
local table = table

local mod_options = {}
local c = 0

local resources = table.icopy(UniversalStorageDepot.storable_resources)

resources[#resources+1] = "WasteRock"
if g_AvailableDlc.armstrong and not table.find(resources, "Seeds") then
	resources[#resources+1] = "Seeds"
end
if g_AvailableDlc.picard and not table.find(resources, "PreciousMinerals") then
	resources[#resources+1] = "PreciousMinerals"
end

for i = 1, #resources do
	local res = resources[i]
	c = c + 1
	mod_options[c] = PlaceObj("ModItemOptionNumber", {
		"name", "MinResourceAmount_" .. res,
		"DisplayName", table.concat(T(302535920011754, "Min Resource Amount") .. ": " .. T(Resources[res].display_name)),
		"Help", T(302535920011755, "If stored resource is below this amount then don't remove resource from depot."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 10000,
		"StepSize", 10,
	})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
