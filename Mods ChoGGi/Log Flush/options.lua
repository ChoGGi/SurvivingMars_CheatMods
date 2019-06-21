-- max 40 chars
DefineClass("ModOptions_ChoGGi_LogFlush", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "NewMinute",
			name = T(302535920011346, "Each Minute"),
		},
		{
			default = false,
			editor = "bool",
			id = "NewHour",
			name = T(302535920011347, "Each Hour"),
		},
		{
			default = true,
			editor = "bool",
			id = "NewDay",
			name = T(302535920011348, "Each Sol"),
		},
	},
})
