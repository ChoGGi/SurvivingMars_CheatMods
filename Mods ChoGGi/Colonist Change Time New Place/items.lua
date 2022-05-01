-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ForcedByUserLockTimeout",
		"DisplayName", T(492281705322, "ForcedByUserLockTimeout"),
		"Help", T(691313621108, "Lock time to Workplace, Residence, Dome selected by user"),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 500,
	}),
}
