
-- get defaults from ECM if enabled
local ChoGGi = rawget(_G, "ChoGGi")
local grid_opacity
local grid_size
if ChoGGi then
	local u = ChoGGi.UserSettings
	grid_opacity = type(u.DebugGridOpacity) == "number" and u.DebugGridOpacity or 15
	grid_size = type(u.DebugGridSize) == "number" and u.DebugGridSize or 25
end

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "Option1",
		"DisplayName", T(302535920011364, "Show during construction"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DebugGridSize",
		"DisplayName", T(302535920011069, "Grid Size"),
		"DefaultValue", grid_size,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DebugGridOpacity",
		"DisplayName", T(302535920011070, "Grid Opacity"),
		"DefaultValue", grid_opacity,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
