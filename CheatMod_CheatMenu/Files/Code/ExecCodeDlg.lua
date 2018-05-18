local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs

function ChoGGi.MsgFuncs.ExecCodeDlg_ClassesGenerate()
  DefineClass.ChoGGi_ExecCodeDlg = {
    __parents = {
      "FrameWindow"
    }
  }

  function ChoGGi_ExecCodeDlg:Init()
    DataInstances.UIDesignerData.ChoGGi_ExecCodeDlg:InitDialogFromView(self, "ChoGGi_ExecCodeDlg")
    self.choosed = false
    self.finished = false
    self.obj = false

    function self.idOk.OnButtonPressed()
      self.finished = true
      self.choosed = self.idTextEdit:GetText()
      self:delete()
    end
    function self.idCancel.OnButtonPressed()
      self.finished = true
      self:delete()
    end
    function self.idTextEdit.edit.OnKbdKeyDown(this, char, virtual_key)
      if virtual_key == const.vkEsc then
        if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
          self.idCancel:Press()
          return "break"
        end
        self:SetFocus()
        return "break"

      elseif virtual_key == const.vkEnter then
        self.finished = true
        self.choosed = self.idTextEdit:GetText()
        self:delete()
        return "break"
      end

      --return SingleLineEdit.OnKbdKeyDown(this, char, virtual_key)
      return ChoGGi_uiMultiLineEdit.OnKbdKeyDown(this, char, virtual_key)
    end
  end

end

function ChoGGi.MsgFuncs.ExecCodeDlg_ClassesBuilt()

UIDesignerData:new({
  DesignOrigin = point(100, 100),
  DesignResolution = point(300, 450),
  HGE = true,
  file_name = "ChoGGi_ExecCodeDlg",
  name = "ChoGGi_ExecCodeDlg",
  parent_control = {
    CaptionHeight = 32,
    --Class = "FrameWindow",
    Image = "CommonAssets/UI/Controls/WindowFrame.tga",
    Movable = true,
    PatternBottomRight = point(123, 122),
    PatternTopLeft = point(4, 24),
    PosOrg = point(100, 100),
    SizeOrg = point(400, 450),
    HorizontalResize = true,
    VerticalResize = true,

    Class = "Dialog",
    --Pos = point(320, 120),
    --Size = point(274, 137)
  },
  subviews = {
    {
      name = "default",

      {
        Id = "idCaption",
        Class = "StaticText",
        TextPrefix = "<center>",
        BackgroundColor = 0,
        FontStyle = "Editor14Bold",
        HandleMouse = false,
        Subview = "default",
        PosOrg = point(105, 101),
        SizeOrg = point(390, 22),
        HSizing = "Resize",
        VSizing = "Resize"
      },
      {
        Class = "Button",
        Id = "idOk",
        Pos = point(345, 218),
        Size = point(92, 24),
        Subview = "default",
        Text = T({1000426, "OK"}),
        TextColorDisabled = -8421505
      },
      {
        Class = "Button",
        Id = "idCancel",
        Pos = point(472, 218),
        Size = point(92, 24),
        Subview = "default",
        Text = T({1000427, "Cancel"}),
        TextColorDisabled = -8421505
      },
      {
        BackgroundColor = 0,
        CenterRectangle = box(1, 1, 30, 30),
        Class = "ChoGGi_uiMultiLineEdit",
        Id = "idTextEdit",
        --Image = "CommonAssets/UI/Controls/EditFrame.tga",
        Pos = point(330, 152),
        Size = point(254, 44),
        Subview = "default"
      }
    }
  },

  views = PlaceObj("UIDesignerViews", nil, {
    PlaceObj("UIDesignerView", {"name", "Default"})
  })

  --[[
  views = PlaceObj("UIDesignerViews", nil, {
    PlaceObj("UIDesignerView", {
      "name",
      "ChoGGi_ExecCodeDlg",
      "visible_subviews",
      set("ChoGGi_ExecCodeDlg"),
      "active_subview",
      "default"
    })
  })
  --]]

})
end
