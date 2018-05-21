local CreateGameTimeThread = CreateGameTimeThread
function ChoGGi.MsgFuncs.uiMultiLineEdit_ClassesGenerate()
  DefineClass.ChoGGi_uiMultiLineEdit = {
    __parents = {
      "BaseTextControl",
      "BindableControl"
    },
    text = "",
    display_text = "",
    font_style = "Editor12",
    text_color = RGB(255, 255, 255),
    selection_back_color = RGB(255, 255, 255),
    selection_text_color = RGB(0, 0, 0),
    auto_select_all = false,
    cursor_blink_time = 400,
    background_color = RGBA(0, 0, 0, 128),
    text_valign = "top",
    text_halign = "left",
    cursor_pos = 0,
    cursor_prev_pos = 0,
    ctrlZ_cmd_table = false,
    left_scroll_x = 0,
    right_scroll_x = 0,
    selected_mode = false,
    blink_cursor_thread = false,
    stop_blink = false,
    show_cursor = false,
    Filter = ".",
    NegFilter = "",
    AllowPaste = true,
    DisplacementPos = false,
    DisplacementWidth = 0,
    IsKoreanIme = false,
    Ime = true,
    OnValueChanged = function(self, value)
    end,
    OnCursorPosChange = function()
    end,


    auto_height = true,
    SingleLine = false,
  }
  ChoGGi_uiMultiLineEdit.properties = {
    {
      category = "Layout",
      id = "AutoHeight",
      editor = "bool",
      default = ChoGGi_uiMultiLineEdit.auto_height
    },
    {
      category = "General",
      id = "Text",
      editor = "text",
      default = ChoGGi_uiMultiLineEdit.text,
      help = "Text to display/edit"
    },
    {
      category = "General",
      id = "Filter",
      editor = "text",
      default = ChoGGi_uiMultiLineEdit.Filter,
      help = "Lua string pattern for allowed characters"
    },
    {
      category = "General",
      id = "NegFilter",
      editor = "text",
      default = ChoGGi_uiMultiLineEdit.Filter,
      help = "A string containing the forbidden characters"
    },
    {
      category = "General",
      id = "ReplaceCharsWith",
      editor = "text",
      default = false,
      help = "A string containing the characters which will be displayed instead of each character of the real text"
    },
    {
      category = "General",
      id = "AutoSelectAll",
      editor = "bool",
      default = ChoGGi_uiMultiLineEdit.auto_select_all,
      help = "If true, the control switches to 'all text selected' mode when focused"
    },
    {
      category = "General",
      id = "AllowPaste",
      editor = "bool",
      default = true,
      help = "Allow copy/paste operations"
    },
    {
      category = "General",
      id = "Ime",
      editor = "bool",
      default = true,
      help = "Activate Ime support for CKJ languages when the control reseives focus."
    },
    {
      category = "Layout",
      id = "TextVAlign",
      editor = "combo",
      default = ChoGGi_uiMultiLineEdit.text_valign,
      items = {
        "top",
        "center",
        "bottom"
      },
      help = "Text vertical align to control"
    },
    {
      category = "Layout",
      id = "TextHAlign",
      editor = "combo",
      default = ChoGGi_uiMultiLineEdit.text_halign,
      items = {"left", "right"},
      help = "Text horizontal alignment"
    },
    {
      category = "Visuals",
      id = "FontStyle",
      editor = "combo",
      default = ChoGGi_uiMultiLineEdit.font_style,
      items = GetFontStyles,
      help = "Font used to draw the text"
    },
    {
      category = "Visuals",
      id = "TextColor",
      editor = "alphacolor",
      default = ChoGGi_uiMultiLineEdit.text_color,
      help = "Color used to draw text"
    },
    {
      category = "Visuals",
      id = "BackgroundColor",
      editor = "alphacolor",
      default = ChoGGi_uiMultiLineEdit.background_color
    },
    {
      category = "Visuals",
      id = "SelectionBackColor",
      editor = "alphacolor",
      default = ChoGGi_uiMultiLineEdit.selection_back_color,
      help = "Color used to draw selection background"
    },
    {
      category = "Visuals",
      id = "SelectionTextColor",
      editor = "alphacolor",
      default = ChoGGi_uiMultiLineEdit.selection_text_color,
      help = "Color used to draw selection text"
    }
  }
  local push_right = function(self, x)
    if type(x) ~= "table" then
      return false
    end
    if self:length() >= self.limit then
      local _ = self:_pop_left()
    end
    self.tail = self.tail + 1
    self[self.tail] = x
  end
  local _push_left = function(self, x)
    if type(x) ~= "table" then
      return false
    end
    self[self.head] = x
    self.head = self.head - 1
  end
  local peek_right = function(self, x)
    if self:is_empty() then
      return false
    end
    return self[self.tail]
  end
  local pop_right = function(self)
    if self:is_empty() then
      return false
    end
    local cmd = self[self.tail]
    self[self.tail] = nil
    self.tail = self.tail - 1
    return cmd
  end
  local _pop_left = function(self)
    if self:is_empty() then
      return false
    end
    local cmd = self[self.head]
    self[self.head] = nil
    self.head = self.head + 1
    return cmd
  end
  local length = function(self)
    return self.tail - self.head
  end
  local is_empty = function(self)
    return self:length() == 0
  end
  local deque_methods = {
    push_right = push_right,
    _push_left = _push_left,
    peek_right = peek_right,
    pop_right = pop_right,
    _pop_left = _pop_left,
    length = length,
    is_empty = is_empty
  }
  function ChoGGi_uiMultiLineEdit:Init()
    self.ctrlZ_cmd_table = {
      head = 0,
      tail = 0,
      limit = 15,
      is_new_cmd = false
    }
    setmetatable(self.ctrlZ_cmd_table, {__index = deque_methods})
  end
  function ChoGGi_uiMultiLineEdit:Done()
    if self.Ime then
      HideIme()
    end
  end
  ChoGGi_uiMultiLineEdit.vkConsume = {}
  local AddConsumeConst = function(string)
    if rawget(const, string) then
      ChoGGi_uiMultiLineEdit.vkConsume[const[string]] = true
    end
  end
  for i = string.byte("A"), string.byte("Z") do
    AddConsumeConst("vk" .. string.char(i))
  end
  for i = string.byte("0"), string.byte("9") do
    AddConsumeConst("vk" .. string.char(i))
  end
  AddConsumeConst("vkBackspace")
  AddConsumeConst("vkSpace")
  AddConsumeConst("vkMinus")
  AddConsumeConst("vkPlus")
  AddConsumeConst("vkOpensq")
  AddConsumeConst("vkClosesq")
  AddConsumeConst("vkSemicolon")
  AddConsumeConst("vkTilde")
  AddConsumeConst("vkQuote")
  AddConsumeConst("vkComma")
  AddConsumeConst("vkDot")
  AddConsumeConst("vkSlash")
  AddConsumeConst("vkBackslash")
  AddConsumeConst("vkLeft")
  AddConsumeConst("vkRight")
  AddConsumeConst("vkDelete")
  AddConsumeConst("vkHome")
  AddConsumeConst("vkEnd")
  AddConsumeConst("vkProcesskey")
  function ChoGGi_uiMultiLineEdit:GetFilter()
    return self.Filter
  end
  function ChoGGi_uiMultiLineEdit:SetFilter(filter)
    self.Filter = filter
  end
  function ChoGGi_uiMultiLineEdit:GetNegFilter()
    return self.NegFilter
  end
  function ChoGGi_uiMultiLineEdit:SetNegFilter(filter)
    self.NegFilter = filter
  end
  function ChoGGi_uiMultiLineEdit:SetTextVAlign(align)
    self.text_valign = align
  end
  function ChoGGi_uiMultiLineEdit:GetTextVAlign()
    return self.text_valign
  end
  function ChoGGi_uiMultiLineEdit:SetTextHAlign(align)
    self.text_halign = align
  end
  function ChoGGi_uiMultiLineEdit:GetTextHAlign()
    return self.text_halign
  end
  function ChoGGi_uiMultiLineEdit:SetText(text, no_update)
    local changed = self.text ~= text
    local fill = self.text == ""
    local empty = text == ""
    self.text = text
    self.display_text = self.ReplaceCharsWith and string.rep(self.ReplaceCharsWith, utf8.len(self.text)) or self.text
    if not no_update then
      if self.selected_mode then
        self:SetCursorPos(utf8.len(text), true)
      else
        self:SetCursorPos(0, true)
      end
      self:Invalidate()
    end
    if changed then
      self:OnValueChanged(self.text, fill, empty)
    end
  end
  function ChoGGi_uiMultiLineEdit:GetText()
    return self.text
  end
  function ChoGGi_uiMultiLineEdit:SetTextColor(clr)
    self.text_color = clr
    self:Invalidate()
  end
  function ChoGGi_uiMultiLineEdit:GetTextColor()
    return self.text_color
  end
  function ChoGGi_uiMultiLineEdit:SetBackgroundColor(color)
    self.background_color = color
    self:Invalidate()
  end
  function ChoGGi_uiMultiLineEdit:GetBackgroundColor()
    return self.background_color
  end
  function ChoGGi_uiMultiLineEdit:SetAllowPaste(b)
    self.AllowPaste = b
  end
  function ChoGGi_uiMultiLineEdit:GetAllowPaste()
    return self.AllowPaste
  end
  function ChoGGi_uiMultiLineEdit:SetIme(b)
    self.Ime = b
  end
  function ChoGGi_uiMultiLineEdit:GetIme()
    return self.Ime
  end
  function ChoGGi_uiMultiLineEdit:SetSelectionBackColor(clr)
    self.selection_back_color = clr
    self:Invalidate()
  end
  function ChoGGi_uiMultiLineEdit:GetSelectionBackColor()
    return self.selection_back_color
  end
  function ChoGGi_uiMultiLineEdit:SetSelectionTextColor(clr)
    self.selection_text_color = clr
    self:Invalidate()
  end
  function ChoGGi_uiMultiLineEdit:GetSelectionTextColor()
    return self.selection_text_color
  end
  function ChoGGi_uiMultiLineEdit:SetAutoSelectAll(enabled)
    self.auto_select_all = enabled
  end
  function ChoGGi_uiMultiLineEdit:GetAutoSelectAll()
    return self.auto_select_all
  end
  function ChoGGi_uiMultiLineEdit:SetEnabled(b)
    if self.enabled == b then
      return
    end
    Window.SetEnabled(self, b)
    if b then
      self.cursor_pos = 0
    end
  end
  function ChoGGi_uiMultiLineEdit:SetCursorPos(new_pos, invalidate)
    self.cursor_pos = new_pos
    local cursor_x_pos = self:GetCursorXPos()
    local text_height = self:GetFontHeight()
    local old_left_scroll_x = self.left_scroll_x
    local old_right_scroll_x = self.right_scroll_x
    if self.text_halign == "left" then
      if cursor_x_pos < self.left_scroll_x then
        self.left_scroll_x = Max(cursor_x_pos - self.box:sizex() / 2, 0)
      elseif cursor_x_pos >= self.left_scroll_x + self.box:sizex() then
        self.left_scroll_x = cursor_x_pos - self.box:sizex()
      end
      self.right_scroll_x = Max(self.right_scroll_x + (old_left_scroll_x - self.left_scroll_x), 0)
    else
      local text_width = UIL.MeasureText(self.display_text, self.font)
      self.left_scroll_x = Max(text_width - self.box:sizex() - self.right_scroll_x, 0)
      local length_diff = text_width - self.left_scroll_x - self.right_scroll_x - self.box:sizex()
      if (self.left_scroll_x > 0 or self.right_scroll_x > 0) and length_diff < 0 then
        self.right_scroll_x = Max(self.right_scroll_x + length_diff, 0)
        old_right_scroll_x = Max(old_right_scroll_x + length_diff, 0)
      end
      if cursor_x_pos < self.right_scroll_x then
        self.right_scroll_x = cursor_x_pos
      elseif cursor_x_pos >= self.right_scroll_x + self.box:sizex() then
        self.right_scroll_x = cursor_x_pos - self.box:sizex()
      end
      self.left_scroll_x = Max(self.left_scroll_x + (old_right_scroll_x - self.right_scroll_x), 0)
    end
    if invalidate then
      self:Invalidate()
    end
    if not self.selected_mode then
      self.cursor_prev_pos = new_pos
    end
    self:OnCursorPosChange(new_pos)
    self:UpdateImePos()
  end
  function ChoGGi_uiMultiLineEdit:GetYOffset(text_height)
    text_height = text_height or self:GetFontHeight()
    local yoffset = 0
    if self.text_valign == "center" then
      yoffset = (self.box:sizey() - text_height) / 2
    elseif self.text_valign == "bottom" then
      yoffset = self.box:sizey() - text_height
    end
    return yoffset
  end
  function ChoGGi_uiMultiLineEdit:UpdateImePos()
    if IsImeEnabled() then
      local cursor_x_pos = self:GetCursorXPos()
      local text_height = self:GetFontHeight()
      local yoffset = self:GetYOffset(text_height)
      SetImePosition(self.box:minx() + cursor_x_pos - self.left_scroll_x, self.box:miny() + yoffset, self.font)
      if self.IsKoreanIme then
        self:SetupKoreanImeInput()
      end
    end
  end
  function ChoGGi_uiMultiLineEdit:OnScaleChanged()
    BaseTextControl.OnScaleChanged(self)
    self:UpdateImePos()
  end
  function ChoGGi_uiMultiLineEdit:GetCursorPos()
    return self.cursor_pos
  end
  function ChoGGi_uiMultiLineEdit:PosFromChar(pos)
    local x1 = UIL.MeasureText(utf8.sub(self.display_text, 1, pos), self.font)
    local x2, height = UIL.MeasureText(utf8.sub(self.display_text, 1, pos + 1), self.font)
    local left, top = self.box:minx() - self.left_scroll_x, self.box:miny()
    local result_rect = box(left + x1, top, left + x2, top + height)
    return IntersectRects(self.box, result_rect)
  end
  function ChoGGi_uiMultiLineEdit:Replace(start_pos, end_pos, replace_with, invalidate)
    local new_text = utf8.sub(self.text, 1, start_pos) .. replace_with .. utf8.sub(self.text, end_pos + 1)
    self:SetText(new_text, true)
    if invalidate then
      self:Invalidate()
    end
  end
  function ChoGGi_uiMultiLineEdit:CorrectCursorPos()
    local text_len = utf8.len(self.display_text)
    if self.cursor_pos and text_len <= self.cursor_pos then
      self:SetCursorPos(text_len, true)
    end
  end
  function ChoGGi_uiMultiLineEdit:HideCursor()
    if self.blink_cursor_thread then
      DeleteThread(self.blink_cursor_thread)
      self.blink_cursor_thread = false
    end
    self.show_cursor = false
  end
  function ChoGGi_uiMultiLineEdit:ShowCursor(delay)
    self.show_cursor = true
    self:CreateCursorBlinkThread(delay)
  end
  function ChoGGi_uiMultiLineEdit:OnKbdIMEStartComposition(char, virtual_key, repeated, time, lang)
    if IsImeEnabled() and FullscreenMode() == 2 and AccountStorage and not AccountStorage.is_user_warned_about_ime_flicker then
      CreateMessageBox(T({1000620, "Warning"}), T({
        1000621,
        "Windows Input Method Editor may cause flickering when in Fullscreen."
      }))
      AccountStorage.is_user_warned_about_ime_flicker = true
    end
    self:HideCursor()
    if lang == "ko" then
      self.IsKoreanIme = true
      if self.selected_mode then
        self:OnKbdKeyDown(0, const.vkProcesskey)
      end
      self:SetupKoreanImeInput()
    end
  end
  function ChoGGi_uiMultiLineEdit:OnKbdIMEEndComposition()
    local delay = 0
    if self.IsKoreanIme then
      self.IsKoreanIme = false
      self.DisplacementPos = false
      self.DisplacementWidth = 0
      delay = 15
    end
    self:ShowCursor(delay)
  end
  function ChoGGi_uiMultiLineEdit:SetupKoreanImeInput()
    local x, y = GetImeWindowWidthHeight(self.font)
    local max_pos = utf8.len(self.display_text)
    if max_pos > self.cursor_pos then
      self.DisplacementPos = self.cursor_pos
      self.DisplacementWidth = x
      self:Invalidate()
    end
  end
  function ChoGGi_uiMultiLineEdit:OnShortcut(shortcut, source)
    return "break"
  end
  function ChoGGi_uiMultiLineEdit:OnKbdKeyDown(char, virtual_key)
    local result = "continue"
    if terminal.IsKeyPressed(const.vkShift) and virtual_key ~= const.vkShift and (virtual_key == const.vkLeft or virtual_key == const.vkRight or virtual_key == const.vkHome or virtual_key == const.vkEnd) and not self.selected_mode then
      self.selected_mode = true
      self.cursor_prev_pos = self.cursor_pos
      self.stop_blink = true
    end
    if virtual_key == const.vkLeft then
      if terminal.IsKeyPressed(const.vkControl) then
        local new_pos = 0
        local wstart, wend = string.find(self.display_text, "[%w_]+")
        while wstart ~= nil do
          if wstart < self.cursor_pos + 1 and wstart > new_pos + 1 then
            new_pos = wstart - 1
          end
          wstart, wend = string.find(self.display_text, "[%w_]+", wend + 1)
        end
        local pstart, pend = string.find(self.display_text, "%p+")
        while pstart ~= nil do
          if pstart < self.cursor_pos + 1 and pstart > new_pos + 1 then
            new_pos = pstart - 1
          end
          pstart, pend = string.find(self.display_text, "%p+", pend + 1)
        end
        self:SetCursorPos(new_pos, true)
      elseif self.selected_mode and not terminal.IsKeyPressed(const.vkShift) then
        self.selected_mode = false
        self.cursor_pos = Min(self.cursor_pos, self.cursor_prev_pos) + 1
      end
      if self.cursor_pos > 0 then
        self:SetCursorPos(self.cursor_pos - 1, true)
      end
      if self.selected_mode then
        return "break"
      end
      result = "break"
    elseif virtual_key == const.vkRight then
      if terminal.IsKeyPressed(const.vkControl) then
        local new_pos = utf8.len(self.display_text)
        local wstart, wend = string.find(self.display_text, "[%w_]+")
        while wstart ~= nil do
          if wstart > self.cursor_pos + 1 then
            new_pos = wstart - 1
            break
          end
          wstart, wend = string.find(self.display_text, "[%w_]+", wend + 1)
        end
        local pstart, pend = string.find(self.display_text, "%p+")
        while pstart ~= nil do
          if pstart > self.cursor_pos + 1 and pstart < new_pos + 1 then
            new_pos = pstart - 1
            break
          end
          pstart, pend = string.find(self.display_text, "%p+", pend + 1)
        end
        self:SetCursorPos(new_pos, true)
      else
        if self.selected_mode and not terminal.IsKeyPressed(const.vkShift) then
          self.selected_mode = false
          self.cursor_pos = Max(self.cursor_pos, self.cursor_prev_pos) - 1
        end
        if self.cursor_pos < utf8.len(self.display_text) then
          self:SetCursorPos(self.cursor_pos + 1, true)
        end
      end
      if self.selected_mode then
        return "break"
      end
      result = "break"
    elseif virtual_key == const.vkBackspace then
      local selection_max_pos = self.cursor_pos
      local selection_min_pos = self.cursor_pos - 1
      if self.selected_mode then
        selection_max_pos = Max(self.cursor_pos, self.cursor_prev_pos)
        selection_min_pos = Min(self.cursor_pos, self.cursor_prev_pos)
        self.ctrlZ_cmd_table.is_new_cmd = true
      else
        local cmd = self.ctrlZ_cmd_table:peek_right()
        if cmd and cmd.cmd_type == "RevBackspace" and not self.ctrlZ_cmd_table.is_new_cmd then
          cmd.selection_min_pos = selection_min_pos
          cmd.selection_max_pos = selection_min_pos
          cmd.text = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos) .. cmd.text
        elseif cmd and cmd.cmd_type ~= "RevBackspace" then
          self.ctrlZ_cmd_table.is_new_cmd = true
        end
      end
      if self.ctrlZ_cmd_table.is_new_cmd then
        self.ctrlZ_cmd_table:push_right({
          cursor_new_pos = selection_min_pos == self.cursor_pos and selection_min_pos or selection_min_pos + (selection_max_pos - selection_min_pos),
          selection_min_pos = selection_min_pos,
          selection_max_pos = selection_min_pos,
          text = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos),
          cmd = self.Replace,
          cmd_type = "RevBackspace"
        })
        self.ctrlZ_cmd_table.is_new_cmd = false
      end
      if selection_min_pos >= 0 then
        self:Replace(selection_min_pos, selection_max_pos, "")
        self:SetCursorPos(selection_min_pos, true)
      end
      self:CorrectCursorPos()
      result = "break"
    elseif virtual_key == const.vkDelete then
      local selection_max_pos = self.cursor_pos + 1
      local selection_min_pos = self.cursor_pos
      if self.selected_mode then
        selection_max_pos = Max(self.cursor_pos, self.cursor_prev_pos)
        selection_min_pos = Min(self.cursor_pos, self.cursor_prev_pos)
        self.ctrlZ_cmd_table.is_new_cmd = true
      else
        local cmd = self.ctrlZ_cmd_table:peek_right()
        if cmd and cmd.cmd_type == "RevDelete" and not self.ctrlZ_cmd_table.is_new_cmd then
          cmd.text = cmd.text .. utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos)
        elseif cmd and cmd.cmd_type ~= "RevDelete" then
          self.ctrlZ_cmd_table.is_new_cmd = true
        end
      end
      if self.ctrlZ_cmd_table.is_new_cmd then
        self.ctrlZ_cmd_table:push_right({
          cursor_new_pos = selection_min_pos == self.cursor_pos and selection_min_pos or selection_min_pos + (selection_max_pos - selection_min_pos),
          selection_min_pos = selection_min_pos,
          selection_max_pos = selection_min_pos,
          text = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos),
          cmd = self.Replace,
          cmd_type = "RevDelete"
        })
        self.ctrlZ_cmd_table.is_new_cmd = false
      end
      if 0 < utf8.len(self.display_text) then
        self:Replace(selection_min_pos, selection_max_pos, "")
        self:SetCursorPos(selection_min_pos, true)
      end
      result = "break"
    elseif virtual_key == const.vkHome then
      self:SetCursorPos(0, true)
      if self.selected_mode then
        return "break"
      end
      result = "break"
    elseif virtual_key == const.vkEnd then
      self:SetCursorPos(utf8.len(self.display_text), true)
      if self.selected_mode then
        return "break"
      end
      result = "break"
    elseif self.display_text ~= "" and virtual_key == const.vkC and (terminal.IsKeyPressed(const.vkControl) or Platform.osx and terminal.IsKeyPressed(const.vkLwin)) then
      if self.selected_mode then
        local selection_max_pos = Max(self.cursor_pos, self.cursor_prev_pos)
        local selection_min_pos = Min(self.cursor_pos, self.cursor_prev_pos)
        local NewClip_str = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos)
        CopyToClipboard(NewClip_str)
        return "break"
      end
      CopyToClipboard(self.display_text)
      result = "break"
    elseif virtual_key == const.vkV and (terminal.IsKeyPressed(const.vkControl) or Platform.osx and terminal.IsKeyPressed(const.vkLwin)) then
      --local clip = GetFromClipboard(0 > self.MaxLen and self.MaxLen or nil)
      local clip = GetFromClipboard()
      if clip and self.AllowPaste then
        if self.NegFilter and self.NegFilter ~= "" then
          clip = clip:gsub("[" .. self.NegFilter .. "]", "")
        end
        local txt_len = utf8.len(self.display_text)
        local clip_len = utf8.len(clip)
        local selection_max_pos = self.cursor_pos
        local selection_min_pos = self.cursor_pos
        local selected_text = false
        if self.selected_mode then
          selection_max_pos = Max(self.cursor_pos, self.cursor_prev_pos)
          selection_min_pos = Min(self.cursor_pos, self.cursor_prev_pos)
          selected_text = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos)
          txt_len = txt_len - utf8.len(selected_text)
        end
        --[[
        if 0 < self.MaxLen and txt_len + clip_len > self.MaxLen then
          if 0 < self.MaxLen - txt_len then
            clip = utf8.sub(clip, 1, self.MaxLen - txt_len)
            clip_len = utf8.len(clip)
          else
            return "break"
          end
        end
        --]]
        clip = utf8.sub(clip, 1, self.MaxLen - txt_len)
        clip_len = utf8.len(clip)

        self.ctrlZ_cmd_table:push_right({
          cursor_new_pos = selection_min_pos,
          selection_min_pos = selection_min_pos,
          selection_max_pos = selection_min_pos + clip_len,
          text = selected_text,
          cmd = self.Replace,
          cmd_type = "RevPaste"
        })
        self:Replace(selection_min_pos, selection_max_pos, clip)
        self:SetCursorPos(selection_min_pos + clip_len, true)
      end
      result = "break"
    elseif self.display_text ~= "" and virtual_key == const.vkX and (terminal.IsKeyPressed(const.vkControl) or Platform.osx and terminal.IsKeyPressed(const.vkLwin)) then
      if self.selected_mode then
        self.selected_mode = false
        local selection_max_pos = Max(self.cursor_pos, self.cursor_prev_pos)
        local selection_min_pos = Min(self.cursor_pos, self.cursor_prev_pos)
        local NewClip_str = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos)
        CopyToClipboard(NewClip_str)
        self.ctrlZ_cmd_table:push_right({
          cursor_new_pos = selection_min_pos == self.cursor_pos and selection_min_pos or selection_min_pos + (selection_max_pos - selection_min_pos),
          selection_min_pos = selection_min_pos,
          selection_max_pos = selection_min_pos,
          text = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos),
          cmd = self.Replace,
          cmd_type = "RevCut",
          selected_mode = true
        })
        self:Replace(selection_min_pos, selection_max_pos, "")
        self:SetCursorPos(selection_min_pos, true)
        return "break"
      end
      CopyToClipboard(self.display_text)
      result = "break"
    elseif virtual_key == const.vkZ and (terminal.IsKeyPressed(const.vkControl) or Platform.osx and terminal.IsKeyPressed(const.vkLwin)) then
      local ctrlZ_cmd = self.ctrlZ_cmd_table:pop_right()
      if ctrlZ_cmd and ctrlZ_cmd.cmd then
        local text = ctrlZ_cmd.text or ""
        ctrlZ_cmd.cmd(self, ctrlZ_cmd.selection_min_pos, ctrlZ_cmd.selection_max_pos, text)
        self:SetCursorPos(ctrlZ_cmd.cursor_new_pos, true)
        self.cursor_prev_pos = ctrlZ_cmd.selection_max_pos
      end
      result = "break"
    elseif virtual_key == const.vkA and (terminal.IsKeyPressed(const.vkControl) or Platform.osx and terminal.IsKeyPressed(const.vkLwin)) then
      self:SelectAll()
      return "break"
    elseif virtual_key == const.vkTab then
      if self:IsTabActivator() then
        if terminal.IsKeyPressed(const.vkShift) then
          self:PrevEditControl()
        else
          self:NextEditControl()
        end
        return "break"
      end
    elseif virtual_key == const.vkEsc then
    end
    if result == "break" then
      self.selected_mode = false
      self.stop_blink = true
    end
    if ChoGGi_uiMultiLineEdit.vkConsume[virtual_key] and not terminal.IsKeyPressed(const.vkControl) and not terminal.IsKeyPressed(const.vkAlt) then
      if virtual_key ~= const.vkLeft and virtual_key ~= const.vkRight and virtual_key ~= const.vkBackspace and virtual_key ~= const.vkDelete then
        local selection_max_pos = self.cursor_pos + 1
        local selection_min_pos = self.cursor_pos
        local cmd = self.ctrlZ_cmd_table:peek_right()
        if self.selected_mode then
          local selection_max_pos = Max(self.cursor_pos, self.cursor_prev_pos)
          local selection_min_pos = Min(self.cursor_pos, self.cursor_prev_pos)
          self.ctrlZ_cmd_table:push_right({
            cursor_new_pos = selection_min_pos,
            selection_min_pos = selection_min_pos,
            selection_max_pos = selection_min_pos + 1,
            text = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos),
            cmd = self.Replace,
            cmd_type = "RevReplace"
          })
          self.ctrlZ_cmd_table.is_new_cmd = true
          self:Replace(selection_min_pos, selection_max_pos, "")
          self:SetCursorPos(selection_min_pos, true)
          self.selected_mode = false
        elseif cmd and cmd.cmd_type == "RevInsert" and not self.ctrlZ_cmd_table.is_new_cmd then
          cmd.selection_max_pos = cmd.selection_max_pos + 1
        else
          self.ctrlZ_cmd_table:push_right({
            cursor_new_pos = selection_min_pos,
            selection_min_pos = selection_min_pos,
            selection_max_pos = selection_max_pos,
            text = false,
            cmd = self.Replace,
            cmd_type = "RevInsert"
          })
          self.ctrlZ_cmd_table.is_new_cmd = false
        end
      end
      result = "break"
    end
    return result
  end
  local pass_key = {
    "vkEnter",
    "vkEsc",
    "vkTab",
    "vkLeft",
    "vkRight",
    "vkUp",
    "vkDown"
  }
  function ChoGGi_uiMultiLineEdit:OnKbdKeyUp(char, vkey)
    if ChoGGi_uiMultiLineEdit.vkConsume[vkey] then
      return "break"
    end
    for idx = 1, #pass_key do
      if vkey == const[pass_key[idx]] then
        return "continue"
      end
    end
    return "break"
  end
  function ChoGGi_uiMultiLineEdit:OnLButtonDoubleClick()
    if not self.enabled then
      return "break"
    end
    self:SelectAll()
    return "break"
  end
  function ChoGGi_uiMultiLineEdit:CharMatchFilters(char)
    return (not self.Filter or string.find(char, self.Filter)) and not string.find(self.NegFilter, char, 1, true)
  end
  function ChoGGi_uiMultiLineEdit:OnKbdChar(char, virtual_key)
    --if string.byte(char, 1) >= 32 and self:CharMatchFilters(char) and (self.MaxLen < 0 or utf8.len(self.display_text) < self.MaxLen) then
    if string.byte(char, 1) >= 32 and self:CharMatchFilters(char) then
      if self.selected_mode then
        self.selected_mode = false
        self:Replace(0, utf8.len(self.text), char)
        self:SetCursorPos(1, true)
      else
        self:Replace(self.cursor_pos, self.cursor_pos, char)
        self:SetCursorPos(self.cursor_pos + 1, true)
      end
      self:CorrectCursorPos()
      self.stop_blink = true
      return "break"
    end
    return "continue"
  end
  function ChoGGi_uiMultiLineEdit:OnLButtonDown(pt)
    if not self.enabled then
      return "break"
    end
    if self.desktop.keyboard_focus == self or not self.auto_select_all or self.selected_mode then
      self.selected_mode = false
      local window_x, window_size_x, ptx = self.box:minx(), self.box:sizex(), pt:x()
      local prev_char_x_pos = window_x
      local found
      local text_len = utf8.len(self.display_text)
      local loop_start, loop_end, loop_step = 1, text_len, 1
      local left_align = self.text_halign == "left" or self.left_scroll_x > 0 or 0 < self.right_scroll_x
      if not left_align then
        loop_start = text_len
        loop_end = 1
        loop_step = -1
      end
      for i = loop_start, loop_end, loop_step do
        local char_x_pos
        if left_align then
          char_x_pos = UIL.MeasureText(utf8.sub(self.display_text, 1, i), self.font) - self.left_scroll_x + window_x
        else
          char_x_pos = window_x + window_size_x - UIL.MeasureText(utf8.sub(self.display_text, i, text_len), self.font)
        end
        local found_condition
        if left_align then
          found_condition = ptx < char_x_pos
        else
          found_condition = ptx > char_x_pos
        end
        if found_condition then
          found = true
          if ptx < char_x_pos - (char_x_pos - prev_char_x_pos) / 2 then
            self:SetCursorPos(i - 1, true)
          else
            self:SetCursorPos(i, true)
          end
          self.stop_blink = true
          break
        end
        prev_char_x_pos = char_x_pos
      end
      if not found then
        self:SetCursorPos(left_align and text_len or 0, true)
        self.stop_blink = true
      end
    end
    self:SetFocus()
    return "break"
  end
  function ChoGGi_uiMultiLineEdit:SelectAll()
    self.selected_mode = true
    self.cursor_prev_pos = 0
    self:SetCursorPos(utf8.len(self.display_text), true)
    self:Invalidate()
  end
  function ChoGGi_uiMultiLineEdit:CreateCursorBlinkThread(delay)
    delay = delay or 0
    if not self.blink_cursor_thread then
      self.blink_cursor_thread = CreateGameTimeThread(function()
        while true do
          Sleep(delay)
          self.show_cursor = self.stop_blink or not self.show_cursor
          if not self.show_cursor and not self.ctrlZ_cmd_table.is_new_cmd then
            self.ctrlZ_cmd_table.is_new_cmd = true
          end
          self.stop_blink = false
          self:Invalidate()
          Sleep(self.cursor_blink_time)
        end
      end)
    end
  end
  function ChoGGi_uiMultiLineEdit:OnSetFocus()
    self.right_scroll_x = 0
    if self.auto_select_all then
      self:SelectAll()
    else
      self:SetCursorPos(self.cursor_pos, true)
    end
    if not hr.ImeCompositionStarted then
      self:CreateCursorBlinkThread()
    end
    ShowVirtualKeyboard(true)
    if self.Ime then
      ShowIme()
    end
    self:UpdateImePos()
  end
  function ChoGGi_uiMultiLineEdit:OnKillFocus()
    ShowVirtualKeyboard(false)
    self.selected_mode = false
    self.show_cursor = false
    self.right_scroll_x = self.right_scroll_x + self.left_scroll_x
    self.left_scroll_x = 0
    self:Invalidate()
    DeleteThread(self.blink_cursor_thread)
    self.blink_cursor_thread = false
    if self.Ime then
      HideIme()
    end
  end
  function ChoGGi_uiMultiLineEdit:Draw()
    if self.background_color ~= 0 then
      UIL.DrawSolidRect(self.box, self.background_color)
    end
    UIL.SetFont(self.font)
    local text_width, text_height = UIL.MeasureText(self.display_text, self.font)
    local yoffset = self:GetYOffset(text_height)
    local ChopText = function(text, pos)
      local t1 = utf8.sub(text, 1, pos)
      local t2 = utf8.sub(text, pos + 1, -1)
      local t1Len = UIL.MeasureText(t1)
      return t1, t2, t1Len
    end
    local DrawChoppedText = function(text, pos, chopPos, textColor)
      chopPos = chopPos or self.DisplacementPos
      textColor = textColor or self.text_color
      local t1, t2, offset, t2Len = ChopText(text, chopPos)
      offset = offset + self.DisplacementWidth
      UIL.DrawText(t1, pos, self.font, textColor)
      pos = pos:SetX(pos:x() + offset)
      UIL.DrawText(t2, pos, self.font, textColor)
    end
    local start_x = self.text_halign == "right" and self.right_scroll_x == 0 and self.box:maxx() - text_width or self.box:minx() - self.left_scroll_x
    if self.selected_mode then
      local selection_max_pos = Max(self.cursor_pos, self.cursor_prev_pos)
      local selection_min_pos = Min(self.cursor_pos, self.cursor_prev_pos)
      local selection_max_x = UIL.MeasureText(utf8.sub(self.display_text, 1, selection_max_pos), self.font)
      local selection_min_x = UIL.MeasureText(utf8.sub(self.display_text, 1, selection_min_pos), self.font)
      local left_unselected_text = utf8.sub(self.display_text, 1, selection_min_pos)
      local selected_text = utf8.sub(self.display_text, selection_min_pos + 1, selection_max_pos)
      local right_unselected_text = utf8.sub(self.display_text, selection_max_pos + 1, utf8.len(self.display_text))
      local disp = ""
      if self.DisplacementPos then
        if selection_min_pos >= self.DisplacementPos then
          selection_min_x = selection_min_x + self.DisplacementWidth
          selection_max_x = selection_max_x + self.DisplacementWidth
          disp = "left"
        elseif selection_max_pos >= self.DisplacementPos then
          selection_max_x = selection_max_x + self.DisplacementWidth
          disp = "selection"
        else
          disp = "right"
        end
      end
      UIL.DrawSolidRect(box(start_x + selection_min_x, self.box:miny() + yoffset, start_x + selection_max_x, self.box:miny() + text_height + yoffset), self.selection_back_color)
      if left_unselected_text ~= "" then
        if disp == "left" then
          DrawChoppedText(left_unselected_text, point(start_x, self.box:miny() + yoffset))
        else
          UIL.DrawText(left_unselected_text, point(start_x, self.box:miny() + yoffset), self.font, self.text_color)
        end
      end
      if disp == "selection" then
        DrawChoppedText(selected_text, point(start_x + selection_min_x, self.box:miny() + yoffset), self.DisplacementPos - selection_min_pos, self.selection_text_color)
      else
        UIL.DrawText(selected_text, point(start_x + selection_min_x, self.box:miny() + yoffset), self.font, self.selection_text_color)
      end
      if right_unselected_text ~= "" then
        if disp == "right" then
          DrawChoppedText(right_unselected_text, point(start_x + selection_max_x, self.box:miny() + yoffset), self.DisplacementPos - selection_max_pos)
        else
          UIL.DrawText(right_unselected_text, point(start_x + selection_max_x, self.box:miny() + yoffset), self.font, self.text_color)
        end
      end
    elseif self.DisplacementPos then
      DrawChoppedText(self.display_text, point(start_x, self.box:miny() + yoffset))
    else
      UIL.DrawText(self.display_text, point(start_x, self.box:miny() + yoffset), self.font, self.text_color)
    end
    if self.show_cursor then
      local cursor_x_pos = self:GetCursorXPos()
      if self.text_halign == "right" then
        if cursor_x_pos == 0 then
          cursor_x_pos = 1 or cursor_x_pos
        end
        UIL.DrawSolidRect(box(self.box:maxx() - cursor_x_pos + self.right_scroll_x, self.box:miny() + yoffset, self.box:maxx() - cursor_x_pos + self.right_scroll_x + 1, self.box:miny() + text_height + yoffset), self.text_color)
      else
        UIL.DrawSolidRect(box(self.box:minx() + cursor_x_pos - self.left_scroll_x, self.box:miny() + yoffset, self.box:minx() + cursor_x_pos - self.left_scroll_x + 1, self.box:miny() + text_height + yoffset), self.text_color)
      end
    end
  end
  function ChoGGi_uiMultiLineEdit:GetCursorXPos()
    local cursor_x_pos = 0
    if self.text_halign == "right" then
      local text_len = utf8.len(self.display_text)
      if text_len > self.cursor_pos then
        cursor_x_pos = UIL.MeasureText(utf8.sub(self.display_text, self.cursor_pos + 1, text_len), self.font)
      end
    elseif 0 < self.cursor_pos then
      cursor_x_pos = UIL.MeasureText(utf8.sub(self.display_text, 1, self.cursor_pos), self.font)
    end
    if self.DisplacementPos and self.DisplacementPos < self.cursor_pos - 1 then
      cursor_x_pos = self.text_halign == "left" and cursor_x_pos + self.DisplacementWidth or cursor_x_pos - self.DisplacementWidth
    end
    return cursor_x_pos
  end
  function ChoGGi_uiMultiLineEdit:IsTabActivated()
    return true, self
  end
  function ChoGGi_uiMultiLineEdit:SetValue(text)
    self:SetText(text)
  end
  function ChoGGi_uiMultiLineEdit:GetValue(text)
    return self:GetText()
  end
  function ChoGGi_uiMultiLineEdit:Bind(obj, prop_meta)
    BindableControl.Bind(self, obj, prop_meta)
  end

end
