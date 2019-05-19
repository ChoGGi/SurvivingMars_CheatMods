-- max 40 chars
DefineClass("ModOptions_ChoGGi_ResearchSmallCheckMarks", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "ChangePercent",
			name = "Shrink percent counters.",
		},
	},
})