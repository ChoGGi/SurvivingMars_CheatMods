DefineClass("ModOptions_XXXXXXXXXXXX", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = "true",
			editor = "bool",
			id = "ToggleExample",
			name = T(0, "toggle boolean"),
		},
		{
			default = 15,
			editor = "number",
			id = "NumberExample",
			max = 25,
			min = 1,
			name = T(0, "number slider"),
			slider = true,
		},
		{
			default = "second",
			editor = "choice",
			id = "ChoiceExample",
			items = {
				{
					text = T("first"),
					value = "first",
				},
				{
					text = T("second"),
					value = "second",
				},
				{
					text = T("third"),
					value = "third",
				},
			},
			name = T(0, "list of choices"),
		},
	},
})