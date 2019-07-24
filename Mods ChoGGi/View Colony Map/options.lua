-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_ViewColonyMap", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EnableChallenges",
			name = T(754117323318, "Enable") .. " " .. T(10880, "CHALLENGES"),
		},
	},
})