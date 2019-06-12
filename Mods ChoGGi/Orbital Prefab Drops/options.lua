DefineClass("ModOptions_ChoGGi_OrbitalPrefabDrops", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 1,
			editor = "number",
			id = "ModelType",
			max = 4,
			min = 1,
			name = "Model Type",
			desc = "1 = supply pod, 2 = old black hex, 3 = arc pod, 4 = drop pod (3/4 Space Race DLC).",
		},
		{
			default = true,
			editor = "bool",
			id = "PrefabOnly",
			name = "Prefab Only",
			desc = "Only rocket drop prefabs (or all buildings depending on Inside/Outside Buildings).",
		},
		{
			default = true,
			editor = "bool",
			id = "Outside",
			name = "Outside Buildings",
			desc = "If you don't want them being dropped off outside domes.",
		},
		{
			default = false,
			editor = "bool",
			id = "Inside",
			name = "Inside Buildings",
			desc = "If you don't want them being dropped off inside domes.",
		},
		{
			default = true,
			editor = "bool",
			id = "DomeCrack",
			name = "Dome Crack",
			desc = "If the site is in a dome, it'll crack the glass.",
		},
	},
})
