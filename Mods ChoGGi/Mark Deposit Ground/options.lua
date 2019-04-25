DefineClass("ModOptions_ChoGGi_MarkDepositGround", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = "false",
			editor = "bool",
			id = "HideSigns",
			name = [[Hide signs (pressing "I" will not toggle them)]],
			desc = [[Hide signs on the map.]],
		},
		{
			default = "false",
			editor = "bool",
			id = "AlienAnomaly",
			name = "Alien Signs",
			desc = [[Change anomaly signs to aliens.]],
		},
		{
			default = "false",
			editor = "bool",
			id = "ShowConstruct",
			name = "Construction Signs",
			desc = [[Signs are visible during construction.]],
		},
	},
})