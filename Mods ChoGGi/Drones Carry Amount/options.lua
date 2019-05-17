DefineClass("ModOptions_ChoGGi_DronesCarryAmountFix", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "UseCarryAmount",
			name = T(0, "Use Carry Amount"),
		},
		{
			default = 5,
			editor = "number",
			id = "CarryAmount",
			max = 250,
			min = 1,
			name = T(0, "Carry Amount"),
		},
	},
})