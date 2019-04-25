DefineClass("ModOptions_ChoGGi_LockResidence", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = "false",
			editor = "bool",
			id = "NeverChange",
			name = "Never Change",
			desc = "Residents will never change residence (may cause issues).",
		},
	},
})
