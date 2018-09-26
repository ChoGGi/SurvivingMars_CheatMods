-- See LICENSE for terms

local LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]]

-- Everything stored in one global table
EveryFlagOnWikipedia = {
	_LICENSE = LICENSE,
	email = "SM_Mods@choggi.org",
	id = "ChoGGi_EveryFlagOnWikipedia",
	RandomBirthplace = true,
}

-- just in case anyone adds some custom HumanNames
function OnMsg.ModsReloaded()

	local AsyncRand = AsyncRand
	local HumanNames = HumanNames
	local Nations = Nations
	local path = table.concat{CurrentModPath,"Flags/flag_%s.tga"}

	-- get all human names then merge into one table and apply to all nations
	local name_table = {
		Family = {},
		Female = {
			-- Bulgarian and Russian (for now)
			Family = {},
		},
		Male = {
			Family = {},
		},
		-- add some extra names associated with space (loosely)
		Unique = {
			Female = {
				"Anna Fisher",
				"Christa McAuliffe",
				"Judith Resnik",
				"Kalpana Chawla",
				"Kathryn D. Sullivan",
				"Laurel B. Clark",
				"Sally Ride",
				"Svetlana Savitskaya",
				"Valentina Tereshkova",
			},
			Male = {
				"Adolf Thiel",
				"Alan T. Waterman",
				"Albert Zeiler",
				"Albin Wittmann",
				"Aleksandr Lyapunov",
				"Alexander Bolonkin",
				"Alexander Kemurdzhian",
				"Alexander M. Lippisch",
				"Andreas Alexandrakis",
				"Apollo M. O. Smith",
				"Arkady Ostashev",
				"Arthur Rudolph",
				"August Schulze",
				"Auguste Piccard",
				"Bernhard Tessmann",
				"Boris Chertok",
				"Charles Gifford",
				"Chuck Yeager",
				"Dieter Grau",
				"Dieter Huzel",
				"Dmitri Ilyich Kozlov",
				"Dmitry Okhotsimsky",
				"Eberhard Rees",
				"Edward S. Forman",
				"Erich W. Neubert",
				"Ernst Geissler",
				"Ernst R. G. Eckert",
				"Ernst Stuhlinger",
				"Eugene Saenger",
				"Frank Malina",
				"Fridtjof Speer",
				"Friedrich von Saurma",
				"Friedrich Zander",
				"Fritz Mueller",
				"Georg E. Knausenberger",
				"Georg Rickhey",
				"Georg von Tiesenhausen",
				"George Edward Pendray",
				"George H. Ludwig",
				"Georgy Babakin",
				"Gerhard Reisig",
				"Glenn L. Martin",
				"Guenter Wendt",
				"György Marx",
				"Hans Fichtner",
				"Hans Hosenthien",
				"Hans Hueter",
				"Hans Maus",
				"Hans R. Palaoro",
				"Harry Ruppe",
				"Harry W. Bull",
				"Heinz-Hermann Koelle",
				"Helmut Gröttrup",
				"Helmut Hölzer",
				"Helmut Zoike",
				"Herman Potočnik",
				"Hermann H. Kurzweg",
				"Hermann Oberth",
				"Hubert E. Kroh",
				"Igor Kurchatov",
				"Ivan Kleimenov",
				"Jack Parsons",
				"James Hart Wyld",
				"James Van Allen",
				"Jean d'Alembert",
				"Jean Piccard",
				"Jesco von Puttkamer",
				"Johannes Kepler",
				"John Bruce Medaris",
				"Joseph-Louis Lagrange",
				"Karl Heimburg",
				"Klaus Riedel",
				"Konrad Dannenberg",
				"Konstantin Tsiolkovsky",
				"Krafft Arnold Ehricke",
				"Kurt H. Debus",
				"Leonhard Euler",
				"Leonid A. Voskresenskiy",
				"Lovell Lawrence Jr.",
				"Ludwig Prandtl",
				"Ludwig Roth",
				"Martin Summerfield",
				"Mikhail B. Dobriyan",
				"Mikhail Gurevich",
				"Mikhail Tikhonravov",
				"Mikhail Yangel",
				"Milton Rosen",
				"Mstislav Keldysh",
				"Nikolay Pilyugin",
				"Oswald Lange",
				"Otto Hirschler",
				"Qian Xuesen",
				"Robert Esnault-Pelterie",
				"Robert H. Goddard",
				"Rudi Beichel",
				"Rudolf Nebel",
				"Sergei Korolev",
				"Theodor A. Poppel",
				"Theodor Karl Otto Vowe",
				"Theodore von Kármán",
				"Valentin Glushko",
				"Vasily Mishin",
				"Vladimir Chelomey",
				"Vladimir Komarov",
				"Vladimir Syromyatnikov",
				"Walter Dornberger",
				"Walter Häussermann",
				"Walter Riedel",
				"Walter Schwidetzky",
				"Walter Thiel",
				"Weld Arnold",
				"Werner Dahm",
				"Werner Kuers",
				"Werner Rosinski",
				"Wernher von Braun",
				"Wilhelm Jungert",
				"William Mrazek",
				"William Pickering",
				"Willy Ley",
				"Willy Mrazek",
				"Yevgeny Ostashev",
				"Yuri Gagarin",
				"Yuri Shargin",
			},
		},
	}

	-- loop through each nation group
	for Name_R,Race in pairs(HumanNames) do
		-- then each type of name Family,Female,Male,Unique
		for Type,Names in pairs(Race) do

			if Type == "Unique" then
				for Type2,Names2 in pairs(Names) do
					for i = 1, #Names2 do
						name_table[Type][Type2][#name_table[Type][Type2]+1] = Names2[i]
					end
				end

			-- Bulgarian and Russian both have extra tables added
			elseif Name_R == "Bulgarian" or Name_R == "Russian" then
				for Type2,Names2 in pairs(Names) do
					if Type2 == "First" then
						for i = 1, #Names2 do
							name_table[Type][#name_table[Type]+1] = Names2[i]
						end
					else
						for i = 1, #Names2 do
							name_table[Type][Type2][#name_table[Type][Type2]+1] = Names2[i]
						end
					end
				end

			else -- regular names (Female,Male,Family)
				for i = 1, #Names do
					name_table[Type][#name_table[Type]+1] = Names[i]
				end
			end

		end
	end

	-- instead of just replacing the orig table we add on to it (just in case more nations are added, maybe by another mod)
	local c = #Nations

	c = c + 1
	Nations[c] = {
		value = "abkhazia",
		text = "Abkhazia",
		flag = path:format("abkhazia"),
	}
	c = c + 1
	Nations[c] = {
		value = "afghanistan",
		text = "Afghanistan",
		flag = path:format("afghanistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "aland",
		text = "Aland",
		flag = path:format("aland"),
	}
	c = c + 1
	Nations[c] = {
		value = "alaska",
		text = "Alaska",
		flag = path:format("alaska"),
	}
	c = c + 1
	Nations[c] = {
		value = "albania",
		text = "Albania",
		flag = path:format("albania"),
	}
	c = c + 1
	Nations[c] = {
		value = "alderney",
		text = "Alderney",
		flag = path:format("alderney"),
	}
	c = c + 1
	Nations[c] = {
		value = "algeria",
		text = "Algeria",
		flag = path:format("algeria"),
	}
	c = c + 1
	Nations[c] = {
		value = "american_samoa",
		text = "American Samoa",
		flag = path:format("american_samoa"),
	}
	c = c + 1
	Nations[c] = {
		value = "andorra",
		text = "Andorra",
		flag = path:format("andorra"),
	}
	c = c + 1
	Nations[c] = {
		value = "angola",
		text = "Angola",
		flag = path:format("angola"),
	}
	c = c + 1
	Nations[c] = {
		value = "anguilla",
		text = "Anguilla",
		flag = path:format("anguilla"),
	}
	c = c + 1
	Nations[c] = {
		value = "anjouan",
		text = "Anjouan",
		flag = path:format("anjouan"),
	}
	c = c + 1
	Nations[c] = {
		value = "antigua_and_barbuda",
		text = "Antigua And Barbuda",
		flag = path:format("antigua_and_barbuda"),
	}
	c = c + 1
	Nations[c] = {
		value = "argentina",
		text = "Argentina",
		flag = path:format("argentina"),
	}
	c = c + 1
	Nations[c] = {
		value = "armenia",
		text = "Armenia",
		flag = path:format("armenia"),
	}
	c = c + 1
	Nations[c] = {
		value = "artsakh",
		text = "Artsakh",
		flag = path:format("artsakh"),
	}
	c = c + 1
	Nations[c] = {
		value = "aruba",
		text = "Aruba",
		flag = path:format("aruba"),
	}
	c = c + 1
	Nations[c] = {
		value = "ascension_island",
		text = "Ascension Island",
		flag = path:format("ascension_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "ashanti",
		text = "Ashanti",
		flag = path:format("ashanti"),
	}
	c = c + 1
	Nations[c] = {
		value = "australia",
		text = "Australia",
		flag = path:format("australia"),
	}
	c = c + 1
	Nations[c] = {
		value = "austria-hungary",
		text = "Austria-hungary",
		flag = path:format("austria-hungary"),
	}
	c = c + 1
	Nations[c] = {
		value = "austria",
		text = "Austria",
		flag = path:format("austria"),
	}
	c = c + 1
	Nations[c] = {
		value = "azerbaijan",
		text = "Azerbaijan",
		flag = path:format("azerbaijan"),
	}
	c = c + 1
	Nations[c] = {
		value = "bahrain",
		text = "Bahrain",
		flag = path:format("bahrain"),
	}
	c = c + 1
	Nations[c] = {
		value = "balawaristan",
		text = "Balawaristan",
		flag = path:format("balawaristan"),
	}
	c = c + 1
	Nations[c] = {
		value = "bamileke_national_movement",
		text = "Bamileke National Movement",
		flag = path:format("bamileke_national_movement"),
	}
	c = c + 1
	Nations[c] = {
		value = "bangladesh",
		text = "Bangladesh",
		flag = path:format("bangladesh"),
	}
	c = c + 1
	Nations[c] = {
		value = "barbados",
		text = "Barbados",
		flag = path:format("barbados"),
	}
	c = c + 1
	Nations[c] = {
		value = "bavaria",
		text = "Bavaria",
		flag = path:format("bavaria"),
	}
	c = c + 1
	Nations[c] = {
		value = "belarus",
		text = "Belarus",
		flag = path:format("belarus"),
	}
	c = c + 1
	Nations[c] = {
		value = "belgium",
		text = "Belgium",
		flag = path:format("belgium"),
	}
	c = c + 1
	Nations[c] = {
		value = "belize",
		text = "Belize",
		flag = path:format("belize"),
	}
	c = c + 1
	Nations[c] = {
		value = "benin",
		text = "Benin",
		flag = path:format("benin"),
	}
	c = c + 1
	Nations[c] = {
		value = "bermuda",
		text = "Bermuda",
		flag = path:format("bermuda"),
	}
	c = c + 1
	Nations[c] = {
		value = "bhutan",
		text = "Bhutan",
		flag = path:format("bhutan"),
	}
	c = c + 1
	Nations[c] = {
		value = "biafra",
		text = "Biafra",
		flag = path:format("biafra"),
	}
	c = c + 1
	Nations[c] = {
		value = "bolivia",
		text = "Bolivia",
		flag = path:format("bolivia"),
	}
	c = c + 1
	Nations[c] = {
		value = "bonaire",
		text = "Bonaire",
		flag = path:format("bonaire"),
	}
	c = c + 1
	Nations[c] = {
		value = "bonnie_blue_flag_the_confederate_states_of_america",
		text = "Bonnie Blue Flag The Confederate States Of America",
		flag = path:format("bonnie_blue_flag_the_confederate_states_of_america"),
	}
	c = c + 1
	Nations[c] = {
		value = "bophuthatswana",
		text = "Bophuthatswana",
		flag = path:format("bophuthatswana"),
	}
	c = c + 1
	Nations[c] = {
		value = "bora_bora",
		text = "Bora Bora",
		flag = path:format("bora_bora"),
	}
	c = c + 1
	Nations[c] = {
		value = "bosnia_and_herzegovina",
		text = "Bosnia And Herzegovina",
		flag = path:format("bosnia_and_herzegovina"),
	}
	c = c + 1
	Nations[c] = {
		value = "botswana",
		text = "Botswana",
		flag = path:format("botswana"),
	}
	c = c + 1
	Nations[c] = {
		value = "bougainville",
		text = "Bougainville",
		flag = path:format("bougainville"),
	}
	c = c + 1
	Nations[c] = {
		value = "brazil",
		text = "Brazil",
		flag = path:format("brazil"),
	}
	c = c + 1
	Nations[c] = {
		value = "brittany",
		text = "Brittany",
		flag = path:format("brittany"),
	}
	c = c + 1
	Nations[c] = {
		value = "brunei",
		text = "Brunei",
		flag = path:format("brunei"),
	}
	c = c + 1
	Nations[c] = {
		value = "bulgaria",
		text = "Bulgaria",
		flag = path:format("bulgaria"),
	}
	c = c + 1
	Nations[c] = {
		value = "bumbunga",
		text = "Bumbunga",
		flag = path:format("bumbunga"),
	}
	c = c + 1
	Nations[c] = {
		value = "burkina_faso",
		text = "Burkina Faso",
		flag = path:format("burkina_faso"),
	}
	c = c + 1
	Nations[c] = {
		value = "burundi",
		text = "Burundi",
		flag = path:format("burundi"),
	}
	c = c + 1
	Nations[c] = {
		value = "byelorussian_ssr",
		text = "Byelorussian SSR",
		flag = path:format("byelorussian_ssr"),
	}
	c = c + 1
	Nations[c] = {
		value = "cabinda",
		text = "Cabinda",
		flag = path:format("cabinda"),
	}
	c = c + 1
	Nations[c] = {
		value = "california",
		text = "California",
		flag = path:format("california"),
	}
	c = c + 1
	Nations[c] = {
		value = "california_independence",
		text = "California Independence",
		flag = path:format("california_independence"),
	}
	c = c + 1
	Nations[c] = {
		value = "cambodia",
		text = "Cambodia",
		flag = path:format("cambodia"),
	}
	c = c + 1
	Nations[c] = {
		value = "cameroon",
		text = "Cameroon",
		flag = path:format("cameroon"),
	}
	c = c + 1
	Nations[c] = {
		value = "canada",
		text = "Canada",
		flag = path:format("canada"),
	}
	c = c + 1
	Nations[c] = {
		value = "cantabrian_labaru",
		text = "Cantabrian Labaru",
		flag = path:format("cantabrian_labaru"),
	}
	c = c + 1
	Nations[c] = {
		value = "canu",
		text = "Canu",
		flag = path:format("canu"),
	}
	c = c + 1
	Nations[c] = {
		value = "cape_verde",
		text = "Cape Verde",
		flag = path:format("cape_verde"),
	}
	c = c + 1
	Nations[c] = {
		value = "casamance",
		text = "Casamance",
		flag = path:format("casamance"),
	}
	c = c + 1
	Nations[c] = {
		value = "cascadia",
		text = "Cascadia",
		flag = path:format("cascadia"),
	}
	c = c + 1
	Nations[c] = {
		value = "castile",
		text = "Castile",
		flag = path:format("castile"),
	}
	c = c + 1
	Nations[c] = {
		value = "chad",
		text = "Chad",
		flag = path:format("chad"),
	}
	c = c + 1
	Nations[c] = {
		value = "chechen_republic_of_ichkeria",
		text = "Chechen Republic Of Ichkeria",
		flag = path:format("chechen_republic_of_ichkeria"),
	}
	c = c + 1
	Nations[c] = {
		value = "chile",
		text = "Chile",
		flag = path:format("chile"),
	}
	c = c + 1
	Nations[c] = {
		value = "chin_national_front",
		text = "Chin National Front",
		flag = path:format("chin_national_front"),
	}
	c = c + 1
	Nations[c] = {
		value = "christmas_island",
		text = "Christmas Island",
		flag = path:format("christmas_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "ciskei",
		text = "Ciskei",
		flag = path:format("ciskei"),
	}
	c = c + 1
	Nations[c] = {
		value = "colombia",
		text = "Colombia",
		flag = path:format("colombia"),
	}
	c = c + 1
	Nations[c] = {
		value = "cornwall",
		text = "Cornwall",
		flag = path:format("cornwall"),
	}
	c = c + 1
	Nations[c] = {
		value = "corsica",
		text = "Corsica",
		flag = path:format("corsica"),
	}
	c = c + 1
	Nations[c] = {
		value = "cospaia",
		text = "Cospaia",
		flag = path:format("cospaia"),
	}
	c = c + 1
	Nations[c] = {
		value = "costa_rica",
		text = "Costa Rica",
		flag = path:format("costa_rica"),
	}
	c = c + 1
	Nations[c] = {
		value = "cote_divoire",
		text = "Cote Divoire",
		flag = path:format("cote_divoire"),
	}
	c = c + 1
	Nations[c] = {
		value = "cretan_state",
		text = "Cretan State",
		flag = path:format("cretan_state"),
	}
	c = c + 1
	Nations[c] = {
		value = "crimea",
		text = "Crimea",
		flag = path:format("crimea"),
	}
	c = c + 1
	Nations[c] = {
		value = "croatia",
		text = "Croatia",
		flag = path:format("croatia"),
	}
	c = c + 1
	Nations[c] = {
		value = "cuba",
		text = "Cuba",
		flag = path:format("cuba"),
	}
	c = c + 1
	Nations[c] = {
		value = "curacao",
		text = "Curacao",
		flag = path:format("curacao"),
	}
	c = c + 1
	Nations[c] = {
		value = "cyprus",
		text = "Cyprus",
		flag = path:format("cyprus"),
	}
	c = c + 1
	Nations[c] = {
		value = "dar_el_kuti_republic",
		text = "Dar El Kuti Republic",
		flag = path:format("dar_el_kuti_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "denmark",
		text = "Denmark",
		flag = path:format("denmark"),
	}
	c = c + 1
	Nations[c] = {
		value = "djibouti",
		text = "Djibouti",
		flag = path:format("djibouti"),
	}
	c = c + 1
	Nations[c] = {
		value = "dominica",
		text = "Dominica",
		flag = path:format("dominica"),
	}
	c = c + 1
	Nations[c] = {
		value = "donetsk_oblast",
		text = "Donetsk Oblast",
		flag = path:format("donetsk_oblast"),
	}
	c = c + 1
	Nations[c] = {
		value = "eastern_rumelia",
		text = "Eastern Rumelia",
		flag = path:format("eastern_rumelia"),
	}
	c = c + 1
	Nations[c] = {
		value = "easter_island",
		text = "Easter Island",
		flag = path:format("easter_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "east_germany",
		text = "East Germany",
		flag = path:format("east_germany"),
	}
	c = c + 1
	Nations[c] = {
		value = "east_timor",
		text = "East Timor",
		flag = path:format("east_timor"),
	}
	c = c + 1
	Nations[c] = {
		value = "ecuador",
		text = "Ecuador",
		flag = path:format("ecuador"),
	}
	c = c + 1
	Nations[c] = {
		value = "egypt",
		text = "Egypt",
		flag = path:format("egypt"),
	}
	c = c + 1
	Nations[c] = {
		value = "el_salvador",
		text = "El Salvador",
		flag = path:format("el_salvador"),
	}
	c = c + 1
	Nations[c] = {
		value = "enenkio",
		text = "Enenkio",
		flag = path:format("enenkio"),
	}
	c = c + 1
	Nations[c] = {
		value = "england",
		text = "England",
		flag = path:format("england"),
	}
	c = c + 1
	Nations[c] = {
		value = "equatorial_guinea",
		text = "Equatorial Guinea",
		flag = path:format("equatorial_guinea"),
	}
	c = c + 1
	Nations[c] = {
		value = "eritrea",
		text = "Eritrea",
		flag = path:format("eritrea"),
	}
	c = c + 1
	Nations[c] = {
		value = "estonia",
		text = "Estonia",
		flag = path:format("estonia"),
	}
	c = c + 1
	Nations[c] = {
		value = "ethiopia",
		text = "Ethiopia",
		flag = path:format("ethiopia"),
	}
	c = c + 1
	Nations[c] = {
		value = "evis",
		text = "Evis",
		flag = path:format("evis"),
	}
	c = c + 1
	Nations[c] = {
		value = "fiji",
		text = "Fiji",
		flag = path:format("fiji"),
	}
	c = c + 1
	Nations[c] = {
		value = "finland",
		text = "Finland",
		flag = path:format("finland"),
	}
	c = c + 1
	Nations[c] = {
		value = "flnks",
		text = "Front de Libération Nationale Kanak et Socialiste",
		flag = path:format("flnks"),
	}
	c = c + 1
	Nations[c] = {
		value = "forcas_and_careiras",
		text = "Forcas And Careiras",
		flag = path:format("forcas_and_careiras"),
	}
	c = c + 1
	Nations[c] = {
		value = "formosa",
		text = "Formosa",
		flag = path:format("formosa"),
	}
	c = c + 1
	Nations[c] = {
		value = "france",
		text = "France",
		flag = path:format("france"),
	}
	c = c + 1
	Nations[c] = {
		value = "franceville",
		text = "Franceville",
		flag = path:format("franceville"),
	}
	c = c + 1
	Nations[c] = {
		value = "free_aceh_movement",
		text = "Free Aceh Movement",
		flag = path:format("free_aceh_movement"),
	}
	c = c + 1
	Nations[c] = {
		value = "free_morbhan_republic",
		text = "Free Morbhan Republic",
		flag = path:format("free_morbhan_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "free_territory_trieste",
		text = "Free Territory Trieste",
		flag = path:format("free_territory_trieste"),
	}
	c = c + 1
	Nations[c] = {
		value = "french_guiana",
		text = "French Guiana",
		flag = path:format("french_guiana"),
	}
	c = c + 1
	Nations[c] = {
		value = "french_polynesia",
		text = "French Polynesia",
		flag = path:format("french_polynesia"),
	}
	c = c + 1
	Nations[c] = {
		value = "gabon",
		text = "Gabon",
		flag = path:format("gabon"),
	}
	c = c + 1
	Nations[c] = {
		value = "gdansk",
		text = "Gdansk",
		flag = path:format("gdansk"),
	}
	c = c + 1
	Nations[c] = {
		value = "genoa",
		text = "Genoa",
		flag = path:format("genoa"),
	}
	c = c + 1
	Nations[c] = {
		value = "georgia",
		text = "Georgia",
		flag = path:format("georgia"),
	}
	c = c + 1
	Nations[c] = {
		value = "germany",
		text = "Germany",
		flag = path:format("germany"),
	}
	c = c + 1
	Nations[c] = {
		value = "ghana",
		text = "Ghana",
		flag = path:format("ghana"),
	}
	c = c + 1
	Nations[c] = {
		value = "gibraltar",
		text = "Gibraltar",
		flag = path:format("gibraltar"),
	}
	c = c + 1
	Nations[c] = {
		value = "greece",
		text = "Greece",
		flag = path:format("greece"),
	}
	c = c + 1
	Nations[c] = {
		value = "greenland",
		text = "Greenland",
		flag = path:format("greenland"),
	}
	c = c + 1
	Nations[c] = {
		value = "grenada",
		text = "Grenada",
		flag = path:format("grenada"),
	}
	c = c + 1
	Nations[c] = {
		value = "grobherzogtum_baden",
		text = "Grobherzogtum Baden",
		flag = path:format("grobherzogtum_baden"),
	}
	c = c + 1
	Nations[c] = {
		value = "grobherzogtum_hessen_ohne_wappen",
		text = "Grobherzogtum Hessen Ohne Wappen",
		flag = path:format("grobherzogtum_hessen_ohne_wappen"),
	}
	c = c + 1
	Nations[c] = {
		value = "guadeloupe",
		text = "Guadeloupe",
		flag = path:format("guadeloupe"),
	}
	c = c + 1
	Nations[c] = {
		value = "guam",
		text = "Guam",
		flag = path:format("guam"),
	}
	c = c + 1
	Nations[c] = {
		value = "guangdong",
		text = "Guangdong",
		flag = path:format("guangdong"),
	}
	c = c + 1
	Nations[c] = {
		value = "guatemala",
		text = "Guatemala",
		flag = path:format("guatemala"),
	}
	c = c + 1
	Nations[c] = {
		value = "guernsey",
		text = "Guernsey",
		flag = path:format("guernsey"),
	}
	c = c + 1
	Nations[c] = {
		value = "guinea-bissau",
		text = "Guinea-bissau",
		flag = path:format("guinea-bissau"),
	}
	c = c + 1
	Nations[c] = {
		value = "guinea",
		text = "Guinea",
		flag = path:format("guinea"),
	}
	c = c + 1
	Nations[c] = {
		value = "gurkhaland",
		text = "Gurkhaland",
		flag = path:format("gurkhaland"),
	}
	c = c + 1
	Nations[c] = {
		value = "guyana",
		text = "Guyana",
		flag = path:format("guyana"),
	}
	c = c + 1
	Nations[c] = {
		value = "gwynedd",
		text = "Gwynedd",
		flag = path:format("gwynedd"),
	}
	c = c + 1
	Nations[c] = {
		value = "haiti",
		text = "Haiti",
		flag = path:format("haiti"),
	}
	c = c + 1
	Nations[c] = {
		value = "hawaii",
		text = "Hawaii",
		flag = path:format("hawaii"),
	}
	c = c + 1
	Nations[c] = {
		value = "hejaz",
		text = "Hejaz",
		flag = path:format("hejaz"),
	}
	c = c + 1
	Nations[c] = {
		value = "honduras",
		text = "Honduras",
		flag = path:format("honduras"),
	}
	c = c + 1
	Nations[c] = {
		value = "hong_kong",
		text = "Hong Kong",
		flag = path:format("hong_kong"),
	}
	c = c + 1
	Nations[c] = {
		value = "huahine",
		text = "Huahine",
		flag = path:format("huahine"),
	}
	c = c + 1
	Nations[c] = {
		value = "hungary",
		text = "Hungary",
		flag = path:format("hungary"),
	}
	c = c + 1
	Nations[c] = {
		value = "hyderabad_state",
		text = "Hyderabad State",
		flag = path:format("hyderabad_state"),
	}
	c = c + 1
	Nations[c] = {
		value = "iceland",
		text = "Iceland",
		flag = path:format("iceland"),
	}
	c = c + 1
	Nations[c] = {
		value = "idel-ural_state",
		text = "Idel-ural State",
		flag = path:format("idel-ural_state"),
	}
	c = c + 1
	Nations[c] = {
		value = "independent_state_of_croatia",
		text = "Independent State Of Croatia",
		flag = path:format("independent_state_of_croatia"),
	}
	c = c + 1
	Nations[c] = {
		value = "india",
		text = "India",
		flag = path:format("india"),
	}
	c = c + 1
	Nations[c] = {
		value = "indonesia",
		text = "Indonesia",
		flag = path:format("indonesia"),
	}
	c = c + 1
	Nations[c] = {
		value = "iran",
		text = "Iran",
		flag = path:format("iran"),
	}
	c = c + 1
	Nations[c] = {
		value = "iraq",
		text = "Iraq",
		flag = path:format("iraq"),
	}
	c = c + 1
	Nations[c] = {
		value = "ireland",
		text = "Ireland",
		flag = path:format("ireland"),
	}
	c = c + 1
	Nations[c] = {
		value = "israel",
		text = "Israel",
		flag = path:format("israel"),
	}
	c = c + 1
	Nations[c] = {
		value = "italy",
		text = "Italy",
		flag = path:format("italy"),
	}
	c = c + 1
	Nations[c] = {
		value = "jamaica",
		text = "Jamaica",
		flag = path:format("jamaica"),
	}
	c = c + 1
	Nations[c] = {
		value = "japan",
		text = "Japan",
		flag = path:format("japan"),
	}
	c = c + 1
	Nations[c] = {
		value = "jersey",
		text = "Jersey",
		flag = path:format("jersey"),
	}
	c = c + 1
	Nations[c] = {
		value = "johnston_atoll",
		text = "Johnston Atoll",
		flag = path:format("johnston_atoll"),
	}
	c = c + 1
	Nations[c] = {
		value = "jordan",
		text = "Jordan",
		flag = path:format("jordan"),
	}
	c = c + 1
	Nations[c] = {
		value = "kapok",
		text = "Kapok",
		flag = path:format("kapok"),
	}
	c = c + 1
	Nations[c] = {
		value = "karen_national_liberation_army",
		text = "Karen National Liberation Army",
		flag = path:format("karen_national_liberation_army"),
	}
	c = c + 1
	Nations[c] = {
		value = "karen_national_union",
		text = "Karen National Union",
		flag = path:format("karen_national_union"),
	}
	c = c + 1
	Nations[c] = {
		value = "katanga",
		text = "Katanga",
		flag = path:format("katanga"),
	}
	c = c + 1
	Nations[c] = {
		value = "kazakhstan",
		text = "Kazakhstan",
		flag = path:format("kazakhstan"),
	}
	c = c + 1
	Nations[c] = {
		value = "kenya",
		text = "Kenya",
		flag = path:format("kenya"),
	}
	c = c + 1
	Nations[c] = {
		value = "khalistans",
		text = "Khalistans",
		flag = path:format("khalistans"),
	}
	c = c + 1
	Nations[c] = {
		value = "kingdom_of_kurdistan",
		text = "Kingdom Of Kurdistan",
		flag = path:format("kingdom_of_kurdistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "kiribati",
		text = "Kiribati",
		flag = path:format("kiribati"),
	}
	c = c + 1
	Nations[c] = {
		value = "khmers_kampuchea_krom",
		text = "Khmers Kampuchea-Krom",
		flag = path:format("khmers_kampuchea_krom"),
	}
	c = c + 1
	Nations[c] = {
		value = "kokbayraq",
		text = "Kokbayraq",
		flag = path:format("kokbayraq"),
	}
	c = c + 1
	Nations[c] = {
		value = "konigreich_wurttemberg",
		text = "Konigreich Wurttemberg",
		flag = path:format("konigreich_wurttemberg"),
	}
	c = c + 1
	Nations[c] = {
		value = "kosovo",
		text = "Kosovo",
		flag = path:format("kosovo"),
	}
	c = c + 1
	Nations[c] = {
		value = "krusevo_republic",
		text = "Krusevo Republic",
		flag = path:format("krusevo_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "kuban_people's_republic",
		text = "Kuban People's Republic",
		flag = path:format("kuban_people's_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "kurdistan",
		text = "Kurdistan",
		flag = path:format("kurdistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "kuwait",
		text = "Kuwait",
		flag = path:format("kuwait"),
	}
	c = c + 1
	Nations[c] = {
		value = "kyrgyzstan",
		text = "Kyrgyzstan",
		flag = path:format("kyrgyzstan"),
	}
	c = c + 1
	Nations[c] = {
		value = "ladonia",
		text = "Ladonia",
		flag = path:format("ladonia"),
	}
	c = c + 1
	Nations[c] = {
		value = "laos",
		text = "Laos",
		flag = path:format("laos"),
	}
	c = c + 1
	Nations[c] = {
		value = "latvia",
		text = "Latvia",
		flag = path:format("latvia"),
	}
	c = c + 1
	Nations[c] = {
		value = "lebanon",
		text = "Lebanon",
		flag = path:format("lebanon"),
	}
	c = c + 1
	Nations[c] = {
		value = "lesotho",
		text = "Lesotho",
		flag = path:format("lesotho"),
	}
	c = c + 1
	Nations[c] = {
		value = "liberia",
		text = "Liberia",
		flag = path:format("liberia"),
	}
	c = c + 1
	Nations[c] = {
		value = "libya",
		text = "Libya",
		flag = path:format("libya"),
	}
	c = c + 1
	Nations[c] = {
		value = "liechtenstein",
		text = "Liechtenstein",
		flag = path:format("liechtenstein"),
	}
	c = c + 1
	Nations[c] = {
		value = "lithuania",
		text = "Lithuania",
		flag = path:format("lithuania"),
	}
	c = c + 1
	Nations[c] = {
		value = "lorraine",
		text = "Lorraine",
		flag = path:format("lorraine"),
	}
	c = c + 1
	Nations[c] = {
		value = "los_altos",
		text = "Los Altos",
		flag = path:format("los_altos"),
	}
	c = c + 1
	Nations[c] = {
		value = "luxembourg",
		text = "Luxembourg",
		flag = path:format("luxembourg"),
	}
	c = c + 1
	Nations[c] = {
		value = "macau",
		text = "Macau",
		flag = path:format("macau"),
	}
	c = c + 1
	Nations[c] = {
		value = "macedonia",
		text = "Macedonia",
		flag = path:format("macedonia"),
	}
	c = c + 1
	Nations[c] = {
		value = "madagascar",
		text = "Madagascar",
		flag = path:format("madagascar"),
	}
	c = c + 1
	Nations[c] = {
		value = "magallanes",
		text = "Magallanes",
		flag = path:format("magallanes"),
	}
	c = c + 1
	Nations[c] = {
		value = "maguindanao",
		text = "Maguindanao",
		flag = path:format("maguindanao"),
	}
	c = c + 1
	Nations[c] = {
		value = "malawi",
		text = "Malawi",
		flag = path:format("malawi"),
	}
	c = c + 1
	Nations[c] = {
		value = "malaysia",
		text = "Malaysia",
		flag = path:format("malaysia"),
	}
	c = c + 1
	Nations[c] = {
		value = "maldives",
		text = "Maldives",
		flag = path:format("maldives"),
	}
	c = c + 1
	Nations[c] = {
		value = "mali",
		text = "Mali",
		flag = path:format("mali"),
	}
	c = c + 1
	Nations[c] = {
		value = "malta",
		text = "Malta",
		flag = path:format("malta"),
	}
	c = c + 1
	Nations[c] = {
		value = "manchukuo",
		text = "Manchukuo",
		flag = path:format("manchukuo"),
	}
	c = c + 1
	Nations[c] = {
		value = "mauritania",
		text = "Mauritania",
		flag = path:format("mauritania"),
	}
	c = c + 1
	Nations[c] = {
		value = "mauritius",
		text = "Mauritius",
		flag = path:format("mauritius"),
	}
	c = c + 1
	Nations[c] = {
		value = "mayotte",
		text = "Mayotte",
		flag = path:format("mayotte"),
	}
	c = c + 1
	Nations[c] = {
		value = "merina_kingdom",
		text = "Merina Kingdom",
		flag = path:format("merina_kingdom"),
	}
	c = c + 1
	Nations[c] = {
		value = "mexico",
		text = "Mexico",
		flag = path:format("mexico"),
	}
	c = c + 1
	Nations[c] = {
		value = "minerva",
		text = "Minerva",
		flag = path:format("minerva"),
	}
	c = c + 1
	Nations[c] = {
		value = "azawad_national_liberation_movement",
		text = "Azawad National Liberation Movement",
		flag = path:format("azawad_national_liberation_movement"),
	}
	c = c + 1
	Nations[c] = {
		value = "moro_national_liberation_front",
		text = "Moro National Liberation Front",
		flag = path:format("moro_national_liberation_front"),
	}
	c = c + 1
	Nations[c] = {
		value = "moheli",
		text = "Moheli",
		flag = path:format("moheli"),
	}
	c = c + 1
	Nations[c] = {
		value = "moldova",
		text = "Moldova",
		flag = path:format("moldova"),
	}
	c = c + 1
	Nations[c] = {
		value = "monaco",
		text = "Monaco",
		flag = path:format("monaco"),
	}
	c = c + 1
	Nations[c] = {
		value = "mongolia",
		text = "Mongolia",
		flag = path:format("mongolia"),
	}
	c = c + 1
	Nations[c] = {
		value = "montenegro",
		text = "Montenegro",
		flag = path:format("montenegro"),
	}
	c = c + 1
	Nations[c] = {
		value = "montserrat",
		text = "Montserrat",
		flag = path:format("montserrat"),
	}
	c = c + 1
	Nations[c] = {
		value = "morning_star",
		text = "Morning Star",
		flag = path:format("morning_star"),
	}
	c = c + 1
	Nations[c] = {
		value = "morocco",
		text = "Morocco",
		flag = path:format("morocco"),
	}
	c = c + 1
	Nations[c] = {
		value = "most_serene_republic_of_venice",
		text = "Most Serene Republic Of Venice",
		flag = path:format("most_serene_republic_of_venice"),
	}
	c = c + 1
	Nations[c] = {
		value = "mozambique",
		text = "Mozambique",
		flag = path:format("mozambique"),
	}
	c = c + 1
	Nations[c] = {
		value = "murrawarri_republic",
		text = "Murrawarri Republic",
		flag = path:format("murrawarri_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "myanmar",
		text = "Myanmar",
		flag = path:format("myanmar"),
	}
	c = c + 1
	Nations[c] = {
		value = "namibia",
		text = "Namibia",
		flag = path:format("namibia"),
	}
	c = c + 1
	Nations[c] = {
		value = "natalia_republic",
		text = "Natalia Republic",
		flag = path:format("natalia_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "nauru",
		text = "Nauru",
		flag = path:format("nauru"),
	}
	c = c + 1
	Nations[c] = {
		value = "navassa_island",
		text = "Navassa Island",
		flag = path:format("navassa_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "nejd",
		text = "Nejd",
		flag = path:format("nejd"),
	}
	c = c + 1
	Nations[c] = {
		value = "nepal",
		text = "Nepal",
		flag = path:format("nepal"),
	}
	c = c + 1
	Nations[c] = {
		value = "new_mon_state_party",
		text = "New Mon State Party",
		flag = path:format("new_mon_state_party"),
	}
	c = c + 1
	Nations[c] = {
		value = "new_zealand",
		text = "New Zealand",
		flag = path:format("new_zealand"),
	}
	c = c + 1
	Nations[c] = {
		value = "new_zealand_south_island",
		text = "New Zealand South Island",
		flag = path:format("new_zealand_south_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "nicaragua",
		text = "Nicaragua",
		flag = path:format("nicaragua"),
	}
	c = c + 1
	Nations[c] = {
		value = "niger",
		text = "Niger",
		flag = path:format("niger"),
	}
	c = c + 1
	Nations[c] = {
		value = "nigeria",
		text = "Nigeria",
		flag = path:format("nigeria"),
	}
	c = c + 1
	Nations[c] = {
		value = "niue",
		text = "Niue",
		flag = path:format("niue"),
	}
	c = c + 1
	Nations[c] = {
		value = "norfolk_island",
		text = "Norfolk Island",
		flag = path:format("norfolk_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "north_korea",
		text = "North Korea",
		flag = path:format("north_korea"),
	}
	c = c + 1
	Nations[c] = {
		value = "norway",
		text = "Norway",
		flag = path:format("norway"),
	}
	c = c + 1
	Nations[c] = {
		value = "occitania",
		text = "Occitania",
		flag = path:format("occitania"),
	}
	c = c + 1
	Nations[c] = {
		value = "ogaden_national_liberation_front",
		text = "Ogaden National Liberation Front",
		flag = path:format("ogaden_national_liberation_front"),
	}
	c = c + 1
	Nations[c] = {
		value = "oman",
		text = "Oman",
		flag = path:format("oman"),
	}
	c = c + 1
	Nations[c] = {
		value = "ottoman_alternative",
		text = "Ottoman Alternative",
		flag = path:format("ottoman_alternative"),
	}
	c = c + 1
	Nations[c] = {
		value = "padania",
		text = "Padania",
		flag = path:format("padania"),
	}
	c = c + 1
	Nations[c] = {
		value = "pakistan",
		text = "Pakistan",
		flag = path:format("pakistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "palau",
		text = "Palau",
		flag = path:format("palau"),
	}
	c = c + 1
	Nations[c] = {
		value = "palestine",
		text = "Palestine",
		flag = path:format("palestine"),
	}
	c = c + 1
	Nations[c] = {
		value = "palmyra_atoll",
		text = "Palmyra Atoll",
		flag = path:format("palmyra_atoll"),
	}
	c = c + 1
	Nations[c] = {
		value = "panama",
		text = "Panama",
		flag = path:format("panama"),
	}
	c = c + 1
	Nations[c] = {
		value = "papua_new_guinea",
		text = "Papua New Guinea",
		flag = path:format("papua_new_guinea"),
	}
	c = c + 1
	Nations[c] = {
		value = "paraguay",
		text = "Paraguay",
		flag = path:format("paraguay"),
	}
	c = c + 1
	Nations[c] = {
		value = "pattani",
		text = "Pattani",
		flag = path:format("pattani"),
	}
	c = c + 1
	Nations[c] = {
		value = "pernambucan_revolt",
		text = "Pernambucan Revolt",
		flag = path:format("pernambucan_revolt"),
	}
	c = c + 1
	Nations[c] = {
		value = "peru",
		text = "Peru",
		flag = path:format("peru"),
	}
	c = c + 1
	Nations[c] = {
		value = "piratini_republic",
		text = "Piratini Republic",
		flag = path:format("piratini_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "poland",
		text = "Poland",
		flag = path:format("poland"),
	}
	c = c + 1
	Nations[c] = {
		value = "porto_claro",
		text = "Porto Claro",
		flag = path:format("porto_claro"),
	}
	c = c + 1
	Nations[c] = {
		value = "portugal",
		text = "Portugal",
		flag = path:format("portugal"),
	}
	c = c + 1
	Nations[c] = {
		value = "portugalicia",
		text = "Portugalicia",
		flag = path:format("portugalicia"),
	}
	c = c + 1
	Nations[c] = {
		value = "puerto_rico",
		text = "Puerto Rico",
		flag = path:format("puerto_rico"),
	}
	c = c + 1
	Nations[c] = {
		value = "qatar",
		text = "Qatar",
		flag = path:format("qatar"),
	}
	c = c + 1
	Nations[c] = {
		value = "quebec",
		text = "Quebec",
		flag = path:format("quebec"),
	}
	c = c + 1
	Nations[c] = {
		value = "raiatea",
		text = "Raiatea",
		flag = path:format("raiatea"),
	}
	c = c + 1
	Nations[c] = {
		value = "rainbowcreek",
		text = "Rainbowcreek",
		flag = path:format("rainbowcreek"),
	}
	c = c + 1
	Nations[c] = {
		value = "rapa_nui,_chile",
		text = "Rapa Nui, Chile",
		flag = path:format("rapa_nui,_chile"),
	}
	c = c + 1
	Nations[c] = {
		value = "republica_juliana",
		text = "Republica Juliana",
		flag = path:format("republica_juliana"),
	}
	c = c + 1
	Nations[c] = {
		value = "republic_of_dubrovnik",
		text = "Republic Of Dubrovnik",
		flag = path:format("republic_of_dubrovnik"),
	}
	c = c + 1
	Nations[c] = {
		value = "Republic_of_New_Afrika",
		text = "Republic Of New Afrika",
		flag = path:format("Republic_of_New_Afrika"),
	}
	c = c + 1
	Nations[c] = {
		value = "republic_ryukyu_independists",
		text = "Republic Ryukyu Independists",
		flag = path:format("republic_ryukyu_independists"),
	}
	c = c + 1
	Nations[c] = {
		value = "rhodesia",
		text = "Rhodesia",
		flag = path:format("rhodesia"),
	}
	c = c + 1
	Nations[c] = {
		value = "riau_independists",
		text = "Riau Independists",
		flag = path:format("riau_independists"),
	}
	c = c + 1
	Nations[c] = {
		value = "romania",
		text = "Romania",
		flag = path:format("romania"),
	}
	c = c + 1
	Nations[c] = {
		value = "rose_island",
		text = "Rose Island",
		flag = path:format("rose_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "rotuma",
		text = "Rotuma",
		flag = path:format("rotuma"),
	}
	c = c + 1
	Nations[c] = {
		value = "rurutu",
		text = "Rurutu",
		flag = path:format("rurutu"),
	}
	c = c + 1
	Nations[c] = {
		value = "russia",
		text = "Russia",
		flag = path:format("russia"),
	}
	c = c + 1
	Nations[c] = {
		value = "rwanda",
		text = "Rwanda",
		flag = path:format("rwanda"),
	}
	c = c + 1
	Nations[c] = {
		value = "ryukyu",
		text = "Ryukyu",
		flag = path:format("ryukyu"),
	}
	c = c + 1
	Nations[c] = {
		value = "saba",
		text = "Saba",
		flag = path:format("saba"),
	}
	c = c + 1
	Nations[c] = {
		value = "saint-pierre_and_miquelon",
		text = "Saint-pierre And Miquelon",
		flag = path:format("saint-pierre_and_miquelon"),
	}
	c = c + 1
	Nations[c] = {
		value = "saint_barthelemy",
		text = "Saint Barthelemy",
		flag = path:format("saint_barthelemy"),
	}
	c = c + 1
	Nations[c] = {
		value = "saint_helena",
		text = "Saint Helena",
		flag = path:format("saint_helena"),
	}
	c = c + 1
	Nations[c] = {
		value = "saint_kitts_and_nevis",
		text = "Saint Kitts And Nevis",
		flag = path:format("saint_kitts_and_nevis"),
	}
	c = c + 1
	Nations[c] = {
		value = "saint_lucia",
		text = "Saint Lucia",
		flag = path:format("saint_lucia"),
	}
	c = c + 1
	Nations[c] = {
		value = "saint_vincent_and_the_grenadines",
		text = "Saint Vincent And The Grenadines",
		flag = path:format("saint_vincent_and_the_grenadines"),
	}
	c = c + 1
	Nations[c] = {
		value = "sami",
		text = "Sami",
		flag = path:format("sami"),
	}
	c = c + 1
	Nations[c] = {
		value = "samoa",
		text = "Samoa",
		flag = path:format("samoa"),
	}
	c = c + 1
	Nations[c] = {
		value = "san_marino",
		text = "San Marino",
		flag = path:format("san_marino"),
	}
	c = c + 1
	Nations[c] = {
		value = "sao_tome_and_principe",
		text = "Sao Tome And Principe",
		flag = path:format("sao_tome_and_principe"),
	}
	c = c + 1
	Nations[c] = {
		value = "sark",
		text = "Sark",
		flag = path:format("sark"),
	}
	c = c + 1
	Nations[c] = {
		value = "saudi_arabia",
		text = "Saudi Arabia",
		flag = path:format("saudi_arabia"),
	}
	c = c + 1
	Nations[c] = {
		value = "saxony",
		text = "Saxony",
		flag = path:format("saxony"),
	}
	c = c + 1
	Nations[c] = {
		value = "scotland",
		text = "Scotland",
		flag = path:format("scotland"),
	}
	c = c + 1
	Nations[c] = {
		value = "sealand",
		text = "Sealand",
		flag = path:format("sealand"),
	}
	c = c + 1
	Nations[c] = {
		value = "sedang",
		text = "Sedang",
		flag = path:format("sedang"),
	}
	c = c + 1
	Nations[c] = {
		value = "senegal",
		text = "Senegal",
		flag = path:format("senegal"),
	}
	c = c + 1
	Nations[c] = {
		value = "serbia",
		text = "Serbia",
		flag = path:format("serbia"),
	}
	c = c + 1
	Nations[c] = {
		value = "serbian_krajina",
		text = "Serbian Krajina",
		flag = path:format("serbian_krajina"),
	}
	c = c + 1
	Nations[c] = {
		value = "seychelles",
		text = "Seychelles",
		flag = path:format("seychelles"),
	}
	c = c + 1
	Nations[c] = {
		value = "sfr_yugoslavia",
		text = "Sfr Yugoslavia",
		flag = path:format("sfr_yugoslavia"),
	}
	c = c + 1
	Nations[c] = {
		value = "sierra_leone",
		text = "Sierra Leone",
		flag = path:format("sierra_leone"),
	}
	c = c + 1
	Nations[c] = {
		value = "sikkim",
		text = "Sikkim",
		flag = path:format("sikkim"),
	}
	c = c + 1
	Nations[c] = {
		value = "simple_of_the_grand_duchy_of_tuscany",
		text = "Simple Of The Grand Duchy Of Tuscany",
		flag = path:format("simple_of_the_grand_duchy_of_tuscany"),
	}
	c = c + 1
	Nations[c] = {
		value = "singapore",
		text = "Singapore",
		flag = path:format("singapore"),
	}
	c = c + 1
	Nations[c] = {
		value = "sint_eustatius",
		text = "Sint Eustatius",
		flag = path:format("sint_eustatius"),
	}
	c = c + 1
	Nations[c] = {
		value = "sint_maarten",
		text = "Sint Maarten",
		flag = path:format("sint_maarten"),
	}
	c = c + 1
	Nations[c] = {
		value = "slovakia",
		text = "Slovakia",
		flag = path:format("slovakia"),
	}
	c = c + 1
	Nations[c] = {
		value = "slovenia",
		text = "Slovenia",
		flag = path:format("slovenia"),
	}
	c = c + 1
	Nations[c] = {
		value = "snake_of_martinique",
		text = "Snake Of Martinique",
		flag = path:format("snake_of_martinique"),
	}
	c = c + 1
	Nations[c] = {
		value = "somalia",
		text = "Somalia",
		flag = path:format("somalia"),
	}
	c = c + 1
	Nations[c] = {
		value = "somaliland",
		text = "Somaliland",
		flag = path:format("somaliland"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_africa",
		text = "South Africa",
		flag = path:format("south_africa"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_georgia_and_the_south_sandwich_islands",
		text = "South Georgia And The South Sandwich Islands",
		flag = path:format("south_georgia_and_the_south_sandwich_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_kasai",
		text = "South Kasai",
		flag = path:format("south_kasai"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_korea",
		text = "South Korea",
		flag = path:format("south_korea"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_moluccas",
		text = "South Moluccas",
		flag = path:format("south_moluccas"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_ossetia",
		text = "South Ossetia",
		flag = path:format("south_ossetia"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_sudan",
		text = "South Sudan",
		flag = path:format("south_sudan"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_vietnam",
		text = "South Vietnam",
		flag = path:format("south_vietnam"),
	}
	c = c + 1
	Nations[c] = {
		value = "south_yemen",
		text = "South Yemen",
		flag = path:format("south_yemen"),
	}
	c = c + 1
	Nations[c] = {
		value = "spain",
		text = "Spain",
		flag = path:format("spain"),
	}
	c = c + 1
	Nations[c] = {
		value = "sri_lanka",
		text = "Sri Lanka",
		flag = path:format("sri_lanka"),
	}
	c = c + 1
	Nations[c] = {
		value = "sudan",
		text = "Sudan",
		flag = path:format("sudan"),
	}
	c = c + 1
	Nations[c] = {
		value = "sulawesi",
		text = "Sulawesi",
		flag = path:format("sulawesi"),
	}
	c = c + 1
	Nations[c] = {
		value = "sulu",
		text = "Sulu",
		flag = path:format("sulu"),
	}
	c = c + 1
	Nations[c] = {
		value = "suriname",
		text = "Suriname",
		flag = path:format("suriname"),
	}
	c = c + 1
	Nations[c] = {
		value = "swaziland",
		text = "Swaziland",
		flag = path:format("swaziland"),
	}
	c = c + 1
	Nations[c] = {
		value = "sweden",
		text = "Sweden",
		flag = path:format("sweden"),
	}
	c = c + 1
	Nations[c] = {
		value = "switzerland",
		text = "Switzerland",
		flag = path:format("switzerland"),
	}
	c = c + 1
	Nations[c] = {
		value = "syria",
		text = "Syria",
		flag = path:format("syria"),
	}
	c = c + 1
	Nations[c] = {
		value = "syrian_kurdistan",
		text = "Syrian Kurdistan",
		flag = path:format("syrian_kurdistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "szekely_land",
		text = "Szekely Land",
		flag = path:format("szekely_land"),
	}
	c = c + 1
	Nations[c] = {
		value = "taiwan_proposed_1996",
		text = "Taiwan Proposed 1996",
		flag = path:format("taiwan_proposed_1996"),
	}
	c = c + 1
	Nations[c] = {
		value = "tajikistan",
		text = "Tajikistan",
		flag = path:format("tajikistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "tanganyika",
		text = "Tanganyika",
		flag = path:format("tanganyika"),
	}
	c = c + 1
	Nations[c] = {
		value = "tanzania",
		text = "Tanzania",
		flag = path:format("tanzania"),
	}
	c = c + 1
	Nations[c] = {
		value = "tavolara",
		text = "Tavolara",
		flag = path:format("tavolara"),
	}
	c = c + 1
	Nations[c] = {
		value = "texas",
		text = "Texas",
		flag = path:format("texas"),
	}
	c = c + 1
	Nations[c] = {
		value = "thailand",
		text = "Thailand",
		flag = path:format("thailand"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_aceh_sultanate",
		text = "The Aceh Sultanate",
		flag = path:format("the_aceh_sultanate"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_american_indian_movement",
		text = "The American Indian Movement",
		flag = path:format("the_american_indian_movement"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_bahamas",
		text = "The Bahamas",
		flag = path:format("the_bahamas"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_barisan_revolusi_nasional",
		text = "The Barisan Revolusi Nasional",
		flag = path:format("the_barisan_revolusi_nasional"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_basque_country",
		text = "The Basque Country",
		flag = path:format("the_basque_country"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_bodo_liberation_tigers_force",
		text = "The Bodo Liberation Tigers Force",
		flag = path:format("the_bodo_liberation_tigers_force"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_british_antarctic_territory",
		text = "The British Antarctic Territory",
		flag = path:format("the_british_antarctic_territory"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_british_indian_ocean_territory",
		text = "The British Indian Ocean Territory",
		flag = path:format("the_british_indian_ocean_territory"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_british_virgin_islands",
		text = "The British Virgin Islands",
		flag = path:format("the_british_virgin_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_cayman_islands",
		text = "The Cayman Islands",
		flag = path:format("the_cayman_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_central_african_republic",
		text = "The Central African Republic",
		flag = path:format("the_central_african_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_cocos_keeling_islands",
		text = "The Cocos Keeling Islands",
		flag = path:format("the_cocos_keeling_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_collectivity_of_saint_martin",
		text = "The Collectivity Of Saint Martin",
		flag = path:format("the_collectivity_of_saint_martin"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_comoros",
		text = "The Comoros",
		flag = path:format("the_comoros"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_confederate_states_of_america",
		text = "The Confederate States Of America",
		flag = path:format("the_confederate_states_of_america"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_cook_islands",
		text = "The Cook Islands",
		flag = path:format("the_cook_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_creek_nation",
		text = "The Creek Nation",
		flag = path:format("the_creek_nation"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_croatian_republic_of_herzeg-bosnia",
		text = "The Croatian Republic Of Herzeg-bosnia",
		flag = path:format("the_croatian_republic_of_herzeg-bosnia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_czech_republic",
		text = "The Czech Republic",
		flag = path:format("the_czech_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_democratic_republic_of_the_congo",
		text = "The Democratic Republic Of The Congo",
		flag = path:format("the_democratic_republic_of_the_congo"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_district_of_columbia",
		text = "The District Of Columbia",
		flag = path:format("the_district_of_columbia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_dominican_republic",
		text = "The Dominican Republic",
		flag = path:format("the_dominican_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_falkland_islands",
		text = "The Falkland Islands",
		flag = path:format("the_falkland_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_faroe_islands",
		text = "The Faroe Islands",
		flag = path:format("the_faroe_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_federal_republic_of_central_america",
		text = "The Federal Republic Of Central America",
		flag = path:format("the_federal_republic_of_central_america"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_federal_republic_of_southern_cameroons",
		text = "The Federal Republic Of Southern Cameroons",
		flag = path:format("the_federal_republic_of_southern_cameroons"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_federated_states_of_micronesia",
		text = "The Federated States Of Micronesia",
		flag = path:format("the_federated_states_of_micronesia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_federation_of_rhodesia_and_nyasaland",
		text = "The Federation Of Rhodesia And Nyasaland",
		flag = path:format("the_federation_of_rhodesia_and_nyasaland"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_free_state_of_fiume",
		text = "The Free State Of Fiume",
		flag = path:format("the_free_state_of_fiume"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_french_southern_and_antarctic_lands",
		text = "The French Southern And Antarctic Lands",
		flag = path:format("the_french_southern_and_antarctic_lands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_gagauz_people",
		text = "The Gagauz People",
		flag = path:format("the_gagauz_people"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_galician_ssr",
		text = "The Galician SSR",
		flag = path:format("the_galician_ssr"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_gambia",
		text = "The Gambia",
		flag = path:format("the_gambia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_hawar_islands",
		text = "The Hawar Islands",
		flag = path:format("the_hawar_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_inner_mongolian_people's_party",
		text = "The Inner Mongolian People's Party",
		flag = path:format("the_inner_mongolian_people's_party"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_islands_of_refreshment",
		text = "The Islands Of Refreshment",
		flag = path:format("the_islands_of_refreshment"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_isle_of_man",
		text = "The Isle Of Man",
		flag = path:format("the_isle_of_man"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_araucania_and_patagonia",
		text = "The Kingdom Of Araucania And Patagonia",
		flag = path:format("the_kingdom_of_araucania_and_patagonia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_lau",
		text = "The Kingdom Of Lau",
		flag = path:format("the_kingdom_of_lau"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_mangareva",
		text = "The Kingdom Of Mangareva",
		flag = path:format("the_kingdom_of_mangareva"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_redonda",
		text = "The Kingdom Of Redonda",
		flag = path:format("the_kingdom_of_redonda"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_rimatara",
		text = "The Kingdom Of Rimatara",
		flag = path:format("the_kingdom_of_rimatara"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_tahiti",
		text = "The Kingdom Of Tahiti",
		flag = path:format("the_kingdom_of_tahiti"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_talossa",
		text = "The Kingdom Of Talossa",
		flag = path:format("the_kingdom_of_talossa"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_the_two_sicilies",
		text = "The Kingdom Of The Two Sicilies",
		flag = path:format("the_kingdom_of_the_two_sicilies"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_kingdom_of_yugoslavia",
		text = "The Kingdom Of Yugoslavia",
		flag = path:format("the_kingdom_of_yugoslavia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_mapuches",
		text = "The Mapuches",
		flag = path:format("the_mapuches"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_maratha_empire",
		text = "The Maratha Empire",
		flag = path:format("the_maratha_empire"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_marshall_islands",
		text = "The Marshall Islands",
		flag = path:format("the_marshall_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_mengjiang",
		text = "The Mengjiang",
		flag = path:format("the_mengjiang"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_midway_islands",
		text = "The Midway Islands",
		flag = path:format("the_midway_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_moro_islamic_liberation_front",
		text = "The Moro Islamic Liberation Front",
		flag = path:format("the_moro_islamic_liberation_front"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_mughal_empire",
		text = "The Mughal Empire",
		flag = path:format("the_mughal_empire"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_National_Front_for_the_Liberation_of_Southern_Vietnam",
		text = "The National Front For The Liberation Of Southern Vietnam",
		flag = path:format("the_National_Front_for_the_Liberation_of_Southern_Vietnam"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_netherlands",
		text = "The Netherlands",
		flag = path:format("the_netherlands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_northern_mariana_islands",
		text = "The Northern Mariana Islands",
		flag = path:format("the_northern_mariana_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_orange_free_state",
		text = "The Orange Free State",
		flag = path:format("the_orange_free_state"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_oromo_liberation_front",
		text = "The Oromo Liberation Front",
		flag = path:format("the_oromo_liberation_front"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_pattani_united_liberation_organisation",
		text = "The Pattani United Liberation Organisation",
		flag = path:format("the_pattani_united_liberation_organisation"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_people's_republic_of_china",
		text = "The People's Republic Of China",
		flag = path:format("the_people's_republic_of_china"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_peru-bolivian_confederation",
		text = "The Peru-bolivian Confederation",
		flag = path:format("the_peru-bolivian_confederation"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_philippines",
		text = "The Philippines",
		flag = path:format("the_philippines"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_pitcairn_islands",
		text = "The Pitcairn Islands",
		flag = path:format("the_pitcairn_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_principality_of_trinidad",
		text = "The Principality Of Trinidad",
		flag = path:format("the_principality_of_trinidad"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_alsace-lorraine",
		text = "The Republic Of Alsace-lorraine",
		flag = path:format("the_republic_of_alsace-lorraine"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_benin",
		text = "The Republic Of Benin",
		flag = path:format("the_republic_of_benin"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_central_highlands_and_champa",
		text = "The Republic Of Central Highlands And Champa",
		flag = path:format("the_republic_of_central_highlands_and_champa"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_china",
		text = "The Republic Of China",
		flag = path:format("the_republic_of_china"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_lower_california",
		text = "The Republic Of Lower California",
		flag = path:format("the_republic_of_lower_california"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_molossia",
		text = "The Republic Of Molossia",
		flag = path:format("the_republic_of_molossia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_sonora",
		text = "The Republic Of Sonora",
		flag = path:format("the_republic_of_sonora"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_talossa",
		text = "The Republic Of Talossa",
		flag = path:format("the_republic_of_talossa"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_texas",
		text = "The Republic Of Texas",
		flag = path:format("the_republic_of_texas"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_the_congo",
		text = "The Republic Of The Congo",
		flag = path:format("the_republic_of_the_congo"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_the_rif",
		text = "The Republic Of The Rif",
		flag = path:format("the_republic_of_the_rif"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_the_rio_grande",
		text = "The Republic Of The Rio Grande",
		flag = path:format("the_republic_of_the_rio_grande"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_western_bosnia",
		text = "The Republic Of Western Bosnia",
		flag = path:format("the_republic_of_western_bosnia"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_yucatan",
		text = "The Republic Of Yucatan",
		flag = path:format("the_republic_of_yucatan"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_republic_of_zamboanga",
		text = "The Republic Of Zamboanga",
		flag = path:format("the_republic_of_zamboanga"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_ross_dependency",
		text = "The Ross Dependency",
		flag = path:format("the_ross_dependency"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_sahrawi_arab_democratic_republic",
		text = "The Sahrawi Arab Democratic Republic",
		flag = path:format("the_sahrawi_arab_democratic_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_solomon_islands",
		text = "The Solomon Islands",
		flag = path:format("the_solomon_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_soviet_union",
		text = "The Soviet Union",
		flag = path:format("the_soviet_union"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_sultanate_of_banten",
		text = "The Sultanate Of Banten",
		flag = path:format("the_sultanate_of_banten"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_sultanate_of_mataram",
		text = "The Sultanate Of Mataram",
		flag = path:format("the_sultanate_of_mataram"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_sultanate_of_zanzibar",
		text = "The Sultanate Of Zanzibar",
		flag = path:format("the_sultanate_of_zanzibar"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_tagalog_people",
		text = "The Tagalog People",
		flag = path:format("the_tagalog_people"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_transcaucasian_federation",
		text = "The Transcaucasian Federation",
		flag = path:format("the_transcaucasian_federation"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_tuamotu_kingdom",
		text = "The Tuamotu Kingdom",
		flag = path:format("the_tuamotu_kingdom"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_turkish_republic_of_northern_cyprus",
		text = "The Turkish Republic Of Northern Cyprus",
		flag = path:format("the_turkish_republic_of_northern_cyprus"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_turks_and_caicos_islands",
		text = "The Turks And Caicos Islands",
		flag = path:format("the_turks_and_caicos_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_tuvan_people's_republic",
		text = "The Tuvan People's Republic",
		flag = path:format("the_tuvan_people's_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_united_arab_emirates",
		text = "The United Arab Emirates",
		flag = path:format("the_united_arab_emirates"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_united_kingdom",
		text = "The United Kingdom",
		flag = path:format("the_united_kingdom"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_united_states",
		text = "The United States",
		flag = path:format("the_united_states"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_united_states_virgin_islands",
		text = "The United States Virgin Islands",
		flag = path:format("the_united_states_virgin_islands"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_united_tribes_of_fiji_1865-1867",
		text = "The United Tribes Of Fiji 1865-1867",
		flag = path:format("the_united_tribes_of_fiji_1865-1867"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_united_tribes_of_fiji_1867-1869",
		text = "The United Tribes Of Fiji 1867-1869",
		flag = path:format("the_united_tribes_of_fiji_1867-1869"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_vatican_city",
		text = "The Vatican City",
		flag = path:format("the_vatican_city"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_vermont_republic",
		text = "The Vermont Republic",
		flag = path:format("the_vermont_republic"),
	}
	c = c + 1
	Nations[c] = {
		value = "the_west_indies_federation",
		text = "The West Indies Federation",
		flag = path:format("the_west_indies_federation"),
	}
	c = c + 1
	Nations[c] = {
		value = "tibet",
		text = "Tibet",
		flag = path:format("tibet"),
	}
	c = c + 1
	Nations[c] = {
		value = "tknara",
		text = "Tknara",
		flag = path:format("tknara"),
	}
	c = c + 1
	Nations[c] = {
		value = "togo",
		text = "Togo",
		flag = path:format("togo"),
	}
	c = c + 1
	Nations[c] = {
		value = "tokelau",
		text = "Tokelau",
		flag = path:format("tokelau"),
	}
	c = c + 1
	Nations[c] = {
		value = "tonga",
		text = "Tonga",
		flag = path:format("tonga"),
	}
	c = c + 1
	Nations[c] = {
		value = "transkei",
		text = "Transkei",
		flag = path:format("transkei"),
	}
	c = c + 1
	Nations[c] = {
		value = "transnistria",
		text = "Transnistria",
		flag = path:format("transnistria"),
	}
	c = c + 1
	Nations[c] = {
		value = "transvaal",
		text = "Transvaal",
		flag = path:format("transvaal"),
	}
	c = c + 1
	Nations[c] = {
		value = "trinidad_and_tobago",
		text = "Trinidad And Tobago",
		flag = path:format("trinidad_and_tobago"),
	}
	c = c + 1
	Nations[c] = {
		value = "tristan_da_cunha",
		text = "Tristan Da Cunha",
		flag = path:format("tristan_da_cunha"),
	}
	c = c + 1
	Nations[c] = {
		value = "tunisia",
		text = "Tunisia",
		flag = path:format("tunisia"),
	}
	c = c + 1
	Nations[c] = {
		value = "turkey",
		text = "Turkey",
		flag = path:format("turkey"),
	}
	c = c + 1
	Nations[c] = {
		value = "turkmenistan",
		text = "Turkmenistan",
		flag = path:format("turkmenistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "tuvalu",
		text = "Tuvalu",
		flag = path:format("tuvalu"),
	}
	c = c + 1
	Nations[c] = {
		value = "uganda",
		text = "Uganda",
		flag = path:format("uganda"),
	}
	c = c + 1
	Nations[c] = {
		value = "ukraine",
		text = "Ukraine",
		flag = path:format("ukraine"),
	}
	c = c + 1
	Nations[c] = {
		value = "ukrainian_ssr",
		text = "Ukrainian SSR",
		flag = path:format("ukrainian_ssr"),
	}
	c = c + 1
	Nations[c] = {
		value = "uruguay",
		text = "Uruguay",
		flag = path:format("uruguay"),
	}
	c = c + 1
	Nations[c] = {
		value = "uzbekistan",
		text = "Uzbekistan",
		flag = path:format("uzbekistan"),
	}
	c = c + 1
	Nations[c] = {
		value = "vanuatu",
		text = "Vanuatu",
		flag = path:format("vanuatu"),
	}
	c = c + 1
	Nations[c] = {
		value = "venda",
		text = "Venda",
		flag = path:format("venda"),
	}
	c = c + 1
	Nations[c] = {
		value = "venezuela",
		text = "Venezuela",
		flag = path:format("venezuela"),
	}
	c = c + 1
	Nations[c] = {
		value = "vietnam",
		text = "Vietnam",
		flag = path:format("vietnam"),
	}
	c = c + 1
	Nations[c] = {
		value = "vojvodina",
		text = "Vojvodina",
		flag = path:format("vojvodina"),
	}
	c = c + 1
	Nations[c] = {
		value = "wake_island",
		text = "Wake Island",
		flag = path:format("wake_island"),
	}
	c = c + 1
	Nations[c] = {
		value = "wales",
		text = "Wales",
		flag = path:format("wales"),
	}
	c = c + 1
	Nations[c] = {
		value = "wallis_and_futuna",
		text = "Wallis And Futuna",
		flag = path:format("wallis_and_futuna"),
	}
	c = c + 1
	Nations[c] = {
		value = "yemen",
		text = "Yemen",
		flag = path:format("yemen"),
	}
	c = c + 1
	Nations[c] = {
		value = "zambia",
		text = "Zambia",
		flag = path:format("zambia"),
	}
	c = c + 1
	Nations[c] = {
		value = "zanzibar",
		text = "Zanzibar",
		flag = path:format("zanzibar"),
	}
	c = c + 1
	Nations[c] = {
		value = "zimbabwe",
		text = "Zimbabwe",
		flag = path:format("zimbabwe"),
	}
	c = c + 1
	Nations[c] = {
		value = "zomi_re-unification_organisation",
		text = "Zomi Re-unification Organisation",
		flag = path:format("zomi_re-unification_organisation"),
	}

	const.FullTransitionToMarsNames = 9999

	-- add list of names from earlier for each nation
	for i = 1, #Nations do
		HumanNames[Nations[i].value] = name_table
--~		 -- skip the countries added by the game (unless it's Mars)
--~		 if Nations[i].value == "Mars" or type(Nations[i].text) == "string" then
--~			 HumanNames[Nations[i].value] = name_table
--~		 else
--~			 if HumanNames[Nations[i].value] then
--~				 HumanNames[Nations[i].value].Unique = name_table.Unique
--~			 end
--~		 end
	end

	-- replace the func that gets a nation (it gets a weighted nation depending on your sponsors instead of all of them)
	function GetWeightedRandNation()
		return Nations[AsyncRand(#Nations - 1 + 1) + 1].value
	end

end

