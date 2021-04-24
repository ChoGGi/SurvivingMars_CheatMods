return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 8,
		}),
	},
	"title", "Remove Unwanted Colonists",
	"id", "ChoGGi_RemoveUnwantedColonists",
	"steam_id", "1594867237",
	"pops_any_uuid", "fb8fc954-40d2-4818-b84f-157903c4ed36",
	"lua_revision", 1001514, -- Tito
	"version", 13,
	"version_major", 1,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
		"Code/MurderPod.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"TagOther", true,
	"description", [[Adds a button to the colonist selection menu to send them back to Earth.
A pod will come down and hover around the colonist till they make the mistake of going outside.
If you change your mind; you can toggle it before they get sucked up.

Once they go outside it'll suck them up and take them back to Earth (truthfully just outside the atmosphere before spacing them).



Unfortunately frozen bodies don't have any propulsion systems. They'll come back as human shaped meteors (in a few Sols). You wouldn't want to experience the Kessler syndrome around your shiny new planet after all.
On the bright side there won't be much left on impact, so other colonists won't be affected (no hit to applicants).

Mod Options:
Skip Tourists: Never remove tourists.
See mod options to automagically remove colonists of certain traits.

This also adds a buildable monument to idiots, for those colonists less inclined to go outside.]],
})
