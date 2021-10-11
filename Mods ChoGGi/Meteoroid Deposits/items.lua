-- See LICENSE for terms

local props = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SurfaceOnly",
		"DisplayName", T(302535920012054, "Surface Only"),
		"Help", T(302535920012055, "You only get deposits on the surface colony."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SafeLanding",
		"DisplayName", T(302535920012040, "Safe Landing"),
		"Help", T(302535920012041, "Buildings won't be hit by falling rocks."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MetalsThreshold",
		"DisplayName", T(302535920012042, "Metals Threshold"),
		"Help", T(302535920012043, "Threshold for a new Metals deposit."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RareMetalsThreshold",
		"DisplayName", T(302535920012044, "Rare Metals Threshold"),
		"Help", T(302535920012045, "Threshold for a new Rare Metals deposit."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "WaterThreshold",
		"DisplayName", T(302535920012046, "Water Threshold"),
		"Help", T(302535920012047, "Threshold for a new Water deposit."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ConcreteThreshold",
		"DisplayName", T(302535920012048, "Concrete Threshold"),
		"Help", T(302535920012049, "Threshold for a new Concrete deposit."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 50,
	}),
}

if g_AvailableDlc.picard then
	props[#props+1] = PlaceObj("ModItemOptionToggle", {
		"name", "ExoticMinerals",
		"DisplayName", T(608869515243, "Exotic Minerals"),
		"Help", T(302535920012090, "Drop mineral deposits."),
		"DefaultValue", false,
	})
	props[#props+1] = PlaceObj("ModItemOptionNumber", {
		"name", "ExoticMineralsThreshold",
		"DisplayName", T(302535920012091, "Exotic Minerals Threshold"),
		"Help", T(302535920012092, "Threshold for a new Exotic Minerals deposit."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 50,
	})
end

return props
