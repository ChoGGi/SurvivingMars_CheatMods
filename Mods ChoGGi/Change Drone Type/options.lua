DefineClass("ModOptions_ChoGGi_ChangeDroneType", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "Aerodynamics",
			name = T(302535920011064, [[Martian Aerodynamics]]),
--~ 			desc = [[Only show button when Martian Aerodynamics has been researched.]],
		},
		{
			default = false,
			editor = "bool",
			id = "AlwaysWasp",
			name = T(302535920011065, [[Always Wasp Drones]]),
--~ 			desc = [[Override drone type to always wasps.]],
		},
	},
})