-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	-- TheMartian
	PlaceObj("ModItemOptionNumber", {
		"name", "TheMartian_Evening",
		"DisplayName", T(0000, "Before TerraForm Evening"),
		"Help", T(0000, [[This is the lightmodel used before planet is terraformed.

Default value is 50]]),
		"DefaultValue", 50 * 2,
		"MinValue", 0,
		"MaxValue", 200,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TheMartian_Night",
		"DisplayName", T(0000, "Before TerraForm Night"),
		"Help", T(0000, [[This is the lightmodel used before planet is terraformed.

Default value is 19]]),
		"DefaultValue", 19 * 2,
		"MinValue", 0,
		"MaxValue", 200,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TheMartian_Dawn",
		"DisplayName", T(0000, "Before TerraForm Dawn"),
		"Help", T(0000, [[This is the lightmodel used before planet is terraformed.

Default value is 0]]),
		"DefaultValue", 30,
		"MinValue", 0,
		"MaxValue", 200,
	}),
	-- Disasters
	PlaceObj("ModItemOptionNumber", {
		"name", "ColdWave_Dawn",
		"DisplayName", T(0000, "ColdWave Dawn"),
		"Help", T(0000, [[Coldwave dawn lightmodel.

Default value is 0]]),
		"DefaultValue", 30,
		"MinValue", 0,
		"MaxValue", 200,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DustStorm_Dawn",
		"DisplayName", T(0000, "DustStorm Dawn"),
		"Help", T(0000, [[DustStorm dawn lightmodel.

Default value is 0]]),
		"DefaultValue", 30,
		"MinValue", 0,
		"MaxValue", 200,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "GreatDustStorm_Dawn",
		"DisplayName", T(0000, "GreatDustStorm Dawn"),
		"Help", T(0000, [[GreatDustStorm dawn lightmodel.

Default value is 0]]),
		"DefaultValue", 30,
		"MinValue", 0,
		"MaxValue", 200,
	}),
}
