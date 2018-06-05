-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_ExecCodeDlg_Designer = {
  __parents = {
    "FrameWindow"
  }
}
function ChoGGi_ExecCodeDlg_Designer:Init()
  local ChoGGi = ChoGGi

  self:SetPos(point(100, 100))
  self:SetSize(point(600, 90))
  self:SetMinSize(point(50, 50))
  self:SetTranslate(false)
  self:SetMovable(true)
  self:SetZOrder(zorder)

  ChoGGi.ComFuncs.DialogAddCaption({self = self,pos = point(50, 101),size = point(390, 22)})
  ChoGGi.ComFuncs.DialogAddCloseX(self,point(679, 103))

  local obj

  obj = SingleLineEdit:new(self)
  obj:SetId("idEditValue")
  obj:SetPos(point(110, 125))
  obj:SetSize(point(585, 24))
  obj:SetHSizing("Resize")
  obj:SetVSizing("Resize")
  obj:SetTextHAlign("center")
  obj:SetTextVAlign("center")
  obj:SetFontStyle("Editor14Bold")
  obj:SetText("ChoGGi.CurObj") --start off with this as code (maybe just update s instead?)
  obj:SetHint("Paste or type code to be executed here.")
  obj:SetMaxLen(-1)

  obj = Button:new(self)
  obj:SetId("idOK")
  obj:SetPos(point(110, 155))
  obj:SetSize(point(45, 25))
  obj:SetHSizing("AnchorToLeft")
  obj:SetVSizing("AnchorToBottom")
  obj:SetFontStyle("Editor14Bold")
  obj:SetText("Exec")
  obj:SetHint("Exec and close dialog (Enter can also be used).")

  obj = Button:new(self)
  obj:SetId("idClose")
  obj:SetPos(point(190, 155))
  obj:SetSize(point(65, 25))
  obj:SetHSizing("AnchorToLeft")
  obj:SetVSizing("AnchorToBottom")
  obj:SetFontStyle("Editor14Bold")
  obj:SetText(T({1000430, "Cancel"}))
  obj:SetHint("Cancel without changing anything.")

  obj = Button:new(self)
  obj:SetId("idInsertObj")
  obj:SetPos(point(300, 155))
  obj:SetSize(point(90, 25))
  obj:SetHSizing("AnchorToLeft")
  obj:SetVSizing("AnchorToBottom")
  obj:SetFontStyle("Editor14Bold")
  obj:SetText("Insert Obj")
  obj:SetHint("At caret position inserts: ChoGGi.CurObj")

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()

  self:SetPos(point(100, 100))
  self:SetSize(point(600, 90))
end

DefineClass.ChoGGi_ExecCodeDlg = {
  __parents = {
    "ChoGGi_ExecCodeDlg_Designer",
  },
  ZOrder = zorder
}

function ChoGGi_ExecCodeDlg:Init()

  local ChoGGi = ChoGGi
  local ShowConsoleLog = ShowConsoleLog
  local dlgConsole = dlgConsole
  local terminal = terminal
  local const = const

  --defaults
  self.code = false
  self.obj = false

  --focus and textbox and move cursor to end of text
  self.idEditValue:SetFocus()
  self.idEditValue:SetCursorPos(#self.idEditValue:GetText())

  --just exec
  function self.idOK.OnButtonPressed()
    ChoGGi.CurObj = self.obj
    --use console to exec code so we can show results in it
    ShowConsoleLog(true)
    dlgConsole:Exec(self.idEditValue:GetText())
  end

  --return text and close
  local function Close()
    --send back code (could be useful)
    self:delete(self.idEditValue:GetText())
  end
  self.idClose.OnButtonPressed = Close
  self.idCloseX.OnButtonPressed = Close

  --insert text at caret
  function self.idInsertObj.OnButtonPressed()
    local pos = self.idEditValue:GetCursorPos()
    local text = self.idEditValue:GetText()
    self.idEditValue:SetText(text:sub(1,pos) .. "ChoGGi.CurObj" .. text:sub(pos+1))
    --
    self.idEditValue:SetCursorPos(pos+13)
  end

  --make checkbox work like a button
  --[[
  local children = self.idCheckBox2.children
  for i = 1, #children do
    if children[i].class == "Button" then
      local but = children[i]
      function but.OnButtonPressed()
        dosomething()
      end
    end
  end
  --]]

end --init

--esc removes focus,shift+esc closes, enter executes code
function ChoGGi_ExecCodeDlg:OnKbdKeyDown(_, virtual_key)
  if virtual_key == const.vkEsc then
    if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
      self.idClose:Press()
    end
    self:SetFocus()
    return "break"
  elseif virtual_key == const.vkEnter then
    self.idOK:Press()
    return "break"
  end
  return "continue"
end
