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
			name = "Empty Dump Sites",
		},
		{
			default = true,
			editor = "bool",
			id = "EmptyNewSol",
			name = "Empty Each Sol",
		},
		{
			default = false,
			editor = "bool",
			id = "EmptyNewHour",
			name = "Empty Each Hour",
		},
	},
})