--See LICENSE for terms

local oldTableConcat = oldTableConcat

-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_ExecCodeDlg_Defaults = {
  __parents = {"FrameWindow"}
}

function ChoGGi_ExecCodeDlg_Defaults:Init()
  local ChoGGi = ChoGGi

  self:SetPos(point(100, 100))
  self:SetSize(point(600, 90))
  self:SetMinSize(point(50, 50))
  self:SetTranslate(false)
  self:SetMovable(true)
  self:SetZOrder(zorder)
  local ShowConsoleLog = ShowConsoleLog
  local dlgConsole = dlgConsole
  local terminal = terminal
  local const = const

  --defaults
  self.code = false
  self.obj = false

  ChoGGi.ComFuncs.DialogAddCaption(self,{pos = point(50, 101),size = point(390, 22)})
  ChoGGi.ComFuncs.DialogAddCloseX(self,function() self:delete(self.idEditValue:GetText()) end)

  self.idEditValue = SingleLineEdit:new(self)
  self.idEditValue:SetPos(point(110, 125))
  self.idEditValue:SetSize(point(585, 24))
  self.idEditValue:SetHSizing("Resize")
  self.idEditValue:SetVSizing("Resize")
  self.idEditValue:SetTextHAlign("center")
  self.idEditValue:SetTextVAlign("center")
  self.idEditValue:SetFontStyle("Editor14Bold")
  self.idEditValue:SetText("ChoGGi.CurObj") --start off with this as code (maybe just update s instead?)
  self.idEditValue:SetHint(ChoGGi.ComFuncs.Trans(302535920000072,"Paste or type code to be executed here."))
  self.idEditValue:SetMaxLen(-1)
  --focus on textbox and move cursor to end of text
  self.idEditValue:SetFocus()
  self.idEditValue:SetCursorPos(#self.idEditValue:GetText())

  self.idOK = Button:new(self)
  self.idOK:SetPos(point(110, 155))
  self.idOK:SetSize(point(45, 25))
  self.idOK:SetHSizing("AnchorToLeft")
  self.idOK:SetVSizing("AnchorToBottom")
  self.idOK:SetFontStyle("Editor14Bold")
  self.idOK:SetText(ChoGGi.ComFuncs.Trans(302535920000051,"Exec"))
  self.idOK:SetHint(ChoGGi.ComFuncs.Trans(302535920000073,"Exec and close dialog (Enter can also be used)."))
  --just exec instead of also closing dialog
  function self.idOK.OnButtonPressed()
    ChoGGi.CurObj = self.obj
    --use console to exec code so we can show results in it
    ShowConsoleLog(true)
    dlgConsole:Exec(self.idEditValue:GetText())
  end

  self.idClose = Button:new(self)
  self.idClose:SetPos(point(190, 155))
  self.idClose:SetSize(point(65, 25))
  self.idClose:SetHSizing("AnchorToLeft")
  self.idClose:SetVSizing("AnchorToBottom")
  self.idClose:SetFontStyle("Editor14Bold")
  self.idClose:SetText(T({1000430, "Cancel"}))
  self.idClose:SetHint(ChoGGi.ComFuncs.Trans(302535920000074,"Cancel without changing anything."))
  self.idClose.OnButtonPressed = self.idCloseX.OnButtonPressed

  self.idInsertObj = Button:new(self)
  self.idInsertObj:SetPos(point(300, 155))
  self.idInsertObj:SetSize(point(90, 25))
  self.idInsertObj:SetHSizing("AnchorToLeft")
  self.idInsertObj:SetVSizing("AnchorToBottom")
  self.idInsertObj:SetFontStyle("Editor14Bold")
  self.idInsertObj:SetText(ChoGGi.ComFuncs.Trans(302535920000075,"Insert Obj"))
  self.idInsertObj:SetHint(oldTableConcat({ChoGGi.ComFuncs.Trans(302535920000076,"At caret position inserts"),": ","ChoGGi.CurObj"}))

  --insert text at caret
  function self.idInsertObj.OnButtonPressed()
    local pos = self.idEditValue:GetCursorPos()
    local text = self.idEditValue:GetText()
    self.idEditValue:SetText(oldTableConcat({text:sub(1,pos),"ChoGGi.CurObj",text:sub(pos+1)}))
    self.idEditValue:SetCursorPos(pos+13)
  end

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()

  self:SetPos(point(100, 100))
  self:SetSize(point(600, 90))
end

DefineClass.ChoGGi_ExecCodeDlg = {
  __parents = {
    "ChoGGi_ExecCodeDlg_Defaults",
  },
  ZOrder = zorder
}

--esc removes focus,shift+esc closes, enter executes code
function ChoGGi_ExecCodeDlg:OnKbdKeyDown(_, virtual_key)
  if virtual_key == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  elseif virtual_key == const.vkEnter then
    self.idOK:Press()
    return "break"
  end
  return "continue"
end
