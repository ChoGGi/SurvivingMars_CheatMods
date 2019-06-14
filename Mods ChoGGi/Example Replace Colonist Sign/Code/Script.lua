
-- list of entities we're going to be adding
local entity_list = {
	"SignTest",
}
-- getting called a bunch, so make them local
local path_loc_str = CurrentModPath .. "Entities/"
local mod = Mods.ChoGGi_ExampleReplaceSign

-- no sense in making a new one for each entity
local EntityDataTableTemplate = {
	category_Decors = true,
	entity = {
		fade_category = "Never",
		material_type = "Metal",
	},
}

-- local instead of global is quicker
local EntityData = EntityData
local EntityLoadEntities = EntityLoadEntities
local SetEntityFadeDistances = SetEntityFadeDistances

-- pretty much using what happens when you use ModItemEntity
local function AddEntity(name)
	EntityData[name] = EntityDataTableTemplate
	EntityLoadEntities[#EntityLoadEntities + 1] = {
		mod,
		name,
		path_loc_str .. name .. ".ent"
	}
	SetEntityFadeDistances(name, -1, -1)
end

for i = 1, #entity_list do
	AddEntity(entity_list[i])
end

-- replace the homeless sign with our new one
UnitSignHomeless.entity = "SignTest"
-- for the selected signs you need this replaced with an entity
--~ UnitArrowHomeless.entity = "ArrowTest"
