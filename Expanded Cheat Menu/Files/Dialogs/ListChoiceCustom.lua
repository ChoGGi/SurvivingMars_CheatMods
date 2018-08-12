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
  listitem_height = false,
  colorpicker = false,
  custom_type = 0,
  custom_func = false,
  hidden = false,

  sel = false,
  obj = false,
}

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
--~   -- used for hiding ListItems (well, okay restoring the actual height of them)
--~   self.listitem_height = self.idList.item_windows[1]:GetHeight(),
  -- fix this
  self.listitem_height = 25

  self.title = self.list.title

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()

  self:AddScrollList()
  self.idList:SetDock("top")

--~   --hook into SetContent so we can add OnSetState to each list item to show hints
--~   local orig_SetContent = self.idList.SetContent
--~   function self.idList:SetContent(items)
--~     orig_SetContent(self,items)
--~     self.parent.idListSetContent(self)
--~   end
--~   --do stuff on selection
--~   local orig_OnLButtonDown = self.idList.OnLButtonDown
--~   function self.idList:OnLButtonDown(...)
--~     local ret = {orig_OnLButtonDown(self,...)}
--~     self.parent.idListOnLButtonDown(self)
--~     --for whatever is expecting a return value
--~     return table.unpack(ret)
--~   end

--~   --what happens when you dbl click the list
--~   function self.idList.OnLButtonDoubleClick()
--~     self:idListOnLButtonDoubleClick()
--~   end

--~   --what happens when you dbl r-click the list
--~   function self.idList.OnRButtonDoubleClick()
--~     self:idListOnRButtonDoubleClick()
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
      local value = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetValue())
      if self.custom_type > 0 then
        if self.idList.last_selected then
          self.idList.items[self.idList.last_selected].value = value
        end
      else
        self.idList:SetItem(#self.idList.items,{
          text = value,
          value = value,
          hint = 302535920000079--[[< Use custom value--]],
        })
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
      self.idList.items[self.idList.last_selected].value = color
      --custom value box
      self.idEditValue:SetText(tostring(color))
    end,
    OnMouseButtonDoubleClick = function(_, _, button)
      print(button)
      if button == "R" then
        self:idColorPickerOnRButtonDoubleClick()
      end
    end,
--~     AdditionalComponent = self.prop_meta.editor == "color" and "alpha" or "intensity"
  }, self.idColorPickerArea)
