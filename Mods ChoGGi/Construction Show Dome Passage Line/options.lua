DefineClass("ModOptions_ChoGGi_ConstructionShowDomePassageLine", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Option1",
			name = T(302535920011067, "Show during construction"),
			desc = "Show during construction.",
		},
		{
			-- removed 5 for the angles passages (may) need
			default = 5,
			max = 20,
			min = 0,
			editor = "number",
			id = "AdjustLineLength",
			name = T(302535920011351, "Adjust Line Length"),
		},
	},
})