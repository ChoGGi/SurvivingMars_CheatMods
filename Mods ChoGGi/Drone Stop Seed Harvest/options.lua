-- max 40 chars
DefineClass("ModOptions_ChoGGi_DroneStopSeedHarvest", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "StopHarvest",
			name = "Stop Harvest",
		},
	},
})