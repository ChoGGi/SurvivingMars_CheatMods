-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_TradePadAllResources", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EnableWasteRock",
			name = T(4518, "Waste Rock"),
		},
	},
})