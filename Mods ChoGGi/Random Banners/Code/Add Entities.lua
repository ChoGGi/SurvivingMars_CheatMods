-- See LICENSE for terms

-- this code will add a new banner (pretty much the same as a regular logo)

-- not much point without it
if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed!")
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
local def = CurrentModDef

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
		def,
		name,
		path_loc_str .. name .. ".ent"
	}
	SetEntityFadeDistances(name, -1, -1)
end
