--See LICENSE for terms

local default_icon = "UI/Icons/Sections/attention.tga"

local Concat = ChoGGi.ComFuncs.Concat
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local S = ChoGGi.Strings

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

local ModUploadThread
function ChoGGi.MenuFuncs.ModUpload()
  local ChoGGi = ChoGGi
  local ItemList = {}
  local Mods = Mods or empty_table
  for id,mod in pairs(Mods) do
    ItemList[#ItemList+1] = {
      text = mod.title,
      value = id,
      hint = mod.description,
      mod = mod,
    }
  end

  local CallBackFunc = function(choice)
    -- abort if upload already happening
    if IsValidThread(ModUploadThread) then
      ChoGGi.ComFuncs.MsgWait(
        1000011--[[There is an active Steam upload--]],
        1000592--[[Error--]],
        "UI/Common/mod_steam_workshop.tga"
      )
      return
    end

    local mod = choice[1].mod
    local copy_files = choice[1].check1
    local blank_mod = choice[1].check2
    local diff_author = choice[1].mod.author ~= SteamGetPersonaName()

    ModUploadThread = CreateRealTimeThread(function()
      -- clear out and create upload folder
      local dest = "AppData/ModUpload/"
      AsyncDeletePath(dest)
      AsyncCreatePath(dest)

      -- build / show confirmation dialog
      local upload_msg = S[1000012--[[Mod %s will be uploaded to Steam--]]]:format(mod.title)
      if not copy_files then
        upload_msg = Concat(upload_msg,"\n",S[302535920001262--[["""AppData/ModUpload"" folder is empty and waiting for insert."--]]])
      end
      if diff_author then
        upload_msg = Concat(upload_msg,"\n\n",S[302535920001263--[["Mod author name is different from your name, do you have permission to upload this mod?"--]]])
      end

      local function CallBackFunc(answer)
        if not answer then
          return
        end

        MsgPopup(
          5452--[[START--]],
          302535920000367--[[Mod Upload--]]
        )

        -- add new mod
        local err,item_id,bShowLegalAgreement
        if Platform.steam then
          if mod.steam_id ~= 0 then
            local exists
            local appId = SteamGetAppId()
            local userId = SteamGetUserId64()
            err, exists = AsyncSteamWorkshopUserOwnsItem(userId, appId, mod.steam_id)
            if not err and not exists then
              mod.steam_id = 0
            end
          end
          if mod.steam_id == 0 then
            err,item_id,bShowLegalAgreement = AsyncSteamWorkshopCreateItem()
            mod.steam_id = item_id or nil
          end
        end

        -- update mod, and copy files to ModUpload
        if copy_files and not blank_mod and not err then
          local files
          -- I prefer to update this manually
          if not ChoGGi.Testing then
            mod:SaveDef()
          end
          mod:SaveItems()
    --~       AsyncDeletePath(dest)
    --~       AsyncCreatePath(dest)
          err, files = AsyncListFiles(mod.path, "*", "recursive,relative")
          if not err then
            for i = 1, #files or "" do
              local dest_file = Concat(dest,files[i])
              local dir = SplitPath(dest_file)
              AsyncCreatePath(dir)
              err = AsyncCopyFile(Concat(mod.path,files[i]), dest_file, "raw")
            end
          end
        end

        -- update mod on workshop
        if not err or blank_mod then
          local os_dest = ConvertToOSPath(dest)
          if Platform.steam then
            err = AsyncSteamWorkshopUpdateItem{
              item_id = mod.steam_id,
              title = mod.title,
              description = mod.description,
              tags = mod:GetTags(),
              content_os_folder = os_dest,
              image_os_filename = mod.image ~= "" and ConvertToOSPath(mod.image) or ""
            }
          else
            err = "no steam"
          end
        end

        -- show id in console (figure out a decent way to add this to metadat.lua)
        if item_id then
          print(mod.title,": ",S[1000107--[[Mod--]]]," ",S[1000021--[[Steam ID--]]],": ",item_id)
        end
        local msg, title
        if err and not blank_mod then
          msg = S[1000013--[[Mod %s was not uploaded to Steam. Error: %s--]]]:format(mod.title,err)
          title = S[1000592--[[Error--]]]
        else
          msg = S[1000014--[[Mod %s was successfully uploaded to Steam!--]]]:format(mod.title)
          title = S[1000015--[[Success--]]]
        end

        -- update mod log and print it to console log
        ModLog(Concat("\n",msg,": ",mod.title))
        print(S[302535920001265--[[ModMessageLog--]]],":\n",ModMessageLog)

        -- let user know if we're good or not
        ChoGGi.ComFuncs.MsgWait(
          msg,
          Concat(title,": ",mod.title),
          "UI/Common/mod_steam_workshop.tga"
        )

        -- remove upload folder
        AsyncDeletePath(dest)
      end

      ChoGGi.ComFuncs.QuestionBox(
        upload_msg,
        CallBackFunc,
        mod.title,
        nil,
        nil,
        "UI/Common/mod_steam_workshop.tga"
      )
    end) -- ModUploadThread
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = 302535920000367--[[Mod Upload--]],
    check1 = 302535920001258--[[Copy Files--]],
    check1_hint = 302535920001259--[["Copies all mod files to AppData/ModUpload, uncheck to copy files manually."--]],
    check1_checked = true,
    check2 = 302535920001260--[[Blank Mod--]],
    check2_hint = 302535920001261--[["Uploads a blank private mod to Steam Workshop, and prints Workshop id in log."--]],
  }
end

function ChoGGi.MenuFuncs.EditECMSettings()
  local ChoGGi = ChoGGi
  -- make sure any changed settings are current
  ChoGGi.SettingFuncs.WriteSettings()
  -- load up settings file in the editor
  local dialog = ChoGGi_MultiLineText:new({}, terminal.desktop,{
    text = ChoGGi.SettingFuncs.ReadSettings(),
    hint_ok = 302535920001244--[["Saves settings to file, and applies any changes."--]],
    hint_cancel = 302535920001245--[[Abort without touching anything.--]],
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

      MsgPopup(302535920001070--[[Restart to take effect.--]])
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(S[302535920000466--[["This will disable the cheats menu, cheats panel, and all hotkeys.
CheatMenuModSettings.lua > DisableECM to re-enable them."--]]],"\n\n",S[302535920001070--[[Restart to take effect.--]]]),
    CallBackFunc,
    302535920000142--[[Disable--]]
  )
end

function ChoGGi.MenuFuncs.CheatsMenu_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.UserSettings.ShowCheatsMenu = not ChoGGi.UserSettings.ShowCheatsMenu
  ChoGGi.SettingFuncs.WriteSettings()
  UAMenu.ToggleOpen()
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
  MsgPopup(
    S[302535920001068--[[%s: Interface in screenshots.--]]]:format(ChoGGi.UserSettings.ShowInterfaceInScreenshots),
    302535920001069--[[Interface--]]
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

      MsgPopup(
        302535920001070--[[Restart to take effect.--]],
        302535920001084--[[Reset--]],
        default_icon
      )
    end
  end
  ChoGGi.ComFuncs.QuestionBox(
    Concat(S[302535920001072--[[Are you sure you want to reset ECM settings?

Old settings are saved as %s--]]]:format(old),"\n\n",S[302535920001070--[[Restart to take effect.--]]]),
    CallBackFunc,
    Concat(S[302535920001084--[[Reset--]]],"!")
  )
end

function ChoGGi.MenuFuncs.SignsInterface_Toggle()
  ToggleSigns()
  MsgPopup(
    302535920001074--[[Sign, sign, everywhere a sign.
Blockin' out the scenery, breakin' my mind.
Do this, don't do that, can't you read the sign?--]],
    302535920001075--[[Signs--]],
    nil,
    true
  )
end

function ChoGGi.MenuFuncs.OnScreenHints_Toggle()
  SetHintNotificationsEnabled(not HintsEnabled)
  UpdateOnScreenHintDlg()
  MsgPopup(
    tostring(HintsEnabled),
    4248--[[Hints--]]
  )
end

function ChoGGi.MenuFuncs.OnScreenHints_Reset()
  g_ShownOnScreenHints = {}
  UpdateOnScreenHintDlg()
  MsgPopup(
    302535920001076--[[Hints Reset!--]],
    4248--[[Hints--]]
  )
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
    S[302535920001077--[[%s: Bye bye hints--]]]:format(ChoGGi.UserSettings.DisableHints),
    4248--[[Hints--]],
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
    S[302535920001078--[["Hover mouse over menu item to get description and enabled status
If there isn't a status then it's likely a list of options to choose from

For any issues; please report them to my Github/Steam/NexusMods page, or email %s"--]]]:format(ChoGGi.email),
    487939677892--[[Help--]]
  )
end

