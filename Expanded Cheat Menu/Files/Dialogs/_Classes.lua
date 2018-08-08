-- See LICENSE for terms

local S = ChoGGi.Strings

local RGB = RGB
local box = box
local point = point

local white = white
local black = black
local dark_gray = -13158858
local light_gray = -2368549

DefineClass.ChoGGi_Text = {
  __parents = {"XText"},
  -- needed for SetBox
  -- default
  Background = dark_gray,
  TextColor = white,
  -- focused
  FocusedBackground = dark_gray,
  RolloverTextColor = white,
  -- selected
  SelectionBackground = light_gray,
  SelectionColor = black,

  WordWrap = false,
--~     MaxLen = 65536, --65536?
}

DefineClass.ChoGGi_CloseButton = {
  __parents = {"XTextButton"},
  RolloverTemplate = "Rollover",
  RolloverText = S[1011--[[Close--]]],
  RolloverTitle = S[126095410863--[[Info--]]],
--~   Image = "CommonAssets/UI/Controls/Button/Close.tga",
  Image = "UI/Common/mission_no.tga",
  Dock = "top",
  HAlign = "right",
  ZOrder = 99,
  Margins = box(0, -20, 0, 0),
}

-- 1 above console log
--~ local zorder = 2000001

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

function ChoGGi_Dialog:AddElements(parent,context)
  local g_Classes = g_Classes

  parent.idSizeControl = g_Classes.XSizeControl:new({
    ZOrder = 98,
  }, self)

  parent.idMoveControl = g_Classes.XMoveControl:new({
    MinHeight = 30,
    Margins = box(0, -30, 0, 0),
    VAlign = "top",
    ZOrder = 97,
  }, self)

  parent.idCloseX = ChoGGi_CloseButton:new({
    OnPress = context.func or function()
      parent:delete()
    end,
  }, self)

  parent.idTitle = g_Classes.XLabel:new({
    Dock = "top",
    HAlign = "center",
    FontStyle = "Editor12Bold",
    Margins = box(4, 2, 4, 2),
    Translate = self.Translate,
    TextColor = light_gray,
  }, self)
  parent.idTitle:SetText(parent.title or S[1000016--[[Title--]]])

end

DefineClass.ChoGGi_Window = {
  __parents = {"XWindow"},
}

function ChoGGi_Window:SetPos(obj)
--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()

  local x,y,w,h
  if IsPoint(obj) then
    local box = self.idContainer.box
    x = obj:x()
    y = obj:y()
    w = box:sizex()
    h = box:sizey()
  else
    -- it's a copy of examine wanting a new window offset
    obj = obj.idContainer.box
    x = obj:minx()
    y = obj:miny() + 30
    w = obj:sizex()
    h = obj:sizey()
  end

  self.idContainer:SetBox(x,y,w,h)
end
