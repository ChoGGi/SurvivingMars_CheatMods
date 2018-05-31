--Haemimont Games code (mostly)

DefineClass.Examine = {
  __parents = {
    "ExamineDesigner"
  },
  ZOrder = 9
}
markers = rawget(_G, "markers") or {}
transp_mode = rawget(_G, "transp_mode") or false
local HLEnd = "</h></color>"
function Examine:Init()

  local ChoGGi = ChoGGi

  self.onclick_handles = {}
  self.obj = false
  self.show_times = "relative"
  self.offset = 1
  self.page = 1
  self.transp_mode = transp_mode
  function self.idText.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end
  self.idText:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idMenu.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end
  self.idMenu:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idNext.OnButtonPressed()
    self:FindNext(self.idFilter:GetText())
  end
  self.idFilter:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idFilter.OnValueChanged(this, value)
    self:FindNext(value)
  end
  --[[
  re-added below
  function self.idFilter.OnKbdKeyDown(_, char, virtual_key)
    if virtual_key == const.vkEnter then
      self:FindNext(self.idFilter:GetText())
      return "break"
    end
    StaticText.OnKbdKeyDown(self, char, virtual_key)
  end
  --]]

  function self.idClose.OnButtonPressed()
    self:delete()
  end
  self:SetTranspMode(self.transp_mode)

  --added:
  function self.idDump.OnButtonPressed()
    local String = self:totextex(self.obj)
    --remove html tags
    String = String:gsub("<[/%s%a%d]*>","")
    ChoGGi.ComFuncs.Dump("\r\n" .. String,nil,"DumpedExamine","lua")
  end
  function self.idDumpObj.OnButtonPressed()
    ChoGGi.ComFuncs.Dump("\r\n" .. ValueToLuaCode(self.obj),nil,"DumpedExamineObject","lua")
  end

  function self.idAttaches.OnButtonPressed()
    local attaches = type(self.obj) == "table" and type(self.obj.GetAttaches) == "function" and self.obj:GetAttaches()

    if attaches and #attaches > 0 then
      ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(self.obj:GetAttaches(),self)
    else
      print("Zero attachments means zero...")
    end
  end

  function self.idEdit.OnButtonPressed()
    ChoGGi.ComFuncs.OpenInObjectManipulator(self.obj,self)
  end
  function self.idCodeExec.OnButtonPressed()
    ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj,self)
  end

  --improve text handling
  function self.idFilter.OnKbdKeyDown(_, char, vk)
    local text = self.idFilter
    if vk == const.vkEnter then
      self:FindNext(text:GetText())
      return "break"
    elseif vk == const.vkBackspace or vk == const.vkDelete then
      local selection_min_pos = text.cursor_pos - 1
      local selection_max_pos = text.cursor_pos
      if vk == const.vkDelete then
        selection_min_pos = text.cursor_pos
        selection_max_pos = text.cursor_pos + 1
      end
      text:Replace(selection_min_pos, selection_max_pos, "")
      text:SetCursorPos(selection_min_pos, true)
      return "break"
    elseif vk == const.vkRight then
      text:SetCursorPos(text.cursor_pos + 1, true)
      return "break"
    elseif vk == const.vkLeft then
      text:SetCursorPos(text.cursor_pos + -1, true)
      return "break"
    elseif vk == const.vkHome then
      text:SetCursorPos(0, true)
      return "break"
    elseif vk == const.vkEnd then
      text:SetCursorPos(#text.display_text, true)
      return "break"
    elseif vk == const.vkEsc then
      if terminal.IsKeyPressed(const.vkControl) or terminal.IsKeyPressed(const.vkShift) then
        self.idClose:Press()
      end
      self:SetFocus()
      return "break"
    end
    StaticText.OnKbdKeyDown(self, char, vk)
  end

end
function Examine:FindNext(filter)
  local drawBuffer = self.idText.draw_cache
  local current_y = -self.idText.text_offset:y()
  local min_match, closest_match = false, false
  for y, list_draw_info in pairs(drawBuffer) do
    for i = 1, #list_draw_info do
      local draw_info = list_draw_info[i]
      if draw_info.text and string.find(draw_info.text, filter, 1, true) then
        if not min_match or y < min_match then
          min_match = y
        end
        if y > current_y and (not closest_match or y < closest_match) then
          closest_match = y
        end
      end
    end
  end
  if min_match or closest_match then
    self.idText:SetTextOffset(point(0, -(closest_match or min_match)))
  end
end
function Examine:SetTranspMode(transp_mode)
  self.idText.scroll:ClearModifiers()
  self:ClearModifiers()
  if transp_mode then
    self.idText.scroll:AddInterpolation({
      type = const.intAlpha,
      startValue = 64,
      flags = const.intfIgnoreParent
    })
    self:AddInterpolation({
      type = const.intAlpha,
      startValue = 32
    })
  end
end
function Examine:ToString(o)
  return tostring(o)
end
function Examine:valuetotextex(o)
  local Examine = function(_, _, button)
    if button == "left" then
      OpenExamine(o, self)
    elseif IsValid(o) then
      ShowMe(o)
    end
  end
  local ShowPoint = function()
    ShowMe(o)
  end
  if type(o) == "function" then
    local debug_info = debug.getinfo(o, "Sn")
    return self:HyperLink(Examine) .. self:ToString(debug_info.name or debug_info.name_what or "unknown name") .. "@" .. debug_info.short_src .. "(" .. debug_info.linedefined .. ")" .. HLEnd
  end
  if IsValid(o) then
    return self:HyperLink(Examine) .. o.class .. HLEnd .. "@" .. self:valuetotextex(o:GetPos())
  end
  if IsPoint(o) then
    local res = {
      o:x(),
      o:y(),
      o:z()
    }
    return self:HyperLink(ShowPoint) .. "(" .. table.concat(res, ",") .. ")" .. HLEnd
  end
  if type(o) == "table" and getmetatable(o) and getmetatable(o) == objlist then
    local res = {}
    for i = 1, Min(#o, 3) do
      table.insert(res, i .. " = " .. self:valuetotextex(o[i]))
    end
    if #o > 3 then
      table.insert(res, "...")
    end
    return self:HyperLink(Examine) .. "objlist" .. HLEnd .. "{" .. table.concat(res, ", ") .. "}"
  end
  if type(o) == "thread" then
    return self:HyperLink(Examine) .. self:ToString(o) .. HLEnd
  end
  if type(o) == "string" then
    return "<tags off>'" .. o .. "'<tags on>"
  end
  if type(o) == "table" then
    if IsT(o) then
      return self:HyperLink(Examine) .. "T{\"" .. TDevModeGetEnglishText(o, true) .. "\"}" .. HLEnd
    else
      local text = ObjectClass(o) or self:ToString(o) .. "(len:" .. #o .. ")"
      return self:HyperLink(Examine) .. text .. HLEnd
    end
  end
  return self:ToString(o)
end
function Examine:HyperLink(f, custom_color)
  table.insert(self.onclick_handles, f)
  return (custom_color or "<color 150 170 250>") .. "<h " .. #self.onclick_handles .. " 230 195 50>"
end
local filters = {
  Short = {
    "StateObject1"
  },
  TraceCall = {"Call"},
  Long = {
    "StateObject1",
    "StateObject2"
  },
  General = {false}
}
function Examine:filtersmarttable(e)
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
function Examine:evalsmarttable(format_text, e)
  local touched = {}
  local i = 0
  format_text = string.gsub(format_text, "{(%d-)}", function(s)
    if #s == 0 then
      i = i + 1
    else
      i = tonumber(s)
    end
    touched[i + 1] = true
    return "<color 255 255 128>" .. self:valuetotextex(e[i + 2]) .. "</color>"
  end)
  for i = 2, #e do
    if not touched[i] then
      format_text = format_text .. " <color 255 255 128>[" .. self:valuetotextex(e[i]) .. "]</color>"
    end
  end
  return format_text
end
function Examine:totextex(o)
  local ExamineThreadLevel = function(level, info)
    local data = {}
    local l = 1
    while true do
      local name, val = debug.getlocal(o, level, l)
      if name then
        data[name] = val
        l = l + 1
      end
    end
    for i = 1, info.nups do
      local name, val = debug.getupvalue(info.func, i)
      if name ~= nil and val ~= nil then
        data[name .. "(up)"] = val
      end
    end
    return function()
      local ex = Examine:new()
      ex:SetObj(data)
    end
  end
  local Examine = function(o)
    return function()
      OpenExamine(o, self)
    end
  end
  local res = {}
  local sort = {}
  if type(o) == "table" and getmetatable(o) ~= g_traceMeta then
    for k, v in pairs(o) do
      table.insert(res, self:valuetotextex(k) .. " = " .. self:valuetotextex(v))
      if type(k) == "number" then
        sort[res[#res]] = k
      end
    end
  else
    if type(o) == "thread" then
      local info, level, s = true, 0, nil
      while true do
        info = debug.getinfo(o, level, "Slfun")
        if info then
          table.insert(res, self:HyperLink(ExamineThreadLevel(level, info)) .. info.short_src .. "(" .. info.currentline .. ") " .. (info.name or info.name_what or "unknown name") .. HLEnd)
          level = level + 1
          else
            if type(o) == "function" then
              local i = 1
              while true do
                local k, v = debug.getupvalue(o, i)
                if k ~= nil then
                  table.insert(res, self:valuetotextex(k) .. " = " .. self:valuetotextex(v))
                  i = i + 1
                  elseif type(o) ~= "table" or getmetatable(o) ~= g_traceMeta then
                    table.insert(res, self:valuetotextex(o))
                  end
                end
              end
          end
        end
      end
  end
  table.sort(res, function(a, b)
    if sort[a] and sort[b] then
      return sort[a] < sort[b]
    end
    if sort[a] or sort[b] then
      return sort[a] and true
    end
    return CmpLower(a, b)
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
              table.insert(res, t .. "<vspace 8>")
            end
          end
        end
      end
    end
  end
  if IsValid(o) and IsKindOf(o, "CObject") then
    table.insert(res, 1, "<center>--" .. self:HyperLink(Examine(getmetatable(o))) .. o.class .. HLEnd .. "@" .. self:valuetotextex(o:GetPos()) .. "--<vspace 6>")
    if o:IsValidPos() and IsValidEntity(o:GetEntity()) and 0 < o:GetAnimDuration() then
      local pos = o:GetVisualPos() + o:GetStepVector() * o:TimeToAnimEnd() / o:GetAnimDuration()
      table.insert(res, 2, "<center>" .. GetStateName(o:GetState()) .. ", step:" .. self:HyperLink(function()
        ShowMe(pos)
      end) .. tostring(o:GetStepVector(o:GetState(), 0)) .. HLEnd)
    else
    end
  elseif type(o) == "table" and getmetatable(o) then
    if getmetatable(o) == g_traceMeta then
      table.insert(res, 1, "<center>--Trace Log--<vspace 6>")
      if self.show_times == "relative" then
        table.insert(res, 1, "<center>-- relative times --<vspace 6>")
      end
    else
      table.insert(res, 1, "<center>--metatable: " .. self:valuetotextex(getmetatable(o)) .. "--<vspace 6><left>")
    end
  end
  return Untranslated(table.concat(res, "\n"))
end
function Examine:menu(o)
  local res = {}
  local Show = function()
    if IsValid(o) then
      ShowMe(o)
    else
      for k, v in pairs(o) do
        if IsPoint(k) or IsValid(k) then
          ShowMe(k)
        end
        if IsPoint(v) or IsValid(v) then
          ShowMe(v)
        end
      end
    end
  end
  local ShowLog = function()
    OpenExamine(o.trace_log, self)
  end
  local Destroy = function()
    if IsValid(o) then
      DoneObject(o)
    end
  end
  local Assign = function(name)
    return function(_, _, button)
      if button == "left" then
        rawset(_G, name, o)
        self.idMenu:SetText(self:menu(o))
      elseif button == "right" then
        ShowMe(rawget(_G, name), RGB(0, 0, 255))
        OpenExamine(rawget(_G, name), self)
      end
    end
  end
  local ShowTime = function()
    if self.show_times then
      if self.show_times == "relative" then
        self.show_times = "absolute"
      else
        self.show_times = false
      end
    else
      self.show_times = "relative"
    end
    if self.obj then
      self:SetObj(self.obj)
    end
  end
  if IsValid(o) and type(o) == "table" then
    table.insert(res, self:HyperLink(Show) .. "[ShowIt]" .. HLEnd)
  end
  table.insert(res, self:HyperLink(ClearShowMe) .. "[Clear Markers]" .. HLEnd)
  if IsValid(o) then
    table.insert(res, self:HyperLink(Destroy) .. "[Destroy It!]" .. HLEnd)
    if o:HasMember("trace_log") then
      table.insert(res, self:HyperLink(ShowLog) .. "[Log]" .. HLEnd)
    end
  end
  if type(o) == "table" and getmetatable(o) == g_traceMeta then
    table.insert(res, self:HyperLink(ShowTime) .. "[Times]" .. HLEnd)
  end
  local Refresh = function()
    if self.obj then
      self:SetObj(self.obj)
    end
  end
  local SetTransp = function()
    self.transp_mode = not self.transp_mode
    self:SetTranspMode(self.transp_mode)
  end
  table.insert(res, "\n" .. self:HyperLink(Refresh) .. "[Refresh]" .. HLEnd)
  table.insert(res, self:HyperLink(SetTransp) .. "[Transp]" .. HLEnd)
  if type(o) == "table" and getmetatable(o) == g_traceMeta then
    local Switch = function(t)
      return function()
        LocalStorage.trace_config = t
        SaveLocalStorage()
        self:SetObj(self.obj)
      end, LocalStorage.trace_config == t and "<color 0 255 0>"
    end
    local Prev = function()
      self.page = Max(1, self.page - 1)
      self:SetObj(self.obj)
    end
    local Next = function()
      self.page = self.page + 1
      self:SetObj(self.obj)
    end
    table.insert(res, "\n" .. self:HyperLink(Switch("Short")) .. "[Short]</color>" .. HLEnd .. " " .. self:HyperLink(Switch("Long")) .. "[Long]</color>" .. HLEnd .. " " .. self:HyperLink(Switch("TraceCall")) .. "[TraceCall]</color>" .. HLEnd .. " " .. self:HyperLink(Switch(false)) .. "[General]</color>" .. HLEnd .. " " .. self:HyperLink(Prev) .. "[-]" .. HLEnd .. self.page .. self:HyperLink(Next) .. "[+]" .. HLEnd)
  else
    table.insert(res, [[

Assign to]])
    for i = 1, 3 do
      local name = "o" .. i
      table.insert(res, self:HyperLink(Assign(name), rawget(_G, name) == o and "<color 0 255 0>") .. "[" .. name .. "]" .. HLEnd .. "</color> ")
    end
  end
  return Untranslated(table.concat(res, "  "))
end

function Examine:SetObj(o)
  self.onclick_handles = {}
  self.obj = o
  self.idText:SetText(self:totextex(o))
  self.idMenu:SetText(self:menu(o))

  --update attaches button with attaches amount
  --local attaches = type(o) == "table" and type(o.GetAttaches) == "function" and o:GetAttaches()
  local attaches = type(o) == "table" and type(o.GetAttaches) == "function" and o:GetAttaches()
  local amount = attaches and #attaches or 0
  local hint = "Opens attachments in new examine window."
  local name = ChoGGi.CodeFuncs.RetName(o)
  --local name = type(o) == "table" and o.class
  self.idAttaches:SetHint(hint .. "\nThis " .. name .. " has: " .. amount)
end

function Examine:SetText(text)
  self.onclick_handles = {}
  self.obj = false
  self.idText:SetText(text)
  self.idMenu:SetText(self:menu())
end
function OpenExamine(o, from)
  if o == nil then
    return ClearShowMe()
  end
  local ex = Examine:new()
  if from then
    ex:SetPos(from:GetPos() + point(0, 20))
    ex:SetSize(from:GetSize())
  end
  ex:SetObj(o)
end
lm = false
function ShowMe(o, color, time)
  if o == nil then
    return ClearShowMe()
  end
  if type(o) == "table" and #o == 2 then
    if IsPoint(o[1]) and terrain.IsPointInBounds(o[1]) and IsPoint(o[2]) and terrain.IsPointInBounds(o[2]) then
      local m = Vector:new()
      m:Set(o[1], o[2], color)
      markers[m] = "vector"
      o = m
    end
  elseif IsPoint(o) then
    if terrain.IsPointInBounds(o) then
      local m = Sphere:new()
      m:SetPos(o)
      m:SetRadius(50 * guic)
      m:SetColor(color or RGB(0, 255, 0))
      markers[m] = "point"
      if not time then
        ViewPos(o)
      end
      o = m
    end
  elseif IsValid(o) then
    markers[o] = markers[o] or o:GetColorModifier()
    o:SetColorModifier(color or RGB(0, 255, 0))
    local pos = o:GetVisualPos()
    if not time and terrain.IsPointInBounds(pos) then
      ViewPos(pos)
    end
  elseif not markers[o] then
    AddTrackerText(false, o)
  end
  lm = o
  if time then
    CreateGameTimeThread(function()
      Sleep(time)
      local v = markers[o]
      if IsValid(o) then
        if v == "point" or v == "vector" then
          DoneObject(o)
        else
          o:SetColorModifier(v)
        end
      end
      if Platform.developer then
        ClearTextTrackers(o)
      end
    end)
  end
end
function ClearShowMe()
  for k, v in pairs(markers) do
    if IsValid(k) then
      if v == "point" then
        DoneObject(k)
      else
        k:SetColorModifier(v)
      end
    end
  end
  if Platform.developer then
    ClearTextTrackers()
  end
  markers = {}
end
function ShowCircle(pt, r, color)
  local c = Circle:new()
  c:SetPos(pt:SetTerrainZ(10 * guic))
  c:SetRadius(r)
  c:SetColor(color or RGB(255, 255, 255))
  CreateGameTimeThread(function()
    Sleep(7000)
    if IsValid(c) then
      c:delete()
    end
  end)
end
local OpenExamine = OpenExamine
function examine(o)
  OpenExamine(o)
end
function ex(o)
  OpenExamine(o)
end
