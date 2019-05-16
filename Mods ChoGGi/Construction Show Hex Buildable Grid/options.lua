local u = ChoGGi.UserSettings
local grid_opacity = type(u.DebugGridOpacity) == "number" and u.DebugGridOpacity or 15
local grid_size = type(u.DebugGridSize) == "number" and u.DebugGridSize or 25

DefineClass("ModOptions_ChoGGi_ConstructionShowHexBuildableGrid", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = "true",
			editor = "bool",
			id = "Option1",
			name = "Show during construction",
			desc = "Show during construction.",
		},
		{
			default = grid_size,
			editor = "number",
			id = "DebugGridSize",
			max = 100,
			min = 1,
			name = "Grid Size",
		},
		{
			default = grid_opacity,
			editor = "number",
			id = "DebugGridOpacity",
			max = 100,
			min = 0,
			name = "Grid Opacity",
		},
	},
})