-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions()
	if CurrentModOptions:GetProperty("DisableMartianNames") then
		-- I doubt any game will last 99999 sols
		const.FullTransitionToMarsNames = 99999
	else
		-- default
		const.FullTransitionToMarsNames = 20
	end
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local name_table_Unique = {
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

	-- ModsReloaded can fire multiple times
	if table.find(HumanNames.American.Unique.Male, "Adolf Thiel") then
		return
	end

	-- loop through all the nation names and add new names
	for id, name_table in pairs(HumanNames) do
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
end
