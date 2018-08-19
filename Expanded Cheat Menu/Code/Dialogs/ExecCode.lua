-- See LICENSE for terms

-- shows a dialog with a single line edit to execute code in

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName

DefineClass.ChoGGi_ExecCodeDlg = {
  __parents = {"ChoGGi_Window"},
  obj = false,
}

function ChoGGi_ExecCodeDlg:Init(parent, context)
  local ChoGGi = ChoGGi
  local g_Classes = g_Classes
  local dlgConsole = dlgConsole

  self.dialog_width = 700
  self.dialog_height = 240
  self.obj = context.obj
  self.title = Concat(S[302535920000040--[[Exec Code--]]],": ",RetName(self.obj))

  -- By the Power of Grayskull!
  self:AddElements(parent, context)

  self:AddScrollEdit()

  -- start off with this as code
  self.idEdit:SetText(GetFromClipboard() or "ChoGGi.CurObj")
  -- focus on text
  self.idEdit:SetFocus()
  -- hinty hint
  self.idEdit:SetRolloverText(S[302535920000072--[["Paste or type code to be executed here, ChoGGi.CurObj is the examined object.
Press Ctrl-Enter or Shift-Enter to execute code."--]]])
  -- let us override enter/esc
  self.idEdit.OnKbdKeyDown = function(obj, vk)
    return self:idEditOnKbdKeyDown(obj, vk)
  end

  self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
    Id = "idButtonContainer",
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
      self.idEdit:EditOperation("ChoGGi.CurObj",true)
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

  self:SetInitPos(context.parent)
end

local IsKeyPressed = terminal.IsKeyPressed
local shift_key = const.vkShift
local ctrl_key = Platform.osx and const.vkLwin or const.vkControl
function ChoGGi_ExecCodeDlg:idEditOnKbdKeyDown(obj,vk)
  local const = const
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
