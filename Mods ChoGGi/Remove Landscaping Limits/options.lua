DefineClass("ModOptions_ChoGGi_AdjustLandscapingSize", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 10,
			max = 100,
			min = 1,
			editor = "number",
			id = "StepSize",
			name = T(302535920011237, "Step Size"),
		},
		{
			default = true,
			editor = "bool",
			id = "RemoveLandScapingLimits",
			name = T(302535920011238, "Remove Landscaping Limits"),
		},
	},
})