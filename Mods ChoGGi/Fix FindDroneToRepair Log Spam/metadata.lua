return PlaceObj("ModDef", {
	"title", "Fix FindDroneToRepair Log Spam",
	"id", "ChoGGi_FixFindDroneToRepairLogSpam",
	"steam_id", "1576382631",
	"pops_any_uuid", "d8a6fb94-bc0b-4ad5-9aea-083ca8f51a93",
	"image", "Preview.png",
	"author", "ChoGGi",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"lua_revision", 1001551,
	"code", {
		"Code/Script.lua",
	},
	"TagOther", true,
	"has_options", true,
	"description", [[This seems to be an issue from flying drones and a drone hub being destroyed.

Your log will "fill" up with these errors:
[LUA ERROR] HGE::l_HexAxialDistance:
Mars/Lua/Units/Drone.lua(256): method FindDroneToRepair
Mars/Lua/Units/Drone.lua(548): field Idle
Mars/Dlc/gagarin/Code/FlyingDrone.lua(312):	<>
[C](-1): global sprocall
(116):	<>
				--- end of stack
[LUA ERROR] Mars/Lua/Units/Drone.lua:257: attempt to compare nil with number
Mars/Lua/Units/Drone.lua(548): field Idle
Mars/Dlc/gagarin/Code/FlyingDrone.lua(312):	<>
[C](-1): global sprocall
(116):	<>
				--- end of stack

Thanks to veryinky for that entertaining log.

Includes mod option to disable fix.
]],
})
