-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_RenegadeProgress", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "DisableRenegades",
			name = T(12228, "Disable") .. " " .. T(7031, "Renegades"),
		},
	},
})