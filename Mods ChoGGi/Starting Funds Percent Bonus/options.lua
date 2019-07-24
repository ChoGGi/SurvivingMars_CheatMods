-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_StartingFundsPercentBonus", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 0,
			max = 250,
			min = 0,
			editor = "number",
			id = "FundingPercent",
			name = T(3613, "Funding") .. " " .. T(1000099, "Percent"),
		},
	},
})

