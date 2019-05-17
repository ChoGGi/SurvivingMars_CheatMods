DefineClass("ModOptions_ChoGGi_DisableSelectionPanelSizing", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Enabled",
			name = "Disable Panel Sizing",
			desc = "If you want to re-enable the auto-sizing.",
		},
		{
			default = false,
			editor = "bool",
			id = "ScrollSelection",
			name = "Scroll Sections",
			desc = "Adds scrollbars to certain panels (buggy, has flickering).",
		},
	},
})
