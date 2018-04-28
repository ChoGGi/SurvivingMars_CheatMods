--
function ChoGGi.ObjectManipulator_ClassesGenerate()

  DefineClass.ObjectManipulator = {
    __parents = {
      "FrameWindow",
      "PauseGameDialog"
    }
  }

-------------------------
function ObjectManipulator:dsgffdjhftsffhjgf()
-------------------------
print("ChoGGi.testing")
ex(ChoGGi.ObjectManipulator_Dlg.idList)


ChoGGi.ObjectManipulator_Dlg.idList:UpdateRollover()
ChoGGi.ObjectManipulator_Dlg.idList.columns = 3
ChoGGi.ObjectManipulator_Dlg.idList.column_or_row_sizes = {column1=50,column2=50,column3=50}

ChoGGi.ObjectManipulator_Dlg.idList:SetContent({

  {text = 1,hint = 11111,column1 = true},
  {text = 2,hint = 22222,column2 = true},
  {text = 3,hint = 33333,column3 = true}
})

ChoGGi.ObjectManipulator_Dlg.idList.item_windows[1]:SetHint()
-------------------------
end
-------------------------

  function ObjectManipulator:Init()
    --init stuff?
    DataInstances.UIDesignerData.ObjectManipulator:InitDialogFromView(self, "Default")

    --set some values...
    self.idEditValue.display_text = "Edit Value"
    self.choices = {}
    self.sel = false
    self.obj = false
  self.onclick_handles = {}
  self.page = 1
  self.show_times = "relative"

  function self.idList.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end

    --have to do it for each item?
    --self.idList.single = false

    --add some padding before the text
    --self.idEditValue.DisplacementPos = 0
    --self.idEditValue.DisplacementWidth = 10

    --update custom value list item
    function self.idEditValue.OnValueChanged()
      self.idList:SetItem(#self.idList.items,{
        text = self.idEditValue:GetText(),
        value = ChoGGi.RetNumOrString(self.idEditValue:GetText()),
        hint = "< Use custom value"
      })
    end

    function self.idClose.OnButtonPressed()
      self:delete()
    end

    --hook into SetContent so we can add OnSetState to each listitem to show hints
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

----click actions

    --single left click
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
      self.idEditValue:SetText(self.sel.text)
    end

    --dblclick to ?
    --self.idList.OnDoubleClick = ""
  end --init

  function ObjectManipulator:PostInit()
  print("PostInit")
  end

  function ObjectManipulator:OnKbdKeyDown(char, virtual_key)
    if virtual_key == const.vkEsc then
      self.idClose:Press()
      return "break"
    elseif virtual_key == const.vkSpace then
      self.idCheckBox1:SetToggled(not self.idCheckBox1:GetToggled())
      return "break"
    end
    return "continue"
  end

  function ObjectManipulator:HyperLink(f, custom_color)
    table.insert(self.onclick_handles, f)
    return (custom_color or "<color 150 170 250>") .. "<h " .. #self.onclick_handles .. " 230 195 50>"
  end

  function ObjectManipulator:filtersmarttable(e)
    local format_text = tostring(e[2])
    local t = string.match(format_text, "^%[(.*)%]")
    if t then
      if LocalStorage.trace_config ~= nil then
        local filter = filters[LocalStorage.trace_config] or filters.General
        if not table.find(filter, t) then
          return false
        end
      end
      format_text = string.sub(format_text, 3 + #t)
    end
    return format_text, e
  end

  function ObjectManipulator:evalsmarttable(format_text, e)
  local touched = {}
  local i = 0
  format_text = string.gsub(format_text, "{(%d-)}", function(s)
    if #s == 0 then
      i = i + 1
    else
      i = tonumber(s)
    end
    touched[i + 1] = true
    return "<color 255 255 128>" .. ChoGGi.CreateProp(e[i + 2]) .. "</color>"
  end)
  for i = 2, #e do
    if not touched[i] then
      format_text = format_text .. " <color 255 255 128>[" .. ChoGGi.CreateProp(e[i]) .. "]</color>"
    end
  end
  return format_text
end

end --ClassesGenerate

function ChoGGi.ObjectManipulator_ClassesBuilt()

  --dialog layout
  --[[
  DesignResolution
  MinSize
  SizeOrg
  --]]
  UIDesignerData:new({
    DesignOrigin = point(100, 100),
    DesignResolution = point(650, 450),
    --HGE = true,
    Translate = false,
    file_name = "ObjectManipulator",
    name = "ObjectManipulator",
    parent_control = {
      CaptionHeight = 32,
      Class = "FrameWindow",
      GamepadStrip = false,
      Image = "CommonAssets/UI/Controls/WindowFrame.tga",
      --Image = ChoGGi.ModPath .. "Images/WindowFrameDark.tga",
      MinSize = point(100, 450),
      Movable = true,
      PatternBottomRight = point(123, 122),
      PatternTopLeft = point(4, 24),
      PosOrg = point(100, 100),
      SizeOrg = point(650, 450),
      HorizontalResize = true,
      VerticalResize = true,
    },
    subviews = {
      {
        name = "default",
        {
          Id = "idCaption",
          Class = "StaticText",
          TextPrefix = "<center>",
          TextVAlign = "center",
          BackgroundColor = 0,
          FontStyle = "Editor14Bold",
          HandleMouse = false,
          Subview = "default",
          HSizing = "0, 1, 0",
          VSizing = "0, 1, 0",
          PosOrg = point(250, 101),
          SizeOrg = point(390, 22),
        },
        {
          Id = "idClose",
          Class = "Button",
          CloseDialog = true,
          --FontStyle = "Editor14Bold",
          Image = "CommonAssets/UI/Controls/Button/Close.tga",
          --ImageType = "aaaaa",
          Subview = "default",
          --Text = "X",
          --HSizing = "1, 0, 1",
          HSizing = "AnchorToRight",
          VSizing = "1, 0, 0",
          PosOrg = point(729, 103),
          SizeOrg = point(18, 18),
        },
        --(row) of checkboxe(s)
        {
          Id = "idAutoRefresh",
          Class = "CheckButton",
          TextHAlign = "center",
          TextVAlign = "center",
          ButtonSize = point(16, 16),
          Image = "CommonAssets/UI/Controls/Button/CheckButton.tga",
          --ImageType = "aaaaa",
          Text = "Auto-Refresh",
          Hint = "Auto-refresh list every second (removes any unapplied values).",
          Subview = "default",
          --HSizing = "1, 0, 1",
          VSizing = "1, 0, 0",
          PosOrg = point(115, 128),
          SizeOrg = point(164, 17),
        },
        --row of buttons

        {
          Id = "idRefresh",
          Class = "Button",
          TextHAlign = "center",
          TextVAlign = "center",
          --FontStyle = "Editor14Bold",
          Subview = "default",
          Text = "Refresh",
          Hint = "Refresh list without applying changed values.",
          --HSizing = "1, 0, 1",
          VSizing = "1, 0, 0",
          PosOrg = point(115, 150),
          SizeOrg = point(65, 26),
        },
        {
          Id = "idGoto",
          Class = "Button",
          TextHAlign = "center",
          TextVAlign = "center",
          --FontStyle = "Editor14Bold",
          Subview = "default",
          Text = "Goto Obj",
          Hint = "View object on map.",
          --HSizing = "1, 0, 1",
          VSizing = "1, 0, 0",
          PosOrg = point(185, 150),
          SizeOrg = point(75, 26),
        },
        {
          Id = "idApply",
          Class = "Button",
          TextHAlign = "center",
          TextVAlign = "center",
          --FontStyle = "Editor14Bold",
          Subview = "default",
          Text = "Apply",
          Hint = "Apply unsaved values to object.",
          --HSizing = "1, 0, 1",
          VSizing = "1, 0, 0",
          PosOrg = point(280, 150),
          SizeOrg = point(65, 26),
        },
        --list
        {
        --  column_or_row_sizes = false,
  --columns = 0,

          Id = "idList",
          Class = "List",
          --Class = "AccordionList",
          ShowPartialItems = true,
          --ByRows = true, --When true the list box orders the items in rows, otherwise in columns
          --Single = false, --When true the list box shows only one item per row or column
          ScrollPadding = 1,
          FontStyle = "Editor14Bold",
          RolloverFontStyle = "Editor14",
          ScrollBar = true,
          ScrollAutohide = true,
          SelectionColor = RGB(0, 0, 0),
          SelectionFontStyle = "Editor14Bold",
          BackgroundColor = RGB(50, 50, 50),
          Spacing = point(8, 2),
          Subview = "default",
          HSizing = "0, 1, 0",
          VSizing = "0, 1, 0",
          PosOrg = point(104, 180),
          SizeOrg = point(642, 330),
        },
        --editor line
        {
          Id = "idEditValue",
          Class = "SingleLineEdit",
          AutoSelectAll = true,
          MaxLen = 500,
          NegFilter = "`~!@#$%^&()_={}[]|\\;:'\"<,>.?",
          FontStyle = "Editor14Bold",
          Subview = "default",
          Spacing = 10,
          TextVAlign = "center",
          Hint = "Use to change values of selected list item.",
          --HSizing = "1, 0, 1",
          HSizing = "0, 1, 0",
          VSizing = "1, 0, 0",
          PosOrg = point(106, 513),
          SizeOrg = point(385, 28),
        },

      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt
