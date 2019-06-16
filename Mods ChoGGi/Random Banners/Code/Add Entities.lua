-- See LICENSE for terms

-- for those of you interested in adding new flags (you'll also have to do something with SponsorBannerBase:GetEntity())

-- not much point without it
if not g_AvailableDlc.gagarin then
	return
end

-- list of entities we're going to be adding
local entity_list = {
	"Flag_01_Pride",
	"Flag_02_Pride",
	"Flag_03_Pride",
}

-- local instead of global is quicker
local EntityData = EntityData
local EntityLoadEntities = EntityLoadEntities
local SetEntityFadeDistances = SetEntityFadeDistances
-- getting called a bunch, so make them local
local path_loc_str = CurrentModPath .. "Entities/"
local mod = Mods.ChoGGi_RandomBanners

-- no sense in making a new one for each entity
local entity_template = {
	category_Decors = true,
	entity = {
		class_parent = "BuildingEntityClass",
		fade_category = "Never",
		material_type = "Rock",
	},
}

for i = 1, #entity_list do
	local name = entity_list[i]
	-- pretty much using what happens when you use ModItemEntity
	EntityData[name] = entity_template
	EntityLoadEntities[#EntityLoadEntities + 1] = {
		mod,
		name,
		path_loc_str .. name .. ".ent"
	}
	SetEntityFadeDistances(name, -1, -1)
end
