--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans
--~ local icon = "new_city.tga"

function ChoGGi.MsgFuncs.GameMenu_ChoGGi_Loaded()

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(302535920000493--[[Change Map--]])),
    ChoGGi.MenuFuncs.ChangeMap,
    nil,
    T(302535920000494--[[Change map (options to pick commander, sponsor, etc...

Attention: If you get yellow ground areas; just load it again.
The map disaster settings don't do jack.--]]),
    "load_city.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(3591--[[Autosave--]])," ",T(302535920001201--[[Interval--]])),
    ChoGGi.MenuFuncs.AutosavePeriod,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(const.AutosavePeriod,
        302535920001206--[[Change how many Sols between autosaving.--]]
      )
    end,
    "save_city.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(302535920000265--[[No More Pulsating Pins--]])),
    ChoGGi.MenuFuncs.PulsatingPins_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisablePulsatingPinsMotion,
        302535920000335--[[Pins will no longer do the pulsating motion (hover over to stop).--]]
      )
    end,
    "JoinGame.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(302535920000623--[[Change Terrain Type--]])),
    ChoGGi.MenuFuncs.ChangeTerrainType,
    nil,
    T(302535920000624--[[Green or Icy mars? Coming right up!
(don't forget a light model)--]]),
    "prefabs.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(302535920000625--[[Change Light Model--]])),
    ChoGGi.MenuFuncs.ChangeLightmodel,
    nil,
    T(302535920000626--[[Changes the lighting mode (temporary or permanent).--]]),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(302535920000627--[[Change Light Model Custom--]])),
    ChoGGi.MenuFuncs.ChangeLightmodelCustom,
    nil,
    T(302535920000628--[[Make a custom lightmodel and save it to settings. You still need to use \"Change Light Model\" for permanent.--]]),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(302535920000629--[[Set UI Transparency--]])),
    ChoGGi.MenuFuncs.SetTransparencyUI,
    ChoGGi.UserSettings.KeyBindings.SetTransparencyUI,
    T(302535920000630--[[Change the transparency of UI items (info panel, menu, pins).--]]),
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/",T(302535920000631--[[Set UI Transparency Mouseover--]])),
    ChoGGi.MenuFuncs.TransparencyUI_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.TransparencyToggle,
        302535920000632--[[Toggle removing transparency on mouseover.--]]
      )
    end,
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[2]",T(302535920000845--[[Render--]]),"/",T(302535920000633--[[Lights Radius--]])),
    ChoGGi.MenuFuncs.SetLightsRadius,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.LightsRadius,
        302535920000634--[[Sets light radius (Menu>Options>Video>Lights), menu options max out at 100.
Lets you see lights from further away/more bleedout?--]]
      )
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[2]",T(302535920000845--[[Render--]]),"/",T(302535920000635--[[Terrain Detail--]])),
    ChoGGi.MenuFuncs.SetTerrainDetail,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.TerrainDetail,
        302535920000636--[[Sets hr.TR_MaxChunks (Menu>Options>Video>Terrain), menu options max out at 200.
Makes the background terrain more detailed (make sure to also stick Terrain on Ultra in the options menu).--]]
      )
    end,
    "selslope.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[2]",T(302535920000845--[[Render--]]),"/",T(302535920000637--[[Video Memory--]])),
    ChoGGi.MenuFuncs.SetVideoMemory,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.VideoMemory,
        302535920000638--[[Sets hr.DTM_VideoMemory (Menu>Options>Video>Textures), menu options max out at 2048.--]]
      )
    end,
    "CountPointLights.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[2]",T(302535920000845--[[Render--]]),"/",T(302535920000639--[[Shadow Map--]])),
    ChoGGi.MenuFuncs.SetShadowmapSize,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShadowmapSize,
        302535920000640--[[Sets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096.--]]
      )
    end,
    "DisableEyeSpec.tga"
  )

  --------------------
  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[2]",T(302535920000845--[[Render--]]),"/",T(302535920000641--[[Disable Texture Compression--]])),
    ChoGGi.MenuFuncs.DisableTextureCompression_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisableTextureCompression,
        302535920000642--[[Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram).--]]
      )
    end,
    "ExportImageSequence.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[2]",T(302535920000845--[[Render--]]),"/",T(302535920000643--[[Higher Render Distance--]])),
    ChoGGi.MenuFuncs.HigherRenderDist_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.HigherRenderDist,
        302535920000644--[[Renders model from further away.
Not noticeable unless using higher zoom.--]]
      )
    end,
    "CameraEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[2]",T(302535920000845--[[Render--]]),"/",T(302535920000645--[[Higher Shadow Distance--]])),
    ChoGGi.MenuFuncs.HigherShadowDist_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.HigherShadowDist,
        302535920000646--[[Renders shadows from further away.
Not noticeable unless using higher zoom.--]]
      )
    end,
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[1]",T(302535920001058--[[Camera--]]),"/",T(302535920000647--[[Border Scrolling--]])),
    ChoGGi.MenuFuncs.SetBorderScrolling,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.BorderScrollingToggle,
        302535920000648--[[Set size of activation for mouse border scrolling.--]]
      )
    end,
    "CameraToggle.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[1]",T(302535920001058--[[Camera--]]),"/",T(302535920000649--[[Zoom Distance--]])),
    ChoGGi.MenuFuncs.CameraZoom_Toggle,
    nil,
    function()
      return ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CameraZoomToggle,
        302535920000650--[[Further zoom distance.--]]
      )
    end,
    "MoveUpCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[1]",T(302535920001058--[[Camera--]]),"/",T(302535920000651--[[Toggle Free Camera--]])),
    ChoGGi.MenuFuncs.CameraFree_Toggle,
    ChoGGi.UserSettings.KeyBindings.CameraFree_Toggle,
    T(302535920000652--[[I believe I can fly.--]]),
    "NewCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[1]",T(302535920001058--[[Camera--]]),"/",T(302535920000653--[[Toggle Follow Camera--]])),
    ChoGGi.MenuFuncs.CameraFollow_Toggle,
    ChoGGi.UserSettings.KeyBindings.CameraFollow_Toggle,
    T(302535920000654--[[Select (or mouse over) an object to follow.--]]),
    "Shot.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    Concat(T(1000435--[[Game--]]),"/[1]",T(302535920001058--[[Camera--]]),"/",T(302535920000655--[[Toggle Cursor--]])),
    ChoGGi.MenuFuncs.CursorVisible_Toggle,
    ChoGGi.UserSettings.KeyBindings.CursorVisible_Toggle,
    T(302535920000656--[[Toggle between moving camera and selecting objects.--]]),
    "select_objects.tga"
  )

end
