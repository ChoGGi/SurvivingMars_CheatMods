-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddRivals",
		"DisplayName", T(0000, "Rival Amount"),
		"Help", T(0000, "How many rivals to spawn."),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", #Presets.DumbAIDef.MissionSponsors,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RivalSpawnSol",
		"DisplayName", T(0000, "Rival Spawn Sol"),
		"Help", T(0000, "Pick Sol that rivals will spawn on."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RivalSpawnSolRandom",
		"DisplayName", T(0000, "Rival Spawn Sol Random"),
		"Help", T(0000, [[Turn this on to randomise Rival Spawn Sol.
Min value is 1, Max value is set to Rival Spawn Sol.
You might need to re-apply mod options after starting a couple new games.]]),
		"DefaultValue", false,
	}),
}
