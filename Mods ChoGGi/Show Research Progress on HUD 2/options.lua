-- max 40 chars
DefineClass("ModOptions_ChoGGi_ShowResearchProgressonHUD2", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "QueueCount",
			name = T(302535920011471, "Show Number in Queue"),
		},
		{
			default = false,
			editor = "bool",
			id = "HideWhenEmpty",
			name = T(302535920011472, "Hide When Queue is Empty"),
		},
	},
})