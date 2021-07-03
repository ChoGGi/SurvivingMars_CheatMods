-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "MinimumSurfaceDeposits",
		"DisplayName", T(0000, "Minimum Surface Deposits"),
		"Help", T(0000, [[Use a sector with at least this many surface deposits (concrete and scattered metals).

If no sector has enough than return the one with the most.
Set both to 0 for random (how it used to work).
]]),
		"DefaultValue", 6,
		"MinValue", 0,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MinimumSubsurfaceDeposits",
		"DisplayName", T(0000, "Minimum Subsurface Deposits"),
		"Help", T(0000, [[Use a sector with at least this many subsurface deposits (metals/rare metals deposits).

If no sector has enough than return the one with the most.
Set both to 0 for random (how it used to work).
]]),
		"DefaultValue", 2,
		"MinValue", 0,
		"MaxValue", 10,
	}),
}