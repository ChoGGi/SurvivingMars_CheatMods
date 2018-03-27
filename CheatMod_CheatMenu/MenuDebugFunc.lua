function ChoGGi.WriteDebugLogs()
  ChoGGi.CheatMenuSettings.WriteDebugLogs = not ChoGGi.CheatMenuSettings.WriteDebugLogs
  if ChoGGi.CheatMenuSettings.WriteDebugLogs then
    ChoGGi.WriteDebugLogsEnable()
  end
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Write Debug Logs: " .. ChoGGi.CheatMenuSettings.WriteDebugLogs,
   "Research","UI/Icons/Notifications/research.tga"
  )
end

function ChoGGi.ExamineCurrentObj()
  pcall(function()
    OpenExamine(SelectedObj)
  end)
end

function ChoGGi.DumpCurrentObj()
  pcall(function()
    Examine.onclick_handles = {}
    Examine.obj = SelectedObj
    local tempTable = Examine:totextex(SelectedObj)
    ChoGGi.Dump(tempTable .. "\n\n","a","DumpedHtml","html")
  end)
end

function ChoGGi.BombardmentAtCursorMass()
  StartBombard(GetTerrainCursor(),0,50,0,0)
end

function ChoGGi.BombardmentAtCursor()
  StartBombard(GetTerrainCursor(),0,1,0,0)
  --function WaitBombard(obj, radius, count, delay_min, delay_max)
end

function ChoGGi.DestroySelectedObject()
  pcall(function()
    SelectedObj.can_demolish = true
    SelectedObj.indestructible = false
    DestroyBuildingImmediate(SelectedObj)
    SelectedObj:Destroy()
  end)
end

function ChoGGi.ConsoleToggleHistory()
  ChoGGi.CheatMenuSettings.ConsoleToggleHistory = not ChoGGi.CheatMenuSettings.ConsoleToggleHistory
  ShowConsoleLog(ChoGGi.CheatMenuSettings.ConsoleToggleHistory)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup("Those who cannot remember the past are condemned to repeat it.",
   "Console","UI/Icons/Sections/workshifts.tga"
  )
end

function ChoGGi.ChangeMap()
  local ineditor = Platform.editor and IsEditorActive()
  if ineditor then
    s_OldChangeMapAction()
  else
    CreateRealTimeThread(function()
      local caption = Untranslated("Choose map with settings presets:")
      local maps = ListMaps()
      local items = {}
      for i = 1, #maps do
        if not string.find(string.lower(maps[i]), "^prefab") and not string.find(maps[i], "^__") then
          table.insert(items, {
            text = Untranslated(maps[i]),
            map = maps[i]
          })
        end
      end
      local default_selection = table.find(maps, GetMapName())
      local map_settings = {}
      local class_names = ClassDescendantsList("MapSettings")
      for i = 1, #class_names do
        local class = class_names[i]
        map_settings[class] = mapdata[class]
      end
      local sel_idx, map_settings = WaitMapSettingsDialog(items, caption, nil, default_selection, map_settings)
      if sel_idx ~= "idCancel" then
        local map = sel_idx and items[sel_idx].map
        if not map or map == "" then
          return
        end
        CloseMenuWizards()
        StartGame(map, map_settings)
        LocalStorage.last_map = map
        SaveLocalStorage()
      end
    end)
  end
end

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: MenuDebugFunc.lua",true)
end
