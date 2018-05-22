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

      ChoGGi.ComFuncs.MsgPopup("Terrain: " .. choice[1].text,
        "Terrain"
      )
    end
  end

  local hint = "Map default: " .. mapdata.BaseLayer
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Terrain Texture",hint)
end

--add button to import model
function ChoGGi.MenuFuncs.ChangeLightmodelCustom(Name)
  local ItemList = {}
  local LightmodelDefaults = Lightmodel:GetProperties()

  --always load defaults, then override with custom so list is always full
  local def = LightmodelDefaults
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
    ChoGGi.UserSettings.LightmodelCustom = PropToLuaCode(ChoGGi.CodeFuncs.LightmodelBuild(model_table))
    if choice[1].check1 then
      SetLightmodelOverride(1,"ChoGGi_Custom")
    else
      SetLightmodel(1,"ChoGGi_Custom")
    end

    ChoGGi.SettingFuncs.WriteSettings()
  end

  local hint = "Use double right click to test without closing dialog\n\nSome settings can't be changed in the editor, but you can manually add them in the settings file (type ex(DataInstances.Lightmodel) and use dump obj)."
  local Check1 = "Semi-Permanent"
  local Check1Hint = "Make it stay at selected light model till reboot (use Misc>Change Light Model for Permanent)."
  local Check2 = "Presets"
  local Check2Hint = "Opens up the list of premade styles so you can start with the settings from one."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Custom Lightmodel",hint,nil,Check1,Check1Hint,Check2,Check2Hint,5)
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
      text = " Default",
      value = "ChoGGi_Default",
      hint = "Choose to this remove Permanent setting.",
    }
    ItemList[#ItemList+1] = {
      text = " Custom",
      value = "ChoGGi_Custom",
      hint = "Custom Lightmodel made with \"Change Light Model Custom\"",
    }
  end
  local Table = DataInstances.Lightmodel
  for i = 1, #Table do
    ItemList[#ItemList+1] = {
      text = Table[i].name,
      value = Table[i].name,
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
        ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,"Lighting")
      end
    end
  end

  local hint
  local Check1
  local Check1Hint
  local Check2
  local Check2Hint
  local title = "Select Lightmodel Preset"
  if not Browse then
    title = "Change Lightmodel"
    hint = "If you used Permanent; you must choose default to remove the setting (or it'll set the lightmodel next time you start the game)."
    local Lightmodel = ChoGGi.UserSettings.Lightmodel
    if Lightmodel then
      hint = hint .. "\n\nPermanent: " .. Lightmodel
    end
    Check1 = "Permanent"
    Check1Hint = "Make it stay at selected light model all the time (including reboots)."
    Check2 = "Edit"
    Check2Hint = "Open this style in \"Change Light Model Custom\"."
  end
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,title,hint,nil,Check1,Check1Hint,Check2,Check2Hint,3)
end

