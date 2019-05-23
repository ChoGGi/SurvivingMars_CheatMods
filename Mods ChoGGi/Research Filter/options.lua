-- max 40 chars
DefineClass("ModOptions_ChoGGi_ResearchFilter", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "HideCompleted",
			name = "Hide completed tech.",
		},
	},
})