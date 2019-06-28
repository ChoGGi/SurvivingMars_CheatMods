-- max 40 chars
DefineClass("ModOptions_ChoGGi_EnableConsole", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EnableLog",
			name = T(302535920011357, "Enable Console Log"),
		},
		{
			default = true,
			editor = "bool",
			id = "EnableConsole",
			name = T(302535920011356, "Enable Console"),
		},
	},
})