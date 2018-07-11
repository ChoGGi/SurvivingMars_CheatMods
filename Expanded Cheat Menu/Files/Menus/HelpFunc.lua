--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local T = ChoGGi.ComFuncs.Trans
local UsualIcon = "UI/Icons/Sections/attention.tga"

local tostring = tostring

local CreateBugReportDlg = CreateBugReportDlg
local CreateRealTimeThread = CreateRealTimeThread
local UpdateOnScreenHintDlg = UpdateOnScreenHintDlg
local SetHintNotificationsEnabled = SetHintNotificationsEnabled
local ToggleSigns = ToggleSigns
local AsyncFileDelete = AsyncFileDelete
local ThreadUnlockKey = ThreadUnlockKey
local ThreadLockKey = ThreadLockKey
local AsyncCopyFile = AsyncCopyFile
local WriteScreenshot = WriteScreenshot
local GenerateScreenshotFilename = GenerateScreenshotFilename
local MovieWriteScreenshot = MovieWriteScreenshot
local UnlockCamera = UnlockCamera
local LockCamera = LockCamera
local WaitNextFrame = WaitNextFrame
local LuaCodeToTuple = LuaCodeToTuple

local g_Classes = g_Classes

function ChoGGi.MenuFuncs.EditECMSettings()
  local ChoGGi = ChoGGi
  -- make sure any changed settings are current
  ChoGGi.SettingFuncs.WriteSettings()
  -- load up settings file in the editor
  local dialog = g_Classes.ChoGGi_MultiLineText:new({}, terminal.desktop,{
    text = ChoGGi.SettingFuncs.ReadSettings(),
    hint_ok = T(302535920001244--[["Saves settings to file, and applies any changes."--]]),
    hint_cancel = T(302535920001245--[[Abort without touching anything.--]]),
    func = function(answer,_,obj)
      if answer then
        -- get text and update settings file
        local err,settings = LuaCodeToTuple(obj.idText:GetText())
        if not err then
          ChoGGi.SettingFuncs.WriteSettings(settings)
          -- then read new settings
          ChoGGi.SettingFuncs.ReadSettings()
        end
      end
    end,
  })
  dialog:Open()
end

