-- See LICENSE for terms

local consts = g_Consts and g_Consts or Consts

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "DustStormFlight",
		"DisplayName", T(0000, "Dust Storm Flight"),
		"Help", T(0000, "Rockets can land and take off during dust storms."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "LaunchFuel",
		"DisplayName", T(702, "Launch Fuel"),
		"Help", T(302535920011867, "The amount of fuel it takes to launch the rocket."),
		"DefaultValue", RocketBase:GetProperty("launch_fuel") / const.ResourceScale,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxExportStorage",
		"DisplayName", T(758, "Max Export Storage"),
		"Help", T(302535920011897, "How many rares on one rocket."),
		"DefaultValue", RocketBase:GetProperty("max_export_storage") / const.ResourceScale,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PassengerOrbitLifetime",
		"DisplayName", T(8457, "Passenger Orbit Lifetime"),
		"Help", T(302535920011868, "Passengers on board will die if the rocket doesn't land this many hours after arriving in orbit."),
		"DefaultValue", RocketBase:GetProperty("passenger_orbit_life") / const.HourDuration,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "CargoCapacity",
		"DisplayName", T(4598, "Payload Capacity"),
		"Help", T(4597, "Maximum payload (in kg) of a resupply Rocket"),
		"DefaultValue", consts.CargoCapacity / const.ResourceScale,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "FoodPerRocketPassenger",
		"DisplayName", T(4616, "Food per Rocket Passenger"),
		"Help", T(4615, "The amount of Food (unscaled) supplied with each Colonist arrival"),
		"DefaultValue", consts.FoodPerRocketPassenger / const.ResourceScale,
		"MinValue", 0,
		"MaxValue", 1000,
	}),

	PlaceObj("ModItemOptionNumber", {
		"name", "MaxColonistsPerRocket",
		"DisplayName", T(4594, "Colonists per Rocket"),
		"Help", T(4593, "Maximum number of Colonists that can arrive on Mars in a single Rocket"),
		"DefaultValue", consts.MaxColonistsPerRocket,
		"MinValue", 0,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TravelTimeEarthMars",
		"DisplayName", T(4590, "Rocket Travel Time (Earth to Mars)"),
		"Help", T(4589, "Time it takes for a Rocket to travel from Earth to Mars"),
		"DefaultValue", consts.TravelTimeEarthMars / const.Scale.hours,
		"MinValue", 0,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TravelTimeMarsEarth",
		"DisplayName", T(4592, "Rocket Travel Time (Mars to Earth)"),
		"Help", T(4591, "Time it takes for a Rocket to travel from Mars to Earth"),
		"DefaultValue", consts.TravelTimeMarsEarth / const.Scale.hours,
		"MinValue", 0,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RocketPrice",
		"DisplayName", T(744485829662, "Rocket Price"),
		"Help", T(302535920011869, "In Millions."),
		"DefaultValue", consts.RocketPrice / const.Scale.mil,
		"MinValue", 0,
		"MaxValue", 50000,
		"StepSize", 100,
	}),
}
