function ChoGGi.MsgFuncs.MonitorInfoDlg_ClassesGenerate()

  DefineClass.ChoGGi_MonitorInfoDlg = {
    __parents = {
      "FrameWindow"
    }
  }

  function ChoGGi_MonitorInfoDlg:Init()
    DataInstances.UIDesignerData.ChoGGi_MonitorInfoDlg:InitDialogFromView(self, "Default")

    local ChoGGi = ChoGGi
    local Sleep = Sleep
    local CreateRealTimeThread = CreateRealTimeThread
    local terminal = terminal
    local const = const

    self.refreshing = false
    --make sure we're always above examiner dialogs
    self:SetZOrder(20000)
    --defaults
    self.object = false
    self.values = false
    self.tables = false
    self.delay = 1000

    --add check for auto-refresh
    local children = self.idAutoRefresh.children
    for i = 1, #children do
      if children[i].class == "Button" then
        local but = children[i]
        function but.OnButtonPressed()
          self.refreshing = self.idAutoRefresh:GetState()
          CreateRealTimeThread(function()
            while self.refreshing do
              self:UpdateText()
              Sleep(self.delay)
            end
          end)
        end
      end
    end

    self.idText.OnRButtonDoubleClick = function()
      ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(self.tables)
    end

    function self.idRefresh.OnButtonPressed()
    ex(self.object)
      self:UpdateText()
    end

    function self.idTimerAmount.OnValueChanged()
      local delay = ChoGGi.ComFuncs.RetProperType(self.idTimerAmount:GetText())
      if type(delay) == "number" and delay > 0 then
        self.delay = delay
      end
    end

    local texttable
    local text
    local monitort
    local name
    local kind
    function self:UpdateText()
      --check for scroll pos
      local scrollpos = self.idText.scroll:GetPosition()
      --create prop list for list
      texttable = {[1]=""}
      for i = 1, #self.tables do
        monitort = self.tables[i]
        texttable[#texttable+1] = "----- "
        texttable[#texttable+1] = monitort.class
        texttable[#texttable+1] = " "
        texttable[#texttable+1] = i
        texttable[#texttable+1] = ":\n"
        for Key,Value in pairs(self.values) do
          name = monitort[Value.name]
          if name or type(name) == "boolean" then
            texttable[#texttable+1] = Value.name
            if Value.kind == 0 then
              --0 = value
              texttable[#texttable+1] = ": "
              texttable[#texttable+1] = tostring(name)
              texttable[#texttable+1] = "\n"
            elseif Value.kind == 1 then
              --1=table
              texttable[#texttable+1] = ": "
              texttable[#texttable+1] = #name
              texttable[#texttable+1] = "\n"
            elseif Value.kind == 2 then
            --2=list table values
              texttable[#texttable+1] = ":\n"
              for t_name,t_value in pairs(name) do
                texttable[#texttable+1] = "\t"
                texttable[#texttable+1] = t_name
                texttable[#texttable+1] = ": "
                texttable[#texttable+1] = tostring(t_value)
                texttable[#texttable+1] = "\n"
              end
              texttable[#texttable+1] = "\n"
            end
          end
        end
        texttable[#texttable+1] = "\n"
      end
      --less .. is better
      text = table.concat(texttable)

      if text == "" then
        local err = "Error opening" .. tostring(self.object)
        self.idText:SetText(err)
        return
      end
      --populate it
      self.idText:SetText(text)
      --and scroll to saved pos
      self.idText.scroll:SetPosition(scrollpos)
    end

    --esc removes focus,shift+esc closes, enter executes code
    function self:OnKbdKeyDown(_, virtual_key)
      if virtual_key == const.vkEsc then
        if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
          self.idClose:Press()
        end
        self:SetFocus()
        return "break"
      end
      return "continue"
    end

  end --init

end --ClassesGenerate

function ChoGGi.MsgFuncs.MonitorInfoDlg_ClassesBuilt()

  UIDesignerData:new({
    DesignOrigin = point(100, 100),
    DesignResolution = point(300, 450),
    HGE = true,
    file_name = "ChoGGi_MonitorInfoDlg",
    name = "ChoGGi_MonitorInfoDlg",
    parent_control = {
      CaptionHeight = 32,
      Class = "FrameWindow",
      GamepadStrip = false,
      Image = "CommonAssets/UI/Controls/WindowFrame.tga",
      Movable = true,
      PatternBottomRight = point(123, 122),
      PatternTopLeft = point(4, 24),
      PosOrg = point(100, 100),
      SizeOrg = point(400, 600),
      MinSize = point(24, 24),
      HorizontalResize = true,
      VerticalResize = true
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
          PosOrg = point(50, 101),
          SizeOrg = point(390, 22),
          HSizing = "AnchorToLeft",
          VSizing = "Resize",
        },
        {
          Id = "idCloseX",
          Class = "Button",
          CloseDialog = true,
          --FontStyle = "Editor14Bold",
          Image = "CommonAssets/UI/Controls/Button/Close.tga",
          Hint = "Closes dialog.",
          HSizing = "AnchorToRight",
          Subview = "default",
          PosOrg = point(478, 103),
          SizeOrg = point(18, 18),
        },
        {
          Id = "idAutoRefresh",
          Class = "CheckButton",
          TextHAlign = "center",
          TextVAlign = "center",
          ButtonSize = point(16, 16),
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          Text = "Auto-Refresh",
          Hint = "Auto-refresh list every \"Amount\".",
          Subview = "default",
          PosOrg = point(115, 128),
          SizeOrg = point(100, 17),
        },
        {
          Id = "idRefresh",
          Class = "Button",
          TextHAlign = "center",
          TextVAlign = "center",
          Text = "Refresh",
          Hint = "Refresh the list.",
          Subview = "default",
          TextPrefix = "<center>",
          PosOrg = point(225, 128),
          SizeOrg = point(55, 17),
        },
        {
          Id = "idTimerAmount",
          Class = "SingleLineEdit",
          FontStyle = "Editor14Bold",
          Subview = "default",
          MaxLen = -1,
          PosOrg = point(290, 126),
          SizeOrg = point(200, 24),
          TextVAlign = "center",
          Text = "1000",
          Hint = "Refresh delay in ms",
          HSizing = "Resize",
          VSizing = "AnchorToTop",
        },
        {
          Id = "idText",
          Class = "StaticText",
          FontStyle = "Editor12Bold",
          Subview = "default",
          MaxLen = -1,
          PosOrg = point(110, 152),
          SizeOrg = point(385, 537),
          ScrollBar = true,
          ScrollAutohide = true,
          HSizing = "Resize",
          VSizing = "Resize",
          Hint = "Double right-click to open list of objects.",
          BackgroundColor = RGBA(0, 0, 0, 16),
        },
      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt