-- max 40 chars
DefineClass("ModOptions_ChoGGi_BouncyDrones", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 2,
			max = 100,
			min = 0,
			editor = "number",
			id = "Gravity",
			name = T(302535920011395, "Bouncy Drones"),
		},
		{
			default = 10,
			max = 100,
			min = 0,
			editor = "number",
			id = "GravityRC",
			name = T(302535920011396, "Gravity RC"),
		},
		{
			default = 25,
			max = 100,
			min = 0,
			editor = "number",
			id = "GravityColonist",
			name = T(302535920011397, "Gravity Colonist"),
		},
	},
})
