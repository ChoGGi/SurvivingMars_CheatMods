-- max 40 chars
DefineClass("ModOptions_ChoGGi_LakesToggleVisibility", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "EnableLakes",
			name = "Enable Lakes",
		},
		{
			default = false,
			editor = "bool",
			id = "EnableGridView",
			name = "Enable Grid View",
		},
	},
})