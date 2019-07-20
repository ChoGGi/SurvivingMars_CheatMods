-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_DelaySelectionArrows", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "DisableSelect",
			name = T(12228, "Disable") .. " " .. T(131775917427, "Select"),
		},
	},
})