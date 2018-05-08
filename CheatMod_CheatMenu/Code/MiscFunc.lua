local UsualIcon = "UI/Icons/Anomaly_Event.tga"

function ChoGGi.TransparencyUI_Toggle()
  ChoGGi.CheatMenuSettings.TransparencyToggle = not ChoGGi.CheatMenuSettings.TransparencyToggle

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("UI Transparency Toggle: " .. tostring(ChoGGi.CheatMenuSettings.TransparencyToggle),
    "Transparency"
  )
end

function ChoGGi.SetTransparencyUI()
  local desk = terminal.desktop
  local igi = GetInGameInterface()
  --sets or gets transparency based on iWhich
  local function trans(iType,sName,iWhich)
    local name = ChoGGi.CheatMenuSettings.Transparency[sName]
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
          ChoGGi.CheatMenuSettings.Transparency[text] = nil
        else
          ChoGGi.CheatMenuSettings.Transparency[text] = value
        end

      end
    end

    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Transparency has been updated.","Transparency")
  end

  local hint = "For some reason they went opposite day with this one: 255 is invisible and 0 is visible."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Transparency",hint,nil,nil,nil,nil,nil,4)
end

function ChoGGi.ShowAutoUnpinObjectList()

  --build a list
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

  if not ChoGGi.CheatMenuSettings.UnpinObjects then
    ChoGGi.CheatMenuSettings.UnpinObjects = {}
  end

  --other hint type
  local EnabledList = ""
  local list = ChoGGi.CheatMenuSettings.UnpinObjects
  if next(list) then
    local tab = list
    for i = 1, #tab do
      EnabledList = EnabledList .. " " .. i
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      ChoGGi.MsgPopup("Pick a checkbox next time...","Pins")
      return
    elseif check1 and check2 then
      ChoGGi.MsgPopup("Don't pick both checkboxes next time...","Pins")
      return
    end

    for i = 1, #choice do
      local value = choice[i].value
      if check2 then
        local pins = ChoGGi.CheatMenuSettings.UnpinObjects
        for j = 1, #pins do
          if pins[j] == value then
            pins[j] = false
          end
        end
      elseif check1 then
        table.insert(ChoGGi.CheatMenuSettings.UnpinObjects,value)
      end
    end

    --remove dupes
    ChoGGi.CheatMenuSettings.UnpinObjects = ChoGGi.RetTableNoDupes(ChoGGi.CheatMenuSettings.UnpinObjects)

    local found = true
    while found do
      found = nil
      for i = 1, #ChoGGi.CheatMenuSettings.UnpinObjects do
        if ChoGGi.CheatMenuSettings.UnpinObjects[i] == false then
          ChoGGi.CheatMenuSettings.UnpinObjects[i] = nil
          found = true
          break
        end
      end
    end

    --if it's empty then remove setting
    if not next(ChoGGi.CheatMenuSettings.UnpinObjects) then
      ChoGGi.CheatMenuSettings.UnpinObjects = nil
    end
    ChoGGi.WriteSettings()
    ChoGGi.MsgPopup("Toggled: " .. #choice .. " pinnable objects.","Pins")
  end

  local hint = "Auto Unpinned:" .. EnabledList .. "\nEnter a class name (s.class) to add a custom entry."
  local hint_check1 = "Add these items to the unpin list."
  local hint_check2 = "Remove these items from the unpin list."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Auto Remove Items From Pin List",hint,true,"Add to list",hint_check1,"Remove from list",hint_check2)
end

function ChoGGi.CleanAllObjects()
  local tab = UICity.labels.Building or empty_table
  for i = 1, #tab do
    tab[i]:SetDust(0,const.DustMaterialExterior)
  end
  tab = UICity.labels.Unit or empty_table
  for i = 1, #tab do
    tab[i]:SetDust(0,const.DustMaterialExterior)
  end

  ChoGGi.MsgPopup("Cleaned all","Objects")
end

function ChoGGi.FixAllObjects()
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

  ChoGGi.MsgPopup("Fixed all","Objects")
end

--build and show a list of attachments for changing their colours
function ChoGGi.CreateObjectListAndAttaches()
  local obj = SelectedObj or SelectionMouseObj()
  if not obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGi.MsgPopup("Select/mouse over an object (buildings,vehicles,signs,some rocks)","Colour")
    return
  end
  local ItemList = {}

  --has no Attaches so just open as is
  if obj:GetNumAttaches() == 0 then
    ChoGGi.ChangeObjectColour(obj)
    return
  else
    table.insert(ItemList,{
      text = " " .. obj.class,
      value = obj.class,
      obj = obj,
      hint = "Change main object colours."
    })
    local Attaches = obj:GetAttaches()
    for i = 1, #Attaches do
      table.insert(ItemList,{
        text = Attaches[i].class,
        value = Attaches[i].class,
        parentobj = obj,
        obj = Attaches[i],
        hint = "Change colours of a part of an object."
      })
    end
  end

  local CallBackFunc = function()
    --we're ignoring the ok button
    return
  end

  local hint = "Double click to open object/attachment to edit."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,nil,nil,nil,nil,nil,1)
