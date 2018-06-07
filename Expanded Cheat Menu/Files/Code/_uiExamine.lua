--Haemimont Games code (mostly)
--why would they remove such a useful modding tool from a game that relies on mods this much? sigh.

local oldTableConcat = oldTableConcat
local Untranslated = Untranslated

-- 1 above console log
local zorder = 2000001

DefineClass.ChoGGi_ExamineDlg_Defaults = {
  __parents = {"FrameWindow"}
}

function ChoGGi_ExamineDlg_Defaults:Init()
  local ChoGGi = ChoGGi

  self:SetPos(point(278, 191))
  self:SetSize(point(372, 459))
  self:SetTranslate(false)
  self:SetMinSize(point(309, 53))
  self:SetMovable(true)
  self.onclick_handles = {}
  self.obj = false
  self.show_times = "relative"
  self.offset = 1
  self.page = 1
  -- 1 above console log
  self:SetZOrder(zorder)

  ChoGGi.ComFuncs.DialogAddCaption(self,{pos = point(250, 195),size = point(300, 22)})
  ChoGGi.ComFuncs.DialogAddCloseX(self)

  self.idText = StaticText:new(self)
  self.idText:SetPos(point(283, 332))
  self.idText:SetSize(point(362, 310))
  self.idText:SetHSizing("Resize")
  self.idText:SetVSizing("Resize")
  self.idText:SetBackgroundColor(RGBA(0, 0, 0, 50))
  self.idText:SetFontStyle("Editor12Bold")
  self.idText:SetScrollBar(true)
  self.idText:SetScrollAutohide(true)
  function self.idText.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end
  self.idText:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })

  self.idMenu = StaticText:new(self)
  self.idMenu:SetPos(point(283, 217))
  self.idMenu:SetSize(point(362, 52))
  self.idMenu:SetHSizing("Resize")
  self.idMenu:SetBackgroundColor(RGBA(0, 0, 0, 16))
  self.idMenu:SetFontStyle("Editor12Bold")
  function self.idMenu.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end
  self.idMenu:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })

  --todo: better text control (fix weird ass text controls)
  self.idFilter = SingleLineEdit:new(self)
  self.idFilter:SetPos(point(288, 275))
  self.idFilter:SetSize(point(350, 26))
  self.idFilter:SetHSizing("Resize")
  self.idFilter:SetBackgroundColor(RGBA(0, 0, 0, 16))
  self.idFilter:SetFontStyle("Editor12Bold")
  self.idFilter:SetHint(ChoGGi.ComFuncs.Trans(302535920000043,"Scrolls to text entered"))
  self.idFilter:SetTextHAlign("center")
  self.idFilter:SetTextVAlign("center")
  self.idFilter:SetBackgroundColor(RGBA(0, 0, 0, 100))
  self.idFilter.display_text = ChoGGi.ComFuncs.Trans(302535920000044,"Goto text")
  self.idFilter:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idFilter.OnValueChanged(this, value)
    self:FindNext(value)
  end
  --improved text handling
  function self.idFilter:OnKbdKeyDown(char, vk)
    if vk == const.vkEnter then
      self.parent:FindNext(self:GetText())
      return "break"
    elseif vk == const.vkEsc then
      self.parent.idCloseX:Press()
      return "break"
    else
      SingleLineEdit.OnKbdKeyDown(self, char, vk)
    end
  end

  self.idNext = Button:new(self)
  self.idNext:SetPos(point(590, 304))
  self.idNext:SetSize(point(53, 26))
  self.idNext:SetText(T({1000232, "Next"}))
  self.idNext:SetTextColorDisabled(RGBA(127, 127, 127, 255))
  self.idNext:SetHSizing("AnchorToRight")
  self.idNext:SetHint(ChoGGi.ComFuncs.Trans(302535920000045,"Scrolls down one or scrolls between text in \"Goto text\"."))
  function self.idNext.OnButtonPressed()
    self:FindNext(self.idFilter:GetText())
  end

  --needs moar buttons
  self.idDump = Button:new(self)
  self.idDump:SetPos(point(290, 304))
  self.idDump:SetSize(point(75, 26))
  self.idDump:SetText(ChoGGi.ComFuncs.Trans(302535920000046,"Dump Text"))
  self.idDump:SetHint(ChoGGi.ComFuncs.Trans(302535920000047,"Dumps text to AppData/DumpedExamine.lua"))
  function self.idDump.OnButtonPressed()
    --[[
    local String = self:totextex(self.obj)
    --remove html tags
    String = String:gsub("<[/%s%a%d]*>","")
    ChoGGi.ComFuncs.Dump(oldTableConcat({"\r\n",String}),nil,"DumpedExamine","lua")
    --]]
    self.idActionMenu = FramedList:new(self)
    self.idActionMenu:SetPos(point(290, 304))
    self.idActionMenu:SetSize(point(75, 26))
    self.idActionMenu.list:SetAutosize(true)
    self.idActionMenu:SetBackgroundColor(RGBA(0, 0, 0, 0))
    self.idActionMenu:SetSelectionBackground(RGBA(0, 0, 0, 0))
    self.idActionMenu.frame:SetCenterRectangle(box(16, 16, 32, 32))
    self.idActionMenu.list:SetTextColor(RGB(0, 0, 0))
    self.idActionMenu.list.OnClick = function()
      print("sdfds")
    end

    self.idActionMenu.list:SetContent({text="sdfgfdg",value="dddd"})
  end


  self.idDumpObj = Button:new(self)
  self.idDumpObj:SetPos(point(375, 304))
  self.idDumpObj:SetSize(point(75, 26))
  self.idDumpObj:SetText(ChoGGi.ComFuncs.Trans(302535920000048,"Dump Obj"))
  self.idDumpObj:SetHint(ChoGGi.ComFuncs.Trans(302535920000049,"Dumps object to AppData/DumpedExamineObject.lua\n\nThis can take time on something like the \"Building\" metatable"))
  function self.idDumpObj.OnButtonPressed()
    ChoGGi.ComFuncs.Dump(oldTableConcat({"\r\n",ValueToLuaCode(self.obj)}),nil,"DumpedExamineObject","lua")
  end

  self.idEdit = Button:new(self)
  self.idEdit:SetPos(point(460, 304))
  self.idEdit:SetSize(point(53, 26))
  self.idEdit:SetText(T({327465361219, "Edit"}))
  self.idEdit:SetHint(ChoGGi.ComFuncs.Trans(302535920000050,"Opens object in Object Manipulator."))
  function self.idEdit.OnButtonPressed()
    ChoGGi.ComFuncs.OpenInObjectManipulator(self.obj,self)
  end

  self.idCodeExec = Button:new(self)
  self.idCodeExec:SetPos(point(520, 304))
  self.idCodeExec:SetSize(point(50, 26))
  self.idCodeExec:SetText(ChoGGi.ComFuncs.Trans(302535920000051,"Exec"))
  self.idCodeExec:SetHint(ChoGGi.ComFuncs.Trans(302535920000052,"Execute code (using console for output). ChoGGi.CurObj is whatever object is opened in examiner.\nWhich you can then mess around with some more in the console."))
  function self.idCodeExec.OnButtonPressed()
    ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj,self)
  end

  self.idAttaches = Button:new(self)
  self.idAttaches:SetPos(point(575, 304))
  self.idAttaches:SetSize(point(75, 26))
  self.idAttaches:SetText(ChoGGi.ComFuncs.Trans(302535920000053,"Attaches"))
  self.idAttaches:SetHint(ChoGGi.ComFuncs.Trans(302535920000054,"Opens attachments in new examine window."))
  function self.idAttaches.OnButtonPressed()
    local attaches = type(self.obj) == "table" and type(self.obj.GetAttaches) == "function" and self.obj:GetAttaches()

    if attaches and #attaches > 0 then
      ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(attaches,self)
    else
      print(ChoGGi.ComFuncs.Trans(302535920000055,"Zero attachments means zero..."))
    end
  end

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()

  self:SetPos(point(50,150))
  self:SetSize(point(500,600))
