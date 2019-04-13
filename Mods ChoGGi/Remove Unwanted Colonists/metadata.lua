return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Remove Unwanted Colonists v0.3",
	"version_major", 0,
	"version_minor", 3,
	"saved", 1551355200,
	"image", "Preview.png",
	"id", "ChoGGi_RemoveUnwantedColonists",
	"steam_id", "1594867237",
	"pops_desktop_uuid", "9f2beb20-8ac6-4201-af9b-366308bd65fb",
	"pops_any_uuid", "fb8fc954-40d2-4818-b84f-157903c4ed36",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
		"Code/MurderPod.lua",
		"Code/IdiotMonument.lua",
	},
	"description", [[Adds a button to the colonist selection menu to send them back to Earth.
A pod will come down and hover around the colonist till they make the mistake of going outside.
If you change your mind; you can toggle it before they get sucked up.

Once they go outside it'll suck them up and take them back to Earth (truthfully just outside the atmosphere before spacing them).



Unfortunately frozen bodies don't have any propulsion systems. They'll come back as human shaped meteors (in a few Sols). You wouldn't want to experience the Kessler syndrome around your shiny new planet after all.
On the bright side there won't be much left on impact, so other colonists won't be affected.



This also adds a buildable monument to idiots, for those colonists less inclined to go outside.]],
})
