local CMenuFuncs = ChoGGi.MenuFuncs
local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs
local CConsts = ChoGGi.Consts
local CInfoFuncs = ChoGGi.InfoFuncs
local CSettingFuncs = ChoGGi.SettingFuncs
local CTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.ResourcesMenu_LoadingScreenPreClose()
  --CComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  CComFuncs.AddAction(
    "Expanded CM/Resources/Add Orbital Probes",
    CMenuFuncs.AddOrbitalProbes,
    nil,
    "Add more probes.",
    "ToggleTerrainHeight.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Resources/Food Per Rocket Passenger",
    CMenuFuncs.SetFoodPerRocketPassenger,
    nil,
    "Change the amount of Food supplied with each Colonist arrival.",
    "ToggleTerrainHeight.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Resources/Add Prefabs",
    CMenuFuncs.AddPrefabs,
    nil,
    "Adds prefabs.",
    "gear.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Resources/Add Funding",
    CMenuFuncs.SetFunding,
    "Ctrl-Shift-0",
    "Add more funding (or reset back to 500 M).",
    "pirate.tga"
  )

  CComFuncs.AddAction(
    "Expanded CM/Resources/Fill Selected Resource",
    CMenuFuncs.FillResource,
    "Ctrl-F",
    "Fill the selected/moused over object's resource(s)",
    "Cube.tga"
  )
end