end

function ChoGGi.ChangeObjectColour(obj,Parent)
  if not obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGi.MsgPopup("Can't colour object","Colour")
    return
  end
  --SetPal(Obj,i,Color,Roughness,Metallic)
  local SetPal = obj.SetColorizationMaterial
  local pal = ChoGGi.GetPalette(obj)

  local ItemList = {}
  for i = 1, 4 do
    table.insert(ItemList,{
      text = "Colour " .. i,
      value = pal["Color" .. i],
      hint = "Use the colour picker (dbl-click for instant change).",
    })
    table.insert(ItemList,{
      text = "Metallic " .. i,
      value = pal["Metallic" .. i],
      hint = "Don't use the colour picker: Numbers range from -255 to 255.",
    })
    table.insert(ItemList,{
      text = "Roughness " .. i,
      value = pal["Roughness" .. i],
      hint = "Don't use the colour picker: Numbers range from -255 to 255.",
    })
  end
  table.insert(ItemList,{
    text = "X_BaseColour",
    value = 6579300,
    obj = obj,
    hint = "single colour for object (this colour will interact with the other colours).\nIf you want to change the colour of an object you can't with 1-4 (like drones).",
  })

  --callback
  local CallBackFunc = function(choice)
    if #choice == 13 then
      --keep original colours as part of object
      local base = choice[13].value
      --used to check for grid connections
      local CheckAir = choice[1].checkair
      local CheckWater = choice[1].checkwater
      local CheckElec = choice[1].checkelec
      --needed to set attachment colours
      local Label = obj.class
      local FakeParent
      if Parent then
        Label = Parent.class
        FakeParent = Parent
      else
        FakeParent = obj.parentobj
      end
      if not FakeParent then
        FakeParent = obj
      end
      --they get called a few times so
      local function SetOrigColours(Object)
        ChoGGi.RestoreOldPalette(Object)
        --6579300 = reset base color
        Object:SetColorModifier(6579300)
      end
      local function SetColours(Object)
        ChoGGi.SaveOldPalette(Object)
        for i = 1, 4 do
          local Color = choice[i].value
          local Metallic = choice[i+4].value
          local Roughness = choice[i+8].value
          SetPal(Object,i,Color,Roughness,Metallic)
        end
        Object:SetColorModifier(base)
      end
      --make sure we're in the same grid
      local function CheckGrid(Func,Object,Building)
        if CheckAir and Building.air and FakeParent.air and Building.air.grid.elements[1].building.handle == FakeParent.air.grid.elements[1].building.handle then
          Func(Object)
        end
        if CheckWater and Building.water and FakeParent.water and Building.water.grid.elements[1].building.handle == FakeParent.water.grid.elements[1].building.handle then
          Func(Object)
        end
        if CheckElec and Building.electricity and FakeParent.electricity and Building.electricity.grid.elements[1].building.handle == FakeParent.electricity.grid.elements[1].building.handle then
          Func(Object)
        end
        if not CheckAir and not CheckWater and not CheckElec then
          Func(Object)
        end
      end

      --store table so it's the same as was displayed
      table.sort(choice,
        function(a,b)
          return ChoGGi.CompareTableNames(a,b,"text")
        end
      )
      --All of type checkbox
      if choice[1].check1 then
        local tab = UICity.labels[Label] or empty_table
        for i = 1, #tab do
          if Parent then
            local Attaches = tab[i]:GetAttaches()
            for j = 1, #Attaches do
              if Attaches[j].class == obj.class then
                if choice[1].check2 then
                  CheckGrid(SetOrigColours,Attaches[j],tab[i])
                else
                  CheckGrid(SetColours,Attaches[j],tab[i])
                end
              end
            end
          else --not parent
            if choice[1].check2 then
              CheckGrid(SetOrigColours,tab[i],tab[i])
            else
              CheckGrid(SetColours,tab[i],tab[i])
            end
          end --Parent
        end
      else --single building change
        if choice[1].check2 then
          CheckGrid(SetOrigColours,obj,obj)
        else
          CheckGrid(SetColours,obj,obj)
        end
      end

      ChoGGi.MsgPopup("Colour is set on " .. obj.class,"Colour")
    end
  end
  local hint = "If number is 8421504 (0 for Metallic/Roughness) then you probably can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking)."
  local hint_check1 = "Change all objects of the same type."
  local hint_check2 = "if they're there; resets to default colours."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,true,"All of type",hint_check1,"Default Colour",hint_check2,2)
