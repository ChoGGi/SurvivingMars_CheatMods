-- max 40 chars
DefineClass("ModOptions_ChoGGi_HangingGardensChildrenAllowed", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "PlaygroundPerk",
			name = T(4755, "Chance to get a Perk"),
		},
	},
})