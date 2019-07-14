-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EnableMod",
			name = T(754117323318, "Enable") .. " " .. T(12360, "Mod"),
		},
		{
			default = 15,
			max = 25,
			min = 1,
			editor = "number",
			id = "NumberExample",
			name = T(302535920011000, "number slider"),
		},
		{
			default = "second",
			editor = "choice",
			id = "ChoiceExample",
			items = {
				{
					text = T(302535920011000, "first"),
					value = "first",
				},
				{
					text = T(302535920011000, "second"),
					value = "second",
				},
				{
					text = T(302535920011000, "third"),
					value = "third",
				},
			},
			name = T(302535920011000, "list of choices"),
		},
	},
})