function ChoGGi.MenuFuncs.DisableECM()
  local function CallBackFunc(answer)
    if answer then
      local ChoGGi = ChoGGi
      ChoGGi.UserSettings.DisableECM = not ChoGGi.UserSettings.DisableECM
      ChoGGi.SettingFuncs.WriteSettings()

      MsgPopup(T(302535920001070--[[Restart to take effect.--]]))
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(T(302535920000466--[["This will disable the cheats menu, cheats panel, and all hotkeys.
CheatMenuModSettings.lua > DisableECM to re-enable them."--]]),"\n\n",T(302535920001070--[[Restart to take effect.--]])),
    CallBackFunc,
    T(302535920000142--[[Disable--]])
  )
end

function ChoGGi.MenuFuncs.CheatsMenu_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.ShowCheatsMenu = not ChoGGi.UserSettings.ShowCheatsMenu
  ChoGGi.SettingFuncs.WriteSettings()
  g_Classes.UAMenu.ToggleOpen()
end

function ChoGGi.MenuFuncs.ShowChangelogECM()
	local file_error, str = AsyncFileToString(Concat(ChoGGi.ModPath,"changes.log"))
	if not file_error then
    OpenExamine(str)
	end
end

function ChoGGi.MenuFuncs.ShowReadmeECM()
	local file_error, str = AsyncFileToString(Concat(ChoGGi.ModPath,"README.md"))
	if not file_error then
    OpenExamine(str)
	end
end

function ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle()
  local ChoGGi = ChoGGi
  hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
  ChoGGi.UserSettings.ShowInterfaceInScreenshots = not ChoGGi.UserSettings.ShowInterfaceInScreenshots

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(Concat(T(302535920001068--[[Interface in screenshots--]]),": ",tostring(ChoGGi.UserSettings.ShowInterfaceInScreenshots)),
    T(302535920001069--[[Interface--]])
  )
end

function ChoGGi.MenuFuncs.TakeScreenshot(Bool)
  if Bool == true then
    CreateRealTimeThread(function()
      WaitNextFrame(3)
      LockCamera("Screenshot")
      MovieWriteScreenshot(GenerateScreenshotFilename("SSAA","AppData/"), 0, 64, false)
      UnlockCamera("Screenshot")
    end)
  else
    WriteScreenshot(GenerateScreenshotFilename("SS", "AppData/"))
  end
end

function ChoGGi.MenuFuncs.ResetECMSettings()
  local file = ChoGGi.SettingsFile
  local old = Concat(file,".old")

  local function CallBackFunc(answer)
    if answer then
      ThreadLockKey(old)
      AsyncCopyFile(file,old)
      ThreadUnlockKey(old)

      ThreadLockKey(file)
      AsyncFileDelete(ChoGGi.SettingsFile)
      ThreadUnlockKey(file)

      --so we don't save file on exit
      ChoGGi.Temp.ResetSettings = true

      MsgPopup(T(302535920001070--[[Restart to take effect.--]]),
        Concat(T(302535920001084--[[Reset","!--]])),UsualIcon
      )
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(T(302535920001072--[[Are you sure you want to reset ECM settings?

Old settings are saved as--]])," ",old,"\n\n",T(302535920001070--[[Restart to take effect.--]])),
    CallBackFunc,
    T(302535920001071--[[Reset!--]])
  )
end

function ChoGGi.MenuFuncs.SignsInterface_Toggle()
  ToggleSigns()
  MsgPopup(T(302535920001074--[[Sign, sign, everywhere a sign.
Blockin' out the scenery, breakin' my mind.
Do this, don't do that, can't you read the sign?--]]),
    T(302535920001075--[[Signs--]]),nil,true
  )
end

function ChoGGi.MenuFuncs.OnScreenHints_Toggle()
  SetHintNotificationsEnabled(not HintsEnabled)
  UpdateOnScreenHintDlg()
  MsgPopup(HintsEnabled,T(4248--[[Hints--]]))
end

function ChoGGi.MenuFuncs.OnScreenHints_Reset()
  g_ShownOnScreenHints = {}
  UpdateOnScreenHintDlg()
  MsgPopup(T(302535920001076--[[Hints Reset!--]]),T(4248--[[Hints--]]))
end

function ChoGGi.MenuFuncs.NeverShowHints_Toggle()
  local ChoGGi = ChoGGi
  if ChoGGi.UserSettings.DisableHints then
    ChoGGi.UserSettings.DisableHints = nil
    mapdata.DisableHints = false
    HintsEnabled = true
  else
    ChoGGi.UserSettings.DisableHints = true
    mapdata.DisableHints = true
    HintsEnabled = false
  end

  ChoGGi.SettingFuncs.WriteSettings()
  MsgPopup(
    Concat(tostring(ChoGGi.UserSettings.DisableHints),T(302535920001077--[[: Bye bye hints--]])),
    T(4248--[[Hints--]]),
    "UI/Icons/Sections/attention.tga"
  )
end

function ChoGGi.MenuFuncs.ReportBugDlg()
  --was in orig func, i guess there's never any bugs when modding :)
  if Platform.ged then
    return
  end
  CreateRealTimeThread(function()
    CreateBugReportDlg()
  end)
end

function ChoGGi.MenuFuncs.AboutECM()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.MsgWait(
    string.format(T(302535920001078--[["Hover mouse over menu item to get description and enabled status
If there isn't a status then it's likely a list of options to choose from

For any issues; please report them to my Github/Steam/NexusMods page, or email %s"--]]),ChoGGi.email),
    T(487939677892--[[Help--]])
  )
end

