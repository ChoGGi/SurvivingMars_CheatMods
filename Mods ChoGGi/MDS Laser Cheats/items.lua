-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "HitChance",
		"DisplayName", T(671, "Hit Chance"),
		"Help", T(302535920011861, "The chance to hit a meteor."),
		"DefaultValue", MDSLaser:GetProperty("hit_chance"),
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "FireRate",
		"DisplayName", T(672, "Fire Rate"),
		"Help", T(302535920011862, "Cooldown between shots in ms."),
		"DefaultValue", MDSLaser:GetProperty("cooldown"),
		"MinValue", 0,
		"MaxValue", 10000,
		"StepSize", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ProtectRange",
		"DisplayName", T(673, "Protect Range"),
		"Help", T(302535920011863, "If meteors would fall within dist range it can be destroyed by the laser (in hexes)."),
		"DefaultValue", MDSLaser:GetProperty("protect_range"),
		"MinValue", 1,
		"MaxValue", 128,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ShootRange",
		"DisplayName", T(674, "Shoot Range"),
		"Help", T(302535920011864, "Range at which meteors can be destroyed. Should be greater than the protection range (in hexes)."),
		"DefaultValue", MDSLaser:GetProperty("shoot_range"),
		"MinValue", 1,
		"MaxValue", 128,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RotateSpeed",
		"DisplayName", T(676, "Rotate Speed"),
		"Help", T(302535920011865, "Platform's rotation speed to target meteor in Deg/Sec."),
		"DefaultValue", MDSLaser:GetProperty("rot_speed") / 60,
		"MinValue", 0,
		"MaxValue", 3600,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "BeamTime",
		"DisplayName", T(677, "Beam Time"),
		"Help", T(302535920011866, "For how long laser beam is visible (in ms)."),
		"DefaultValue", MDSLaser:GetProperty("beam_time"),
		"MinValue", 0,
		"MaxValue", 10000,
		"StepSize", 100,
	}),
}
