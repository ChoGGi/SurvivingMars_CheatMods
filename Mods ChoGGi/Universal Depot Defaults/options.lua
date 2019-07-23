-- See LICENSE for terms

local properties = {
	{
		default = true,
		editor = "bool",
		id = "ShuttleAccess",
		name = T(11254, "Shuttle Access"),
	},
	{
		default = 3,
		max = function()
			return UniversalStorageDepot:GetDefaultPropertyValue("max_storage_per_resource") / const.ResourceScale
		end,
		min = 0,
		editor = "number",
		id = "StoredAmount",
		name = T(1000100, "Amount"),
	},
}
-- add any valid res
local c = #properties

local storable_resources = {"Concrete", "Electronics", "Food", "Fuel", "MachineParts", "Metals", "Polymers", "PreciousMetals", "Seeds"}
local table_find = table.find

local Resources = Resources
for id, item in pairs(Resources) do
	if table_find(storable_resources, id) then
		c = c + 1
		properties[c] = {
			default = true,
			editor = "bool",
			id = id,
			name = T(754117323318, "Enable") .. " " .. T(item.display_name),
		}
	end
end

-- max 40 chars
DefineClass("ModOptions_ChoGGi_UniversalDepotDefaults", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})
