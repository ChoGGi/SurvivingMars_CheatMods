function ChoGGi.UIDesignerData_ClassesGenerate()

  DefineClass.ListChoiceCustomDialog = {
    __parents = {
      "FrameWindow",
      "PauseGameDialog"
    }
  }

  --ex(ChoGGi.ListChoiceCustomDialog_Dlg.idList)
  function ListChoiceCustomDialog:Init()
    --init stuff?
    DataInstances.UIDesignerData.ListChoiceCustomDialog:InitDialogFromView(self, "Default")

    --set some values...
    self.idCustomValue.display_text = "Add Custom Value"
    self.choices = {}
    self.sel = false

    --have to do it for each item?
    self.idList:SetHSizing("Resize")

    --add some padding before the text
    --self.idCustomValue.DisplacementPos = 0
    --self.idCustomValue.DisplacementWidth = 10

    --do stuff on selection
    local origOnLButtonDown = self.idList.OnLButtonDown
    self.idList.OnLButtonDown = function(selfList,...)
      local ret = origOnLButtonDown(selfList,...)
      --update selection (select last selected if multisel)
      self.sel = self.idList:GetSelection()[#self.idList:GetSelection()]
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
    end

    --return values
    function self.idOK.OnButtonPressed()
      --check checkboxes
      ChoGGi.ListChoiceCustomDialog_CheckBox1 = self.idCheckBox1:GetToggled()
      ChoGGi.ListChoiceCustomDialog_CheckBox2 = self.idCheckBox2:GetToggled()

      --get sel item(s)
      local items = self.idList:GetSelection()
      for i = 1, #items do
        if i == 1 then
          --always return the custom value
          local number = tonumber(self.idCustomValue:GetText())
          if number then
            items[i].custom = number
          else
            items[i].custom = self.idCustomValue:GetText()
          end
        end
        table.insert(self.choices,items[i])
      end
      --send selection back
      self:delete(self.choices)
    end

    --dblclick to ret item
    self.idList.OnDoubleClick = self.idOK.OnButtonPressed

    --hook into SetContent so we can add OnSetState to each list item to show hints
    self.idList.Orig_SetContent = self.idList.SetContent
    function self.idList:SetContent(items)
      self.Orig_SetContent(self,items)
      local listitems = self.item_windows
      for i = 1, #listitems do
        local listitem = listitems[i]
        listitem.Orig_OnSetState = listitem.OnSetState
        function listitem:OnSetState(list, item, rollovered, selected)
          self.Orig_OnSetState(self,list, item, rollovered, selected)
          if rollovered or selected then
            local hint = item.text
            if item.value then
              hint = hint .. ": " .. item.value
            end
            if item.hint then
              hint = hint .. "\n\n" .. item.hint
            end
            self.parent.parent:SetHint(hint)
          end
        end
      end
    end

  end --init

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

  --dialog layout
  --[[
  DesignResolution
  MinSize
  SizeOrg
  --]]
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
          Id = "idCaption",
          Class = "StaticText",
          TextPrefix = "<center>",
          BackgroundColor = 0,
          FontStyle = "Editor14Bold",
          HandleMouse = false,
          Subview = "default",
          PosOrg = point(105, 101),
          SizeOrg = point(390, 22),
          HSizing = "0, 1, 0",
          VSizing = "0, 1, 0"
        },

        {
          Id = "idList",
          Class = "List",
          ShowPartialItems = true,
          ScrollPadding = 1,
          SelectionColor = RGB(0, 0, 0),
          FontStyle = "Editor14",
          PosOrg = point(105, 123),
          RolloverFontStyle = "Editor14",
          ScrollBar = true,
          ScrollAutohide = true,
          SelectionFontStyle = "Editor14",
          Spacing = point(8, 2),
          Subview = "default",
          SizeOrg = point(390, 335),
          HSizing = "0, 1, 0",
          VSizing = "0, 1, 0"
        },
        {
          Id = "idCustomValue",
          Class = "SingleLineEdit",
          AutoSelectAll = true,
          NegFilter = "`~!@#$%^&()_={}[]|\\;:'\"<,>.?",
          FontStyle = "Editor14Bold",
          Subview = "default",
          PosOrg = point(110, 465),
          SizeOrg = point(375, 24),
          TextVAlign = "center",
          Hint = "You can enter a custom value to be applied.\n\nWarning: Entering the wrong value may crash the game or otherwise cause issues.",
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          Id = "idCheckBox1",
          Class = "CheckButton",
          Text = "PlaceHolder",
          ButtonSize = point(16, 16),
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          ImageType = "aaaaa",
          PosOrg = point(110, 440),
          SizeOrg = point(164, 17),
          Subview = "default",
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          Id = "idCheckBox2",
          Class = "CheckButton",
          Text = "PlaceHolder",
          ButtonSize = point(16, 16),
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          ImageType = "aaaaa",
          PosOrg = point(300, 440),
          SizeOrg = point(164, 17),
          Subview = "default",
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          Id = "idOK",
          Class = "Button",
          FontStyle = "Editor14Bold",
          GamepadButton = "ButtonA",
          Subview = "default",
          Text = T({1000429, "OK"}),
          Hint = "Apply and close dialog (Arrow keys and Enter/Esc can also be used).",
          PosOrg = point(110, 500),
          SizeOrg = point(129, 34),
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },
        {
          Id = "idCancel",
          Class = "Button",
          CloseDialog = true,
          FontStyle = "Editor14Bold",
          GamepadButton = "ButtonB",
          Hint = "Cancel without changing anything.",
          Subview = "default",
          Text = T({1000430, "Cancel"}),
          PosOrg = point(353, 500),
          SizeOrg = point(132, 34),
          HSizing = "1, 0, 1",
          VSizing = "1, 0, 0"
        },

      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt
