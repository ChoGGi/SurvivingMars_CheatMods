-- See LICENSE for terms

local Concat = ChangeObjectColour.ComFuncs.Concat --added in Init.lua

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

function ChangeObjectColour.ComFuncs.Trans(...)
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
local T = ChangeObjectColour.ComFuncs.Trans

-- shows a popup msg with the rest of the notifications
function ChangeObjectColour.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  local ChangeObjectColour = ChangeObjectColour
  Icon = type(tostring(Icon):find(".tga")) == "number" and Icon or ""
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
    if Size then
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
      --update dialog size
      popup:InvalidateMeasure()
--parent ex(GetXDialog("OnScreenNotificationsDlg")[1])
--osn GetXDialog("OnScreenNotificationsDlg")[1][1]
      --i don't care for sounds
      --[[
      if type(params.fx_action) == "string" and params.fx_action ~= "" then
        PlayFX(params.fx_action)
      end
      --]]
    end
  end)
end

-- change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function ChangeObjectColour.ComFuncs.UserAddActions(ActionsToAdd)
if ChangeObjectColour.Temp.Testing then
  if type(ActionsToAdd) == "string" then
    print("ActionsToAdd",ActionsToAdd)
  end
end
  for k, v in pairs(ActionsToAdd) do
    if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
      if v.key ~= nil and v.key ~= "" then
        if type(v.key) == "table" then
          local keys = v.key
          if #keys <= 0 then
            v.description = ""
          else
            v.description = Concat(v.description," (",keys[1])
            for i = 2, #keys do
              v.description = Concat(v.description," ",T(302535920000165--[[or--]])," ",keys[i])
            end
            v.description = Concat(v.description,")")
          end
        else
          v.description = Concat(tostring(v.description)," (",v.key,")")
        end
      end
      v.id = k
      v.idx = g_idxAction
      g_idxAction = g_idxAction + 1
      UserActions.Actions[k] = v
    else
      UserActions.RejectedActions[k] = v
    end
  end
  UserActions_SetMode(UserActions.mode)
end

function ChangeObjectColour.ComFuncs.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  local ChangeObjectColour = ChangeObjectColour
  if Menu then
    Menu = Concat("/",tostring(Menu))
  end
  local name = "NOFUNC"
  --add name to action id
  if Action then
    local debug_info = debug.getinfo(Action, "Sn")
    local text = tostring(Concat(debug_info.short_src,"(",debug_info.linedefined,")"))
    name = text:gsub(ChangeObjectColour.ModPath,"")
    name = name:gsub(ChangeObjectColour.ModPath:gsub("AppData","...ata"),"")
    name = name:gsub(ChangeObjectColour.ModPath:gsub("AppData","...a"),"")
    --
  elseif ChangeObjectColour.Temp.Testing and Key ~= "Skip" then
    ChangeObjectColour.Temp.StartupMsgs[#ChangeObjectColour.Temp.StartupMsgs+1] = Concat("<color 255 100 100>",T(302535920000000--[[Expanded Cheat Menu--]]),"</color><color 0 0 0>: </color><color 128 255 128>",T(302535920000166--[[BROKEN FUNCTION--]]),": </color>",Menu)
  end


  --T(Number from Game.csv)
  --UserActions.AddActions({
  --UserActions.RejectedActions()
  ChangeObjectColour.ComFuncs.UserAddActions({
    [Concat("ChangeObjectColour_",name,"-",AsyncRand())] = {
      menu = Menu,
      action = Action,
      key = Key,
      description = Des or "", --errors if not a string
      icon = Icon,
      toolbar = Toolbar,
      mode = Mode,
      xinput = xInput,
      toolbar_default = ToolbarDefault
    }
  })
end

function ChangeObjectColour.ComFuncs.FilterFromTable(Table,ExcludeList,IncludeList,Type)
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

-- returns object name or at least always some string
function ChangeObjectColour.ComFuncs.RetName(obj)
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
--~       return ChangeObjectColour.ComFuncs.RetName(obj[1])
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

ChangeObjectColour.ComFuncs.OpenInListChoice({
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
function ChangeObjectColour.ComFuncs.OpenInListChoice(Table)
  local ChangeObjectColour = ChangeObjectColour
  if not Table or (Table and type(Table) ~= "table" or not Table.callback or not Table.items) then
    ChangeObjectColour.ComFuncs.MsgPopup(T(302535920000013--[[This shouldn't happen... Well shit something's bork bork bork.--]]),T(6774--[[Error--]]))
    return
  end

  --sort table by display text
  local sortby = Table.sortby or "text"
  table.sort(Table.items,
    function(a,b)
      return ChangeObjectColour.ComFuncs.CompareTableValue(a,b,sortby)
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not Table.custom_type then
    --insert blank item for adding custom value
    Table.items[#Table.items+1] = {text = "",hint = "",value = false}
  end

  CreateRealTimeThread(function()
--~     local option = ChangeObjectColour.ComFuncs.OpenInListChoice(Table)
    local dlg = g_Classes.ChangeObjectColour_ListChoiceCustomDialog:new()

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

function ChangeObjectColour.ComFuncs.CompareTableValue(a,b,sName)
  if not a and not b then
    return
  end
  if type(a[sName]) == type(b[sName]) then
    return a[sName] < b[sName]
  else
    return tostring(a[sName]) < tostring(b[sName])
  end
end

function ChangeObjectColour.ComFuncs.DialogAddCaption(parent,Table)
  parent.idCaption = g_Classes.StaticText:new(parent)
  parent.idCaption:SetPos(Table.pos)
  parent.idCaption:SetSize(Table.size)
  parent.idCaption:SetHSizing("AnchorToLeft")
  parent.idCaption:SetBackgroundColor(0)
  parent.idCaption:SetFontStyle("Editor14Bold")
  parent.idCaption:SetTextPrefix(Table.prefix or "<center>")
  parent.idCaption.HandleMouse = false
end

function ChangeObjectColour.ComFuncs.DialogAddCloseX(parent,func)
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

function ChangeObjectColour.ComFuncs.RetButtonTextSize(text,font)
  font = font and FontStyles.GetFontId(font) or FontStyles.GetFontId("Editor14Bold")
  local x,y = UIL_MeasureText(text or "", font)
  return point(x + 24,y + 4) --button padding
end

function ChangeObjectColour.ComFuncs.RetCheckTextSize(text,font)
  font = font and FontStyles.GetFontId(font) or FontStyles.GetFontId("Editor14Bold")
  local x,_ = UIL_MeasureText(text or "", font)
  return point(x + 24,17) --button padding
end

function ChangeObjectColour.ComFuncs.RetProperType(Value)
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
