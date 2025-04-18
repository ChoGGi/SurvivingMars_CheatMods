-- See LICENSE for terms

local ScaleStat = const.Scale.Stat

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxSafariLength",
		"DisplayName", T(302535920011847, "Max Safari Length"),
		"Help", T(302535920011877, "Change the max safari route limit."),
		"DefaultValue", MaxRouteLength,
		"MinValue", 0,
		"MaxValue", 10000,
		"StepSize", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RCSafariMaxWaypoints",
		"DisplayName", T(302535920011878, "RC Safari Max Waypoints"),
		"Help", T(12811, "How many waypoints a safari can have."),
		"DefaultValue", (g_Consts and g_Consts.RCSafariMaxWaypoints or Consts.RCSafariMaxWaypoints),
		"MinValue", 1,
		"MaxValue", 250,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SightRange",
		"DisplayName", T(302535920011879, "Sight Range"),
		"Help", T(302535920011880, "How far the tourists can see sights from the rover."),
		"DefaultValue", RCSafari.sight_range,
		"MinValue", 1,
		"MaxValue", 250,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxPassengers",
		"DisplayName", T(12764, "Max passengers"),
		"Help", T(302535920011881, "How many tourists per safari."),
		"DefaultValue", RCSafari.max_visitors,
		"MinValue", 1,
		"MaxValue", 250,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SatisfactionChange",
		"DisplayName", T(12712, "Satisfaction change on visit"),
		"Help", T(302535920011882, "Add satisfaction for visit."),
		"DefaultValue", RCSafari.satisfaction_change / ScaleStat,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "HealthChange",
		"DisplayName", T(728, "Health change on visit"),
		"Help", T(302535920011883, "Add health for visit."),
		"DefaultValue", RCSafari.health_change / ScaleStat,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SanityChange",
		"DisplayName", T(729, "Sanity change on visit"),
		"Help", T(302535920011884, "Add sanity for visit."),
		"DefaultValue", RCSafari.sanity_change / ScaleStat,
		"MinValue", 0,
		"MaxValue", 100,
	}),

	PlaceObj("ModItemOptionNumber", {
		"name", "ServiceComfort",
		"DisplayName", T(730, "Service Comfort"),
		"Help", T(302535920011885, "Comfort threshold for increase."),
		"DefaultValue", RCSafari.service_comfort / ScaleStat,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ComfortIncrease",
		"DisplayName", T(731, "Comfort increase on visit"),
		"Help", T(302535920011886, "How much comfort is added per visit."),
		"DefaultValue", RCSafari.comfort_increase / ScaleStat,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