end

function ChoGGi.SetObjectOpacity()
  local sel = SelectedObj or SelectionMouseObj()
  local ItemList = {
    {text = " Reset: Anomalies",value = "Anomaly",hint = "Loops though and makes all anomalies visible."},
    {text = " Reset: Buildings",value = "Building",hint = "Loops though and makes all buildings visible."},
    {text = " Reset: Cables & Pipes",value = "GridElements",hint = "Loops though and makes all pipes and cables visible."},
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
    ChoGGi.MsgPopup("Selected: " .. choice[1].text,
      "Opacity","UI/Icons/Sections/attention.tga"
    )
  end
  local hint
  local name = ""
  if sel then
    hint = "Current: " .. sel:GetOpacity() .. "\n\nYou can still select items after making them invisible (0), but it may take some effort :)."
    name = sel.encyclopedia_id or sel.class
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Opacity: " .. name,hint)
end

function ChoGGi.DisableTextureCompression_Toggle()
  ChoGGi.CheatMenuSettings.DisableTextureCompression = not ChoGGi.CheatMenuSettings.DisableTextureCompression

  hr.TR_ToggleTextureCompression = 1

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Texture Compression: " .. tostring(ChoGGi.CheatMenuSettings.DisableTextureCompression),
    "Video",UsualIcon
  )
end

function ChoGGi.SetShadowmapSize()
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
      ChoGGi.SetSavedSetting("ShadowmapSize",value)
    else
      ChoGGi.CheatMenuSettings.ShadowmapSize = false
    end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("ShadowmapSize: " .. choice[1].text,
        "Video",UsualIcon
      )
  end
  local hint = "Current: " .. hr.ShadowmapSize .. "\n\n" .. hint_highest .. "\n\nMax set to 16384."
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Shadowmap Size",hint)
end

function ChoGGi.HigherShadowDist_Toggle()
  ChoGGi.CheatMenuSettings.HigherShadowDist = not ChoGGi.CheatMenuSettings.HigherShadowDist

  hr.ShadowRangeOverride = ChoGGi.ValueRetOpp(hr.ShadowRangeOverride,0,1000000)
  hr.ShadowFadeOutRangePercent = ChoGGi.ValueRetOpp(hr.ShadowFadeOutRangePercent,30,0)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Higher Shadow Render Dist: " .. tostring(ChoGGi.CheatMenuSettings.HigherShadowDist),
    "Video",UsualIcon
  )
end

