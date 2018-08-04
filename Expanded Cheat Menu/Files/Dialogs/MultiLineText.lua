-- See LICENSE for terms

-- displays text in a selectable text box

if g_Classes.ChoGGi_MultiLineText then
  return
end

--~ local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

DefineClass.ChoGGi_MultiLineText = {
  __parents = {"XDialog"},
  HandleKeyboard = true,
  Translate = false,
  HAlign = "center",
  VAlign = "center",
  BackgroundColor = RGBA(0, 0, 0, 16),
  func = false,
  XRolloverWindow_ZOrder = false,
  overwrite = false,
}

function ChoGGi_MultiLineText:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes
  local white = white
  local black = black
  local dark_gray = -13158858
  local light_gray = -2368549

  --build container
  g_Classes.StdDialog.Init(self, parent, context)

  --damn modal
  self:SetModal(false)
  self:SetTranslate(false)

  --size it
  local width,height = 500,250
  local size = UIL.GetScreenSize()
  if size:x() > 1024 then
    width = 1000
  end
  if size:y() > 768 then
    height = 500
  end

  local z = context.zorder or 1
  -- so we're on top of examine
  z = z + 1
  self:SetZOrder(z)
  self.XRolloverWindow_ZOrder = g_Classes.XRolloverWindow.ZOrder
  g_Classes.XRolloverWindow.ZOrder = z+1

  --add a little spacing
  self.idContainer:SetMargins(box(0, 6, 6, 0))
  self.idContainer:SetBackground(dark_gray)
  self:SetBorderColor(white)
  --store func for calling from :OnShortcut
  self.func = context.func

  g_Classes.XMultiLineEdit:new({
    Id = "idText",
--~     TextVAlign = "center",
    MinWidth = width,
    MaxWidth = width,
    MinHeight = height,
    TextFont = "Editor16",
    --default
    Background = dark_gray,
    TextColor = white,
    --focused
    FocusedBackground = dark_gray,
    RolloverTextColor = white,
    --selected
    SelectionBackground = light_gray,
    SelectionColor = black,

    WordWrap = context.wrap,
    MaxLen = 65536, --65536?
--~     MaxLines = 15,
  }, self.idContainer)

  self.idText:SetText(context.text)

  g_Classes.XSleekScroll:new({
    Id = "idVScroll",
    Target = "idText",
    --vertical scroll
    Dock = "right",
    Max = context.text:len(),
    Margins = box(4, 1, -4, 1),
    --doesn't seem to work?
    AutoHide = true,
  }, self.idContainer)
  self.idVScroll.MinWidth = 15
  self.idVScroll.MaxWidth = 15
  self.idText.VScroll = "idVScroll"

--~ box(left,top, right, bottom)

  g_Classes.XSleekScroll:new({
    Id = "idHScroll",
    Target = "idText",
    Dock = "bottom",
    Horizontal = true,
    Max = context.text:len(),
    Margins = box(1, 4, 1, 1),
    AutoHide = true,
  }, self.idContainer)
  self.idHScroll.MinHeight = 15
  self.idHScroll.MaxHeight = 15
  self.idText.HScroll = "idHScroll"

  if context.checkbox then
    g_Classes.XCheckButton:new({
      RolloverTemplate = "Rollover",
      RolloverText = S[302535920000827--[[Check this to overwrite file instead of appending to it.--]]],
      RolloverTitle = S[302535920000721--[[Checkbox--]]],

      OnChange = function()
        if self.overwrite then
          self.overwrite = false
        else
          self.overwrite = "w"
        end
      end
    }, self.idButtonContainer)
  end

  ChoGGi.ComFuncs.DialogXAddButton(
    self.idButtonContainer,
    S[6878--[[OK--]]],
    ChoGGi.ComFuncs.CheckText(context.hint_ok,S[6878--[[OK--]]]),
    function()
      self:Close(true,"ok")
    end
  )

  ChoGGi.ComFuncs.DialogXAddButton(
    self.idButtonContainer,
    S[6879--[[Cancel--]]],
    ChoGGi.ComFuncs.CheckText(context.hint_cancel,S[6879--[[Cancel--]]]),
    function()
      self:Close(false,"cancel")
    end
  )

end

function ChoGGi_MultiLineText:OnShortcut(shortcut, _)
  if shortcut == "Enter" then
    self:Close(true,"ok")
  elseif self.context.question and shortcut == "Escape" then
    self:Close(false,"cancel")
  end
end

function ChoGGi_MultiLineText:Close(answer,result)
  local g_Classes = g_Classes
  g_Classes.XRolloverWindow.ZOrder = self.XRolloverWindow_ZOrder

  if self.func then
    self.func(answer,self.overwrite,self)
  end
  g_Classes.XDialog.Close(self,result)
end


--[[
local dialog = ChoGGi_MultiLineText:new({}, terminal.desktop,{})
dialog:Open()
OpenGedApp("XWindowInspector", dialog)
FontStyles.Consolas13 = "Consolas, 13, aa"
FontStyles.Consolas15 = "Consolas, 15, aa"

--]]
