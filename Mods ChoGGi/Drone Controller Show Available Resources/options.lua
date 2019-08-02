-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_DroneControllerShowAvailableResources", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 15,
			max = 100,
			min = 1,
			editor = "number",
			id = "TextScale",
			name = T(1000145, "Text") .. " " .. T(1000081, "Scale"),
		},
	},
})
