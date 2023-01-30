-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "ResearchCost",
		"DisplayName", T(0000, "Research Cost"),
		"Help", T(0000, "How much to scan for asteroids/store in Center."),
		"DefaultValue", Consts.DiscoveryScanCost / const.ResearchPointsScale,
		"MinValue", 1,
		"MaxValue", 100,
	}),
}
