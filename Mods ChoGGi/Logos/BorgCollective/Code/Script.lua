-- See LICENSE for terms

local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj


-- copy n paste from ChoGGi_Funcs.Common.LoadEntity
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

	local function LoadEntity(name, path, mod, template)
		EntityData[name] = entity_templates[template or "decal"]

		EntityLoadEntities[#EntityLoadEntities + 1] = {
			mod,
			name,
			path
		}
		SetEntityFadeDistances(name, -1, -1)
	end

	LoadEntity(
		"BorgCollective",
		CurrentModPath .. "Entities/BorgCollective.ent",
		CurrentModDef
	)
end -- LoadEntity

function OnMsg.ClassesPostprocess()
	if not MissionLogoPresetMap["ChoGGi.Logos.BorgCollective"] then
		PlaceObj("MissionLogoPreset", {
			display_name = [[Borg Collective]],
			decal_entity = "BorgCollective",
			entity_name = "BorgCollective",
			id = "ChoGGi.Logos.BorgCollective",
			image = CurrentModPath .. "UI/BorgCollective.png",
		})
	end
end
