-- See LICENSE for terms

local T = T
local table = table

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ColdWaveCrackling",
		"DisplayName", T(302535920011995, "Cold Wave Crackling"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ResearchComplete",
		"DisplayName", T(5654, "Research Complete"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SelectBuildingSound",
		"DisplayName", T(000, "Select Building Sound"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RareMetalsExtractor",
		"DisplayName", T(3530, "Rare Metals Extractor"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "BioroboticsWorkshop",
		"DisplayName", T(8825, "Biorobotics Workshop"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SensorSensorTowerBeeping",
		"DisplayName", T(302535920011379, "Sensor Tower Beeping"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RCCommanderDronesDeployed",
		"DisplayName", T(302535920011380, "RC Drones Deployed"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MirrorSphereCrackling",
		"DisplayName", T(302535920011381, "Mirror Sphere Crackling"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NurseryChild",
		"DisplayName", table.concat(T(5179, "Nursery") .. " " .. T(4775, "Child")),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SpacebarMusic",
		"DisplayName", table.concat(T(5280, "Spacebar") .. " " .. T(3580, "Music")),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
}
