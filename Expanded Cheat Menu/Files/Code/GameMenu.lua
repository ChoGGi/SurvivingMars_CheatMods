--See LICENSE for terms

local icon = "new_city.tga"

function ChoGGi.MsgFuncs.GameMenu_LoadingScreenPreClose()

  ChoGGi.ComFuncs.AddAction(
    "Game/" .. ChoGGi.ComFuncs.Trans(302535920000623,"Change Terrain Type"),
    ChoGGi.MenuFuncs.ChangeTerrainType,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000624,"Green or Icy mars? Coming right up!\n(don't forget a light model)"),
    "prefabs.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/" .. ChoGGi.ComFuncs.Trans(302535920000625,"Change Light Model"),
    ChoGGi.MenuFuncs.ChangeLightmodel,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000626,"Changes the lighting mode (temporary or permanent)."),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/" .. ChoGGi.ComFuncs.Trans(302535920000627,"Change Light Model Custom"),
    ChoGGi.MenuFuncs.ChangeLightmodelCustom,
    nil,
    ChoGGi.ComFuncs.Trans(302535920000628,"Make a custom lightmodel and save it to settings. You still need to use \"Change Light Model\" for permanent."),
    "light_model.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/" .. ChoGGi.ComFuncs.Trans(302535920000629,"Set UI Transparency"),
    ChoGGi.MenuFuncs.SetTransparencyUI,
    "Ctrl-F3",
    ChoGGi.ComFuncs.Trans(302535920000630,"Change the transparency of UI items (info panel, menu, pins)."),
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/" .. ChoGGi.ComFuncs.Trans(302535920000631,"Set UI Transparency Mouseover"),
    ChoGGi.MenuFuncs.TransparencyUI_Toggle,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.TransparencyToggle)
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000632,"Toggle removing transparency on mouseover.")
    end,
    "set_last_texture.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/" .. ChoGGi.ComFuncs.Trans(302535920000633,"Lights Radius"),
    ChoGGi.MenuFuncs.SetLightsRadius,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.LightsRadius)
      return des .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000634,"Sets light radius (Menu>Options>Video>Lights), menu options max out at 100.\nLets you see lights from further away/more bleedout?")
    end,
    "LightArea.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/" .. ChoGGi.ComFuncs.Trans(302535920000635,"Terrain Detail"),
    ChoGGi.MenuFuncs.SetTerrainDetail,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.TerrainDetail)
      return des .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000636,"Sets hr.TR_MaxChunks (Menu>Options>Video>Terrain), menu options max out at 200.\nMakes the background terrain more detailed (make sure to also stick Terrain on Ultra in the options menu).")
    end,
    "selslope.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/" .. ChoGGi.ComFuncs.Trans(302535920000637,"Video Memory"),
    ChoGGi.MenuFuncs.SetVideoMemory,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.VideoMemory)
      return des .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000638,"Sets hr.DTM_VideoMemory (Menu>Options>Video>Textures), menu options max out at 2048.")
    end,
    "CountPointLights.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/" .. ChoGGi.ComFuncs.Trans(302535920000639,"Shadow Map"),
    ChoGGi.MenuFuncs.SetShadowmapSize,
    nil,
    function()
      local des = "Current: " .. tostring(ChoGGi.UserSettings.ShadowmapSize)
      return des .. "\n" .. ChoGGi.ComFuncs.Trans(302535920000640,"Sets the shadow map size (Menu>Options>Video>Shadows), menu options max out at 4096.")
    end,
    "DisableEyeSpec.tga"
  )

  --------------------
  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/" .. ChoGGi.ComFuncs.Trans(302535920000641,"Disable Texture Compression"),
    ChoGGi.MenuFuncs.DisableTextureCompression_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.DisableTextureCompression and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000642,"Toggle texture compression (game defaults to on, seems to make a difference of 600MB vram).")
    end,
    "ExportImageSequence.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/" .. ChoGGi.ComFuncs.Trans(302535920000643,"Higher Render Distance"),
    ChoGGi.MenuFuncs.HigherRenderDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherRenderDist and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000644,"Renders model from further away.\nNot noticeable unless using higher zoom.")
    end,
    "CameraEditor.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[2]Render/" .. ChoGGi.ComFuncs.Trans(302535920000645,"Higher Shadow Distance"),
    ChoGGi.MenuFuncs.HigherShadowDist_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.HigherShadowDist and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000646,"Renders shadows from further away.\nNot noticeable unless using higher zoom.")
    end,
    "toggle_post.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/" .. ChoGGi.ComFuncs.Trans(302535920000647,"Border Scrolling"),
    ChoGGi.MenuFuncs.SetBorderScrolling,
    nil,
    function()
      local des = ChoGGi.UserSettings.BorderScrollingToggle and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000648,"Set size of activation for mouse border scrolling.")
    end,
    "CameraToggle.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/" .. ChoGGi.ComFuncs.Trans(302535920000649,"Zoom Distance"),
    ChoGGi.MenuFuncs.CameraZoom_Toggle,
    nil,
    function()
      local des = ChoGGi.UserSettings.CameraZoomToggle and "(" .. ChoGGi.ComFuncs.Trans(302535920000030,"Enabled") .. ")" or "(" .. ChoGGi.ComFuncs.Trans(302535920000036,"Disabled") .. ")"
      return des .. " " .. ChoGGi.ComFuncs.Trans(302535920000650,"Further zoom distance.")
    end,
    "MoveUpCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/" .. ChoGGi.ComFuncs.Trans(302535920000651,"Toggle Free Camera"),
    ChoGGi.MenuFuncs.CameraFree_Toggle,
    "Shift-C",
    ChoGGi.ComFuncs.Trans(302535920000652,"I believe I can fly."),
    "NewCamera.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/" .. ChoGGi.ComFuncs.Trans(302535920000653,"Toggle Follow Camera"),
    ChoGGi.MenuFuncs.CameraFollow_Toggle,
    "Ctrl-Shift-F",
    ChoGGi.ComFuncs.Trans(302535920000654,"Select (or mouse over) an object to follow."),
    "Shot.tga"
  )

  ChoGGi.ComFuncs.AddAction(
    "Game/[1]Camera/" .. ChoGGi.ComFuncs.Trans(302535920000655,"Toggle Cursor"),
    ChoGGi.MenuFuncs.CursorVisible_Toggle,
    "Ctrl-Alt-F",
    ChoGGi.ComFuncs.Trans(302535920000656,"Toggle between moving camera and selecting objects."),
    "select_objects.tga"
  )

end
