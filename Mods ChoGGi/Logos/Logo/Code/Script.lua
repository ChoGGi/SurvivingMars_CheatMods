local CurrentModPath = CurrentModPath
local PlaceObj = PlaceObj

-- no sense in making a new one for each entity
local entity_template_decal = {
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

local name = "Something_Oh_So_Unique"
local path = CurrentModPath .. "Entities/Logo.ent"
local mod = Mods.Something_Oh_So_Unique

EntityData[name] = entity_template_decal
EntityLoadEntities[#EntityLoadEntities + 1] = {
	mod,
	name,
	path
}
SetEntityFadeDistances(name, -1, -1)

function OnMsg.ClassesPostprocess()
	PlaceObj("MissionLogoPreset", {
		display_name = [[Logo]],
		decal_entity = "Logo",
		entity_name = name,
		id = "ChoGGi.Logos.Logo",
		image = CurrentModPath .. "UI/Logo.png",
	})
end
