-- See LICENSE for terms

local S = ChoGGi.Strings

local RGB = RGB
local box = box
local point = point

local white = white
local black = black
local dark_gray = -13158858
local light_gray = -2368549
local rollover_blue = RGB(24, 123, 197)

local text = "Editor12Bold"
if ChoGGi.testing then
  text = "Editor14Bold"
end
DefineClass.ChoGGi_Text = {
  __parents = {"XText"},
  -- default
  Background = dark_gray,
  TextColor = white,
  -- focused
  FocusedBackground = dark_gray,
  RolloverTextColor = white,
  -- selected
  SelectionBackground = light_gray,
  SelectionColor = black,
  TextFont = text,
  WordWrap = true,
}

DefineClass.ChoGGi_Buttons = {
  __parents = {"XTextButton"},
  RolloverTitle = S[126095410863--[[Info--]]],
  RolloverBackground = rollover_blue,
  RolloverTextColor = white,
}

DefineClass.ChoGGi_CloseButton = {
  __parents = {"ChoGGi_Buttons"},
  RolloverText = S[1011--[[Close--]]],
  RolloverAnchor = "right",
--~   Image = "CommonAssets/UI/Controls/Button/Close.tga",
  Image = "UI/Common/mission_no.tga",
  Dock = "top",
  HAlign = "right",
--~   ZOrder = 99,
--~   Margins = box(0, -20, 0, 0),
    Margins = box(0, 4, 2, 0),
}

DefineClass.ChoGGi_Button = {
  __parents = {"ChoGGi_Buttons"},
  MinWidth = 60,
  Text = S[6878--[[OK--]]],
  --center text
  LayoutMethod = "VList",
  Background = light_gray,
}
DefineClass.ChoGGi_ComboButton = {
  __parents = {"XComboButton"},
  Background = light_gray,
  RolloverTextColor = white,
}


DefineClass.ChoGGi_CheckButton = {
  __parents = {"XCheckButton"},
  RolloverTitle = S[302535920000721--[[Checkbox--]]],
  TextColor = white,
  RolloverTextColor = light_gray,
  MinWidth = 60,
  Text = S[6878--[[OK--]]],
}
function ChoGGi_CheckButton:Init()
--~   XCheckButton.Init(self)
  self.idIcon:SetBackground(light_gray)
end

DefineClass.ChoGGi_TextInput = {
  __parents = {"XEdit"},
--~   Multiline = false,
--~   WordWrap = false,
--~   AllowTabs = false,
  RolloverTitle = S[126095410863--[[Info--]]],
--~   -- text displayed till mouse/kb focus
--~   display_text = false,
}
--~ function ChoGGi_TextInput:Init()
--~   self:SetText(self.display_text or "")
--~ end

DefineClass.ChoGGi_Dialog = {
  __parents = {"XDialog"},
  Translate = false,
--~   min_size = point(50, 50),
  MinHeight = 50,
  MinWidth = 150,
  BackgroundColor = RGBA(0, 0, 0, 16),
  HAlign = "left",
  VAlign = "top",
--~   ZOrder = zorder,
  Dock = "ignore",
}

DefineClass.ChoGGi_Window = {
  __parents = {"XWindow"},
  dialog_width = 500,
  dialog_height = 500,
}

function ChoGGi_Window:AddElements(parent,context)
  local g_Classes = g_Classes

  -- add container dialog for everything to fit in
  self.idDialog = g_Classes.ChoGGi_Dialog:new({
    Background = dark_gray,
    BorderWidth = 2,
    BorderColor = light_gray,
  }, self)
--~   self.idDialog:Open(parent,context)

  self.idCaption = g_Classes.XWindow:new({
    Id = "idCaption",
    Dock = "top",
  }, self.idDialog)

  -- x,y,w,h (start off with all dialogs at 100,100, default size, and we move later)
  self.idDialog:SetBox(100, 100, self.dialog_width, self.dialog_height)

  self.idSizeControl = g_Classes.XSizeControl:new({
--~     ZOrder = 98,
  }, self.idDialog)

  self.idMoveControl = g_Classes.XMoveControl:new({
    MinHeight = 30,
    Margins = box(0, -30, 0, 0),
    VAlign = "top",
--~     ZOrder = 97,
  }, self.idCaption)

  self.idCloseX = ChoGGi_CloseButton:new({
    OnPress = context.func or function()
      self:delete()
    end,
  }, self.idCaption)

  self.idTitle = g_Classes.XLabel:new({
    Dock = "top",
    HAlign = "center",
    TextFont = "Editor14Bold",
    Margins = box(4, -20, 4, 2),
    Translate = self.Translate,
    TextColor = white,
    Text = self.title or S[1000016--[[Title--]]],
  }, self.idCaption)
--~   self.idTitle:SetText()
end

-- takes either a point, or box to set pos
function ChoGGi_Window:SetPos(obj)
--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()

  local x,y,w,h
  if IsPoint(obj) then
    local box = self.idDialog.box
    x = obj:x()
    y = obj:y()
    w = box:sizex()
    h = box:sizey()
  else
    -- it's a copy of examine wanting a new window offset
    obj = obj.idDialog.box
    x = obj:minx()
    y = obj:miny() + 25
    w = obj:sizex()
    h = obj:sizey()
  end
  -- make sure we can always move it
  if self.idDialog.Dock ~= "ignore" then
    self.idDialog:SetDock("ignore")
  end
  self.idDialog:SetBox(x,y,w,h)
end

-- scrollable textbox
function ChoGGi_Window:AddTextBox(parent,context)
  local g_Classes = g_Classes

  self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idScrollV",
    Target = "idScrollBox",
    Dock = "right",
  }, self.idDialog)

  self.idScrollH = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idScrollH",
    Target = "idScrollBox",
    Dock = "bottom",
    Horizontal = true,
  }, self.idDialog)

  self.idScrollBox = g_Classes.XScrollArea:new({
    Id = "idScrollBox",
    VScroll = "idScrollV",
    HScroll = "idScrollH",
    Margins = box(5,0,0,0),
  }, self.idDialog)

  self.idText = g_Classes.ChoGGi_Text:new({
    Id = "idText",
    OnHyperLink = function(_, link, _, box, pos, button)
      self.onclick_handles[tonumber(link)](box, pos, button)
    end,
  }, self.idScrollBox)

end

DefineClass.ChoGGi_SleekScroll = {
  __parents = {"XSleekScroll"},
  MinThumbSize = 30,
  AutoHide = true,
  Background = RGBA(0,0,0,0),
}

-- convenience function
function ChoGGi_SleekScroll:SetHorizontal()
  self.MinHeight = 10
  self.MaxHeight = 10
  self.MinWidth = 10
  self.MaxWidth = 10
end
