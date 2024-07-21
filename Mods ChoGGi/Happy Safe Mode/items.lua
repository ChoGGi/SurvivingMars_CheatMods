-- See LICENSE for terms

local Consts = Consts

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DisableStoryBitSuicides",
		"DisplayName", T(0000, "Disable Story Bit Suicides"),
		"Help", T(0000, [[Certain StoryBits will kill off colonists; this will stop the suicide, but the storybit will still mention it (I got better).
You can disable if preferred for roleplaying.
]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ColdWaveSanityDamage",
		"DisplayName", T(0000, "Cold Wave Sanity Damage"),
		"Help", T(438538796804--[[Sanity damage from a Cold Wave (per hour)]]),
		"DefaultValue", Consts.ColdWaveSanityDamage,
		"MinValue", 0,
		"MaxValue", 2000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DustStormSanityDamage",
		"DisplayName", T(0000, "Dust Storm Sanity Damage"),
		"Help", T(438538796803--[["Sanity damage from Dust Storms (per hour)]]),
		"DefaultValue", Consts.DustStormSanityDamage,
		"MinValue", 0,
		"MaxValue", 2000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MeteorSanityDamage",
		"DisplayName", T(0000, "Meteor Sanity Damage"),
		"Help", T(4579--[[Sanity damage from meteor (one-time on impact)]]),
		"DefaultValue", Consts.MeteorSanityDamage,
		"MinValue", 0,
		"MaxValue", 50000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MysteryDreamSanityDamage",
		"DisplayName", T(0000, "Mirages Sanity Damage"),
		"Help", T(6975--[[Sanity damage for Dreamers from Mirages (per hour)]]),
		"DefaultValue", Consts.MysteryDreamSanityDamage,
		"MinValue", 0,
		"MaxValue", 2000,
	}),
}
