DefineClass("ModOptions_ChoGGi_PatientTransportRoute", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 1,
			max = 45,
			min = 1,
			editor = "number",
			id = "Amount",
			name = "Amount to wait before delivery",
		},
	},
})
