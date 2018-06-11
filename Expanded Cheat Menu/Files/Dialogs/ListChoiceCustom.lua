--See LICENSE for terms

--~ local Concat = ChoGGi.ComFuncs.Concat
local TConcat = ChoGGi.ComFuncs.TableConcat
local T = ChoGGi.ComFuncs.Trans

local type,tostring,table = type,tostring,table

local CreateRealTimeThread = CreateRealTimeThread
local CreateRolloverWindow = CreateRolloverWindow
local GetRGB = GetRGB
local point = point
local SetLightmodel = SetLightmodel
local RGB,RGBA = RGB,RGBA

local UIL_RGBtoHSV = UIL.RGBtoHSV

local g_Classes = g_Classes

--ex(ChoGGi.ListChoiceCustomDialog_Dlg)
--ChoGGi.ListChoiceCustomDialog_Dlg.colorpicker

-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_ListChoiceCustomDialog = {
  __parents = {"FrameWindow"},
  ZOrder = zorder,
  choices = false,
  sel = false,
  obj = false,
  CustomType = 0,
  colorpicker = false,
  Func = false,
}

function ChoGGi_ListChoiceCustomDialog:Init()
  local ChoGGi = ChoGGi

  --element pos is based on
  self:SetPos(point(0,0))

  local dialog_width = 400
  local dialog_height = 440
  self:SetSize(point(dialog_width, dialog_height))
  self:SetMinSize(point(50, 50))
  self:SetMovable(true)
  self:SetTranslate(false)

  local border = 4
  local element_y
  local element_x
  dialog_width = dialog_width - border * 2
  local dialog_left = border

  ChoGGi.ComFuncs.DialogAddCloseX(self)
  ChoGGi.ComFuncs.DialogAddCaption(self,{
    pos = point(25, border),
    size = point(dialog_width-self.idCloseX:GetSize():x(), 22)
  })

  element_y = self.idCaption:GetPos():y() + self.idCaption:GetSize():y()

  local idList_height = 330
  self.idList = g_Classes.List:new(self)
  self.idList:SetPos(point(dialog_left, element_y-2))
  self.idList:SetSize(point(dialog_width, idList_height))
  self.idList:SetShowPartialItems(true)
  self.idList:SetBackgroundColor(RGBA(0, 0, 0, 50))
  self.idList:SetSelectionColor(RGB(0, 0, 0))
  self.idList:SetSelectionFontStyle("Editor14")
  self.idList:SetRolloverFontStyle("Editor14")
  self.idList:SetFontStyle("Editor14")
  self.idList:SetHSizing("Resize")
  self.idList:SetVSizing("Resize")
  self.idList:SetSpacing(point(8, 2))
  self.idList:SetScrollBar(true)
  self.idList:SetScrollAutohide(true)

  element_y = border + self.idList:GetPos():y() + self.idList:GetSize():y()
  local halfish_for_checks = (dialog_width - 10) / 2

  self.idCheckBox1 = g_Classes.CheckButton:new(self)
  self.idCheckBox1:SetPos(point(dialog_left+15, element_y))
  self.idCheckBox1:SetSize(point(halfish_for_checks, 17))
  self.idCheckBox1:SetText(T(588--[[Empty--]]))
  self.idCheckBox1:SetButtonSize(point(16, 16))
  self.idCheckBox1:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idCheckBox1:SetHSizing("AnchorToMidline")
  self.idCheckBox1:SetVSizing("AnchorToBottom")

  element_x = border * 2 + self.idCheckBox1:GetPos():x() + self.idCheckBox1:GetSize():x()

  self.idCheckBox2 = g_Classes.CheckButton:new(self)
  self.idCheckBox2:SetPos(point(element_x, element_y))
  self.idCheckBox2:SetSize(point(halfish_for_checks, 17))
  self.idCheckBox2:SetText(T(588--[[Empty--]]))
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

  element_y = 4 + self.idCheckBox2:GetPos():y() + self.idCheckBox2:GetSize():y()

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
            hint[#hint+1] = item.hint
          end
          self.parent:SetHint(TConcat(hint))
          CreateRolloverWindow(self.parent, TConcat(hint), true)
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
    if type(sel) == "table" and #sel > 0 then
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
          else
            self.idColorHSV:SetVisible(false)
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

  self.idEditValue = g_Classes.SingleLineEdit:new(self)
  self.idEditValue:SetPos(point(dialog_left, element_y))
  self.idEditValue:SetSize(point(dialog_width, 24))
  self.idEditValue:SetAutoSelectAll(true)
  self.idEditValue:SetFontStyle("Editor14Bold")
  self.idEditValue:SetHSizing("Resize")
  self.idEditValue:SetVSizing("AnchorToBottom")
  self.idEditValue:SetHint(T(302535920000077--[[You can enter a custom value to be applied.\n\nWarning: Entering the wrong value may crash the game or otherwise cause issues.--]]))
  self.idEditValue:SetTextVAlign("center")
  self.idEditValue.display_text = T(302535920000078--[[Add Custom Value--]])
  --update custom value list item
  function self.idEditValue.OnValueChanged()
    local value = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetValue())

    if self.CustomType > 0 then
      self.idList.items[self.idList.last_selected].value = value
    else
      self.idList:SetItem(#self.idList.items,{
        text = value,
        value = value,
        hint = T(302535920000079,"< Use custom value")
      })
    end
  end

  element_y = 4 + self.idEditValue:GetPos():y() + self.idEditValue:GetSize():y()

  local title = T(1000429--[[OK--]])
  self.idOK = g_Classes.Button:new(self)
  self.idOK:SetPos(point(dialog_left+20, element_y))
  self.idOK:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idOK:SetHSizing("AnchorToLeft")
  self.idOK:SetVSizing("AnchorToBottom")
  self.idOK:SetFontStyle("Editor14Bold")
  self.idOK:SetText(title)
  self.idOK:SetHint(T(302535920000080--[[Apply and close dialog (Arrow keys and Enter/Esc can also be used).--]]))

  element_x = 100 + self.idOK:GetPos():x() + self.idOK:GetSize():x()

  --return values
  function self.idOK.OnButtonPressed()
    --item list
    self:GetAllItems()
    --send selection back
    self:delete(self.choices)
  end

  title = T(1000430--[[Cancel--]])
  self.idClose = g_Classes.Button:new(self)
  self.idClose:SetPos(point(element_x, element_y))
  self.idClose:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idClose:SetHSizing("AnchorToLeft")
  self.idClose:SetVSizing("AnchorToBottom")
  self.idClose:SetFontStyle("Editor14Bold")
  self.idClose:SetHint(T(302535920000074--[[Cancel without changing anything.--]]))
  self.idClose:SetText(title)
  self.idClose.OnButtonPressed = self.idCloseX.OnButtonPressed

  --new height/width for colour controls
  element_y = self.idCaption:GetPos():y() + self.idCaption:GetSize():y()

  self.idColorHSV = g_Classes.ColorHSVControl:new(self)
  self.idColorHSV:SetPos(point(dialog_width - 325, element_y)) --for some reason this is ignored till visible, unlike checkmarks
  self.idColorHSV:SetSize(point(300, 300))
  self.idColorHSV:SetHSizing("AnchorToRight")
  self.idColorHSV:SetVSizing("AnchorToTop")
  self.idColorHSV:SetVisible(false)
  self.idColorHSV:SetHint(T(302535920000081--[[Double right-click to set without closing dialog.--]]))
  --stop idColorHSV from closing on dblclick
  function self.idColorHSV.OnLButtonDoubleClick()
  end
  --apply colour on dbl r-click
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
  --and update custom value when dbl r-click
  function self.OnColorChanged(color)
    --update item
    self.idList.items[self.idList.last_selected].value = color
    --custom value box
    self.idEditValue:SetText(tostring(color))
  end

  local hint_connectedgrid = T(302535920000082--[[Check this for \"All of type\" to only apply to connected grid.--]])

  element_y = self.idColorHSV:GetPos():y() + self.idColorHSV:GetSize():y()
  local offset = 50

  --right to left positioning for checks as we use AnchorToRight
  title = T(302535920000037--[[Electricity--]])
  local title_size = ChoGGi.ComFuncs.RetCheckTextSize(title)
  self.idColorCheckElec = g_Classes.CheckButton:new(self)
  self.idColorCheckElec:SetPos(point(dialog_width - border - title_size:x() - offset, element_y))
  self.idColorCheckElec:SetSize(title_size)
  self.idColorCheckElec:SetHSizing("AnchorToRight")
  self.idColorCheckElec:SetVSizing("AnchorToTop")
  self.idColorCheckElec:SetVisible(false)
  self.idColorCheckElec:SetButtonSize(point(16, 16))
  self.idColorCheckElec:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idColorCheckElec:SetText(title)
  self.idColorCheckElec:SetHint(hint_connectedgrid)

  element_x = border * 2 + self.idColorCheckElec:GetSize():x()

  title = T(891--[[Air--]])
  title_size = ChoGGi.ComFuncs.RetCheckTextSize(title)
  self.idColorCheckAir = g_Classes.CheckButton:new(self)
  self.idColorCheckAir:SetPos(point(dialog_width - title_size:x() - element_x - offset, element_y))
  self.idColorCheckAir:SetSize(title_size)
  self.idColorCheckAir:SetHSizing("AnchorToRight")
  self.idColorCheckAir:SetVSizing("AnchorToTop")
  self.idColorCheckAir:SetVisible(false)
  self.idColorCheckAir:SetButtonSize(point(16, 16))
  self.idColorCheckAir:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idColorCheckAir:SetText(title)
  self.idColorCheckAir:SetHint(hint_connectedgrid)

  element_x = border * 2 + self.idColorCheckAir:GetPos():x()

  title = T(681--[[Water--]])
  self.idColorCheckWater = g_Classes.CheckButton:new(self)
  self.idColorCheckWater:SetPos(point(dialog_width - element_x - offset - 25, element_y))
  self.idColorCheckWater:SetSize(ChoGGi.ComFuncs.RetCheckTextSize(title))
  self.idColorCheckWater:SetHSizing("AnchorToRight")
  self.idColorCheckWater:SetVSizing("AnchorToTop")
  self.idColorCheckWater:SetVisible(false)
  self.idColorCheckWater:SetButtonSize(point(16, 16))
  self.idColorCheckWater:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idColorCheckWater:SetText(title)
  self.idColorCheckWater:SetHint(hint_connectedgrid)

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()

  --if i don't have this than there's a chunk of empy beneath it (till user resizes)
  CreateRealTimeThread(function()
    self.idList:SetSize(point(dialog_width, idList_height))
  end)
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
--~   pcall(function()
    local num = ChoGGi.ComFuncs.RetProperType(self.idEditValue:GetText())
    if type(num) == "number" then
      self.idColorHSV:SetHSV(UIL_RGBtoHSV(GetRGB(num)))
      self.idColorHSV:InitHSVPtPos()
      self.idColorHSV:Invalidate()
    end
--~   end)
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
  local const = const
  if virtual_key == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  elseif virtual_key == const.vkEnter then
    self.idOK:Press()
    return "break"
--~   elseif virtual_key == const.vkSpace then
--~     self.idCheckBox1:SetToggled(not self.idCheckBox1:GetToggled())
--~     return "break"
  end
  return "continue"
end
