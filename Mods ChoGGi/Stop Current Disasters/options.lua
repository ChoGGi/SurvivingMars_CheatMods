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
			name = T(302535920011303, "Enable Mod"),
		},
	},
})