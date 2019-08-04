DefineClass("ModOptions_ChoGGi_MarkDepositGround", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "HideSigns",
			name = T(302535920011430, [[Hide signs (pressing "I" will not toggle them)]]),
--~ 			desc = [[Hide signs on the map.]],
		},
		{
			default = false,
			editor = "bool",
			id = "AlienAnomaly",
			name = T(302535920011431, "Alien Signs"),
--~ 			desc = [[Change anomaly signs to aliens.]],
		},
		{
			default = false,
			editor = "bool",
			id = "ShowConstruct",
			name = T(302535920011432, "Construction Signs"),
--~ 			desc = [[Signs are visible during construction.]],
		},
	},
})