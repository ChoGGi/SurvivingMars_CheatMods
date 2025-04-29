-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ReconnectGrids",
		"DisplayName", T(0000, "Reconnect Grids"),
		"Help", T(0000, "Try to reconnect grids by turning on switches if no leaks detected."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PipeValves",
		"DisplayName", T(0000, "Pipe Valves"),
		"Help", T(0000, "Toggle pipe valves automagically."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "CableSwitches",
		"DisplayName", T(0000, "Cable Switches"),
		"Help", T(0000, "Toggle cable switches automagically."),
		"DefaultValue", true,
	}),
}
