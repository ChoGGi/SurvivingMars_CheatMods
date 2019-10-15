-- See LICENSE for terms

-- Mars Marx, eh close enough
local mod = CurrentModDef

local logos = {
	{
		file = "Argent_a_fylfot_azure",
		name = "Argent a fylfot azure",
	},
	{
		file = "Arms_of_chamberlayne",
		name = "Arms of Chamberlayne",
	},
	{
		file = "Aztec_Swastika",
		name = "Aztec Swastika",
	},
	{
		file = "Battersea_Shield",
		name = "Battersea Shield",
	},
	{
		file = "Bengali_Swastika",
		name = "Bengali Swastika",
	},
	{
		file = "Black_Sun",
		name = "Black Sun",
	},
	{
		file = "Chromesun_4_uktenas",
		name = "Chromesun 4 uktenas",
	},
	{
		file = "Croix_Gammee",
		name = "Croix Gammee",
	},
	{
		file = "Cross_Cramponnee",
		name = "Cross Cramponnee",
	},
	{
		file = "Falun_Gong",
		name = "Falun Gong",
	},
	{
		file = "Finnish_air_force_roundel_(1934-1945)",
		name = "Finnish air force roundel (1934-1945)",
	},
	{
		file = "Flag_of_Gilgit-Baltistan_United_Movement",
		name = "Flag of Gilgit-Baltistan United Movement",
	},
	{
		file = "Fylfot",
		name = "Fylfot",
	},
	{
		file = "Gammadion",
		name = "Gammadion",
	},
	{
		file = "Greco-Roman_Swastika",
		name = "Greco-Roman Swastika",
	},
	{
		file = "Hachisuka_Masakatsu",
		name = "Hachisuka Masakatsu",
	},
	{
		file = "Hands_of_Svarog",
		name = "Hands of Svarog",
	},
	{
		file = "Hatisuka_Manji",
		name = "Hatisuka Manji",
	},
	{
		file = "Hindu",
		name = "Hindu",
	},
	{
		file = "Latvian_air_force_roundel_(1926-1940)",
		name = "Latvian air force roundel (1926-1940)",
	},
	{
		file = "Lauburu",
		name = "Lauburu",
	},
	{
		file = "Left-facing_Swastika",
		name = "Left-facing Swastika",
	},
	{
		file = "Lentosotakoulun_Lippu",
		name = "Lentosotakoulun Lippu",
	},
	{
		file = "Little_Sun_Sloneczko",
		name = "Little Sun Sloneczko",
	},
	{
		file = "Lotta_Svard_badge",
		name = "Lotta Svard badge",
	},
	{
		file = "Mongolian_shamanism_Temdeg_symbol",
		name = "Mongolian shamanism Temdeg",
	},
	{
		file = "Mursunsydan",
		name = "Mursunsydan",
	},
	{
		file = "Odinic_Rite_fylfot",
		name = "Odinic Rite fylfot",
	},
	{
		file = "Patch_of_the_US_45th_Infantry_Division_(1924-1939)",
		name = "Patch of the US 45th Infantry Division (1924-1939)",
	},
	{
		file = "Raelian_symbol",
		name = "Raelian",
	},
	{
		file = "Right-facing_Swastika",
		name = "Right-facing Swastika",
	},
	{
		file = "Sauvastika",
		name = "Sauvastika",
	},
	{
		file = "Sauwastika",
		name = "Sauwastika",
	},
	{
		file = "Shanrendao",
		name = "Shanrendao",
	},
	{
		file = "Slavic_Svarog_Kolowrot",
		name = "Slavic Svarog Kolowrot",
	},
	{
		file = "Slavic_Swastika_Cross_of_Perun",
		name = "Slavic Swastika Cross of Perun",
	},
	{
		file = "Slavic_Swastika_Cross_of_Perun_2",
		name = "Slavic Swastika Cross of Perun 2",
	},
	{
		file = "Square",
		name = "Square",
	},
	{
		file = "Swarzyca_Kruszwicka",
		name = "Swarzyca Kruszwicka",
	},
	{
		file = "Swarzyca_z_podwojnymi_ramionami",
		name = "Swarzyca z podwójnymi ramionami",
	},
	{
		file = "Tetraskele",
		name = "Tetraskele",
	},
	{
		file = "Theosophical_Seal",
		name = "Theosophical Seal",
	},
	{
		file = "Tursaansydan",
		name = "Tursaansydan",
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

			PlaceObj("MissionLogoPreset", {
				decal_entity = file,
				entity_name = file,
				display_name = "Hakenkreuz: " .. logo.name,
				id = "HakenkreuzLogos_" .. file,
				image = logo_path .. file .. ".png",
			})
		end
	end
end -- Postprocess
