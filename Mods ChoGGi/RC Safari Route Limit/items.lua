-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxSafariLength",
		"DisplayName", T(302535920011847, "Max Safari Length"),
		"DefaultValue", MaxRouteLength * 2,
		"MinValue", 1,
		"MaxValue", 100000,
		"StepSize", 100,
	}),
}
