--
function ChoGGi.MsgFuncs.ObjectManipulator_ClassesGenerate()

  DefineClass.ObjectManipulator = {
    __parents = {
      "FrameWindow",
      --"PauseGameDialog"
    }
  }

  --ex(ChoGGi.ObjectManipulator_Dlg.idAutoRefresh)
  --ex(ChoGGi.ObjectManipulator_Dlg)
  function ObjectManipulator:Init()
    --init stuff?
    DataInstances.UIDesignerData.ObjectManipulator:InitDialogFromView(self, "Default")

    --set some values...
    self.idEditValue.display_text = "Edit Value"
    self.choices = {}
    self.sel = false
    self.obj = false
    self.refreshing = false
  self.page = 1
  self.show_times = "relative"

    --have to do it for each item?
    --self.idList.single = false

    --add some padding before the text
    --self.idEditValue.DisplacementPos = 0
    --self.idEditValue.DisplacementWidth = 10

    --update custom value list item
    function self.idEditValue.OnValueChanged()
      local sel_idx = self.idList.last_selected
      --nothing selected
      if not sel_idx then
        return
      end
      --
      local edit_text = self.idEditValue:GetText()
      local edit_value = ChoGGi.Funcs.RetProperType(edit_text)
      local edit_type = type(edit_value)
      local obj_value = self.obj[self.idList.items[sel_idx].text]
      local obj_type = type(obj_value)
      --only update strings/numbers/boolean/nil
      if obj_type == "table" or obj_type == "userdata" or obj_type == "function" or obj_type == "thread" then
        return
      end

      --if types match then we're fine, or nil if we're removing something
      if obj_type == edit_type or edit_type == "nil" or
          --false bools can be made a string or num
          (obj_value == false and edit_type == "string" or edit_type == "number") or
          --strings can be numbers or bools
          (obj_type == "string" and edit_type == "number" or edit_type == "boolean") or
          --numbers can be false
          (obj_type ~= "number" and edit_type ~= "boolean") then
        --list item
        self.idList.items[sel_idx].value = edit_text
        --stored obj
        self.idList.item_windows[sel_idx].value:SetText(edit_text)
        --actual object
        local value = self.obj[self.idList.items[sel_idx].text]
        if value == false or value then
          self.obj[self.idList.items[sel_idx].text] = edit_value
        end
      end
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
            self.parent:SetHint(hint .. "\n\nYou can only change strings/numbers/booleans (to remove set value to nil).\nValue is updated while typing.\nPress Enter to refresh list (update names).\n\nDouble right-click selected item to open in new manipulator.")
          end
        end
      end
    end

    --override ListItem:OnCreate
    function self.idList:ItemCreate(item_window, item)
      if not item_window then
        return
      end
      self.parent.OnCreate(item_window,item,self)
    end

----click actions

    --do stuff on selection
    local origOnLButtonDown = self.idList.OnLButtonDown
    self.idList.OnLButtonDown = function(selfList,...)
      local ret = origOnLButtonDown(selfList,...)

      --update selection (select last selected if multisel)
      self.sel = self.idList:GetSelection()[#self.idList:GetSelection()]
      if self.sel then
        --update the edit value box
        self.idEditValue:SetText(self.sel.value)
        self.idEditValue:SetFocus()
      end

      --for whatever is expecting a return value
      return ret
    end

    --open editor with whatever is selected
    self.idList.OnRButtonDoubleClick = function()
      if self.sel then
        ChoGGi.Funcs.OpenInObjectManipulator(self.sel.object,self)
      end
    end

    --close without doing anything
    function self.idClose.OnButtonPressed()
      self:delete()
    end

    --refresh the list...
    function self.idRefresh.OnButtonPressed()
      self:UpdateListContent(self.obj)
    end
    --move viewpoint to obj
    function self.idGoto.OnButtonPressed()
      self:ViewObject(self.obj)
    end
    --open dialog to get new name
    function self.idAddNew.OnButtonPressed()
      local ItemList = {
        {text = "New Entry",value = "BLANK",hint = "Enter the name of the new entry to be added."},
        {text = "New Value",value = false,hint = "Set teh value of the new entry to be added."},
      }

      local CallBackFunc = function(choice)
        --add it to the actual object
        self.obj[tostring(choice[1].value)] = ChoGGi.Funcs.RetProperType(choice[2].value)
        --refresh list
        self:UpdateListContent(self.obj)
      end
      ChoGGi.Funcs.FireFuncAfterChoice(CallBackFunc,ItemList,"New Entry",nil,nil,nil,nil,nil,nil,4)
    end
    --idApplyAll
    function self.idApplyAll.OnButtonPressed()
      local value = self.sel.value
      if value then
        local objs = GetObjects({class=self.obj.class})
        for i = 1, #objs do
          objs[i][self.sel.text] = ChoGGi.Funcs.RetProperType(value)
        end
      end
    end

    --add check for auto-refresh
    local children = self.idAutoRefresh.children
    for i = 1, #children do
      if children[i].class == "Button" then
        local but = children[i]
        function but.OnButtonPressed()
          self.refreshing = self.idAutoRefresh:GetState()
          CreateRealTimeThread(function()
            while self.refreshing do
              self:UpdateListContent(self.obj)
              Sleep(1000)
            end
          end)
        end
      end
    end

  end --init

  --function ObjectManipulator:OnKbdKeyDown(char, virtual_key)
  function ObjectManipulator:OnKbdKeyDown(_, virtual_key)
    if virtual_key == const.vkEsc then
      if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
        self.idClose:Press()
      end
      self:SetFocus()
      return "break"
    elseif virtual_key == const.vkEnter then
      local origsel = self.idList.last_selected
      self:UpdateListContent(self.obj)
      self.idList:SetSelection(origsel, true)
      return "break"
    end
    return "continue"
  end

  function ObjectManipulator:UpdateListContent(obj)
    --check for scroll pos
    local scrollpos = self.idList.vscrollbar:GetPosition()
    --create prop list for list
    local list = self:CreatePropList(obj)
    if not list then
      local err = "Error opening" .. tostring(obj)
      self.idList:SetContent({{text=err,value=err}})
      return
    end
    --populate it
    self.idList:SetContent(list)
    --and scroll to saved pos
    self.idList.vscrollbar:SetPosition(scrollpos)
  end

  function ObjectManipulator:ViewObject(obj)
    ShowMe(obj)
    ClearShowMe()
    SelectObj(obj)
  end

  --override Listitem:OnCreate so we can have two columns (wonder if there's another way)
  function ObjectManipulator:OnCreate(item,list)
    local data_instance = item.ItemDataInstance or list:GetItemDataInstance()
    local view_name = item and item.ItemSubview or list:GetItemSubview()
    if data_instance ~= "" and view_name ~= "" then
      self.DesignerFile = data_instance
      self:SetDesignerFileView(view_name)
      if InDesigner(list) and #self.children == 0 then
        self:SetSize(point(25, 25))
      end
    else
      local text_item = StaticText:new(self)
      text_item:SetBackgroundColor(0)
      text_item:SetId("text")
      text_item:SetFontStyle(item.FontStyle or list:GetFontStyle(), item.FontStyle or list.font_scale)
      local item_spacing = list.item_spacing * list:GetWindowScale() / 100
      local width = Min(1280, list:GetSize():x() - 2 * item_spacing:x())
      local _, height = text_item:MeasureText(item.text or "", nil, nil, nil, width)
      height = Min(720, height)
      text_item:SetSize(point(width, height))
      --newly added
      local value_item = StaticText:new(self)
      value_item:SetBackgroundColor(0)
      value_item:SetId("value")
      value_item:SetFontStyle(item.FontStyle or list:GetFontStyle(), item.FontStyle or list.font_scale)
      --local item_spacing = list.item_spacing * list:GetWindowScale() / 100
      --local value_width = Min(1280, list:GetSize():x() - 2 * item_spacing:x())
      local _, value_height = value_item:MeasureText(item.text or "", nil, nil, nil, width)
      value_height = Min(720, value_height)
      value_item:SetSize(point(width, value_height))
      value_item:SetPos(point(width - 250, value_item:GetY()))
      --newly added
    end
    for i = 1, #self.children do
      local child = self.children[i]
      if item[child.id] and child:HasMember("SetText") then
        child:SetText(item[child.id])
      elseif item[child.id] and child:HasMember("SetImage") then
        child:SetImage(item[child.id])
      end
    end
    self:SetHint(item.rollover)
    if item.ZOrder then
      self:SetZOrder(item.ZOrder)
    end
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
      if next(s) == nil then
      --if #s == 0 then
        i = i + 1
      else
        i = tonumber(s)
      end
      touched[i + 1] = true
      return "<color 255 255 128>" .. self:CreateProp(e[i + 2]) .. "</color>"
    end)
    for i = 2, #e do
      if not touched[i] then
        format_text = format_text .. " <color 255 255 128>[" .. self:CreateProp(e[i]) .. "]</color>"
      end
    end
    return format_text
  end

  function ObjectManipulator:CreateProp(o)
    if type(o) == "function" then
      local debug_info = debug.getinfo(o, "Sn")
      return tostring(debug_info.name or debug_info.name_what or "unknown name") .. "@" .. debug_info.short_src .. "(" .. debug_info.linedefined .. ")"
    end

    if IsValid(o) then
      return o.class .. "@" .. self:CreateProp(o:GetPos())
    end

    if IsPoint(o) then
      local res = {
        o:x(),
        o:y(),
        o:z()
      }
      return "(" .. table.concat(res, ",") .. ")"
    end
    --if some value is fucked, this just lets us ignore whatever value is fucked.
    pcall(function()
      if type(o) == "table" and getmetatable(o) and getmetatable(o) == objlist then
        local res = {}
        for i = 1, Min(#o, 3) do
          res[#res+1] = {
            text = i,
            value = self:CreateProp(o[i])
          }
        end
        if #o > 3 then
          res[#res+1] = {text = "..."}
        end
        return "objlist" .. "{" .. table.concat(res, ", ") .. "}"
      end
    end)

    if type(o) == "thread" then
      return tostring(o)
    end

    if type(o) == "string" then
      return o
    end

    if type(o) == "table" then
      if IsT(o) then
        return "T{\"" .. _InternalTranslate(o) .. "\"}"
      else
        local text = ObjectClass(o) or tostring(o) .. "(len:" .. #o .. ")"
        return text
      end
    end

    return tostring(o)

  end

  function ObjectManipulator:CreatePropList(o)
    local res = {}
    local sort = {}
    local function tableinsert(k,v)
      --text colours
      local text
      if type(v) == "table" then
        if v.class then
          text = "<color 150 170 150>" .. self:CreateProp(k) .. "</color>"
        else
          text = "<color 150 170 250>" .. self:CreateProp(k) .. "</color>"
        end
      elseif type(v) == "function" then
        text = "<color 250 75 75>" .. self:CreateProp(k) .. "</color>"
      else
        text = self:CreateProp(k)
      end
      res[#res+1] = {
        sort = self:CreateProp(k),
        text = text,
        value = self:CreateProp(v),
        object = v
      }
    end

    if type(o) == "table" and getmetatable(o) ~= g_traceMeta then
      for k, v in pairs(o) do
        tableinsert(k,v,res)
        if type(k) == "number" then
          sort[res[#res]] = k
        end
      end
    else
      if type(o) == "thread" then
        local info, level, _ = true, 0, nil
        while true do
          info = debug.getinfo(o, level, "Slfun")
          if info then
            res[#res+1] = {text = info.short_src .. "(" .. info.currentline .. ") " .. (info.name or info.name_what or "unknown name")}
            level = level + 1
            else
              if type(o) == "function" then
                local i = 1
                while true do
                  local k, v = debug.getupvalue(o, i)
                  if k ~= nil then
                    tableinsert(k,v,res)
                    i = i + 1
                    elseif type(o) ~= "table" or getmetatable(o) ~= g_traceMeta then
                      tableinsert(k,v,res)
                    end
                  end
                end
            end
          end
        end
    end

    table.sort(res, function(a, b)
      if sort[a.sort] and sort[b.sort] then
        return sort[a.sort] < sort[b.sort]
      end
      if sort[a.sort] or sort[b.sort] then
        return sort[a.sort] and true
      end
      return CmpLower(a.sort, b.sort)
    end)

    if type(o) == "table" and getmetatable(o) == g_traceMeta and getmetatable(o) == g_traceMeta then
      local items = 1
      for i = 1, #o do
        if not (items >= self.page * 150) then
          local format_text, e = self:filtersmarttable(o[i])
          if format_text then
            items = items + 1
            if items >= (self.page - 1) * 150 then
              local t = self:evalsmarttable(format_text, e)
              if t then
                if self.show_times ~= "relative" then
                  t = "<color 255 255 0>" .. tostring(e[1]) .. "</color>:" .. t
                else
                  t = "<color 255 255 0>" .. tostring(e[1] - GameTime()) .. "</color>:" .. t
                end
                res[#res+1] = {text =  t .. "<vspace 8>"}
              end
            end
          end
        end
      end
    end

    return res
    --return Untranslated(table.concat(res, "\n"))
  end



end --ClassesGenerate

function ChoGGi.MsgFuncs.ObjectManipulator_ClassesBuilt()
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
          HSizing = "Resize",
          VSizing = "Resize",
          PosOrg = point(250, 101),
          SizeOrg = point(390, 22),
        },
        {
          Id = "idClose",
          Class = "Button",
          CloseDialog = true,
          --FontStyle = "Editor14Bold",
          Image = "CommonAssets/UI/Controls/Button/Close.tga",
          Hint = "Closes dialog.",
          --ImageType = "aaaaa",
          HSizing = "AnchorToRight",
          Subview = "default",
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
          Hint = "Auto-refresh list every second (turn off to edit values).",
          Subview = "default",
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
          Hint = "Refresh list.",
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
          PosOrg = point(185, 150),
          SizeOrg = point(75, 26),
        },
        {
          Id = "idAddNew",
          Class = "Button",
          TextHAlign = "center",
          TextVAlign = "center",
          --FontStyle = "Editor14Bold",
          Subview = "default",
          Text = "Add",
          Hint = "Add new entry to ",
          PosOrg = point(265, 150),
          SizeOrg = point(60, 26),
        },
        {
          Id = "idApplyAll",
          Class = "Button",
          TextHAlign = "center",
          TextVAlign = "center",
          --FontStyle = "Editor14Bold",
          Subview = "default",
          Text = "Apply To All",
          Hint = "Apply selected value to all objects of the same type.",
          PosOrg = point(450, 150),
          SizeOrg = point(90, 26),
        },
        --list
        {
          Id = "idList",
          Class = "List",
          ShowPartialItems = true,
          FontStyle = "Editor14Bold",
          RolloverFontStyle = "Editor14",
          ScrollBar = true,
          ScrollAutohide = true,
          --SelectionColor = RGB(0, 0, 0),
          SelectionFontStyle = "Editor14Bold",
          SelectionBackground = RGB(100, 100, 100),
          BackgroundColor = RGB(50, 50, 50),
          Spacing = point(8, 2),
          Subview = "default",
          HSizing = "Resize",
          VSizing = "Resize",
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
          HSizing = "Resize",
          VSizing = "AnchorToBottom",
          PosOrg = point(106, 514),
          SizeOrg = point(640, 28),
        },

      }
    },
    views = PlaceObj("UIDesignerViews", nil, {
      PlaceObj("UIDesignerView", {"name", "Default"})
    })
  })

end --ClassesBuilt
