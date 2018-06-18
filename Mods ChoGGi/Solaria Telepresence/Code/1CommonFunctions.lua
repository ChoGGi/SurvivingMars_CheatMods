--See LICENSE for terms

local Concat = SolariaTelepresence.ComFuncs.Concat --added in Init.lua

local pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable = pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable
local table,debug,string = table,debug,string

local _InternalTranslate = _InternalTranslate
local AsyncCreatePath = AsyncCreatePath
local AsyncFileDelete = AsyncFileDelete
local AsyncFileOpen = AsyncFileOpen
local AsyncFileRename = AsyncFileRename
local AsyncFileToString = AsyncFileToString
local AsyncListFiles = AsyncListFiles
local AsyncRand = AsyncRand
local AsyncStringToFile = AsyncStringToFile
local box = box
local CreateGameTimeThread = CreateGameTimeThread
local CreateRealTimeThread = CreateRealTimeThread
local CreateRolloverWindow = CreateRolloverWindow
local DoneObject = DoneObject
local FilterObjects = FilterObjects
local GetInGameInterface = GetInGameInterface
local GetObjects = GetObjects
local GetTerrainCursor = GetTerrainCursor
local GetXDialog = GetXDialog
local HandleToObject = HandleToObject
local IsBox = IsBox
local IsObjlist = IsObjlist
local IsPoint = IsPoint
local IsValid = IsValid
local Msg = Msg
local OnScreenNotificationPreset = OnScreenNotificationPreset
local OpenXDialog = OpenXDialog
local point = point
local RGB = RGB
local ShowConsoleLog = ShowConsoleLog
local Sleep = Sleep
local TechDef = TechDef
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey
local ViewPos = ViewPos
local WaitMarsQuestion = WaitMarsQuestion
local WaitPopupNotification = WaitPopupNotification

local T = T -- T replaced below
local guic = guic

local UserActions_SetMode = UserActions.SetMode
local terminal_GetMousePos = terminal.GetMousePos
local UIL_MeasureText = UIL.MeasureText
local terrain_IsPointInBounds = terrain.IsPointInBounds

local g_Classes = g_Classes

-- I want a translate func to always return a string
function SolariaTelepresence.ComFuncs.Trans(...)
  local trans
  local vararg = {...}
  --just in case a
  pcall(function()
    if type(vararg[1]) == "userdata" then
      trans = _InternalTranslate(table.unpack(vararg))
    else
      trans = _InternalTranslate(T(vararg))
    end
  end)
  --just in case b
  if type(trans) ~= "string" then
    if type(vararg[2]) == "string" then
      return vararg[2]
    end
    --we don't translate this one (just in case c)
    return Concat("Missing locale string id: ",vararg[1])
  end
  return trans
end
local T = SolariaTelepresence.ComFuncs.Trans


-- backup orginal function for later use (checks if we already have a backup, or else problems)
function SolariaTelepresence.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local SolariaTelepresence = SolariaTelepresence
  if Func then
    local newname = Concat(ClassOrFunc,"_",Func)
    if not SolariaTelepresence.OrigFuncs[newname] then
      SolariaTelepresence.OrigFuncs[newname] = _G[ClassOrFunc][Func]
    end
  else
    if not SolariaTelepresence.OrigFuncs[ClassOrFunc] then
      SolariaTelepresence.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end


-- shows a popup msg with the rest of the notifications
function SolariaTelepresence.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  local SolariaTelepresence = SolariaTelepresence
  Icon = type(tostring(Icon):find(".tga")) == "number" and Icon or Concat(SolariaTelepresence.MountPath,"TheIncal.tga")
  --eh, it needs something for the id, so I can fiddle with it later
  local id = AsyncRand()
  --build our popup
  local timeout = 10000
  if Size then
    timeout = 30000
  end
  local params = {
    expiration=timeout, --{expiration=99999999999999999}
    --dismissable=false,
  }
  local cycle_objs = params.cycle_objs
  local dlg = GetXDialog("OnScreenNotificationsDlg")
  if not dlg then
    if not GetInGameInterface() then
      return
    end
    dlg = OpenXDialog("OnScreenNotificationsDlg", GetInGameInterface())
  end
  local data = {
    id = id,
    --name = id,
    title = tostring(Title or ""),
    text = tostring(Msg or T(3718--[[NONE--]])),
    image = Icon
  }
  table.set_defaults(data, params)
  table.set_defaults(data, OnScreenNotificationPreset)

  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
    --large amount of text option
  end)
