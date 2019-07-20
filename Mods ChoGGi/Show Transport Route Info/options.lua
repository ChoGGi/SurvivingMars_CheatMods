-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_ShowTransportRouteInfo", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EnableIcon",
			name = T(754117323318, "Enable") .. " " .. T(94, "Icon"),
		},
		{
			default = true,
			editor = "bool",
			id = "EnableText",
			name = T(754117323318, "Enable") .. " " .. T(1000145, "Text"),
		},
	},
})