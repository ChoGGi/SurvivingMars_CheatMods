--Haemimont Games code (mostly)
--why would they remove such a useful modding tool from a game that relies on mods this much?

DefineClass.ExamineDesigner = {
  __parents = {
    "FrameWindow"
  }
}
function ExamineDesigner:Init()

  self:SetPos(point(278, 191))
  self:SetTranslate(false)
  self:SetMinSize(point(309, 53))
  self:SetMovable(true)
  self:SetSize(point(372, 459))
  -- 1 above console log
  self:SetZOrder(2000001)
  local obj

  obj = StaticText:new(self)
  obj:SetId("idCaption")
  obj:SetPos(point(325, 195))
  obj:SetSize(point(300, 22))
  obj:SetHSizing("Resize")
  obj:SetVSizing("Resize")
  obj:SetBackgroundColor(0)
  obj:SetFontStyle("Editor14Bold")
  obj:SetTextPrefix("Object Examiner: ")
  obj.SingleLine = true
  obj.HandleMouse = false

  obj = StaticText:new(self)
  obj:SetId("idText")
  --obj:SetPos(point(283, 306))
  --obj:SetSize(point(362, 332))
  obj:SetPos(point(283, 332))
  obj:SetSize(point(362, 310))
  obj:SetHSizing("Resize")
  obj:SetVSizing("Resize")
  --obj:SetBackgroundColor(RGBA(0, 0, 0, 16))
  obj:SetBackgroundColor(RGBA(0, 0, 0, 50))
  obj:SetFontStyle("Editor12Bold")
  obj:SetScrollBar(true)
  --
  obj:SetScrollAutohide(true)

  obj = StaticText:new(self)
  obj:SetId("idMenu")
  obj:SetPos(point(283, 217))
  obj:SetSize(point(362, 52))
  obj:SetHSizing("Resize")
  obj:SetBackgroundColor(RGBA(0, 0, 0, 16))
  obj:SetFontStyle("Editor12Bold")

  --todo: better text control (weird ass text controls)
  obj = SingleLineEdit:new(self)
  obj:SetId("idFilter")
  --obj:SetPos(point(283, 275))
  --obj:SetSize(point(306, 26))
  obj:SetPos(point(288, 275))
  obj:SetSize(point(350, 26))
  obj:SetHSizing("Resize")
  obj:SetBackgroundColor(RGBA(0, 0, 0, 16))
  obj:SetFontStyle("Editor12Bold")
  --
  obj:SetHint("Scrolls to text entered")
  obj:SetTextHAlign("center")
  obj:SetTextVAlign("center")
  obj:SetBackgroundColor(RGBA(0, 0, 0, 100))
  obj.display_text = "Goto text"

  obj = Button:new(self)
  obj:SetId("idClose")
  --obj:SetPos(point(597, 191))
  --obj:SetSize(point(50, 24))
  obj:SetPos(point(629, 194))
  obj:SetSize(point(18, 18))
  obj:SetHSizing("AnchorToRight")
  --obj:SetText(Untranslated("Close"))
  obj:SetTextColorDisabled(RGBA(127, 127, 127, 255))
  --
  obj:SetImage("CommonAssets/UI/Controls/Button/Close.tga")
  obj:SetHint("Good bye")

  obj = Button:new(self)
  obj:SetId("idNext")
  --obj:SetPos(point(592, 275))
  obj:SetPos(point(715, 304))
  obj:SetSize(point(53, 26))
  obj:SetText(Untranslated("Next"))
  obj:SetTextColorDisabled(RGBA(127, 127, 127, 255))
  --
  obj:SetHint("Scrolls down one or scrolls between text in \"Goto text\".")

  --needs moar buttons
  obj = Button:new(self)
  obj:SetId("idDump")
  obj:SetPos(point(290, 304))
  obj:SetSize(point(75, 26))
  obj:SetText("Dump Text")
  obj:SetHint("Dumps text to AppData/DumpedExamine.lua")

  obj = Button:new(self)
  obj:SetId("idDumpObj")
  obj:SetPos(point(375, 304))
  obj:SetSize(point(75, 26))
  obj:SetText("Dump Obj")
  obj:SetHint("Dumps object to AppData/DumpedExamineObject.lua\n\nThis can take time on something like the \"Building\" metatable")

  obj = Button:new(self)
  obj:SetId("idEdit")
  obj:SetPos(point(460, 304))
  obj:SetSize(point(53, 26))
  obj:SetText("Edit")
  obj:SetHint("Opens object in Object Manipulator.")

  obj = Button:new(self)
  obj:SetId("idCodeExec")
  obj:SetPos(point(520, 304))
  obj:SetSize(point(50, 26))
  obj:SetText("Exec")
  obj:SetHint("Execute code (using console for output). ChoGGi.CurObj is whatever object is opened in examiner.\nWhich you can then mess around with some more in the console.")

  obj = Button:new(self)
  obj:SetId("idAttaches")
  obj:SetPos(point(575, 304))
  obj:SetSize(point(75, 26))
  obj:SetText("Attaches")
  obj:SetHint("Opens attachments in new examine window.")

  self:InitChildrenSizing()
  --have to size children before doing these (or fix something something)
  self:SetPos(point(50,150))
  self:SetSize(point(500,600))
end
