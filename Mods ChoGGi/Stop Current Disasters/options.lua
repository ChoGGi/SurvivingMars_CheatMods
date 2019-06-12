-- max 40 chars
DefineClass("ModOptions_ChoGGi_StopCurrentDisasters", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EnableMod",
			name = "Enable Mod",
		},
	},
})