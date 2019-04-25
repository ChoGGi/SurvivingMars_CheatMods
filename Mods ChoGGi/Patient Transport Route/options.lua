DefineClass("ModOptions_ChoGGi_PatientTransportRoute", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 1,
			editor = "number",
			id = "Amount",
			max = 45,
			min = 1,
			name = "Amount to wait before delivery",
		},
	},
})
