--[[
	g_CurrentCCS = ColonyColorSchemes.ChoGGi_Classic_Colour_Scheme
	ReapplyPalettes()

GetRGBA(argb)
RGBA(r, g, b, a)


RGBA(GetRGBA(2199664752))

ColonyColorSchemes.ChoGGi_Classic_Colour_Scheme.cables_base = ColorizationMaterialEncode(RGB(22, 36, 50), -128, 128)

	ColonyColorSchemes.ChoGGi_Classic_Colour_Scheme.inside_accent_2 = ColorizationMaterialEncode(2367520, 64, -32)

-- water rec spire
-5592406
'palette_color1', "inside_base",
'palette_color2', "inside_metal",
'palette_color3', "life_accent_1",

s:SetColorizationMaterial(3, ColorizationMaterialDecode(3132729656))

CloningVats
'palette_color1', "inside_base",
'palette_color2', "inside_accent_medical",
'palette_color3', "inside_metal",
--]]
--[[
telescope
1 9980454
2 8553090
3 14606046
	'palette_color1', "outside_base",
	'palette_color2', "inside_accent_research",
	'palette_color3', "outside_metal",

mohole
1 9193472
2 5789784
3 6974058

space elev
1 3032666
	'palette_color1', "outside_accent_1",
	'palette_color2', "outside_base",
	'palette_color3', "electro_accent_2",

art sun
1 3032666

project morph
1 3032666

sanit
2 3435136

network node
1 7237230
3 15350282

clonevat
2 9461848

electr store
3 2368548

art store
1 3680802

casino
1 2367520
3 61182

spacebar
1 2778756

mar uni
4 5119010

hawking
1 29300

res lab
1 1715262

water tank
1 6423556

moist vap
2 6954006

water extr
2 6035990

oxy tank
1 7340546

moxie
1 8001046

tunnel door
4 1989232

fuelk refin
3 2510946
4 7249126

machine parts fac
1 5129264

elec fac
1 6575674
2 1183246

poly fac
3 1198176

rare mets
2 2124452

fusion
1 10507294
2 2124452
3 3289650

subheat
2 5510160
--]]

-- this is just a copy n paste of one of the in-game schemes
-- convert the numbers with ColorizationMaterialDecode(2209066747), this will return three numbers:
-- a value you can use with GetRGB(value), roughness value, metallic value
-- to convert back into the proper number use ColorizationMaterialEncode(RGB(22, 36, 50), rough, met)

-- not my speeling

local ColorizationMaterialEncode = ColorizationMaterialEncode
function OnMsg.ClassesPostprocess()
	-- check for the id of the scheme so we don't add dupes
	if not Presets.ColonyColorScheme.Default.ChoGGi_Classic_Colour_Scheme then
		PlaceObj('ColonyColorScheme', {
			display_name = "Classic Colours",
			id = "ChoGGi_Classic_Colour_Scheme",
			group = "Default",

			cables_base = ColorizationMaterialEncode(1518913, -16, 24),
			-- yellowish
			dome_base = 2209066747,
			-- reddish
			electro_accent_1 = 2196030942,
			-- blueish
--~ 			electro_accent_2 = 1792320026,
			electro_accent_2 = ColorizationMaterialEncode(10507294, 0, 0),
			-- whiteish

			electro_base = 2197732730,
--~ 			electro_base = ColorizationMaterialEncode(2124452, 0, 0),
			incide_accent_green = 2214666249,
			incide_accent_red = 2214691666,
			incide_accent_wood = 2214925623,
			incide_dark = 2215021850,
--~ 			inside_accent_1 = 2204419550,
			inside_accent_1 = ColorizationMaterialEncode(10765370, 64, -32),
--~ 			inside_accent_2 = 2191420342,
			inside_accent_2 = 2191420342,
			inside_accent_factory = 2614983144,
			inside_accent_food = 2208523310,
			inside_accent_housing = 2204734246,
--~ 			inside_accent_medical = 2206435183,
			inside_accent_medical = ColorizationMaterialEncode(9461848, 0, 0),
--~ 			inside_accent_research = 2207440038,
			inside_accent_research = ColorizationMaterialEncode(9980454, 0, 0),
--~ 			inside_accent_service = 2209377272,
			inside_accent_service = ColorizationMaterialEncode(13618378, 0, 0),
			inside_base = 2199912447,
			inside_metal = 3132729656,
			inside_wood = 2204669242,
--~ 			life_accent_1 = 2214905310,
			life_accent_1 = ColorizationMaterialEncode(-5592406, 0, 0),
			life_base = 2199681265,
--~ 			mining_accent_1 = 2200233326,
			mining_accent_1 = ColorizationMaterialEncode(16745472, 0, 0),
			mining_base = 2203991160,
--~ 			mining_base = ColorizationMaterialEncode(2124452, 0, 0),
			-- dark gray
			none = 3130007616,
--~ 			outside_accent_1 = 2206516702,
			outside_accent_1 = ColorizationMaterialEncode(3032666, 0, 0),
			outside_accent_2 = 2205442228,
--~ 			outside_accent_factory = 2206516702,
			outside_accent_factory = 2206516702,
			outside_base = 2208069873,
			outside_dark = ColorizationMaterialEncode(5789784, 0, 0),
--~ 			outside_dark = 2207161658,
--~ 			outside_metal = 2207706587,
			outside_metal = ColorizationMaterialEncode(9193472, 0, 0),
			pipes_base = 2199664752,
			pipes_metal = 2173937486,

			rocket_accent = nil,
			rocket_base = nil,
			rover_accent = 2200225246,
			rover_base = 2204024186,
			rover_dark = 2215220006,
			wonder_base = 2214592512,
	})
	end
end
