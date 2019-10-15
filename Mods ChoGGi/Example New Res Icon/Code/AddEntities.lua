
-- list of entities we're going to be adding
local entity_list = {
	"SignExampleMetalDeposit",
	"SignExampleConcreteDeposit",
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
		fade_category = "Never",
		material_type = "Metal",
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
