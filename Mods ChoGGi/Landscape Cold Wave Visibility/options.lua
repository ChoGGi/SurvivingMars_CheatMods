-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_LandscapeColdWaveVisibility", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 5,
			max = 25,
			min = 1,
			editor = "number",
			id = "SpaceCount",
			name = T(1000452, "Space") .. " " .. T(3732, "Count"),
		},
	},
})