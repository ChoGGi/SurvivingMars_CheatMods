return PlaceObj("ModDef", {
	"title", "Fix: Project Morpheus Particle Fell Down",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1543320000,
	"image", "Preview.png",
	"id", "ChoGGi_FixProjectMorpheusParticleFellDown",
	"steam_id", "1576281619",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[This one has been in since release...

On load, and once a day it'll check if the blue growing thing has fallen off any morph towers, and re-attach if any have.]],
})
