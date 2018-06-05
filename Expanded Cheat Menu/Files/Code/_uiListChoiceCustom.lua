local oldTableConcat = oldTableConcat

--ex(ChoGGi.ListChoiceCustomDialog_Dlg)
--ChoGGi.ListChoiceCustomDialog_Dlg.colorpicker

-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_ListChoiceCustomDialog_Defaults = {
  __parents = {"FrameWindow"}
}

function ChoGGi_ListChoiceCustomDialog_Defaults:Init()
  local ChoGGi = ChoGGi

  self:SetPos(point(100, 100))
  self:SetSize(point(400, 450))
  self:SetMinSize(point(50, 50))
  self:SetTranslate(false)
  self:SetMovable(true)
  self:SetZOrder(zorder)
  self.choices = false
  self.sel = false
  self.obj = false
  self.CustomType = 0
  self.colorpicker = nil
  self.Func = false

  ChoGGi.ComFuncs.DialogAddCaption(self,{pos = point(105, 101),size = point(390, 22)})
  ChoGGi.ComFuncs.DialogAddCloseX(self)


  self.idList = List:new(self)
  self.idList:SetShowPartialItems(true)
  self.idList:SetSelectionColor(RGB(0, 0, 0))
  self.idList:SetSelectionFontStyle("Editor14")
  self.idList:SetRolloverFontStyle("Editor14")
  self.idList:SetFontStyle("Editor14")
  self.idList:SetPos(point(105, 123))
  self.idList:SetSize(point(390, 335))
  self.idList:SetHSizing("Resize")
  self.idList:SetVSizing("Resize")
  self.idList:SetSpacing(point(8, 2))
  self.idList:SetScrollBar(true)
  self.idList:SetScrollAutohide(true)
  --hook into SetContent so we can add OnSetState to each list item to show hints
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
            if type(item.value) == "userdata" then
              hint[#hint+1] = ": "
              hint[#hint+1] = ChoGGi.ComFuncs.Trans(item.value)
            elseif item.value then
              hint[#hint+1] = ": "
              hint[#hint+1] = tostring(item.value)
            end
          end
          if type(item.hint) == "userdata" then
            hint[#hint+1] = "\n\n"
            hint[#hint+1] = ChoGGi.ComFuncs.Trans(item.hint)
          elseif item.hint then
            hint[#hint+1] = "\n\n"
            hint[#hint+1] = item.hint
          end
          --self.parent.parent:SetHint(hint)
          self.parent:SetHint(oldTableConcat(hint))
        end
      end
    end
  end
  --do stuff on selection
  local orig_OnLButtonDown = self.idList.OnLButtonDown
  function self.idList:OnLButtonDown(...)
    local ret = {orig_OnLButtonDown(self,...)}
    local sel = self:GetSelection()
    self = self.parent
    if type(sel) == "table" and next(sel) then
    --if #sel ~= 0 then
      --update selection (select last selected if multisel)
      self.sel = sel[#sel]
      --update the custom value box
      self.idEditValue:SetText(tostring(self.sel.value))
      if self.CustomType > 0 then
        --2 = showing the colour picker
        if self.CustomType == 2 then
          self:UpdateColourPicker()
        --don't show picker unless it's a colour setting
        elseif self.CustomType == 5 then
          if self.CustomType == 5 and self.sel.editor == "color" then
            self:UpdateColourPicker()
            self:SetWidth(750)
            self.idColorHSV:SetVisible(true)
            self.idColorHSV:SetPos(point(500, 125))
          else
            self.idColorHSV:SetVisible(false)
            --self:SetWidth(400)
          end
        end
      end
    end

    --for whatever is expecting a return value
    return table.unpack(ret)
  end
  --what happens when you dbl click the list
  function self.idList.OnLButtonDoubleClick()
    if not self.sel then
      return
    end
    --open colour changer
    if self.CustomType == 1 or self.CustomType == 2 then
      ChoGGi.CodeFuncs.ChangeObjectColour(self.sel.obj,self.sel.parentobj)
    elseif self.CustomType == 7 then
      --open it in monitor list
      ChoGGi.CodeFuncs.DisplayMonitorList(self.sel.value,self.sel.parentobj)
    elseif self.CustomType ~= 5 then
      --dblclick to close and ret item
      self.idOK.OnButtonPressed()
    end
  end
  --what happens when you dbl r-click the list
  function self.idList.OnRButtonDoubleClick()
    --applies the lightmodel without closing dialog,
    if self.CustomType == 5 then
      self:BuildAndApplyLightmodel()
    elseif self.CustomType == 6 and self.Func then
      self.Func(self.sel.func)
    else
      self.idEditValue:SetText(self.sel.text)
    end
  end

  self.idEditValue = SingleLineEdit:new(self)
  self.idEditValue:SetAutoSelectAll(true)
  self.idEditValue:SetFontStyle("Editor14Bold")
  self.idEditValue:SetPos(point(110, 465))
  self.idEditValue:SetSize(point(375, 24))
  self.idEditValue:SetHSizing("Resize")
  self.idEditValue:SetVSizing("AnchorToBottom")
  self.idEditValue:SetHint("You can enter a custom value to be applied.\n\nWarning: Entering the wrong value may crash the game or otherwise cause issues.")
  self.idEditValue:SetTextVAlign("center")
  self.idEditValue.display_text = "Add Custom Value"
  --update custom value list item
  function self.idEditValue.OnValueChanged()
    local value = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetValue())

    if self.CustomType > 0 then
      self.idList.items[self.idList.last_selected].value = value
    else
      self.idList:SetItem(#self.idList.items,{
        text = value,
        value = value,
        hint = "< Use custom value"
      })
    end
  end


  self.idCheckBox1 = CheckButton:new(self)
  self.idCheckBox1:SetPos(point(110, 440))
  self.idCheckBox1:SetSize(point(200, 17))
  self.idCheckBox1:SetText(T({588, "Empty"}))
  self.idCheckBox1:SetButtonSize(point(16, 16))
  self.idCheckBox1:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idCheckBox1:SetHSizing("AnchorToMidline")
  self.idCheckBox1:SetVSizing("AnchorToBottom")

  self.idCheckBox2 = CheckButton:new(self)
  self.idCheckBox2:SetText(T({588, "Empty"}))
  self.idCheckBox2:SetPos(point(300, 440))
  self.idCheckBox2:SetSize(point(200, 17))
  self.idCheckBox2:SetButtonSize(point(16, 16))
  self.idCheckBox2:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idCheckBox2:SetHSizing("AnchorToMidline")
  self.idCheckBox2:SetVSizing("AnchorToBottom")
  --make checkbox work like a button
  local children = self.idCheckBox2.children
  for i = 1, #children do
    if children[i].class == "Button" then
      local but = children[i]
      function but.OnButtonPressed()
        --show lightmodel lists and lets you pick one to use in new window
        if self.CustomType == 5 then
          ChoGGi.MenuFuncs.ChangeLightmodel(true)
        end
      end
    end
  end

  self.idOK = Button:new(self)
  self.idOK:SetPos(point(110, 500))
  self.idOK:SetSize(point(129, 34))
  self.idOK:SetHSizing("AnchorToMidline")
  self.idOK:SetVSizing("AnchorToBottom")
  self.idOK:SetFontStyle("Editor14Bold")
  self.idOK:SetText(T({1000429, "OK"}))
  self.idOK:SetHint("Apply and close dialog (Arrow keys and Enter/Esc can also be used).")
  --return values
  function self.idOK.OnButtonPressed()
    --item list
    self:GetAllItems()
    --send selection back
    self:delete(self.choices)
  end

  self.idClose = Button:new(self)
  self.idClose:SetPos(point(353, 500))
  self.idClose:SetSize(point(132, 34))
  self.idClose:SetHSizing("AnchorToMidline")
  self.idClose:SetVSizing("AnchorToBottom")
  self.idClose:SetFontStyle("Editor14Bold")
  self.idClose:SetHint("Cancel without changing anything.")
  self.idClose:SetText(T({1000430, "Cancel"}))
  self.idClose.OnButtonPressed = self.idCloseX.OnButtonPressed

  self.idColorHSV = ColorHSVControl:new(self)
  self.idColorHSV:SetPos(point(500, 125)) --for some reason this is ignored till visible, unlike checkmarks
  self.idColorHSV:SetSize(point(300, 300))
  self.idColorHSV:SetHSizing("AnchorToRight")
  self.idColorHSV:SetVisible(false)
  self.idColorHSV:SetHint("Double right-click to set without closing dialog.")
  --stop idColorHSV from closing on dblclick
  function self.idColorHSV.OnLButtonDoubleClick()
  end
  function self.idColorHSV.OnRButtonDoubleClick()
    if self.CustomType == 2 then
      if not self.obj then
        --grab the object from the last list item
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
    elseif self.CustomType == 5 then
      self:BuildAndApplyLightmodel()
    end
  end
  --update custom value when dbl right
  function self.OnColorChanged(color)
    --update item
    self.idList.items[self.idList.last_selected].value = color
    --custom value box
    self.idEditValue:SetText(tostring(color))
  end

  local hint_connectedgrid = "Check this for \"All of type\" to only apply to connected grid."

  self.idColorCheckAir = CheckButton:new(self)
  self.idColorCheckAir:SetPos(point(525, 400))
  self.idColorCheckAir:SetSize(point(50, 17))
  self.idColorCheckAir:SetVisible(false)
  self.idColorCheckAir:SetButtonSize(point(16, 16))
  self.idColorCheckAir:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idColorCheckAir:SetText(T({891, "Air"}))
  self.idColorCheckAir:SetHint(hint_connectedgrid)

  self.idColorCheckWater = CheckButton:new(self)
  self.idColorCheckWater:SetPos(point(575, 400))
  self.idColorCheckWater:SetSize(point(60, 17))
  self.idColorCheckWater:SetVisible(false)
  self.idColorCheckWater:SetButtonSize(point(16, 16))
  self.idColorCheckWater:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idColorCheckWater:SetText(T({681, "Water"}))
  self.idColorCheckWater:SetHint(hint_connectedgrid)

  self.idColorCheckElec = CheckButton:new(self)
  self.idColorCheckElec:SetPos(point(645, 400))
  self.idColorCheckElec:SetSize(point(85, 17))
  self.idColorCheckElec:SetVisible(false)
  self.idColorCheckElec:SetButtonSize(point(16, 16))
  self.idColorCheckElec:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idColorCheckElec:SetText("Electricity")
  self.idColorCheckElec:SetHint(hint_connectedgrid)

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()
end

DefineClass.ChoGGi_ListChoiceCustomDialog = {
  __parents = {
    "ChoGGi_ListChoiceCustomDialog_Defaults"
  },
  ZOrder = zorder
}

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
  pcall(function()
    local num = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetText())
    self.idColorHSV:SetHSV(UIL.RGBtoHSV(GetRGB(num)))
    self.idColorHSV:InitHSVPtPos()
    self.idColorHSV:Invalidate()
  end)
end

function ChoGGi_ListChoiceCustomDialog:GetAllItems()
  --always start with blank choices
  self.choices = {}
  --get sel item(s)
  local items
  if self.CustomType == 0 or self.CustomType == 3 or self.CustomType == 6 then
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
    --add checkbox statuses
    self.choices[1].check1 = self.idCheckBox1:GetToggled()
    self.choices[1].check2 = self.idCheckBox2:GetToggled()
    self.choices[1].checkair = self.idColorCheckAir:GetToggled()
    self.choices[1].checkwater = self.idColorCheckWater:GetToggled()
    self.choices[1].checkelec = self.idColorCheckElec:GetToggled()
  end
end

--function ChoGGi_ListChoiceCustomDialog:OnKbdKeyDown(char, virtual_key)
function ChoGGi_ListChoiceCustomDialog:OnKbdKeyDown(_, virtual_key)
  if virtual_key == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  elseif virtual_key == const.vkEnter then
    self.idOK:Press()
    return "break"
    --[[
  elseif virtual_key == const.vkSpace then
    self.idCheckBox1:SetToggled(not self.idCheckBox1:GetToggled())
    return "break"
    --]]
  end
  return "continue"
end
