-- max 40 chars
DefineClass("ModOptions_ChoGGi_AutoEmptyWasteStorage", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "EmptyDumpSites",
			name = T(302535920011392, "Empty Dump Sites"),
		},
		{
			default = true,
			editor = "bool",
			id = "EmptyNewSol",
			name = T(302535920011393, "Empty Each Sol"),
		},
		{
			default = false,
			editor = "bool",
			id = "EmptyNewHour",
			name = T(302535920011394, "Empty Each Hour"),
		},
	},
})