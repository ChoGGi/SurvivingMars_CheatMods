-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_DisableMouse", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EnableMod",
			name = T(754117323318, "Enable") .. " " .. T(12360, "Mod"),
		},
	},
})