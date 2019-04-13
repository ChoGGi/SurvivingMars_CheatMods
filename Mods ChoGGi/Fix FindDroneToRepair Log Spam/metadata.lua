return PlaceObj("ModDef", {
	"title", "Fix: FindDroneToRepair Log Spam",
	"version_major", 0,
	"version_minor", 1,
	"saved", 1543320000,
	"image", "Preview.png",
	"id", "ChoGGi_FixFindDroneToRepairLogSpam",
	"steam_id", "1576382631",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[This seems to be an issue from flying drones and a drone hub being destroyed.

Your log will "fill" up with these errors:
[LUA ERROR] HGE::l_HexAxialDistance:
Mars/Lua/Units/Drone.lua(256): method FindDroneToRepair
Mars/Lua/Units/Drone.lua(548): field Idle
Mars/Dlc/gagarin/Code/FlyingDrone.lua(312):  <>
[C](-1): global sprocall
(116):  <>
        --- end of stack
[LUA ERROR] Mars/Lua/Units/Drone.lua:257: attempt to compare nil with number
Mars/Lua/Units/Drone.lua(548): field Idle
Mars/Dlc/gagarin/Code/FlyingDrone.lua(312):  <>
[C](-1): global sprocall
(116):  <>
        --- end of stack

Thanks to veryinky for that entertaining log.]],
})
