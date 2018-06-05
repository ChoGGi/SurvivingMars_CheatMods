-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_ListChoiceCustomDialog_Designer = {
  __parents = {
    "FrameWindow"
  }
}

function ChoGGi_ListChoiceCustomDialog_Designer:Init()
  local ChoGGi = ChoGGi

  self:SetPos(point(100, 100))
  self:SetSize(point(400, 450))
  self:SetMinSize(point(50, 50))
  self:SetTranslate(false)
  self:SetMovable(true)
  self:SetZOrder(zorder)

  ChoGGi.ComFuncs.DialogAddCaption({self = self,pos = point(105, 101),size = point(390, 22)})
  ChoGGi.ComFuncs.DialogAddCloseX(self,point(479, 103))

  local obj

  obj = List:new(self)
  obj:SetId("idList")
  obj:SetShowPartialItems(true)
  obj:SetSelectionColor(RGB(0, 0, 0))
  obj:SetSelectionFontStyle("Editor14")
  obj:SetRolloverFontStyle("Editor14")
  obj:SetFontStyle("Editor14")
  obj:SetPos(point(105, 123))
  obj:SetSize(point(390, 335))
  obj:SetHSizing("Resize")
  obj:SetVSizing("Resize")
  obj:SetSpacing(point(8, 2))
  obj:SetScrollBar(true)
  obj:SetScrollAutohide(true)

  obj = SingleLineEdit:new(self)
  obj:SetId("idEditValue")
  obj:SetAutoSelectAll(true)
  obj:SetFontStyle("Editor14Bold")
  obj:SetPos(point(110, 465))
  obj:SetSize(point(375, 24))
  obj:SetHSizing("Resize")
  obj:SetVSizing("AnchorToBottom")
  obj:SetHint("You can enter a custom value to be applied.\n\nWarning: Entering the wrong value may crash the game or otherwise cause issues.")
  obj:SetTextVAlign("center")

  obj = CheckButton:new(self)
  obj:SetId("idCheckBox1")
  obj:SetPos(point(110, 440))
  obj:SetSize(point(200, 17))
  obj:SetText(T({588, "Empty"}))
  obj:SetButtonSize(point(16, 16))
  obj:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  obj:SetHSizing("AnchorToMidline")
  obj:SetVSizing("AnchorToBottom")

  obj = CheckButton:new(self)
  obj:SetId("idCheckBox2")
  obj:SetText(T({588, "Empty"}))
  obj:SetPos(point(300, 440))
  obj:SetSize(point(200, 17))
  obj:SetButtonSize(point(16, 16))
  obj:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  obj:SetHSizing("AnchorToMidline")
  obj:SetVSizing("AnchorToBottom")

  obj = Button:new(self)
  obj:SetId("idOK")
  obj:SetPos(point(110, 500))
  obj:SetSize(point(129, 34))
  obj:SetHSizing("AnchorToMidline")
  obj:SetVSizing("AnchorToBottom")
  obj:SetFontStyle("Editor14Bold")
  obj:SetText(T({1000429, "OK"}))
  obj:SetHint("Apply and close dialog (Arrow keys and Enter/Esc can also be used).")

  obj = Button:new(self)
  obj:SetId("idClose")
  obj:SetPos(point(353, 500))
  obj:SetSize(point(132, 34))
  obj:SetHSizing("AnchorToMidline")
  obj:SetVSizing("AnchorToBottom")
  obj:SetFontStyle("Editor14Bold")
  obj:SetHint("Cancel without changing anything.")
  obj:SetText(T({1000430, "Cancel"}))

  obj = ColorHSVControl:new(self)
  obj:SetId("idColorHSV")
  obj:SetPos(point(500, 115))
  obj:SetSize(point(300, 300))
  obj:SetVisible(false)
  obj:SetHint("Double right click to set without closing dialog.")

  local hint_connectedgrid = "Check this for \"All of type\" to only apply to connected grid."

  obj = CheckButton:new(self)
  obj:SetId("idColorCheckAir")
  obj:SetPos(point(525, 400))
  obj:SetSize(point(50, 17))
  obj:SetVisible(false)
  obj:SetButtonSize(point(16, 16))
  obj:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  obj:SetText(T({891, "Air"}))
  obj:SetHint(hint_connectedgrid)

  obj = CheckButton:new(self)
  obj:SetId("idColorCheckWater")
  obj:SetPos(point(575, 400))
  obj:SetSize(point(60, 17))
  obj:SetVisible(false)
  obj:SetButtonSize(point(16, 16))
  obj:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  obj:SetText(T({681, "Water"}))
  obj:SetHint(hint_connectedgrid)

  obj = CheckButton:new(self)
  obj:SetId("idColorCheckElec")
  obj:SetPos(point(645, 400))
  obj:SetSize(point(85, 17))
  obj:SetVisible(false)
  obj:SetButtonSize(point(16, 16))
  obj:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  obj:SetText("Electricity")
  obj:SetHint(hint_connectedgrid)

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()

  self:SetPos(point(100, 100))
  self:SetSize(point(400, 450))
