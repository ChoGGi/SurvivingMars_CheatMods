DefineClass("ModOptions_ChoGGi_AdjustLandscapingSize", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 5,
			editor = "number",
			id = "StepSize",
			max = 100,
			min = 1,
			name = "Step Size",
		},
		{
			default = true,
			editor = "bool",
			id = "RemoveLandScapingLimits",
			name = "Remove Landscaping Limits",
		},
	},
})