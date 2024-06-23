-- See LICENSE for terms

local mod = CurrentModDef

local logos = {
	{
		file = "Arrow",
		name = "Arrow",
	},
	{
		file = "DHARMA Initiative (Modern Black)",
		name = "DHARMA Initiative (Modern Black)",
	},
	{
		file = "DHARMA Initiative (Modern with Text)",
		name = "DHARMA Initiative (Modern with Text)",
	},
	{
		file = "DHARMA Initiative (Modern)",
		name = "DHARMA Initiative (Modern)",
	},
	{
		file = "DHARMA Initiative",
		name = "DHARMA Initiative",
	},
	{
		file = "Door",
		name = "Door",
	},
	{
		file = "Flame",
		name = "Flame",
	},
	{
		file = "Hydra (Red)",
		name = "Hydra (Red)",
	},
	{
		file = "Hydra",
		name = "Hydra",
	},
	{
		file = "Lamp Post",
		name = "Lamp Post",
	},
	{
		file = "Looking Glass (Alternate)",
		name = "Looking Glass (Alternate)",
	},
	{
		file = "Looking Glass",
		name = "Looking Glass",
	},
	{
		file = "Orchid (Inverted)",
		name = "Orchid (Inverted)",
	},
	{
		file = "Orchid",
		name = "Orchid",
	},
	{
		file = "Pearl (Inverted)",
		name = "Pearl (Inverted)",
	},
	{
		file = "Pearl",
		name = "Pearl",
	},
	{
		file = "Security",
		name = "Security",
	},
	{
		file = "Sri Lanka",
		name = "Sri Lanka",
	},
	{
		file = "Staff",
		name = "Staff",
	},
	{
		file = "Swan",
		name = "Swan",
	},
	{
		file = "Tempest",
		name = "Tempest",
	},
	{
		file = "Temple",
		name = "Temple",
	},
}
local logos_length = #logos

do -- LoadEntity
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
	local ent_path = mod.env.CurrentModPath .. "Entities/"

	for i = 1, logos_length do
		local file = logos[i].file

		EntityData[file] = entity_template_decal
		EntityLoadEntities[#EntityLoadEntities + 1] = {
			mod,
			file,
			ent_path .. file .. ".ent"
		}
		SetEntityFadeDistances(file, -1, -1)
	end
end -- LoadEntity

do -- Postprocess
	local PlaceObj = PlaceObj
	local logo_path = mod.env.CurrentModPath .. "UI/"

	function OnMsg.ClassesPostprocess()
		for i = 1, logos_length do
			local logo = logos[i]
			local file = logo.file

			local id = "DHARMAInitiative_" .. file
			if not MissionLogoPresetMap[id] then
				PlaceObj("MissionLogoPreset", {
					decal_entity = file,
					entity_name = file,
					display_name = "DHARMA: " .. logo.name,
					id = id,
					image = logo_path .. file .. ".png",
				})
			end
		end
	end
end -- Postprocess
