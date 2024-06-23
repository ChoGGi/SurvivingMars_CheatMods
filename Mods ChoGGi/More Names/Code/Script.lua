-- See LICENSE for terms

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	if CurrentModOptions:GetProperty("DisableMartianNames") then
		-- I doubt any game will last 99999 sols
		const.FullTransitionToMarsNames = 99999
	else
		-- default
		const.FullTransitionToMarsNames = 20
	end
end
-- called below instead
--~ -- Load default/saved settings
--~ OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local name_table_Unique = {
	Female = {
		"Anna Fisher",
		"Christa McAuliffe",
		"Judith Resnik",
		"Kalpana Chawla",
		"Kathryn Dwyer Sullivan",
		"Laurel Blair Clark",
		"Lisa Marie Nowak",
		"Sally Ride",
		"Svetlana Savitskaya",
		"Susan Kilrain",
		"Valentina Tereshkova",
		"Wendy Barrien Lawrence",
	},
	Male = {
		"Beef Testosterone",

		"Adolf Thiel",
		"Alan Tower Waterman",
		"Albert Zeiler",
		"Albin Wittmann",
		"Aleksandr Lyapunov",
		"Alexander Bolonkin",
		"Alexander Kemurdzhian",
		"Alexander Martin Lippisch",
		"Andreas Alexandrakis",
		"Apollo Milton Olin Smith",
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
		"Edward Seymour Forman",
		"Erich Walter Neubert",
		"Ernst Geissler",
		"Ernst Rudolph Georg Eckert",
		"Ernst Stuhlinger",
		"Eugene Saenger",
		"Frank Malina",
		"Fridtjof Speer",
		"Friedrich von Saurma",
		"Friedrich Zander",
		"Fritz Mueller",
		"Georg Emil Knausenberger",
		"Georg Rickhey",
		"Georg von Tiesenhausen",
		"George Edward Pendray",
		"George H. Ludwig",
		"Georgy Babakin",
		"Gerhard Herbert Richard Reisig",
		"Glenn Luther Martin",
		"Guenter Wendt",
		"György Marx",
		"Hans Joachim Oskar Fichtner",
		"Hans Hosenthien",
		"Hans Hueter",
		"Hans Maus",
		"Hans Rudolf Palaoro",
		"Harry Ruppe",
		"Harry W. Bull",
		"Heinz-Hermann Koelle",
		"Helmut Gröttrup",
		"Helmut Hölzer",
		"Helmut Zoike",
		"Herman Potocnik",
		"Hermann Herbert Kurzweg",
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
		"Johannes Winkler",
		"John Bruce Medaris",
		"Joseph-Louis Lagrange",
		"Karl Heimburg",
		"Karl-Heinz Bringer",
		"Klaus Riedel",
		"Konrad Dannenberg",
		"Konstantin Tsiolkovsky",
		"Krafft Arnold Ehricke",
		"Kurt Heinrich Debus",
		"Leonhard Euler",
		"Leonid Alexandrovich Voskresenskiy",
		"Lovell Lawrence Jr.",
		"Ludwig Prandtl",
		"Ludwig Roth",
		"Magnus von Braun",
		"Martin Summerfield",
		"Mikhail Borisovich Dobriyan",
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
		"Robert Hutchings Goddard",
		"Rudi Beichel",
		"Rudolf Nebel",
		"Sergei Korolev",
		"Theodor Anton Poppel",
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
		"William August Schulze",
		"William Mrazek",
		"William Pickering",
		"Willy Ley",
		"Willy Mrazek",
		"Yevgeny Ostashev",
		"Yuri Gagarin",
		"Yuri Shargin",
	},
}
-- no sense in counting over n over
local c_male = #name_table_Unique.Male
local c_female = #name_table_Unique.Female

-- append new names to existing list
local function AddNames(list, names, c_names)
	local c_list = #list
	for i = 1, c_names do
		c_list = c_list + 1
		list[c_list] = names[i]
	end
end

-- just in case anyone adds some custom HumanNames
function OnMsg.ModsReloaded()
	-- load default/saved settings
	ModOptions()

	local HumanNames = HumanNames

	-- ModsReloaded can fire multiple times, and I don't want a bunch of dupe names
--~ 	if table.find(HumanNames.American.Unique.Male, "Adolf Thiel") then
	if HumanNames.ChoGGi_AddedNames then
		return
	end

	-- loop through all the nation names and add new names
	for _, name_table in pairs(HumanNames) do
		-- some don't have it
		if not name_table.Unique then
			name_table.Unique = {
				Male = {},
				Female = {},
			}
		end
		AddNames(name_table.Unique.Male, name_table_Unique.Male, c_male)
		AddNames(name_table.Unique.Female, name_table_Unique.Female, c_female)
	end

	HumanNames.ChoGGi_AddedNames = {_faketable_ignore = true}
	--
end

-- Okay I guess FullTransitionToMarsNames is kinda useless for births...

local ChoOrig_NameUnit = NameUnit
function NameUnit(unit, ...)
	if unit.birthplace and unit.birthplace ~= "Mars" then
		return ChoOrig_NameUnit(unit, ...)
	end
	-- Get sponsor nations and pick random one
	-- copy pasta from GenerateColonistData()
	local sponsor_id = g_CurrentMissionParams.idMissionSponsor or "IMM"
	local sponsor_nations = GetSponsorNations(sponsor_id)
	if #(sponsor_nations or "") <= 0 then
		sponsor_nations = GetSponsorNations("IMM")
	end
	unit.birthplace = GetWeightedRandNation(sponsor_nations) or "IMM"

	return ChoOrig_NameUnit(unit, ...)
end