end

-- well that's the question isn't it?
function SolariaTelepresence.ComFuncs.QuestionBox(Msg,Function,Title,Ok,Cancel)
  pcall(function()
    CreateRealTimeThread(function()
      --fire callback if user clicks ok
      local answer = WaitMarsQuestion(nil,
        tostring(Title or ""),
        tostring(Msg or ""),
        tostring(Ok or T(6878--[[OK--]])),
        tostring(Cancel or T(6879--[[Cancel--]]))
      )
      if answer == "ok" then
        Function(true)
      else
        Function()
      end
    end)
  end)
end

function SolariaTelepresence.ComFuncs.FilterFromTable(Table,ExcludeList,IncludeList,Type)
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

function SolariaTelepresence.ComFuncs.CompareTableValue(a,b,sName)
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
function SolariaTelepresence.ComFuncs.RetProperType(Value)
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

-- returns object name or at least always some string
function SolariaTelepresence.ComFuncs.RetName(obj)
  if obj == _G then
    return "_G"
  end
  local name
  if type(obj) == "table" then
    --translated name
    if type(obj.display_name) == "userdata" then
      return T(obj.display_name)
    elseif IsObjlist(obj) then
      return "objlist"
      --return the name of the first one?
--~       return SolariaTelepresence.ComFuncs.RetName(obj[1])
    end
    name = getmetatable(obj)
    if name and type(name.class) == "string" then
      return name.class
    end
    name = obj.encyclopedia_id or obj.class
  end

  if type(name) == "string" then
    return name
  end

  --falling back baby (lags the shit outta kansas if this is a large objlist)
  return tostring(obj)
end

