--See LICENSE for terms

local UsualIcon = "UI/Icons/Anomaly_Event.tga"

function ChoGGi.MenuFuncs.ChangeTerrainType()
  local ItemList = {}
  local Table = DepositionTypes
  for i = 1, #Table do
    ItemList[#ItemList+1] = {
      text = Table[i]:gsub("_mesh.mtl",""):gsub("Terrain",""),
      value = i,
    }
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      terrain.SetTerrainType({type = value})

      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(904,"Terrain") .. ": " .. choice[1].text,
        ChoGGi.ComFuncs.Trans(904,"Terrain")
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000973,"Change Terrain Texture"),
    hint = ChoGGi.ComFuncs.Trans(302535920000974,"Map default") .. ": " .. mapdata.BaseLayer,
  })
end

--add button to import model
function ChoGGi.MenuFuncs.ChangeLightmodelCustom(Name)
  local ItemList = {}
  local SetLightmodelOverride = SetLightmodelOverride
  local SetLightmodel = SetLightmodel

  --always load defaults, then override with custom settings so list is always full
  local def = Lightmodel:GetProperties()
  for i = 1, #def do
    if def[i].editor ~= "image" and def[i].editor ~= "dropdownlist" and def[i].editor ~= "combo" and type(def[i].value) ~= "userdata" then
      ItemList[#ItemList+1] = {
        text = def[i].editor == "color" and "<color 175 175 255>" .. def[i].id .. "</color>" or def[i].id,
        sort = def[i].id,
        --text = def[i].id,
        value = def[i].default,
        default = def[i].default,
        editor = def[i].editor,
        hint = "" .. (def[i].name or "") .. "\nhelp: " .. (def[i].help or "") .. "\n\ndefault: " .. (tostring(def[i].default) or "") .. " min: " .. (def[i].min or "") .. " max: " .. (def[i].max or "") .. " scale: " .. (def[i].scale or ""),
      }
    end
  end

  --custom settings
  local cus = ChoGGi.Temp.LightmodelCustom
  --or loading style from presets
  if type(Name) == "string" then
    cus = DataInstances.Lightmodel[Name]
  end
  for i = 1, #ItemList do
    if cus[ItemList[i].sort] then
      ItemList[i].value = cus[ItemList[i].sort]
    end
  end

  local CallBackFunc = function(choice)
    local model_table = {}
    for i = 1, #choice do
      local value = choice[i].value
      if value ~= choice[i].default then
        model_table[#model_table+1] = {
          id = choice[i].sort,
          value = value,
        }
      end
    end

    --save the custom lightmodel
    local lm = ChoGGi.CodeFuncs.LightmodelBuild(model_table)
    lm.name = "ChoGGi_Custom"
    ChoGGi.UserSettings.LightmodelCustom = PropToLuaCode(lm)
    if choice[1].check1 then
      SetLightmodelOverride(1,"ChoGGi_Custom")
    else
      SetLightmodel(1,"ChoGGi_Custom")
    end

    ChoGGi.SettingFuncs.WriteSettings()
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000975,"Custom Lightmodel"),
    hint = ChoGGi.ComFuncs.Trans(302535920000976,"Use double right click to test without closing dialog\n\nSome settings can't be changed in the editor, but you can manually add them in the settings file (type ex(DataInstances.Lightmodel) and use dump obj)."),
    check1 = ChoGGi.ComFuncs.Trans(302535920000977,"Semi-Permanent"),
    check1_hint = ChoGGi.ComFuncs.Trans(302535920000978,"Make it stay at selected light model till reboot (use Misc>Change Light Model for Permanent)."),
    check2 = ChoGGi.ComFuncs.Trans(302535920000979,"Presets"),
    check2_hint = ChoGGi.ComFuncs.Trans(302535920000980,"Opens up the list of premade styles so you can start with the settings from one."),
    custom_type = 5,
  })
end

function ChoGGi.MenuFuncs.ChangeLightmodel(Mode)
  --if it gets opened by menu then has object so easy way to do this
  local Browse
  if Mode == true then
    Browse = Mode
  end

  local ItemList = {}
  if not Browse then
    ItemList[#ItemList+1] = {
      text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),
      value = "ChoGGi_Default",
      hint = ChoGGi.ComFuncs.Trans(302535920000981,"Choose to this remove Permanent setting."),
    }
    ItemList[#ItemList+1] = {
      text = " " .. ChoGGi.ComFuncs.Trans(302535920000982,"Custom"),
      value = "ChoGGi_Custom",
      hint = ChoGGi.ComFuncs.Trans(302535920000983,"Custom Lightmodel made with \"Change Light Model Custom\""),
    }
  end
  local Table = DataInstances.Lightmodel
  for i = 1, #Table do
    ItemList[#ItemList+1] = {
      text = Table[i].name,
      value = Table[i].name,
      func = Table[i].name,
    }
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "string" then
      if Browse or choice[1].check2 then
        ChoGGi.MenuFuncs.ChangeLightmodelCustom(value)
      else
        if value == "ChoGGi_Default" then
          ChoGGi.UserSettings.Lightmodel = nil
          SetLightmodelOverride(1)
        else
          if choice[1].check1 then
            ChoGGi.UserSettings.Lightmodel = value
            SetLightmodelOverride(1,value)
          else
            SetLightmodelOverride(1)
            SetLightmodel(1,value)
          end
        end

        ChoGGi.SettingFuncs.WriteSettings()
        ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000769,"Selected: ") .. choice[1].text,ChoGGi.ComFuncs.Trans(302535920000984,"Lighting"))
      end
    end
  end

  local hint
  local Check1
  local Check1Hint
  local Check2
  local Check2Hint
  local title = ChoGGi.ComFuncs.Trans(302535920000985,"Select Lightmodel Preset")
  if not Browse then
    title = ChoGGi.ComFuncs.Trans(302535920000986,"Change Lightmodel")
    hint = ChoGGi.ComFuncs.Trans(302535920000987,"If you used Permanent; you must choose default to remove the setting (or it'll set the lightmodel next time you start the game).")
    local Lightmodel = ChoGGi.UserSettings.Lightmodel
    if Lightmodel then
      hint = hint .. "\n\n" .. ChoGGi.ComFuncs.Trans(302535920000988,"Permanent") .. ": " .. Lightmodel
    end
    Check1 = ChoGGi.ComFuncs.Trans(302535920000988,"Permanent")
    Check1Hint = ChoGGi.ComFuncs.Trans(302535920000989,"Make it stay at selected light model all the time (including reboots).")
    Check2 = ChoGGi.ComFuncs.Trans(327465361219,"Edit")
    Check2Hint = ChoGGi.ComFuncs.Trans(302535920000990,"Open this style in \"Change Light Model Custom\".")
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = title,
    hint = hint .. ChoGGi.ComFuncs.Trans(302535920000991,"\n\nDouble right-click to preview lightmodel without closing dialog."),
    check1 = Check1,
    check1_hint = Check1Hint,
    check2 = Check2,
    check2_hint = Check2Hint,
    --custom_type = 3,
    custom_type = 6,
    custom_func = function(value)
      SetLightmodel(1,value)
    end,
  })
end

function ChoGGi.MenuFuncs.TransparencyUI_Toggle()
  ChoGGi.UserSettings.TransparencyToggle = not ChoGGi.UserSettings.TransparencyToggle

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000992,"UI Transparency Toggle") .. ": " .. tostring(ChoGGi.UserSettings.TransparencyToggle),
    ChoGGi.ComFuncs.Trans(1608,"Transparency")
  )
end

function ChoGGi.MenuFuncs.SetTransparencyUI()
  local desk = terminal.desktop
  local igi = GetInGameInterface()
  --sets or gets transparency based on iWhich
  local function trans(iType,sName,iWhich)
    local name = ChoGGi.UserSettings.Transparency[sName]
    if not iWhich and name then
      return name
    end

    local uilist
    if iType == 1 then
      uilist = desk
    else
      if not igi or not igi:GetVisible() then
        return 0
      end
      uilist = igi
    end
    for i = 1, #uilist do
      local ui = uilist[i]
      if ui.class == sName then
        if iWhich then
          ui:SetTransparency(iWhich)
        else
          return ui:GetTransparency()
        end
      end
    end
    if not iWhich then
      --didn't find window so return 0 (fully vis)
      return 0
    end
  end

  local ItemList = {
    {text = "ConsoleLog",value = trans(1,"ConsoleLog"),hint = ChoGGi.ComFuncs.Trans(302535920000994,"Console logging text")},
    {text = "Console",value = trans(1,"Console"),hint = ChoGGi.ComFuncs.Trans(302535920000996,"Console text input")},
    {text = "UAMenu",value = trans(1,"UAMenu"),hint = ChoGGi.ComFuncs.Trans(302535920000998,"Cheat Menu: This uses 255 as visible and 0 as invisible.")},

    {text = "HUD",value = trans(2,"HUD"),hint = ChoGGi.ComFuncs.Trans(302535920001000,"Buttons at bottom")},
    {text = "XBuildMenu",value = trans(2,"XBuildMenu"),hint = ChoGGi.ComFuncs.Trans(302535920000993,"Build menu")},
    {text = "InfopanelDlg",value = trans(2,"InfopanelDlg"),hint = ChoGGi.ComFuncs.Trans(302535920000995,"Infopanel (selection)")},
    {text = "PinsDlg",value = trans(2,"PinsDlg"),hint = ChoGGi.ComFuncs.Trans(302535920000997,"Pins menu")},
  }
  --callback
  local CallBackFunc = function(choice)
    for i = 1, #choice do
      local value = choice[i].value
      local text = choice[i].text

      if type(value) == "number" then

        if text == "UAMenu" or text == "Console" or text == "ConsoleLog" then
          trans(1,text,value)
        else
          trans(2,text,value)
        end

        --everything but UAMenu uses 255-0 in the opposite manner
        if value == 0 or (value == 255 and text == "UAMenu") then
          ChoGGi.UserSettings.Transparency[text] = nil
        else
          ChoGGi.UserSettings.Transparency[text] = value
        end

      end
    end

    ChoGGi.SettingFuncs.WriteSettings()
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000999,"Transparency has been updated."),ChoGGi.ComFuncs.Trans(1608,"Transparency"))
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001001,"Set UI Transparency"),
    hint = ChoGGi.ComFuncs.Trans(302535920001002,"For some reason they went opposite day with this one: 255 is invisible and 0 is visible."),
    custom_type = 4,
  })
end
function ChoGGi.MenuFuncs.SetLightsRadius()
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),value = false,hint = ChoGGi.ComFuncs.Trans(302535920001003,"restart to enable")},
    {text = ChoGGi.ComFuncs.Trans(302535920001004,"01 Lowest (25)"),value = 25},
    {text = ChoGGi.ComFuncs.Trans(302535920001005,"02 Lower (50)"),value = 50},
    {text = ChoGGi.ComFuncs.Trans(302535920001006,"03 Low (90)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 90},
    {text = ChoGGi.ComFuncs.Trans(302535920001007,"04 Medium (95)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 95},
    {text = ChoGGi.ComFuncs.Trans(302535920001008,"05 High (100)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 100},
    {text = ChoGGi.ComFuncs.Trans(302535920001009,"06 Ultra (200)"),value = 200},
    {text = ChoGGi.ComFuncs.Trans(302535920001010,"07 Ultra-er (400)"),value = 400},
    {text = ChoGGi.ComFuncs.Trans(302535920001011,"08 Ultra-er (600)"),value = 600},
    {text = ChoGGi.ComFuncs.Trans(302535920001012,"09 Ultra-er (1000)"),value = 1000},
    {text = ChoGGi.ComFuncs.Trans(302535920001013,"10 Laggy (10000)"),value = 10000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      if value > 100000 then
        value = 100000
      end
      hr.LightsRadiusModifier = value
      ChoGGi.ComFuncs.SetSavedSetting("LightsRadius",value)
    else
      ChoGGi.UserSettings.LightsRadius = nil
    end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001014,"Lights Radius") .. ": " .. choice[1].text,
        ChoGGi.ComFuncs.Trans(302535920001015,"Video"),UsualIcon
      )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001016,"Set Lights Radius"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hr.LightsRadiusModifier .. ChoGGi.ComFuncs.Trans(302535920001017,"\n\nTurns up the radius for light bleedout, doesn't seem to hurt FPS much."),
  })
end

function ChoGGi.MenuFuncs.SetTerrainDetail()
  local hint_warn = ChoGGi.ComFuncs.Trans(302535920001018,"\nAbove 1000 will add a long delay to loading.")
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),value = false,hint = ChoGGi.ComFuncs.Trans(302535920001003,"restart to enable")},
    {text = ChoGGi.ComFuncs.Trans(302535920001004,"01 Lowest (25)"),value = 25},
    {text = ChoGGi.ComFuncs.Trans(302535920001005,"02 Lower (50)"),value = 50},
    {text = ChoGGi.ComFuncs.Trans(302535920001021,"03 Low (100)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 100},
    {text = ChoGGi.ComFuncs.Trans(302535920001022,"04 Medium (150)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 150},
    {text = ChoGGi.ComFuncs.Trans(302535920001008,"05 High (100)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 100},
    {text = ChoGGi.ComFuncs.Trans(302535920001024,"06 Ultra (200)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 200},
    {text = ChoGGi.ComFuncs.Trans(302535920001010,"07 Ultra-er (400)"),value = 400},
    {text = ChoGGi.ComFuncs.Trans(302535920001011,"08 Ultra-er (600)"),value = 600},
    {text = ChoGGi.ComFuncs.Trans(302535920001012,"09 Ultra-er (1000)"),value = 1000,hint = hint_warn},
    {text = ChoGGi.ComFuncs.Trans(302535920001028,"10 Ultra-er (2000)"),value = 2000,hint = hint_warn},
    {text = ChoGGi.ComFuncs.Trans(302535920001029,"11 It goes to 11 (6000)"),value = 6000,hint = hint_warn},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      if value > 6000 then
        value = 6000
      end
      hr.TR_MaxChunks = value
      ChoGGi.ComFuncs.SetSavedSetting("TerrainDetail",value)
    else
      ChoGGi.UserSettings.TerrainDetail = nil
    end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000635,"Terrain Detail") .. ": " .. choice[1].text,
        ChoGGi.ComFuncs.Trans(302535920001015,"Video"),UsualIcon
      )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000129,"Set") .. " " .. ChoGGi.ComFuncs.Trans(302535920000635,"Terrain Detail"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hr.TR_MaxChunks .. ChoGGi.ComFuncs.Trans(302535920001030,"\nDoesn't seem to use much CPU, but load times will probably increase. I've limited max to 6000, if you've got a Nvidia Volta and want to use more memory then do it through the settings file.\n\nAnd yes Medium is using a higher setting than High..."),
  })
end

function ChoGGi.MenuFuncs.SetVideoMemory()
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),value = false,hint = ChoGGi.ComFuncs.Trans(302535920001003,"restart to enable")},
    {text = ChoGGi.ComFuncs.Trans(302535920001031,"1 Crap (32)"),value = 32},
    {text = ChoGGi.ComFuncs.Trans(302535920001032,"2 Crap (64)"),value = 64},
    {text = ChoGGi.ComFuncs.Trans(302535920001033,"3 Crap (128)"),value = 128},
    {text = ChoGGi.ComFuncs.Trans(302535920001034,"4 Low (256)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 256},
    {text = ChoGGi.ComFuncs.Trans(302535920001035,"5 Medium (512)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 512},
    {text = ChoGGi.ComFuncs.Trans(302535920001036,"6 High (1024)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 1024},
    {text = ChoGGi.ComFuncs.Trans(302535920001037,"7 Ultra (2048)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 2048},
    {text = ChoGGi.ComFuncs.Trans(302535920001038,"8 Ultra-er (4096)"),value = 4096},
    {text = ChoGGi.ComFuncs.Trans(302535920001039,"9 Ultra-er-er (8192)"),value = 8192},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      hr.DTM_VideoMemory = value
      ChoGGi.ComFuncs.SetSavedSetting("VideoMemory",value)
    else
      ChoGGi.UserSettings.VideoMemory = nil
    end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001040,"Video Memory") .. ": " .. choice[1].text,
        ChoGGi.ComFuncs.Trans(302535920001015,"Video"),UsualIcon
      )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001041,"Set Video Memory Use"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hr.DTM_VideoMemory,
  })
end

function ChoGGi.MenuFuncs.SetShadowmapSize()
  local hint_highest = ChoGGi.ComFuncs.Trans(302535920001042,"Warning: Highest uses vram (one gig for starter base, a couple for large base).")
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),value = false,hint = ChoGGi.ComFuncs.Trans(302535920001003,"restart to enable")},
    {text = ChoGGi.ComFuncs.Trans(302535920001043,"1 Crap (256)"),value = 256},
    {text = ChoGGi.ComFuncs.Trans(302535920001044,"2 Lower (512)"),value = 512},
    {text = ChoGGi.ComFuncs.Trans(302535920001045,"3 Low (1536)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 1536},
    {text = ChoGGi.ComFuncs.Trans(302535920001046,"4 Medium (2048)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 2048},
    {text = ChoGGi.ComFuncs.Trans(302535920001047,"5 High (4096)") .. " < " .. ChoGGi.ComFuncs.Trans(302535920001065,"Menu Option"),value = 4096},
    {text = ChoGGi.ComFuncs.Trans(302535920001048,"6 Higher (8192)"),value = 8192},
    {text = ChoGGi.ComFuncs.Trans(302535920001049,"7 Highest (16384)"),value = 16384,hint = hint_highest},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      if value > 16384 then
        value = 16384
      end
      hr.ShadowmapSize = value
      ChoGGi.ComFuncs.SetSavedSetting("ShadowmapSize",value)
    else
      ChoGGi.UserSettings.ShadowmapSize = nil
    end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001050,"ShadowmapSize") .. ": " .. choice[1].text,
        ChoGGi.ComFuncs.Trans(302535920001015,"Video"),UsualIcon
      )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001051,"Set Shadowmap Size"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hr.ShadowmapSize .. "\n\n" .. hint_highest .. ChoGGi.ComFuncs.Trans(302535920001052,"\n\nMax limited to 16384 (or crashing)."),
  })
end

function ChoGGi.MenuFuncs.HigherShadowDist_Toggle()
  ChoGGi.UserSettings.HigherShadowDist = not ChoGGi.UserSettings.HigherShadowDist

  hr.ShadowRangeOverride = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowRangeOverride,0,1000000)
  hr.ShadowFadeOutRangePercent = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowFadeOutRangePercent,30,0)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001053,"Higher Shadow Render Dist") .. ": " .. tostring(ChoGGi.UserSettings.HigherShadowDist),
    ChoGGi.ComFuncs.Trans(302535920001015,"Video"),UsualIcon
  )
end

function ChoGGi.MenuFuncs.HigherRenderDist_Toggle()
  local DefaultSetting = ChoGGi.Consts.HigherRenderDist
  local hint_min = ChoGGi.ComFuncs.Trans(302535920001054,"Minimal FPS hit on large base")
  local hint_small = ChoGGi.ComFuncs.Trans(302535920001055,"Small FPS hit on large base")
  local hint_fps = ChoGGi.ComFuncs.Trans(302535920001056,"FPS hit")
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000110,"Default") .. ": " .. DefaultSetting,value = DefaultSetting},
    {text = 240,value = 240,hint = hint_min},
    {text = 360,value = 360,hint = hint_min},
    {text = 480,value = 480,hint = hint_min},
    {text = 600,value = 600,hint = hint_small},
    {text = 720,value = 720,hint = hint_small},
    {text = 840,value = 840,hint = hint_fps},
    {text = 960,value = 960,hint = hint_fps},
    {text = 1080,value = 1080,hint = hint_fps},
    {text = 1200,value = 1200,hint = hint_fps},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.HigherRenderDist then
    hint = tostring(ChoGGi.UserSettings.HigherRenderDist)
  end

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      hr.LODDistanceModifier = value
      ChoGGi.ComFuncs.SetSavedSetting("HigherRenderDist",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920001057,"Higher Render Dist") .. ": " .. tostring(ChoGGi.UserSettings.HigherRenderDist),
        ChoGGi.ComFuncs.Trans(302535920001015,"Video"),UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001057,"Higher Render Dist"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hint,
  })
end

--CameraObj

--use hr.FarZ = 7000000 for viewing full map with 128K zoom
function ChoGGi.MenuFuncs.CameraFree_Toggle()
  --if not mapdata.GameLogic then
  --  return
  --end
  if cameraFly.IsActive() then
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
    cameraRTS.Activate(1)
    engineShowMouseCursor()
    print(ChoGGi.ComFuncs.Trans(302535920001058,"Camera") .. " " .. ChoGGi.ComFuncs.Trans(302535920001059,"RTS"))
  else
    cameraFly.Activate(1)
    HideMouseCursor("InGameCursor")
    SetMouseDeltaMode(true)
    --IsMouseCursorHidden works by checking whatever this sets, not what EnableMouseControl sets
    engineHideMouseCursor()
    print(ChoGGi.ComFuncs.Trans(302535920001058,"Camera") .. " " .. ChoGGi.ComFuncs.Trans(302535920001060,"Fly"))
  end
  --resets zoom so...
  ChoGGi.CodeFuncs.SetCameraSettings()
end

function ChoGGi.MenuFuncs.CameraFollow_Toggle()
  --it was on the free camera so
  if not mapdata.GameLogic then
    return
  end
  local obj = ChoGGi.CodeFuncs.SelObject()

  --turn it off?
  if camera3p.IsActive() then
    engineShowMouseCursor()
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
    cameraRTS.Activate(1)
    --reset camera fov settings
    if ChoGGi.cameraFovX then
      camera.SetFovX(ChoGGi.cameraFovX)
    end
    --show log again if it was hidden
    if ChoGGi.UserSettings.ConsoleToggleHistory then
      cls() --if it's going to spam the log, might as well clear it
      ChoGGi.CodeFuncs.ToggleConsoleLog()
    end
    --reset camera zoom settings
    ChoGGi.CodeFuncs.SetCameraSettings()
    return
  --crashes game if we attach to "false"
  elseif not obj then
    return
  end
  --let user know the camera mode
  print(ChoGGi.ComFuncs.Trans(302535920001058,"Camera") .. " " .. ChoGGi.ComFuncs.Trans(302535920001061,"Follow"))
  --we only want to follow one object
  if ChoGGi.LastFollowedObject then
    camera3p.DetachObject(ChoGGi.LastFollowedObject)
  end
  --save for DetachObject
  ChoGGi.LastFollowedObject = obj
  --save for fovX reset
  ChoGGi.cameraFovX = camera.GetFovX()
  --zoom further out unless it's a colonist
  if not obj.base_death_age then
    --up the horizontal fov so we're further away from object
    camera.SetFovX(8400)
  end
  --consistent zoom level
  cameraRTS.SetZoom(8000)
  --Activate it
  camera3p.Activate(1)
  camera3p.AttachObject(obj)
  camera3p.SetLookAtOffset(point(0,0,-1500))
  camera3p.SetEyeOffset(point(0,0,-1000))
  --moving mouse moves camera
  camera3p.EnableMouseControl(true)
  --IsMouseCursorHidden works by checking whatever this sets, not what EnableMouseControl sets
  engineHideMouseCursor()

  --toggle showing console history as console spams transparent something (and it'd be annoying to replace that function)
  if ChoGGi.UserSettings.ConsoleToggleHistory then
    ChoGGi.CodeFuncs.ToggleConsoleLog()
  end

  --if it's a rover then stop the ctrl control mode from being active (from pressing ctrl-shift-f)
  pcall(function()
    obj:SetControlMode(false)
  end)
end

--LogCameraPos(print)
function ChoGGi.MenuFuncs.CursorVisible_Toggle()
  if IsMouseCursorHidden() then
    engineShowMouseCursor()
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
  else
    engineHideMouseCursor()
    HideMouseCursor("InGameCursor")
    SetMouseDeltaMode(true)
  end
end

function ChoGGi.MenuFuncs.SetBorderScrolling()
  local DefaultSetting = 5
  local hint_down = ChoGGi.ComFuncs.Trans(302535920001062,"Down scrolling may not work (dependant on aspect ratio?).")
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000793,"Default"),value = DefaultSetting},
    {text = 0,value = 0,hint = ChoGGi.ComFuncs.Trans(302535920001063,"disable mouse border scrolling, WASD still works fine.")},
    {text = 1,value = 1,hint = hint_down},
    {text = 2,value = 2,hint = hint_down},
    {text = 3,value = 3},
    {text = 4,value = 4},
    {text = 10,value = 10},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.UserSettings.BorderScrollingArea then
    hint = tostring(ChoGGi.UserSettings.BorderScrollingArea)
  end

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetSavedSetting("BorderScrollingArea",value)
      ChoGGi.CodeFuncs.SetCameraSettings()

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(choice[1].value .. ": " .. ChoGGi.ComFuncs.Trans(302535920001064,"Mouse") .. " " .. ChoGGi.ComFuncs.Trans(302535920000647,"Border Scrolling"),
        ChoGGi.ComFuncs.Trans(302535920000647,"Border Scrolling"),"UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920000129,"Set") .. " " .. ChoGGi.ComFuncs.Trans(302535920000647,"Border Scrolling"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hint,
  })
end

function ChoGGi.MenuFuncs.CameraZoom_Toggle()
  local DefaultSetting = ChoGGi.Consts.CameraZoomToggle
  local ItemList = {
    {text = " " .. ChoGGi.ComFuncs.Trans(302535920000110,"Default") .. ": " .. DefaultSetting,value = DefaultSetting},
    {text = 16000,value = 16000},
    {text = 20000,value = 20000},
    {text = 24000,value = 24000, hint = ChoGGi.ComFuncs.Trans(302535920001066,"What used to be the default for this ECM setting")},
    {text = 32000,value = 32000},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.UserSettings.CameraZoomToggle then
    hint = tostring(ChoGGi.UserSettings.CameraZoomToggle)
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.ComFuncs.SetSavedSetting("CameraZoomToggle",value)
      ChoGGi.CodeFuncs.SetCameraSettings()

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": " .. ChoGGi.ComFuncs.Trans(302535920001058,"Camera") .. " " .. ChoGGi.ComFuncs.Trans(302535920001067,"Zoom"),
        ChoGGi.ComFuncs.Trans(302535920001058,"Camera"),"UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = ChoGGi.ComFuncs.Trans(302535920001058,"Camera") .. " " .. ChoGGi.ComFuncs.Trans(302535920001067,"Zoom"),
    hint = ChoGGi.ComFuncs.Trans(302535920000106,"Current") .. ": " .. hint,
  })
end
