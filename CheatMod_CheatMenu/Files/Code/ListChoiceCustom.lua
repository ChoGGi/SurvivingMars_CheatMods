local CCodeFuncs = ChoGGi.CodeFuncs
local CComFuncs = ChoGGi.ComFuncs

function ChoGGi.MsgFuncs.ListChoiceCustom_ClassesGenerate()

  DefineClass.ListChoiceCustomDialog = {
    __parents = {
      "FrameWindow"
    }

  }

  --ex(ChoGGi.ListChoiceCustomDialog_Dlg)
  --ChoGGi.ListChoiceCustomDialog_Dlg.colorpicker
  function ListChoiceCustomDialog:Init()
    --init stuff?
    DataInstances.UIDesignerData.ListChoiceCustomDialog:InitDialogFromView(self, "Default")

    self:SetZOrder(20000)
    --set some values...
    self.idEditValue.display_text = "Add Custom Value"
    self.choices = false
    self.sel = false
    self.obj = false
    self.CustomType = 0
    self.colorpicker = nil

    --have to do it for each item?
    --self.idList:SetHSizing("Resize")

    --add some padding before the text
    --self.idEditValue.DisplacementPos = 0
    --self.idEditValue.DisplacementWidth = 10

    --update custom value when dbl right
    self.OnColorChanged = function(color)
      --update item
      self.idList.items[self.idList.last_selected].value = color
      --custom value box
      self.idEditValue:SetText(tostring(color))
    end

    --update custom value list item
    function self.idEditValue.OnValueChanged()
      local value = CComFuncs.RetProperType(self.idEditValue:GetValue())

      if self.CustomType > 0 then
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
      --item list
      self:GetAllItems()
      --send selection back
      self:delete(self.choices)
    end


    --make checkbox work like a button
    local children = self.idCheckBox2.children
    for i = 1, #children do
      if children[i].class == "Button" then
        local but = children[i]
        function but.OnButtonPressed()
          --show lightmodel lists and lets you pick one to use in new window
          if self.CustomType == 5 then
            ChoGGi.MenuFuncs.ChangeLightmodel(true)
          end
        end
      end
    end

    --do stuff on selection
    local origOnLButtonDown = self.idList.OnLButtonDown
    self.idList.OnLButtonDown = function(selfList,...)
      local ret = origOnLButtonDown(selfList,...)
      local sel = self.idList:GetSelection()
      if type(sel) == "table" and next(sel) then
      --if #sel ~= 0 then
        --update selection (select last selected if multisel)
        self.sel = sel[#sel]
        --update the custom value box
        self.idEditValue:SetText(tostring(self.sel.value))
        if self.CustomType > 0 then
          --2 = showing the colour picker
          if self.CustomType == 2 then
            self:UpdateColourPicker()
          --don't show picker unless it's a colour setting
          elseif self.CustomType == 5 then
            if self.CustomType == 5 and self.sel.editor == "color" then
              self:UpdateColourPicker()
              self.idColorHSV:SetVisible(true)
              self:SetWidth(800)
            else
              self.idColorHSV:SetVisible(false)
              --self:SetWidth(400)
            end
          end
        end
      end

      --for whatever is expecting a return value
      return ret
    end

    --what happens when you dbl click the list
    self.idList.OnLButtonDoubleClick = function()
      --open colour changer
      if self.CustomType == 1 or self.CustomType == 2 then
        CCodeFuncs.ChangeObjectColour(self.sel.obj,self.sel.parentobj)
      elseif self.CustomType ~= 5 then
        --dblclick to close and ret item
        self.idOK.OnButtonPressed()
      end
    end

    self.idList.OnRButtonDoubleClick = function()
      --applies the lightmodel without closing dialog,
      if self.CustomType == 5 then
        self:BuildAndApplyLightmodel()
      else
        self.idEditValue:SetText(self.sel.text)
      end
    end

    --stop idColorHSV from closing on dblclick
    self.idColorHSV.OnLButtonDoubleClick = function()
    end
    self.idColorHSV.OnRButtonDoubleClick = function()
      if self.CustomType == 2 then
        if not self.obj then
          --grab the object from the last list item
          self.obj = self.idList.items[#self.idList.items].obj
        end
        local SetPal = self.obj.SetColorizationMaterial
        local items = self.idList.items
        CCodeFuncs.SaveOldPalette(self.obj)
        for i = 1, 4 do
          local Color = items[i].value
          local Metallic = items[i+4].value
          local Roughness = items[i+8].value
          SetPal(self.obj,i,Color,Roughness,Metallic)
        end
        self.obj:SetColorModifier(self.idList.items[#self.idList.items].value)
      elseif self.CustomType == 5 then
        self:BuildAndApplyLightmodel()
      end
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
              if type(item.value) == "userdata" then
                hint = hint .. ": " .. _InternalTranslate(item.value)
              else
                hint = hint .. ": " .. tostring(item.value)
              end
            end
            if item.hint then
              hint = hint .. "\n\n" .. item.hint
            end
            --self.parent.parent:SetHint(hint)
            self.parent:SetHint(hint)
          end
        end
      end
    end

    function self:BuildAndApplyLightmodel()
      --update list item settings table
      self:GetAllItems()
      --remove defaults
      local model_table = {}
      for i = 1, #self.choices do
        local value = self.choices[i].value
        if value ~= self.choices[i].default then
          model_table[#model_table+1] = {
            id = self.choices[i].sort,
            value = value,
          }
        end
      end
      --rebuild it
      CCodeFuncs.LightmodelBuild(model_table)
      --and temp apply
      SetLightmodel(1,"ChoGGi_Custom")
    end

    --update colour
    function self:UpdateColourPicker()
      pcall(function()
        local num = CComFuncs.RetProperType(self.idEditValue:GetText())
        self.idColorHSV:SetHSV(UIL.RGBtoHSV(GetRGB(num)))
        self.idColorHSV:InitHSVPtPos()
        self.idColorHSV:Invalidate()
      end)
    end

    function self:GetAllItems()
      --always start with blank choices
      self.choices = {}
      --get sel item(s)
      local items = self.idList:GetSelection()
      --get all items
      if self.CustomType > 0 and self.CustomType ~= 3 then
        items = self.idList.items
      end
      if #items > 0 then
        for i = 1, #items do
          if i == 1 then
            --always return the custom value (and try to convert it to correct type)
            items[i].editvalue = CComFuncs.RetProperType(self.idEditValue:GetText())
          end
          self.choices[#self.choices+1] = items[i]
        end
        --add checkbox statuses
        self.choices[1].check1 = self.idCheckBox1:GetToggled()
        self.choices[1].check2 = self.idCheckBox2:GetToggled()
        self.choices[1].checkair = self.idColorCheckAir:GetToggled()
        self.choices[1].checkwater = self.idColorCheckWater:GetToggled()
        self.choices[1].checkelec = self.idColorCheckElec:GetToggled()
      end
    end

    --function ListChoiceCustomDialog:OnKbdKeyDown(char, virtual_key)
    function self:OnKbdKeyDown(_, virtual_key)
      if virtual_key == const.vkEsc then
        if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
          self.idClose:Press()
        end
        self:SetFocus()
        return "break"
        --[[
      elseif virtual_key == const.vkEnter then
        self.idOK:Press()
        return "break"
      elseif virtual_key == const.vkSpace then
        self.idCheckBox1:SetToggled(not self.idCheckBox1:GetToggled())
        return "break"
        --]]
      end
      return "continue"
    end

  end --init

end --ClassesGenerate

function ChoGGi.MsgFuncs.ListChoiceCustom_ClassesBuilt()

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
          HSizing = "Resize",
          VSizing = "Resize"
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
          HSizing = "Resize",
          VSizing = "AnchorToBottom"
        },
        {
          Id = "idEditValue",
          Class = "SingleLineEdit",
          AutoSelectAll = true,
          --NegFilter = "`!@#$^&_|\\;:\<>.?",
          FontStyle = "Editor14Bold",
          Subview = "default",
          PosOrg = point(110, 465),
          SizeOrg = point(375, 24),
          TextVAlign = "center",
          Hint = "You can enter a custom value to be applied.\n\nWarning: Entering the wrong value may crash the game or otherwise cause issues.",
          HSizing = "Resize",
          VSizing = "AnchorToBottom"
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
          HSizing = "AnchorToMidline",
          VSizing = "AnchorToBottom"
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
          HSizing = "AnchorToMidline",
          VSizing = "AnchorToBottom"
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
          HSizing = "AnchorToMidline",
          VSizing = "AnchorToBottom"
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
          HSizing = "AnchorToMidline",
          VSizing = "AnchorToBottom"
        },
        {
          Id = "idColorHSV",
          Class = "ColorHSVControl",
          Visible = false,
          PosOrg = point(500, 115),
          SizeOrg = point(300, 300),
          Hint = "Double right click to set without closing dialog.",
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
