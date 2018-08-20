-- See LICENSE for terms

-- used to do minimal editing of objects (or all of same type)

local Concat = ChoGGi.ComFuncs.Concat
local TableConcat = ChoGGi.ComFuncs.TableConcat
local T = ChoGGi.ComFuncs.Translate
local S = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName

local pcall,tostring,type,table = pcall,tostring,type,table

local IsPoint = IsPoint
local Min = Min
local ObjectClass = ObjectClass

DefineClass.ChoGGi_ObjectManipulatorDlg = {
  __parents = {"ChoGGi_Window"},
  choices = {},
  refreshing = false,
  obj = false,
  sel = false,
  dialog_width = 750.0,
  dialog_height = 650.0,
}

function ChoGGi_ObjectManipulatorDlg:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes

  local name = RetName(self.obj)

  self.obj = context.obj
  self.title = Concat(S[302535920000471--[[Object Manipulator--]]],": ",name)

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  -- checkboxes (ok checkbox, maybe do some more shit here)
  self.idCheckboxArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idCheckboxArea",
    Dock = "top",
  }, self.idDialog)

  self.idAutoRefresh = g_Classes.ChoGGi_CheckButton:new({
    Id = "idAutoRefresh",
    Text = S[302535920000084--[[Auto-Refresh--]]],
    RolloverText = S[302535920001257--[[Auto-refresh list every second.--]]],
    Dock = "left",
    OnChange = function()
      self.idAutoRefreshToggle(self)
    end,
  }, self.idCheckboxArea)

  self.idButtonArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idButtonArea",
    Dock = "top",
  }, self.idDialog)

  self.idRefresh = g_Classes.ChoGGi_Button:new({
    Id = "idRefresh",
    Text = S[1000220--[[Refresh--]]],
    Dock = "left",
    RolloverText = S[302535920000092--[[Refresh list.--]]],
    OnMouseButtonDown = function()
      self:UpdateListContent()
    end,
  }, self.idButtonArea)

  self.idGoto = g_Classes.ChoGGi_Button:new({
    Id = "idGoto",
    Text = S[302535920000093--[[Goto Obj--]]],
    Dock = "left",
    RolloverText = S[302535920000094--[[View object on map.--]]],
    OnMouseButtonDown = function()
      ViewAndSelectObject(self.obj)
    end,
  }, self.idButtonArea)

  self.idAddNew = g_Classes.ChoGGi_Button:new({
    Id = "idAddNew",
    Text = S[398847925160--[[New--]]],
    Dock = "left",
    RolloverText = S[398847925160--[[New--]]],
    OnMouseButtonDown = function()
      self:idAddNewOnMouseButtonDown()
    end,
  }, self.idButtonArea)
  -- update the add button hint
  self.idAddNew:SetRollover(S[302535920000041--[[Add new entry to %s (Defaults to name/value of selected item).--]]]:format(name))

  self.idApplyAll = g_Classes.ChoGGi_Button:new({
    Id = "idApplyAll",
    Text = S[302535920000099--[[Apply To All--]]],
    Dock = "left",
    RolloverText = S[302535920000100--[[Apply selected value to all objects of the same type.--]]],
    OnMouseButtonDown = function()
      self:idApplyAllOnMouseButtonDown()
    end,
  }, self.idButtonArea)

  self:AddScrollList()

  function self.idList.OnMouseButtonDown(obj,pt,button)
    g_Classes.ChoGGi_List.OnMouseButtonDown(obj,pt,button)
    self:idListOnMouseButtonDown(button)
  end
  function self.idList.OnMouseButtonDoubleClick(_,_,button)
    self:idListOnMouseButtonDoubleClick(button)
  end

  self.idEditArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idEditArea",
    Dock = "bottom",
  }, self.idDialog)

  self.idEditValue = g_Classes.ChoGGi_TextInput:new({
    Id = "idEditValue",
    RolloverText = S[302535920000102--[[Use to change values of selected list item.--]]],
    Hint = S[302535920000103--[[Edit Value--]]],
    OnTextChanged = function()
      self:idEditValueOnTextChanged()
    end,
  }, self.idEditArea)

  self:SetInitPos(context.parent)

  -- update item list
  self:UpdateListContent()
end

function ChoGGi_ObjectManipulatorDlg:idListOnMouseButtonDown(button)
  --update selection (select last selected if multisel)
  self.sel = self.idList:GetSelection()[#self.idList:GetSelection()]
  if self.sel then
    --update the edit value box
    self.idEditValue:SetText(self.sel.value)
    self.idEditValue:SetFocus()
  end
end

function ChoGGi_ObjectManipulatorDlg:idListOnMouseButtonDoubleClick(button)
  if #self.idList.selection > 0 then
    ChoGGi.ComFuncs.OpenInObjectManipulatorDlg(self.sel.object,self)
  end
end

function ChoGGi_ObjectManipulatorDlg:idAddNewOnMouseButtonDown()
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
    self:UpdateListContent()
  end

  ChoGGi.ComFuncs.OpenInListChoice{
    callback = CallBackFunc,
    items = ItemList,
    title = S[302535920000095--[[New Entry--]]],
    custom_type = 4,
  }
end

function ChoGGi_ObjectManipulatorDlg:idApplyAllOnMouseButtonDown()
  if not self.sel then
    return
  end
  local value = self.sel.value
  if value then
    ForEach{
      class = self.obj.class,
      area = "realm",
      exec = function(o)
        o[self.sel.text] = ChoGGi.ComFuncs.RetProperType(value)
      end,
    }
  end
end

function ChoGGi_ObjectManipulatorDlg:idEditValueOnTextChanged()
  local sel_idx = self.idList.selection
  -- nothing selected
  if #sel_idx < 1 then
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

function ChoGGi_ObjectManipulatorDlg:idAutoRefreshToggle()
  self:CreateThread("update", function(self)
    local Sleep = Sleep
    while true do
      if self.obj then
        self:UpdateListContent()
      else
        Halt()
      end
      Sleep(1000)
    end
  end, self)
end

function ChoGGi_ObjectManipulatorDlg:OnKbdKeyDown(_, vk)
  local const = const
  if vk == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  elseif vk == const.vkEnter then
    local origsel = self.idList.last_selected
    self:UpdateListContent()
    self.idList:SetSelection(origsel, true)
    return "break"
  end
  return "continue"
end

function ChoGGi_ObjectManipulatorDlg:UpdateListContent()
  local obj = self.obj
--~   self.idList:Clear()
--~   for i = 1, #self.items do
--~     local listitem = self.idList:CreateTextItem(self.items[i].text)
--~     listitem.item = self.items[i]
--~     listitem.RolloverText = self:UpdateHintText(self.items[i])
--~   end

  --check for scroll pos
  local scrollpos = self.idScrollArea.OffsetY
  --create prop list for list
  local list = self:CreatePropList(obj)
  if not list then
    local err = S[302535920000090--[[Error opening: %s--]]]:format(RetName(obj))
--~     self.idList:SetContent({text=err,value=err})
    return
  end
  --populate it
--~   self.idList:SetContent(list)
  --and scroll to saved pos
  self.idScrollArea:ScrollTo(scrollpos)
end

--override Listitem:OnCreate so we can have two columns (wonder if there's another way)
function ChoGGi_ObjectManipulatorDlg:OnCreate(item,list)
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

function ChoGGi_ObjectManipulatorDlg:CreateProp(obj)
  local objlist = objlist
  local obj_type = type(obj)
  if obj_type == "function" then
    local debug_info = debug.getinfo(obj, "Sn")
    return Concat(tostring(debug_info.name or debug_info.name_what or S[302535920000063--[[unknown name--]]]),"@",debug_info.short_src,"(",debug_info.linedefined,")")
  end

  if IsValid(obj) then
    return Concat(obj.class,"@",self:CreateProp(obj:GetPos()))
  end

  if IsPoint(obj) then
    local res = {
      obj:x(),
      obj:y(),
      obj:z()
    }
    return Concat("(",Concat(res, ","),")")
  end
  --if some value is fucked, this just lets us ignore whatever value is fucked.
  pcall(function()
    local meta = getmetatable(obj)
    if obj_type == "table" and meta and meta == objlist then
      local res = {}
      for i = 1, Min(#obj, 3) do
        res[#res+1] = {
          text = i,
          value = self:CreateProp(obj[i])
        }
      end
      if #obj > 3 then
        res[#res+1] = {text = "..."}
      end
      return Concat("objlist","{",Concat(res, ", "),"}")
    end
  end)

  if obj_type == "thread" then
    return tostring(obj)
  end

  if obj_type == "string" then
    return obj
  end

  if obj_type == "table" then
    if IsT(obj) then
      return Concat("T{\"",T(obj),"\"}")
    else
      local text = Concat(ObjectClass(obj) or tostring(obj),"(len:",#obj,")")
      return text
    end
  end

  return tostring(obj)
end

function ChoGGi_ObjectManipulatorDlg:CreatePropList(obj)
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

  if type(obj) == "table" then
    for k, v in pairs(obj) do
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
