-- See LICENSE for terms

-- displays text in a selectable text box

if g_Classes.ChoGGi_MultiLineText then
  return
end

--~ local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

local white = white
local black = black
local dark_gray = -13158858
local light_gray = -2368549

DefineClass.ChoGGi_MultiLineText = {
  __parents = {"ChoGGi_Window"},

--~   HAlign = "center",
--~   VAlign = "center",
--~   BackgroundColor = RGBA(0, 0, 0, 16),
  HandleKeyboard = true,
  retfunc = false,
  overwrite = false,
}

function ChoGGi_MultiLineText:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes

--~   g_Classes.Examine:Open(parent, context)

  self.dialog_width = 500
  self.dialog_height = 400

  --store func for calling from :OnShortcut
  self.retfunc = context.func
  -- overwrite dumped file
  self.overwrite = context.overwrite
  -- pretty title
  self.title = context.title

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self:AddScrollAreaV()
  self:AddMultiTextScroll(context)
  self.idText:SetText(context.text)

  self.idButtonContainer = g_Classes.XWindow:new({
    Id = "idButtonContainer",
    Dock = "bottom",
  }, self.idDialog)

  if context.checkbox then
    g_Classes.ChoGGi_CheckButton:new({
      Dock = "left",
      Text = S[302535920000721--[[Overwrite--]]],
      RolloverText = S[302535920000827--[[Check this to overwrite file instead of appending to it.--]]],

      OnChange = function()
        if self.overwrite then
          self.overwrite = false
        else
          self.overwrite = "w"
        end
      end
    }, self.idButtonContainer)
  end

  self.idOkay = g_Classes.ChoGGi_Button:new({
    Id = "idOkay",
    Dock = "left",
    Text = S[6878--[[OK--]]],
    RolloverText = ChoGGi.ComFuncs.CheckText(context.hint_ok,S[6878--[[OK--]]]),
    OnMouseButtonDown = function(_,_,button)
      self:Close("ok",true)
    end,
  }, self.idButtonContainer)

  self.idCancel = g_Classes.ChoGGi_Button:new({
    Id = "idCancel",
    Dock = "right",
    Text = S[6879--[[Cancel--]]],
    RolloverText = ChoGGi.ComFuncs.CheckText(context.hint_cancel,S[6879--[[Cancel--]]]),
    OnMouseButtonDown = function(_,_,button)
      self:Close("cancel",false)
    end,
  }, self.idButtonContainer)

end

function ChoGGi_MultiLineText:OnShortcut(shortcut)
  if shortcut == "Enter" then
    self:Close("ok",true)
  elseif shortcut == "Escape" and self.context.question then
    self:Close("cancel",false)
  end
end

function ChoGGi_MultiLineText:Close(result,answer)
  if self.retfunc then
    self.retfunc(answer,self.overwrite,self)
  end
  ChoGGi_Window.Close(self,result)
end


--[[
local dialog = ChoGGi_MultiLineText:new({}, terminal.desktop,{})
dialog:Open()
OpenGedApp("XWindowInspector", dialog)
FontStyles.Consolas13 = "Consolas, 13, aa"
FontStyles.Consolas15 = "Consolas, 15, aa"

--]]
