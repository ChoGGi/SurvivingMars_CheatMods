DefineClass("ModOptions_ChoGGi_SaveRocketCargo", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "ClearOnLaunch",
			name = "Clear On Launch",
			desc = "Clear cargo for rocket/pod/elevator when launched (not all cargo, just for the same type).",
		},
	},
})
