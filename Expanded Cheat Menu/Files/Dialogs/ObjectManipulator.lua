-- See LICENSE for terms

-- used to do minimal editing of objects (or all of same type)

if g_Classes.ChoGGi_ObjectManipulator then
  return
end

local Concat = ChoGGi.ComFuncs.Concat
local TableConcat = ChoGGi.ComFuncs.TableConcat
local T = ChoGGi.ComFuncs.Trans
local S = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName

local pcall,tostring,type = pcall,tostring,type
local table = table

local IsPoint = IsPoint
local Min = Min
local ObjectClass = ObjectClass

local g_traceMeta = g_traceMeta

--ex(ChoGGi.ObjectManipulator_Dlg.idAutoRefresh)
--ex(ChoGGi.ObjectManipulator_Dlg)

-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_ObjectManipulator = {
  __parents = {"FrameWindow"},
  ZOrder = zorder,
  choices = {},
  sel = false,
  obj = false,
  MinSize = point(50, 50),
  translate = false,
  refreshing = false,
  page = 1,
  show_times = "relative",
}

function ChoGGi_ObjectManipulator:Init()
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes
  local point = point

  --element pos is based on
  self:SetPos(point(0,0))

  local dialog_width = 650
  local dialog_height = 450
  self:SetSize(point(dialog_width, dialog_height))
  self:SetMovable(true)

  local border = 4
  local element_y
  local element_x
  dialog_width = dialog_width - border * 2
  local dialog_left = border

  ChoGGi.ComFuncs.DialogAddCloseX(
    self,
    function()
      self:delete(self.idEditValue:GetText())
    end
  )
  ChoGGi.ComFuncs.DialogAddCaption(self,{
    prefix = Concat(S[302535920000471--[[Object Manipulator--]]],": "),
    pos = point(25, border),
    size = point(dialog_width-self.idCloseX:GetSize():x(), 22)
  })

  element_y = border / 2 + self.idCaption:GetPos():y() + self.idCaption:GetSize():y()

  local title = S[302535920000084--[[Auto-Refresh--]]]
  self.idAutoRefresh = g_Classes.CheckButton:new(self)
  self.idAutoRefresh:SetPos(point(dialog_left, element_y))
  self.idAutoRefresh:SetSize(ChoGGi.ComFuncs.RetCheckTextSize(title))
  self.idAutoRefresh:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idAutoRefresh:SetText(title)
  self.idAutoRefresh:SetHint(S[302535920000091--[[Auto-refresh list every second (turn off to edit values).--]]])
  self.idAutoRefresh:SetButtonSize(point(16, 16))
  --add check for auto-refresh
  function self.idAutoRefresh.button.OnButtonPressed()
    local Sleep = Sleep
    self.refreshing = self.idAutoRefresh:GetState()
    CreateRealTimeThread(function()
      while self.refreshing do
        self:UpdateListContent(self.obj)
        Sleep(1000)
      end
    end)
  end

  element_y = border / 2 + self.idAutoRefresh:GetPos():y() + self.idAutoRefresh:GetSize():y()

  title = S[1000220--[[Refresh--]]]
  self.idRefresh = g_Classes.Button:new(self)
  self.idRefresh:SetPos(point(dialog_left, element_y))
  self.idRefresh:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idRefresh:SetText(title)
  self.idRefresh:SetHint(S[302535920000092--[[Refresh list.--]]])
  --refresh the list...
  function self.idRefresh.OnButtonPressed()
    self:UpdateListContent(self.obj)
  end

  element_x = border * 2 + self.idRefresh:GetPos():x() + self.idRefresh:GetSize():x()

  title = S[302535920000093--[[Goto Obj--]]]
  self.idGoto = g_Classes.Button:new(self)
  self.idGoto:SetPos(point(element_x, element_y))
  self.idGoto:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idGoto:SetText(title)
  self.idGoto:SetHint(S[302535920000094--[[View object on map.--]]])
  --move viewpoint to obj
  function self.idGoto.OnButtonPressed()
    ViewAndSelectObject(self.obj)
  end

  element_x = border * 2 + self.idGoto:GetPos():x() + self.idGoto:GetSize():x()

  title = S[398847925160--[[New--]]]
  self.idAddNew = g_Classes.Button:new(self)
  self.idAddNew:SetPos(point(element_x, element_y))
  self.idAddNew:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idAddNew:SetText(title)
  --open dialog to get new name
  function self.idAddNew.OnButtonPressed()
    local sel_name
    local sel_value
    if self.sel then
      sel_name = self.sel.text
      sel_value = self.sel.value
    else
      sel_name = S[3718--[[NONE--]]]
      sel_value = false
    end
    local ItemList = {
      {text = S[302535920000095--[[New Entry--]]],value = sel_name,hint = 302535920000096--[[Enter the name of the new entry to be added.--]]},
      {text = S[302535920000097--[[New Value--]]],value = sel_value,hint = 302535920000098--[[Set the value of the new entry to be added.--]]},
    }

    local function CallBackFunc(choice)
      local value = choice[1].value
      if not value then
        return
      end
      --add it to the actual object
      self.obj[tostring(value)] = ChoGGi.ComFuncs.RetProperType(choice[2].value)
      --refresh list
      self:UpdateListContent(self.obj)
    end

    ChoGGi.ComFuncs.OpenInListChoice{
      callback = CallBackFunc,
      items = ItemList,
      title = S[302535920000095--[[New Entry--]]],
      custom_type = 4,
    }
  end

  element_x = border * 2 + self.idAddNew:GetPos():x() + self.idAddNew:GetSize():x()

  title = S[302535920000099--[[Apply To All--]]]
  self.idApplyAll = g_Classes.Button:new(self)
  self.idApplyAll:SetPos(point(element_x, element_y))
  self.idApplyAll:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idApplyAll:SetText(title)
  self.idApplyAll:SetHint(S[302535920000100--[[Apply selected value to all objects of the same type.--]]])
  --idApplyAll
  function self.idApplyAll.OnButtonPressed()
    if not self.sel then
      return
    end
    local value = self.sel.value
    if value then
      local objs = GetObjects{class = self.obj.class}
      for i = 1, #objs do
        objs[i][self.sel.text] = ChoGGi.ComFuncs.RetProperType(value)
      end
    end
  end

  element_y = border / 2 + self.idApplyAll:GetPos():y() + self.idApplyAll:GetSize():y()

  self.idList = g_Classes.List:new(self)
  self.idList:SetPos(point(dialog_left, element_y))
  self.idList:SetSize(point(dialog_width,dialog_height - element_y - border - 28))
  self.idList:SetHSizing("Resize")
  self.idList:SetVSizing("Resize")
  self.idList:SetFontStyle("Editor14Bold")
  self.idList:SetRolloverFontStyle("Editor14")
  self.idList:SetSelectionFontStyle("Editor14Bold")
  self.idList:SetShowPartialItems(true)
  self.idList:SetScrollBar(true)
  self.idList:SetScrollAutohide(true)
  self.idList:SetSpacing(point(8, 2))
  self.idList:SetSelectionBackground(RGB(100, 100, 100))
  self.idList:SetBackgroundColor(RGB(50, 50, 50))
  --hook into SetContent so we can add OnSetState to each listitem to show hints
  self.idList.orig_SetContent = self.idList.SetContent
  function self.idList:SetContent(items)
    self.orig_SetContent(self,items)
    local listitems = self.item_windows
    for i = 1, #listitems do
      local listitem = listitems[i]
      listitem.orig_OnSetState = listitem.OnSetState
      function listitem:OnSetState(list, item, rollovered, selected)
        self.orig_OnSetState(self,list, item, rollovered, selected)
        if rollovered or selected then
          local hint = {item.text}
          if item.value then
            hint[#hint+1] = ": "
            hint[#hint+1] = item.value
          end
          if item.hint then
            hint[#hint+1] = "\n\n"
            hint[#hint+1] = item.hint
          end
          hint[#hint+1] = "\n\n"
          hint[#hint+1] = S[302535920000101--[["You can only change strings/numbers/booleans (to remove set value to nil).
Value is updated while typing.\nPress Enter to refresh list (update names).

Double click selected item to open in new manipulator."--]]]
          self.parent:SetHint(TableConcat(hint))
          CreateRolloverWindow(self.parent, TableConcat(hint), true)
        end
      end
    end
  end
  --override ListItem:OnCreate
  function self.idList:ItemCreate(item_window, item)
    if not item_window then
      return
    end
    self.parent.OnCreate(item_window,item,self)
  end
  --do stuff on selection
  local orig_OnLButtonDown = self.idList.OnLButtonDown
  function self.idList:OnLButtonDown(...)
    local ret = {orig_OnLButtonDown(self,...)}
    self = self.parent

    --update selection (select last selected if multisel)
    self.sel = self.idList:GetSelection()[#self.idList:GetSelection()]
    if self.sel then
      --update the edit value box
      self.idEditValue:SetText(self.sel.value)
      self.idEditValue:SetFocus()
    end

    --for whatever is expecting a return value
    return table.unpack(ret)
  end
  --open editor with whatever is selected
  function self.idList.OnLButtonDoubleClick()
    if self.sel then
      ChoGGi.ComFuncs.OpenInObjectManipulator(self.sel.object,self)
    end
  end

  element_y = border / 2 + self.idList:GetPos():y() + self.idList:GetSize():y()

  self.idEditValue = g_Classes.SingleLineEdit:new(self)
  self.idEditValue:SetPos(point(dialog_left, element_y))
  self.idEditValue:SetSize(point(dialog_width, 28))
  self.idEditValue:SetTextVAlign("center")
  self.idEditValue:SetHSizing("Resize")
  self.idEditValue:SetVSizing("AnchorToBottom")
  self.idEditValue:SetHint(S[302535920000102--[[Use to change values of selected list item.--]]])
  self.idEditValue:SetFontStyle("Editor14Bold")
  self.idEditValue:SetAutoSelectAll(true)
  self.idEditValue:SetMaxLen(-1)
  self.idEditValue.display_text = S[302535920000103--[[Edit Value--]]]
  --update custom value list item
  function self.idEditValue.OnValueChanged()
    local sel_idx = self.idList.last_selected
    --nothing selected
    if not sel_idx then
      return
    end
    --
    local edit_text = self.idEditValue:GetText()
    local edit_value = ChoGGi.ComFuncs.RetProperType(edit_text)
    local edit_type = type(edit_value)
    local obj_value = self.obj[self.idList.items[sel_idx].text]
    local obj_type = type(obj_value)
    --only update strings/numbers/boolean/nil
    if obj_type == "table" or obj_type == "userdata" or obj_type == "function" or obj_type == "thread" then
      return
    end

    --if types match then we're fine, or nil if we're removing something
    if obj_type == edit_type or edit_type == "nil" or
        --false bools can be made a string or num
        (obj_value == false and edit_type == "string" or edit_type == "number") or
        --strings can be numbers or bools
        (obj_type == "string" and edit_type == "number" or edit_type == "boolean") or
        --numbers can be false
        (obj_type ~= "number" and edit_type ~= "boolean") then
      --list item
      self.idList.items[sel_idx].value = edit_text
      --stored obj
      self.idList.item_windows[sel_idx].value:SetText(edit_text)
      --actual object
      local value = self.obj[self.idList.items[sel_idx].text]
      if value == false or value then
        self.obj[self.idList.items[sel_idx].text] = edit_value
      end
    end
  end


  --so elements move when dialog re-sizes
  self:InitChildrenSizing()
end


--function ChoGGi_ObjectManipulator:OnKbdKeyDown(char, vk)
function ChoGGi_ObjectManipulator:OnKbdKeyDown(_, vk)
  local const = const
  if vk == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  elseif vk == const.vkEnter then
    local origsel = self.idList.last_selected
    self:UpdateListContent(self.obj)
    self.idList:SetSelection(origsel, true)
    return "break"
  end
  return "continue"
end

function ChoGGi_ObjectManipulator:UpdateListContent(obj)
  if not self.idList then
    return
  end
  --check for scroll pos
  local scrollpos = self.idList.vscrollbar:GetPosition()
  --create prop list for list
  local list = self:CreatePropList(obj)
  if not list then
    local err = S[302535920000090--[[Error opening: %s--]]]:format(RetName(obj))
    --self.idList:SetContent({{text=err,value=err}})
    self.idList:SetContent({text=err,value=err})
    return
  end
  --populate it
  self.idList:SetContent(list)
  --and scroll to saved pos
  self.idList.vscrollbar:SetPosition(scrollpos)
end

--override Listitem:OnCreate so we can have two columns (wonder if there's another way)
function ChoGGi_ObjectManipulator:OnCreate(item,list)
  local g_Classes = g_Classes
  local data_instance = item.ItemDataInstance or list:GetItemDataInstance()
  local view_name = item and item.ItemSubview or list:GetItemSubview()
  if data_instance ~= "" and view_name ~= "" then
    self.DesignerFile = data_instance
    self:SetDesignerFileView(view_name)
    if InDesigner(list) and #self.children == 0 then
      self:SetSize(point(25, 25))
    end
  else
    local text_item = g_Classes.StaticText:new(self)
    text_item:SetBackgroundColor(0)
    text_item:SetId("text")
    text_item:SetFontStyle(item.FontStyle or list:GetFontStyle(), item.FontStyle or list.font_scale)
    local item_spacing = list.item_spacing * list:GetWindowScale() / 100
    local width = Min(1280, list:GetSize():x() - 2 * item_spacing:x())
    local _, height = text_item:MeasureText(item.text or "", nil, nil, nil, width)
    height = Min(720, height)
    text_item:SetSize(point(width, height))
    --newly added
    local value_item = g_Classes.StaticText:new(self)
    value_item:SetBackgroundColor(0)
    value_item:SetId("value")
    value_item:SetFontStyle(item.FontStyle or list:GetFontStyle(), item.FontStyle or list.font_scale)
    --local item_spacing = list.item_spacing * list:GetWindowScale() / 100
    --local value_width = Min(1280, list:GetSize():x() - 2 * item_spacing:x())
    local _, value_height = value_item:MeasureText(item.text or "", nil, nil, nil, width)
    value_height = Min(720, value_height)
    value_item:SetSize(point(width, value_height))
    value_item:SetPos(point(width - 250, value_item:GetY()))
    --newly added
  end
  for i = 1, #self.children do
    local child = self.children[i]
    if item[child.id] and child:HasMember("SetText") then
      child:SetText(item[child.id])
    elseif item[child.id] and child:HasMember("SetImage") then
      child:SetImage(item[child.id])
    end
  end
  self:SetHint(item.rollover)
  if item.ZOrder then
    self:SetZOrder(item.ZOrder)
  end
end

function ChoGGi_ObjectManipulator:CreateProp(o)
  local objlist = objlist
  local obj_type = type(o)
  if obj_type == "function" then
    local debug_info = debug.getinfo(o, "Sn")
    return Concat(tostring(debug_info.name or debug_info.name_what or S[302535920000063--[[unknown name--]]]),"@",debug_info.short_src,"(",debug_info.linedefined,")")
  end

  if IsValid(o) then
    return Concat(o.class,"@",self:CreateProp(o:GetPos()))
  end

  if IsPoint(o) then
    local res = {
      o:x(),
      o:y(),
      o:z()
    }
    return Concat("(",Concat(res, ","),")")
  end
  --if some value is fucked, this just lets us ignore whatever value is fucked.
  pcall(function()
    local meta = getmetatable(o)
    if obj_type == "table" and meta and meta == objlist then
      local res = {}
      for i = 1, Min(#o, 3) do
        res[#res+1] = {
          text = i,
          value = self:CreateProp(o[i])
        }
      end
      if #o > 3 then
        res[#res+1] = {text = "..."}
      end
      return Concat("objlist","{",Concat(res, ", "),"}")
    end
  end)

  if obj_type == "thread" then
    return tostring(o)
  end

  if obj_type == "string" then
    return o
  end

  if obj_type == "table" then
    if IsT(o) then
      return Concat("T{\"",T(o),"\"}")
    else
      local text = Concat(ObjectClass(o) or tostring(o),"(len:",#o,")")
      return text
    end
  end

  return tostring(o)
end

function ChoGGi_ObjectManipulator:CreatePropList(o)
  local res = {}
  local sort = {}
  local function tableinsert(k,v)
    --text colours
    local text
    local v_type = type(v)
    if v_type == "table" then
      if v.class then
        text = Concat("<color 150 170 150>",self:CreateProp(k),"</color>")
      else
        text = Concat("<color 150 170 250>",self:CreateProp(k),"</color>")
      end
    elseif v_type == "function" then
      text = Concat("<color 250 75 75>",self:CreateProp(k),"</color>")
    else
      text = self:CreateProp(k)
    end
    res[#res+1] = {
      sort = self:CreateProp(k),
      text = text,
      value = self:CreateProp(v),
      object = v
    }
  end

  if type(o) == "table" and getmetatable(o) ~= g_traceMeta then
    for k, v in pairs(o) do
      tableinsert(k,v,res)
      if type(k) == "number" then
        sort[res[#res]] = k
      end
    end
  end

  table.sort(res, function(a, b)
    if sort[a.sort] and sort[b.sort] then
      return sort[a.sort] < sort[b.sort]
    end
    if sort[a.sort] or sort[b.sort] then
      return sort[a.sort] and true
    end
    return CmpLower(a.sort, b.sort)
  end)

  return res
end
