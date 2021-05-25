return PlaceObj("ModDef", {
	"title", "Oxygen Management",
	"id", "ChoGGi_OxygenManagement",
	"steam_id", "2497163542",
	"pops_any_uuid", "d8195d02-e409-442c-8345-914f3931d95f",
	"lua_revision", 1001514, -- Tito
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagGameplay", true,
	"description", [[
A new game is needed (you can use an existing, but you'll need to rebuild buildings).


You cannot build MOXIEs till you research Magnetic Filtering!
MOXIEs now cost an additional 2 polymers to build.
Reduce MOXIE production to 2 oxygen, increase electrical consumption to 10.
Increase algae oxygen production to 2, kelp to 1.
Factories cost an additional 2 oxygen.
Each colonist increases dome oxygen use by 0.035 - 0.1 units (age dependant).


https://forum.paradoxplaza.com/forum/threads/more-oxygen-consuming-buildings-and-facilities-are-needed.1175384/
Requested by YertyL.
]],
})
