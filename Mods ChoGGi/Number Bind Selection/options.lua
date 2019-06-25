-- max 40 chars
DefineClass("ModOptions_ChoGGi_NumberBindSelection", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "SelectView",
			name = T(302535920011342, "Select & View"),
		},
		{
			default = false,
			editor = "bool",
			id = "ShowCentre",
			name = T(302535920011352, "Show a marker when View option enabled"),
		},
	},
})