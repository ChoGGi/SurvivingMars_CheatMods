return PlaceObj("ModDef", {
	"title", "Fix: Transports Don't Move After Route Set v0.1",
	"version", 1,
	"saved", 1540641600,
	"image", "Preview.png",
	"id", "ChoGGi_FixTransportsDontMoveAfterRouteSet",
	"steam_id", "1549495547",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[If you set a transport route between two resources/stockpiles/etc and the transport just sits there like an idiot...

Fixes this error in log:
[LUA ERROR] Mars/Lua/Units/RCTransport.lua:1018: attempt to index a boolean value (field 'unreachable_objects')]],
})