end

DefineClass.ChoGGi_ListChoiceCustomDialog = {
  __parents = {
    "ChoGGi_ListChoiceCustomDialog_Designer"
  },
  ZOrder = zorder
}

--ex(ChoGGi.ListChoiceCustomDialog_Dlg)
--ChoGGi.ListChoiceCustomDialog_Dlg.colorpicker
function ChoGGi_ListChoiceCustomDialog:Init()

  --defaults
  self.idEditValue.display_text = "Add Custom Value"
  self.choices = false
  self.sel = false
  self.obj = false
  self.CustomType = 0
  self.colorpicker = nil
  self.Func = false
  --have to do it for each item?
  --self.idList:SetHSizing("Resize")

  --add some padding before the text
  --self.idEditValue.DisplacementPos = 0
  --self.idEditValue.DisplacementWidth = 10

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

  --return values
  function self.idOK.OnButtonPressed()
    --item list
    self:GetAllItems()
    --send selection back
    self:delete(self.choices)
  end

  --close without doing anything
  local function Close()
    self:delete()
  end
  self.idClose.OnButtonPressed = Close
  self.idCloseX.OnButtonPressed = Close

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

  --do stuff on selection
  local origOnLButtonDown = self.idList.OnLButtonDown
  self.idList.OnLButtonDown = function(selfList,...)
    local ret = origOnLButtonDown(selfList,...)
    local sel = self.idList:GetSelection()
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
            self.idColorHSV:SetVisible(true)
            self:SetWidth(800)
            self.idColorHSV:SetPos(point(500, 115))
          else
            self.idColorHSV:SetVisible(false)
            --self:SetWidth(400)
          end
        end
      end
    end

    --for whatever is expecting a return value
    return ret
  end

  --what happens when you dbl click the list
  self.idList.OnLButtonDoubleClick = function()
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

  self.idList.OnRButtonDoubleClick = function()
    --applies the lightmodel without closing dialog,
    if self.CustomType == 5 then
      self:BuildAndApplyLightmodel()
    elseif self.CustomType == 6 and self.Func then
      self.Func(self.sel.func)
    else
      self.idEditValue:SetText(self.sel.text)
    end
  end

  --stop idColorHSV from closing on dblclick
  self.idColorHSV.OnLButtonDoubleClick = function()
  end
  self.idColorHSV.OnRButtonDoubleClick = function()
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

  --hook into SetContent so we can add OnSetState to each list item to show hints
  self.idList.Orig_SetContent = self.idList.SetContent
  function self.idList:SetContent(items)
    self.Orig_SetContent(self,items)
    local listitems = self.item_windows
    for i = 1, #listitems do
      local listitem = listitems[i]
      listitem.Orig_OnSetState = listitem.OnSetState
      function listitem:OnSetState(list, item, rollovered, selected)
        self.Orig_OnSetState(self,list, item, rollovered, selected)
        if rollovered or selected then
          local hint = item.text
          if item.value then
            if type(item.value) == "userdata" then
              hint = hint .. ": " .. ChoGGi.ComFuncs.Trans(item.value)
            elseif item.value then
              hint = hint .. ": " .. tostring(item.value)
            end
          end
          if type(item.hint) == "userdata" then
            hint = hint .. "\n\n" .. ChoGGi.ComFuncs.Trans(item.hint)
          elseif item.hint then
            hint = hint .. "\n\n" .. item.hint
          end
          --self.parent.parent:SetHint(hint)
          self.parent:SetHint(hint)
        end
      end
    end
  end
end --init

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
    if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
      self.idClose:Press()
    end
    self:SetFocus()
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
