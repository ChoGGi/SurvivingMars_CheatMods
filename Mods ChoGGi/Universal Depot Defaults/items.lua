-- See LICENSE for terms

local table = table
local PlaceObj = PlaceObj
local T = T

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShuttleAccess",
		"DisplayName", table.concat(T("<image UI/Icons/IPButtons/shuttle.tga> ") .. T(11254, "Shuttle Access")),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "StoredAmount",
		"DisplayName", table.concat(T("<image UI/Icons/IPButtons/resources_section.tga> ") .. T(10370, "Desire Amount")),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", function()
			-- use my mod if setting set
			if Mods and Mods.ChoGGi_CheatMenu and ChoGGi.UserSettings.StorageUniversalDepot then
				return ChoGGi.UserSettings.StorageUniversalDepot / const.ResourceScale
			end
			return UniversalStorageDepot:GetDefaultPropertyValue("max_storage_per_resource") / const.ResourceScale
		end,
	}),
}
-- add any valid res
local c = #mod_options

local storable_resources = {
	"Concrete",
	"Electronics",
	"Food",
	"Fuel",
	"MachineParts",
	"Metals",
	"Polymers",
	"PreciousMetals",
}
-- no seeds if no green planet
if g_AvailableDlc.armstrong then
	storable_resources[#storable_resources+1] = "Seeds"
end
if g_AvailableDlc.picard then
	storable_resources[#storable_resources+1] = "PreciousMinerals"
end

-- if ECM is installed than use amount from it
local max_res_amount = BuildingTemplates.StorageConcrete.max_storage_per_resource / const.ResourceScale
if Mods and Mods.ChoGGi_CheatMenu and ChoGGi.UserSettings.StorageOtherDepot then
	max_res_amount = ChoGGi.UserSettings.StorageOtherDepot / const.ResourceScale
end

-- get display_name and add to list
local Resources = Resources
for id, item in pairs(Resources) do

	-- default enable storing this resource in uni depots
	if table.find(storable_resources, id) then
		local image = ""
		if id == "Seeds" then
			image = T("<image UI/Icons/ColonyControlCenter/seeds_on.tga> ")
		else
			image = T("<image UI/Icons/Sections/" .. id ..  "_1.tga> ")
		end
		c = c + 1
		mod_options[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", table.concat(image .. T(754117323318--[[Enable]]) .. " " .. T(item.display_name)),
			"DefaultValue", true,
		})

		-- individual
--~ 		-- Add desire amounts for each resource depot
--~ 		c = c + 1
--~ 		mod_options[c] = PlaceObj("ModItemOptionNumber", {
--~ 			"name", "StoredAmount_" .. id,
--~ 			"DisplayName", table.concat(T(10370, "Desire Amount") .. image .. T(item.display_name)),
--~ 			"Help", T(0000, "Set desire amount for individual depots."),
--~ 			"DefaultValue", 3,
--~ 			"MinValue", 0,
--~ 			"MaxValue", max_res_amount,
--~ 		})

	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
