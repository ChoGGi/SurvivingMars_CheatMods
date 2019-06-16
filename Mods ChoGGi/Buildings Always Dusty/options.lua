-- max 40 chars
DefineClass("ModOptions_ChoGGi_BuildingsAlwaysDusty", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "AlwaysDusty",
			name = T(302535920011125, "Always Dusty"),
		},
		{
			default = false,
			editor = "bool",
			id = "AlwaysClean",
			name = T(302535920011126, "Always Clean"),
		},
	},
})