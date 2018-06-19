-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local T = ChoGGi.ComFuncs.Trans

local rawget,table,string,tostring,print,select = rawget,table,string,tostring,print,select

local box = box
local FlushLogFile = FlushLogFile
local AsyncFileToString = AsyncFileToString
local GetLogFile = GetLogFile

local g_Classes = g_Classes
--~ box(left, top, right, bottom)

--fired from OnMsgs
function ChoGGi.Console.ConsoleControls()
  --stick everything in
  local container = g_Classes.XWindow:new({
    Id = "idContainer",
    Margins = box(15, 0, 0, 0),
    Dock = "bottom",
    LayoutMethod = "HWrap",
    Image = "CommonAssets/UI/round-frame-20.tga",
  }, dlgConsole)

  --------------------------------Console popup
  g_Classes.XTextButton:new({
--~     Id = "idConsoleMenu",
    Padding = box(5, 2, 5, 2),
    TextFont = "Editor16Bold",
    RolloverAnchor = "top",
    RolloverTemplate = "Rollover",
    RolloverText = T(302535920001089--[[Settings & Commands--]]),
    Text = T(302535920001073--[[Console--]]),
    OnPress = function(self)
      local popup = rawget(terminal.desktop, "idConsoleMenu")
      if popup then
        popup:Close()
      else
        PopupToggle(self,"idConsoleMenu",{
          {
            name = T(302535920001026--[[Show File Log--]]),
            hint = T(302535920001091--[[Flushes log to disk and displays in console log.--]]),
            class = "XTextButton",
            clicked = function(self,pos,button)
              FlushLogFile()
              print(select(2,AsyncFileToString(GetLogFile())))
            end,
          },
          {
            name = T(302535920000071--[[Mods Log,--]]),
            hint = T(302535920000870--[[Shows any errors from loading mods in console log.--]]),
            class = "XTextButton",
            clicked = function(self,pos,button)
              print(ModMessageLog)
            end,
          },
          {name = " - ",class = "XTextButton"},
          {
            name = T(302535920000734--[[Clear Log--]]),
            hint = T(302535920001152--[[Clear out the console log.--]]),
            class = "XTextButton",
            clicked = cls,
          },
          {
            name = T(302535920000563--[[Copy Log Text--]]),
            hint = T(302535920001154--[[Displays the log text in a window you can copy sections from.--]]),
            class = "XTextButton",
            clicked = ChoGGi.ComFuncs.SelectConsoleLogText,
          },
          {name = " - ",class = "XTextButton"},
          {
            name = T(302535920001112--[[Console Log--]]),
            hint = T(302535920001119--[[Toggle showing the console log on screen.--]]),
            class = "XCheckButton",
            value = "dlgConsoleLog",
            clicked = function(self,pos,button)
              local ChoGGi = ChoGGi
              ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
              ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)
              ChoGGi.SettingFuncs.WriteSettings()
            end,
          },
          {
            name = T(302535920001120--[[Console Log Window--]]),
            hint = T(302535920001133--[[Toggle showing the console log window on screen.--]]),
            class = "XCheckButton",
            value = "dlgChoGGi_ConsoleLogWin",
            clicked = function(self,pos,button)
              local ChoGGi = ChoGGi
              ChoGGi.UserSettings.ConsoleHistoryWin = not ChoGGi.UserSettings.ConsoleHistoryWin
              ChoGGi.SettingFuncs.WriteSettings()
              ChoGGi.ComFuncs.ShowConsoleLogWin(ChoGGi.UserSettings.ConsoleHistoryWin)
            end,
          },
        })
      end
    end,
  }, container)

  --------------------------------History popup
  g_Classes.XTextButton:new({
--~     Id = "idHistoryMenu",
    RolloverTemplate = "Rollover",
    RolloverAnchor = "top",
    Padding = box(5, 2, 5, 2),
    TextFont = "Editor16Bold",
    RolloverText = T(302535920001080--[[Console History Items--]]),
    Text = T(302535920000793--[[History--]]),
    OnPress = function(self)
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
              class = "XTextButton",
              name = name,
              hint = Concat(T(302535920001138--[[Execute this command in the console.--]]),"\n\n",text),
              clicked = function(self,pos,button)
--~                 ShowConsoleLog(true)
                dlgConsole:Exec(text)
              end,
            }
          end
        end
        PopupToggle(self,"idHistoryMenu",items)
      end
    end,
  }, container)

  --------------------------------Scripts buttons
  g_Classes.XWindow:new({
    Id = "idScripts",
--~     Margins = box(15, 0, 0, 0),
--~     Dock = "bottom",
--~     Padding = box(5, 2, 5, 2),
    LayoutMethod = "HWrap",
  }, container)

