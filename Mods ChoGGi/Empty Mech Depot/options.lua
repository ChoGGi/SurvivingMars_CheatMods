-- max 40 chars
DefineClass("ModOptions_ChoGGi_EmptyMechDepot", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "SkipDelete",
			name = T(9428, "Skip") .. " " .. T(12071, "Delete"),
		},
	},
})