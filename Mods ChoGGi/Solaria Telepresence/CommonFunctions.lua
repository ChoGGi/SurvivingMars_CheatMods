--keep everything stored in
ChoGGiX = {
  email = "SolariaTelepresence@choggi.org",
  id = "ChoGGi_SolariaTelepresence",
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --/Code/*Menu.lua and /Code/*Func.lua
  MenuFuncs = {},
  --OnMsgs.lua
  MsgFuncs = {},
  --InfoPaneCheats.lua
  InfoFuncs = {},
  --Defaults.lua
  SettingFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {},
  --settings that are saved to SettingsFile
  UserSettings = {
    RemoveBuildingLimits = true
  },
}

ChoGGiX.ModPath = Mods[ChoGGiX.id].path

--backup orginal function for later use (checks if we already have a backup, or else problems)
function ChoGGiX.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local ChoGGiX = ChoGGiX
  if Func then
    local newname = ClassOrFunc .. "_" .. Func
    if not ChoGGiX.OrigFuncs[newname] then
      ChoGGiX.OrigFuncs[newname] = _G[ClassOrFunc][Func]
    end
  else
    if not ChoGGiX.OrigFuncs[ClassOrFunc] then
      ChoGGiX.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

function ChoGGiX.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  pcall(function()
    --returns translated text corresponding to number if we don't do tostring for numbers
    Msg = tostring(Msg)
    --Title = tostring(Title)
    Title = type(Title) == "string" and Title or ChoGGiX.CodeFuncs.Trans(1000016)
    Icon = type(tostring(Icon):find(".tga")) == "number" and Icon or "UI/Icons/Notifications/placeholder.tga"
    --local id = "ChoGGiX_" .. AsyncRand()
    local id = AsyncRand()
    local timeout = 10000
    if Size then
      timeout = 25000
    end
    if type(AddCustomOnScreenNotification) == "function" then --if we called it where there ain't no UI
      CreateRealTimeThread(function()
        AddCustomOnScreenNotification(
          id,Title,Msg,Icon,nil,{expiration=timeout}
          --id,Title,Msg,Icon,nil,{expiration=99999999999999999}
        )
        --since I use AsyncRand for the id, I don't want this getting too large.
        g_ShownOnScreenNotifications[id] = nil
        --large amount of text option
        if Size then
          --add some custom settings this way, till i figure out hwo to add them as params
          local osDlg = GetXDialog("OnScreenNotificationsDlg")[1]
          local popup
          for i = 1, #osDlg do
            if osDlg[i].notification_id == id then
              popup = osDlg[i]
              break
            end
          end
          --remove text limit
          --popup.idText.Shorten = false
          --popup.idText.MaxHeight = nil
          popup.idText.Margins = box(0,0,0,-500)
          --resize
          popup.idTitle.Margins = box(0,-20,0,0)
          --image
          Sleep(0)
          popup[1].scale = point(2800,2600)
          popup[1].Margins = box(-5,-30,0,-5)
          --update dialog
          popup:InvalidateMeasure()
  --parent ex(GetXDialog("OnScreenNotificationsDlg")[1])
  --osn GetXDialog("OnScreenNotificationsDlg")[1][1]
        end
      end)
    end
  end)
end

function ChoGGiX.ComFuncs.QuestionBox(Msg,Function,Title,Ok,Cancel)
  pcall(function()
    Msg = Msg or "Empty"
    Ok = Ok or "Ok"
    Cancel = Cancel or "Cancel"
    Title = Title or "Placeholder"
    CreateRealTimeThread(function()
      if "ok" == WaitQuestion(nil,
        Title,
        Msg,
        Ok,
        Cancel
      ) then
          Function()
      end
    end)
  end)
end

function ChoGGiX.ComFuncs.FilterFromTable(Table,ExcludeList,IncludeList,Type)
  return FilterObjects({
    filter = function(Obj)
      if ExcludeList or IncludeList then
        if ExcludeList and IncludeList then
          if not ExcludeList[Obj[Type]] then
            return Obj
          elseif IncludeList[Obj[Type]] then
            return Obj
          end
        elseif ExcludeList then
          if not ExcludeList[Obj[Type]] then
            return Obj
          end
        elseif IncludeList then
          if IncludeList[Obj[Type]] then
            return Obj
          end
        end
      else
        if Obj[Type] then
          return Obj
        end
      end
    end
  },Table)
end

function ChoGGiX.ComFuncs.MsgPopup(Msg,Title,Icon)
  pcall(function()
    --returns translated text corresponding to number if we don't do tostring for numbers
    Msg = tostring(Msg)
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    local id = AsyncRand()
    local timeout = 8000
    if type(AddCustomOnScreenNotification) == "function" then --if we called it where there ain't no UI
      CreateRealTimeThread(function()
        AddCustomOnScreenNotification(
          id,Title,Msg,Icon,nil,{expiration=timeout}
        )
        --since I use AsyncRand for the id, I don't want this getting too large.
        g_ShownOnScreenNotifications[id] = nil
      end)
    end
  end)
end
function ChoGGiX.ComFuncs.CompareTableValue(a,b,sName)
  if not a and not b then
    return
  end
  if type(a[sName]) == type(b[sName]) then
    return a[sName] < b[sName]
  else
    return tostring(a[sName]) < tostring(b[sName])
  end
end

--tries to convert "65" to 65, "boolean" to boolean, "nil" to nil
function ChoGGiX.ComFuncs.RetProperType(Value)
  --number?
  local num = tonumber(Value)
  if num then
    return num
  end
  --stringy boolean
  if Value == "true" then
    return true
  elseif Value == "false" then
    return false
  end
  if Value == "nil" then
    return
  end
  --then it's a string (probably)
  return Value
end
