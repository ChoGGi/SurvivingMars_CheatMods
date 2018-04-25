return PlaceObj("ModDef", {
	"title", "Building Placement Orientation",
	"description", "Any object you place will have the same orientation as the last placed object."
    .."\n\nCtrl-Space to activate placement mode with the last placed object."
    .."\n\nCtrl-Shift-Space to activate placement mode with the selected object (or object under mouse).",
	"tags", "Building",
	"id", "ChoGGi_BuildingPlacementOrientation",
	"author", "ChoGGi",
	"version", 3,
	"code", {
		"Script.lua",
	},
})
