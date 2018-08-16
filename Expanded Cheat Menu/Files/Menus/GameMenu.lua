-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920001292--[[List All Objects--]]],
  ActionId = "Game.List All Objects",
  ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
  RolloverText = S[302535920001293--[[A list of objects; double-click on one to select and move the camera to it.--]]],
  OnAction = ChoGGi.MenuFuncs.XXListAllObjectsXXXXXXX,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000864--[[Delete All Rocks--]]],
  ActionId = "Game.Delete All Rocks",
  ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
  RolloverText = S[302535920001238--[[Removes most rocks for that smooth map feel (will take about 30 seconds).--]]],
  OnAction = ChoGGi.MenuFuncs.DeleteAllRocks,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000674--[[Terrain Editor Toggle--]]],
  ActionId = "Game.Terrain Editor Toggle",
  ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
  RolloverText = S[302535920000675--[[Opens up the map editor with the brush tool visible.--]]],
  OnAction = ChoGGi.MenuFuncs.TerrainEditor_Toggle,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.TerrainEditor_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000485--[[Terrain Flatten Toggle--]]],
  ActionId = "Game.Terrain Flatten Toggle",
  ActionIcon = "CommonAssets/UI/Menu/FixUnderwaterEdges.tga",
  RolloverText = S[302535920000486--[[Use the shortcut to turn this on as it will use where your cursor is as the height to flatten to.

Use Shift + Arrow keys to change the height/radius.--]]],
  OnAction = ChoGGi.MenuFuncs.FlattenTerrain_Toggle,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.FlattenTerrain_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000493--[[Change Map--]]],
  ActionId = "Game.Change Map",
  ActionIcon = "CommonAssets/UI/Menu/load_city.tga",
  RolloverText = S[302535920000494--[[Change map (options to pick commander, sponsor, etc...

Attention: If you get yellow ground areas; just load it again.
The map disaster settings don't do jack (use ECM>Mission>Disasters).--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeMap,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000265--[[Pulsating Pins--]]],
  ActionId = "Game.Pulsating Pins",
  ActionIcon = "CommonAssets/UI/Menu/JoinGame.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DisablePulsatingPinsMotion,
      302535920000335--[[Pins will no longer do the pulsating motion (hover over to stop).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.PulsatingPins_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000623--[[Change Terrain Type--]]],
  ActionId = "Game.Change Terrain Type",
  ActionIcon = "CommonAssets/UI/Menu/prefabs.tga",
  RolloverText = S[302535920000624--[[Green or Icy mars? Coming right up!
(don't forget a light model)--]]],
  OnAction = ChoGGi.MenuFuncs.ChangeTerrainType,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000625--[[Change Light Model--]]],
  ActionId = "Game.Change Light Model",
  ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.Lightmodel,
      302535920000626--[[Changes the lighting mode (temporary or permanent).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.ChangeLightmodel,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000627--[[Change Light Model Custom--]]],
  ActionId = "Game.Change Light Model Custom",
  ActionIcon = "CommonAssets/UI/Menu/light_model.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.LightmodelCustom,
      302535920000628--[["Make a custom lightmodel and save it to settings. You still need to use ""Change Light Model"" for permanent."--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.ChangeLightmodelCustom,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000629--[[UI Transparency--]]],
  ActionId = "Game.UI Transparency",
  ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
  RolloverText = S[302535920000630--[[Change the transparency of UI items (info panel, menu, pins).--]]],
  OnAction = ChoGGi.MenuFuncs.SetTransparencyUI,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.SetTransparencyUI,
}

Actions[#Actions+1] = {
  ActionMenubar = S[283142739680--[[Game--]]],
  ActionName = S[302535920000631--[[UI Transparency Mouseover--]]],
  ActionId = "Game.UI Transparency Mouseover",
  ActionIcon = "CommonAssets/UI/Menu/set_last_texture.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.TransparencyToggle,
      302535920000632--[[Toggle removing transparency on mouseover.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.TransparencyUI_Toggle,
}

local str_Game_Render = "Game.Render"
Actions[#Actions+1] = {
  ActionMenubar = "Game",
  ActionName = Concat(S[302535920000845--[[Render--]]]," .."),
  ActionId = str_Game_Render,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "02",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Render,
  ActionName = S[302535920000633--[[Lights Radius--]]],
  ActionId = "Game.Render.Lights Radius",
  ActionIcon = "CommonAssets/UI/Menu/LightArea.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.LightsRadius,
      302535920000634--[[Sets light radius (Menu>Options>Video>Lights), menu options max out at 100.
Lets you see lights from further away/more bleedout?--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetLightsRadius,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Render,
  ActionName = S[302535920000635--[[Terrain Detail--]]],
  ActionId = "Game.Render.Terrain Detail",
  ActionIcon = "CommonAssets/UI/Menu/selslope.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.TerrainDetail,
      302535920000636--[[Sets hr.TR_MaxChunks (Menu>Options>Video>Terrain), menu options max out at 200.
Makes the background terrain more detailed (make sure to also stick Terrain on Ultra in the options menu).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetTerrainDetail,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Render,
  ActionName = S[302535920000637--[[Video Memory--]]],
  ActionId = "Game.Render.Video Memory",
  ActionIcon = "CommonAssets/UI/Menu/CountPointLights.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.VideoMemory,
      302535920000638--[[Sets hr.DTM_VideoMemory (Menu>Options>Video>Textures), menu options max out at 2048.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetVideoMemory,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Render,
  ActionName = S[302535920000639--[[Shadow Map--]]],
  ActionId = "Game.Render.Shadow Map",
  ActionIcon = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.ShadowmapSize,
      302535920000640--[[Sets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetShadowmapSize,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Render,
  ActionName = S[302535920000641--[[Disable Texture Compression--]]],
  ActionId = "Game.Render.Disable Texture Compression",
  ActionIcon = "CommonAssets/UI/Menu/ExportImageSequence.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.DisableTextureCompression,
      302535920000642--[[Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram).--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.DisableTextureCompression_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Render,
  ActionName = S[302535920000643--[[Higher Render Distance--]]],
  ActionId = "Game.Render.Higher Render Distance",
  ActionIcon = "CommonAssets/UI/Menu/CameraEditor.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.HigherRenderDist,
      302535920000644--[[Renders model from further away.
Not noticeable unless using higher zoom.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.HigherRenderDist_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Render,
  ActionName = S[302535920000645--[[Higher Shadow Distance--]]],
  ActionId = "Game.Render.Higher Shadow Distance",
  ActionIcon = "CommonAssets/UI/Menu/toggle_post.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.HigherShadowDist,
      302535920000646--[[Renders shadows from further away.
Not noticeable unless using higher zoom.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.HigherShadowDist_Toggle,
}

local str_Game_Camera = "Game.Camera"
Actions[#Actions+1] = {
  ActionMenubar = "Game",
  ActionName = Concat(S[302535920001058--[[Camera--]]]," .."),
  ActionId = str_Game_Camera,
  ActionIcon = "CommonAssets/UI/Menu/folder.tga",
  OnActionEffect = "popup",
  ActionSortKey = "01",
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Camera,
  ActionName = S[302535920000647--[[Border Scrolling--]]],
  ActionId = "Game.Camera.Border Scrolling",
  ActionIcon = "CommonAssets/UI/Menu/CameraToggle.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.BorderScrollingToggle,
      302535920000648--[[Set size of activation for mouse border scrolling.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.SetBorderScrolling,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Camera,
  ActionName = S[302535920000649--[[Zoom Distance--]]],
  ActionId = "Game.Camera.Zoom Distance",
  ActionIcon = "CommonAssets/UI/Menu/MoveUpCamera.tga",
  RolloverText = function()
    return ChoGGi.ComFuncs.SettingState(
      ChoGGi.UserSettings.CameraZoomToggle,
      302535920000650--[[Further zoom distance.--]]
    )
  end,
  OnAction = ChoGGi.MenuFuncs.CameraZoom_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Camera,
  ActionName = S[302535920000651--[[Toggle Free Camera--]]],
  ActionId = "Game.Camera.Toggle Free Camera",
  ActionIcon = "CommonAssets/UI/Menu/NewCamera.tga",
  RolloverText = S[302535920000652--[[I believe I can fly.--]]],
  OnAction = ChoGGi.MenuFuncs.CameraFree_Toggle,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.CameraFree_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Camera,
  ActionName = S[302535920000653--[[Toggle Follow Camera--]]],
  ActionId = "Game.Camera.Toggle Follow Camera",
  ActionIcon = "CommonAssets/UI/Menu/Shot.tga",
  RolloverText = S[302535920000654--[[Select (or mouse over) an object to follow.--]]],
  OnAction = ChoGGi.MenuFuncs.CameraFollow_Toggle,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.CameraFollow_Toggle,
}

Actions[#Actions+1] = {
  ActionMenubar = str_Game_Camera,
  ActionName = S[302535920000655--[[Toggle Cursor--]]],
  ActionId = "Game.Camera.Toggle Cursor",
  ActionIcon = "CommonAssets/UI/Menu/select_objects.tga",
  RolloverText = S[302535920000656--[[Toggle between moving camera and selecting objects.--]]],
  OnAction = ChoGGi.MenuFuncs.CursorVisible_Toggle,
  ActionShortcut = ChoGGi.UserSettings.KeyBindings.CursorVisible_Toggle,
}
