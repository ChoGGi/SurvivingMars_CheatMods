-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "DailySanityLoss",
		"DisplayName", T(302535920011783, "Daily Sanity Loss"),
		"Help", T(302535920011790, "How many sanity is lost each day after landing on Mars (cannibals only...)."),
		"DefaultValue", 4,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DailyColonistLoss",
		"DisplayName", T(302535920011784, "Daily Colonist Loss"),
		"Help", T(302535920011785, "How many longpigs are cooked up for the Lūʻau."),
		"DefaultValue", 1,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxFeedingTime",
		"DisplayName", T(302535920011786, "Max Feeding Time"),
		"Help", T(302535920011787, [[Max time in hours between Min Feeding Time.

Once a rocket is in orbit; it's time is set.]]),
		"DefaultValue", 10,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MinFeedingTime",
		"DisplayName", T(302535920011788, "Min Feeding Time"),
		"Help", T(302535920011789, [[Min time in hours between Min Feeding Time.

Once a rocket is in orbit; it's time is set.]]),
		"DefaultValue", 4,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
