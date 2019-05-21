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
			name = "Enable Console Log",
		},
	},
})