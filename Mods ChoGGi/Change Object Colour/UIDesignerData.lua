function OnMsg.ClassesGenerate()

  DefineClass.ListChoiceCustomDialog = {
    __parents = {
      "FrameWindow"
    }
  }

  --ex(ChoGGiX.ListChoiceCustomDialog_Dlg)
  --ChoGGiX.ListChoiceCustomDialog_Dlg.colorpicker
  function ListChoiceCustomDialog:Init()
    --init stuff?
    DataInstances.UIDesignerData.ListChoiceCustomDialog:InitDialogFromView(self, "Default")

    --set some values...
    self.idEditValue.display_text = "Add Custom Value"
    self.choices = false
    self.sel = false
    self.obj = false
    self.CustomType = nil
    self.colorpicker = nil

    --have to do it for each item?
    self.idList:SetHSizing("Resize")

    --add some padding before the text
    --self.idEditValue.DisplacementPos = 0
    --self.idEditValue.DisplacementWidth = 10

    --do stuff on selection
    local origOnLButtonDown = self.idList.OnLButtonDown
    self.idList.OnLButtonDown = function(selfList,...)
      local ret = origOnLButtonDown(selfList,...)
      local sel = self.idList:GetSelection()
      if #sel ~= 0 then
        --update selection (select last selected if multisel)
        self.sel = sel[#sel]
        --update the custom value box
        self.idEditValue:SetText(tostring(self.sel.value))
        if type(self.CustomType) == "number" then
          --2 = showing the colour picker
          if self.CustomType == 2 then
            self:UpdateColourPicker()
          end
        end
      end

      --for whatever is expecting a return value
      return ret
    end

    --update custom value when dbl right
    self.OnColorChanged = function(color)
      --update item
      self.idList.items[self.idList.last_selected].value = color
      --custom value box
      self.idEditValue:SetText(tostring(color))
    end

    self.idList.OnRButtonDoubleClick = function()
      self.idEditValue:SetText(self.sel.text)
    end

    --update custom value list item
    function self.idEditValue.OnValueChanged()
      local value = ChoGGiX.RetProperType(self.idEditValue:GetValue())

      if type(self.CustomType) == "number" then
        self.idList.items[self.idList.last_selected].value = value
      else
        self.idList:SetItem(#self.idList.items,{
          text = value,
          value = value,
          hint = "< Use custom value"
        })
      end
    end

    --return values
    function self.idOK.OnButtonPressed()
      --check checkboxes
      ChoGGiX.ListChoiceCustomDialog_CheckBox1 = self.idCheckBox1:GetToggled()
      ChoGGiX.ListChoiceCustomDialog_CheckBox2 = self.idCheckBox2:GetToggled()
      ChoGGiX.ListChoiceCustomDialog_ColorCheckAir = self.idColorCheckAir:GetToggled()
      ChoGGiX.ListChoiceCustomDialog_ColorCheckWater = self.idColorCheckWater:GetToggled()
      ChoGGiX.ListChoiceCustomDialog_ColorCheckElec = self.idColorCheckElec:GetToggled()

      self:GetAllItems()
      --send selection back
      self:delete(self.choices)
    end

    --what happens when you dbl click the list
    self.idList.OnDoubleClick = function()
      if type(self.CustomType) == "number" then
        if self.CustomType == 1 then
        --dblclick to open item
        ChoGGiX.ChangeObjectColour(self.sel.obj,self.sel.parentobj)
        end
      else
        --dblclick to close and ret item
        self.idOK.OnButtonPressed()
      end
    end

    --stop idColorHSV from closing on dblclick
    self.idColorHSV.OnLButtonDoubleClick = function()
      if not self.obj then
        --grab the object from the last list item
        self.obj = self.idList.items[#self.idList.items].obj
      end
      local SetPal = self.obj.SetColorizationMaterial
      local items = self.idList.items
      ChoGGiX.SaveOldPalette(self.obj)
      for i = 1, 4 do
        local Color = items[i].value
        local Metallic = items[i+4].value
        local Roughness = items[i+8].value
        SetPal(self.obj,i,Color,Roughness,Metallic)
      end
      self.obj:SetColorModifier(self.idList.items[#self.idList.items].value)
    end

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

  --update colour
  function ListChoiceCustomDialog:UpdateColourPicker()
    local num = ChoGGiX.RetProperType(self.idEditValue:GetText())
    self.idColorHSV:SetHSV(UIL.RGBtoHSV(GetRGB(num)))
    self.idColorHSV:InitHSVPtPos()
    self.idColorHSV:Invalidate()
  end

  function ListChoiceCustomDialog:GetAllItems()
    --always start with blank choices
    self.choices = {}
    --get sel item(s)
    local items = self.idList:GetSelection()
    --get all items
    if type(self.CustomType) == "number" then
      items = self.idList.items
    end
    for i = 1, #items do
      if i == 1 then
        --always return the custom value (and try to convert it to correct type)
        items[i].custom = ChoGGiX.RetProperType(self.idEditValue:GetText())
      end
      table.insert(self.choices,items[i])
    end
  end

  function ListChoiceCustomDialog:OnKbdKeyDown(char, virtual_key)
    if virtual_key == const.vkEsc then
      if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
        self.idClose:Press()
      end
      self:SetFocus()
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

function OnMsg.ClassesBuilt()

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
          Id = "idEditValue",
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
          PosOrg = point(110, 440),
          SizeOrg = point(200, 17),
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
          PosOrg = point(300, 440),
          SizeOrg = point(200, 17),
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
          Id = "idClose",
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
        {
          Id = "idColorHSV",
          Class = "ColorHSVControl",
          Visible = false,
          PosOrg = point(500, 115),
          SizeOrg = point(300, 300),
          Hint = "Double-click to set colour without closing dialog.",
        },
        {
          Id = "idColorCheckAir",
          Class = "CheckButton",
          Visible = false,
          PosOrg = point(525, 400),
          SizeOrg = point(50, 17),
          ButtonSize = point(16, 16),
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          Text = "Air",
          Hint = hint_connectedgrid,
        },
        {
          Id = "idColorCheckWater",
          Class = "CheckButton",
          Visible = false,
          PosOrg = point(575, 400),
          SizeOrg = point(60, 17),
          ButtonSize = point(16, 16),
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          Text = "Water",
          Hint = hint_connectedgrid,
        },
        {
          Id = "idColorCheckElec",
          Class = "CheckButton",
          Visible = false,
          PosOrg = point(645, 400),
          SizeOrg = point(85, 17),
          ButtonSize = point(16, 16),
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          Text = "Electricity",
          Hint = hint_connectedgrid,
        },

      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt
