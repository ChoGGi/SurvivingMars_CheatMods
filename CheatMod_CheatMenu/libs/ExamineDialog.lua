function OnMsg.ClassesGenerate(classdefs)

DefineClass.RCDesireTransportBuilding = {
__parents = {
    "BaseRoverBuilding"
  },
  rover_class = "RCDesireTransport"
}
--[[
--dumpo(classdefs)
dumpt(classdefs)
dumpl(classdefs)
--]]

--CommonLua\UI\uiExamine.lua
--CommonLua\UI\uiExamine.designer.lua
  --add dump button to Examine windows
  function ExamineDesigner:Init()
    self:SetPos(point(278, 191))
    self:SetTranslate(false)
    self:SetMinSize(point(309, 53))
    self:SetMovable(true)
    self:SetSize(point(372, 459))
    self:SetZOrder(10000)
    local win
    win = StaticText:new(self)
    win:SetId("idText")
    win:SetPos(point(283, 306))
    win:SetSize(point(362, 332))
    win:SetHSizing("Resize")
    win:SetVSizing("Resize")
    win:SetBackgroundColor(RGBA(0, 0, 0, 16))
    win:SetFontStyle("Editor12Bold")
    win:SetScrollBar(true)
    win = StaticText:new(self)
    win:SetId("idMenu")
    win:SetPos(point(283, 217))
    win:SetSize(point(362, 52))
    win:SetHSizing("Resize")
    win:SetBackgroundColor(RGBA(0, 0, 0, 16))
    win:SetFontStyle("Editor12Bold")
    win = SingleLineEdit:new(self)
    win:SetId("idFilter")
    win:SetPos(point(283, 275))
    win:SetSize(point(306, 26))
    win:SetHSizing("Resize")
    win:SetBackgroundColor(RGBA(0, 0, 0, 16))
    win:SetFontStyle("Editor12Bold")
    win = Button:new(self)
    win:SetId("idClose")
    win:SetPos(point(597, 191))
    win:SetSize(point(50, 24))
    win:SetHSizing("AnchorToRight")
    win:SetText(Untranslated("Close"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
    win = Button:new(self)
    win:SetId("idNext")
    win:SetPos(point(592, 275))
    win:SetSize(point(53, 26))
    win:SetText(Untranslated("Next"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))

    win = Button:new(self)
    win:SetId("idDump")
    win:SetPos(point(300, 275))
    win:SetSize(point(53, 26))
    win:SetText(Untranslated("Dump"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))

    self:InitChildrenSizing()
  end

  function Examine:Init()
    self.Dump = function(...)
      ChoGGi.Dump(...,nil,nil,"html")
    end
    self.onclick_handles = {}
    self.obj = false
    self.show_times = "relative"
    self.offset = 1
    self.page = 1
    self.transp_mode = transp_mode
    function self.idText.OnHyperLink(_, link, _, box, pos, button)
      self.onclick_handles[tonumber(link)](box, pos, button)
    end
    self.idText:AddInterpolation({
      type = const.intAlpha,
      startValue = 255,
      flags = const.intfIgnoreParent
    })
    function self.idMenu.OnHyperLink(_, link, _, box, pos, button)
      self.onclick_handles[tonumber(link)](box, pos, button)
    end
    self.idMenu:AddInterpolation({
      type = const.intAlpha,
      startValue = 255,
      flags = const.intfIgnoreParent
    })
    function self.idNext.OnButtonPressed()
      self:FindNext(self.idFilter:GetText())
    end
    function self.idDump.OnButtonPressed()
      self.Dump(self:totextex(self.obj) .. "\n")
    end
    self.idFilter:AddInterpolation({
      type = const.intAlpha,
      startValue = 255,
      flags = const.intfIgnoreParent
    })
    function self.idFilter.OnValueChanged(this, value)
      self:FindNext(value)
    end
    function self.idFilter.OnKbdKeyDown(_, char, virtual_key)
      if virtual_key == const.vkEnter then
        self:FindNext(self.idFilter:GetText())
        return "break"
      end
      StaticText.OnKbdKeyDown(self, char, virtual_key)
    end
    function self.idClose.OnButtonPressed()
      self:delete()
    end
    self:SetTranspMode(self.transp_mode)
  end

end

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"ExamineDialog")
end
