-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableLakes",
		"DisplayName", T(0000, "Enable Lakes"),
		"Help", T(0000, [[Swap lakes with a fake ice/water texture, so you can still visually see the level.

I had to adjust the level so the texture mostly stays below the ground.]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableGridView",
		"DisplayName", T(0000, "Enable Grid View"),
		"Help", T(0000, "As an alternate this will use a debug view instead of water (but it bleeds through entities)."),
		"DefaultValue", false,
	}),
}