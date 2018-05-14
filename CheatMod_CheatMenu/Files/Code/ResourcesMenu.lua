local cMenuFuncs = ChoGGi.MenuFuncs
local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables

function ChoGGi.MsgFuncs.ResourcesMenu_LoadingScreenPreClose()
  --cComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  cComFuncs.AddAction(
    "Expanded CM/Resources/Add Orbital Probes",
    cMenuFuncs.AddOrbitalProbes,
    nil,
    "Add more probes.",
    "ToggleTerrainHeight.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Resources/Food Per Rocket Passenger",
    cMenuFuncs.SetFoodPerRocketPassenger,
    nil,
    "Change the amount of Food supplied with each Colonist arrival.",
    "ToggleTerrainHeight.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Resources/Add Prefabs",
    cMenuFuncs.AddPrefabs,
    nil,
    "Adds prefabs.",
    "gear.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Resources/Add Funding",
    cMenuFuncs.SetFunding,
    "Ctrl-Shift-0",
    "Add more funding (or reset back to 500 M).",
    "pirate.tga"
  )

  cComFuncs.AddAction(
    "Expanded CM/Resources/Fill Selected Resource",
    cMenuFuncs.FillResource,
    "Ctrl-F",
    "Fill the selected/moused over object's resource(s)",
    "Cube.tga"
  )
end
