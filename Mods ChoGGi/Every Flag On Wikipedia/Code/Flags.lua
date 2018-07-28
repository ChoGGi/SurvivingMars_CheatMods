-- See LICENSE for terms

-- just in case anyone adds some custom HumanNames
function OnMsg.ModsLoaded()

  local EveryFlagOnWikipedia = EveryFlagOnWikipedia
  local Random = Random
  local T = T
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

  -- makes it easier to access the flags
  MountFolder("EveryFlagOnWikipedia",EveryFlagOnWikipedia.ComFuncs.TableConcat{EveryFlagOnWikipedia.ModPath,"Flags/"})

  local Nations = Nations

  -- instead of just replacing the orig table we add on to it (just in case more nations are added, maybe by a mod)
  Nations[#Nations+1] = {
    value = "abkhazia",
    text = "Abkhazia",
    flag = "EveryFlagOnWikipedia/flag_abkhazia.tga",
  }
  Nations[#Nations+1] = {
    value = "afghanistan",
    text = "Afghanistan",
    flag = "EveryFlagOnWikipedia/flag_afghanistan.tga",
  }
  Nations[#Nations+1] = {
    value = "aland",
    text = "Aland",
    flag = "EveryFlagOnWikipedia/flag_aland.tga",
  }
  Nations[#Nations+1] = {
    value = "alaska",
    text = "Alaska",
    flag = "EveryFlagOnWikipedia/flag_alaska.tga",
  }
  Nations[#Nations+1] = {
    value = "albania",
    text = "Albania",
    flag = "EveryFlagOnWikipedia/flag_albania.tga",
  }
  Nations[#Nations+1] = {
    value = "alderney",
    text = "Alderney",
    flag = "EveryFlagOnWikipedia/flag_alderney.tga",
  }
  Nations[#Nations+1] = {
    value = "algeria",
    text = "Algeria",
    flag = "EveryFlagOnWikipedia/flag_algeria.tga",
  }
  Nations[#Nations+1] = {
    value = "american_samoa",
    text = "American Samoa",
    flag = "EveryFlagOnWikipedia/flag_american_samoa.tga",
  }
  Nations[#Nations+1] = {
    value = "andorra",
    text = "Andorra",
    flag = "EveryFlagOnWikipedia/flag_andorra.tga",
  }
  Nations[#Nations+1] = {
    value = "angola",
    text = "Angola",
    flag = "EveryFlagOnWikipedia/flag_angola.tga",
  }
  Nations[#Nations+1] = {
    value = "anguilla",
    text = "Anguilla",
    flag = "EveryFlagOnWikipedia/flag_anguilla.tga",
  }
  Nations[#Nations+1] = {
    value = "anjouan",
    text = "Anjouan",
    flag = "EveryFlagOnWikipedia/flag_anjouan.tga",
  }
  Nations[#Nations+1] = {
    value = "antigua_and_barbuda",
    text = "Antigua And Barbuda",
    flag = "EveryFlagOnWikipedia/flag_antigua_and_barbuda.tga",
  }
  Nations[#Nations+1] = {
    value = "argentina",
    text = "Argentina",
    flag = "EveryFlagOnWikipedia/flag_argentina.tga",
  }
  Nations[#Nations+1] = {
    value = "armenia",
    text = "Armenia",
    flag = "EveryFlagOnWikipedia/flag_armenia.tga",
  }
  Nations[#Nations+1] = {
    value = "artsakh",
    text = "Artsakh",
    flag = "EveryFlagOnWikipedia/flag_artsakh.tga",
  }
  Nations[#Nations+1] = {
    value = "aruba",
    text = "Aruba",
    flag = "EveryFlagOnWikipedia/flag_aruba.tga",
  }
  Nations[#Nations+1] = {
    value = "ascension_island",
    text = "Ascension Island",
    flag = "EveryFlagOnWikipedia/flag_ascension_island.tga",
  }
  Nations[#Nations+1] = {
    value = "ashanti",
    text = "Ashanti",
    flag = "EveryFlagOnWikipedia/flag_ashanti.tga",
  }
  Nations[#Nations+1] = {
    value = "australia",
    text = "Australia",
    flag = "EveryFlagOnWikipedia/flag_australia.tga",
  }
  Nations[#Nations+1] = {
    value = "austria-hungary",
    text = "Austria-hungary",
    flag = "EveryFlagOnWikipedia/flag_austria-hungary.tga",
  }
  Nations[#Nations+1] = {
    value = "austria",
    text = "Austria",
    flag = "EveryFlagOnWikipedia/flag_austria.tga",
  }
  Nations[#Nations+1] = {
    value = "azerbaijan",
    text = "Azerbaijan",
    flag = "EveryFlagOnWikipedia/flag_azerbaijan.tga",
  }
  Nations[#Nations+1] = {
    value = "bahrain",
    text = "Bahrain",
    flag = "EveryFlagOnWikipedia/flag_bahrain.tga",
  }
  Nations[#Nations+1] = {
    value = "balawaristan",
    text = "Balawaristan",
    flag = "EveryFlagOnWikipedia/flag_balawaristan.tga",
  }
  Nations[#Nations+1] = {
    value = "bamileke_national_movement",
    text = "Bamileke National Movement",
    flag = "EveryFlagOnWikipedia/flag_bamileke_national_movement.tga",
  }
  Nations[#Nations+1] = {
    value = "bangladesh",
    text = "Bangladesh",
    flag = "EveryFlagOnWikipedia/flag_bangladesh.tga",
  }
  Nations[#Nations+1] = {
    value = "barbados",
    text = "Barbados",
    flag = "EveryFlagOnWikipedia/flag_barbados.tga",
  }
  Nations[#Nations+1] = {
    value = "bavaria",
    text = "Bavaria",
    flag = "EveryFlagOnWikipedia/flag_bavaria.tga",
  }
  Nations[#Nations+1] = {
    value = "belarus",
    text = "Belarus",
    flag = "EveryFlagOnWikipedia/flag_belarus.tga",
  }
  Nations[#Nations+1] = {
    value = "belgium",
    text = "Belgium",
    flag = "EveryFlagOnWikipedia/flag_belgium.tga",
  }
  Nations[#Nations+1] = {
    value = "belize",
    text = "Belize",
    flag = "EveryFlagOnWikipedia/flag_belize.tga",
  }
  Nations[#Nations+1] = {
    value = "benin",
    text = "Benin",
    flag = "EveryFlagOnWikipedia/flag_benin.tga",
  }
  Nations[#Nations+1] = {
    value = "bermuda",
    text = "Bermuda",
    flag = "EveryFlagOnWikipedia/flag_bermuda.tga",
  }
  Nations[#Nations+1] = {
    value = "bhutan",
    text = "Bhutan",
    flag = "EveryFlagOnWikipedia/flag_bhutan.tga",
  }
  Nations[#Nations+1] = {
    value = "biafra",
    text = "Biafra",
    flag = "EveryFlagOnWikipedia/flag_biafra.tga",
  }
  Nations[#Nations+1] = {
    value = "bolivia",
    text = "Bolivia",
    flag = "EveryFlagOnWikipedia/flag_bolivia.tga",
  }
  Nations[#Nations+1] = {
    value = "bonaire",
    text = "Bonaire",
    flag = "EveryFlagOnWikipedia/flag_bonaire.tga",
  }
  Nations[#Nations+1] = {
    value = "bonnie_blue_flag_the_confederate_states_of_america",
    text = "Bonnie Blue Flag The Confederate States Of America",
    flag = "EveryFlagOnWikipedia/flag_bonnie_blue_flag_the_confederate_states_of_america.tga",
  }
  Nations[#Nations+1] = {
    value = "bophuthatswana",
    text = "Bophuthatswana",
    flag = "EveryFlagOnWikipedia/flag_bophuthatswana.tga",
  }
  Nations[#Nations+1] = {
    value = "bora_bora",
    text = "Bora Bora",
    flag = "EveryFlagOnWikipedia/flag_bora_bora.tga",
  }
  Nations[#Nations+1] = {
    value = "bosnia_and_herzegovina",
    text = "Bosnia And Herzegovina",
    flag = "EveryFlagOnWikipedia/flag_bosnia_and_herzegovina.tga",
  }
  Nations[#Nations+1] = {
    value = "botswana",
    text = "Botswana",
    flag = "EveryFlagOnWikipedia/flag_botswana.tga",
  }
  Nations[#Nations+1] = {
    value = "bougainville",
    text = "Bougainville",
    flag = "EveryFlagOnWikipedia/flag_bougainville.tga",
  }
  Nations[#Nations+1] = {
    value = "brazil",
    text = "Brazil",
    flag = "EveryFlagOnWikipedia/flag_brazil.tga",
  }
  Nations[#Nations+1] = {
    value = "brittany",
    text = "Brittany",
    flag = "EveryFlagOnWikipedia/flag_brittany.tga",
  }
  Nations[#Nations+1] = {
    value = "brunei",
    text = "Brunei",
    flag = "EveryFlagOnWikipedia/flag_brunei.tga",
  }
  Nations[#Nations+1] = {
    value = "bulgaria",
    text = "Bulgaria",
    flag = "EveryFlagOnWikipedia/flag_bulgaria.tga",
  }
  Nations[#Nations+1] = {
    value = "bumbunga",
    text = "Bumbunga",
    flag = "EveryFlagOnWikipedia/flag_bumbunga.tga",
  }
  Nations[#Nations+1] = {
    value = "burkina_faso",
    text = "Burkina Faso",
    flag = "EveryFlagOnWikipedia/flag_burkina_faso.tga",
  }
  Nations[#Nations+1] = {
    value = "burundi",
    text = "Burundi",
    flag = "EveryFlagOnWikipedia/flag_burundi.tga",
  }
  Nations[#Nations+1] = {
    value = "byelorussian_ssr",
    text = "Byelorussian SSR",
    flag = "EveryFlagOnWikipedia/flag_byelorussian_ssr.tga",
  }
  Nations[#Nations+1] = {
    value = "cabinda",
    text = "Cabinda",
    flag = "EveryFlagOnWikipedia/flag_cabinda.tga",
  }
  Nations[#Nations+1] = {
    value = "california",
    text = "California",
    flag = "EveryFlagOnWikipedia/flag_california.tga",
  }
  Nations[#Nations+1] = {
    value = "california_independence",
    text = "California Independence",
    flag = "EveryFlagOnWikipedia/flag_california_independence.tga",
  }
  Nations[#Nations+1] = {
    value = "cambodia",
    text = "Cambodia",
    flag = "EveryFlagOnWikipedia/flag_cambodia.tga",
  }
  Nations[#Nations+1] = {
    value = "cameroon",
    text = "Cameroon",
    flag = "EveryFlagOnWikipedia/flag_cameroon.tga",
  }
  Nations[#Nations+1] = {
    value = "canada",
    text = "Canada",
    flag = "EveryFlagOnWikipedia/flag_canada.tga",
  }
  Nations[#Nations+1] = {
    value = "cantabrian_labaru",
    text = "Cantabrian Labaru",
    flag = "EveryFlagOnWikipedia/flag_cantabrian_labaru.tga",
  }
  Nations[#Nations+1] = {
    value = "canu",
    text = "Canu",
    flag = "EveryFlagOnWikipedia/flag_canu.tga",
  }
  Nations[#Nations+1] = {
    value = "cape_verde",
    text = "Cape Verde",
    flag = "EveryFlagOnWikipedia/flag_cape_verde.tga",
  }
  Nations[#Nations+1] = {
    value = "casamance",
    text = "Casamance",
    flag = "EveryFlagOnWikipedia/flag_casamance.tga",
  }
  Nations[#Nations+1] = {
    value = "cascadia",
    text = "Cascadia",
    flag = "EveryFlagOnWikipedia/flag_cascadia.tga",
  }
  Nations[#Nations+1] = {
    value = "castile",
    text = "Castile",
    flag = "EveryFlagOnWikipedia/flag_castile.tga",
  }
  Nations[#Nations+1] = {
    value = "chad",
    text = "Chad",
    flag = "EveryFlagOnWikipedia/flag_chad.tga",
  }
  Nations[#Nations+1] = {
    value = "chechen_republic_of_ichkeria",
    text = "Chechen Republic Of Ichkeria",
    flag = "EveryFlagOnWikipedia/flag_chechen_republic_of_ichkeria.tga",
  }
  Nations[#Nations+1] = {
    value = "chile",
    text = "Chile",
    flag = "EveryFlagOnWikipedia/flag_chile.tga",
  }
  Nations[#Nations+1] = {
    value = "chin_national_front",
    text = "Chin National Front",
    flag = "EveryFlagOnWikipedia/flag_chin_national_front.tga",
  }
  Nations[#Nations+1] = {
    value = "christmas_island",
    text = "Christmas Island",
    flag = "EveryFlagOnWikipedia/flag_christmas_island.tga",
  }
  Nations[#Nations+1] = {
    value = "ciskei",
    text = "Ciskei",
    flag = "EveryFlagOnWikipedia/flag_ciskei.tga",
  }
  Nations[#Nations+1] = {
    value = "colombia",
    text = "Colombia",
    flag = "EveryFlagOnWikipedia/flag_colombia.tga",
  }
  Nations[#Nations+1] = {
    value = "cornwall",
    text = "Cornwall",
    flag = "EveryFlagOnWikipedia/flag_cornwall.tga",
  }
  Nations[#Nations+1] = {
    value = "corsica",
    text = "Corsica",
    flag = "EveryFlagOnWikipedia/flag_corsica.tga",
  }
  Nations[#Nations+1] = {
    value = "cospaia",
    text = "Cospaia",
    flag = "EveryFlagOnWikipedia/flag_cospaia.tga",
  }
  Nations[#Nations+1] = {
    value = "costa_rica",
    text = "Costa Rica",
    flag = "EveryFlagOnWikipedia/flag_costa_rica.tga",
  }
  Nations[#Nations+1] = {
    value = "cote_divoire",
    text = "Cote Divoire",
    flag = "EveryFlagOnWikipedia/flag_cote_divoire.tga",
  }
  Nations[#Nations+1] = {
    value = "cretan_state",
    text = "Cretan State",
    flag = "EveryFlagOnWikipedia/flag_cretan_state.tga",
  }
  Nations[#Nations+1] = {
    value = "crimea",
    text = "Crimea",
    flag = "EveryFlagOnWikipedia/flag_crimea.tga",
  }
  Nations[#Nations+1] = {
    value = "croatia",
    text = "Croatia",
    flag = "EveryFlagOnWikipedia/flag_croatia.tga",
  }
  Nations[#Nations+1] = {
    value = "cuba",
    text = "Cuba",
    flag = "EveryFlagOnWikipedia/flag_cuba.tga",
  }
  Nations[#Nations+1] = {
    value = "curacao",
    text = "Curacao",
    flag = "EveryFlagOnWikipedia/flag_curacao.tga",
  }
  Nations[#Nations+1] = {
    value = "cyprus",
    text = "Cyprus",
    flag = "EveryFlagOnWikipedia/flag_cyprus.tga",
  }
  Nations[#Nations+1] = {
    value = "dar_el_kuti_republic",
    text = "Dar El Kuti Republic",
    flag = "EveryFlagOnWikipedia/flag_dar_el_kuti_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "denmark",
    text = "Denmark",
    flag = "EveryFlagOnWikipedia/flag_denmark.tga",
  }
  Nations[#Nations+1] = {
    value = "djibouti",
    text = "Djibouti",
    flag = "EveryFlagOnWikipedia/flag_djibouti.tga",
  }
  Nations[#Nations+1] = {
    value = "dominica",
    text = "Dominica",
    flag = "EveryFlagOnWikipedia/flag_dominica.tga",
  }
  Nations[#Nations+1] = {
    value = "donetsk_oblast",
    text = "Donetsk Oblast",
    flag = "EveryFlagOnWikipedia/flag_donetsk_oblast.tga",
  }
  Nations[#Nations+1] = {
    value = "eastern_rumelia",
    text = "Eastern Rumelia",
    flag = "EveryFlagOnWikipedia/flag_eastern_rumelia.tga",
  }
  Nations[#Nations+1] = {
    value = "easter_island",
    text = "Easter Island",
    flag = "EveryFlagOnWikipedia/flag_easter_island.tga",
  }
  Nations[#Nations+1] = {
    value = "east_germany",
    text = "East Germany",
    flag = "EveryFlagOnWikipedia/flag_east_germany.tga",
  }
  Nations[#Nations+1] = {
    value = "east_timor",
    text = "East Timor",
    flag = "EveryFlagOnWikipedia/flag_east_timor.tga",
  }
  Nations[#Nations+1] = {
    value = "ecuador",
    text = "Ecuador",
    flag = "EveryFlagOnWikipedia/flag_ecuador.tga",
  }
  Nations[#Nations+1] = {
    value = "egypt",
    text = "Egypt",
    flag = "EveryFlagOnWikipedia/flag_egypt.tga",
  }
  Nations[#Nations+1] = {
    value = "el_salvador",
    text = "El Salvador",
    flag = "EveryFlagOnWikipedia/flag_el_salvador.tga",
  }
  Nations[#Nations+1] = {
    value = "enenkio",
    text = "Enenkio",
    flag = "EveryFlagOnWikipedia/flag_enenkio.tga",
  }
  Nations[#Nations+1] = {
    value = "england",
    text = "England",
    flag = "EveryFlagOnWikipedia/flag_england.tga",
  }
  Nations[#Nations+1] = {
    value = "equatorial_guinea",
    text = "Equatorial Guinea",
    flag = "EveryFlagOnWikipedia/flag_equatorial_guinea.tga",
  }
  Nations[#Nations+1] = {
    value = "eritrea",
    text = "Eritrea",
    flag = "EveryFlagOnWikipedia/flag_eritrea.tga",
  }
  Nations[#Nations+1] = {
    value = "estonia",
    text = "Estonia",
    flag = "EveryFlagOnWikipedia/flag_estonia.tga",
  }
  Nations[#Nations+1] = {
    value = "ethiopia",
    text = "Ethiopia",
    flag = "EveryFlagOnWikipedia/flag_ethiopia.tga",
  }
  Nations[#Nations+1] = {
    value = "evis",
    text = "Evis",
    flag = "EveryFlagOnWikipedia/flag_evis.tga",
  }
  Nations[#Nations+1] = {
    value = "fiji",
    text = "Fiji",
    flag = "EveryFlagOnWikipedia/flag_fiji.tga",
  }
  Nations[#Nations+1] = {
    value = "finland",
    text = "Finland",
    flag = "EveryFlagOnWikipedia/flag_finland.tga",
  }
  Nations[#Nations+1] = {
    value = "flnks",
    text = "Front de Libération Nationale Kanak et Socialiste",
    flag = "EveryFlagOnWikipedia/flag_flnks.tga",
  }
  Nations[#Nations+1] = {
    value = "forcas_and_careiras",
    text = "Forcas And Careiras",
    flag = "EveryFlagOnWikipedia/flag_forcas_and_careiras.tga",
  }
  Nations[#Nations+1] = {
    value = "formosa",
    text = "Formosa",
    flag = "EveryFlagOnWikipedia/flag_formosa.tga",
  }
  Nations[#Nations+1] = {
    value = "france",
    text = "France",
    flag = "EveryFlagOnWikipedia/flag_france.tga",
  }
  Nations[#Nations+1] = {
    value = "franceville",
    text = "Franceville",
    flag = "EveryFlagOnWikipedia/flag_franceville.tga",
  }
  Nations[#Nations+1] = {
    value = "free_aceh_movement",
    text = "Free Aceh Movement",
    flag = "EveryFlagOnWikipedia/flag_free_aceh_movement.tga",
  }
  Nations[#Nations+1] = {
    value = "free_morbhan_republic",
    text = "Free Morbhan Republic",
    flag = "EveryFlagOnWikipedia/flag_free_morbhan_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "free_territory_trieste",
    text = "Free Territory Trieste",
    flag = "EveryFlagOnWikipedia/flag_free_territory_trieste.tga",
  }
  Nations[#Nations+1] = {
    value = "french_guiana",
    text = "French Guiana",
    flag = "EveryFlagOnWikipedia/flag_french_guiana.tga",
  }
  Nations[#Nations+1] = {
    value = "french_polynesia",
    text = "French Polynesia",
    flag = "EveryFlagOnWikipedia/flag_french_polynesia.tga",
  }
  Nations[#Nations+1] = {
    value = "gabon",
    text = "Gabon",
    flag = "EveryFlagOnWikipedia/flag_gabon.tga",
  }
  Nations[#Nations+1] = {
    value = "gdansk",
    text = "Gdansk",
    flag = "EveryFlagOnWikipedia/flag_gdansk.tga",
  }
  Nations[#Nations+1] = {
    value = "genoa",
    text = "Genoa",
    flag = "EveryFlagOnWikipedia/flag_genoa.tga",
  }
  Nations[#Nations+1] = {
    value = "georgia",
    text = "Georgia",
    flag = "EveryFlagOnWikipedia/flag_georgia.tga",
  }
  Nations[#Nations+1] = {
    value = "germany",
    text = "Germany",
    flag = "EveryFlagOnWikipedia/flag_germany.tga",
  }
  Nations[#Nations+1] = {
    value = "ghana",
    text = "Ghana",
    flag = "EveryFlagOnWikipedia/flag_ghana.tga",
  }
  Nations[#Nations+1] = {
    value = "gibraltar",
    text = "Gibraltar",
    flag = "EveryFlagOnWikipedia/flag_gibraltar.tga",
  }
  Nations[#Nations+1] = {
    value = "greece",
    text = "Greece",
    flag = "EveryFlagOnWikipedia/flag_greece.tga",
  }
  Nations[#Nations+1] = {
    value = "greenland",
    text = "Greenland",
    flag = "EveryFlagOnWikipedia/flag_greenland.tga",
  }
  Nations[#Nations+1] = {
    value = "grenada",
    text = "Grenada",
    flag = "EveryFlagOnWikipedia/flag_grenada.tga",
  }
  Nations[#Nations+1] = {
    value = "grobherzogtum_baden",
    text = "Grobherzogtum Baden",
    flag = "EveryFlagOnWikipedia/flag_grobherzogtum_baden.tga",
  }
  Nations[#Nations+1] = {
    value = "grobherzogtum_hessen_ohne_wappen",
    text = "Grobherzogtum Hessen Ohne Wappen",
    flag = "EveryFlagOnWikipedia/flag_grobherzogtum_hessen_ohne_wappen.tga",
  }
  Nations[#Nations+1] = {
    value = "guadeloupe",
    text = "Guadeloupe",
    flag = "EveryFlagOnWikipedia/flag_guadeloupe.tga",
  }
  Nations[#Nations+1] = {
    value = "guam",
    text = "Guam",
    flag = "EveryFlagOnWikipedia/flag_guam.tga",
  }
  Nations[#Nations+1] = {
    value = "guangdong",
    text = "Guangdong",
    flag = "EveryFlagOnWikipedia/flag_guangdong.tga",
  }
  Nations[#Nations+1] = {
    value = "guatemala",
    text = "Guatemala",
    flag = "EveryFlagOnWikipedia/flag_guatemala.tga",
  }
  Nations[#Nations+1] = {
    value = "guernsey",
    text = "Guernsey",
    flag = "EveryFlagOnWikipedia/flag_guernsey.tga",
  }
  Nations[#Nations+1] = {
    value = "guinea-bissau",
    text = "Guinea-bissau",
    flag = "EveryFlagOnWikipedia/flag_guinea-bissau.tga",
  }
  Nations[#Nations+1] = {
    value = "guinea",
    text = "Guinea",
    flag = "EveryFlagOnWikipedia/flag_guinea.tga",
  }
  Nations[#Nations+1] = {
    value = "gurkhaland",
    text = "Gurkhaland",
    flag = "EveryFlagOnWikipedia/flag_gurkhaland.tga",
  }
  Nations[#Nations+1] = {
    value = "guyana",
    text = "Guyana",
    flag = "EveryFlagOnWikipedia/flag_guyana.tga",
  }
  Nations[#Nations+1] = {
    value = "gwynedd",
    text = "Gwynedd",
    flag = "EveryFlagOnWikipedia/flag_gwynedd.tga",
  }
  Nations[#Nations+1] = {
    value = "haiti",
    text = "Haiti",
    flag = "EveryFlagOnWikipedia/flag_haiti.tga",
  }
  Nations[#Nations+1] = {
    value = "hawaii",
    text = "Hawaii",
    flag = "EveryFlagOnWikipedia/flag_hawaii.tga",
  }
  Nations[#Nations+1] = {
    value = "hejaz",
    text = "Hejaz",
    flag = "EveryFlagOnWikipedia/flag_hejaz.tga",
  }
  Nations[#Nations+1] = {
    value = "honduras",
    text = "Honduras",
    flag = "EveryFlagOnWikipedia/flag_honduras.tga",
  }
  Nations[#Nations+1] = {
    value = "hong_kong",
    text = "Hong Kong",
    flag = "EveryFlagOnWikipedia/flag_hong_kong.tga",
  }
  Nations[#Nations+1] = {
    value = "huahine",
    text = "Huahine",
    flag = "EveryFlagOnWikipedia/flag_huahine.tga",
  }
  Nations[#Nations+1] = {
    value = "hungary",
    text = "Hungary",
    flag = "EveryFlagOnWikipedia/flag_hungary.tga",
  }
  Nations[#Nations+1] = {
    value = "hyderabad_state",
    text = "Hyderabad State",
    flag = "EveryFlagOnWikipedia/flag_hyderabad_state.tga",
  }
  Nations[#Nations+1] = {
    value = "iceland",
    text = "Iceland",
    flag = "EveryFlagOnWikipedia/flag_iceland.tga",
  }
  Nations[#Nations+1] = {
    value = "idel-ural_state",
    text = "Idel-ural State",
    flag = "EveryFlagOnWikipedia/flag_idel-ural_state.tga",
  }
  Nations[#Nations+1] = {
    value = "independent_state_of_croatia",
    text = "Independent State Of Croatia",
    flag = "EveryFlagOnWikipedia/flag_independent_state_of_croatia.tga",
  }
  Nations[#Nations+1] = {
    value = "india",
    text = "India",
    flag = "EveryFlagOnWikipedia/flag_india.tga",
  }
  Nations[#Nations+1] = {
    value = "indonesia",
    text = "Indonesia",
    flag = "EveryFlagOnWikipedia/flag_indonesia.tga",
  }
  Nations[#Nations+1] = {
    value = "iran",
    text = "Iran",
    flag = "EveryFlagOnWikipedia/flag_iran.tga",
  }
  Nations[#Nations+1] = {
    value = "iraq",
    text = "Iraq",
    flag = "EveryFlagOnWikipedia/flag_iraq.tga",
  }
  Nations[#Nations+1] = {
    value = "ireland",
    text = "Ireland",
    flag = "EveryFlagOnWikipedia/flag_ireland.tga",
  }
  Nations[#Nations+1] = {
    value = "israel",
    text = "Israel",
    flag = "EveryFlagOnWikipedia/flag_israel.tga",
  }
  Nations[#Nations+1] = {
    value = "italy",
    text = "Italy",
    flag = "EveryFlagOnWikipedia/flag_italy.tga",
  }
  Nations[#Nations+1] = {
    value = "jamaica",
    text = "Jamaica",
    flag = "EveryFlagOnWikipedia/flag_jamaica.tga",
  }
  Nations[#Nations+1] = {
    value = "japan",
    text = "Japan",
    flag = "EveryFlagOnWikipedia/flag_japan.tga",
  }
  Nations[#Nations+1] = {
    value = "jersey",
    text = "Jersey",
    flag = "EveryFlagOnWikipedia/flag_jersey.tga",
  }
  Nations[#Nations+1] = {
    value = "johnston_atoll",
    text = "Johnston Atoll",
    flag = "EveryFlagOnWikipedia/flag_johnston_atoll.tga",
  }
  Nations[#Nations+1] = {
    value = "jordan",
    text = "Jordan",
    flag = "EveryFlagOnWikipedia/flag_jordan.tga",
  }
  Nations[#Nations+1] = {
    value = "kapok",
    text = "Kapok",
    flag = "EveryFlagOnWikipedia/flag_kapok.tga",
  }
  Nations[#Nations+1] = {
    value = "karen_national_liberation_army",
    text = "Karen National Liberation Army",
    flag = "EveryFlagOnWikipedia/flag_karen_national_liberation_army.tga",
  }
  Nations[#Nations+1] = {
    value = "karen_national_union",
    text = "Karen National Union",
    flag = "EveryFlagOnWikipedia/flag_karen_national_union.tga",
  }
  Nations[#Nations+1] = {
    value = "katanga",
    text = "Katanga",
    flag = "EveryFlagOnWikipedia/flag_katanga.tga",
  }
  Nations[#Nations+1] = {
    value = "kazakhstan",
    text = "Kazakhstan",
    flag = "EveryFlagOnWikipedia/flag_kazakhstan.tga",
  }
  Nations[#Nations+1] = {
    value = "kenya",
    text = "Kenya",
    flag = "EveryFlagOnWikipedia/flag_kenya.tga",
  }
  Nations[#Nations+1] = {
    value = "khalistans",
    text = "Khalistans",
    flag = "EveryFlagOnWikipedia/flag_khalistans.tga",
  }
  Nations[#Nations+1] = {
    value = "kingdom_of_kurdistan",
    text = "Kingdom Of Kurdistan",
    flag = "EveryFlagOnWikipedia/flag_kingdom_of_kurdistan.tga",
  }
  Nations[#Nations+1] = {
    value = "kiribati",
    text = "Kiribati",
    flag = "EveryFlagOnWikipedia/flag_kiribati.tga",
  }
  Nations[#Nations+1] = {
    value = "khmers_kampuchea_krom",
    text = "Khmers Kampuchea-Krom",
    flag = "EveryFlagOnWikipedia/flag_khmers_kampuchea_krom.tga",
  }
  Nations[#Nations+1] = {
    value = "kokbayraq",
    text = "Kokbayraq",
    flag = "EveryFlagOnWikipedia/flag_kokbayraq.tga",
  }
  Nations[#Nations+1] = {
    value = "konigreich_wurttemberg",
    text = "Konigreich Wurttemberg",
    flag = "EveryFlagOnWikipedia/flag_konigreich_wurttemberg.tga",
  }
  Nations[#Nations+1] = {
    value = "kosovo",
    text = "Kosovo",
    flag = "EveryFlagOnWikipedia/flag_kosovo.tga",
  }
  Nations[#Nations+1] = {
    value = "krusevo_republic",
    text = "Krusevo Republic",
    flag = "EveryFlagOnWikipedia/flag_krusevo_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "kuban_people's_republic",
    text = "Kuban People's Republic",
    flag = "EveryFlagOnWikipedia/flag_kuban_people's_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "kurdistan",
    text = "Kurdistan",
    flag = "EveryFlagOnWikipedia/flag_kurdistan.tga",
  }
  Nations[#Nations+1] = {
    value = "kuwait",
    text = "Kuwait",
    flag = "EveryFlagOnWikipedia/flag_kuwait.tga",
  }
  Nations[#Nations+1] = {
    value = "kyrgyzstan",
    text = "Kyrgyzstan",
    flag = "EveryFlagOnWikipedia/flag_kyrgyzstan.tga",
  }
  Nations[#Nations+1] = {
    value = "ladonia",
    text = "Ladonia",
    flag = "EveryFlagOnWikipedia/flag_ladonia.tga",
  }
  Nations[#Nations+1] = {
    value = "laos",
    text = "Laos",
    flag = "EveryFlagOnWikipedia/flag_laos.tga",
  }
  Nations[#Nations+1] = {
    value = "latvia",
    text = "Latvia",
    flag = "EveryFlagOnWikipedia/flag_latvia.tga",
  }
  Nations[#Nations+1] = {
    value = "lebanon",
    text = "Lebanon",
    flag = "EveryFlagOnWikipedia/flag_lebanon.tga",
  }
  Nations[#Nations+1] = {
    value = "lesotho",
    text = "Lesotho",
    flag = "EveryFlagOnWikipedia/flag_lesotho.tga",
  }
  Nations[#Nations+1] = {
    value = "liberia",
    text = "Liberia",
    flag = "EveryFlagOnWikipedia/flag_liberia.tga",
  }
  Nations[#Nations+1] = {
    value = "libya",
    text = "Libya",
    flag = "EveryFlagOnWikipedia/flag_libya.tga",
  }
  Nations[#Nations+1] = {
    value = "liechtenstein",
    text = "Liechtenstein",
    flag = "EveryFlagOnWikipedia/flag_liechtenstein.tga",
  }
  Nations[#Nations+1] = {
    value = "lithuania",
    text = "Lithuania",
    flag = "EveryFlagOnWikipedia/flag_lithuania.tga",
  }
  Nations[#Nations+1] = {
    value = "lorraine",
    text = "Lorraine",
    flag = "EveryFlagOnWikipedia/flag_lorraine.tga",
  }
  Nations[#Nations+1] = {
    value = "los_altos",
    text = "Los Altos",
    flag = "EveryFlagOnWikipedia/flag_los_altos.tga",
  }
  Nations[#Nations+1] = {
    value = "luxembourg",
    text = "Luxembourg",
    flag = "EveryFlagOnWikipedia/flag_luxembourg.tga",
  }
  Nations[#Nations+1] = {
    value = "macau",
    text = "Macau",
    flag = "EveryFlagOnWikipedia/flag_macau.tga",
  }
  Nations[#Nations+1] = {
    value = "macedonia",
    text = "Macedonia",
    flag = "EveryFlagOnWikipedia/flag_macedonia.tga",
  }
  Nations[#Nations+1] = {
    value = "madagascar",
    text = "Madagascar",
    flag = "EveryFlagOnWikipedia/flag_madagascar.tga",
  }
  Nations[#Nations+1] = {
    value = "magallanes",
    text = "Magallanes",
    flag = "EveryFlagOnWikipedia/flag_magallanes.tga",
  }
  Nations[#Nations+1] = {
    value = "maguindanao",
    text = "Maguindanao",
    flag = "EveryFlagOnWikipedia/flag_maguindanao.tga",
  }
  Nations[#Nations+1] = {
    value = "malawi",
    text = "Malawi",
    flag = "EveryFlagOnWikipedia/flag_malawi.tga",
  }
  Nations[#Nations+1] = {
    value = "malaysia",
    text = "Malaysia",
    flag = "EveryFlagOnWikipedia/flag_malaysia.tga",
  }
  Nations[#Nations+1] = {
    value = "maldives",
    text = "Maldives",
    flag = "EveryFlagOnWikipedia/flag_maldives.tga",
  }
  Nations[#Nations+1] = {
    value = "mali",
    text = "Mali",
    flag = "EveryFlagOnWikipedia/flag_mali.tga",
  }
  Nations[#Nations+1] = {
    value = "malta",
    text = "Malta",
    flag = "EveryFlagOnWikipedia/flag_malta.tga",
  }
  Nations[#Nations+1] = {
    value = "manchukuo",
    text = "Manchukuo",
    flag = "EveryFlagOnWikipedia/flag_manchukuo.tga",
  }
  Nations[#Nations+1] = {
    value = "mauritania",
    text = "Mauritania",
    flag = "EveryFlagOnWikipedia/flag_mauritania.tga",
  }
  Nations[#Nations+1] = {
    value = "mauritius",
    text = "Mauritius",
    flag = "EveryFlagOnWikipedia/flag_mauritius.tga",
  }
  Nations[#Nations+1] = {
    value = "mayotte",
    text = "Mayotte",
    flag = "EveryFlagOnWikipedia/flag_mayotte.tga",
  }
  Nations[#Nations+1] = {
    value = "merina_kingdom",
    text = "Merina Kingdom",
    flag = "EveryFlagOnWikipedia/flag_merina_kingdom.tga",
  }
  Nations[#Nations+1] = {
    value = "mexico",
    text = "Mexico",
    flag = "EveryFlagOnWikipedia/flag_mexico.tga",
  }
  Nations[#Nations+1] = {
    value = "minerva",
    text = "Minerva",
    flag = "EveryFlagOnWikipedia/flag_minerva.tga",
  }
  Nations[#Nations+1] = {
    value = "azawad_national_liberation_movement",
    text = "Azawad National Liberation Movement",
    flag = "EveryFlagOnWikipedia/flag_azawad_national_liberation_movement.tga",
  }
  Nations[#Nations+1] = {
    value = "moro_national_liberation_front",
    text = "Moro National Liberation Front",
    flag = "EveryFlagOnWikipedia/flag_moro_national_liberation_front.tga",
  }
  Nations[#Nations+1] = {
    value = "moheli",
    text = "Moheli",
    flag = "EveryFlagOnWikipedia/flag_moheli.tga",
  }
  Nations[#Nations+1] = {
    value = "moldova",
    text = "Moldova",
    flag = "EveryFlagOnWikipedia/flag_moldova.tga",
  }
  Nations[#Nations+1] = {
    value = "monaco",
    text = "Monaco",
    flag = "EveryFlagOnWikipedia/flag_monaco.tga",
  }
  Nations[#Nations+1] = {
    value = "mongolia",
    text = "Mongolia",
    flag = "EveryFlagOnWikipedia/flag_mongolia.tga",
  }
  Nations[#Nations+1] = {
    value = "montenegro",
    text = "Montenegro",
    flag = "EveryFlagOnWikipedia/flag_montenegro.tga",
  }
  Nations[#Nations+1] = {
    value = "montserrat",
    text = "Montserrat",
    flag = "EveryFlagOnWikipedia/flag_montserrat.tga",
  }
  Nations[#Nations+1] = {
    value = "morning_star",
    text = "Morning Star",
    flag = "EveryFlagOnWikipedia/flag_morning_star.tga",
  }
  Nations[#Nations+1] = {
    value = "morocco",
    text = "Morocco",
    flag = "EveryFlagOnWikipedia/flag_morocco.tga",
  }
  Nations[#Nations+1] = {
    value = "most_serene_republic_of_venice",
    text = "Most Serene Republic Of Venice",
    flag = "EveryFlagOnWikipedia/flag_most_serene_republic_of_venice.tga",
  }
  Nations[#Nations+1] = {
    value = "mozambique",
    text = "Mozambique",
    flag = "EveryFlagOnWikipedia/flag_mozambique.tga",
  }
  Nations[#Nations+1] = {
    value = "murrawarri_republic",
    text = "Murrawarri Republic",
    flag = "EveryFlagOnWikipedia/flag_murrawarri_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "myanmar",
    text = "Myanmar",
    flag = "EveryFlagOnWikipedia/flag_myanmar.tga",
  }
  Nations[#Nations+1] = {
    value = "namibia",
    text = "Namibia",
    flag = "EveryFlagOnWikipedia/flag_namibia.tga",
  }
  Nations[#Nations+1] = {
    value = "natalia_republic",
    text = "Natalia Republic",
    flag = "EveryFlagOnWikipedia/flag_natalia_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "nauru",
    text = "Nauru",
    flag = "EveryFlagOnWikipedia/flag_nauru.tga",
  }
  Nations[#Nations+1] = {
    value = "navassa_island",
    text = "Navassa Island",
    flag = "EveryFlagOnWikipedia/flag_navassa_island.tga",
  }
  Nations[#Nations+1] = {
    value = "nejd",
    text = "Nejd",
    flag = "EveryFlagOnWikipedia/flag_nejd.tga",
  }
  Nations[#Nations+1] = {
    value = "nepal",
    text = "Nepal",
    flag = "EveryFlagOnWikipedia/flag_nepal.tga",
  }
  Nations[#Nations+1] = {
    value = "new_mon_state_party",
    text = "New Mon State Party",
    flag = "EveryFlagOnWikipedia/flag_new_mon_state_party.tga",
  }
  Nations[#Nations+1] = {
    value = "new_zealand",
    text = "New Zealand",
    flag = "EveryFlagOnWikipedia/flag_new_zealand.tga",
  }
  Nations[#Nations+1] = {
    value = "new_zealand_south_island",
    text = "New Zealand South Island",
    flag = "EveryFlagOnWikipedia/flag_new_zealand_south_island.tga",
  }
  Nations[#Nations+1] = {
    value = "nicaragua",
    text = "Nicaragua",
    flag = "EveryFlagOnWikipedia/flag_nicaragua.tga",
  }
  Nations[#Nations+1] = {
    value = "niger",
    text = "Niger",
    flag = "EveryFlagOnWikipedia/flag_niger.tga",
  }
  Nations[#Nations+1] = {
    value = "nigeria",
    text = "Nigeria",
    flag = "EveryFlagOnWikipedia/flag_nigeria.tga",
  }
  Nations[#Nations+1] = {
    value = "niue",
    text = "Niue",
    flag = "EveryFlagOnWikipedia/flag_niue.tga",
  }
  Nations[#Nations+1] = {
    value = "norfolk_island",
    text = "Norfolk Island",
    flag = "EveryFlagOnWikipedia/flag_norfolk_island.tga",
  }
  Nations[#Nations+1] = {
    value = "north_korea",
    text = "North Korea",
    flag = "EveryFlagOnWikipedia/flag_north_korea.tga",
  }
  Nations[#Nations+1] = {
    value = "norway",
    text = "Norway",
    flag = "EveryFlagOnWikipedia/flag_norway.tga",
  }
  Nations[#Nations+1] = {
    value = "occitania",
    text = "Occitania",
    flag = "EveryFlagOnWikipedia/flag_occitania.tga",
  }
  Nations[#Nations+1] = {
    value = "ogaden_national_liberation_front",
    text = "Ogaden National Liberation Front",
    flag = "EveryFlagOnWikipedia/flag_ogaden_national_liberation_front.tga",
  }
  Nations[#Nations+1] = {
    value = "oman",
    text = "Oman",
    flag = "EveryFlagOnWikipedia/flag_oman.tga",
  }
  Nations[#Nations+1] = {
    value = "ottoman_alternative",
    text = "Ottoman Alternative",
    flag = "EveryFlagOnWikipedia/flag_ottoman_alternative.tga",
  }
  Nations[#Nations+1] = {
    value = "padania",
    text = "Padania",
    flag = "EveryFlagOnWikipedia/flag_padania.tga",
  }
  Nations[#Nations+1] = {
    value = "pakistan",
    text = "Pakistan",
    flag = "EveryFlagOnWikipedia/flag_pakistan.tga",
  }
  Nations[#Nations+1] = {
    value = "palau",
    text = "Palau",
    flag = "EveryFlagOnWikipedia/flag_palau.tga",
  }
  Nations[#Nations+1] = {
    value = "palestine",
    text = "Palestine",
    flag = "EveryFlagOnWikipedia/flag_palestine.tga",
  }
  Nations[#Nations+1] = {
    value = "palmyra_atoll",
    text = "Palmyra Atoll",
    flag = "EveryFlagOnWikipedia/flag_palmyra_atoll.tga",
  }
  Nations[#Nations+1] = {
    value = "panama",
    text = "Panama",
    flag = "EveryFlagOnWikipedia/flag_panama.tga",
  }
  Nations[#Nations+1] = {
    value = "papua_new_guinea",
    text = "Papua New Guinea",
    flag = "EveryFlagOnWikipedia/flag_papua_new_guinea.tga",
  }
  Nations[#Nations+1] = {
    value = "paraguay",
    text = "Paraguay",
    flag = "EveryFlagOnWikipedia/flag_paraguay.tga",
  }
  Nations[#Nations+1] = {
    value = "pattani",
    text = "Pattani",
    flag = "EveryFlagOnWikipedia/flag_pattani.tga",
  }
  Nations[#Nations+1] = {
    value = "pernambucan_revolt",
    text = "Pernambucan Revolt",
    flag = "EveryFlagOnWikipedia/flag_pernambucan_revolt.tga",
  }
  Nations[#Nations+1] = {
    value = "peru",
    text = "Peru",
    flag = "EveryFlagOnWikipedia/flag_peru.tga",
  }
  Nations[#Nations+1] = {
    value = "piratini_republic",
    text = "Piratini Republic",
    flag = "EveryFlagOnWikipedia/flag_piratini_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "poland",
    text = "Poland",
    flag = "EveryFlagOnWikipedia/flag_poland.tga",
  }
  Nations[#Nations+1] = {
    value = "porto_claro",
    text = "Porto Claro",
    flag = "EveryFlagOnWikipedia/flag_porto_claro.tga",
  }
  Nations[#Nations+1] = {
    value = "portugal",
    text = "Portugal",
    flag = "EveryFlagOnWikipedia/flag_portugal.tga",
  }
  Nations[#Nations+1] = {
    value = "portugalicia",
    text = "Portugalicia",
    flag = "EveryFlagOnWikipedia/flag_portugalicia.tga",
  }
  Nations[#Nations+1] = {
    value = "puerto_rico",
    text = "Puerto Rico",
    flag = "EveryFlagOnWikipedia/flag_puerto_rico.tga",
  }
  Nations[#Nations+1] = {
    value = "qatar",
    text = "Qatar",
    flag = "EveryFlagOnWikipedia/flag_qatar.tga",
  }
  Nations[#Nations+1] = {
    value = "quebec",
    text = "Quebec",
    flag = "EveryFlagOnWikipedia/flag_quebec.tga",
  }
  Nations[#Nations+1] = {
    value = "raiatea",
    text = "Raiatea",
    flag = "EveryFlagOnWikipedia/flag_raiatea.tga",
  }
  Nations[#Nations+1] = {
    value = "rainbowcreek",
    text = "Rainbowcreek",
    flag = "EveryFlagOnWikipedia/flag_rainbowcreek.tga",
  }
  Nations[#Nations+1] = {
    value = "rapa_nui,_chile",
    text = "Rapa Nui, Chile",
    flag = "EveryFlagOnWikipedia/flag_rapa_nui,_chile.tga",
  }
  Nations[#Nations+1] = {
    value = "republica_juliana",
    text = "Republica Juliana",
    flag = "EveryFlagOnWikipedia/flag_republica_juliana.tga",
  }
  Nations[#Nations+1] = {
    value = "republic_of_dubrovnik",
    text = "Republic Of Dubrovnik",
    flag = "EveryFlagOnWikipedia/flag_republic_of_dubrovnik.tga",
  }
  Nations[#Nations+1] = {
    value = "Republic_of_New_Afrika",
    text = "Republic Of New Afrika",
    flag = "EveryFlagOnWikipedia/flag_Republic_of_New_Afrika.tga",
  }
  Nations[#Nations+1] = {
    value = "republic_ryukyu_independists",
    text = "Republic Ryukyu Independists",
    flag = "EveryFlagOnWikipedia/flag_republic_ryukyu_independists.tga",
  }
  Nations[#Nations+1] = {
    value = "rhodesia",
    text = "Rhodesia",
    flag = "EveryFlagOnWikipedia/flag_rhodesia.tga",
  }
  Nations[#Nations+1] = {
    value = "riau_independists",
    text = "Riau Independists",
    flag = "EveryFlagOnWikipedia/flag_riau_independists.tga",
  }
  Nations[#Nations+1] = {
    value = "romania",
    text = "Romania",
    flag = "EveryFlagOnWikipedia/flag_romania.tga",
  }
  Nations[#Nations+1] = {
    value = "rose_island",
    text = "Rose Island",
    flag = "EveryFlagOnWikipedia/flag_rose_island.tga",
  }
  Nations[#Nations+1] = {
    value = "rotuma",
    text = "Rotuma",
    flag = "EveryFlagOnWikipedia/flag_rotuma.tga",
  }
  Nations[#Nations+1] = {
    value = "rurutu",
    text = "Rurutu",
    flag = "EveryFlagOnWikipedia/flag_rurutu.tga",
  }
  Nations[#Nations+1] = {
    value = "russia",
    text = "Russia",
    flag = "EveryFlagOnWikipedia/flag_russia.tga",
  }
  Nations[#Nations+1] = {
    value = "rwanda",
    text = "Rwanda",
    flag = "EveryFlagOnWikipedia/flag_rwanda.tga",
  }
  Nations[#Nations+1] = {
    value = "ryukyu",
    text = "Ryukyu",
    flag = "EveryFlagOnWikipedia/flag_ryukyu.tga",
  }
  Nations[#Nations+1] = {
    value = "saba",
    text = "Saba",
    flag = "EveryFlagOnWikipedia/flag_saba.tga",
  }
  Nations[#Nations+1] = {
    value = "saint-pierre_and_miquelon",
    text = "Saint-pierre And Miquelon",
    flag = "EveryFlagOnWikipedia/flag_saint-pierre_and_miquelon.tga",
  }
  Nations[#Nations+1] = {
    value = "saint_barthelemy",
    text = "Saint Barthelemy",
    flag = "EveryFlagOnWikipedia/flag_saint_barthelemy.tga",
  }
  Nations[#Nations+1] = {
    value = "saint_helena",
    text = "Saint Helena",
    flag = "EveryFlagOnWikipedia/flag_saint_helena.tga",
  }
  Nations[#Nations+1] = {
    value = "saint_kitts_and_nevis",
    text = "Saint Kitts And Nevis",
    flag = "EveryFlagOnWikipedia/flag_saint_kitts_and_nevis.tga",
  }
  Nations[#Nations+1] = {
    value = "saint_lucia",
    text = "Saint Lucia",
    flag = "EveryFlagOnWikipedia/flag_saint_lucia.tga",
  }
  Nations[#Nations+1] = {
    value = "saint_vincent_and_the_grenadines",
    text = "Saint Vincent And The Grenadines",
    flag = "EveryFlagOnWikipedia/flag_saint_vincent_and_the_grenadines.tga",
  }
  Nations[#Nations+1] = {
    value = "sami",
    text = "Sami",
    flag = "EveryFlagOnWikipedia/flag_sami.tga",
  }
  Nations[#Nations+1] = {
    value = "samoa",
    text = "Samoa",
    flag = "EveryFlagOnWikipedia/flag_samoa.tga",
  }
  Nations[#Nations+1] = {
    value = "san_marino",
    text = "San Marino",
    flag = "EveryFlagOnWikipedia/flag_san_marino.tga",
  }
  Nations[#Nations+1] = {
    value = "sao_tome_and_principe",
    text = "Sao Tome And Principe",
    flag = "EveryFlagOnWikipedia/flag_sao_tome_and_principe.tga",
  }
  Nations[#Nations+1] = {
    value = "sark",
    text = "Sark",
    flag = "EveryFlagOnWikipedia/flag_sark.tga",
  }
  Nations[#Nations+1] = {
    value = "saudi_arabia",
    text = "Saudi Arabia",
    flag = "EveryFlagOnWikipedia/flag_saudi_arabia.tga",
  }
  Nations[#Nations+1] = {
    value = "saxony",
    text = "Saxony",
    flag = "EveryFlagOnWikipedia/flag_saxony.tga",
  }
  Nations[#Nations+1] = {
    value = "scotland",
    text = "Scotland",
    flag = "EveryFlagOnWikipedia/flag_scotland.tga",
  }
  Nations[#Nations+1] = {
    value = "sealand",
    text = "Sealand",
    flag = "EveryFlagOnWikipedia/flag_sealand.tga",
  }
  Nations[#Nations+1] = {
    value = "sedang",
    text = "Sedang",
    flag = "EveryFlagOnWikipedia/flag_sedang.tga",
  }
  Nations[#Nations+1] = {
    value = "senegal",
    text = "Senegal",
    flag = "EveryFlagOnWikipedia/flag_senegal.tga",
  }
  Nations[#Nations+1] = {
    value = "serbia",
    text = "Serbia",
    flag = "EveryFlagOnWikipedia/flag_serbia.tga",
  }
  Nations[#Nations+1] = {
    value = "serbian_krajina",
    text = "Serbian Krajina",
    flag = "EveryFlagOnWikipedia/flag_serbian_krajina.tga",
  }
  Nations[#Nations+1] = {
    value = "seychelles",
    text = "Seychelles",
    flag = "EveryFlagOnWikipedia/flag_seychelles.tga",
  }
  Nations[#Nations+1] = {
    value = "sfr_yugoslavia",
    text = "Sfr Yugoslavia",
    flag = "EveryFlagOnWikipedia/flag_sfr_yugoslavia.tga",
  }
  Nations[#Nations+1] = {
    value = "sierra_leone",
    text = "Sierra Leone",
    flag = "EveryFlagOnWikipedia/flag_sierra_leone.tga",
  }
  Nations[#Nations+1] = {
    value = "sikkim",
    text = "Sikkim",
    flag = "EveryFlagOnWikipedia/flag_sikkim.tga",
  }
  Nations[#Nations+1] = {
    value = "simple_of_the_grand_duchy_of_tuscany",
    text = "Simple Of The Grand Duchy Of Tuscany",
    flag = "EveryFlagOnWikipedia/flag_simple_of_the_grand_duchy_of_tuscany.tga",
  }
  Nations[#Nations+1] = {
    value = "singapore",
    text = "Singapore",
    flag = "EveryFlagOnWikipedia/flag_singapore.tga",
  }
  Nations[#Nations+1] = {
    value = "sint_eustatius",
    text = "Sint Eustatius",
    flag = "EveryFlagOnWikipedia/flag_sint_eustatius.tga",
  }
  Nations[#Nations+1] = {
    value = "sint_maarten",
    text = "Sint Maarten",
    flag = "EveryFlagOnWikipedia/flag_sint_maarten.tga",
  }
  Nations[#Nations+1] = {
    value = "slovakia",
    text = "Slovakia",
    flag = "EveryFlagOnWikipedia/flag_slovakia.tga",
  }
  Nations[#Nations+1] = {
    value = "slovenia",
    text = "Slovenia",
    flag = "EveryFlagOnWikipedia/flag_slovenia.tga",
  }
  Nations[#Nations+1] = {
    value = "snake_of_martinique",
    text = "Snake Of Martinique",
    flag = "EveryFlagOnWikipedia/flag_snake_of_martinique.tga",
  }
  Nations[#Nations+1] = {
    value = "somalia",
    text = "Somalia",
    flag = "EveryFlagOnWikipedia/flag_somalia.tga",
  }
  Nations[#Nations+1] = {
    value = "somaliland",
    text = "Somaliland",
    flag = "EveryFlagOnWikipedia/flag_somaliland.tga",
  }
  Nations[#Nations+1] = {
    value = "south_africa",
    text = "South Africa",
    flag = "EveryFlagOnWikipedia/flag_south_africa.tga",
  }
  Nations[#Nations+1] = {
    value = "south_georgia_and_the_south_sandwich_islands",
    text = "South Georgia And The South Sandwich Islands",
    flag = "EveryFlagOnWikipedia/flag_south_georgia_and_the_south_sandwich_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "south_kasai",
    text = "South Kasai",
    flag = "EveryFlagOnWikipedia/flag_south_kasai.tga",
  }
  Nations[#Nations+1] = {
    value = "south_korea",
    text = "South Korea",
    flag = "EveryFlagOnWikipedia/flag_south_korea.tga",
  }
  Nations[#Nations+1] = {
    value = "south_moluccas",
    text = "South Moluccas",
    flag = "EveryFlagOnWikipedia/flag_south_moluccas.tga",
  }
  Nations[#Nations+1] = {
    value = "south_ossetia",
    text = "South Ossetia",
    flag = "EveryFlagOnWikipedia/flag_south_ossetia.tga",
  }
  Nations[#Nations+1] = {
    value = "south_sudan",
    text = "South Sudan",
    flag = "EveryFlagOnWikipedia/flag_south_sudan.tga",
  }
  Nations[#Nations+1] = {
    value = "south_vietnam",
    text = "South Vietnam",
    flag = "EveryFlagOnWikipedia/flag_south_vietnam.tga",
  }
  Nations[#Nations+1] = {
    value = "south_yemen",
    text = "South Yemen",
    flag = "EveryFlagOnWikipedia/flag_south_yemen.tga",
  }
  Nations[#Nations+1] = {
    value = "spain",
    text = "Spain",
    flag = "EveryFlagOnWikipedia/flag_spain.tga",
  }
  Nations[#Nations+1] = {
    value = "sri_lanka",
    text = "Sri Lanka",
    flag = "EveryFlagOnWikipedia/flag_sri_lanka.tga",
  }
  Nations[#Nations+1] = {
    value = "sudan",
    text = "Sudan",
    flag = "EveryFlagOnWikipedia/flag_sudan.tga",
  }
  Nations[#Nations+1] = {
    value = "sulawesi",
    text = "Sulawesi",
    flag = "EveryFlagOnWikipedia/flag_sulawesi.tga",
  }
  Nations[#Nations+1] = {
    value = "sulu",
    text = "Sulu",
    flag = "EveryFlagOnWikipedia/flag_sulu.tga",
  }
  Nations[#Nations+1] = {
    value = "suriname",
    text = "Suriname",
    flag = "EveryFlagOnWikipedia/flag_suriname.tga",
  }
  Nations[#Nations+1] = {
    value = "swaziland",
    text = "Swaziland",
    flag = "EveryFlagOnWikipedia/flag_swaziland.tga",
  }
  Nations[#Nations+1] = {
    value = "sweden",
    text = "Sweden",
    flag = "EveryFlagOnWikipedia/flag_sweden.tga",
  }
  Nations[#Nations+1] = {
    value = "switzerland",
    text = "Switzerland",
    flag = "EveryFlagOnWikipedia/flag_switzerland.tga",
  }
  Nations[#Nations+1] = {
    value = "syria",
    text = "Syria",
    flag = "EveryFlagOnWikipedia/flag_syria.tga",
  }
  Nations[#Nations+1] = {
    value = "syrian_kurdistan",
    text = "Syrian Kurdistan",
    flag = "EveryFlagOnWikipedia/flag_syrian_kurdistan.tga",
  }
  Nations[#Nations+1] = {
    value = "szekely_land",
    text = "Szekely Land",
    flag = "EveryFlagOnWikipedia/flag_szekely_land.tga",
  }
  Nations[#Nations+1] = {
    value = "taiwan_proposed_1996",
    text = "Taiwan Proposed 1996",
    flag = "EveryFlagOnWikipedia/flag_taiwan_proposed_1996.tga",
  }
  Nations[#Nations+1] = {
    value = "tajikistan",
    text = "Tajikistan",
    flag = "EveryFlagOnWikipedia/flag_tajikistan.tga",
  }
  Nations[#Nations+1] = {
    value = "tanganyika",
    text = "Tanganyika",
    flag = "EveryFlagOnWikipedia/flag_tanganyika.tga",
  }
  Nations[#Nations+1] = {
    value = "tanzania",
    text = "Tanzania",
    flag = "EveryFlagOnWikipedia/flag_tanzania.tga",
  }
  Nations[#Nations+1] = {
    value = "tavolara",
    text = "Tavolara",
    flag = "EveryFlagOnWikipedia/flag_tavolara.tga",
  }
  Nations[#Nations+1] = {
    value = "texas",
    text = "Texas",
    flag = "EveryFlagOnWikipedia/flag_texas.tga",
  }
  Nations[#Nations+1] = {
    value = "thailand",
    text = "Thailand",
    flag = "EveryFlagOnWikipedia/flag_thailand.tga",
  }
  Nations[#Nations+1] = {
    value = "the_aceh_sultanate",
    text = "The Aceh Sultanate",
    flag = "EveryFlagOnWikipedia/flag_the_aceh_sultanate.tga",
  }
  Nations[#Nations+1] = {
    value = "the_american_indian_movement",
    text = "The American Indian Movement",
    flag = "EveryFlagOnWikipedia/flag_the_american_indian_movement.tga",
  }
  Nations[#Nations+1] = {
    value = "the_bahamas",
    text = "The Bahamas",
    flag = "EveryFlagOnWikipedia/flag_the_bahamas.tga",
  }
  Nations[#Nations+1] = {
    value = "the_barisan_revolusi_nasional",
    text = "The Barisan Revolusi Nasional",
    flag = "EveryFlagOnWikipedia/flag_the_barisan_revolusi_nasional.tga",
  }
  Nations[#Nations+1] = {
    value = "the_basque_country",
    text = "The Basque Country",
    flag = "EveryFlagOnWikipedia/flag_the_basque_country.tga",
  }
  Nations[#Nations+1] = {
    value = "the_bodo_liberation_tigers_force",
    text = "The Bodo Liberation Tigers Force",
    flag = "EveryFlagOnWikipedia/flag_the_bodo_liberation_tigers_force.tga",
  }
  Nations[#Nations+1] = {
    value = "the_british_antarctic_territory",
    text = "The British Antarctic Territory",
    flag = "EveryFlagOnWikipedia/flag_the_british_antarctic_territory.tga",
  }
  Nations[#Nations+1] = {
    value = "the_british_indian_ocean_territory",
    text = "The British Indian Ocean Territory",
    flag = "EveryFlagOnWikipedia/flag_the_british_indian_ocean_territory.tga",
  }
  Nations[#Nations+1] = {
    value = "the_british_virgin_islands",
    text = "The British Virgin Islands",
    flag = "EveryFlagOnWikipedia/flag_the_british_virgin_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_cayman_islands",
    text = "The Cayman Islands",
    flag = "EveryFlagOnWikipedia/flag_the_cayman_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_central_african_republic",
    text = "The Central African Republic",
    flag = "EveryFlagOnWikipedia/flag_the_central_african_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "the_cocos_keeling_islands",
    text = "The Cocos Keeling Islands",
    flag = "EveryFlagOnWikipedia/flag_the_cocos_keeling_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_collectivity_of_saint_martin",
    text = "The Collectivity Of Saint Martin",
    flag = "EveryFlagOnWikipedia/flag_the_collectivity_of_saint_martin.tga",
  }
  Nations[#Nations+1] = {
    value = "the_comoros",
    text = "The Comoros",
    flag = "EveryFlagOnWikipedia/flag_the_comoros.tga",
  }
  Nations[#Nations+1] = {
    value = "the_confederate_states_of_america",
    text = "The Confederate States Of America",
    flag = "EveryFlagOnWikipedia/flag_the_confederate_states_of_america.tga",
  }
  Nations[#Nations+1] = {
    value = "the_cook_islands",
    text = "The Cook Islands",
    flag = "EveryFlagOnWikipedia/flag_the_cook_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_creek_nation",
    text = "The Creek Nation",
    flag = "EveryFlagOnWikipedia/flag_the_creek_nation.tga",
  }
  Nations[#Nations+1] = {
    value = "the_croatian_republic_of_herzeg-bosnia",
    text = "The Croatian Republic Of Herzeg-bosnia",
    flag = "EveryFlagOnWikipedia/flag_the_croatian_republic_of_herzeg-bosnia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_czech_republic",
    text = "The Czech Republic",
    flag = "EveryFlagOnWikipedia/flag_the_czech_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "the_democratic_republic_of_the_congo",
    text = "The Democratic Republic Of The Congo",
    flag = "EveryFlagOnWikipedia/flag_the_democratic_republic_of_the_congo.tga",
  }
  Nations[#Nations+1] = {
    value = "the_district_of_columbia",
    text = "The District Of Columbia",
    flag = "EveryFlagOnWikipedia/flag_the_district_of_columbia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_dominican_republic",
    text = "The Dominican Republic",
    flag = "EveryFlagOnWikipedia/flag_the_dominican_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "the_falkland_islands",
    text = "The Falkland Islands",
    flag = "EveryFlagOnWikipedia/flag_the_falkland_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_faroe_islands",
    text = "The Faroe Islands",
    flag = "EveryFlagOnWikipedia/flag_the_faroe_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_federal_republic_of_central_america",
    text = "The Federal Republic Of Central America",
    flag = "EveryFlagOnWikipedia/flag_the_federal_republic_of_central_america.tga",
  }
  Nations[#Nations+1] = {
    value = "the_federal_republic_of_southern_cameroons",
    text = "The Federal Republic Of Southern Cameroons",
    flag = "EveryFlagOnWikipedia/flag_the_federal_republic_of_southern_cameroons.tga",
  }
  Nations[#Nations+1] = {
    value = "the_federated_states_of_micronesia",
    text = "The Federated States Of Micronesia",
    flag = "EveryFlagOnWikipedia/flag_the_federated_states_of_micronesia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_federation_of_rhodesia_and_nyasaland",
    text = "The Federation Of Rhodesia And Nyasaland",
    flag = "EveryFlagOnWikipedia/flag_the_federation_of_rhodesia_and_nyasaland.tga",
  }
  Nations[#Nations+1] = {
    value = "the_free_state_of_fiume",
    text = "The Free State Of Fiume",
    flag = "EveryFlagOnWikipedia/flag_the_free_state_of_fiume.tga",
  }
  Nations[#Nations+1] = {
    value = "the_french_southern_and_antarctic_lands",
    text = "The French Southern And Antarctic Lands",
    flag = "EveryFlagOnWikipedia/flag_the_french_southern_and_antarctic_lands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_gagauz_people",
    text = "The Gagauz People",
    flag = "EveryFlagOnWikipedia/flag_the_gagauz_people.tga",
  }
  Nations[#Nations+1] = {
    value = "the_galician_ssr",
    text = "The Galician SSR",
    flag = "EveryFlagOnWikipedia/flag_the_galician_ssr.tga",
  }
  Nations[#Nations+1] = {
    value = "the_gambia",
    text = "The Gambia",
    flag = "EveryFlagOnWikipedia/flag_the_gambia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_hawar_islands",
    text = "The Hawar Islands",
    flag = "EveryFlagOnWikipedia/flag_the_hawar_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_inner_mongolian_people's_party",
    text = "The Inner Mongolian People's Party",
    flag = "EveryFlagOnWikipedia/flag_the_inner_mongolian_people's_party.tga",
  }
  Nations[#Nations+1] = {
    value = "the_islands_of_refreshment",
    text = "The Islands Of Refreshment",
    flag = "EveryFlagOnWikipedia/flag_the_islands_of_refreshment.tga",
  }
  Nations[#Nations+1] = {
    value = "the_isle_of_man",
    text = "The Isle Of Man",
    flag = "EveryFlagOnWikipedia/flag_the_isle_of_man.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_araucania_and_patagonia",
    text = "The Kingdom Of Araucania And Patagonia",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_araucania_and_patagonia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_lau",
    text = "The Kingdom Of Lau",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_lau.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_mangareva",
    text = "The Kingdom Of Mangareva",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_mangareva.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_redonda",
    text = "The Kingdom Of Redonda",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_redonda.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_rimatara",
    text = "The Kingdom Of Rimatara",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_rimatara.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_tahiti",
    text = "The Kingdom Of Tahiti",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_tahiti.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_talossa",
    text = "The Kingdom Of Talossa",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_talossa.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_the_two_sicilies",
    text = "The Kingdom Of The Two Sicilies",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_the_two_sicilies.tga",
  }
  Nations[#Nations+1] = {
    value = "the_kingdom_of_yugoslavia",
    text = "The Kingdom Of Yugoslavia",
    flag = "EveryFlagOnWikipedia/flag_the_kingdom_of_yugoslavia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_mapuches",
    text = "The Mapuches",
    flag = "EveryFlagOnWikipedia/flag_the_mapuches.tga",
  }
  Nations[#Nations+1] = {
    value = "the_maratha_empire",
    text = "The Maratha Empire",
    flag = "EveryFlagOnWikipedia/flag_the_maratha_empire.tga",
  }
  Nations[#Nations+1] = {
    value = "the_marshall_islands",
    text = "The Marshall Islands",
    flag = "EveryFlagOnWikipedia/flag_the_marshall_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_mengjiang",
    text = "The Mengjiang",
    flag = "EveryFlagOnWikipedia/flag_the_mengjiang.tga",
  }
  Nations[#Nations+1] = {
    value = "the_midway_islands",
    text = "The Midway Islands",
    flag = "EveryFlagOnWikipedia/flag_the_midway_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_moro_islamic_liberation_front",
    text = "The Moro Islamic Liberation Front",
    flag = "EveryFlagOnWikipedia/flag_the_moro_islamic_liberation_front.tga",
  }
  Nations[#Nations+1] = {
    value = "the_mughal_empire",
    text = "The Mughal Empire",
    flag = "EveryFlagOnWikipedia/flag_the_mughal_empire.tga",
  }
  Nations[#Nations+1] = {
    value = "the_National_Front_for_the_Liberation_of_Southern_Vietnam",
    text = "The National Front For The Liberation Of Southern Vietnam",
    flag = "EveryFlagOnWikipedia/flag_the_National_Front_for_the_Liberation_of_Southern_Vietnam.tga",
  }
  Nations[#Nations+1] = {
    value = "the_netherlands",
    text = "The Netherlands",
    flag = "EveryFlagOnWikipedia/flag_the_netherlands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_northern_mariana_islands",
    text = "The Northern Mariana Islands",
    flag = "EveryFlagOnWikipedia/flag_the_northern_mariana_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_orange_free_state",
    text = "The Orange Free State",
    flag = "EveryFlagOnWikipedia/flag_the_orange_free_state.tga",
  }
  Nations[#Nations+1] = {
    value = "the_oromo_liberation_front",
    text = "The Oromo Liberation Front",
    flag = "EveryFlagOnWikipedia/flag_the_oromo_liberation_front.tga",
  }
  Nations[#Nations+1] = {
    value = "the_pattani_united_liberation_organisation",
    text = "The Pattani United Liberation Organisation",
    flag = "EveryFlagOnWikipedia/flag_the_pattani_united_liberation_organisation.tga",
  }
  Nations[#Nations+1] = {
    value = "the_people's_republic_of_china",
    text = "The People's Republic Of China",
    flag = "EveryFlagOnWikipedia/flag_the_people's_republic_of_china.tga",
  }
  Nations[#Nations+1] = {
    value = "the_peru-bolivian_confederation",
    text = "The Peru-bolivian Confederation",
    flag = "EveryFlagOnWikipedia/flag_the_peru-bolivian_confederation.tga",
  }
  Nations[#Nations+1] = {
    value = "the_philippines",
    text = "The Philippines",
    flag = "EveryFlagOnWikipedia/flag_the_philippines.tga",
  }
  Nations[#Nations+1] = {
    value = "the_pitcairn_islands",
    text = "The Pitcairn Islands",
    flag = "EveryFlagOnWikipedia/flag_the_pitcairn_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_principality_of_trinidad",
    text = "The Principality Of Trinidad",
    flag = "EveryFlagOnWikipedia/flag_the_principality_of_trinidad.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_alsace-lorraine",
    text = "The Republic Of Alsace-lorraine",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_alsace-lorraine.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_benin",
    text = "The Republic Of Benin",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_benin.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_central_highlands_and_champa",
    text = "The Republic Of Central Highlands And Champa",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_central_highlands_and_champa.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_china",
    text = "The Republic Of China",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_china.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_lower_california",
    text = "The Republic Of Lower California",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_lower_california.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_molossia",
    text = "The Republic Of Molossia",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_molossia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_sonora",
    text = "The Republic Of Sonora",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_sonora.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_talossa",
    text = "The Republic Of Talossa",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_talossa.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_texas",
    text = "The Republic Of Texas",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_texas.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_the_congo",
    text = "The Republic Of The Congo",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_the_congo.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_the_rif",
    text = "The Republic Of The Rif",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_the_rif.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_the_rio_grande",
    text = "The Republic Of The Rio Grande",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_the_rio_grande.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_western_bosnia",
    text = "The Republic Of Western Bosnia",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_western_bosnia.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_yucatan",
    text = "The Republic Of Yucatan",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_yucatan.tga",
  }
  Nations[#Nations+1] = {
    value = "the_republic_of_zamboanga",
    text = "The Republic Of Zamboanga",
    flag = "EveryFlagOnWikipedia/flag_the_republic_of_zamboanga.tga",
  }
  Nations[#Nations+1] = {
    value = "the_ross_dependency",
    text = "The Ross Dependency",
    flag = "EveryFlagOnWikipedia/flag_the_ross_dependency.tga",
  }
  Nations[#Nations+1] = {
    value = "the_sahrawi_arab_democratic_republic",
    text = "The Sahrawi Arab Democratic Republic",
    flag = "EveryFlagOnWikipedia/flag_the_sahrawi_arab_democratic_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "the_solomon_islands",
    text = "The Solomon Islands",
    flag = "EveryFlagOnWikipedia/flag_the_solomon_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_soviet_union",
    text = "The Soviet Union",
    flag = "EveryFlagOnWikipedia/flag_the_soviet_union.tga",
  }
  Nations[#Nations+1] = {
    value = "the_sultanate_of_banten",
    text = "The Sultanate Of Banten",
    flag = "EveryFlagOnWikipedia/flag_the_sultanate_of_banten.tga",
  }
  Nations[#Nations+1] = {
    value = "the_sultanate_of_mataram",
    text = "The Sultanate Of Mataram",
    flag = "EveryFlagOnWikipedia/flag_the_sultanate_of_mataram.tga",
  }
  Nations[#Nations+1] = {
    value = "the_sultanate_of_zanzibar",
    text = "The Sultanate Of Zanzibar",
    flag = "EveryFlagOnWikipedia/flag_the_sultanate_of_zanzibar.tga",
  }
  Nations[#Nations+1] = {
    value = "the_tagalog_people",
    text = "The Tagalog People",
    flag = "EveryFlagOnWikipedia/flag_the_tagalog_people.tga",
  }
  Nations[#Nations+1] = {
    value = "the_transcaucasian_federation",
    text = "The Transcaucasian Federation",
    flag = "EveryFlagOnWikipedia/flag_the_transcaucasian_federation.tga",
  }
  Nations[#Nations+1] = {
    value = "the_tuamotu_kingdom",
    text = "The Tuamotu Kingdom",
    flag = "EveryFlagOnWikipedia/flag_the_tuamotu_kingdom.tga",
  }
  Nations[#Nations+1] = {
    value = "the_turkish_republic_of_northern_cyprus",
    text = "The Turkish Republic Of Northern Cyprus",
    flag = "EveryFlagOnWikipedia/flag_the_turkish_republic_of_northern_cyprus.tga",
  }
  Nations[#Nations+1] = {
    value = "the_turks_and_caicos_islands",
    text = "The Turks And Caicos Islands",
    flag = "EveryFlagOnWikipedia/flag_the_turks_and_caicos_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_tuvan_people's_republic",
    text = "The Tuvan People's Republic",
    flag = "EveryFlagOnWikipedia/flag_the_tuvan_people's_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "the_united_arab_emirates",
    text = "The United Arab Emirates",
    flag = "EveryFlagOnWikipedia/flag_the_united_arab_emirates.tga",
  }
  Nations[#Nations+1] = {
    value = "the_united_kingdom",
    text = "The United Kingdom",
    flag = "EveryFlagOnWikipedia/flag_the_united_kingdom.tga",
  }
  Nations[#Nations+1] = {
    value = "the_united_states",
    text = "The United States",
    flag = "EveryFlagOnWikipedia/flag_the_united_states.tga",
  }
  Nations[#Nations+1] = {
    value = "the_united_states_virgin_islands",
    text = "The United States Virgin Islands",
    flag = "EveryFlagOnWikipedia/flag_the_united_states_virgin_islands.tga",
  }
  Nations[#Nations+1] = {
    value = "the_united_tribes_of_fiji_1865-1867",
    text = "The United Tribes Of Fiji 1865-1867",
    flag = "EveryFlagOnWikipedia/flag_the_united_tribes_of_fiji_1865-1867.tga",
  }
  Nations[#Nations+1] = {
    value = "the_united_tribes_of_fiji_1867-1869",
    text = "The United Tribes Of Fiji 1867-1869",
    flag = "EveryFlagOnWikipedia/flag_the_united_tribes_of_fiji_1867-1869.tga",
  }
  Nations[#Nations+1] = {
    value = "the_vatican_city",
    text = "The Vatican City",
    flag = "EveryFlagOnWikipedia/flag_the_vatican_city.tga",
  }
  Nations[#Nations+1] = {
    value = "the_vermont_republic",
    text = "The Vermont Republic",
    flag = "EveryFlagOnWikipedia/flag_the_vermont_republic.tga",
  }
  Nations[#Nations+1] = {
    value = "the_west_indies_federation",
    text = "The West Indies Federation",
    flag = "EveryFlagOnWikipedia/flag_the_west_indies_federation.tga",
  }
  Nations[#Nations+1] = {
    value = "tibet",
    text = "Tibet",
    flag = "EveryFlagOnWikipedia/flag_tibet.tga",
  }
  Nations[#Nations+1] = {
    value = "tknara",
    text = "Tknara",
    flag = "EveryFlagOnWikipedia/flag_tknara.tga",
  }
  Nations[#Nations+1] = {
    value = "togo",
    text = "Togo",
    flag = "EveryFlagOnWikipedia/flag_togo.tga",
  }
  Nations[#Nations+1] = {
    value = "tokelau",
    text = "Tokelau",
    flag = "EveryFlagOnWikipedia/flag_tokelau.tga",
  }
  Nations[#Nations+1] = {
    value = "tonga",
    text = "Tonga",
    flag = "EveryFlagOnWikipedia/flag_tonga.tga",
  }
  Nations[#Nations+1] = {
    value = "transkei",
    text = "Transkei",
    flag = "EveryFlagOnWikipedia/flag_transkei.tga",
  }
  Nations[#Nations+1] = {
    value = "transnistria",
    text = "Transnistria",
    flag = "EveryFlagOnWikipedia/flag_transnistria.tga",
  }
  Nations[#Nations+1] = {
    value = "transvaal",
    text = "Transvaal",
    flag = "EveryFlagOnWikipedia/flag_transvaal.tga",
  }
  Nations[#Nations+1] = {
    value = "trinidad_and_tobago",
    text = "Trinidad And Tobago",
    flag = "EveryFlagOnWikipedia/flag_trinidad_and_tobago.tga",
  }
  Nations[#Nations+1] = {
    value = "tristan_da_cunha",
    text = "Tristan Da Cunha",
    flag = "EveryFlagOnWikipedia/flag_tristan_da_cunha.tga",
  }
  Nations[#Nations+1] = {
    value = "tunisia",
    text = "Tunisia",
    flag = "EveryFlagOnWikipedia/flag_tunisia.tga",
  }
  Nations[#Nations+1] = {
    value = "turkey",
    text = "Turkey",
    flag = "EveryFlagOnWikipedia/flag_turkey.tga",
  }
  Nations[#Nations+1] = {
    value = "turkmenistan",
    text = "Turkmenistan",
    flag = "EveryFlagOnWikipedia/flag_turkmenistan.tga",
  }
  Nations[#Nations+1] = {
    value = "tuvalu",
    text = "Tuvalu",
    flag = "EveryFlagOnWikipedia/flag_tuvalu.tga",
  }
  Nations[#Nations+1] = {
    value = "uganda",
    text = "Uganda",
    flag = "EveryFlagOnWikipedia/flag_uganda.tga",
  }
  Nations[#Nations+1] = {
    value = "ukraine",
    text = "Ukraine",
    flag = "EveryFlagOnWikipedia/flag_ukraine.tga",
  }
  Nations[#Nations+1] = {
    value = "ukrainian_ssr",
    text = "Ukrainian SSR",
    flag = "EveryFlagOnWikipedia/flag_ukrainian_ssr.tga",
  }
  Nations[#Nations+1] = {
    value = "uruguay",
    text = "Uruguay",
    flag = "EveryFlagOnWikipedia/flag_uruguay.tga",
  }
  Nations[#Nations+1] = {
    value = "uzbekistan",
    text = "Uzbekistan",
    flag = "EveryFlagOnWikipedia/flag_uzbekistan.tga",
  }
  Nations[#Nations+1] = {
    value = "vanuatu",
    text = "Vanuatu",
    flag = "EveryFlagOnWikipedia/flag_vanuatu.tga",
  }
  Nations[#Nations+1] = {
    value = "venda",
    text = "Venda",
    flag = "EveryFlagOnWikipedia/flag_venda.tga",
  }
  Nations[#Nations+1] = {
    value = "venezuela",
    text = "Venezuela",
    flag = "EveryFlagOnWikipedia/flag_venezuela.tga",
  }
  Nations[#Nations+1] = {
    value = "vietnam",
    text = "Vietnam",
    flag = "EveryFlagOnWikipedia/flag_vietnam.tga",
  }
  Nations[#Nations+1] = {
    value = "vojvodina",
    text = "Vojvodina",
    flag = "EveryFlagOnWikipedia/flag_vojvodina.tga",
  }
  Nations[#Nations+1] = {
    value = "wake_island",
    text = "Wake Island",
    flag = "EveryFlagOnWikipedia/flag_wake_island.tga",
  }
  Nations[#Nations+1] = {
    value = "wales",
    text = "Wales",
    flag = "EveryFlagOnWikipedia/flag_wales.tga",
  }
  Nations[#Nations+1] = {
    value = "wallis_and_futuna",
    text = "Wallis And Futuna",
    flag = "EveryFlagOnWikipedia/flag_wallis_and_futuna.tga",
  }
  Nations[#Nations+1] = {
    value = "yemen",
    text = "Yemen",
    flag = "EveryFlagOnWikipedia/flag_yemen.tga",
  }
  Nations[#Nations+1] = {
    value = "zambia",
    text = "Zambia",
    flag = "EveryFlagOnWikipedia/flag_zambia.tga",
  }
  Nations[#Nations+1] = {
    value = "zanzibar",
    text = "Zanzibar",
    flag = "EveryFlagOnWikipedia/flag_zanzibar.tga",
  }
  Nations[#Nations+1] = {
    value = "zimbabwe",
    text = "Zimbabwe",
    flag = "EveryFlagOnWikipedia/flag_zimbabwe.tga",
  }
  Nations[#Nations+1] = {
    value = "zomi_re-unification_organisation",
    text = "Zomi Re-unification Organisation",
    flag = "EveryFlagOnWikipedia/flag_zomi_re-unification_organisation.tga",
  }

  const.FullTransitionToMarsNames = 9999

  -- add list of names from earlier for each nation
  for i = 1, #Nations do
    -- skip the ones added by the game (unless it's Mars)
    if Nations[i].value == "Mars" or type(Nations[i].text) == "string" then
      HumanNames[Nations[i].value] = name_table
    else
      if HumanNames[Nations[i].value] then
        HumanNames[Nations[i].value].Unique = name_table.Unique
      end
    end
  end

  -- replace the func that gets a nation (it gets a weighted nation depending on your sponsors instead of all of them)
  function GetWeightedRandNation()
    return Nations[Random(1,#Nations)].value
  end

end
