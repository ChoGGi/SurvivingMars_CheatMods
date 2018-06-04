--See LICENSE for terms

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
    local OpenExamine = OpenExamine

    self.refreshing = false
    --make sure we're always above examiner dialogs
    self:SetZOrder(3000000)
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
              --check for missing table objects
              if self.object.title:find("Grids") then
                self.tables = ChoGGi.ComFuncs.RemoveMissingTableObjects(self.tables,"elements")
                --break if there's none left
                if #self.tables == 0 then
                  --fire once more to show the nothing here text
                  self:UpdateText()
                  break
                end
              end
            end
          end)
        end
      end
    end

    self.idText.OnRButtonDoubleClick = function()
      ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(self.tables)
    end

    function self.idRefresh.OnButtonPressed()
      if ChoGGi.Temp.Testing then
        OpenExamine(self.object)
      end
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
      if #self.tables > 0 then
        for i = 1, #self.tables do
          monitort = self.tables[i]
          texttable[#texttable+1] = "----- "
          texttable[#texttable+1] = i
          texttable[#texttable+1] = ". "
          texttable[#texttable+1] = monitort.class
          texttable[#texttable+1] = ":\n"
          if self.object.listtype == "all" then
            print("all")
            ex(self.tables[i])
            ex(self.values)
            for SecName,SecValue in pairs(self.tables[i]) do
            --goes through all tables

              --goes through each table
              texttable[#texttable+1] = SecName
              texttable[#texttable+1] = "\n"
              for Key,Value in pairs(SecValue) do

                if self.values[Key] then
                  for j = 1, #self.values do
                    local v = self.values[i]
                    --name = monitort[SecName.name]
                    texttable[#texttable+1] = "\t"
                    texttable[#texttable+1] = v.name
                    self:BuildValue(Value,0)
                  end
                elseif Key == "field" then
                  texttable[#texttable+1] = "\t"
                  texttable[#texttable+1] = Value
                  texttable[#texttable+1] = ": "
                end

              end

            end
          else
            for Key,Value in pairs(self.values) do
              name = monitort[Value.name]
              if name or type(name) == "boolean" then
                texttable[#texttable+1] = Value.name
                self:BuildValue(name,Value.kind)
              end
            end
          end --for
        end --if
      else
        texttable[#texttable+1] = "Nothing left"
      end --if #self.tables > 0

      texttable[#texttable+1] = "\n"
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

    function self:BuildValue(name,kind)
      --0 = value
      if kind == 0 then
        texttable[#texttable+1] = ": "
        texttable[#texttable+1] = tostring(name)
        texttable[#texttable+1] = "\n"
      --1=table
      elseif kind == 1 then
        texttable[#texttable+1] = ": "
        texttable[#texttable+1] = #name
        texttable[#texttable+1] = "\n"
      --2=list table values
      elseif kind == 2 then
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
      --just the three for now
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
          SingleLine = true,
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
