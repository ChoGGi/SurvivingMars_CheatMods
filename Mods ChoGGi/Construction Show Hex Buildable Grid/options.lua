local u = ChoGGi.UserSettings
local grid_opacity = type(u.DebugGridOpacity) == "number" and u.DebugGridOpacity or 15
local grid_size = type(u.DebugGridSize) == "number" and u.DebugGridSize or 25

DefineClass("ModOptions_ChoGGi_ConstructionShowHexBuildableGrid", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Option1",
			name = T(302535920011068, "Show during construction"),
			desc = "Show during construction.",
		},
		{
			default = grid_size,
			max = 100,
			min = 1,
			editor = "number",
			id = "DebugGridSize",
			name = T(302535920011069, "Grid Size"),
		},
		{
			default = grid_opacity,
			max = 100,
			min = 0,
			editor = "number",
			id = "DebugGridOpacity",
			name = T(302535920011070, "Grid Opacity"),
		},
	},
})