function ChoGGi.MenuFuncs.TransparencyUI_Toggle()
  ChoGGi.UserSettings.TransparencyToggle = not ChoGGi.UserSettings.TransparencyToggle

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup("UI Transparency Toggle: " .. tostring(ChoGGi.UserSettings.TransparencyToggle),
    "Transparency"
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
    {text = "ConsoleLog",value = trans(1,"ConsoleLog"),hint = "Console text"},
    {text = "Console",value = trans(1,"Console"),hint = "Console input"},
    {text = "UAMenu",value = trans(1,"UAMenu"),hint = "Cheat Menu: This uses 255 as visible and 0 as invisible."},

    {text = "HUD",value = trans(2,"HUD"),hint = "Buttons at bottom"},
    {text = "XBuildMenu",value = trans(2,"XBuildMenu"),hint = "Build menu"},
    {text = "InfopanelDlg",value = trans(2,"InfopanelDlg"),hint = "Infopanel (selection)"},
    {text = "PinsDlg",value = trans(2,"PinsDlg"),hint = "Pins"},
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
    ChoGGi.ComFuncs.MsgPopup("Transparency has been updated.","Transparency")
  end

  local hint = "For some reason they went opposite day with this one: 255 is invisible and 0 is visible."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set UI Transparency",hint,nil,nil,nil,nil,nil,4)
end

function ChoGGi.MenuFuncs.ShowAutoUnpinObjectList()
  local ItemList = {
    {text = "RC Rover",value = "RCRover"},
    {text = "RC Explorer",value = "RCExplorer"},
    {text = "RC Transport",value = "RCTransport"},
    {text = "Drone Hub",value = "DroneHub"},
    {text = "Colonist",value = "Colonist"},
    {text = "Supply Rocket",value = "SupplyRocket"},
    {text = "Space Elevator",value = "SpaceElevator"},
    {text = "Dome Basic",value = "DomeBasic"},
    {text = "Dome Medium",value = "DomeMedium"},
    {text = "Dome Mega",value = "DomeMega"},
    {text = "Dome Oval",value = "DomeOval"},
    {text = "Dome Geoscape",value = "GeoscapeDome"},
  }

  if not ChoGGi.UserSettings.UnpinObjects then
    ChoGGi.UserSettings.UnpinObjects = {}
  end

  --other hint type
  local EnabledList = ""
  local list = ChoGGi.UserSettings.UnpinObjects
  if next(list) then
    local tab = list or empty_table
    for i = 1, #tab do
      EnabledList = EnabledList .. " " .. i
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      ChoGGi.ComFuncs.MsgPopup("Pick a checkbox next time...","Pins")
      return
    elseif check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup("Don't pick both checkboxes next time...","Pins")
      return
    end

    local pins = ChoGGi.UserSettings.UnpinObjects
    for i = 1, #choice do
      local value = choice[i].value
      if check2 then
        for j = 1, #pins do
          if pins[j] == value then
            pins[j] = false
          end
        end
      elseif check1 then
        pins[#pins+1] = value
      end
    end

    --remove dupes
    ChoGGi.UserSettings.UnpinObjects = ChoGGi.ComFuncs.RetTableNoDupes(ChoGGi.UserSettings.UnpinObjects)

    local found = true
    while found do
      found = nil
      for i = 1, #ChoGGi.UserSettings.UnpinObjects do
        if ChoGGi.UserSettings.UnpinObjects[i] == false then
          ChoGGi.UserSettings.UnpinObjects[i] = nil
          found = true
          break
        end
      end
    end

    --if it's empty then remove setting
    if not next(ChoGGi.UserSettings.UnpinObjects) then
      ChoGGi.UserSettings.UnpinObjects = nil
    end
    ChoGGi.SettingFuncs.WriteSettings()
    ChoGGi.ComFuncs.MsgPopup("Toggled: " .. #choice .. " pinnable objects.","Pins")
  end

  local hint = "Auto Unpinned:" .. EnabledList .. "\nEnter a class name (s.class) to add a custom entry."
  local hint_check1 = "Add these items to the unpin list."
  local hint_check2 = "Remove these items from the unpin list."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Auto Remove Items From Pin List",hint,true,"Add to list",hint_check1,"Remove from list",hint_check2)
end

function ChoGGi.MenuFuncs.CleanAllObjects()
  local tab = UICity.labels.Building or empty_table
  for i = 1, #tab do
    tab[i]:SetDust(0,const.DustMaterialExterior)
  end
  tab = UICity.labels.Unit or empty_table
  for i = 1, #tab do
    tab[i]:SetDust(0,const.DustMaterialExterior)
  end

  ChoGGi.ComFuncs.MsgPopup("Cleaned all","Objects")
end

function ChoGGi.MenuFuncs.FixAllObjects()
  local function Repair(Label)
    local tab = UICity.labels[Label] or empty_table
    for i = 1, #tab do
      tab[i]:Repair()
      tab[i].accumulated_maintenance_points = 0
    end
  end
  Repair("Building")
  Repair("Rover")
  local tab = UICity.labels.Drone or empty_table
  for i = 1, #tab do
    tab[i]:SetCommand("RepairDrone")
  end

  ChoGGi.ComFuncs.MsgPopup("Fixed all","Objects")
end

--build and show a list of attachments for changing their colours
function ChoGGi.MenuFuncs.CreateObjectListAndAttaches()
  local obj = ChoGGi.CodeFuncs.SelObject()
  if not obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGi.ComFuncs.MsgPopup("Select/mouse over an object (buildings, vehicles, signs, rocky outcrops).","Colour")
    return
  end
  local ItemList = {}

  --has no Attaches so just open as is
  if obj:GetNumAttaches() == 0 then
    ChoGGi.CodeFuncs.ChangeObjectColour(obj)
    return
  else
    ItemList[#ItemList+1] = {
      text = " " .. obj.class,
      value = obj.class,
      obj = obj,
      hint = "Change main object colours."
    }
    local Attaches = obj:GetAttaches()
    for i = 1, #Attaches do
      ItemList[#ItemList+1] = {
        text = Attaches[i].class,
        value = Attaches[i].class,
        parentobj = obj,
        obj = Attaches[i],
        hint = "Change colours of a part of an object."
      }
    end
  end

  local CallBackFunc = function()
    --we're ignoring the ok button
    return
  end

  local hint = "Double click to open object/attachment to edit."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,nil,nil,nil,nil,nil,1)
end

function ChoGGi.MenuFuncs.SetObjectOpacity()
  local sel = ChoGGi.CodeFuncs.SelObject()
  local ItemList = {
    {text = " Reset: Anomalies",value = "Anomaly",hint = "Loops though and makes all anomalies visible."},
    {text = " Reset: Buildings",value = "Building",hint = "Loops though and makes all buildings visible."},
    {text = " Reset: Cables & Pipes",value = "ChoGGi_GridElements",hint = "Loops though and makes all pipes and cables visible."},
    {text = " Reset: Colonists",value = "Colonists",hint = "Loops though and makes all colonists visible."},
    {text = " Reset: Units",value = "Unit",hint = "Loops though and makes all rovers and drones visible."},
    {text = " Reset: Deposits",value = "SurfaceDeposit",hint = "Loops though and makes all surface, subsurface, and terrain deposits visible."},
    {text = 0,value = 0},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
  }
  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      sel:SetOpacity(value)
    elseif type(value) == "string" then
      local function SettingOpacity(label)
        local tab = UICity.labels[label] or empty_table
        for i = 1, #tab do
          tab[i]:SetOpacity(100)
        end
      end
      SettingOpacity(value)
      --extra ones
      if value == "Building" then
        SettingOpacity("AllRockets")
      elseif value == "Anomaly" then
        SettingOpacity("SubsurfaceAnomalyMarker")
      elseif value == "SurfaceDeposit" then
        SettingOpacity("SubsurfaceDeposit")
        SettingOpacity("TerrainDeposit")
      end
    end
    ChoGGi.ComFuncs.MsgPopup("Selected: " .. choice[1].text,
      "Opacity","UI/Icons/Sections/attention.tga"
    )
  end
  local hint
  local name = ""
  if sel then
    hint = "Current: " .. sel:GetOpacity() .. "\n\nYou can still select items after making them invisible (0), but it may take some effort :)."
    name = ChoGGi.CodeFuncs.Trans(sel.display_name) or sel.encyclopedia_id or sel.class
  end
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Opacity: " .. name,hint)
end

function ChoGGi.MenuFuncs.DisableTextureCompression_Toggle()
  ChoGGi.UserSettings.DisableTextureCompression = not ChoGGi.UserSettings.DisableTextureCompression
  hr.TR_ToggleTextureCompression = 1

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup("Texture Compression: " .. tostring(ChoGGi.UserSettings.DisableTextureCompression),
    "Video",UsualIcon
  )
end

function ChoGGi.MenuFuncs.SetShadowmapSize()
  local hint_highest = "Warning: Highest uses vram (one gig for starter base, a couple for large base)."
  local ItemList = {
    {text = " Default",value = false,hint = "restart to enable"},
    {text = "1 Crap (256)",value = 256},
    {text = "2 Lower (512)",value = 512},
    {text = "3 Low (1536) < Menu Option",value = 1536},
    {text = "4 Medium (2048) < Menu Option",value = 2048},
    {text = "5 High (4096) < Menu Option",value = 4096},
    {text = "6 Higher (8192)",value = 8192},
    {text = "7 Highest (16384)",value = 16384,hint = hint_highest},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      if value > 16384 then
        hr.ShadowmapSize = 16384
      else
        hr.ShadowmapSize = value
      end
      ChoGGi.ComFuncs.SetSavedSetting("ShadowmapSize",value)
    else
      ChoGGi.UserSettings.ShadowmapSize = false
    end

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup("ShadowmapSize: " .. choice[1].text,
        "Video",UsualIcon
      )
  end
  local hint = "Current: " .. hr.ShadowmapSize .. "\n\n" .. hint_highest .. "\n\nMax set to 16384."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Shadowmap Size",hint)
end

function ChoGGi.MenuFuncs.HigherShadowDist_Toggle()
  ChoGGi.UserSettings.HigherShadowDist = not ChoGGi.UserSettings.HigherShadowDist

  hr.ShadowRangeOverride = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowRangeOverride,0,1000000)
  hr.ShadowFadeOutRangePercent = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowFadeOutRangePercent,30,0)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup("Higher Shadow Render Dist: " .. tostring(ChoGGi.UserSettings.HigherShadowDist),
    "Video",UsualIcon
  )
end

function ChoGGi.MenuFuncs.HigherRenderDist_Toggle()

  local DefaultSetting = ChoGGi.Consts.HigherRenderDist
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 240,value = 240,hint = "Minimal FPS hit on large base"},
    {text = 360,value = 360,hint = "Minimal FPS hit on large base"},
    {text = 480,value = 480,hint = "Minimal FPS hit on large base"},
    {text = 600,value = 600,hint = "Small FPS hit on large base"},
    {text = 720,value = 720,hint = "Small FPS hit on large base"},
    {text = 840,value = 840,hint = "FPS hit"},
    {text = 960,value = 960,hint = "FPS hit"},
    {text = 1080,value = 1080,hint = "FPS hit"},
    {text = 1200,value = 1200,hint = "FPS hit"},
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
      ChoGGi.ComFuncs.MsgPopup("Higher Render Dist: " .. tostring(ChoGGi.UserSettings.HigherRenderDist),
        "Video",UsualIcon
      )
    end

  end
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Higher Render Dist","Current: " .. hint)
end