--~   --stop idColorPicker from closing on dbl l click
--~   function self.idColorPicker.OnLButtonDoubleClick()
--~   end

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

  -- fiddling with custom value
  local list = context.list
  if list.custom_type then
    self.idEditValue.auto_select_all = false
    if list.custom_type == 2 or list.custom_type == 5 then
      self.idList:SetSelection(1, true)
      self.sel = self.idList:GetSelection()[#self.idList:GetSelection()]
      self.idEditValue:SetText(tostring(self.sel.value))
      self:UpdateColourPicker()
      if list.custom_type == 2 then
        self:SetWidth(750)
--~         self.idColourContainer:SetVisible(true)
--~         self.idColorPicker:SetVisible(true)
--~         self.idColorCheckAir:SetVisible(true)
--~         self.idColorCheckWater:SetVisible(true)
--~         self.idColorCheckElec:SetVisible(true)
      else
        self.idColourContainer:SetVisible(false)
      end
    end
  end

  if list.multisel then
    self.idList.MultipleSelection = true
    if type(list.multisel) == "number" then
      -- select all of number
      for i = 1, list.multisel do
        self.idList:SetSelection(i, true)
      end
    end
  end

  --setup checkboxes
  if not list.check1 and not list.check2 then
--~     self.hidden.checks = true
    self.idCheckBox1:SetVisible(false)
    self.idCheckBox2:SetVisible(false)
  else
    self.idList:SetSize(point(390, 310))

    if list.check1 then
      self.idCheckBox1:SetText(ChoGGi.ComFuncs.CheckText(list.check1,""))
      self.idCheckBox1:SetRollover(ChoGGi.ComFuncs.CheckText(list.check1_hint,""))
    else
      self.idCheckBox1:SetVisible(false)
    end
    if list.check2 then
      self.idCheckBox2:SetText(ChoGGi.ComFuncs.CheckText(list.check2,""))
      self.idCheckBox2:SetRollover(ChoGGi.ComFuncs.CheckText(list.check2_hint,""))
    else
      self.idCheckBox2:SetVisible(false)
    end
  end
  if list.check1_checked then
    self.idCheckBox1:SetValue(true)
  end
  if list.check2_checked then
     self.idCheckBox2:SetValue(true)
 end

--~   --where to position self
--~   self:SetPos(terminal.GetMousePos())

  --focus on list
  self.idList:SetFocus()
  --self.idList:SetSelection(1, true)

  --are we showing a hint?
  if list.hint then
    list.hint = ChoGGi.ComFuncs.CheckText(list.hint,"")
    self.idList:SetRollover(list.hint)
    self.idOK:SetRollover(Concat(self.idOK:GetRolloverText(),"\n\n\n",list.hint))
  end

  -- hide ok/cancel buttons as they don't do jack
  if list.custom_type == 1 then
--~     self.hidden.buttons = true
    self.idOK:SetVisible(false)
    self.idCancel:SetVisible(false)
  end





  self:SetInitPos(context.parent)
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

--~ function ChoGGi_ListChoiceCustomDialog:UpdateElementPositions()
--~   local point = point
--~   -- no sense in doing anything if we don't need to
--~   if not self.hidden.checks and not self.hidden.buttons then
--~     return
--~   end
--~   CreateRealTimeThread(function()
--~     -- what we adjust by
--~     local heightc = 0
--~     local heightb = 0
--~     if self.hidden.checks then
--~       heightc = self.idCheckBox1:GetHeight()
--~     end
--~     if self.hidden.buttons then
--~       heightb = self.idOK:GetHeight()
--~     end
--~     -- list only gets bigger, we don't need to move it
--~     local size = self.idList:GetSize()
--~     self.idList:SetSize(point(size:x(),size:y() + heightc + heightb))
--~     -- filter just needs to be moved down, the rest have offsets depending on what is hidden
--~     local pos = self.idFilter:GetPos()
--~     self.idFilter:SetPos(point(pos:x(),pos:y() + heightc + heightb))
--~     pos = self.idCheckBox1:GetPos()
--~     self.idCheckBox1:SetPos(point(pos:x(),pos:y() + heightc + heightb))
--~     pos = self.idCheckBox2:GetPos()
--~     self.idCheckBox2:SetPos(point(pos:x(),pos:y() + heightc + heightb))

--~     -- only need to adjust by button height for these
--~     pos = self.idEditValue:GetPos()
--~     self.idEditValue:SetPos(point(pos:x(),pos:y() + heightb))
--~     pos = self.idOK:GetPos()
--~     self.idOK:SetPos(point(pos:x(),pos:y() + heightb))
--~     pos = self.idCancel:GetPos()
--~     self.idCancel:SetPos(point(pos:x(),pos:y() + heightb))

--~     -- so elements move when dialog re-sizes (also has to be called whenever e are repositioned
--~     self:InitChildrenSizing()
--~   end)
--~ end

function ChoGGi_ListChoiceCustomDialog:FilterText(text)
  -- loop through all the list items and set ones without the text to 0 height
  local listitems = self.idList.item_windows
  for i = 1, #listitems do
    local li = listitems[i]

    if li.text.text:lower():find(text:lower()) then
      li:SetHeight(self.listitem_height)
    else
      li:SetHeight(0)
    end
  end
  List.Refresh(self.idList)
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
  --applies the lightmodel without closing dialog,
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
      self.obj = self.idList.items[#self.idList.items].obj
    end
    local SetPal = self.obj.SetColorizationMaterial
    local items = self.idList.items
    ChoGGi.CodeFuncs.SaveOldPalette(self.obj)
    for i = 1, 4 do
      local Color = items[i].value
      local Metallic = items[i+4].value
      local Roughness = items[i+8].value
      SetPal(self.obj,i,Color,Roughness,Metallic)
    end
    self.obj:SetColorModifier(self.idList.items[#self.idList.items].value)
  elseif self.custom_type == 5 then
    self:BuildAndApplyLightmodel()
  end
end

function ChoGGi_ListChoiceCustomDialog:idListOnLButtonDown()
  local p = self.parent
  local sel = self:GetSelection()
  if type(sel) == "table" and #sel > 0 then
    --update selection (select last selected if multisel)
    p.sel = sel[#sel]
    --update the custom value box
    p.idEditValue:SetText(tostring(p.sel.value))
    if p.custom_type > 0 then
      --2 = showing the colour picker
      if p.custom_type == 2 then
        p:UpdateColourPicker()
      --don't show picker unless it's a colour setting
      elseif p.custom_type == 5 then
        if p.custom_type == 5 and p.sel.editor == "color" then
          p:UpdateColourPicker()
          p:SetWidth(750)
          p.idColourContainer:SetVisible(true)
--~           p.idColorPicker:SetVisible(true)
        else
          p.idColourContainer:SetVisible(false)
--~           p.idColorPicker:SetVisible(false)
        end
      end
    end
  end
end

function ChoGGi_ListChoiceCustomDialog:idListSetContent()
  local listitems = self.item_windows
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
    items = self.idList:GetSelection()
  --get all items
  else
    items = self.idList.items
  end
  --attach other stuff to first item
  if #items > 0 then
    for i = 1, #items do
      if i == 1 then
        --always return the custom value (and try to convert it to correct type)
        items[i].editvalue = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetText())
      end
      self.choices[#self.choices+1] = items[i]
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

-- copied from GedPropEditors.lua
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
