-- See LICENSE for terms

local T = T
local PlaceObj = PlaceObj

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "DustGeyserBurst",
		"DisplayName", T(302535920012019, "Dust Geyser Burst"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ArtificialSunZapping",
		"DisplayName", T(302535920012020, "Artificial Sun Zapping"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
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
		"DisplayName", T(302535920012021, "Select Building"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RareMetalsExtractor",
		"DisplayName", T(3530, "Rare Metals Extractor Thumping"),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "BioroboticsWorkshop",
		"DisplayName", T(8825, "Biorobotics Workshop Ambience"),
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
		"DisplayName", T(302535920011380, "RC Drones Deployed Beeping"),
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
		"DisplayName", T(302535920012022, "Nursery Children"),
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

if g_AvailableDlc.picard then
	mod_options[#mod_options+1] = PlaceObj("ModItemOptionToggle", {
		"name", "SupportStrutGrind",
		"DisplayName", table.concat(T(174671309714, "Support Strut") .. " " .. T(0000, "Grind")),
		"Help", T(302535920011593, "Turn <color ChoGGi_green>On</color> to disable sound."),
		"DefaultValue", false,
	})
end

return mod_options
