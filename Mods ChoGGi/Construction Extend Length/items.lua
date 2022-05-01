-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "BuildDist",
		"DisplayName", T(302535920011485, "Build Distance"),
		"Help", T(302535920011399, "How many hexes you can build."),
		"DefaultValue", 250,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PassChunks",
		"DisplayName", T(302535920011486, "Passage Chunks"),
		"Help", T(302535920011400, "Passage length when bending."),
		"DefaultValue", 250,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PassageWalkSpeed",
		"DisplayName", T(302535920011821, "Passage Walk Speed"),
		"Help", T(302535920011822, [[How fast colonists move in passages (useful for longer passages).
1 = regular speed, 2 = 2x regular speed, etc.]]),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 100,
	}),
}