end

--probably best not to change this class name?
DefineClass.Examine = {
  __parents = {
    "ChoGGi_ExamineDlg_Defaults"
  },
  -- 1 above console log
  ZOrder = zorder
}

markers = rawget(_G, "markers") or {}
transp_mode = rawget(_G, "transp_mode") or false
local HLEnd = "</h></color>"
function Examine:Init()
  self.transp_mode = transp_mode
  self:SetTranspMode(self.transp_mode)
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
    return oldTableConcat({self:HyperLink(Examine),self:ToString(debug_info.name or debug_info.name_what or ChoGGi.ComFuncs.Trans(302535920000063,"unknown name")),"@",debug_info.short_src,"(",debug_info.linedefined,")",HLEnd})
  end
  if IsValid(o) then
    return oldTableConcat({self:HyperLink(Examine),o.class,HLEnd,"@",self:valuetotextex(o:GetPos())})
  end
  if IsPoint(o) then
    local res = {
      o:x(),
      o:y(),
      o:z()
    }
    return oldTableConcat({self:HyperLink(ShowPoint),"(",oldTableConcat(res, ","),")",HLEnd})
  end
  if type(o) == "table" and getmetatable(o) and getmetatable(o) == objlist then
    local res = {}
    for i = 1, Min(#o, 3) do
      table.insert(res,oldTableConcat({i," = ",self:valuetotextex(o[i])}))
    end
    if #o > 3 then
      table.insert(res, "...")
    end
    return oldTableConcat({self:HyperLink(Examine),"objlist",HLEnd,"{",oldTableConcat(res, ", "),"}"})
  end
  if type(o) == "thread" then
    return oldTableConcat({self:HyperLink(Examine),self:ToString(o),HLEnd})
  end
  if type(o) == "string" then
    return oldTableConcat({"<tags off>'",o,"'<tags on>"})
  end
  if type(o) == "table" then
    if IsT(o) then
      return oldTableConcat({self:HyperLink(Examine),"T{\"",TDevModeGetEnglishText(o, true),"\"}",HLEnd})
    else
      local text = oldTableConcat({ObjectClass(o) or self:ToString(o),"(len:",#o,")"})
      return oldTableConcat({self:HyperLink(Examine),text,HLEnd})
    end
  end
  return self:ToString(o)
end
function Examine:HyperLink(f, custom_color)
  table.insert(self.onclick_handles, f)
  return oldTableConcat({(custom_color or "<color 150 170 250>"),"<h ",#self.onclick_handles," 230 195 50>"})
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
    return oldTableConcat({"<color 255 255 128>",self:valuetotextex(e[i + 2]),"</color>"})
  end)
  for i = 2, #e do
    if not touched[i] then
      format_text = oldTableConcat({format_text," <color 255 255 128>[",self:valuetotextex(e[i]),"]</color>"})
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
        data[oldTableConcat({name,"(up)"})] = val
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
      table.insert(res,oldTableConcat({self:valuetotextex(k)," = ",self:valuetotextex(v)}))
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
          table.insert(res, oldTableConcat({self:HyperLink(ExamineThreadLevel(level, info)),info.short_src,"(",info.currentline,") ",(info.name or info.name_what or ChoGGi.ComFuncs.Trans(302535920000063,"unknown name")),HLEnd}))
          level = level + 1
          else
            if type(o) == "function" then
              local i = 1
              while true do
                local k, v = debug.getupvalue(o, i)
                if k ~= nil then
                  table.insert(res, oldTableConcat({self:valuetotextex(k)," = ",self:valuetotextex(v)}))
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
                t = oldTableConcat({"<color 255 255 0>",tostring(e[1]),"</color>:",t})
              else
                t = oldTableConcat({"<color 255 255 0>",tostring(e[1] - GameTime()),"</color>:",t})
              end
              table.insert(res, oldTableConcat({t,"<vspace 8>"}))
            end
          end
        end
      end
    end
  end
  if IsValid(o) and IsKindOf(o, "CObject") then
    table.insert(res, 1,oldTableConcat({"<center>--",self:HyperLink(Examine(getmetatable(o))),o.class,HLEnd,"@",self:valuetotextex(o:GetPos()),"--<vspace 6>"}))
    if o:IsValidPos() and IsValidEntity(o:GetEntity()) and 0 < o:GetAnimDuration() then
      local pos = o:GetVisualPos() + o:GetStepVector() * o:TimeToAnimEnd() / o:GetAnimDuration()
      table.insert(res, 2, oldTableConcat({"<center>",GetStateName(o:GetState()),", step:",self:HyperLink(function()
        ShowMe(pos)
      end),tostring(o:GetStepVector(o:GetState(), 0)),HLEnd}))
    end
  elseif type(o) == "table" and getmetatable(o) then
    if getmetatable(o) == g_traceMeta then
      table.insert(res, 1, oldTableConcat({"<center>--",ChoGGi.ComFuncs.Trans(302535920000056,"Trace Log"),"--<vspace 6>"}))
      if self.show_times == "relative" then
        table.insert(res, 1, oldTableConcat({"<center>--",ChoGGi.ComFuncs.Trans(302535920000057,"relative times"),"--<vspace 6>"}))
      end
    else
      table.insert(res, 1, oldTableConcat({"<center>--metatable: ",self:valuetotextex(getmetatable(o)),"--<vspace 6><left>"}))
    end
  end
  return Untranslated(oldTableConcat(res, "\n"))
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
    table.insert(res, oldTableConcat({self:HyperLink(Show),ChoGGi.ComFuncs.Trans(302535920000058,"[ShowIt]"),HLEnd}))
  end
  table.insert(res, oldTableConcat({self:HyperLink(ClearShowMe),ChoGGi.ComFuncs.Trans(302535920000059,"[Clear Markers]"),HLEnd}))
  if IsValid(o) then
    table.insert(res, oldTableConcat({self:HyperLink(Destroy),ChoGGi.ComFuncs.Trans(302535920000060,"[Destroy It!]"),HLEnd}))
    if o:HasMember("trace_log") then
      table.insert(res, oldTableConcat({self:HyperLink(ShowLog),ChoGGi.ComFuncs.Trans(302535920000061,"[Log]"),HLEnd}))
    end
  end
  if type(o) == "table" and getmetatable(o) == g_traceMeta then
    table.insert(res, oldTableConcat({self:HyperLink(ShowTime),ChoGGi.ComFuncs.Trans(302535920000062,"[Times]"),HLEnd}))
  end
  local Refresh = function()
    --if self.obj then
      self:SetObj(self.obj)
    --end
  end
  local SetTransp = function()
    self.transp_mode = not self.transp_mode
    self:SetTranspMode(self.transp_mode)
  end
  table.insert(res, oldTableConcat({"\n",self:HyperLink(Refresh),"[",ChoGGi.ComFuncs.Trans(1000220,"Refresh"),"]",HLEnd}))
  table.insert(res, oldTableConcat({self:HyperLink(SetTransp),ChoGGi.ComFuncs.Trans(302535920000064,"[Transp]"),HLEnd}))
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
      --self:SetObj(self.obj)
    end
    local Next = function()
      self.page = self.page + 1
      --self:SetObj(self.obj)
    end

    table.insert(res, oldTableConcat({
        "\n",
        self:HyperLink(Switch("Short")),
        "[",
        ChoGGi.ComFuncs.Trans(302535920000065,"Short"),
        "]</color>",
        HLEnd," ",
        self:HyperLink(Switch("Long")),
        "[",ChoGGi.ComFuncs.Trans(302535920000066,"Long"),
        "]</color>",HLEnd," ",
        self:HyperLink(Switch("TraceCall")),
        "[",
        ChoGGi.ComFuncs.Trans(302535920000067,"TraceCall"),
        "]</color>",HLEnd," ",
        self:HyperLink(Switch(false)),
        "[",
        ChoGGi.ComFuncs.Trans(1000111,"General"),
        "]</color>",HLEnd," ",
        self:HyperLink(Prev),
        "[-]",HLEnd,
        self.page,self:HyperLink(Next),
        "[+]",HLEnd
      })
    )
  else
    table.insert(res, [[

Assign to]])
    for i = 1, 3 do
      local name = oldTableConcat({"o",i})
      table.insert(res, oldTableConcat({self:HyperLink(Assign(name), rawget(_G, name) == o and "<color 0 255 0>"),"[",name,"]",HLEnd,"</color> "}))
    end
  end
  return Untranslated(oldTableConcat(res, "  "))
end

function Examine:SetObj(o)
  if type(o) == "thread" then
    print(ChoGGi.ComFuncs.Trans(302535920000068,"No Examining this object kthxbye"))
    self:delete()
    return
  end
  self.onclick_handles = {}
  self.obj = o
  local name = ChoGGi.CodeFuncs.RetName(o)
  self.idText:SetText(self:totextex(o))
  self.idMenu:SetText(self:menu(o))

  local is_table = (o) == "table"

  --update attaches button with attaches amount
  local attaches = is_table and type(o.GetAttaches) == "function" and o:GetAttaches()
  local amount = attaches and #attaches or 0
  local hint = {ChoGGi.ComFuncs.Trans(302535920000070,"Opens attachments in new examine window.\nThis "),name," ",ChoGGi.ComFuncs.Trans(302535920000071,"has"),": ",amount}
  self.idAttaches:SetHint(oldTableConcat(hint))

  --add object name to title
  if is_table and type(o.handle) == "number" then
    self.idCaption:SetText(oldTableConcat({name," (",o.handle,")"}))
  else
    self.idCaption:SetText(name)
  end
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
