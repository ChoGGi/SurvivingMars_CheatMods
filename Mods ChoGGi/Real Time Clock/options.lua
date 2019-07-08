-- max 40 chars
DefineClass("ModOptions_ChoGGi_RealTimeClock", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "ShowClock",
			name = T(302535920011359, "Show Clock"),
		},
		{
			default = true,
			editor = "bool",
			id = "TimeFormat",
			name = T(302535920011361, "24/12 Display"),
		},
		{
			default = false,
			editor = "bool",
			id = "Background",
			name = T(302535920011363, "Background"),
		},
		{
			default = 1,
			max = 9,
			min = 1,
			editor = "number",
			id = "TextStyle",
			name = T(302535920011362, "Styles"),
		},

--~ 		{
--~ 			default = "Infobar",
--~ 			editor = "choice",
--~ 			id = "PosChoices",
--~ 			items = {
--~ 				{
--~ 					text = T(9764, "Infobar"),
--~ 					value = "Infobar",
--~ 				},
--~ 				{
--~ 					text = T(7582, "Notifications"),
--~ 					value = "Notifications",
--~ 				},
--~ 			},
--~ 			name = T(3747, "Placement pos"),
--~ 		},

	},
})