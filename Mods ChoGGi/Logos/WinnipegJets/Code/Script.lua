local DelayedLoadEntity = DelayedLoadEntity
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

	-- Mars Marx, eh close enough
	local mod = Mods.ChoGGi_Logos_WinnipegJets
	local ent_path = StringFormat("%sEntities/%s.ent",mod.env.CurrentModPath,"%s")

	local function LoadDecal(name)
		LoadEntity(
			name,
			ent_path:format(name),
			mod
		)
	end

	LoadDecal("WinnipegJets2011")
	LoadDecal("WinnipegJets2018")
end -- LoadEntity

local logo_path = StringFormat("%sUI/%s.png",mod.env.CurrentModPath,"%s")
local function LoadLogo(name,display)
	PlaceObj("MissionLogoPreset", {
		display_name = display,
		decal_entity = name,
		entity_name = name,
		id = StringFormat("ChoGGi.Logos.%s",name),
		image = logo_path:format(name),
	})
end

function OnMsg.ClassesPostprocess()
	LoadLogo("WinnipegJets2011","Winnipeg Jets 2011")
	LoadLogo("WinnipegJets2018","Winnipeg Jets 2018")
end
