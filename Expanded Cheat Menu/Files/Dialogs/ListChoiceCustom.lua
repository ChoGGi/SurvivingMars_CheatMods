-- See LICENSE for terms

-- all purpose items list

local Concat = ChoGGi.ComFuncs.Concat
local TableConcat = ChoGGi.ComFuncs.TableConcat
local T = ChoGGi.ComFuncs.Trans
local S = ChoGGi.Strings

local type,tostring = type,tostring

DefineClass.ChoGGi_ListChoiceCustomDialog = {
  __parents = {"ChoGGi_Window"},
  choices = false,
--~   listitem_height = false,
  colorpicker = false,
  custom_type = 0,
  custom_func = false,
  hidden = false,

  sel = false,
  obj = false,
}

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()
function ChoGGi_ListChoiceCustomDialog:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes
  local point = point
  local RGB,RGBA = RGB,RGBA

  self.dialog_width = 400
  self.dialog_height = 470

  self.list = context.list
  self.items = self.list.items
  self.custom_func = self.list.custom_func
--~   self.hidden = {}
  self.custom_type = self.list.custom_type

  self.title = self.list.title

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self:AddScrollList()
  self:BuildList(self.list.items)

  function self.idList.OnMouseButtonDown(obj,pt,button)
    if button == "L" then
      self:idListOnLButtonDown()
    end
    return g_Classes.ChoGGi_List.OnMouseButtonDown(obj,pt,button)
  end
  function self.idList.OnMouseButtonDoubleClick(obj,pt,button)
    if button == "L" then
      self:idListOnLButtonDoubleClick()
    elseif button == "R" then
      self:idListOnRButtonDoubleClick()
    end
--~     return g_Classes.ChoGGi_List.OnMouseButtonDoubleClick(obj,pt,button)
  end
