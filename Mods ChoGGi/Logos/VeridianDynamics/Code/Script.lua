local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj
local StringFormat = string.format

-- copy n paste from ChoGGi.ComFuncs.LoadEntity
do -- LoadEntity
	-- no sense in making a new one for each entity
	local entity_templates = {
		decal = {
			category_Decors = true,
			entity = {
				fade_category = "Never",
				material_type = "Metal",
			},
		},
		building = {
			category_Buildings = true,
			entity = {
				class_parent = "BuildingEntityClass",
				fade_category = "Never",
				material_type = "Metal",
			},
		},
	}

	-- local instead of global is quicker
	local EntityData = EntityData
	local EntityLoadEntities = EntityLoadEntities
	local SetEntityFadeDistances = SetEntityFadeDistances

	local function LoadEntity(name,path,mod,template)
		EntityData[name] = entity_templates[template or "decal"]

		EntityLoadEntities[#EntityLoadEntities + 1] = {
			mod,
			name,
			path
		}
		SetEntityFadeDistances(name, -1, -1)
	end

	LoadEntity(
		"VeridianDynamics",
		StringFormat("%sEntities/VeridianDynamics.ent",CurrentModPath),
		Mods.ChoGGi_Logos_VeridianDynamics
	)
end -- LoadEntity

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Veridian Dynamics]],
		decal_entity = "VeridianDynamics",
		entity_name = "VeridianDynamics",
		id = "ChoGGi.Logos.VeridianDynamics",
		image = StringFormat("%sUI/VeridianDynamics.png",CurrentModPath),
	})
end
