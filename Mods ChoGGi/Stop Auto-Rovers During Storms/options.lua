-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_StopAutoRoversDuringStorms", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "NearestLaser",
			name = T(4813, "MDS Laser"),
		},
	},
})