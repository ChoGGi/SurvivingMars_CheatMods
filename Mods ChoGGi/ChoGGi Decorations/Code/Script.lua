-- See LICENSE for terms

local decorations = {
	"SoftChair_01",
	"TubeChromeJoint", "TubeJoint",
	"SurfaceDepositConcrete_01", "SurfaceDepositConcrete_02", "SurfaceDepositConcrete_03", "SurfaceDepositConcrete_04", "SurfaceDepositConcrete_05",
	"TreeArm_01",	"TreeArm_02",	"TreeArm_03",	"TreeArm_04",
	"Tree_01",	"Tree_02",	"Tree_03",	"Tree_04",	"Tree_05",
	"SignWater",
	"Monolith",	"MonolithSmall_01",	"MonolithSmall_01",	"MonolithSmall_02",	"MonolithSmall_03",	"MonolithSmall_05",
	"ArtificialSunSphere",	"PlanetMars",	"PlanetEarth",	"PlanetClouds",
	"Mystery_MirrorSphere",
	"Lama",
	"GrassArm_01",	"GrassArm_02",
	"Asteroid",
	"DefenceTurretRocket",
	"BushArm_01",	"BushArm_02",	"BushArm_03",
	"Bush_01",	"Bush_02",	"Bush_03",	"Bush_04",	"Bush_05",	"Bush_06",
	"DebrisConcrete",
	"DebrisMetal",
	"DebrisPolymer",
	"DecorInt_01",	"DecorInt_02",	"DecorInt_03",	"DecorInt_04",	"DecorInt_05",	"DecorInt_06",
	"LampInt_01",	"LampInt_02",	"LampInt_03",	"LampInt_04",	"LampInt_05",
}

local IsValidEntity = IsValidEntity

function OnMsg.ClassesPostprocess()

	local bc = BuildCategories
	if not table.find(bc, "id", "ChoGGi_Decorations") then
		bc[#bc+1] = {
			id = "ChoGGi_Decorations",
			name = T(87, "Decorations"),
			image = "UI/Icons/Buildings/placeholder.tga",
		}
	end

	if BuildingTemplates["ChoGGi_" .. decorations[1]] then
		return
	end

	for i = 1, #decorations do
		local entity = decorations[i]
		if IsValidEntity(entity) then
			PlaceObj("BuildingTemplate", {
				"Id", "ChoGGi_" .. entity,
				"entity", entity,

				"display_name", entity,
				"display_name_pl", entity,
				"description", T(87, "Decorations"),
				"display_icon", "UI/Icons/Buildings/placeholder.tga",

				"instant_build", true,
				"build_points", 0,

				"Group", "ChoGGi_Decorations",
				"build_category", "ChoGGi_Decorations",
				"on_off_button", false,
				"prio_button", false,
			})
		end
	end

end
