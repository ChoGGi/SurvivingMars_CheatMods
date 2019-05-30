-- max 40 chars
DefineClass("ModOptions_ChoGGi_GameRulesBreakthroughs", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "BreakthroughsResearched",
			name = "Breakthroughs Researched",
		},
	},
})