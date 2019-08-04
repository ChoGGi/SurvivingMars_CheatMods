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
			name = T(302535920011467, "Shrink Percent Counters"),
		},
		{
			default = false,
			editor = "bool",
			id = "HideBackground",
			name = T(302535920011468, "Hide Blue Background"),
		},
	},
})