--[[
called below from FireFuncAfterChoice

CustomType=1 : updates selected item with custom value type, hide ok/cancel buttons as they don't do jack, dbl click opens colour changer, and sends back all items
CustomType=2 : colour selector
CustomType=3 : updates selected item with custom value type, and sends back selected item.
CustomType=4 : updates selected item with custom value type, and sends back all items
CustomType=5 : for Lightmodel: show colour selector when listitem.editor = color,pressing check2 applies the lightmodel without closing dialog, dbl rightclick shows lightmodel lists and lets you pick one to use in new window
CustomType=6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)

SolariaTelepresence.ComFuncs.OpenInListChoice({
  callback = CallBackFunc,
  items = ItemList,
  title = "TitleBar",
  hint = Concat("Current",": ",hint),
  multisel = MultiSel,
  custom_type = CustomType,
  custom_func = CustomFunc,
  check1 = "Check1",
  check1_hint = "Check1Hint",
  check2 = "Check2",
  check2_hint = "Check2Hint",
})

--]]
function SolariaTelepresence.ComFuncs.OpenInListChoice(Table)
  local SolariaTelepresence = SolariaTelepresence
  if not Table or (Table and type(Table) ~= "table" or not Table.callback or not Table.items) then
    SolariaTelepresence.ComFuncs.MsgPopup(T(302535920000013--[[This shouldn't happen... Well shit something's bork bork bork.--]]),T(6774--[[Error--]]))
    return
  end

  --sort table by display text
  local sortby = Table.sortby or "text"
  table.sort(Table.items,
    function(a,b)
      return SolariaTelepresence.ComFuncs.CompareTableValue(a,b,sortby)
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not Table.custom_type then
    --insert blank item for adding custom value
    Table.items[#Table.items+1] = {text = "",hint = "",value = false}
  end

  CreateRealTimeThread(function()
--~     local option = SolariaTelepresence.ComFuncs.OpenInListChoice(Table)
    local dlg = g_Classes.SolariaTelepresence_ListChoiceCustomDialog:new()

    if not dlg then
      return
    end

    --title text
    dlg.idCaption:SetText(Table.title)
    --list
    dlg.idList:SetContent(Table.items)

    --fiddling with custom value
    if Table.custom_type then
      dlg.idEditValue.auto_select_all = false
      dlg.CustomType = Table.custom_type
      if Table.custom_type == 2 or Table.custom_type == 5 then
        dlg.idList:SetSelection(1, true)
        dlg.sel = dlg.idList:GetSelection()[#dlg.idList:GetSelection()]
        dlg.idEditValue:SetText(tostring(dlg.sel.value))
        dlg:UpdateColourPicker()
        if Table.custom_type == 2 then
          dlg:SetWidth(750)
          dlg.idColorHSV:SetVisible(true)
          dlg.idColorCheckAir:SetVisible(true)
          dlg.idColorCheckWater:SetVisible(true)
          dlg.idColorCheckElec:SetVisible(true)
        end
      end
    end

    if Table.custom_func then
      dlg.Func = Table.custom_func
    end

    if Table.multisel then
      dlg.idList.multiple_selection = true
      if type(Table.multisel) == "number" then
        --select all of number
        for i = 1, Table.multisel do
          dlg.idList:SetSelection(i, true)
        end
      end
    end

    --setup checkboxes
    if not Table.check1 and not Table.check2 then
      dlg.idCheckBox1:SetVisible(false)
      dlg.idCheckBox2:SetVisible(false)
    else
      dlg.idList:SetSize(point(390, 310))

      if Table.check1 then
        dlg.idCheckBox1:SetText(Table.check1)
        dlg.idCheckBox1:SetHint(Table.check1_hint)
      else
        dlg.idCheckBox1:SetVisible(false)
      end
      if Table.check2 then
        dlg.idCheckBox2:SetText(Table.check2)
        dlg.idCheckBox2:SetHint(Table.check2_hint)
      else
        dlg.idCheckBox2:SetVisible(false)
      end
    end
    --where to position dlg
    dlg:SetPos(terminal_GetMousePos())

    --focus on list
    dlg.idList:SetFocus()
    --dlg.idList:SetSelection(1, true)

    --are we showing a hint?
    if Table.hint then
      dlg.idList:SetHint(Table.hint)
      dlg.idOK:SetHint(Concat(dlg.idOK:GetHint(),"\n\n\n",Table.hint))
    end

    --hide ok/cancel buttons as they don't do jack
    if Table.custom_type == 1 then
      dlg.idOK:SetVisible(false)
      dlg.idClose:SetVisible(false)
    end

    --waiting for choice
    local option = dlg:Wait()

    if option and #option > 0 then
      Table.callback(option)
    end

  end)
end

function SolariaTelepresence.ComFuncs.CompareTableValue(a,b,sName)
  if not a and not b then
    return
  end
  if type(a[sName]) == type(b[sName]) then
    return a[sName] < b[sName]
  else
    return tostring(a[sName]) < tostring(b[sName])
  end
end

function SolariaTelepresence.ComFuncs.DialogAddCaption(parent,Table)
  parent.idCaption = g_Classes.StaticText:new(parent)
  parent.idCaption:SetPos(Table.pos)
  parent.idCaption:SetSize(Table.size)
  parent.idCaption:SetHSizing("AnchorToLeft")
  parent.idCaption:SetBackgroundColor(0)
  parent.idCaption:SetFontStyle("Editor14Bold")
  parent.idCaption:SetTextPrefix(Table.prefix or "<center>")
  parent.idCaption.HandleMouse = false
end

function SolariaTelepresence.ComFuncs.DialogAddCloseX(parent,func)
  parent.idCloseX = g_Classes.Button:new(parent)
  parent.idCloseX:SetHSizing("AnchorToRight")
  parent.idCloseX:SetPos(parent:GetPos() + point(parent:GetSize():x() - 21, 3))
  parent.idCloseX:SetSize(point(18, 18))
  parent.idCloseX:SetImage("CommonAssets/UI/Controls/Button/Close.tga")
  parent.idCloseX:SetHint(T(1011--[[Close--]]))
  parent.idCloseX.OnButtonPressed = func or function()
    parent:delete()
  end
end

function SolariaTelepresence.ComFuncs.RetButtonTextSize(text,font)
  font = font and FontStyles.GetFontId(font) or FontStyles.GetFontId("Editor14Bold")
  local x,y = UIL_MeasureText(text or "", font)
  return point(x + 24,y + 4) --button padding
end

function SolariaTelepresence.ComFuncs.RetCheckTextSize(text,font)
  font = font and FontStyles.GetFontId(font) or FontStyles.GetFontId("Editor14Bold")
  local x,_ = UIL_MeasureText(text or "", font)
  return point(x + 24,17) --button padding
end

function SolariaTelepresence.ComFuncs.RetProperType(Value)
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
