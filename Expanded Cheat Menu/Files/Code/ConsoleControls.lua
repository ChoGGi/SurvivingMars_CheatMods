-- See LICENSE for terms

-- called from OnMsgs

local Concat = ChoGGi.ComFuncs.Concat
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local S = ChoGGi.Strings

local rawget,table,tostring,print,select = rawget,table,tostring,print,select

--~ box(left, top, right, bottom)

local function ShowFileLog()
  FlushLogFile()
  print(select(2,AsyncFileToString(GetLogFile())))
end
local function ModsLog()
  print(ModMessageLog)
end
local function ConsoleLog()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
  ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)
  ChoGGi.SettingFuncs.WriteSettings()
end
local function ConsoleLogWindow()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.ConsoleHistoryWin = not ChoGGi.UserSettings.ConsoleHistoryWin
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.ShowConsoleLogWin(ChoGGi.UserSettings.ConsoleHistoryWin)
end
local function WriteConsoleLog()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.WriteLogs then
    ChoGGi.UserSettings.WriteLogs = nil
    ChoGGi.ComFuncs.WriteLogs_Toggle()
  else
    ChoGGi.UserSettings.WriteLogs = true
    ChoGGi.ComFuncs.WriteLogs_Toggle(true)
  end
  ChoGGi.SettingFuncs.WriteSettings()
end
local function ConsolePopup(self)
  local popup = rawget(terminal.desktop, "idConsoleMenu")
  if popup then
    popup:Close()
  else
    PopupToggle(self,"idConsoleMenu",nil,{
      {
        name = 302535920001026--[[Show File Log--]],
        hint = 302535920001091--[[Flushes log to disk and displays in console log.--]],
        clicked = ShowFileLog,
      },
      {
        name = 302535920000071--[[Mods Log--]],
        hint = 302535920000870--[[Shows any errors from loading mods in console log.--]],
        clicked = ModsLog,
      },
      {name = " - "},
      {
        name = 302535920000734--[[Clear Log--]],
        hint = 302535920001152--[[Clear out the console log (F9 also works).--]],
        clicked = cls,
      },
      {
        name = 302535920000563--[[Copy Log Text--]],
        hint = 302535920001154--[[Displays the log text in a window you can copy sections from.--]],
        clicked = ChoGGi.ComFuncs.SelectConsoleLogText,
      },
      {
        name = 302535920000473--[[Reload ECM Menu--]],
        hint = 302535920000474--[[Fiddling around in the editor mod can break the menu / shortcuts added by ECM (use this to fix).--]],
        clicked = function()
          Msg("ShortcutsReloaded")
        end,
      },
      {name = " - "},
      {
        name = 302535920001112--[[Console Log--]],
        hint = 302535920001119--[[Toggle showing the console log on screen.--]],
        class = "ChoGGi_CheckButtonMenu",
        value = "dlgConsoleLog",
        clicked = ConsoleLog,
      },
      {
        name = 302535920001120--[[Console Log Window--]],
        hint = 302535920001133--[[Toggle showing the console log window on screen.--]],
        class = "ChoGGi_CheckButtonMenu",
        value = "dlgChoGGi_ConsoleLogWin",
        clicked = ConsoleLogWindow,
      },
      {
        name = 302535920000483--[[Write Console Log--]],
        hint = 302535920000484--[[Write console log to AppData/logs/ConsoleLog.log (writes immediately).--]],
        class = "ChoGGi_CheckButtonMenu",
        value = {"WriteLogs"},
        clicked = WriteConsoleLog,
      },
    })
  end
end
local function HistoryPopup(self)
  local popup = rawget(terminal.desktop, "idHistoryMenu")
  if popup then
    popup:Close()
  else
    local items = {}
    --build history list menu
    if #dlgConsole.history_queue > 0 then
      local history = dlgConsole.history_queue
      for i = 1, #history do
        --these can get long so keep 'em short
        local text = tostring(history[i])
        local name = text:sub(1,ChoGGi.UserSettings.ConsoleHistoryMenuLength or 50)
        items[#items+1] = {
          name = name,
          hint = Concat(S[302535920001138--[[Execute this command in the console.--]]],"\n\n",text),
          clicked = function()
            dlgConsole:Exec(text)
          end,
        }
      end
    end
    PopupToggle(self,"idHistoryMenu",nil,items)
  end
end

function ChoGGi.Console.ConsoleControls()
  local g_Classes = g_Classes
  local dlgConsole = dlgConsole

  --stick everything in
  local container = g_Classes.XWindow:new({
    Id = "idContainer",
    Margins = box(15, 0, 0, 0),
    Dock = "bottom",
    LayoutMethod = "HWrap",
    Image = "CommonAssets/UI/round-frame-20.tga",
  }, dlgConsole)

  --------------------------------Console popup
  dlgConsole.idConsoleMenu = g_Classes.ChoGGi_ConsoleButton:new({
    Id = "idConsoleMenu",
    RolloverText = S[302535920001089--[[Settings & Commands for the console.--]]],
    Text = S[302535920001308--[[Settings--]]],
    OnPress = ConsolePopup,
  }, container)

  --------------------------------History popup
  dlgConsole.idHistoryMenu = g_Classes.ChoGGi_ConsoleButton:new({
    Id = "idHistoryMenu",
    RolloverText = S[302535920001080--[[Console history items (mouse-over to see code).--]]],
    Text = S[302535920000793--[[History--]]],
    OnPress = HistoryPopup,
  }, container)

  --------------------------------Scripts buttons
  dlgConsole.idScripts = g_Classes.XWindow:new({
    Id = "idScripts",
    LayoutMethod = "HList",
  }, container)
