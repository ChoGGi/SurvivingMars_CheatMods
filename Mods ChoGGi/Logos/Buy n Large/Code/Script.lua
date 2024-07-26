-- See LICENSE for terms

local mod = CurrentModDef

local loadlogos = {
	{
		name = "BnLCorp",
		display_name = [[BnL Corp]],
	},
}

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

	for i = 1, #loadlogos do
		local name = loadlogos[i].name
		LoadEntity(
			name,
			CurrentModPath .. "Entities/" .. name .. ".ent",
			mod
		)
	end
end -- LoadEntity

function OnMsg.ClassesPostprocess()
	for i = 1, #loadlogos do
		local name = loadlogos[i].name
		local id = "ChoGGi.Logos." .. name
		if not MissionLogoPresetMap[id] then
			PlaceObj("MissionLogoPreset", {
				display_name = loadlogos[i].display_name,
				decal_entity = name,
				entity_name = name,
				id = id,
				image = CurrentModPath .. "UI/" .. name .. ".png",
			})
		end
	end
end