end

local function BuildSciptButton(scripts,dlg,folder)
  g_Classes.XTextButton:new({
    Padding = box(5, 2, 5, 2),
    TextFont = "Editor16Bold",
    RolloverAnchor = "top",
    RolloverTemplate = "Rollover",
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
              class = "XTextButton",
              name = scripts[i].name,
              hint = Concat(T(302535920001138--[[Execute this command in the console.--]]),"\n\n",script),
              clicked = function(self,pos,button)
                dlg:Exec(script)
              end,
            }
          end
        end

        PopupToggle(self,folder.id,items)
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

  --clear out old buttons first
  for i = #scripts, 1, -1 do
    scripts[i]:delete()
    table.remove(scripts,i)
  end

  BuildSciptButton(scripts,dlg,{
    Text = T(302535920000353--[[Scripts--]]),
    RolloverText = string.format(T(302535920000881--[[Place .lua files in %s to have them show up in the 'Scripts' list, you can then use the list to execute them (you can also create folders for sorting).--]]),ChoGGi.scripts),
    id = "idScriptsMenu",
    script_path = ChoGGi.scripts,
  })

  local folders = ChoGGi.ComFuncs.RetFoldersInFolder(ChoGGi.scripts)
  if folders then
    for i = 1, #folders do
      BuildSciptButton(scripts,dlg,{
        Text = folders[i].name,
        RolloverText = string.format(T(302535920001159--[[Any .lua files contained in %s.--]]),folders[i].path),
        id = Concat("id",folders[i].name,"Menu"),
        script_path = folders[i].path,
      })
    end
  end

end

-- add script files if not there
function ChoGGi.Console.ListScriptFiles()
  local AsyncCreatePath = AsyncCreatePath

  local script_path = ChoGGi.scripts
  --create folder and some example scripts if folder doesn't exist
  if AsyncFileOpen(script_path) ~= "Access Denied" then
    AsyncCreatePath(script_path)
    --print some info
    local help = string.format(T(302535920000881--[[Place .lua files in %s to have them show up in the 'Scripts' list, you can then use the list to execute them (you can also create folders for sorting).--]]),script_path)
    print(help)
    --add some example files and a readme
    AsyncStringToFile(Concat(script_path,"/readme.txt"),T(302535920000888--[[Any .lua files in here will be part of a list that you can execute in-game from the console menu.--]]))
    AsyncStringToFile(Concat(script_path,"/Help.lua"),[[local ChoGGi = ChoGGi
ChoGGi.ComFuncs.MsgWait(string.format(ChoGGi.ComFuncs.Trans(302535920000881),ChoGGi.scripts))]])
    AsyncCreatePath(Concat(script_path,"/Examine"))
    AsyncStringToFile(Concat(script_path,"/Examine/ChoGGi.lua"),[[OpenExamine(ChoGGi)]])
    AsyncStringToFile(Concat(script_path,"/Examine/DataInstances.lua"),[[OpenExamine(DataInstances)]])
    AsyncStringToFile(Concat(script_path,"/Examine/InGameInterface.lua"),[[OpenExamine(GetInGameInterface())]])
    AsyncStringToFile(Concat(script_path,"/Examine/MsgThreads.lua"),[[OpenExamine(MsgThreads)\n--includes ThreadsRegister]])
    AsyncStringToFile(Concat(script_path,"/Examine/Presets.lua"),[[OpenExamine(Presets)]])
    AsyncStringToFile(Concat(script_path,"/Examine/terminal.desktop.lua"),[[OpenExamine(terminal.desktop)]])
    AsyncStringToFile(Concat(script_path,"/Examine/UICity.lua"),[[OpenExamine(UICity)]])
    AsyncStringToFile(Concat(script_path,"/Examine/XTemplates.lua"),[[OpenExamine(XTemplates)]])
    AsyncStringToFile(Concat(script_path,"/Examine/XWindowInspector.lua"),[[OpenGedApp("XWindowInspector", terminal.desktop) --Platform.editor]])
    AsyncCreatePath(Concat(script_path,"/Functions"))
    AsyncStringToFile(Concat(script_path,"/Functions/Amount of colonists.lua"),[[#GetObjects({class="Colonist")]])
    AsyncStringToFile(Concat(script_path,"/Functions/Toggle Working SelectedObj.lua"),[[SelectedObj:ToggleWorking()]])
    --rebuild toolbar
    ChoGGi.Console.RebuildConsoleToolbar()
  end
end

