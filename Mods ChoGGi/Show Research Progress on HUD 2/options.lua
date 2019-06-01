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
			name = "Show Number in Queue",
		},
		{
			default = false,
			editor = "bool",
			id = "HideWhenEmpty",
			name = "Hide When Queue is Empty",
		},
	},
})