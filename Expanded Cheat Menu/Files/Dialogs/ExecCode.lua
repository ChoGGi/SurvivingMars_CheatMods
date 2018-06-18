-- See LICENSE for terms

-- shows a dialog with a single line edit to execute code in

local Concat = ChoGGi.ComFuncs.Concat
local T = ChoGGi.ComFuncs.Trans

local ShowConsoleLog = ShowConsoleLog
local point = point

local g_Classes = g_Classes


-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_ExecCodeDlg = {
  __parents = {"FrameWindow"},
  ZOrder = zorder,
  --defaults
  code = false,
  obj = false,
}

function ChoGGi_ExecCodeDlg:Init()

  local ChoGGi = ChoGGi
  local dlgConsole = dlgConsole

  --element pos is based on
  self:SetPos(point(0,0))

  local dialog_width = 600
  local dialog_height = 90
  self:SetSize(point(dialog_width, dialog_height))
  self:SetMinSize(point(50, 50))
  self:SetMovable(true)
  self:SetTranslate(false)

  local border = 4
  local element_y
  local element_x
  dialog_width = dialog_width - border * 2
  local dialog_left = border

  ChoGGi.ComFuncs.DialogAddCloseX(
    self,
    function()
      self:delete(self.idEditValue:GetText())
    end
  )
  ChoGGi.ComFuncs.DialogAddCaption(self,{
    prefix = Concat(T(302535920000040--[[Exec Code on--]]),": "),
    pos = point(25, border),
    size = point(dialog_width-self.idCloseX:GetSize():x(), 22)
  })

  element_y = border / 2 + self.idCaption:GetPos():y() + self.idCaption:GetSize():y()

  self.idEditValue = g_Classes.SingleLineEdit:new(self)
  self.idEditValue:SetPos(point(dialog_left, element_y))
  self.idEditValue:SetSize(point(dialog_width, 24))
  self.idEditValue:SetHSizing("Resize")
  self.idEditValue:SetVSizing("Resize")
  self.idEditValue:SetTextHAlign("center")
  self.idEditValue:SetTextVAlign("center")
  self.idEditValue:SetFontStyle("Editor14Bold")
  self.idEditValue:SetText("ChoGGi.CurObj") --start off with this as code (maybe just update s instead?)
  self.idEditValue:SetHint(T(302535920000072--[[Paste or type code to be executed here.--]]))
  self.idEditValue:SetMaxLen(-1)
  --focus on textbox and move cursor to end of text
  self.idEditValue:SetFocus()
  self.idEditValue:SetCursorPos(#self.idEditValue:GetText())

  element_y = 5 + self.idEditValue:GetPos():y() + self.idEditValue:GetSize():y()

  local title = T(302535920000051--[[Exec--]])
  self.idOK = g_Classes.Button:new(self)
  self.idOK:SetPos(point(dialog_left+5, element_y))
  self.idOK:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idOK:SetHSizing("AnchorToLeft")
  self.idOK:SetVSizing("AnchorToBottom")
  self.idOK:SetFontStyle("Editor14Bold")
  self.idOK:SetText(title)
  self.idOK:SetHint(T(302535920000073--[[Exec and close dialog (Enter can also be used).--]]))
  --just exec instead of also closing dialog
  function self.idOK.OnButtonPressed()
    ChoGGi.CurObj = self.obj
    --use console to exec code so we can show results in it
    ShowConsoleLog(true)
    dlgConsole:Exec(self.idEditValue:GetText())
  end

  element_x = border * 2 + self.idOK:GetPos():x() + self.idOK:GetSize():x()

  title = T(1000430--[[Cancel--]])
  self.idClose = g_Classes.Button:new(self)
  self.idClose:SetPos(point(element_x, element_y))
  self.idClose:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idClose:SetHSizing("AnchorToLeft")
  self.idClose:SetVSizing("AnchorToBottom")
  self.idClose:SetFontStyle("Editor14Bold")
  self.idClose:SetText(title)
  self.idClose:SetHint(T(302535920000074--[[Cancel without changing anything.--]]))
  self.idClose.OnButtonPressed = self.idCloseX.OnButtonPressed

  element_x = border * 2 + self.idClose:GetPos():x() + self.idClose:GetSize():x()

  title = T(302535920000075--[[Insert Obj--]])
  self.idInsertObj = g_Classes.Button:new(self)
  self.idInsertObj:SetPos(point(element_x, element_y))
  self.idInsertObj:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
  self.idInsertObj:SetHSizing("AnchorToLeft")
  self.idInsertObj:SetVSizing("AnchorToBottom")
  self.idInsertObj:SetFontStyle("Editor14Bold")
  self.idInsertObj:SetText(title)
  self.idInsertObj:SetHint(Concat(T(302535920000076--[[At caret position inserts--]]),": ","ChoGGi.CurObj"))

  --insert text at caret
  function self.idInsertObj.OnButtonPressed()
    local pos = self.idEditValue:GetCursorPos()
    local text = self.idEditValue:GetText()
    self.idEditValue:SetText(Concat(text:sub(1,pos),"ChoGGi.CurObj",text:sub(pos+1)))
    self.idEditValue:SetCursorPos(pos+13)
  end

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()
end

--esc removes focus,shift+esc closes, enter executes code
function ChoGGi_ExecCodeDlg:OnKbdKeyDown(_, virtual_key)
  local const = const
  if virtual_key == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  elseif virtual_key == const.vkEnter then
    self.idOK:Press()
    return "break"
  end
  return "continue"
end