function ChoGGi.HigherRenderDist_Toggle()

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
  if ChoGGi.CheatMenuSettings.HigherRenderDist then
    hint = tostring(ChoGGi.CheatMenuSettings.HigherRenderDist)
  end

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      hr.LODDistanceModifier = value
      ChoGGi.SetSavedSetting("HigherRenderDist",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("Higher Render Dist: " .. tostring(ChoGGi.CheatMenuSettings.HigherRenderDist),
        "Video",UsualIcon
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Higher Render Dist","Current: " .. hint)
end

function ChoGGi.CameraFree_Toggle()
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
  ChoGGi.SetCameraSettings()
end

function ChoGGi.CameraFollow_Toggle()
  --it was on the free camera so
  if not mapdata.GameLogic then
    return
  end
  local obj = SelectedObj or SelectionMouseObj()

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
    if ChoGGi.CheatMenuSettings.ConsoleToggleHistory then
      cls() --if it's going to spam the log, might as well clear it
      ChoGGi.ToggleConsoleLog()
    end
    --reset camera zoom settings
    ChoGGi.SetCameraSettings()
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
  if ChoGGi.CheatMenuSettings.ConsoleToggleHistory then
    ChoGGi.ToggleConsoleLog()
  end

  --if it's a rover then stop the ctrl control mode from being active (from pressing ctrl-shift-f)
  pcall(function()
    obj:SetControlMode(false)
  end)
end
--LogCameraPos(print)
function ChoGGi.CursorVisible_Toggle()
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

function ChoGGi.InfopanelCheats_Toggle()
  config.BuildingInfopanelCheats = not config.BuildingInfopanelCheats
  ReopenSelectionXInfopanel()
  ChoGGi.SetSavedSetting("ToggleInfopanelCheats",config.BuildingInfopanelCheats)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ToggleInfopanelCheats) .. ": HAXOR",
    "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.InfopanelCheatsCleanup_Toggle()
  ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane = not ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane

  if ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane then
    ChoGGi.InfopanelCheatsCleanup()
  end

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane) .. ": Cleanup",
    "Cheats","UI/Icons/Anomaly_Tech.tga"
  )
end

function ChoGGi.SetBorderScrolling()
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
  if ChoGGi.CheatMenuSettings.BorderScrollingArea then
    hint = tostring(ChoGGi.CheatMenuSettings.BorderScrollingArea)
  end

  --callback
  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetSavedSetting("BorderScrollingArea",value)

      ChoGGi.SetCameraSettings()

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].value .. ": Mouse Border Scrolling",
        "BorderScrolling","UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"TitleBar","Current: " .. hint)

end

function ChoGGi.CameraZoom_Toggle()
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
  if ChoGGi.CheatMenuSettings.CameraZoomToggle then
    hint = tostring(ChoGGi.CheatMenuSettings.CameraZoomToggle)
  end

  --callback
  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetSavedSetting("CameraZoomToggle",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": Camera Zoom",
        "Camera","UI/Icons/IPButtons/status_effects.tga"
      )
    end

  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Camera Zoom","Current: " .. hint)
end

function ChoGGi.ScannerQueueLarger_Toggle()
  const.ExplorationQueueMaxSize = ChoGGi.ValueRetOpp(const.ExplorationQueueMaxSize,100,ChoGGi.Consts.ExplorationQueueMaxSize)
  ChoGGi.SetSavedSetting("ExplorationQueueMaxSize",const.ExplorationQueueMaxSize)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.ExplorationQueueMaxSize) .. ": scans at a time.",
    "Scanner","UI/Icons/Notifications/scan.tga"
  )
end

--SetTimeFactor(1000) = normal speed
function ChoGGi.SetGameSpeed()
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
      ChoGGi.CheatMenuSettings.mediumGameSpeed = const.mediumGameSpeed
      ChoGGi.CheatMenuSettings.fastGameSpeed = const.fastGameSpeed

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": I think I can...",
        "Speed","UI/Icons/Notifications/timer.tga"
      )
    end
  end

  local hint = "Current speed: " .. current
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Game Speed",hint)
end

function ChoGGi.InstantColonyApproval()
  CreateRealTimeThread(WaitPopupNotification, "ColonyViabilityExit_Delay")
  Msg("ColonyApprovalPassed")
  g_ColonyNotViableUntil = -1
end
