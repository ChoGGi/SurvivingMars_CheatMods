-- See LICENSE for terms

local table = table
local T = T

local mod_options = {
	-- Meteors
	PlaceObj("ModItemOptionToggle", {
		"name", "MeteorsOverkill",
		"DisplayName", table.concat(T(4146, "Meteors") .. ": " .. T(302535920011606, "Overkill")),
		"Help", T(302535920011607, "Lotta Meteors!\n\n<red>You've been warned...</red>"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MeteorsNoDeposits",
		"DisplayName", table.concat(T(4146, "Meteors") .. ": " .. T(302535920011608, "No Deposits")),
		"Help", T(302535920011609, "Enable this option to not have any goodies dropped off.\nThis will override all Meteors!"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MeteorsMDSLasers",
		"DisplayName", table.concat(T(4146, "Meteors") .. ": " .. T(5123, "MDS Lasers")),
		"Help", T(302535920012074, "Unlock building MDS Lasers from the get-go."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MeteorsDefensiveTurrets",
		"DisplayName", table.concat(T(4146, "Meteors") .. ": " .. T(6985, "Defensive Turrets")),
		"Help", T(302535920012075, "Unlock building Defensive Turrets from the get-go."),
		"DefaultValue", false,
	}),
	-- Dust Storms
	PlaceObj("ModItemOptionToggle", {
		"name", "DustStormsUnbreakableCP",
		"DisplayName", table.concat(T(4144, "Dust Storms") .. ": " .. T(302535920011872, "Unbreakable Cables/Pipes")),
		"Help", T(302535920011873, "Cables/Pipes won't break (same as breakthrough tech, but no free construction)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DustStormsAllowRockets",
		"DisplayName", table.concat(T(4144, "Dust Storms") .. ": " .. T(302535920011612, "Allow Rockets")),
		"Help", T(302535920011613, "Allow rockets to take off and land."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DustStormsAllowMOXIEs",
		"DisplayName", table.concat(T(4144, "Dust Storms") .. ": " .. T(302535920012085, "Allow MOXIEs")),
		"Help", T(302535920012086, "You can build/use MOXIEs."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DustStormsMOXIEPerformance",
		"DisplayName", table.concat(T(4144, "Dust Storms") .. ": " .. T(302535920011614, "MOXIE Performance")),
		"Help", T(302535920011615, "Set the negative performance of MOXIEs during dust storms (higher = worse for you)."),
		"DefaultValue", 75,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DustStormsElectrostatic",
		"DisplayName", table.concat(T(4144, "Dust Storms") .. ": " .. T(302535920011616, "Electrostatic Storm")),
		"Help", table.concat(T(302535920011617, "Chance of an electrostatic storm (lightning strikes).") .. "\n\n"
			.. T(302535920011874, "Electrostatic gets chosen before Great, so if it's high enough than Great won't happen.")),
		"DefaultValue", DataInstances.MapSettings_DustStorm.DustStorm_VeryHigh.electrostatic or 5,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DustStormsGreatStorm",
		"DisplayName", table.concat(T(4144, "Dust Storms") .. ": " .. T(302535920011618, "Great Storm")),
		"Help", table.concat(T(302535920011619, "Chance of a great storm (turbines spin faster?).") .. "\n\n"
			.. T(302535920011874, "Electrostatic gets chosen before Great, so if it's high enough than Great won't happen.")),
		"DefaultValue", DataInstances.MapSettings_DustStorm.DustStorm_VeryHigh.great or 15,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	-- Dust Devils
	PlaceObj("ModItemOptionNumber", {
		"name", "DustDevilsTwisterAmount",
		"DisplayName", table.concat(T(4142, "Dust Devils") .. ": " .. T(302535920011620, "Twister Amount")),
		"Help", T(302535920011621, "Minimum amount of twisters on the map (max is 2 * amount)."),
		"DefaultValue", 4,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DustDevilsTwisterMaxAmount",
		"DisplayName", table.concat(T(4142, "Dust Devils") .. ": " .. T(302535920011620, "Twister Amount") .. " " .. T(8780, "MAX")),
		"Help", T(302535920011634, "If you want to set the max (0 to ignore)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DustDevilsElectrostatic",
		"DisplayName", table.concat(T(4142, "Dust Devils") .. ": " .. T(302535920011622, "Electrostatic")),
		"Help", T(302535920011623, "Chance of electrostatic dust devil (drains drone batteries)."),
		"DefaultValue", MapSettings_DustDevils.electro_chance or 5,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	-- cold areas
	PlaceObj("ModItemOptionToggle", {
		"name", "ColdAreaGiveSubsurfaceHeaters",
		"DisplayName", table.concat(T(12824, "Cold Area") .. ": " .. T(302535920011875, "Give ") .. T(5294,"Subsurface Heaters")),
		"Help", T(302535920011876, "Start game with Subsurface Heaters researched."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ColdAreaUnlockSubsurfaceHeaters",
		"DisplayName", table.concat(T(12824, "Cold Area") .. ": " .. T(0000, "Unlock ") .. T(5294,"Subsurface Heaters")),
		"Help", T(0000, "Subsurface Heaters can be built underground/asteroids."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ColdAreaSkipUnderground",
		"DisplayName", table.concat(T(12824, "Cold Area") .. ": " .. T(0000, "Skip Underground")),
		"Help", T(0000, "Underground stays as is."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ColdAreaSkipAsteroids",
		"DisplayName", table.concat(T(12824, "Cold Area") .. ": " .. T(0000, "Skip Asteroids")),
		"Help", T(0000, "Asteroids stay as is."),
		"DefaultValue", false,
	}),

}

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
