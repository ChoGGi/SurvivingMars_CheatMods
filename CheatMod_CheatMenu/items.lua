return {
PlaceObj('ModItemCode', {
	'name', "CheatMod_CheatMenu",
	'FileName', "Init.lua"
}),

PlaceObj("ModItemBuildingTemplate", {
  "name",  "RCDesireTransportBuilding",
  "template_class",  "RCDesireTransportBuilding",
  "construction_cost_Metals",  20000,
  "construction_cost_Electronics",  10000,
  "dome_forbidden",  true,
  "display_name",  "RC Desire Transport",
  "display_name_pl","RC Desire Transport",
  "description",  T({    4461,    "Remote-controlled vehicle that transports resources. Use it to establish permanent supply routes or to gather resources from surface deposits."  }),
  "build_category",  "Infrastructure",
  "display_icon",  "UI/Icons/Buildings/rover_transport.tga",
  "build_pos",  2,
  "entity",  "RoverTransportBuilding",
  "encyclopedia_exclude",  true,
  "on_off_button",  false,
  "prio_button",  false,
  "palettes",  "RCTransport"
}),

}