--~   function list.OnDoubleClick(container_list, item_idx)
--~     self:ApplyActiveSuggestion()
--~   end

  self.idFilterArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idFilterArea",
    Dock = "bottom",
  }, self.idDialog)

  self.idFilter = g_Classes.ChoGGi_TextInput:new({
    Id = "idFilter",
    RolloverText = S[302535920000806--[["Only show items containing this text.

Press Enter to show all items."--]]],
    Hint = S[302535920000068--[[Filter Text--]]],
    OnTextChanged = function()
      self:FilterText(self.idFilter:GetText())
    end,
    OnKbdKeyDown = function(obj, vk)
      return self:idFilterOnKbdKeyDown(obj, vk)
    end,
  }, self.idFilterArea)

  self.idCheckboxArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idCheckboxArea",
    Dock = "bottom",
  }, self.idDialog)

  self.idCheckBox1 = g_Classes.ChoGGi_CheckButton:new({
    Id = "idCheckBox1",
    Text = S[588--[[Empty--]]],
    Dock = "left",
--~     OnChange = function()
--~       self.idAutoRefreshToggle(self)
--~     end,
  }, self.idCheckboxArea)

  self.idCheckBox2 = g_Classes.ChoGGi_CheckButton:new({
    Id = "idCheckBox2",
    Text = S[588--[[Empty--]]],
    Dock = "right",
--~     OnChange = function()
--~       self.idAutoRefreshToggle(self)
--~     end,
  }, self.idCheckboxArea)

  -- make checkbox work like a button
  if self.custom_type == 5 then
    function self.idCheckBox2.OnChange()
      -- show lightmodel lists and lets you pick one to use in new window
      ChoGGi.MenuFuncs.ChangeLightmodel(true)
    end
  end

  self.idEditArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idEditArea",
    Dock = "bottom",
  }, self.idDialog)

  self.idEditValue = g_Classes.ChoGGi_TextInput:new({
    Id = "idEditValue",
    RolloverText = S[302535920000077--[["You can enter a custom value to be applied.

Warning: Entering the wrong value may crash the game or otherwise cause issues."--]]],
    Hint = S[302535920000078--[[Add Custom Value--]]],
    OnTextChanged = function()
      local text = self.idEditValue:GetText()
      local value = ChoGGi.ComFuncs.RetProperType(text)
      if self.custom_type > 0 then
        if #self.idList.selection > 0 then
          self.idList[#self.idList.selection].ChoGGi_context.value = value
        end
      else
        local listitem = self.idList:CreateTextItem(text)
        listitem.RolloverText = ChoGGi.ComFuncs.CheckText(302535920000079--[[< Use custom value--]])
        listitem.ChoGGi_context = {
          text = text
          value = value
          hint = 302535920000079--[[< Use custom value--]]
        }
      end
    end,
  }, self.idEditArea)

  self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
    Id = "idButtonContainer",
    Dock = "bottom",
  }, self.idDialog)

  self.idOK = g_Classes.ChoGGi_Button:new({
    Id = "idOK",
    Dock = "left",
    Text = S[6878--[[OK--]]],
    RolloverText = S[302535920000080--[[Apply and close dialog (Arrow keys and Enter/Esc can also be used).--]]],
    OnMouseButtonDown = function()
      -- build self.choices
      self:GetAllItems()
      -- send selection back
      self:delete(self.choices)
    end,
  }, self.idButtonContainer)

  self.idCancel = g_Classes.ChoGGi_Button:new({
    Id = "idCancel",
    Dock = "right",
    Text = S[6879--[[Cancel--]]],
    RolloverText = S[302535920000074--[[Cancel without changing anything.--]]],
    OnMouseButtonDown = self.idCloseX.OnPress,
  }, self.idButtonContainer)

  -- keep all colour elements in here for easier... UIy stuff
  self.idColourContainer = g_Classes.ChoGGi_DialogSection:new({
    Id = "idColourContainer",
    MinWidth = 550,
    Dock = "right",
  }, self.idDialog)
  self.idColourContainer.visible = false

  self.idColorPickerArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idColorPickerArea",
    Dock = "top",
  }, self.idColourContainer)

  self.idColorPicker = g_Classes.XColorPicker:new({
    RolloverText = S[302535920000081--[[Double right-click to change colour without closing dialog.--]]],
    OnColorChanged = function(picker, color)
--~       self.idEdit:SetText(self:ConvertToText(color))
--~       self.idColorBox.idColor:SetBackground(color)
--~       if now() - last_update >= 100 then
--~         self:SetProp(color)
--~         last_update = now()
--~       end
      --update item
      self.idList[#self.idList.selection].ChoGGi_context.value = color
      --custom value box
      self.idEditValue:SetText(tostring(color))
    end,
    OnMouseButtonDoubleClick = function(a, b, button)
      print(a)
      print(b)
      print(button)
      if button == "R" then
        self:idColorPickerOnRButtonDoubleClick()
      end
      return "break"
    end,
--~     AdditionalComponent = self.prop_meta.editor == "color" and "alpha" or "intensity"
  }, self.idColorPickerArea)

  self.idColorCheckArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idColorCheckArea",
    Dock = "bottom",
  }, self.idColourContainer)

  self.idColorCheckElec = g_Classes.ChoGGi_CheckButton:new({
    Id = "idColorCheckElec",
    Text = S[302535920000037--[[Electricity--]]],
    RolloverText = S[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
    Dock = "left",
  }, self.idColourContainer)

  self.idColorCheckAir = g_Classes.ChoGGi_CheckButton:new({
    Id = "idColorCheckAir",
    Text = S[891--[[Air--]]],
    RolloverText = S[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
    Dock = "left",
  }, self.idColourContainer)

  self.idColorCheckWater = g_Classes.ChoGGi_CheckButton:new({
    Id = "idColorCheckWater",
    Text = S[681--[[Water--]]],
    RolloverText = S[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
    Dock = "left",
  }, self.idColourContainer)

  -- fiddling with custom_type
  if self.custom_type then
    self.idEditValue.auto_select_all = false
    if self.custom_type == 2 or self.custom_type == 5 then
      self.idList:SetSelection(1, true)
      self.sel = self.idList[#self.idList.selection]
      self.idEditValue:SetText(tostring(self.sel.value))
      self:UpdateColourPicker()
      if self.custom_type == 2 then
        self:SetWidth(800)
      else
        self.idColourContainer:SetVisible(false)
      end
    end
  end

  if self.list.multisel then
    self.idList.MultipleSelection = true
    if type(self.list.multisel) == "number" then
      -- select all of number
      for i = 1, self.list.multisel do
        self.idList:SetSelection(i, true)
      end
    end
  end

  -- setup checkboxes
  if not self.list.check1 and not self.list.check2 then
    self.idCheckboxArea:SetVisible(false)
  else
    self:CheckboxSetup(1)
    self:CheckboxSetup(2)
  end

  -- focus on list
  self.idList:SetFocus()

  -- are we showing a hint?
  local hint = self.list.hint
  if hint then
    hint = ChoGGi.ComFuncs.CheckText(hint)
    self.idList:SetRollover(hint)
    self.idOK:SetRollover(Concat(self.idOK:GetRolloverText(),"\n\n\n",hint))
  end

  -- hide ok/cancel buttons as they don't do jack
  if self.custom_type == 1 then
    self.idButtonContainer:SetVisible(false)
  end

  self:SetInitPos(context.parent)
end

function ChoGGi_ListChoiceCustomDialog:BuildList(items)
  self.idList:Clear()
  for i = 1, #items do
    local listitem = self.idList:CreateTextItem(items[i].text)
    listitem.RolloverText = ChoGGi.ComFuncs.CheckText(items[i].hint)
    listitem.ChoGGi_context = items[i]
  end
  ex(self.idList)
end

function ChoGGi_ListChoiceCustomDialog:CheckboxSetup(i)
  local name1 = Concat("idCheckBox",i)
  local name2 = Concat("check",i)
  if self.list[name2] then
    self[name1]:SetText(ChoGGi.ComFuncs.CheckText(self.list[name2]))
    self[name1]:SetRollover(ChoGGi.ComFuncs.CheckText(self.list[Concat("check",i,"_hint")]))
  else
    self[name1]:SetVisible(false)
  end
  if self.list[Concat("check",i,"_checked")] then
    self[name1]:SetValue(true)
  end
end

function ChoGGi_ListChoiceCustomDialog:idFilterOnKbdKeyDown(obj,vk)
  if vk == const.vkEnter then
    self:FilterText("")
    return "break"
  elseif vk == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  end
  return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
end

function ChoGGi_ListChoiceCustomDialog:FilterText(text)
  -- loop through all the list items and set ones without the text to 0 height
  local listitems = self.idList
  for i = 1, #listitems do
    local li = listitems[i]

    if li.text.text:lower():find(text:lower()) then
--~       li:SetHeight(self.listitem_height)
      li:SetVisible(true)
    else
      li:SetVisible()
--~       li:SetHeight(0)
    end
  end
--~   List.Refresh(self.idList)
end

function ChoGGi_ListChoiceCustomDialog:idListOnLButtonDoubleClick()
  if not self.sel then
    return
  end
  -- fire custom_func with sel
  if self.custom_type == 1 or self.custom_type == 7 then
    self.custom_func(self.sel)
  elseif self.custom_type ~= 5 and self.custom_type ~= 2 then
    -- dblclick to close and ret item
    self.idOK.OnButtonPressed()
  end
end

function ChoGGi_ListChoiceCustomDialog:idListOnRButtonDoubleClick()
  -- applies the lightmodel without closing dialog,
  if self.custom_type == 5 then
    self:BuildAndApplyLightmodel()
  elseif self.custom_type == 6 and self.custom_func then
    self.custom_func(self.sel.func)
  else
    self.idEditValue:SetText(self.sel.text)
  end
end

function ChoGGi_ListChoiceCustomDialog:idColorPickerOnRButtonDoubleClick()
  if self.custom_type == 2 then
    if not self.obj then
      -- grab the object from the last list item
      self.obj = self.idList[#self.idList].ChoGGi_context.obj
    end
    local SetPal = self.obj.SetColorizationMaterial
    local items = self.idList
    ChoGGi.CodeFuncs.SaveOldPalette(self.obj)
    for i = 1, 4 do
      local Color = items[i].value
      local Metallic = items[i+4].value
      local Roughness = items[i+8].value
      SetPal(self.obj,i,Color,Roughness,Metallic)
    end
    self.obj:SetColorModifier(self.idList[#self.idList].ChoGGi_context.value)
  elseif self.custom_type == 5 then
    self:BuildAndApplyLightmodel()
  end
end

function ChoGGi_ListChoiceCustomDialog:idListOnLButtonDown()
  if #self.idList.selection > 0 then
    -- update selection (select last selected if multisel)
    self.sel = self.idList[#self.idList.selection].ChoGGi_context
    -- update the custom value box
    self.idEditValue:SetText(tostring(self.sel.value))
    if self.custom_type > 0 then
      -- 2 = showing the colour picker
      if self.custom_type == 2 then
        self:UpdateColourPicker()
      -- don't show picker unless it's a colour setting
      elseif self.custom_type == 5 then
        if self.custom_type == 5 and self.sel.editor == "color" then
          self:UpdateColourPicker()
          self:SetWidth(800)
          self.idColourContainer:SetVisible(true)
        else
          self.idColourContainer:SetVisible(false)
        end
      end
    end
  end
end

function ChoGGi_ListChoiceCustomDialog:idListSetContent()
  local listitems = self
  for i = 1, #listitems do
    local listitem = listitems[i]
    listitem.orig_OnSetState = listitem.OnSetState
    function listitem:OnSetState(list, item, rollovered, selected)
      self.orig_OnSetState(self,list, item, rollovered, selected)
      if rollovered or selected then
        local hint = {item.text}
        if item.value then
          if type(item.value) == "userdata" then
            hint[#hint+1] = ": "
            hint[#hint+1] = T(item.value)
          elseif item.value then
            hint[#hint+1] = ": "
            hint[#hint+1] = tostring(item.value)
          end
        end
        if type(item.hint) == "userdata" then
          hint[#hint+1] = "\n\n"
          hint[#hint+1] = T(item.hint)
        elseif item.hint then
          hint[#hint+1] = "\n\n"
          hint[#hint+1] = ChoGGi.ComFuncs.CheckText(item.hint)
        end
        self.parent:SetHint(TableConcat(hint))
        print("CreateRolloverWindow LISTCHOICE")
--~         CreateRolloverWindow(self.parent, TableConcat(hint), true)
      end
    end
  end
end

function ChoGGi_ListChoiceCustomDialog:BuildAndApplyLightmodel()
  --update list item settings table
  self:GetAllItems()
  --remove defaults
  local model_table = {}
  for i = 1, #self.choices do
    local value = self.choices[i].value
    if value ~= self.choices[i].default then
      model_table[#model_table+1] = {
        id = self.choices[i].sort,
        value = value,
      }
    end
  end
  --rebuild it
  ChoGGi.CodeFuncs.LightmodelBuild(model_table)
  --and temp apply
  SetLightmodel(1,"ChoGGi_Custom")
end

--update colour
function ChoGGi_ListChoiceCustomDialog:UpdateColourPicker()
  local num = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetText())
  if type(num) == "number" then
    self.idColorPicker:SetHSV(UIL.RGBtoHSV(GetRGB(num)))
    self.idColorPicker:InitHSVPtPos()
    self.idColorPicker:Invalidate()
  end
end

function ChoGGi_ListChoiceCustomDialog:GetAllItems()
  --always start with blank choices
  self.choices = {}
  --get sel item(s)
  local items
  if self.custom_type == 0 or self.custom_type == 3 or self.custom_type == 6 then
    items = self.idList.selection
  -- get all items
  else
    items = self.idList
  end
  --attach other stuff to first item
  if #items > 0 then
    for i = 1, #items do
      if i == 1 then
        --always return the custom value (and try to convert it to correct type)
        items[i].editvalue = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetText())
      end
      self.choices[#self.choices+1] = items[i].ChoGGi_context
    end
  end
  -- send back checkmarks no matter what
  self.choices[1] = self.choices[1] or {}
  --add checkbox statuses
  self.choices[1].check1 = self.idCheckBox1:GetToggled()
  self.choices[1].check2 = self.idCheckBox2:GetToggled()
  self.choices[1].checkair = self.idColorCheckAir:GetToggled()
  self.choices[1].checkwater = self.idColorCheckWater:GetToggled()
  self.choices[1].checkelec = self.idColorCheckElec:GetToggled()
end

--function ChoGGi_ListChoiceCustomDialog:OnKbdKeyDown(char, vk)
function ChoGGi_ListChoiceCustomDialog:OnKbdKeyDown(_, vk)
  local const = const
  if vk == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  elseif vk == const.vkEnter then
    self.idOK:Press()
    return "break"
--~   elseif vk == const.vkSpace then
--~     self.idCheckBox1:SetToggled(not self.idCheckBox1:GetToggled())
--~     return "break"
  end
  return "continue"
end

-- copied from GedPropEditors.lua (it's normally only called when GED is loaded).
function CreateNumberEditor(parent, id, up_pressed, down_pressed)
  local button_panel = XWindow:new({Dock = "right"}, parent)
  local top_btn = XTextButton:new({
    Dock = "top",
    OnPress = up_pressed,
    Padding = box(1, 2, 1, 1),
    Icon = "CommonAssets/UI/arrowup-40.tga",
    IconScale = point(500, 500),
    IconColor = RGB(0, 0, 0),
    DisabledIconColor = RGBA(0, 0, 0, 128),
    Background = RGBA(0, 0, 0, 0),
    DisabledBackground = RGBA(0, 0, 0, 0),
    RolloverBackground = RGB(204, 232, 255),
    PressedBackground = RGB(121, 189, 241)
  }, button_panel, nil, nil, "NumberArrow")
  local bottom_btn = XTextButton:new({
    Dock = "bottom",
    OnPress = down_pressed,
    Padding = box(1, 1, 1, 2),
    Icon = "CommonAssets/UI/arrowdown-40.tga",
    IconScale = point(500, 500),
    IconColor = RGB(0, 0, 0),
    DisabledIconColor = RGBA(0, 0, 0, 128),
    Background = RGBA(0, 0, 0, 0),
    DisabledBackground = RGBA(0, 0, 0, 0),
    RolloverBackground = RGB(204, 232, 255),
    PressedBackground = RGB(121, 189, 241)
  }, button_panel, nil, nil, "NumberArrow")
  local edit = XEdit:new({Id = id, Dock = "box"}, parent)
  return edit, top_btn, bottom_btn
end
