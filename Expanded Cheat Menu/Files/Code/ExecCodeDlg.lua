--See LICENSE for terms

function ChoGGi.MsgFuncs.ExecCodeDlg_ClassesGenerate()

  DefineClass.ChoGGi_ExecCodeDlg = {
    __parents = {
      "FrameWindow"
    }

  }

  function ChoGGi_ExecCodeDlg:Init()
    DataInstances.UIDesignerData.ChoGGi_ExecCodeDlg:InitDialogFromView(self, "Default")

    local ChoGGi = ChoGGi
    local ShowConsoleLog = ShowConsoleLog
    local dlgConsole = dlgConsole
    local terminal = terminal
    local const = const

    --make sure we're always above examiner dialogs
    self:SetZOrder(20000)
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

    --esc removes focus,shift+esc closes, enter executes code
    function self:OnKbdKeyDown(_, virtual_key)
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

  end --init

end --ClassesGenerate

function ChoGGi.MsgFuncs.ExecCodeDlg_ClassesBuilt()

  --dialog layout
  --[[
  DesignResolution
  MinSize
  SizeOrg
  --]]
  local hint_connectedgrid = "Check this for \"All of type\" to only apply to connected grid."
  UIDesignerData:new({
    DesignOrigin = point(100, 100),
    DesignResolution = point(300, 450),
    HGE = true,
    file_name = "ChoGGi_ExecCodeDlg",
    name = "ChoGGi_ExecCodeDlg",
    parent_control = {
      CaptionHeight = 32,
      Class = "FrameWindow",
      GamepadStrip = false,
      Image = "CommonAssets/UI/Controls/WindowFrame.tga",
      Movable = true,
      PatternBottomRight = point(123, 122),
      PatternTopLeft = point(4, 24),
      PosOrg = point(100, 100),
      SizeOrg = point(600, 90),
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
          PosOrg = point(679, 103),
          SizeOrg = point(18, 18),
        },
        {
          Id = "idEditValue",
          Class = "SingleLineEdit",
          --AutoSelectAll = true,
          FontStyle = "Editor14Bold",
          Subview = "default",
          MaxLen = -1,
          PosOrg = point(110, 125),
          SizeOrg = point(585, 24),
          TextVAlign = "center",
          Text = "ChoGGi.CurObj", --start off with this as code
          Hint = "Paste or type code to be executed here.",
          HSizing = "Resize",
          VSizing = "Resize",
        },
        {
          Id = "idOK",
          Class = "Button",
          FontStyle = "Editor14Bold",
          Subview = "default",
          Text = "Exec",
          Hint = "Exec and close dialog (Enter can also be used).",
          PosOrg = point(110, 155),
          TextPrefix = "<center>",
          SizeOrg = point(45, 25),
          HSizing = "AnchorToLeft",
          VSizing = "AnchorToBottom",
        },
        {
          Id = "idClose",
          Class = "Button",
          CloseDialog = true,
          FontStyle = "Editor14Bold",
          Hint = "Cancel without changing anything.",
          Subview = "default",
          Text = T({1000430, "Cancel"}),
          PosOrg = point(190, 155),
          TextPrefix = "<center>",
          SizeOrg = point(65, 25),
          HSizing = "AnchorToLeft",
          VSizing = "AnchorToBottom",
        },
        {
          Id = "idInsertObj",
          Class = "Button",
          CloseDialog = true,
          FontStyle = "Editor14Bold",
          Hint = "At caret position inserts: ChoGGi.CurObj",
          TextPrefix = "<center>",
          Subview = "default",
          Text = "Insert Obj",
          PosOrg = point(300, 155),
          SizeOrg = point(90, 25),
          HSizing = "AnchorToLeft",
          VSizing = "AnchorToBottom",
        },
      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt
