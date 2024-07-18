-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RocksChance",
		"DisplayName", T(0000, "Rocks Chance"),
		"Help", T(0000, "Chance of useless rocks in meteorite."),
		"DefaultValue", MapSettings_Meteor.deposit_rock_chance,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MetalsChance",
		"DisplayName", T(0000, "Metals Chance"),
		"Help", T(0000, "Chance of Metals in meteorite."),
		"DefaultValue", MapSettings_Meteor.deposit_metals_chance,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RareMetalsChance",
		"DisplayName", T(0000, "Rare Metals Chance"),
		"Help", T(0000, "Chance of Rare Metals in meteorite."),
		"DefaultValue", 4,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ExoticMineralsChance",
		"DisplayName", T(0000, "Exotic Minerals Chance"),
		"Help", T(0000, "Chance of Exotic Minerals in meteorite."),
		"DefaultValue", 4,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PolymersChance",
		"DisplayName", T(0000, "Polymers Chance"),
		"Help", T(0000, "Chance of Polymers in meteorite."),
		"DefaultValue", MapSettings_Meteor.deposit_polymers_chance,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AnomalyChance",
		"DisplayName", T(0000, "Anomaly Chance"),
		"Help", T(0000, "Chance of Anomaly in meteorite."),
		"DefaultValue", MapSettings_Meteor.deposit_anomaly_chance,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
