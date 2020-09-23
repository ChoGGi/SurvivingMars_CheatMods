-- See LICENSE for terms

-- Mars Marx, eh close enough
local mod = CurrentModDef

local logos = {
	{
		file = "A_flag_for_Space_Communists",
		name = "A flag for Space Communists",
	},
	{
		file = "A_flag_for_Space_Communists2",
		name = "A flag for Space Communists2",
	},
	{
		file = "Anarcho-Communist_Symbol",
		name = "Anarcho-Communist Symbol",
	},
	{
		file = "Chilean_Communist_Party",
		name = "Chilean Communist Party",
	},
	{
		file = "China_Emblem_PLA",
		name = "China Emblem PLA",
	},
	{
		file = "Chinese_Communist_(1920s)",
		name = "Chinese Communist (1920s)",
	},
	{
		file = "Coat_of_Arms_Byelorussian_Soviet_Socialist_Republic",
		name = "Coat of Arms Byelorussian Soviet Socialist Republic",
	},
	{
		file = "Coat_of_arms_of_Bulgaria_(1971-1990)",
		name = "Coat of arms of Bulgaria (1971-1990)",
	},
	{
		file = "Coat_of_Arms_of_East_Germany_(1953-1955)",
		name = "Coat of Arms of East Germany (1953-1955)",
	},
	{
		file = "Coat_of_Arms_of_PCR",
		name = "Coat of Arms of PCR",
	},
	{
		file = "Coat_of_Arms_of_South_Vietnam_(1954-1955)",
		name = "Coat of Arms of South Vietnam (1954-1955)",
	},
	{
		file = "Coat_of_Arms_of_the_Popular_Republic_of_Romania_1948",
		name = "Coat of Arms of the Popular Republic of Romania (1948)",
	},
	{
		file = "Coat_of_Arms_of_the_Socialist_Republic_of_Bosnia_and_Herzegovina",
		name = "Coat of Arms of the Socialist Republic of Bosnia and Herzegovina",
	},
	{
		file = "Coat_of_Arms_of_the_Socialist_Republic_of_Serbia",
		name = "Coat of Arms of the Socialist Republic of Serbia",
	},
	{
		file = "Coat_of_Arms_of_the_Soviet_Union",
		name = "Coat of Arms of the Soviet Union",
	},
	{
		file = "Coat_Soviet_Canuck",
		name = "Coat of Arms of Soviet Canuck",
	},
	{
		file = "Colombian_Communist_Party",
		name = "Colombian Communist Party",
	},
	{
		file = "Communist_Brazil_coat_of_arms",
		name = "Communist Brazil coat of arms",
	},
	{
		file = "Communist_California",
		name = "Communist California",
	},
	{
		file = "Communist_Party_of_Argentina",
		name = "Communist Party of Argentina",
	},
	{
		file = "Communist_Party_of_Belarus",
		name = "Communist Party of Belarus",
	},
	{
		file = "Communist_Party_of_Brazil",
		name = "Communist Party of Brazil",
	},
	{
		file = "Communist_Party_of_Britain",
		name = "Communist Party of Britain",
	},
	{
		file = "Communist_Party_of_Canada",
		name = "Communist Party of Canada",
	},
	{
		file = "Communist_Party_of_Canada_(2018)",
		name = "Communist Party of Canada (2018)",
	},
	{
		file = "Communist_Party_of_Chile",
		name = "Communist Party of Chile",
	},
	{
		file = "Communist_Party_of_China",
		name = "Communist Party of China",
	},
	{
		file = "Communist_Party_of_Finland",
		name = "Communist Party of Finland",
	},
	{
		file = "Communist_Party_of_Greece",
		name = "Communist Party of Greece",
	},
	{
		file = "Communist_Party_of_Ireland",
		name = "Communist Party of Ireland",
	},
	{
		file = "Communist_Party_of_Mexico",
		name = "Communist Party of Mexico",
	},
	{
		file = "Communist_Party_of_Pakistan",
		name = "Communist Party of Pakistan",
	},
	{
		file = "Communist_Party_of_Spain",
		name = "Communist Party of Spain",
	},
	{
		file = "Communist_Party_of_Sweden",
		name = "Communist Party of Sweden",
	},
	{
		file = "Communist_Party_of_the_Russian_Federation",
		name = "Communist Party of the Russian Federation",
	},
	{
		file = "Communist_Party_of_Turkey",
		name = "Communist Party of Turkey",
	},
	{
		file = "Communist_Party_of_Venezuela",
		name = "Communist Party of Venezuela",
	},
	{
		file = "Cosmonautica",
		name = "Cosmonautica",
	},
	{
		file = "Cosmonautica_Orange",
		name = "Cosmonautica Orange",
	},
	{
		file = "Emblem_of_North_Korea",
		name = "Emblem of North Korea",
	},
	{
		file = "Emblem_of_the_Armenian_SSR",
		name = "Emblem of the Armenian SSR",
	},
	{
		file = "Emblem_of_the_Azerbaijan_SSR",
		name = "Emblem of the Azerbaijan SSR",
	},
	{
		file = "Emblem_of_the_Georgian_SSR",
		name = "Emblem of the Georgian SSR",
	},
	{
		file = "Emblem_of_the_Karelo-Finnish_SSR",
		name = "Emblem of the Karelo-Finnish SSR",
	},
	{
		file = "Emblem_of_the_Kirghiz_SSR",
		name = "Emblem of the Kirghiz SSR",
	},
	{
		file = "Emblem_of_the_Moldavian_SSR",
		name = "Emblem of the Moldavian SSR",
	},
	{
		file = "Emblem_of_the_Peoples_Republic_of_China",
		name = "Emblem of the People's Republic of China",
	},
	{
		file = "Emblem_of_the_Tajik_SSR",
		name = "Emblem of the Tajik SSR",
	},
	{
		file = "Emblem_of_the_Transcaucasian_SFSR_(1922-1923)",
		name = "Emblem of the Transcaucasian SFSR (1922-1923)",
	},
	{
		file = "Emblem_of_the_Transcaucasian_SFSR_(1930-1936)",
		name = "Emblem of the Transcaucasian SFSR (1930-1936)",
	},
	{
		file = "Emblem_of_the_Turkmen_SSR",
		name = "Emblem of the Turkmen SSR",
	},
	{
		file = "Emblem_of_the_Ukrainian_SSR",
		name = "Emblem of the Ukrainian SSR",
	},
	{
		file = "Emblem_of_the_Uzbek_SSR",
		name = "Emblem of the Uzbek SSR",
	},
	{
		file = "Emblem_of_Vietnam",
		name = "Emblem of Vietnam",
	},
	{
		file = "Flag_of_North_Korea",
		name = "Flag of North Korea",
	},
	{
		file = "Flag_of_the_Hungarian_Communist_Party",
		name = "Flag of the Hungarian Communist Party",
	},
	{
		file = "Flag_of_Union_State_Space_Agency",
		name = "Flag of Union State Space Agency",
	},
	{
		file = "Hammer_and_Sickle_Red",
		name = "Hammer and Sickle Red",
	},
	{
		file = "Ho_Chi_Minh",
		name = "Ho Chi Minh",
	},
	{
		file = "Interkosmos_Cuban_Stamp",
		name = "Interkosmos Cuban Stamp",
	},
	{
		file = "Interkosmos_Emblem",
		name = "Interkosmos Emblem",
	},
	{
		file = "Interkosmos_Emblem_1977",
		name = "Interkosmos Emblem 1977",
	},
	{
		file = "Interkosmos_Emblem_1980",
		name = "Interkosmos Emblem 1980",
	},
	{
		file = "Interkosmos_Emblem2",
		name = "Interkosmos Emblem2",
	},
	{
		file = "Interkosmos_Emblem3",
		name = "Interkosmos Emblem3",
	},
	{
		file = "Interkosmos_Patch_1980",
		name = "Interkosmos Patch 1980",
	},
	{
		file = "Interkosmos_Soyuz-31",
		name = "Interkosmos Soyuz-31",
	},
	{
		file = "Jordanian_Communist_Party",
		name = "Jordanian Communist Party",
	},
	{
		file = "Laika_Albania",
		name = "Laika Albania",
	},
	{
		file = "Laika_Husky",
		name = "Laika Husky",
	},
	{
		file = "Laika_Posta_Romana1959",
		name = "Laika Posta Romana (1959)",
	},
	{
		file = "Lebanese_Communist_Party",
		name = "Lebanese Communist Party",
	},
	{
		file = "Mexican_Communist_Party",
		name = "Mexican Communist Party",
	},
	{
		file = "New_Communist_Party_of_Britain",
		name = "New Communist Party of Britain",
	},
	{
		file = "Orden_Pobeda_Marshal_Vasilevsky",
		name = "Orden Pobeda Marshal Vasilevsky",
	},
	{
		file = "Partido_Comunista_de_Chile",
		name = "Partido Comunista de Chile",
	},
	{
		file = "Party_of_Italian_Communists",
		name = "Party of Italian Communists",
	},
	{
		file = "Party_of_Mexican_Communists",
		name = "Party of Mexican Communists",
	},
	{
		file = "Peoples_Party_of_Panama",
		name = "People's Party of Panama",
	},
	{
		file = "Pioneers_Pin",
		name = "Pioneers Pin",
	},
	{
		file = "Portuguese_Communist_Party",
		name = "Portuguese Communist Party",
	},
	{
		file = "Progressive_Party_of_Working_People_(Cyprus)",
		name = "Progressive Party of Working People (Cyprus)",
	},
	{
		file = "Red_Pride_Galaxywide",
		name = "Red Pride Galaxywide",
	},
	{
		file = "Redneck_Commies",
		name = "Redneck Commies",
	},
	{
		file = "Russian_Soviet_Federative_Socialist_Republic",
		name = "Russian Soviet Federative Socialist Republic",
	},
	{
		file = "South_African_Communist_Party",
		name = "South African Communist Party",
	},
	{
		file = "Space_Race",
		name = "Space Race",
	},
	{
		file = "Star_Golden_Border",
		name = "Star Golden Border",
	},
	{
		file = "Starry_Plough_flag_(1914)",
		name = "Starry Plough flag (1914)",
	},
	{
		file = "Swiss_Party_of_Labour",
		name = "Swiss Party of Labour",
	},
	{
		file = "Taiwan_Communist_Party",
		name = "Taiwan Communist Party",
	},
	{
		file = "The_Spectre_of_Communism",
		name = "The Spectre of Communism",
	},
	{
		file = "United_Socialist_States_of_America",
		name = "United Socialist States of America",
	},
	{
		file = "USSR",
		name = "USSR",
	},
	{
		file = "Warsaw_Pact",
		name = "Warsaw Pact",
	},
	{
		file = "Workers_of_the_World_Unite",
		name = "Workers of the World Unite",
	},
	{
		file = "Workers_Party_of_New_Zealand",
		name = "Workers Party of New Zealand",
	},
	{
		file = "Xi_Jinping",
		name = "Xi Jinping",
	},
	{
		file = "Zapatismo_Subcommandante_Marcos",
		name = "Zapatismo Subcommandante Marcos",
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

			local id = "CommieMarsLogos_" .. file
			if not MissionLogoPresetMap[id] then
				PlaceObj("MissionLogoPreset", {
					decal_entity = file,
					entity_name = file,
					display_name = "Commie Marx: " .. logo.name,
					id = id,
					image = logo_path .. file .. ".png",
				})
			end
		end
	end
end -- Postprocess
