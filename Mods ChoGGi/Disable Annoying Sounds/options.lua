-- See LICENSE for terms

-- max 40 chars
DefineClass("ModOptions_ChoGGi_DisableAnnoyingSounds", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = false,
			editor = "bool",
			id = "SensorSensorTowerBeeping",
			name = T(302535920011379, "Sensor Tower Beeping"),
		},
		{
			default = false,
			editor = "bool",
			id = "RCCommanderDronesDeployed",
			name = T(302535920011380, "RC Commander Drones Deployed"),
		},
		{
			default = false,
			editor = "bool",
			id = "MirrorSphereCrackling",
			name = T(302535920011381, "Mirror Sphere Crackling"),
		},
		{
			default = false,
			editor = "bool",
			id = "NurseryChild",
			name = T(5179, "Nursery") .. " " .. T(4775, "Child"),
		},
		{
			default = false,
			editor = "bool",
			id = "SpacebarMusic",
			name = T(5280, "Spacebar") .. " " .. T(3580, "Music"),
		},
	},
})
