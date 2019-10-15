-- See LICENSE for terms

local properties = {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShuttleAccess",
		"DisplayName", T(11254, "Shuttle Access"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "StoredAmount",
		"DisplayName", T(10370, "Desire Amount"),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", function()
			return UniversalStorageDepot:GetDefaultPropertyValue("max_storage_per_resource") / const.ResourceScale
		end,
	}),
}
-- add any valid res
local c = #properties

local storable_resources = {"Concrete", "Electronics", "Food", "Fuel", "MachineParts", "Metals", "Polymers", "PreciousMetals", "Seeds"}
local table_find = table.find

-- get display_name and add to list
local Resources = Resources
for id, item in pairs(Resources) do
	if table_find(storable_resources, id) then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", table.concat(T(754117323318, "Enable") .. " " .. T(item.display_name)),
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
