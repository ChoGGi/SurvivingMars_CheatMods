--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.ResourcesMenu_LoadingScreenPreClose()
  --ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon)

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Resources/" .. ChoGGi.ComFuncs.Trans(302535920000719,"Add Orbital Probes"),
    ChoGGi.MenuFuncs.AddOrbitalProbes,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000720,"Add more probes."),
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Resources/" .. ChoGGi.ComFuncs.Trans(302535920000721,"Food Per Rocket Passenger"),
    ChoGGi.MenuFuncs.SetFoodPerRocketPassenger,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000722,"Change the amount of Food supplied with each Colonist arrival."),
    "ToggleTerrainHeight.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Resources/" .. ChoGGi.ComFuncs.Trans(302535920000723,"Add Prefabs"),
    ChoGGi.MenuFuncs.AddPrefabs,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000724,"Adds prefabs."),
    "gear.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Resources/" .. ChoGGi.ComFuncs.Trans(302535920000725,"Add Funding"),
    ChoGGi.MenuFuncs.SetFunding,
    "Ctrl-Shift-0",
    ChoGGi.ComFuncs.Trans(302535920000726,"Add more funding (or reset back to 500 M)."),
    "pirate.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Expanded CM/Resources/" .. ChoGGi.ComFuncs.Trans(302535920000727,"Fill Selected Resource"),
    ChoGGi.MenuFuncs.FillResource,
    "Ctrl-F",
    ChoGGi.ComFuncs.Trans(302535920000728,"Fill the selected/moused over object's resource(s)"),
    "Cube.tga"
  )
end
