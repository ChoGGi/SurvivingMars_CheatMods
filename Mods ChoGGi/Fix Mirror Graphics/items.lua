-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DumpingSites",
		"DisplayName", T(5052, "Dumping Sites"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DomeGrass",
		"DisplayName", T(0000, "Dome Grass"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DomeBeachSand",
		"DisplayName", T(0000, "Dome Beach Sand"),
		"Help", T(0000, "Sandy beaches in geoscape domes."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DomeRubble",
		"DisplayName", T(0000, "Dome Rubble"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TerraGrass",
		"DisplayName", T(0000, "Terraform Grass"),
		"Help", T(0000, "Most green areas after terraforming."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TerraLake",
		"DisplayName", T(0000, "TerraTerraform Lake"),
		"Help", T(0000, "Textures under lakes?"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TerraLichen",
		"DisplayName", T(0000, "TerraTerraform Lichen"),
		"Help", T(0000, "Also includes leftovers from toxic rain."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TerraMoss",
		"DisplayName", T(0000, "TerraTerraform Moss"),
		"Help", T(0000, "dunno?"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TerraSoil",
		"DisplayName", T(0000, "TerraTerraform Soil"),
		"Help", T(0000, "probably farm stuff?"),
		"DefaultValue", false,
	}),
}
