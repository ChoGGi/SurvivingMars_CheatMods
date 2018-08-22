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
  RandomBirthplace = false,
}

-- just in case anyone adds some custom HumanNames
function OnMsg.ModsLoaded()

  local AsyncRand = AsyncRand
  local HumanNames = HumanNames

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

  -- makes it easier to access the flags, not with the DA blacklist it doesn't
--~   MountFolder("EveryFlagOnWikipedia",table.concat{EveryFlagOnWikipedia.ModPath,"Flags/"})

  local path = table.concat{CurrentModPath,"Flags/flag_%s.tga"}

  local Nations = Nations

  -- instead of just replacing the orig table we add on to it (just in case more nations are added, maybe by a mod)
  Nations[#Nations+1] = {
    value = "abkhazia",
    text = "Abkhazia",
    flag = path:format("abkhazia"),
  }
  Nations[#Nations+1] = {
    value = "afghanistan",
    text = "Afghanistan",
    flag = path:format("afghanistan"),
  }
  Nations[#Nations+1] = {
    value = "aland",
    text = "Aland",
    flag = path:format("aland"),
  }
  Nations[#Nations+1] = {
    value = "alaska",
    text = "Alaska",
    flag = path:format("alaska"),
  }
  Nations[#Nations+1] = {
    value = "albania",
    text = "Albania",
    flag = path:format("albania"),
  }
  Nations[#Nations+1] = {
    value = "alderney",
    text = "Alderney",
    flag = path:format("alderney"),
  }
  Nations[#Nations+1] = {
    value = "algeria",
    text = "Algeria",
    flag = path:format("algeria"),
  }
  Nations[#Nations+1] = {
    value = "american_samoa",
    text = "American Samoa",
    flag = path:format("american_samoa"),
  }
  Nations[#Nations+1] = {
    value = "andorra",
    text = "Andorra",
    flag = path:format("andorra"),
  }
  Nations[#Nations+1] = {
    value = "angola",
    text = "Angola",
    flag = path:format("angola"),
  }
  Nations[#Nations+1] = {
    value = "anguilla",
    text = "Anguilla",
    flag = path:format("anguilla"),
  }
  Nations[#Nations+1] = {
    value = "anjouan",
    text = "Anjouan",
    flag = path:format("anjouan"),
  }
  Nations[#Nations+1] = {
    value = "antigua_and_barbuda",
    text = "Antigua And Barbuda",
    flag = path:format("antigua_and_barbuda"),
  }
  Nations[#Nations+1] = {
    value = "argentina",
    text = "Argentina",
    flag = path:format("argentina"),
  }
  Nations[#Nations+1] = {
    value = "armenia",
    text = "Armenia",
    flag = path:format("armenia"),
  }
  Nations[#Nations+1] = {
    value = "artsakh",
    text = "Artsakh",
    flag = path:format("artsakh"),
  }
  Nations[#Nations+1] = {
    value = "aruba",
    text = "Aruba",
    flag = path:format("aruba"),
  }
  Nations[#Nations+1] = {
    value = "ascension_island",
    text = "Ascension Island",
    flag = path:format("ascension_island"),
  }
  Nations[#Nations+1] = {
    value = "ashanti",
    text = "Ashanti",
    flag = path:format("ashanti"),
  }
  Nations[#Nations+1] = {
    value = "australia",
    text = "Australia",
    flag = path:format("australia"),
  }
  Nations[#Nations+1] = {
    value = "austria-hungary",
    text = "Austria-hungary",
    flag = path:format("austria-hungary"),
  }
  Nations[#Nations+1] = {
    value = "austria",
    text = "Austria",
    flag = path:format("austria"),
  }
  Nations[#Nations+1] = {
    value = "azerbaijan",
    text = "Azerbaijan",
    flag = path:format("azerbaijan"),
  }
  Nations[#Nations+1] = {
    value = "bahrain",
    text = "Bahrain",
    flag = path:format("bahrain"),
  }
  Nations[#Nations+1] = {
    value = "balawaristan",
    text = "Balawaristan",
    flag = path:format("balawaristan"),
  }
  Nations[#Nations+1] = {
    value = "bamileke_national_movement",
    text = "Bamileke National Movement",
    flag = path:format("bamileke_national_movement"),
  }
  Nations[#Nations+1] = {
    value = "bangladesh",
    text = "Bangladesh",
    flag = path:format("bangladesh"),
  }
  Nations[#Nations+1] = {
    value = "barbados",
    text = "Barbados",
    flag = path:format("barbados"),
  }
  Nations[#Nations+1] = {
    value = "bavaria",
    text = "Bavaria",
    flag = path:format("bavaria"),
  }
  Nations[#Nations+1] = {
    value = "belarus",
    text = "Belarus",
    flag = path:format("belarus"),
  }
  Nations[#Nations+1] = {
    value = "belgium",
    text = "Belgium",
    flag = path:format("belgium"),
  }
  Nations[#Nations+1] = {
    value = "belize",
    text = "Belize",
    flag = path:format("belize"),
  }
  Nations[#Nations+1] = {
    value = "benin",
    text = "Benin",
    flag = path:format("benin"),
  }
  Nations[#Nations+1] = {
    value = "bermuda",
    text = "Bermuda",
    flag = path:format("bermuda"),
  }
  Nations[#Nations+1] = {
    value = "bhutan",
    text = "Bhutan",
    flag = path:format("bhutan"),
  }
  Nations[#Nations+1] = {
    value = "biafra",
    text = "Biafra",
    flag = path:format("biafra"),
  }
  Nations[#Nations+1] = {
    value = "bolivia",
    text = "Bolivia",
    flag = path:format("bolivia"),
  }
  Nations[#Nations+1] = {
    value = "bonaire",
    text = "Bonaire",
    flag = path:format("bonaire"),
  }
  Nations[#Nations+1] = {
    value = "bonnie_blue_flag_the_confederate_states_of_america",
    text = "Bonnie Blue Flag The Confederate States Of America",
    flag = path:format("bonnie_blue_flag_the_confederate_states_of_america"),
  }
  Nations[#Nations+1] = {
    value = "bophuthatswana",
    text = "Bophuthatswana",
    flag = path:format("bophuthatswana"),
  }
  Nations[#Nations+1] = {
    value = "bora_bora",
    text = "Bora Bora",
    flag = path:format("bora_bora"),
  }
  Nations[#Nations+1] = {
    value = "bosnia_and_herzegovina",
    text = "Bosnia And Herzegovina",
    flag = path:format("bosnia_and_herzegovina"),
  }
  Nations[#Nations+1] = {
    value = "botswana",
    text = "Botswana",
    flag = path:format("botswana"),
  }
  Nations[#Nations+1] = {
    value = "bougainville",
    text = "Bougainville",
    flag = path:format("bougainville"),
  }
  Nations[#Nations+1] = {
    value = "brazil",
    text = "Brazil",
    flag = path:format("brazil"),
  }
  Nations[#Nations+1] = {
    value = "brittany",
    text = "Brittany",
    flag = path:format("brittany"),
  }
  Nations[#Nations+1] = {
    value = "brunei",
    text = "Brunei",
    flag = path:format("brunei"),
  }
  Nations[#Nations+1] = {
    value = "bulgaria",
    text = "Bulgaria",
    flag = path:format("bulgaria"),
  }
  Nations[#Nations+1] = {
    value = "bumbunga",
    text = "Bumbunga",
    flag = path:format("bumbunga"),
  }
  Nations[#Nations+1] = {
    value = "burkina_faso",
    text = "Burkina Faso",
    flag = path:format("burkina_faso"),
  }
  Nations[#Nations+1] = {
    value = "burundi",
    text = "Burundi",
    flag = path:format("burundi"),
  }
  Nations[#Nations+1] = {
    value = "byelorussian_ssr",
    text = "Byelorussian SSR",
    flag = path:format("byelorussian_ssr"),
  }
  Nations[#Nations+1] = {
    value = "cabinda",
    text = "Cabinda",
    flag = path:format("cabinda"),
  }
  Nations[#Nations+1] = {
    value = "california",
    text = "California",
    flag = path:format("california"),
  }
  Nations[#Nations+1] = {
    value = "california_independence",
    text = "California Independence",
    flag = path:format("california_independence"),
  }
  Nations[#Nations+1] = {
    value = "cambodia",
    text = "Cambodia",
    flag = path:format("cambodia"),
  }
  Nations[#Nations+1] = {
    value = "cameroon",
    text = "Cameroon",
    flag = path:format("cameroon"),
  }
  Nations[#Nations+1] = {
    value = "canada",
    text = "Canada",
    flag = path:format("canada"),
  }
  Nations[#Nations+1] = {
    value = "cantabrian_labaru",
    text = "Cantabrian Labaru",
    flag = path:format("cantabrian_labaru"),
  }
  Nations[#Nations+1] = {
    value = "canu",
    text = "Canu",
    flag = path:format("canu"),
  }
  Nations[#Nations+1] = {
    value = "cape_verde",
    text = "Cape Verde",
    flag = path:format("cape_verde"),
  }
  Nations[#Nations+1] = {
    value = "casamance",
    text = "Casamance",
    flag = path:format("casamance"),
  }
  Nations[#Nations+1] = {
    value = "cascadia",
    text = "Cascadia",
    flag = path:format("cascadia"),
  }
  Nations[#Nations+1] = {
    value = "castile",
    text = "Castile",
    flag = path:format("castile"),
  }
  Nations[#Nations+1] = {
    value = "chad",
    text = "Chad",
    flag = path:format("chad"),
  }
  Nations[#Nations+1] = {
    value = "chechen_republic_of_ichkeria",
    text = "Chechen Republic Of Ichkeria",
    flag = path:format("chechen_republic_of_ichkeria"),
  }
  Nations[#Nations+1] = {
    value = "chile",
    text = "Chile",
    flag = path:format("chile"),
  }
  Nations[#Nations+1] = {
    value = "chin_national_front",
    text = "Chin National Front",
    flag = path:format("chin_national_front"),
  }
  Nations[#Nations+1] = {
    value = "christmas_island",
    text = "Christmas Island",
    flag = path:format("christmas_island"),
  }
  Nations[#Nations+1] = {
    value = "ciskei",
    text = "Ciskei",
    flag = path:format("ciskei"),
  }
  Nations[#Nations+1] = {
    value = "colombia",
    text = "Colombia",
    flag = path:format("colombia"),
  }
  Nations[#Nations+1] = {
    value = "cornwall",
    text = "Cornwall",
    flag = path:format("cornwall"),
  }
  Nations[#Nations+1] = {
    value = "corsica",
    text = "Corsica",
    flag = path:format("corsica"),
  }
  Nations[#Nations+1] = {
    value = "cospaia",
    text = "Cospaia",
    flag = path:format("cospaia"),
  }
  Nations[#Nations+1] = {
    value = "costa_rica",
    text = "Costa Rica",
    flag = path:format("costa_rica"),
  }
  Nations[#Nations+1] = {
    value = "cote_divoire",
    text = "Cote Divoire",
    flag = path:format("cote_divoire"),
  }
  Nations[#Nations+1] = {
    value = "cretan_state",
    text = "Cretan State",
    flag = path:format("cretan_state"),
  }
  Nations[#Nations+1] = {
    value = "crimea",
    text = "Crimea",
    flag = path:format("crimea"),
  }
  Nations[#Nations+1] = {
    value = "croatia",
    text = "Croatia",
    flag = path:format("croatia"),
  }
  Nations[#Nations+1] = {
    value = "cuba",
    text = "Cuba",
    flag = path:format("cuba"),
  }
  Nations[#Nations+1] = {
    value = "curacao",
    text = "Curacao",
    flag = path:format("curacao"),
  }
  Nations[#Nations+1] = {
    value = "cyprus",
    text = "Cyprus",
    flag = path:format("cyprus"),
  }
  Nations[#Nations+1] = {
    value = "dar_el_kuti_republic",
    text = "Dar El Kuti Republic",
    flag = path:format("dar_el_kuti_republic"),
  }
  Nations[#Nations+1] = {
    value = "denmark",
    text = "Denmark",
    flag = path:format("denmark"),
  }
  Nations[#Nations+1] = {
    value = "djibouti",
    text = "Djibouti",
    flag = path:format("djibouti"),
  }
  Nations[#Nations+1] = {
    value = "dominica",
    text = "Dominica",
    flag = path:format("dominica"),
  }
  Nations[#Nations+1] = {
    value = "donetsk_oblast",
    text = "Donetsk Oblast",
    flag = path:format("donetsk_oblast"),
  }
  Nations[#Nations+1] = {
    value = "eastern_rumelia",
    text = "Eastern Rumelia",
    flag = path:format("eastern_rumelia"),
  }
  Nations[#Nations+1] = {
    value = "easter_island",
    text = "Easter Island",
    flag = path:format("easter_island"),
  }
  Nations[#Nations+1] = {
    value = "east_germany",
    text = "East Germany",
    flag = path:format("east_germany"),
  }
  Nations[#Nations+1] = {
    value = "east_timor",
    text = "East Timor",
    flag = path:format("east_timor"),
  }
  Nations[#Nations+1] = {
    value = "ecuador",
    text = "Ecuador",
    flag = path:format("ecuador"),
  }
  Nations[#Nations+1] = {
    value = "egypt",
    text = "Egypt",
    flag = path:format("egypt"),
  }
  Nations[#Nations+1] = {
    value = "el_salvador",
    text = "El Salvador",
    flag = path:format("el_salvador"),
  }
  Nations[#Nations+1] = {
    value = "enenkio",
    text = "Enenkio",
    flag = path:format("enenkio"),
  }
  Nations[#Nations+1] = {
    value = "england",
    text = "England",
    flag = path:format("england"),
  }
  Nations[#Nations+1] = {
    value = "equatorial_guinea",
    text = "Equatorial Guinea",
    flag = path:format("equatorial_guinea"),
  }
  Nations[#Nations+1] = {
    value = "eritrea",
    text = "Eritrea",
    flag = path:format("eritrea"),
  }
  Nations[#Nations+1] = {
    value = "estonia",
    text = "Estonia",
    flag = path:format("estonia"),
  }
  Nations[#Nations+1] = {
    value = "ethiopia",
    text = "Ethiopia",
    flag = path:format("ethiopia"),
  }
  Nations[#Nations+1] = {
    value = "evis",
    text = "Evis",
    flag = path:format("evis"),
  }
  Nations[#Nations+1] = {
    value = "fiji",
    text = "Fiji",
    flag = path:format("fiji"),
  }
  Nations[#Nations+1] = {
    value = "finland",
    text = "Finland",
    flag = path:format("finland"),
  }
  Nations[#Nations+1] = {
    value = "flnks",
    text = "Front de Libération Nationale Kanak et Socialiste",
    flag = path:format("flnks"),
  }
  Nations[#Nations+1] = {
    value = "forcas_and_careiras",
    text = "Forcas And Careiras",
    flag = path:format("forcas_and_careiras"),
  }
  Nations[#Nations+1] = {
    value = "formosa",
    text = "Formosa",
    flag = path:format("formosa"),
  }
  Nations[#Nations+1] = {
    value = "france",
    text = "France",
    flag = path:format("france"),
  }
  Nations[#Nations+1] = {
    value = "franceville",
    text = "Franceville",
    flag = path:format("franceville"),
  }
  Nations[#Nations+1] = {
    value = "free_aceh_movement",
    text = "Free Aceh Movement",
    flag = path:format("free_aceh_movement"),
  }
  Nations[#Nations+1] = {
    value = "free_morbhan_republic",
    text = "Free Morbhan Republic",
    flag = path:format("free_morbhan_republic"),
  }
  Nations[#Nations+1] = {
    value = "free_territory_trieste",
    text = "Free Territory Trieste",
    flag = path:format("free_territory_trieste"),
  }
  Nations[#Nations+1] = {
    value = "french_guiana",
    text = "French Guiana",
    flag = path:format("french_guiana"),
  }
  Nations[#Nations+1] = {
    value = "french_polynesia",
    text = "French Polynesia",
    flag = path:format("french_polynesia"),
  }
  Nations[#Nations+1] = {
    value = "gabon",
    text = "Gabon",
    flag = path:format("gabon"),
  }
  Nations[#Nations+1] = {
    value = "gdansk",
    text = "Gdansk",
    flag = path:format("gdansk"),
  }
  Nations[#Nations+1] = {
    value = "genoa",
    text = "Genoa",
    flag = path:format("genoa"),
  }
  Nations[#Nations+1] = {
    value = "georgia",
    text = "Georgia",
    flag = path:format("georgia"),
  }
  Nations[#Nations+1] = {
    value = "germany",
    text = "Germany",
    flag = path:format("germany"),
  }
  Nations[#Nations+1] = {
    value = "ghana",
    text = "Ghana",
    flag = path:format("ghana"),
  }
  Nations[#Nations+1] = {
    value = "gibraltar",
    text = "Gibraltar",
    flag = path:format("gibraltar"),
  }
  Nations[#Nations+1] = {
    value = "greece",
    text = "Greece",
    flag = path:format("greece"),
  }
  Nations[#Nations+1] = {
    value = "greenland",
    text = "Greenland",
    flag = path:format("greenland"),
  }
  Nations[#Nations+1] = {
    value = "grenada",
    text = "Grenada",
    flag = path:format("grenada"),
  }
  Nations[#Nations+1] = {
    value = "grobherzogtum_baden",
    text = "Grobherzogtum Baden",
    flag = path:format("grobherzogtum_baden"),
  }
  Nations[#Nations+1] = {
    value = "grobherzogtum_hessen_ohne_wappen",
    text = "Grobherzogtum Hessen Ohne Wappen",
    flag = path:format("grobherzogtum_hessen_ohne_wappen"),
  }
  Nations[#Nations+1] = {
    value = "guadeloupe",
    text = "Guadeloupe",
    flag = path:format("guadeloupe"),
  }
  Nations[#Nations+1] = {
    value = "guam",
    text = "Guam",
    flag = path:format("guam"),
  }
  Nations[#Nations+1] = {
    value = "guangdong",
    text = "Guangdong",
    flag = path:format("guangdong"),
  }
  Nations[#Nations+1] = {
    value = "guatemala",
    text = "Guatemala",
    flag = path:format("guatemala"),
  }
  Nations[#Nations+1] = {
    value = "guernsey",
    text = "Guernsey",
    flag = path:format("guernsey"),
  }
  Nations[#Nations+1] = {
    value = "guinea-bissau",
    text = "Guinea-bissau",
    flag = path:format("guinea-bissau"),
  }
  Nations[#Nations+1] = {
    value = "guinea",
    text = "Guinea",
    flag = path:format("guinea"),
  }
  Nations[#Nations+1] = {
    value = "gurkhaland",
    text = "Gurkhaland",
    flag = path:format("gurkhaland"),
  }
  Nations[#Nations+1] = {
    value = "guyana",
    text = "Guyana",
    flag = path:format("guyana"),
  }
  Nations[#Nations+1] = {
    value = "gwynedd",
    text = "Gwynedd",
    flag = path:format("gwynedd"),
  }
  Nations[#Nations+1] = {
    value = "haiti",
    text = "Haiti",
    flag = path:format("haiti"),
  }
  Nations[#Nations+1] = {
    value = "hawaii",
    text = "Hawaii",
    flag = path:format("hawaii"),
  }
  Nations[#Nations+1] = {
    value = "hejaz",
    text = "Hejaz",
    flag = path:format("hejaz"),
  }
  Nations[#Nations+1] = {
    value = "honduras",
    text = "Honduras",
    flag = path:format("honduras"),
  }
  Nations[#Nations+1] = {
    value = "hong_kong",
    text = "Hong Kong",
    flag = path:format("hong_kong"),
  }
  Nations[#Nations+1] = {
    value = "huahine",
    text = "Huahine",
    flag = path:format("huahine"),
  }
  Nations[#Nations+1] = {
    value = "hungary",
    text = "Hungary",
    flag = path:format("hungary"),
  }
  Nations[#Nations+1] = {
    value = "hyderabad_state",
    text = "Hyderabad State",
    flag = path:format("hyderabad_state"),
  }
  Nations[#Nations+1] = {
    value = "iceland",
    text = "Iceland",
    flag = path:format("iceland"),
  }
  Nations[#Nations+1] = {
    value = "idel-ural_state",
    text = "Idel-ural State",
    flag = path:format("idel-ural_state"),
  }
  Nations[#Nations+1] = {
    value = "independent_state_of_croatia",
    text = "Independent State Of Croatia",
    flag = path:format("independent_state_of_croatia"),
  }
  Nations[#Nations+1] = {
    value = "india",
    text = "India",
    flag = path:format("india"),
  }
  Nations[#Nations+1] = {
    value = "indonesia",
    text = "Indonesia",
    flag = path:format("indonesia"),
  }
  Nations[#Nations+1] = {
    value = "iran",
    text = "Iran",
    flag = path:format("iran"),
  }
  Nations[#Nations+1] = {
    value = "iraq",
    text = "Iraq",
    flag = path:format("iraq"),
  }
  Nations[#Nations+1] = {
    value = "ireland",
    text = "Ireland",
    flag = path:format("ireland"),
  }
  Nations[#Nations+1] = {
    value = "israel",
    text = "Israel",
    flag = path:format("israel"),
  }
  Nations[#Nations+1] = {
    value = "italy",
    text = "Italy",
    flag = path:format("italy"),
  }
  Nations[#Nations+1] = {
    value = "jamaica",
    text = "Jamaica",
    flag = path:format("jamaica"),
  }
  Nations[#Nations+1] = {
    value = "japan",
    text = "Japan",
    flag = path:format("japan"),
  }
  Nations[#Nations+1] = {
    value = "jersey",
    text = "Jersey",
    flag = path:format("jersey"),
  }
  Nations[#Nations+1] = {
    value = "johnston_atoll",
    text = "Johnston Atoll",
    flag = path:format("johnston_atoll"),
  }
  Nations[#Nations+1] = {
    value = "jordan",
    text = "Jordan",
    flag = path:format("jordan"),
  }
  Nations[#Nations+1] = {
    value = "kapok",
    text = "Kapok",
    flag = path:format("kapok"),
  }
  Nations[#Nations+1] = {
    value = "karen_national_liberation_army",
    text = "Karen National Liberation Army",
    flag = path:format("karen_national_liberation_army"),
  }
  Nations[#Nations+1] = {
    value = "karen_national_union",
    text = "Karen National Union",
    flag = path:format("karen_national_union"),
  }
  Nations[#Nations+1] = {
    value = "katanga",
    text = "Katanga",
    flag = path:format("katanga"),
  }
  Nations[#Nations+1] = {
    value = "kazakhstan",
    text = "Kazakhstan",
    flag = path:format("kazakhstan"),
  }
  Nations[#Nations+1] = {
    value = "kenya",
    text = "Kenya",
    flag = path:format("kenya"),
  }
  Nations[#Nations+1] = {
    value = "khalistans",
    text = "Khalistans",
    flag = path:format("khalistans"),
  }
  Nations[#Nations+1] = {
    value = "kingdom_of_kurdistan",
    text = "Kingdom Of Kurdistan",
    flag = path:format("kingdom_of_kurdistan"),
  }
  Nations[#Nations+1] = {
    value = "kiribati",
    text = "Kiribati",
    flag = path:format("kiribati"),
  }
  Nations[#Nations+1] = {
    value = "khmers_kampuchea_krom",
    text = "Khmers Kampuchea-Krom",
    flag = path:format("khmers_kampuchea_krom"),
  }
  Nations[#Nations+1] = {
    value = "kokbayraq",
    text = "Kokbayraq",
    flag = path:format("kokbayraq"),
  }
  Nations[#Nations+1] = {
    value = "konigreich_wurttemberg",
    text = "Konigreich Wurttemberg",
    flag = path:format("konigreich_wurttemberg"),
  }
  Nations[#Nations+1] = {
    value = "kosovo",
    text = "Kosovo",
    flag = path:format("kosovo"),
  }
  Nations[#Nations+1] = {
    value = "krusevo_republic",
    text = "Krusevo Republic",
    flag = path:format("krusevo_republic"),
  }
  Nations[#Nations+1] = {
    value = "kuban_people's_republic",
    text = "Kuban People's Republic",
    flag = path:format("kuban_people's_republic"),
  }
  Nations[#Nations+1] = {
    value = "kurdistan",
    text = "Kurdistan",
    flag = path:format("kurdistan"),
  }
  Nations[#Nations+1] = {
    value = "kuwait",
    text = "Kuwait",
    flag = path:format("kuwait"),
  }
  Nations[#Nations+1] = {
    value = "kyrgyzstan",
    text = "Kyrgyzstan",
    flag = path:format("kyrgyzstan"),
  }
  Nations[#Nations+1] = {
    value = "ladonia",
    text = "Ladonia",
    flag = path:format("ladonia"),
  }
  Nations[#Nations+1] = {
    value = "laos",
    text = "Laos",
    flag = path:format("laos"),
  }
  Nations[#Nations+1] = {
    value = "latvia",
    text = "Latvia",
    flag = path:format("latvia"),
  }
  Nations[#Nations+1] = {
    value = "lebanon",
    text = "Lebanon",
    flag = path:format("lebanon"),
  }
  Nations[#Nations+1] = {
    value = "lesotho",
    text = "Lesotho",
    flag = path:format("lesotho"),
  }
  Nations[#Nations+1] = {
    value = "liberia",
    text = "Liberia",
    flag = path:format("liberia"),
  }
  Nations[#Nations+1] = {
    value = "libya",
    text = "Libya",
    flag = path:format("libya"),
  }
  Nations[#Nations+1] = {
    value = "liechtenstein",
    text = "Liechtenstein",
    flag = path:format("liechtenstein"),
  }
  Nations[#Nations+1] = {
    value = "lithuania",
    text = "Lithuania",
    flag = path:format("lithuania"),
  }
  Nations[#Nations+1] = {
    value = "lorraine",
    text = "Lorraine",
    flag = path:format("lorraine"),
  }
  Nations[#Nations+1] = {
    value = "los_altos",
    text = "Los Altos",
    flag = path:format("los_altos"),
  }
  Nations[#Nations+1] = {
    value = "luxembourg",
    text = "Luxembourg",
    flag = path:format("luxembourg"),
  }
  Nations[#Nations+1] = {
    value = "macau",
    text = "Macau",
    flag = path:format("macau"),
  }
  Nations[#Nations+1] = {
    value = "macedonia",
    text = "Macedonia",
    flag = path:format("macedonia"),
  }
  Nations[#Nations+1] = {
    value = "madagascar",
    text = "Madagascar",
    flag = path:format("madagascar"),
  }
  Nations[#Nations+1] = {
    value = "magallanes",
    text = "Magallanes",
    flag = path:format("magallanes"),
  }
  Nations[#Nations+1] = {
    value = "maguindanao",
    text = "Maguindanao",
    flag = path:format("maguindanao"),
  }
  Nations[#Nations+1] = {
    value = "malawi",
    text = "Malawi",
    flag = path:format("malawi"),
  }
  Nations[#Nations+1] = {
    value = "malaysia",
    text = "Malaysia",
    flag = path:format("malaysia"),
  }
  Nations[#Nations+1] = {
    value = "maldives",
    text = "Maldives",
    flag = path:format("maldives"),
  }
  Nations[#Nations+1] = {
    value = "mali",
    text = "Mali",
    flag = path:format("mali"),
  }
  Nations[#Nations+1] = {
    value = "malta",
    text = "Malta",
    flag = path:format("malta"),
  }
  Nations[#Nations+1] = {
    value = "manchukuo",
    text = "Manchukuo",
    flag = path:format("manchukuo"),
  }
  Nations[#Nations+1] = {
    value = "mauritania",
    text = "Mauritania",
    flag = path:format("mauritania"),
  }
  Nations[#Nations+1] = {
    value = "mauritius",
    text = "Mauritius",
    flag = path:format("mauritius"),
  }
  Nations[#Nations+1] = {
    value = "mayotte",
    text = "Mayotte",
    flag = path:format("mayotte"),
  }
  Nations[#Nations+1] = {
    value = "merina_kingdom",
    text = "Merina Kingdom",
    flag = path:format("merina_kingdom"),
  }
  Nations[#Nations+1] = {
    value = "mexico",
    text = "Mexico",
    flag = path:format("mexico"),
  }
  Nations[#Nations+1] = {
    value = "minerva",
    text = "Minerva",
    flag = path:format("minerva"),
  }
  Nations[#Nations+1] = {
    value = "azawad_national_liberation_movement",
    text = "Azawad National Liberation Movement",
    flag = path:format("azawad_national_liberation_movement"),
  }
  Nations[#Nations+1] = {
    value = "moro_national_liberation_front",
    text = "Moro National Liberation Front",
    flag = path:format("moro_national_liberation_front"),
  }
  Nations[#Nations+1] = {
    value = "moheli",
    text = "Moheli",
    flag = path:format("moheli"),
  }
  Nations[#Nations+1] = {
    value = "moldova",
    text = "Moldova",
    flag = path:format("moldova"),
  }
  Nations[#Nations+1] = {
    value = "monaco",
    text = "Monaco",
    flag = path:format("monaco"),
  }
  Nations[#Nations+1] = {
    value = "mongolia",
    text = "Mongolia",
    flag = path:format("mongolia"),
  }
  Nations[#Nations+1] = {
    value = "montenegro",
    text = "Montenegro",
    flag = path:format("montenegro"),
  }
  Nations[#Nations+1] = {
    value = "montserrat",
    text = "Montserrat",
    flag = path:format("montserrat"),
  }
  Nations[#Nations+1] = {
    value = "morning_star",
    text = "Morning Star",
    flag = path:format("morning_star"),
  }
  Nations[#Nations+1] = {
    value = "morocco",
    text = "Morocco",
    flag = path:format("morocco"),
  }
  Nations[#Nations+1] = {
    value = "most_serene_republic_of_venice",
    text = "Most Serene Republic Of Venice",
    flag = path:format("most_serene_republic_of_venice"),
  }
  Nations[#Nations+1] = {
    value = "mozambique",
    text = "Mozambique",
    flag = path:format("mozambique"),
  }
  Nations[#Nations+1] = {
    value = "murrawarri_republic",
    text = "Murrawarri Republic",
    flag = path:format("murrawarri_republic"),
  }
  Nations[#Nations+1] = {
    value = "myanmar",
    text = "Myanmar",
    flag = path:format("myanmar"),
  }
  Nations[#Nations+1] = {
    value = "namibia",
    text = "Namibia",
    flag = path:format("namibia"),
  }
  Nations[#Nations+1] = {
    value = "natalia_republic",
    text = "Natalia Republic",
    flag = path:format("natalia_republic"),
  }
  Nations[#Nations+1] = {
    value = "nauru",
    text = "Nauru",
    flag = path:format("nauru"),
  }
  Nations[#Nations+1] = {
    value = "navassa_island",
    text = "Navassa Island",
    flag = path:format("navassa_island"),
  }
  Nations[#Nations+1] = {
    value = "nejd",
    text = "Nejd",
    flag = path:format("nejd"),
  }
  Nations[#Nations+1] = {
    value = "nepal",
    text = "Nepal",
    flag = path:format("nepal"),
  }
  Nations[#Nations+1] = {
    value = "new_mon_state_party",
    text = "New Mon State Party",
    flag = path:format("new_mon_state_party"),
  }
  Nations[#Nations+1] = {
    value = "new_zealand",
    text = "New Zealand",
    flag = path:format("new_zealand"),
  }
  Nations[#Nations+1] = {
    value = "new_zealand_south_island",
    text = "New Zealand South Island",
    flag = path:format("new_zealand_south_island"),
  }
  Nations[#Nations+1] = {
    value = "nicaragua",
    text = "Nicaragua",
    flag = path:format("nicaragua"),
  }
  Nations[#Nations+1] = {
    value = "niger",
    text = "Niger",
    flag = path:format("niger"),
  }
  Nations[#Nations+1] = {
    value = "nigeria",
    text = "Nigeria",
    flag = path:format("nigeria"),
  }
  Nations[#Nations+1] = {
    value = "niue",
    text = "Niue",
    flag = path:format("niue"),
  }
  Nations[#Nations+1] = {
    value = "norfolk_island",
    text = "Norfolk Island",
    flag = path:format("norfolk_island"),
  }
  Nations[#Nations+1] = {
    value = "north_korea",
    text = "North Korea",
    flag = path:format("north_korea"),
  }
  Nations[#Nations+1] = {
    value = "norway",
    text = "Norway",
    flag = path:format("norway"),
  }
  Nations[#Nations+1] = {
    value = "occitania",
    text = "Occitania",
    flag = path:format("occitania"),
  }
  Nations[#Nations+1] = {
    value = "ogaden_national_liberation_front",
    text = "Ogaden National Liberation Front",
    flag = path:format("ogaden_national_liberation_front"),
  }
  Nations[#Nations+1] = {
    value = "oman",
    text = "Oman",
    flag = path:format("oman"),
  }
  Nations[#Nations+1] = {
    value = "ottoman_alternative",
    text = "Ottoman Alternative",
    flag = path:format("ottoman_alternative"),
  }
  Nations[#Nations+1] = {
    value = "padania",
    text = "Padania",
    flag = path:format("padania"),
  }
  Nations[#Nations+1] = {
    value = "pakistan",
    text = "Pakistan",
    flag = path:format("pakistan"),
  }
  Nations[#Nations+1] = {
    value = "palau",
    text = "Palau",
    flag = path:format("palau"),
  }
  Nations[#Nations+1] = {
    value = "palestine",
    text = "Palestine",
    flag = path:format("palestine"),
  }
  Nations[#Nations+1] = {
    value = "palmyra_atoll",
    text = "Palmyra Atoll",
    flag = path:format("palmyra_atoll"),
  }
  Nations[#Nations+1] = {
    value = "panama",
    text = "Panama",
    flag = path:format("panama"),
  }
  Nations[#Nations+1] = {
    value = "papua_new_guinea",
    text = "Papua New Guinea",
    flag = path:format("papua_new_guinea"),
  }
  Nations[#Nations+1] = {
    value = "paraguay",
    text = "Paraguay",
    flag = path:format("paraguay"),
  }
  Nations[#Nations+1] = {
    value = "pattani",
    text = "Pattani",
    flag = path:format("pattani"),
  }
  Nations[#Nations+1] = {
    value = "pernambucan_revolt",
    text = "Pernambucan Revolt",
    flag = path:format("pernambucan_revolt"),
  }
  Nations[#Nations+1] = {
    value = "peru",
    text = "Peru",
    flag = path:format("peru"),
  }
  Nations[#Nations+1] = {
    value = "piratini_republic",
    text = "Piratini Republic",
    flag = path:format("piratini_republic"),
  }
  Nations[#Nations+1] = {
    value = "poland",
    text = "Poland",
    flag = path:format("poland"),
  }
  Nations[#Nations+1] = {
    value = "porto_claro",
    text = "Porto Claro",
    flag = path:format("porto_claro"),
  }
  Nations[#Nations+1] = {
    value = "portugal",
    text = "Portugal",
    flag = path:format("portugal"),
  }
  Nations[#Nations+1] = {
    value = "portugalicia",
    text = "Portugalicia",
    flag = path:format("portugalicia"),
  }
  Nations[#Nations+1] = {
    value = "puerto_rico",
    text = "Puerto Rico",
    flag = path:format("puerto_rico"),
  }
  Nations[#Nations+1] = {
    value = "qatar",
    text = "Qatar",
    flag = path:format("qatar"),
  }
  Nations[#Nations+1] = {
    value = "quebec",
    text = "Quebec",
    flag = path:format("quebec"),
  }
  Nations[#Nations+1] = {
    value = "raiatea",
    text = "Raiatea",
    flag = path:format("raiatea"),
  }
  Nations[#Nations+1] = {
    value = "rainbowcreek",
    text = "Rainbowcreek",
    flag = path:format("rainbowcreek"),
  }
  Nations[#Nations+1] = {
    value = "rapa_nui,_chile",
    text = "Rapa Nui, Chile",
    flag = path:format("rapa_nui,_chile"),
  }
  Nations[#Nations+1] = {
    value = "republica_juliana",
    text = "Republica Juliana",
    flag = path:format("republica_juliana"),
  }
  Nations[#Nations+1] = {
    value = "republic_of_dubrovnik",
    text = "Republic Of Dubrovnik",
    flag = path:format("republic_of_dubrovnik"),
  }
  Nations[#Nations+1] = {
    value = "Republic_of_New_Afrika",
    text = "Republic Of New Afrika",
    flag = path:format("Republic_of_New_Afrika"),
  }
  Nations[#Nations+1] = {
    value = "republic_ryukyu_independists",
    text = "Republic Ryukyu Independists",
    flag = path:format("republic_ryukyu_independists"),
  }
  Nations[#Nations+1] = {
    value = "rhodesia",
    text = "Rhodesia",
    flag = path:format("rhodesia"),
  }
  Nations[#Nations+1] = {
    value = "riau_independists",
    text = "Riau Independists",
    flag = path:format("riau_independists"),
  }
  Nations[#Nations+1] = {
    value = "romania",
    text = "Romania",
    flag = path:format("romania"),
  }
  Nations[#Nations+1] = {
    value = "rose_island",
    text = "Rose Island",
    flag = path:format("rose_island"),
  }
  Nations[#Nations+1] = {
    value = "rotuma",
    text = "Rotuma",
    flag = path:format("rotuma"),
  }
  Nations[#Nations+1] = {
    value = "rurutu",
    text = "Rurutu",
    flag = path:format("rurutu"),
  }
  Nations[#Nations+1] = {
    value = "russia",
    text = "Russia",
    flag = path:format("russia"),
  }
  Nations[#Nations+1] = {
    value = "rwanda",
    text = "Rwanda",
    flag = path:format("rwanda"),
  }
  Nations[#Nations+1] = {
    value = "ryukyu",
    text = "Ryukyu",
    flag = path:format("ryukyu"),
  }
  Nations[#Nations+1] = {
    value = "saba",
    text = "Saba",
    flag = path:format("saba"),
  }
  Nations[#Nations+1] = {
    value = "saint-pierre_and_miquelon",
    text = "Saint-pierre And Miquelon",
    flag = path:format("saint-pierre_and_miquelon"),
  }
  Nations[#Nations+1] = {
    value = "saint_barthelemy",
    text = "Saint Barthelemy",
    flag = path:format("saint_barthelemy"),
  }
  Nations[#Nations+1] = {
    value = "saint_helena",
    text = "Saint Helena",
    flag = path:format("saint_helena"),
  }
  Nations[#Nations+1] = {
    value = "saint_kitts_and_nevis",
    text = "Saint Kitts And Nevis",
    flag = path:format("saint_kitts_and_nevis"),
  }
  Nations[#Nations+1] = {
    value = "saint_lucia",
    text = "Saint Lucia",
    flag = path:format("saint_lucia"),
  }
  Nations[#Nations+1] = {
    value = "saint_vincent_and_the_grenadines",
    text = "Saint Vincent And The Grenadines",
    flag = path:format("saint_vincent_and_the_grenadines"),
  }
  Nations[#Nations+1] = {
    value = "sami",
    text = "Sami",
    flag = path:format("sami"),
  }
  Nations[#Nations+1] = {
    value = "samoa",
    text = "Samoa",
    flag = path:format("samoa"),
  }
  Nations[#Nations+1] = {
    value = "san_marino",
    text = "San Marino",
    flag = path:format("san_marino"),
  }
  Nations[#Nations+1] = {
    value = "sao_tome_and_principe",
    text = "Sao Tome And Principe",
    flag = path:format("sao_tome_and_principe"),
  }
  Nations[#Nations+1] = {
    value = "sark",
    text = "Sark",
    flag = path:format("sark"),
  }
  Nations[#Nations+1] = {
    value = "saudi_arabia",
    text = "Saudi Arabia",
    flag = path:format("saudi_arabia"),
  }
  Nations[#Nations+1] = {
    value = "saxony",
    text = "Saxony",
    flag = path:format("saxony"),
  }
  Nations[#Nations+1] = {
    value = "scotland",
    text = "Scotland",
    flag = path:format("scotland"),
  }
  Nations[#Nations+1] = {
    value = "sealand",
    text = "Sealand",
    flag = path:format("sealand"),
  }
  Nations[#Nations+1] = {
    value = "sedang",
    text = "Sedang",
    flag = path:format("sedang"),
  }
  Nations[#Nations+1] = {
    value = "senegal",
    text = "Senegal",
    flag = path:format("senegal"),
  }
  Nations[#Nations+1] = {
    value = "serbia",
    text = "Serbia",
    flag = path:format("serbia"),
  }
  Nations[#Nations+1] = {
    value = "serbian_krajina",
    text = "Serbian Krajina",
    flag = path:format("serbian_krajina"),
  }
  Nations[#Nations+1] = {
    value = "seychelles",
    text = "Seychelles",
    flag = path:format("seychelles"),
  }
  Nations[#Nations+1] = {
    value = "sfr_yugoslavia",
    text = "Sfr Yugoslavia",
    flag = path:format("sfr_yugoslavia"),
  }
  Nations[#Nations+1] = {
    value = "sierra_leone",
    text = "Sierra Leone",
    flag = path:format("sierra_leone"),
  }
  Nations[#Nations+1] = {
    value = "sikkim",
    text = "Sikkim",
    flag = path:format("sikkim"),
  }
  Nations[#Nations+1] = {
    value = "simple_of_the_grand_duchy_of_tuscany",
    text = "Simple Of The Grand Duchy Of Tuscany",
    flag = path:format("simple_of_the_grand_duchy_of_tuscany"),
  }
  Nations[#Nations+1] = {
    value = "singapore",
    text = "Singapore",
    flag = path:format("singapore"),
  }
  Nations[#Nations+1] = {
    value = "sint_eustatius",
    text = "Sint Eustatius",
    flag = path:format("sint_eustatius"),
  }
  Nations[#Nations+1] = {
    value = "sint_maarten",
    text = "Sint Maarten",
    flag = path:format("sint_maarten"),
  }
  Nations[#Nations+1] = {
    value = "slovakia",
    text = "Slovakia",
    flag = path:format("slovakia"),
  }
  Nations[#Nations+1] = {
    value = "slovenia",
    text = "Slovenia",
    flag = path:format("slovenia"),
  }
  Nations[#Nations+1] = {
    value = "snake_of_martinique",
    text = "Snake Of Martinique",
    flag = path:format("snake_of_martinique"),
  }
  Nations[#Nations+1] = {
    value = "somalia",
    text = "Somalia",
    flag = path:format("somalia"),
  }
  Nations[#Nations+1] = {
    value = "somaliland",
    text = "Somaliland",
    flag = path:format("somaliland"),
  }
  Nations[#Nations+1] = {
    value = "south_africa",
    text = "South Africa",
    flag = path:format("south_africa"),
  }
  Nations[#Nations+1] = {
    value = "south_georgia_and_the_south_sandwich_islands",
    text = "South Georgia And The South Sandwich Islands",
    flag = path:format("south_georgia_and_the_south_sandwich_islands"),
  }
  Nations[#Nations+1] = {
    value = "south_kasai",
    text = "South Kasai",
    flag = path:format("south_kasai"),
  }
  Nations[#Nations+1] = {
    value = "south_korea",
    text = "South Korea",
    flag = path:format("south_korea"),
  }
  Nations[#Nations+1] = {
    value = "south_moluccas",
    text = "South Moluccas",
    flag = path:format("south_moluccas"),
  }
  Nations[#Nations+1] = {
    value = "south_ossetia",
    text = "South Ossetia",
    flag = path:format("south_ossetia"),
  }
  Nations[#Nations+1] = {
    value = "south_sudan",
    text = "South Sudan",
    flag = path:format("south_sudan"),
  }
  Nations[#Nations+1] = {
    value = "south_vietnam",
    text = "South Vietnam",
    flag = path:format("south_vietnam"),
  }
  Nations[#Nations+1] = {
    value = "south_yemen",
    text = "South Yemen",
    flag = path:format("south_yemen"),
  }
  Nations[#Nations+1] = {
    value = "spain",
    text = "Spain",
    flag = path:format("spain"),
  }
  Nations[#Nations+1] = {
    value = "sri_lanka",
    text = "Sri Lanka",
    flag = path:format("sri_lanka"),
  }
  Nations[#Nations+1] = {
    value = "sudan",
    text = "Sudan",
    flag = path:format("sudan"),
  }
  Nations[#Nations+1] = {
    value = "sulawesi",
    text = "Sulawesi",
    flag = path:format("sulawesi"),
  }
  Nations[#Nations+1] = {
    value = "sulu",
    text = "Sulu",
    flag = path:format("sulu"),
  }
  Nations[#Nations+1] = {
    value = "suriname",
    text = "Suriname",
    flag = path:format("suriname"),
  }
  Nations[#Nations+1] = {
    value = "swaziland",
    text = "Swaziland",
    flag = path:format("swaziland"),
  }
  Nations[#Nations+1] = {
    value = "sweden",
    text = "Sweden",
    flag = path:format("sweden"),
  }
  Nations[#Nations+1] = {
    value = "switzerland",
    text = "Switzerland",
    flag = path:format("switzerland"),
  }
  Nations[#Nations+1] = {
    value = "syria",
    text = "Syria",
    flag = path:format("syria"),
  }
  Nations[#Nations+1] = {
    value = "syrian_kurdistan",
    text = "Syrian Kurdistan",
    flag = path:format("syrian_kurdistan"),
  }
  Nations[#Nations+1] = {
    value = "szekely_land",
    text = "Szekely Land",
    flag = path:format("szekely_land"),
  }
  Nations[#Nations+1] = {
    value = "taiwan_proposed_1996",
    text = "Taiwan Proposed 1996",
    flag = path:format("taiwan_proposed_1996"),
  }
  Nations[#Nations+1] = {
    value = "tajikistan",
    text = "Tajikistan",
    flag = path:format("tajikistan"),
  }
  Nations[#Nations+1] = {
    value = "tanganyika",
    text = "Tanganyika",
    flag = path:format("tanganyika"),
  }
  Nations[#Nations+1] = {
    value = "tanzania",
    text = "Tanzania",
    flag = path:format("tanzania"),
  }
  Nations[#Nations+1] = {
    value = "tavolara",
    text = "Tavolara",
    flag = path:format("tavolara"),
  }
  Nations[#Nations+1] = {
    value = "texas",
    text = "Texas",
    flag = path:format("texas"),
  }
  Nations[#Nations+1] = {
    value = "thailand",
    text = "Thailand",
    flag = path:format("thailand"),
  }
  Nations[#Nations+1] = {
    value = "the_aceh_sultanate",
    text = "The Aceh Sultanate",
    flag = path:format("the_aceh_sultanate"),
  }
  Nations[#Nations+1] = {
    value = "the_american_indian_movement",
    text = "The American Indian Movement",
    flag = path:format("the_american_indian_movement"),
  }
  Nations[#Nations+1] = {
    value = "the_bahamas",
    text = "The Bahamas",
    flag = path:format("the_bahamas"),
  }
  Nations[#Nations+1] = {
    value = "the_barisan_revolusi_nasional",
    text = "The Barisan Revolusi Nasional",
    flag = path:format("the_barisan_revolusi_nasional"),
  }
  Nations[#Nations+1] = {
    value = "the_basque_country",
    text = "The Basque Country",
    flag = path:format("the_basque_country"),
  }
  Nations[#Nations+1] = {
    value = "the_bodo_liberation_tigers_force",
    text = "The Bodo Liberation Tigers Force",
    flag = path:format("the_bodo_liberation_tigers_force"),
  }
  Nations[#Nations+1] = {
    value = "the_british_antarctic_territory",
    text = "The British Antarctic Territory",
    flag = path:format("the_british_antarctic_territory"),
  }
  Nations[#Nations+1] = {
    value = "the_british_indian_ocean_territory",
    text = "The British Indian Ocean Territory",
    flag = path:format("the_british_indian_ocean_territory"),
  }
  Nations[#Nations+1] = {
    value = "the_british_virgin_islands",
    text = "The British Virgin Islands",
    flag = path:format("the_british_virgin_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_cayman_islands",
    text = "The Cayman Islands",
    flag = path:format("the_cayman_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_central_african_republic",
    text = "The Central African Republic",
    flag = path:format("the_central_african_republic"),
  }
  Nations[#Nations+1] = {
    value = "the_cocos_keeling_islands",
    text = "The Cocos Keeling Islands",
    flag = path:format("the_cocos_keeling_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_collectivity_of_saint_martin",
    text = "The Collectivity Of Saint Martin",
    flag = path:format("the_collectivity_of_saint_martin"),
  }
  Nations[#Nations+1] = {
    value = "the_comoros",
    text = "The Comoros",
    flag = path:format("the_comoros"),
  }
  Nations[#Nations+1] = {
    value = "the_confederate_states_of_america",
    text = "The Confederate States Of America",
    flag = path:format("the_confederate_states_of_america"),
  }
  Nations[#Nations+1] = {
    value = "the_cook_islands",
    text = "The Cook Islands",
    flag = path:format("the_cook_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_creek_nation",
    text = "The Creek Nation",
    flag = path:format("the_creek_nation"),
  }
  Nations[#Nations+1] = {
    value = "the_croatian_republic_of_herzeg-bosnia",
    text = "The Croatian Republic Of Herzeg-bosnia",
    flag = path:format("the_croatian_republic_of_herzeg-bosnia"),
  }
  Nations[#Nations+1] = {
    value = "the_czech_republic",
    text = "The Czech Republic",
    flag = path:format("the_czech_republic"),
  }
  Nations[#Nations+1] = {
    value = "the_democratic_republic_of_the_congo",
    text = "The Democratic Republic Of The Congo",
    flag = path:format("the_democratic_republic_of_the_congo"),
  }
  Nations[#Nations+1] = {
    value = "the_district_of_columbia",
    text = "The District Of Columbia",
    flag = path:format("the_district_of_columbia"),
  }
  Nations[#Nations+1] = {
    value = "the_dominican_republic",
    text = "The Dominican Republic",
    flag = path:format("the_dominican_republic"),
  }
  Nations[#Nations+1] = {
    value = "the_falkland_islands",
    text = "The Falkland Islands",
    flag = path:format("the_falkland_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_faroe_islands",
    text = "The Faroe Islands",
    flag = path:format("the_faroe_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_federal_republic_of_central_america",
    text = "The Federal Republic Of Central America",
    flag = path:format("the_federal_republic_of_central_america"),
  }
  Nations[#Nations+1] = {
    value = "the_federal_republic_of_southern_cameroons",
    text = "The Federal Republic Of Southern Cameroons",
    flag = path:format("the_federal_republic_of_southern_cameroons"),
  }
  Nations[#Nations+1] = {
    value = "the_federated_states_of_micronesia",
    text = "The Federated States Of Micronesia",
    flag = path:format("the_federated_states_of_micronesia"),
  }
  Nations[#Nations+1] = {
    value = "the_federation_of_rhodesia_and_nyasaland",
    text = "The Federation Of Rhodesia And Nyasaland",
    flag = path:format("the_federation_of_rhodesia_and_nyasaland"),
  }
  Nations[#Nations+1] = {
    value = "the_free_state_of_fiume",
    text = "The Free State Of Fiume",
    flag = path:format("the_free_state_of_fiume"),
  }
  Nations[#Nations+1] = {
    value = "the_french_southern_and_antarctic_lands",
    text = "The French Southern And Antarctic Lands",
    flag = path:format("the_french_southern_and_antarctic_lands"),
  }
  Nations[#Nations+1] = {
    value = "the_gagauz_people",
    text = "The Gagauz People",
    flag = path:format("the_gagauz_people"),
  }
  Nations[#Nations+1] = {
    value = "the_galician_ssr",
    text = "The Galician SSR",
    flag = path:format("the_galician_ssr"),
  }
  Nations[#Nations+1] = {
    value = "the_gambia",
    text = "The Gambia",
    flag = path:format("the_gambia"),
  }
  Nations[#Nations+1] = {
    value = "the_hawar_islands",
    text = "The Hawar Islands",
    flag = path:format("the_hawar_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_inner_mongolian_people's_party",
    text = "The Inner Mongolian People's Party",
    flag = path:format("the_inner_mongolian_people's_party"),
  }
  Nations[#Nations+1] = {
    value = "the_islands_of_refreshment",
    text = "The Islands Of Refreshment",
    flag = path:format("the_islands_of_refreshment"),
  }
  Nations[#Nations+1] = {
    value = "the_isle_of_man",
    text = "The Isle Of Man",
    flag = path:format("the_isle_of_man"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_araucania_and_patagonia",
    text = "The Kingdom Of Araucania And Patagonia",
    flag = path:format("the_kingdom_of_araucania_and_patagonia"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_lau",
    text = "The Kingdom Of Lau",
    flag = path:format("the_kingdom_of_lau"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_mangareva",
    text = "The Kingdom Of Mangareva",
    flag = path:format("the_kingdom_of_mangareva"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_redonda",
    text = "The Kingdom Of Redonda",
    flag = path:format("the_kingdom_of_redonda"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_rimatara",
    text = "The Kingdom Of Rimatara",
    flag = path:format("the_kingdom_of_rimatara"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_tahiti",
    text = "The Kingdom Of Tahiti",
    flag = path:format("the_kingdom_of_tahiti"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_talossa",
    text = "The Kingdom Of Talossa",
    flag = path:format("the_kingdom_of_talossa"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_the_two_sicilies",
    text = "The Kingdom Of The Two Sicilies",
    flag = path:format("the_kingdom_of_the_two_sicilies"),
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_yugoslavia",
    text = "The Kingdom Of Yugoslavia",
    flag = path:format("the_kingdom_of_yugoslavia"),
  }
  Nations[#Nations+1] = {
    value = "the_mapuches",
    text = "The Mapuches",
    flag = path:format("the_mapuches"),
  }
  Nations[#Nations+1] = {
    value = "the_maratha_empire",
    text = "The Maratha Empire",
    flag = path:format("the_maratha_empire"),
  }
  Nations[#Nations+1] = {
    value = "the_marshall_islands",
    text = "The Marshall Islands",
    flag = path:format("the_marshall_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_mengjiang",
    text = "The Mengjiang",
    flag = path:format("the_mengjiang"),
  }
  Nations[#Nations+1] = {
    value = "the_midway_islands",
    text = "The Midway Islands",
    flag = path:format("the_midway_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_moro_islamic_liberation_front",
    text = "The Moro Islamic Liberation Front",
    flag = path:format("the_moro_islamic_liberation_front"),
  }
  Nations[#Nations+1] = {
    value = "the_mughal_empire",
    text = "The Mughal Empire",
    flag = path:format("the_mughal_empire"),
  }
  Nations[#Nations+1] = {
    value = "the_National_Front_for_the_Liberation_of_Southern_Vietnam",
    text = "The National Front For The Liberation Of Southern Vietnam",
    flag = path:format("the_National_Front_for_the_Liberation_of_Southern_Vietnam"),
  }
  Nations[#Nations+1] = {
    value = "the_netherlands",
    text = "The Netherlands",
    flag = path:format("the_netherlands"),
  }
  Nations[#Nations+1] = {
    value = "the_northern_mariana_islands",
    text = "The Northern Mariana Islands",
    flag = path:format("the_northern_mariana_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_orange_free_state",
    text = "The Orange Free State",
    flag = path:format("the_orange_free_state"),
  }
  Nations[#Nations+1] = {
    value = "the_oromo_liberation_front",
    text = "The Oromo Liberation Front",
    flag = path:format("the_oromo_liberation_front"),
  }
  Nations[#Nations+1] = {
    value = "the_pattani_united_liberation_organisation",
    text = "The Pattani United Liberation Organisation",
    flag = path:format("the_pattani_united_liberation_organisation"),
  }
  Nations[#Nations+1] = {
    value = "the_people's_republic_of_china",
    text = "The People's Republic Of China",
    flag = path:format("the_people's_republic_of_china"),
  }
  Nations[#Nations+1] = {
    value = "the_peru-bolivian_confederation",
    text = "The Peru-bolivian Confederation",
    flag = path:format("the_peru-bolivian_confederation"),
  }
  Nations[#Nations+1] = {
    value = "the_philippines",
    text = "The Philippines",
    flag = path:format("the_philippines"),
  }
  Nations[#Nations+1] = {
    value = "the_pitcairn_islands",
    text = "The Pitcairn Islands",
    flag = path:format("the_pitcairn_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_principality_of_trinidad",
    text = "The Principality Of Trinidad",
    flag = path:format("the_principality_of_trinidad"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_alsace-lorraine",
    text = "The Republic Of Alsace-lorraine",
    flag = path:format("the_republic_of_alsace-lorraine"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_benin",
    text = "The Republic Of Benin",
    flag = path:format("the_republic_of_benin"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_central_highlands_and_champa",
    text = "The Republic Of Central Highlands And Champa",
    flag = path:format("the_republic_of_central_highlands_and_champa"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_china",
    text = "The Republic Of China",
    flag = path:format("the_republic_of_china"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_lower_california",
    text = "The Republic Of Lower California",
    flag = path:format("the_republic_of_lower_california"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_molossia",
    text = "The Republic Of Molossia",
    flag = path:format("the_republic_of_molossia"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_sonora",
    text = "The Republic Of Sonora",
    flag = path:format("the_republic_of_sonora"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_talossa",
    text = "The Republic Of Talossa",
    flag = path:format("the_republic_of_talossa"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_texas",
    text = "The Republic Of Texas",
    flag = path:format("the_republic_of_texas"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_the_congo",
    text = "The Republic Of The Congo",
    flag = path:format("the_republic_of_the_congo"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_the_rif",
    text = "The Republic Of The Rif",
    flag = path:format("the_republic_of_the_rif"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_the_rio_grande",
    text = "The Republic Of The Rio Grande",
    flag = path:format("the_republic_of_the_rio_grande"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_western_bosnia",
    text = "The Republic Of Western Bosnia",
    flag = path:format("the_republic_of_western_bosnia"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_yucatan",
    text = "The Republic Of Yucatan",
    flag = path:format("the_republic_of_yucatan"),
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_zamboanga",
    text = "The Republic Of Zamboanga",
    flag = path:format("the_republic_of_zamboanga"),
  }
  Nations[#Nations+1] = {
    value = "the_ross_dependency",
    text = "The Ross Dependency",
    flag = path:format("the_ross_dependency"),
  }
  Nations[#Nations+1] = {
    value = "the_sahrawi_arab_democratic_republic",
    text = "The Sahrawi Arab Democratic Republic",
    flag = path:format("the_sahrawi_arab_democratic_republic"),
  }
  Nations[#Nations+1] = {
    value = "the_solomon_islands",
    text = "The Solomon Islands",
    flag = path:format("the_solomon_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_soviet_union",
    text = "The Soviet Union",
    flag = path:format("the_soviet_union"),
  }
  Nations[#Nations+1] = {
    value = "the_sultanate_of_banten",
    text = "The Sultanate Of Banten",
    flag = path:format("the_sultanate_of_banten"),
  }
  Nations[#Nations+1] = {
    value = "the_sultanate_of_mataram",
    text = "The Sultanate Of Mataram",
    flag = path:format("the_sultanate_of_mataram"),
  }
  Nations[#Nations+1] = {
    value = "the_sultanate_of_zanzibar",
    text = "The Sultanate Of Zanzibar",
    flag = path:format("the_sultanate_of_zanzibar"),
  }
  Nations[#Nations+1] = {
    value = "the_tagalog_people",
    text = "The Tagalog People",
    flag = path:format("the_tagalog_people"),
  }
  Nations[#Nations+1] = {
    value = "the_transcaucasian_federation",
    text = "The Transcaucasian Federation",
    flag = path:format("the_transcaucasian_federation"),
  }
  Nations[#Nations+1] = {
    value = "the_tuamotu_kingdom",
    text = "The Tuamotu Kingdom",
    flag = path:format("the_tuamotu_kingdom"),
  }
  Nations[#Nations+1] = {
    value = "the_turkish_republic_of_northern_cyprus",
    text = "The Turkish Republic Of Northern Cyprus",
    flag = path:format("the_turkish_republic_of_northern_cyprus"),
  }
  Nations[#Nations+1] = {
    value = "the_turks_and_caicos_islands",
    text = "The Turks And Caicos Islands",
    flag = path:format("the_turks_and_caicos_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_tuvan_people's_republic",
    text = "The Tuvan People's Republic",
    flag = path:format("the_tuvan_people's_republic"),
  }
  Nations[#Nations+1] = {
    value = "the_united_arab_emirates",
    text = "The United Arab Emirates",
    flag = path:format("the_united_arab_emirates"),
  }
  Nations[#Nations+1] = {
    value = "the_united_kingdom",
    text = "The United Kingdom",
    flag = path:format("the_united_kingdom"),
  }
  Nations[#Nations+1] = {
    value = "the_united_states",
    text = "The United States",
    flag = path:format("the_united_states"),
  }
  Nations[#Nations+1] = {
    value = "the_united_states_virgin_islands",
    text = "The United States Virgin Islands",
    flag = path:format("the_united_states_virgin_islands"),
  }
  Nations[#Nations+1] = {
    value = "the_united_tribes_of_fiji_1865-1867",
    text = "The United Tribes Of Fiji 1865-1867",
    flag = path:format("the_united_tribes_of_fiji_1865-1867"),
  }
  Nations[#Nations+1] = {
    value = "the_united_tribes_of_fiji_1867-1869",
    text = "The United Tribes Of Fiji 1867-1869",
    flag = path:format("the_united_tribes_of_fiji_1867-1869"),
  }
  Nations[#Nations+1] = {
    value = "the_vatican_city",
    text = "The Vatican City",
    flag = path:format("the_vatican_city"),
  }
  Nations[#Nations+1] = {
    value = "the_vermont_republic",
    text = "The Vermont Republic",
    flag = path:format("the_vermont_republic"),
  }
  Nations[#Nations+1] = {
    value = "the_west_indies_federation",
    text = "The West Indies Federation",
    flag = path:format("the_west_indies_federation"),
  }
  Nations[#Nations+1] = {
    value = "tibet",
    text = "Tibet",
    flag = path:format("tibet"),
  }
  Nations[#Nations+1] = {
    value = "tknara",
    text = "Tknara",
    flag = path:format("tknara"),
  }
  Nations[#Nations+1] = {
    value = "togo",
    text = "Togo",
    flag = path:format("togo"),
  }
  Nations[#Nations+1] = {
    value = "tokelau",
    text = "Tokelau",
    flag = path:format("tokelau"),
  }
  Nations[#Nations+1] = {
    value = "tonga",
    text = "Tonga",
    flag = path:format("tonga"),
  }
  Nations[#Nations+1] = {
    value = "transkei",
    text = "Transkei",
    flag = path:format("transkei"),
  }
  Nations[#Nations+1] = {
    value = "transnistria",
    text = "Transnistria",
    flag = path:format("transnistria"),
  }
  Nations[#Nations+1] = {
    value = "transvaal",
    text = "Transvaal",
    flag = path:format("transvaal"),
  }
  Nations[#Nations+1] = {
    value = "trinidad_and_tobago",
    text = "Trinidad And Tobago",
    flag = path:format("trinidad_and_tobago"),
  }
  Nations[#Nations+1] = {
    value = "tristan_da_cunha",
    text = "Tristan Da Cunha",
    flag = path:format("tristan_da_cunha"),
  }
  Nations[#Nations+1] = {
    value = "tunisia",
    text = "Tunisia",
    flag = path:format("tunisia"),
  }
  Nations[#Nations+1] = {
    value = "turkey",
    text = "Turkey",
    flag = path:format("turkey"),
  }
  Nations[#Nations+1] = {
    value = "turkmenistan",
    text = "Turkmenistan",
    flag = path:format("turkmenistan"),
  }
  Nations[#Nations+1] = {
    value = "tuvalu",
    text = "Tuvalu",
    flag = path:format("tuvalu"),
  }
  Nations[#Nations+1] = {
    value = "uganda",
    text = "Uganda",
    flag = path:format("uganda"),
  }
  Nations[#Nations+1] = {
    value = "ukraine",
    text = "Ukraine",
    flag = path:format("ukraine"),
  }
  Nations[#Nations+1] = {
    value = "ukrainian_ssr",
    text = "Ukrainian SSR",
    flag = path:format("ukrainian_ssr"),
  }
  Nations[#Nations+1] = {
    value = "uruguay",
    text = "Uruguay",
    flag = path:format("uruguay"),
  }
  Nations[#Nations+1] = {
    value = "uzbekistan",
    text = "Uzbekistan",
    flag = path:format("uzbekistan"),
  }
  Nations[#Nations+1] = {
    value = "vanuatu",
    text = "Vanuatu",
    flag = path:format("vanuatu"),
  }
  Nations[#Nations+1] = {
    value = "venda",
    text = "Venda",
    flag = path:format("venda"),
  }
  Nations[#Nations+1] = {
    value = "venezuela",
    text = "Venezuela",
    flag = path:format("venezuela"),
  }
  Nations[#Nations+1] = {
    value = "vietnam",
    text = "Vietnam",
    flag = path:format("vietnam"),
  }
  Nations[#Nations+1] = {
    value = "vojvodina",
    text = "Vojvodina",
    flag = path:format("vojvodina"),
  }
  Nations[#Nations+1] = {
    value = "wake_island",
    text = "Wake Island",
    flag = path:format("wake_island"),
  }
  Nations[#Nations+1] = {
    value = "wales",
    text = "Wales",
    flag = path:format("wales"),
  }
  Nations[#Nations+1] = {
    value = "wallis_and_futuna",
    text = "Wallis And Futuna",
    flag = path:format("wallis_and_futuna"),
  }
  Nations[#Nations+1] = {
    value = "yemen",
    text = "Yemen",
    flag = path:format("yemen"),
  }
  Nations[#Nations+1] = {
    value = "zambia",
    text = "Zambia",
    flag = path:format("zambia"),
  }
  Nations[#Nations+1] = {
    value = "zanzibar",
    text = "Zanzibar",
    flag = path:format("zanzibar"),
  }
  Nations[#Nations+1] = {
    value = "zimbabwe",
    text = "Zimbabwe",
    flag = path:format("zimbabwe"),
  }
  Nations[#Nations+1] = {
    value = "zomi_re-unification_organisation",
    text = "Zomi Re-unification Organisation",
    flag = path:format("zomi_re-unification_organisation"),
  }

  const.FullTransitionToMarsNames = 9999

  -- add list of names from earlier for each nation
  for i = 1, #Nations do
    HumanNames[Nations[i].value] = name_table
--~     -- skip the countries added by the game (unless it's Mars)
--~     if Nations[i].value == "Mars" or type(Nations[i].text) == "string" then
--~       HumanNames[Nations[i].value] = name_table
--~     else
--~       if HumanNames[Nations[i].value] then
--~         HumanNames[Nations[i].value].Unique = name_table.Unique
--~       end
--~     end
  end

  -- replace the func that gets a nation (it gets a weighted nation depending on your sponsors instead of all of them)
  function GetWeightedRandNation()
    return Nations[AsyncRand(#Nations - 1 + 1) + 1].value
  end

end
