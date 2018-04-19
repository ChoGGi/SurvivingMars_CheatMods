function ChoGGi.UIDesignerData_ClassesGenerate()

  DefineClass.ListChoiceCustomDialog = {
    __parents = {
      "FrameWindow",
      "PauseGameDialog"
    }
  }

  --ChoGGi.ListChoiceCustom_Dialog.idList:SetHint("XXXX")
  function ListChoiceCustomDialog:Init()
    --init stuff?
    DataInstances.UIDesignerData.ListChoiceCustomDialog:InitDialogFromView(self, "Default")

    --set some values...
    self.idCustomValue.display_text = "Add Custom Value"
    self.idCustomValue:SetHint("You can enter a custom value to be applied.\n\nWarning: Entering the wrong value may crash the game or otherwise cause issues.")
    self.idCancel:SetHint("Cancel without changing anything.")
    self.choices = {}
    self.sel = false

    --setup for multi selection
    if ChoGGi.ListChoiceCustom_MultiSel then
      self.idList.multiple_selection = true
    end

    --do stuff on selection
    local origOnLButtonDown = self.idList.OnLButtonDown
    self.idList.OnLButtonDown = function(selfList,...)
      local ret = origOnLButtonDown(selfList,...)
      --update selection (select last selected if multisel)
      self.sel = self.idList:GetSelection()[#self.idList:GetSelection()]
      --if we want to change hints on selection (why doesn't onmouseenter work for list items?)
      if ChoGGi.ListChoiceCustom_Hint then
        --only call when sending hint type
        self.idList:SetHint(self.sel.text .. " " .. self.sel.hint)
      end
      --for whatever is expecting a return value
      return ret
    end

    --update custom value when dbl right
    self.idList.OnRButtonDoubleClick = function()
      self.idCustomValue:SetText(self.sel.text)
    end

    --update custom value list item
    function self.idCustomValue.OnValueChanged()
      self.idList:SetItem(#self.idList.items,{
        text = self.idCustomValue:GetText(),
        value = ChoGGi.RetNumOrString(self.idCustomValue:GetText()),
        hint = "< Use custom value"
      })
      self.idList:SetSelection(self.idList.rows, true)
    end

    function self.idOK.OnButtonPressed(this)
      --check checkboxes
      ChoGGi.ListChoiceCustom_CheckBox1 = self.idCheckBox1:GetToggled()
      ChoGGi.ListChoiceCustom_CheckBox2 = self.idCheckBox2:GetToggled()

      --get sel item(s)
      local items = self.idList:GetSelection()
      for i = 1, #items do
        if i == 1 then
          --if we're just returning the one item then add list item number
          items[i].which = self.idList:GetSelectionIdx()[1]
        end
        table.insert(self.choices,items[i])
      end
      --send selection back
      self:delete(self.choices)
    end

    --dblclick to ret item
    self.idList.OnDoubleClick = self.idOK.OnButtonPressed

  end --init

  function ListChoiceCustomDialog:PostInit()
    --focus on list and set selection to last item
    self.idList:SetFocus()
    self.idList:SetSelection(#self.idList.items, true)
  end

  function ListChoiceCustomDialog:OnKbdKeyDown(char, virtual_key)
    if virtual_key == const.vkEsc then
      self.idCancel:Press()
      return "break"
    elseif virtual_key == const.vkEnter then
      self.idOK:Press()
      return "break"
    elseif virtual_key == const.vkSpace then
      self.idCheckBox1:SetToggled(not self.idCheckBox1:GetToggled())
      return "break"
    end
    return "continue"
  end

end --ClassesGenerate

function ChoGGi.UIDesignerData_ClassesBuilt()
  UIDesignerData:new({
    DesignOrigin = point(100, 100),
    DesignResolution = point(300, 450),
    HGE = true,
    file_name = "ListChoiceCustomDialog",
    name = "ListChoiceCustomDialog",
    parent_control = {
      CaptionHeight = 32,
      Class = "FrameWindow",
      GamepadStrip = false,
      Image = "CommonAssets/UI/Controls/WindowFrame.tga",
      MinSize = point(400, 450),
      Movable = true,
      PatternBottomRight = point(123, 122),
      PatternTopLeft = point(4, 24),
      PosOrg = point(100, 100),
      SizeOrg = point(400, 450),
      HorizontalResize = true,
      VerticalResize = true
    },
    subviews = {
      {
        name = "default",
        {
          --MultipleSelection = true,
          Class = "List",
          FontStyle = "Editor14",
          Id = "idList",
          PosOrg = point(105, 123),
          RolloverFontStyle = "Editor14",
          ScrollBar = true,
          SelectionFontStyle = "Editor14",
          Spacing = point(8, 2),
          Subview = "default",
          SizeOrg = point(390, 322),
          HSizing = "0, 1, 0",
          VSizing = "0, 1, 0"
        },
        {
          BackgroundColor = 0,
          Class = "StaticText",
          FontStyle = "Editor14Bold",
          HandleMouse = false,
          Id = "idCaption",
          Subview = "default",
          TextPrefix = "<center>",
          PosOrg = point(105, 101),
          SizeOrg = point(390, 22),
          HSizing = "0, 1, 0",
          VSizing = "0, 1, 0"
        },
        {
          Class = "Button",
          FontStyle = "Editor14Bold",
          GamepadButton = "ButtonA",
          Id = "idOK",
          Subview = "default",
          Text = T({1000429, "OK"}),
          TextColorDisabled = -8421505,
          PosOrg = point(110, 500),
          SizeOrg = point(129, 34),
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          Class = "Button",
          CloseDialog = true,
          FontStyle = "Editor14Bold",
          GamepadButton = "ButtonB",
          Id = "idCancel",
          Subview = "default",
          Text = T({1000430, "Cancel"}),
          TextColorDisabled = -8421505,
          PosOrg = point(353, 500),
          SizeOrg = point(132, 34),
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          AutoSelectAll = true,
          NegFilter = "`~!@#$%^&*()_-+={}[]|\\;:'\"<,>./?",
          BackgroundColor = -16777216,
          Id = "idCustomValue",
          Class = "SingleLineEdit",
          FontStyle = "Editor14Bold",
          Subview = "default",
          TextColorDisabled = -8421505,
          PosOrg = point(110, 465),
          SizeOrg = point(375, 24),
          TextVAlign = "center",
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          Text = "PlaceHolder",
          ButtonSize = point(16, 16),
          Class = "CheckButton",
          Id = "idCheckBox1",
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          ImageType = "aaaaa",
          PosOrg = point(110, 440),
          SizeOrg = point(164, 17),
          Subview = "default",
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          Text = "PlaceHolder",
          ButtonSize = point(16, 16),
          Class = "CheckButton",
          Id = "idCheckBox2",
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          ImageType = "aaaaa",
          PosOrg = point(300, 440),
          SizeOrg = point(164, 17),
          Subview = "default",
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        }
      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt
