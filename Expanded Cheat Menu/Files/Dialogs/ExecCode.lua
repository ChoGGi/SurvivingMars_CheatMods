-- See LICENSE for terms

-- shows a dialog with a single line edit to execute code in

if g_Classes.ChoGGi_ExecCodeDlg then
  return
end

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName

DefineClass.ChoGGi_ExecCodeDlg = {
  __parents = {"ChoGGi_Window"},
  code = false,
  obj = false,
}

function ChoGGi_ExecCodeDlg:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes
  local dlgConsole = dlgConsole
  local point = point

  self.dialog_width = 600
  self.dialog_height = 150
  self.obj = context.obj
  self.title = Concat(S[302535920000040--[[Exec Code--]]],": ",RetName(self.obj))

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self:AddScrollEdit(context)
  -- start off with this as code
  self.idEdit:SetText(GetFromClipboard() or "ChoGGi.CurObj")
  -- focus on textbox and move cursor to end of text
  self.idEdit:SetFocus()
  self.idEdit:SetCursor(1,#self.idEdit:GetText())
  self.idEdit:SetRolloverText(S[302535920000072--[["Paste or type code to be executed here.
Press Ctrl-Enter or Shift-Enter to execute code."--]]])
  self.idEdit.OnKbdKeyDown = function(obj, vk)
    return self:idEditOnKbdKeyDown(obj, vk)
  end

  self.idButtonContainer = g_Classes.XWindow:new({
    Id = "idButtonContainer",
    Padding = box(4,8,4,4),
    Dock = "bottom",
  }, self.idDialog)

  self.idOK = g_Classes.ChoGGi_Button:new({
    Id = "idOK",
    Dock = "left",
    Text = S[302535920000040--[[Exec Code--]]],
    RolloverText = S[302535920000073--[[Exec code (Ctrl-Enter or Shift-Enter to execute code).--]]],
    Margins = box(10, 0, 0, 0),
    MinWidth = 100,
    OnPress = function()
      -- exec instead of also closing dialog
      ChoGGi.CurObj = self.obj
      -- use console to exec code so we can show results in it
      ShowConsoleLog(true)
      dlgConsole:Exec(self.idEdit:GetText())
    end,
  }, self.idButtonContainer)

  self.idInsertObj = g_Classes.ChoGGi_Button:new({
    Id = "idInsertObj",
    Dock = "left",
    Text = S[302535920000075--[[Insert Obj--]]],
    RolloverText = S[302535920000076--[[At caret position inserts: ChoGGi.CurObj--]]],
    Margins = box(10, 0, 0, 0),
    MinWidth = 100,
    OnMouseButtonDown = function()
--~       local line = self.idEdit.cursor_line
--~       local pos = utf8.len(self.idEdit.lines[line])
--~       local text = self.idEdit:GetText()
--~       self.idEdit:SetText(Concat(utf8.sub(text,1,pos),"ChoGGi.CurObj",utf8.sub(text,pos+1)))
--~       self.idEdit:SetCursor(line,pos+13)

      local text = self.idEdit:GetText()
      local _,before = self.idEdit:OneCharBeforeCursor()
      local line,after = self.idEdit:OneCharAfterCursor()
      print(before,"|",after)
      self.idEdit:SetText(Concat(text:sub(1,before),"ChoGGi.CurObj",text:sub(after)))
      self.idEdit:SetCursor(line,after+12)

    end,
  }, self.idButtonContainer)

  self.idCancel = g_Classes.ChoGGi_Button:new({
    Id = "idCancel",
    Dock = "right",
    Text = S[6879--[[Cancel--]]],
    RolloverText = S[302535920000074--[[Cancel without changing anything.--]]],
    Margins = box(0, 0, 10, 0),
    OnPress = self.idCloseX.OnPress,
  }, self.idButtonContainer)
end

local IsKeyPressed = terminal.IsKeyPressed
local shift_key = const.vkShift
local ctrl_key = Platform.osx and const.vkLwin or const.vkControl
function ChoGGi_ExecCodeDlg:idEditOnKbdKeyDown(obj,vk)
  if vk == const.vkEnter then
    if IsKeyPressed(shift_key) or IsKeyPressed(ctrl_key) then
      self.idOK:Press()
    end
    return "break"
  elseif vk == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  end
  return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
end
