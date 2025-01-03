-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "BreakthroughCount",
		"DisplayName", T(0000, "Breakthrough Count"),
		"Help", T(0000, [[Defaults to 13: 4 from planetary anomalies, and 9 from ground anomalies.
You can also get some from storybits, but those can change slightly (you could bump it up to 17 and very likely get them as well).

If you have B&B DLC then ignore the first four, as they don't get planetary anomalies; see my Fix Bugs mod.]]),
		"DefaultValue", 13,
		"MinValue", 1,
		"MaxValue", #(Presets.TechPreset.Breakthroughs or 50),
	}),
}
