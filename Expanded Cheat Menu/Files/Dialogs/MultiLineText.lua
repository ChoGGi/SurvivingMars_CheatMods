-- See LICENSE for terms

-- displays text in a selectable text box

--~ local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

DefineClass.ChoGGi_MultiLineText = {
  __parents = {"ChoGGi_Window"},
  retfunc = false,
  overwrite = false,
  context = false,
}

function ChoGGi_MultiLineText:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes

  self.dialog_width = 500
  self.dialog_height = 400

  self.context = context
  -- store func for calling from :OnShortcut
  self.retfunc = context.custom_func
  -- overwrite dumped file
  self.overwrite = context.overwrite

  self.title = context.title or 302535920001301--[[Edit Text--]]

  --
--~   context.func = self:Close("cancel",false)

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self:AddScrollEdit(context)
  self.idEdit:SetText(context.text)

  self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
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
    OnMouseButtonDown = function()
      self:Close("ok",true)
    end,
  }, self.idButtonContainer)

  self.idCancel = g_Classes.ChoGGi_Button:new({
    Id = "idCancel",
    Dock = "right",
    Text = S[6879--[[Cancel--]]],
    RolloverText = ChoGGi.ComFuncs.CheckText(context.hint_cancel,S[6879--[[Cancel--]]]),
    OnMouseButtonDown = function()
      self:Close("cancel",false)
    end,
  }, self.idButtonContainer)

  self:SetInitPos(context.parent)
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
OpenGedApp("XWindowInspector", dialog)
FontStyles.Consolas13 = "Consolas, 13, aa"
FontStyles.Consolas15 = "Consolas, 15, aa"

--]]
