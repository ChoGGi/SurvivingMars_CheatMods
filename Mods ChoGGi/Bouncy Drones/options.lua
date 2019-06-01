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
			name = "Bouncy Drones",
		},
		{
			default = 10,
			max = 100,
			min = 0,
			editor = "number",
			id = "GravityRC",
			name = "Gravity RC",
		},
		{
			default = 25,
			max = 100,
			min = 0,
			editor = "number",
			id = "GravityColonist",
			name = "Gravity Colonist",
		},
	},
})