--CameraObj

function ChoGGi.MenuFuncs.CameraFree_Toggle()
  if not mapdata.GameLogic then
    return
  end
  if cameraFly.IsActive() then
    SetMouseDeltaMode(false)
    ShowMouseCursor("InGameCursor")
    cameraRTS.Activate(1)
    engineShowMouseCursor()
    print("Camera RTS")
  else
    cameraFly.Activate(1)
    HideMouseCursor("InGameCursor")
    SetMouseDeltaMode(true)
    --IsMouseCursorHidden works by checking whatever this sets, not what EnableMouseControl sets
    engineHideMouseCursor()
    print("Camera Fly")
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
  print("Camera Follow")
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

function ChoGGi.MenuFuncs.InfopanelCheats_Toggle()
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.ComFuncs.SetSavedSetting("ToggleInfopanelCheats",config.BuildingInfopanelCheats)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ToggleInfopanelCheats) .. ": HAXOR",
    "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.InfopanelCheatsCleanup_Toggle()
  ChoGGi.UserSettings.CleanupCheatsInfoPane = not ChoGGi.UserSettings.CleanupCheatsInfoPane

  if ChoGGi.UserSettings.CleanupCheatsInfoPane then
    ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
  end

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.CleanupCheatsInfoPane) .. ": Cleanup",
    "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.MenuFuncs.SetBorderScrolling()
  local DefaultSetting = 5
  local hint_down = "Down scrolling may not work (dependant on aspect ratio?)."
  local ItemList = {
    {text = " Default",value = DefaultSetting},
    {text = 0,value = 0,hint = "disable mouse border scrolling, WASD still works fine."},
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].value .. ": Mouse Border Scrolling",
        "BorderScrolling","UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"TitleBar","Current: " .. hint)

end

function ChoGGi.MenuFuncs.CameraZoom_Toggle()
  local DefaultSetting = ChoGGi.Consts.CameraZoomToggle
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 16000,value = 16000},
    {text = 20000,value = 20000},
    {text = 24000,value = 24000, hint = "What used to be the default for this ECM setting"},
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
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": Camera Zoom",
        "Camera","UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Camera Zoom","Current: " .. hint)
end

function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
  const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
  ChoGGi.ComFuncs.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ExplorationQueueMaxSize) .. ": scans at a time.",
    "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

--SetTimeFactor(1000) = normal speed
function ChoGGi.MenuFuncs.SetGameSpeed()
  local ItemList = {
    {text = " Default",value = 1},
    {text = "1 Double",value = 2},
    {text = "2 Triple",value = 3},
    {text = "3 Quadruple",value = 4},
    {text = "4 Octuple",value = 8},
    {text = "5 Sexdecuple",value = 16},
    {text = "6 Duotriguple",value = 32},
    {text = "7 Quattuorsexaguple",value = 64},
  }

  local current = "Default"
  pcall(function()
    if const.mediumGameSpeed == 6 then
      current = "Double"
    elseif const.mediumGameSpeed == 9 then
      current = "Triple"
    elseif const.mediumGameSpeed == 12 then
      current = "Quadruple"
    elseif const.mediumGameSpeed == 24 then
      current = "Octuple"
    elseif const.mediumGameSpeed == 48 then
      current = "Sexdecuple"
    elseif const.mediumGameSpeed == 96 then
      current = "Duotriguple"
    elseif const.mediumGameSpeed == 192 then
      current = "Quattuorsexaguple"
    else
      current = "Custom: " .. const.mediumGameSpeed .. " < base number 3 multipled by custom amount"
    end
  end)

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      const.mediumGameSpeed = ChoGGi.Consts.mediumGameSpeed * value
      const.fastGameSpeed = ChoGGi.Consts.fastGameSpeed * value
      --so it changes the speed
      ChangeGameSpeedState(-1)
      ChangeGameSpeedState(1)
      --update settings
      ChoGGi.UserSettings.mediumGameSpeed = const.mediumGameSpeed
      ChoGGi.UserSettings.fastGameSpeed = const.fastGameSpeed

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": Excusa! Esta too mucho rapido for the eyes to follow? I'll show you in el slow motiono.",
        "Speed","UI/Icons/Notifications/timer.tga"
      )
    end
  end

  local hint = "Current speed: " .. current
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Game Speed",hint)
end

