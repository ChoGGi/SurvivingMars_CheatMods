ChoGGiX = {}

function OnMsg.ClassesGenerate()

  DefineClass.ListChoiceCustomDialog = {
    __parents = {
      "FrameWindow",
      "PauseGameDialog"
    }
  }

  function ListChoiceCustomDialog:Init()
    --init stuff?
    DataInstances.UIDesignerData.ListChoiceCustomDialog:InitDialogFromView(self, "Default")

    --set some values...
    self.idEditValue.display_text = "Add Custom Value"
    self.choices = false
    self.sel = false
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

      --update selection (select last selected if multisel)
      self.sel = self.idList:GetSelection()[#self.idList:GetSelection()]
      --update the custom value box
      self.idEditValue:SetText(tostring(self.sel.value))
      if type(self.CustomType) == "number" then
        --2 = showing the colour picker
        if self.CustomType == 2 then
          self:UpdateColourPicker()
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

      self:GetAllItems()
      --send selection back
      self:delete(self.choices)
    end

    self.idList.OnDoubleClick = function()
      if type(self.CustomType) == "number" and self.CustomType == 1 then
        --dblclick to open item
        ChoGGiX.ChangeObjectColour(self.sel.obj)
      else
        --dblclick to ret item
        self.idOK.OnButtonPressed()
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
        },

      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt

function OnMsg.LoadGame()

  --change some annoying stuff about UserActions.AddActions()
  local g_idxAction = 0
  function ChoGGiX.UserAddActions(ActionsToAdd)
    for k, v in pairs(ActionsToAdd) do
      if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
        if v.key ~= nil and v.key ~= "" then
          if type(v.key) == "table" then
            local keys = v.key
            if #keys <= 0 then
              v.description = ""
            else
              v.description = v.description .. " (" .. keys[1]
              for i = 2, #keys do
                v.description = v.description .. " or " .. keys[i]
              end
              v.description = v.description .. ")"
            end
          else
            v.description = tostring(v.description) .. " (" .. v.key .. ")"
          end
        end
        v.id = k
        v.idx = g_idxAction
        g_idxAction = g_idxAction + 1
        UserActions.Actions[k] = v
      else
        UserActions.RejectedActions[k] = v
      end
    end
    UserActions.SetMode(UserActions.mode)
  end

  function ChoGGiX.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
    if Menu then
      Menu = "/" .. tostring(Menu)
    end

    ChoGGiX.UserAddActions({
      ["ChoGGiX_" .. AsyncRand()] = {
        menu = Menu,
        action = Action,
        key = Key,
        description = Des or "",
        icon = Icon,
        toolbar = Toolbar,
        mode = Mode,
        xinput = xInput,
        toolbar_default = ToolbarDefault
      }
    })
  end

  function ChoGGiX.GetPalette(Obj)
    local get = Obj.GetColorizationMaterial
    local pal = {}
    pal.Color1, pal.Roughness1, pal.Metallic1 = get(Obj, 1)
    pal.Color2, pal.Roughness2, pal.Metallic2 = get(Obj, 2)
    pal.Color3, pal.Roughness3, pal.Metallic3 = get(Obj, 3)
    pal.Color4, pal.Roughness4, pal.Metallic4 = get(Obj, 4)
    return pal
  end

  function ChoGGiX.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
  local dlg = ListChoiceCustomDialog:new()

  if not dlg then
    return
  end

  if ChoGGiX.Testing then
--easier to fiddle with it like this
ChoGGiX.ListChoiceCustomDialog_Dlg = dlg
  end

    --title text
    dlg.idCaption:SetText(Caption)
    --list
    dlg.idList:SetContent(Items)

    --fiddling with custom value
    if CustomType then
    dlg.idEditValue.auto_select_all = false
      dlg.CustomType = CustomType
      if dlg.CustomType == 2 then
        dlg.idColorHSV:SetVisible(true)
        dlg:SetWidth(800)
        dlg.idList:SetSelection(1, true)
        dlg.sel = dlg.idList:GetSelection()[#dlg.idList:GetSelection()]
      dlg.idEditValue:SetText(tostring(dlg.sel.value))
        dlg:UpdateColourPicker()
      end
    end

    if MultiSel then
      dlg.idList.multiple_selection = true
      if type(MultiSel) == "number" then
        --select all of number
        for i = 1, MultiSel do
          dlg.idList:SetSelection(i, true)
        end
      end
    end

    --setup checkboxes
    if not Check1 and not Check2 then
      dlg.idCheckBox1:SetVisible(false)
      dlg.idCheckBox2:SetVisible(false)
    else
      dlg.idList:SetSize(point(390, 310))

      if Check1 then
        dlg.idCheckBox1:SetText(Check1)
        dlg.idCheckBox1:SetHint(Check1Hint)
      else
        dlg.idCheckBox1:SetVisible(false)
      end
      if Check2 then
        dlg.idCheckBox2:SetText(Check2)
        dlg.idCheckBox2:SetHint(Check2Hint)
      else
        dlg.idCheckBox2:SetVisible(false)
      end
    end
    --where to position dlg
    dlg:SetPos(terminal.GetMousePos())

    --focus on list
    dlg.idList:SetFocus()
    --dlg.idList:SetSelection(1, true)

    --are we showing a hint?
    if Hint then
      dlg.idList:SetHint(Hint)
      dlg.idOK:SetHint(dlg.idOK:GetHint() .. "\n\n\n" .. Hint)
    end

    --waiting for choice
    return dlg:Wait()
  end

  function ChoGGiX.CompareTableNames(a,b,sName)
    if type(a[sName]) == type(b[sName]) then
      return a[sName] < b[sName]
    else
      return tostring(a[sName]) < tostring(b[sName])
    end
  end
  function ChoGGiX.RetProperType(Value)
    --number?
    local ret = tonumber(Value)
    if ret then
      return ret
    end
    --stringy boolean
    if Value == "true" then
      return true
    elseif Value == "false" then
      return false
    end
    --then it's a string (probably)
    return Value
  end


  function ChoGGiX.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
    if not Func or not Items or (Items and #Items == 0) then
      return
    end

    --sort table by display text
    table.sort(Items,
      function(a,b)
        return ChoGGiX.CompareTableNames(a,b,"text")
      end
    )

    --only insert blank item if we aren't updating other items with it
    if not CustomType then
      --insert blank item for adding custom value
      table.insert(Items,{text = "",hint = "",value = false})
    end

    CreateRealTimeThread(function()
      local option = ChoGGiX.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
    if option ~= "idClose" then
        Func(option)
      end
    end)
  end

--build n show a list of attaches for changing colour
  function ChoGGiX.CreateObjectListAndAttaches()
    local obj = SelectedObj or SelectionMouseObj()
    local ItemList = {}

    --has no Attaches so just open as is
    if obj:GetNumAttaches() == 0 then
      ChoGGiX.ChangeObjectColour(obj)
      return
    else
      table.insert(ItemList,{
        text = " " .. obj.class,
        obj = obj,
        hint = "Change main object colours."
      })
      local Attaches = obj:GetAttaches()
      for i = 1, #Attaches do
        table.insert(ItemList,{
          text = Attaches[i].class,
          obj = Attaches[i],
          hint = "Change colours of a part of an object."
        })
      end
    end

    --callback
    local CallBackFunc = function(choice)
      ChoGGiX.ChangeObjectColour(choice[1].obj)
    end

    local hint = "Double click to open object/attachment to edit."
    ChoGGiX.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,nil,nil,nil,nil,nil,1)
  end

  function ChoGGiX.ChangeObjectColour(obj)
  if not obj and not obj:IsKindOf("ColorizableObject") then
    ChoGGiX.MsgPopup("Can't colour object","Colour")
    return
  end
  --SetPal(sel,i,Color,Roughness,Metallic)
  local SetPal = obj.SetColorizationMaterial
  local GetPal = obj.GetColorizationMaterial
  local pal = ChoGGiX.GetPalette(obj)

  local ItemList = {}
  table.insert(ItemList,{
    text = "X_BaseColour",
    value = 6579300,
    hint = "single colour for object (if you really want to change the colour of something you can't above).",
  })
  for i = 1, 4 do
    table.insert(ItemList,{
      text = "Colour " .. i,
      value = pal["Color" .. i],
      hint = "Use the colour picker.",
    })
    table.insert(ItemList,{
      text = "Metallic " .. i,
      value = pal["Metallic" .. i],
      hint = "Don't use the colour picker. Numbers range from -255 to 255?",
    })
    table.insert(ItemList,{
      text = "Roughness " .. i,
      value = pal["Roughness" .. i],
      hint = "Don't use the colour picker. Numbers range from -255 to 255?",
    })
  end

  --callback
  local CallBackFunc = function(choice)
    if #choice == 13 then
      --keep original colours as part of object
      local base = choice[13].value
      local function saveold(obj)
        if not obj.ChoGGi_origcolors then
          obj.ChoGGi_origcolors = {}
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,1)})
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,2)})
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,3)})
          table.insert(obj.ChoGGi_origcolors,{GetPal(obj,4)})
        end
      end
      local function restoreold(obj)
        if obj.ChoGGi_origcolors then
          local c = obj.ChoGGi_origcolors
          local SetPal = obj.SetColorizationMaterial
          SetPal(obj,1, c[1][1], c[1][2], c[1][3])
          SetPal(obj,2, c[2][1], c[2][2], c[2][3])
          SetPal(obj,3, c[3][1], c[3][2], c[3][3])
          SetPal(obj,4, c[4][1], c[4][2], c[4][3])
        end
      end

      table.sort(choice,
        function(a,b)
          return ChoGGiX.CompareTableNames(a,b,"text")
        end
      )

      if ChoGGiX.ListChoiceCustomDialog_CheckBox1 then
        for _,building in ipairs(UICity.labels[obj.class] or empty_table) do
          if ChoGGiX.ListChoiceCustomDialog_CheckBox2 then
            restoreold(building)
            --6579300 = reset color mod thingy
            building:SetColorModifier(6579300)
          else
            if base == 6579300 then
              saveold(building)
              for i = 1, 4 do
                local Color = choice[i].value
                local Metallic = choice[i+4].value
                local Roughness = choice[i+8].value
                SetPal(building,i,Color,Roughness,Metallic)
              end
            else
              building:SetColorModifier(base)
            end
          end
        end
      else
        if ChoGGiX.ListChoiceCustomDialog_CheckBox2 then
          restoreold(obj)
          obj:SetColorModifier(6579300)
        else
          if base == 6579300 then
            saveold(obj)
            for i = 1, 4 do
              local Color = choice[i].value
              local Metallic = choice[i+4].value
              local Roughness = choice[i+8].value
              SetPal(obj,i,Color,Roughness,Metallic)
            end
          else
            obj:SetColorModifier(base)
          end
        end
      end

      ChoGGiX.MsgPopup("Colour is set on " .. obj.encyclopedia_id,"Colour")
    end
  end
  local hint = "If number is 8421504 (0 for Metallic/Roughness) then you can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking)."
  local hint_check1 = "Change all objects of the same type."
  local hint_check2 = "if they're there; resets to default colours."
  ChoGGiX.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,true,"All of type",hint_check1,"Default Colour",hint_check2,2)
end




  ChoGGiX.AddAction(
    "Expanded CM/Buildings/Change Colour",
    ChoGGiX.CreateObjectListAndAttaches,
    "F6",
    "Select a building to change the colour (of some buildings).",
    "toggle_dtm_slots.tga"
  )

end
