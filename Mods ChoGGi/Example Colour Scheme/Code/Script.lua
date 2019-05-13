--[[
To encode/decode the numbers below:

plunking this in the console (open mod editor or just use ECM):
ColorizationMaterialDecode(2209066747)
will give you something like
-4543543 45 70

-4543543 = 24bit colour value, you can either plunk it in my object colour mod to fiddle or use GetRGB(-4543543) which will give you the rgb values

45 = roughness value
70 = metallic
(rough and met are how mottled/shiny the surface is)

to get a number for the list use
ColorizationMaterialEncode(colour_value, roughness, metallic)
or
ColorizationMaterialEncode(RGB(22, 36, 50), roughness, metallic)
--]]

-- not my speeling

local ColorizationMaterialEncode = ColorizationMaterialEncode
function OnMsg.ClassesPostprocess()
	-- check for the id of the scheme so we don't add dupes
	if not Presets.ColonyColorScheme.Default.ChoGGi_Custom_Scheme then
		PlaceObj('ColonyColorScheme', {
			display_name = "Custom Scheme",
			id = "ChoGGi_Custom_Scheme",
			group = "Default",

			cables_base = ColorizationMaterialEncode(1518913, -16, 24),
			dome_base = 2187894897,
			electro_accent_1 = 2215054937,
			electro_accent_2 = 2986060593,
			electro_base = 2214588606,
			incide_accent_green = 2214666249,
			incide_accent_red = 2214691666,
			incide_accent_wood = 2214925623,
			incide_dark = 2215021850,
			inside_accent_1 = 2200736526,
			inside_accent_2 = 2198415095,
			inside_accent_factory = 2203988035,
			inside_accent_food = 2211077937,
			inside_accent_housing = 2857046543,
			inside_accent_medical = 2210629487,
			inside_accent_research = 2201428392,
			inside_accent_service = 2189190810,
			inside_base = 2210398207,
			inside_metal = 2591434031,
			inside_wood = 2202572090,
			life_accent_1 = 2216288661,
			life_base = 2194089715,
			mining_accent_1 = 2596495343,
			mining_base = 2228988721,
			none = 3130007616,
			outside_accent_1 = 2170773487,
			outside_accent_2 = 2208102899,
			outside_accent_factory = 3150487665,
			outside_base = 2210332155,
			outside_dark = 2215236519,
			outside_metal = 2352410075,
			pipes_base = 3969673781,
			pipes_metal = 2331834867,
			rocket_accent = 2209949355,
			rocket_base = 2205923182,
			rover_accent = 2212330229,
			rover_base = 2209949355,
			rover_dark = 2215220006,
			wonder_base = 2214592512,
		})
	end
end