local entity_table = {}
local function SetEntity(Obj,Entity)
  --backup orig
  if not Obj.ChoGGi_OrigEntity then
    Obj.ChoGGi_OrigEntity = Obj.entity
  end
  if Entity == "Default" and Obj.ChoGGi_OrigEntity then
    Obj.entity = Obj.ChoGGi_OrigEntity
    Obj:ChangeEntity(Obj.ChoGGi_OrigEntity)
    Obj.ChoGGi_OrigEntity = nil
  else
    Obj.entity = Entity
    Obj:ChangeEntity(Entity)
  end
end
function ChoGGi.MenuFuncs.SetEntity()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    ChoGGi.ComFuncs.MsgPopup("You need to select an object.","Entity")
    return
  end

  local hint_noanim = "No animation."
  if #entity_table == 0 then
    entity_table = {
      {text = "  Default Entity",value = "Default"},
      {text = " Kosmonavt",value = "Kosmonavt"},
      {text = " Lama",value = "Lama",hint = hint_noanim},
      {text = " GreenMan",value = "GreenMan",hint = hint_noanim},
      {text = " PlanetMars",value = "PlanetMars",hint = hint_noanim},
      {text = " PlanetEarth",value = "PlanetEarth",hint = hint_noanim},
      {text = " Rocket Small",value = "RocketUI",hint = hint_noanim},
      {text = " Rocket Regular",value = "Rocket",hint = hint_noanim},
      {text = " CombatRover",value = "CombatRover",hint = hint_noanim},
      {text = " PumpStationDemo",value = "PumpStationDemo",hint = hint_noanim},
    }
    --EntityData
    local Table = DataInstances.BuildingTemplate
    for i = 1, #Table do
      entity_table[#entity_table+1] = {
        text = Table[i].entity,
        value = Table[i].entity,
        hint = hint_noanim
      }
    end
  end
  local ItemList = entity_table

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup("Don't pick both checkboxes next time...","Entity")
      return
    end

    local dome
    if sel.dome and check1 then
      dome = sel.dome
    end
    local value = choice[1].value
    if EntityData[value] or value == "Default" then

      if check2 then
        SetEntity(sel,value)
      else
        local objs = GetObjects({class = sel.class}) or empty_table
        for i = 1, #objs do
          if dome then
            if objs[i].dome and objs[i].dome == dome then
              SetEntity(objs[i],value)
            end
          else
            SetEntity(objs[i],value)
          end
        end
      end
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": " .. sel.class,"Entity")
    end
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to objects in the same dome as selected object."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected object."
  local hint = "Current: " .. (sel.ChoGGi_OrigEntity or sel.entity) .. "\nIf you don't pick a checkbox it will change all of selected type.\n\nPost a request if you want me to add more entities from EntityData (use ex(EntityData) to list).\n\nNot permanent for colonists after they exit buildings (for now)."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Entity For " .. sel.class,hint,nil,Check1,Check1Hint,Check2,Check2Hint)
end

local function SetScale(Obj,Scale)
  local cUserSettings = ChoGGi.UserSettings
  Obj:SetScale(Scale)
  --changing entity to a static one and changing scale can make things not move so re-apply speeds.
  CreateRealTimeThread(function()
    --and it needs a slight delay
    Sleep(500)
    if Obj.class == "Drone" then
      if cUserSettings.SpeedDrone then
        pf.SetStepLen(Obj,cUserSettings.SpeedDrone)
      else
        Obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedDrone())
      end
    elseif Obj.class == "CargoShuttle" then
      if cUserSettings.SpeedShuttle then
        Obj.max_speed = ChoGGi.Consts.SpeedShuttle
      else
        Obj.max_speed = ChoGGi.Consts.SpeedShuttle
      end
    elseif Obj.class == "Colonist" then
      if cUserSettings.SpeedColonist then
        pf.SetStepLen(Obj,cUserSettings.SpeedColonist)
      else
        Obj:SetMoveSpeed(ChoGGi.Consts.SpeedColonist)
      end
    elseif s:IsKindOf("BaseRover") then
      if cUserSettings.SpeedRC then
        pf.SetStepLen(Obj,cUserSettings.SpeedRC)
      else
        Obj:SetMoveSpeed(ChoGGi.CodeFuncs.GetSpeedRC())
      end
    end
  end)
end

function ChoGGi.MenuFuncs.SetEntityScale()
  local sel = ChoGGi.CodeFuncs.SelObject()
  if not sel then
    ChoGGi.ComFuncs.MsgPopup("You need to select an object.","Scale")
    return
  end

  local ItemList = {
    {text = " Default",value = 100},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
  }

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    if check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup("Don't pick both checkboxes next time...","Scale")
      return
    end

    local dome
    if sel.dome and check1 then
      dome = sel.dome
    end
    local value = choice[1].value
    if type(value) == "number" then

      if check2 then
        SetScale(sel,value)
      else
        local objs = GetObjects({class = sel.class}) or empty_table
        for i = 1, #objs do
          if dome then
            if objs[i].dome and objs[i].dome == dome then
              SetScale(objs[i],value)
            end
          else
            SetScale(objs[i],value)
          end
        end
      end
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": " .. sel.class,"Scale")
    end
  end

  local Check1 = "Dome Only"
  local Check1Hint = "Will only apply to objects in the same dome as selected object."
  local Check2 = "Selected Only"
  local Check2Hint = "Will only apply to selected object."
  local hint = "Current object: " .. sel:GetScale() .. "\nIf you don't pick a checkbox it will change all of selected type."
  ChoGGi.CodeFuncs.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Entity For " .. sel.class,hint,nil,Check1,Check1Hint,Check2,Check2Hint)
end
