-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

DefineClass.ChoGGi_ConsoleLogWin = {
  __parents = {"ChoGGi_Window"},
  transp_mode = false,
  update_thread = false,
}

function ChoGGi_ConsoleLogWin:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes

  self.dialog_width = 700
  self.dialog_height = 500

  self.title = 302535920001120--[[Console Log Window--]]

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
    Id = "idButtonContainer",
    Dock = "top",
  }, self.idDialog)

  self.idToggleTrans = g_Classes.ChoGGi_CheckButton:new({
    Id = "idToggleTrans",
    Text = S[302535920000865--[[Toggle Trans--]]],
    Dock = "left",
    OnChange = function()
      self.transp_mode = not self.transp_mode
      self:SetTranspMode(self.transp_mode)
    end,
  }, self.idButtonContainer)
  self.idToggleTrans:AddInterpolation{
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  }

  self.idShowFileLog = g_Classes.ChoGGi_Button:new({
    Id = "idShowFileLog",
    Dock = "left",
    Text = S[302535920001026--[[Show File Log--]]],
    RolloverText = S[302535920001091--[[Flushes log to disk and displays in console log.--]]],
    OnMouseButtonDown = function()
      FlushLogFile()
      print(select(2,AsyncFileToString(GetLogFile())))
    end,
  }, self.idButtonContainer)

  self.idShowModsLog = g_Classes.ChoGGi_Button:new({
    Id = "idShowModsLog",
    Dock = "left",
    Text = S[302535920000071--[[Mods Log--]]],
    RolloverText = S[302535920000870--[[Shows any errors from loading mods in console log.--]]],
    OnMouseButtonDown = function()
      print(ModMessageLog)
    end,
  }, self.idButtonContainer)

  self.idClearLog = g_Classes.ChoGGi_Button:new({
    Id = "idClearLog",
    Dock = "left",
    Text = S[302535920000734--[[Clear Log--]]],
    RolloverText = S[302535920000477--[[Clear out the windowed console log.--]]],
    OnMouseButtonDown = function()
      self.idText:SetText("")
    end,
  }, self.idButtonContainer)

  self.idCopyText = g_Classes.ChoGGi_Button:new({
    Id = "idCopyText",
    Dock = "left",
    Text = S[302535920000563--[[Copy Log Text--]]],
    RolloverText = S[302535920001154--[[Displays the log text in a window you can copy sections from.--]]],
    OnMouseButtonDown = function()
      ChoGGi.ComFuncs.SelectConsoleLogText()
    end,
  }, self.idButtonContainer)

  -- text box with log in it
  self:AddScrollText()
end

function ChoGGi_ConsoleLogWin:SetTranspMode(toggle)
  self:ClearModifiers()
  if toggle then
    self:AddInterpolation{
      type = const.intAlpha,
      startValue = 32
    }
    self.idToggleTrans:AddInterpolation{
      type = const.intAlpha,
      startValue = 200,
      flags = const.intfIgnoreParent
    }
  end
end
dlgChoGGi_ConsoleLogWin = rawget(_G, "dlgChoGGi_ConsoleLogWin") or false

function ChoGGi_ConsoleLogWin:Done(result)
  local ChoGGi = ChoGGi
  -- closing means user doesn't want to see it next time (probably)
  ChoGGi.UserSettings.ConsoleHistoryWin = false
  dlgChoGGi_ConsoleLogWin = false
  ChoGGi.SettingFuncs.WriteSettings()
  -- save the dimensions
  ChoGGi.UserSettings.ConsoleLogWin_Pos = self:GetPos()
  ChoGGi.UserSettings.ConsoleLogWin_Size = self:GetSize()
  Dialog.Done(self,result)
end

function OnMsg.ConsoleLine(text, bNewLine)
  local dlg = dlgChoGGi_ConsoleLogWin
  if dlg then
    local old_text = dlg.idText:GetText()

    if bNewLine then
      text = Concat(old_text,"\n",text)
    else
      text = Concat(old_text,text)
    end
    dlg.idText:SetText(text)

    -- always scroll to end of text
    dlg.idScrollBox:ScrollTo(0, utf8.len(text))
  end
end
