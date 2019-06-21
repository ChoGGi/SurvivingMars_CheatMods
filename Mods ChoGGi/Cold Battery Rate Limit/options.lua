-- max 40 chars
DefineClass("ModOptions_ChoGGi_ColdBatteryRateLimit", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "ColdCapacity",
			name = T(109035890389, "Capacity"),
		},
	},
})