end

local function BuildSciptButton(scripts,dlg,folder)
  ChoGGi_ConsoleButton:new({
    RolloverText = folder.RolloverText,
    Text = folder.Text,
    OnPress = function(self)
      local popup = rawget(terminal.desktop, folder.id)
      if popup then
        popup:Close()
      else
        local items = {}
        local scripts = ChoGGi.ComFuncs.RetFilesInFolder(folder.script_path,".lua")
        if scripts then
          for i = 1, #scripts do
            local _, script = AsyncFileToString(scripts[i].path)
            items[#items+1] = {
              name = scripts[i].name,
              hint = Concat(S[302535920001138--[[Execute this command in the console.--]]],"\n\n",script),
              clicked = function()
                dlg:Exec(script)
              end,
            }
          end
        end

        PopupToggle(self,folder.id,nil,items)
      end
    end,
  }, scripts)
end

-- rebuild menu toolbar buttons
function ChoGGi.Console.RebuildConsoleToolbar(dlg)
  if not dlg then
    return
  end

  local ChoGGi = ChoGGi
  local scripts = dlg.idScripts

  ChoGGi.Console.BuildScriptFiles()

  -- clear out old buttons first
  for i = #scripts, 1, -1 do
    scripts[i]:delete()
    table.remove(scripts,i)
  end

  BuildSciptButton(scripts,dlg,{
    Text = S[302535920000353--[[Scripts--]]],
    RolloverText = S[302535920000881--[["Place .lua files in %s to have them show up in the ""Scripts"" list, you can then use the list to execute them (you can also create folders for sorting)."--]]]:format(ChoGGi.scripts),
    id = "idScriptsMenu",
    script_path = ChoGGi.scripts,
  })

  local folders = ChoGGi.ComFuncs.RetFoldersInFolder(ChoGGi.scripts)
  if folders then
    local hint_str = S[302535920001159--[[Any .lua files in %s.--]]]
    for i = 1, #folders do
      BuildSciptButton(scripts,dlg,{
        Text = folders[i].name,
        RolloverText = hint_str:format(folders[i].path),
        id = Concat("id",folders[i].name,"Menu"),
        script_path = folders[i].path,
      })
    end
  end

end

-- add example script files if folder is missing
function ChoGGi.Console.BuildScriptFiles()
  local script_path = ChoGGi.scripts
  --create folder and some example scripts if folder doesn't exist
  local err,_ = AsyncGetFileAttribute(script_path,"size")
  if err then
    AsyncCreatePath(Concat(script_path,"/Examine"))
    AsyncCreatePath(Concat(script_path,"/Functions"))
    --print some info
    print(S[302535920000881--[["Place .lua files in %s to have them show up in the ""Scripts"" list, you can then use the list to execute them (you can also create folders for sorting)."--]]]:format(script_path))
    --add some example files and a readme
    AsyncStringToFile(Concat(script_path,"/readme.txt"),S[302535920000888--[[Any .lua files in here will be part of a list that you can execute in-game from the console menu.--]]])
    AsyncStringToFile(Concat(script_path,"/Help Me.lua"),[[ChoGGi.ComFuncs.MsgWait(ChoGGi.Strings[302535920000881]:format(ChoGGi.scripts))]])
    AsyncStringToFile(Concat(script_path,"/Examine/ChoGGi.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi)
-- stores all ECM stuff.]])
    AsyncStringToFile(Concat(script_path,"/Examine/DataInstances.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(DataInstances)]])
    AsyncStringToFile(Concat(script_path,"/Examine/Consts.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(Consts)]])
    AsyncStringToFile(Concat(script_path,"/Examine/const.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(const)]])
    AsyncStringToFile(Concat(script_path,"/Examine/FXRules.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(FXRules)
-- sounds/fx effects/etc]])
    AsyncStringToFile(Concat(script_path,"/Examine/InGameInterface.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(GetInGameInterface())
-- use Dialogs instead of this if you want to access the dialogs.]])
    AsyncStringToFile(Concat(script_path,"/Examine/MsgThreads.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(MsgThreads)
-- includes ThreadsRegister]])
    AsyncStringToFile(Concat(script_path,"/Examine/Presets.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(Presets)]])
    AsyncStringToFile(Concat(script_path,"/Examine/terminal.desktop.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(terminal.desktop)
-- any opened UI elements.]])
    AsyncStringToFile(Concat(script_path,"/Examine/UICity.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(UICity)
-- created on a new game, stores most data you'll need.]])
    AsyncStringToFile(Concat(script_path,"/Examine/XTemplates.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(XTemplates)
-- stores all GUI before they're built. Saved per game, new DLC will update them as well.]])
    AsyncStringToFile(Concat(script_path,"/Examine/Dialogs.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(Dialogs)]])
-- added by ECM]])
    AsyncStringToFile(Concat(script_path,"/Examine/Flags.lua"),[[ChoGGi.ComFuncs.OpenInExamineDlg(Flags)
-- See const.FLAG]])
    AsyncStringToFile(Concat(script_path,"/Examine/XWindowInspector.lua"),[[OpenGedApp("XWindowInspector", terminal.desktop)]])
    AsyncStringToFile(Concat(script_path,"/Functions/Amount of colonists.lua"),[[#(UICity.labels.Colonist or "")]])
    AsyncStringToFile(Concat(script_path,"/Functions/Toggle Working SelectedObj.lua"),[[SelectedObj:ToggleWorking()]])
  end

  --rebuild toolbar
  ChoGGi.Console.RebuildConsoleToolbar()
end

