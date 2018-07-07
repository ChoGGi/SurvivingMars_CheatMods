-- See LICENSE for terms

local g_Classes = g_Classes
if g_Classes.Examine then
  return
end

--see about hiding list when moving dialog

local Concat
local DialogAddCaption
local DialogAddCloseX
local DialogUpdateMenuitems
local Dump
local RetButtonTextSize
local RetName
local RetSortTextAssTable
local ShowMe
local T
local TConcat
--now we can local just the funcs, and ignore the settings that may be changed later on (maybe i should have two globals, settings and funcs)
do
  local ChoGGi = ChoGGi
  Concat = ChoGGi.ComFuncs.Concat
  DialogAddCaption = ChoGGi.ComFuncs.DialogAddCaption
  DialogAddCloseX = ChoGGi.ComFuncs.DialogAddCloseX
  DialogUpdateMenuitems = ChoGGi.ComFuncs.DialogUpdateMenuitems
  Dump = ChoGGi.ComFuncs.Dump
  RetButtonTextSize = ChoGGi.ComFuncs.RetButtonTextSize
  RetName = ChoGGi.ComFuncs.RetName
  RetSortTextAssTable = ChoGGi.ComFuncs.RetSortTextAssTable
  ShowMe = ChoGGi.ComFuncs.ShowMe
  T = ChoGGi.ComFuncs.Trans
  TConcat = ChoGGi.ComFuncs.TableConcat
end

local pairs,type,print,tostring,tonumber,getmetatable,rawget,rawset = pairs,type,print,tostring,tonumber,getmetatable,rawget,rawset
local string,table,debug,utf8 = string,table,debug,utf8

local CmpLower = CmpLower
local GetStateName = GetStateName
local IsPoint = IsPoint
local IsValid = IsValid
local IsValidEntity = IsValidEntity
local OpenExamine = OpenExamine
local point = point
local SaveLocalStorage = SaveLocalStorage
local ValueToLuaCode = ValueToLuaCode
local XDestroyRolloverWindow = XDestroyRolloverWindow
local Max,Min = Max,Min
local RGBA,RGB = RGBA,RGB
local CreateRealTimeThread = CreateRealTimeThread

local terrain_GetHeight = terrain.GetHeight

-- 1 above console log
local zorder = 2000001

local g_traceMeta = false --figure out how to use traces?

--~ markers = rawget(_G, "markers") or empty_table --moved to ComFuncs
transp_mode = rawget(_G, "transp_mode") or false
local HLEnd = "</h></color>"
--probably best not to change this class name, if other people use it
DefineClass.Examine = {
  __parents = {"FrameWindow"},
  ZOrder = zorder,
  onclick_handles = {},
  obj = false,
  show_times = "relative",
  offset = 1,
  page = 1,
}

function Examine:Init()
  local ChoGGi = ChoGGi
  local const = const
  local terminal = terminal

  --element pos is based on
  self:SetPos(point(0,0))

  local dialog_width = 500
  local dialog_height = 600
  self:SetSize(point(dialog_width,dialog_height))
  self:SetMinSize(point(50, 50))
  self:SetMovable(true)
  self:SetTranslate(false)

  local border = 4
  local element_y
  local element_x
  dialog_width = dialog_width - border * 2
  local dialog_left = border

  DialogAddCloseX(self)
  DialogAddCaption(self,{
    prefix = Concat(T(302535920000069--[[Examine--]]),": "),
    pos = point(25, border),
    size = point(dialog_width-self.idCloseX:GetSize():x(), 22)
  })

  element_y = self.idCaption:GetPos():y() + self.idCaption:GetSize():y()

  self.idLinks = g_Classes.StaticText:new(self)
  self.idLinks:SetPos(point(dialog_left, element_y))
--~   self.idLinks:SetSize(point(dialog_width, 34))
  self.idLinks:SetSize(point(dialog_width, 20))
  --~ box(left,top, right, bottom)
  self.idLinks:SetHSizing("Resize")
  self.idLinks:SetBackgroundColor(RGBA(0, 0, 0, 16))
  self.idLinks:SetFontStyle("Editor12Bold")
  function self.idLinks.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end
  self.idLinks:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })

  element_y = border / 2 + self.idLinks:GetPos():y() + self.idLinks:GetSize():y()

  --todo: better text control (fix weird ass text controls)
  self.idFilter = g_Classes.SingleLineEdit:new(self)
  self.idFilter:SetPos(point(dialog_left, element_y))
  self.idFilter:SetSize(point(dialog_width, 26))
  self.idFilter:SetHSizing("Resize")
  self.idFilter:SetBackgroundColor(RGBA(0, 0, 0, 16))
  self.idFilter:SetFontStyle("Editor12Bold")
  self.idFilter:SetHint(T(302535920000043--[[Scrolls to text entered--]]))
  self.idFilter:SetTextHAlign("center")
  self.idFilter:SetTextVAlign("center")
  self.idFilter:SetBackgroundColor(RGBA(0, 0, 0, 100))
  self.idFilter.display_text = T(302535920000044--[[Goto text--]])
  self.idFilter:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idFilter.OnValueChanged(_, value)
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
      g_Classes.SingleLineEdit.OnKbdKeyDown(self, char, vk)
    end
  end

  element_y = border + self.idFilter:GetPos():y() + self.idFilter:GetSize():y()

  local title = T(302535920000239--[[Tools--]])
  self.idTools = g_Classes.Button:new(self)
  self.idTools:SetPos(point(dialog_left+5, element_y))
  self.idTools:SetSize(RetButtonTextSize(title))
  self.idTools:SetText(title)
  self.idToolsMenu = g_Classes.ComboBox:new(self)
  self.idToolsMenu:SetPos(self.idTools:GetPos() + point(0,10))
  --height doesn't matter, but width sure does
  self.idToolsMenu:SetSize(point(100, 0))
  self.idToolsMenu:SetVisible(false)
  self.idToolsMenu:SetItemsLimit(25)
  --so it doesn't block clicking when it's closed
  self.idToolsMenu:SetZOrder(0)

  function self.idTools.OnButtonPressed()
    DialogUpdateMenuitems(self.idToolsMenu)
    --combo makes this 1000000, we need more to be on top of examine
    self.idToolsMenu.drop_dialog:SetZOrder(zorder+1)
  end

  local menuitem_DumpText = Concat(T(302535920000004--[[Dump--]])," ",T(1000145--[[Text--]]))
  local menuitem_DumpObject = Concat(T(302535920000004--[[Dump--]])," ",T(298035641454--[[Object--]]))
  local menuitem_ViewText = Concat(T(302535920000048--[[View--]])," ",T(1000145--[[Text--]]))
  local menuitem_ViewObject = Concat(T(302535920000048--[[View--]])," ",T(298035641454--[[Object--]]))
  local menuitem_EditObject = Concat(T(327465361219 --[[Edit--]])," ",T(298035641454 --[[Object--]]))
  local menuitem_ExecCode = T(302535920000323--[[Exec Code--]])

  function self.idToolsMenu.OnComboClose(menu,idx)
    --close hint
    XDestroyRolloverWindow(true)
    if self.idToolsMenu.list.rollover then
      local text = menu.items[idx].text
      if text == menuitem_ViewText then
        local str = self:totextex(self.obj)
        --remove html tags
        str = str:gsub("<[/%s%a%d]*>","")
        local dialog = g_Classes.ChoGGi_MultiLineText:new({}, terminal.desktop,{
          checkbox = true,
          zorder = zorder,
          text = str,
          hint_ok = T(302535920000047),
          func = function(answer,overwrite)
            if answer then
              Dump(Concat("\n",str),overwrite,"DumpedExamine","lua")
            end
          end,
        })
        dialog:Open()
      elseif text == menuitem_ViewObject then
        local str = ValueToLuaCode(self.obj)
        local dialog = g_Classes.ChoGGi_MultiLineText:new({}, terminal.desktop,{
          checkbox = true,
          zorder = zorder,
          text = str,
          hint_ok = T(302535920000049),
          func = function(answer,overwrite)
            if answer then
              Dump(Concat("\n",str),overwrite,"DumpedExamineObject","lua")
            end
          end,
        })
        dialog:Open()
      elseif text == menuitem_DumpText then
        local str = self:totextex(self.obj)
        --remove html tags
        str = str:gsub("<[/%s%a%d]*>","")
        Dump(Concat("\n",str),overwrite,"DumpedExamine","lua")
      elseif text == menuitem_DumpObject then
        local str = ValueToLuaCode(self.obj)
        Dump(Concat("\n",str),overwrite,"DumpedExamineObject","lua")
      elseif text == menuitem_EditObject then
        ChoGGi.ComFuncs.OpenInObjectManipulator(self.obj,self)
      elseif text == menuitem_ExecCode then
        ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj,self)
      end

    end
  end
  --setup menu items
  self.idToolsMenu:SetContent({
    {
      text = Concat("   ---- ",T(302535920000239--[[Tools--]])),
      rollover = "-"
    },
    {
      text = menuitem_DumpText,
      rollover = T(302535920000046--[[dumps text to AppData/DumpedExamine.lua--]]),
    },
    {
      text = menuitem_DumpObject,
      rollover = T(302535920001027--[[dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the "Building" metatable--]]),
    },

    {
      text = menuitem_ViewText,
      rollover = T(302535920000047--[[View text, and optionally dumps text to AppData/DumpedExamine.lua (don't use this option on large text)--]]),
    },
    {
      text = menuitem_ViewObject,
      rollover = T(302535920000049--[[View text, and optionally dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the \"Building\" metatable (don't use this option on large text)--]]),
    },
    {
      text = "   ---- ",
      rollover = "-",
    },
    {
      text = menuitem_EditObject,
      rollover = T(302535920000050--[[Opens object in Object Manipulator.--]]),
    },
    {
      text = menuitem_ExecCode,
      rollover = T(302535920000052--[[Execute code (using console for output). ChoGGi.CurObj is whatever object is opened in examiner.\nWhich you can then mess around with some more in the console.--]]),
    },
  }, true)

  element_x = 10 + self.idTools:GetPos():x() + self.idTools:GetSize():x()
  title = T(302535920000520--[[Parents--]])
  self.idParents = g_Classes.Button:new(self)
  self.idParents:SetPos(point(element_x, element_y))
  self.idParents:SetSize(RetButtonTextSize(title))
  self.idParents:SetText(title)
  self.idParents:SetHint(T(302535920000553--[[Examine parent and ancestor objects.--]]))

  self.idParentsMenu = g_Classes.ComboBox:new(self)
  self.idParentsMenu:SetPos(self.idParents:GetPos() + point(0,10))
  --height doesn't matter, but width sure does
  self.idParentsMenu:SetSize(point(250, 0))
  self.idParentsMenu:SetVisible(false)
  self.idParentsMenu:SetItemsLimit(25)
  --so it doesn't block clicking when it's closed
  self.idParentsMenu:SetZOrder(0)

  function self.idParents.OnButtonPressed()
    DialogUpdateMenuitems(self.idParentsMenu)
    self.idParentsMenu.drop_dialog:SetZOrder(zorder+1)
  end

  function self.idParentsMenu.OnComboClose(menu,index)
    --close hint
    XDestroyRolloverWindow(true)
    if self.idParentsMenu.list.rollover then
      local text = menu.items[index].text
      if not text:find("-") then
        OpenExamine(_G[text],self)
      end
    end
  end

  element_x = 10 + self.idParents:GetPos():x() + self.idParents:GetSize():x()

  title = T(302535920000053--[[Attaches--]])
  self.idAttaches = g_Classes.Button:new(self)
  self.idAttaches:SetPos(point(element_x, element_y))
  self.idAttaches:SetSize(RetButtonTextSize(title))
  self.idAttaches:SetText(title)
  self.idAttaches:SetHint(T(302535920000054--[[Any objects attached to this object.--]]))
  self.idAttachesMenu = g_Classes.ComboBox:new(self)
  self.idAttachesMenu:SetPos(self.idAttaches:GetPos() + point(0,10))
  --height doesn't matter, but width sure does
  self.idAttachesMenu:SetSize(point(250, 0))
  self.idAttachesMenu:SetVisible(false)
  self.idAttachesMenu:SetItemsLimit(25)
  --so it doesn't block clicking when it's closed
  self.idAttachesMenu:SetZOrder(0)

  function self.idAttaches.OnButtonPressed()
    DialogUpdateMenuitems(self.idAttachesMenu)
    --combo makes this 1000000, we need more to be on top of examine
    self.idAttachesMenu.drop_dialog:SetZOrder(zorder+1)
  end

  function self.idAttachesMenu.OnComboClose(menu,idx)
    --close hint
    XDestroyRolloverWindow(true)
    if self.idAttachesMenu.list.rollover then
      local item = menu.items[idx]
      if not item.text:find("-") then
        OpenExamine(item.obj,self)
      end
    end
  end


  title = T(1000232--[[Next--]])
  self.idNext = g_Classes.Button:new(self)
  self.idNext:SetSize(RetButtonTextSize(title))
  self.idNext:SetPos(point(dialog_width-60-border, element_y))
  self.idNext:SetText(title)
  --self.idNext:SetTextColorDisabled(RGBA(127, 127, 127, 255))
  self.idNext:SetHSizing("AnchorToRight")
  self.idNext:SetHint(T(302535920000045--[[Scrolls down one line or scrolls between text in \"Goto text\".\nRight-click to scroll to top.--]]))
  function self.idNext.OnButtonPressed()
    self:FindNext(self.idFilter:GetText())
  end
  function self.idNext.OnRButtonPressed()
    self.idText:SetTextOffset(point(0,0))
  end

  element_y = border + self.idTools:GetPos():y() + self.idTools:GetSize():y()

  self.idText = g_Classes.StaticText:new(self)
  self.idText:SetPos(point(dialog_left, element_y))
  self.idText:SetSize(point(dialog_width, dialog_height-element_y-border-1))
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
  element_y = border + self.idText:GetPos():y() + self.idText:GetSize():y()

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()

  --look at them sexy internals
  self.transp_mode = transp_mode
  self:SetTranspMode(self.transp_mode)

  CreateRealTimeThread(function()
    self:SetPos(point(100,100))
  end)
end

function Examine:FindNext(filter)
  local drawBuffer = self.idText.draw_cache
  local current_y = -self.idText.text_offset:y()
  local min_match, closest_match = false, false
  for y, list_draw_info in pairs(drawBuffer) do
    for i = 1, #list_draw_info do
      local draw_info = list_draw_info[i]
      if draw_info.text and string.find(draw_info.text:lower(), filter:lower(), 0, true) then
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
--

local function Examine_valuetotextex(_, _, button,o,self)
  if button == "left" then
    OpenExamine(o, self)
  elseif IsValid(o) then
    ShowMe(o)
  end
end
local function ShowPoint_valuetotextex(o)
  ShowMe(o)
end
function Examine:valuetotextex(o)
  local objlist = objlist
  local obj_type = type(o)
  local is_table = obj_type == "table"

  if obj_type == "function" then
    local debug_info = debug.getinfo(o, "Sn")
    return Concat(
      self:HyperLink(function(_,_,button)
        Examine_valuetotextex(_,_,button,o,self)
      end),
      tostring(debug_info.name or debug_info.name_what or T(302535920000063--[[unknown name--]])),
      "@",
      debug_info.short_src,
      "(",
      debug_info.linedefined,
      ")",
      HLEnd
    )
  elseif IsValid(o) then
    return Concat(
      self:HyperLink(function(_,_,button)
        Examine_valuetotextex(_,_,button,o,self)
      end),
      o.class,
      HLEnd,
      "@",
      self:valuetotextex(o:GetPos())
    )
  elseif IsPoint(o) then
    return Concat(
      self:HyperLink(function()
        ShowPoint_valuetotextex(o)
      end),
      "(",o:x(),",",o:y(),",",o:z() or terrain_GetHeight(o),")",
      HLEnd
    )
  end

  if is_table then
    local is_objlist = getmetatable(o)
    if is_objlist and is_objlist == objlist then
      local res = {
        self:HyperLink(function(_,_,button)
          Examine_valuetotextex(_,_,button,o,self)
        end),
        "objlist",
        HLEnd,
        "{",
      }
      for i = 1, Min(#o, 3) do
        res[#res+1] = i
        res[#res+1] = " = "
        res[#res+1] = self:valuetotextex(o[i])
      end
      if #o > 3 then
        res[#res+1] = "..."
      end
      res[#res+1] = ", "
      res[#res+1] = "}"
      return TConcat(res)
    end

  elseif obj_type == "thread" then
    return Concat(
      self:HyperLink(function(_,_,button)
        Examine_valuetotextex(_,_,button,o,self)
      end),
      tostring(o),
      HLEnd
    )
  elseif obj_type == "string" then
    return Concat(
      "<tags off>'",
      o,
      "'<tags on>"
    )
  end

  if is_table then
    return Concat(
      self:HyperLink(function(_,_,button)
        Examine_valuetotextex(_,_,button,o,self)
      end),
      Concat(RetName(o)," (len:",#o,")"),
      HLEnd
    )
  end

--~   return tostring(o)
  return o
end

function Examine:HyperLink(f, custom_color)
  self.onclick_handles[#self.onclick_handles+1] = f
  return Concat(
    (custom_color or "<color 150 170 250>"),
    "<h ",
    #self.onclick_handles,
    " 230 195 50>"
  )
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
  local LocalStorage = LocalStorage
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
    return Concat(
      "<color 255 255 128>",self:valuetotextex(e[i + 2]),"</color>"
    )
  end)
  for i = 2, #e do
    if not touched[i] then
      format_text = Concat(
        format_text," <color 255 255 128>[",self:valuetotextex(e[i]),"]</color>"
      )
    end
  end
  return format_text
end

---------------------------------------------------------------------------------------------------------------------
local function ExamineThreadLevel_totextex(level, info, o,self)
  local data = {}
  local l = 1
  while true do
    local name, val = debug.getlocal(o, level, l)
    if name then
      data[name] = val
      l = l + 1
    else
      break
    end
  end
  for i = 1, info.nups do
    local name, val = debug.getupvalue(info.func, i)
    if name ~= nil and val ~= nil then
      data[Concat(name,"(up)")] = val
    end
  end
  return function()
    OpenExamine(data, self)
  end
end
local function Examine_totextex(o,self)
  OpenExamine(o, self)
end
function Examine:totextex(o)
  local res = {}
  local sort = {}
  local obj_metatable = getmetatable(o)
  local obj_type = type(o)
  local is_table = obj_type == "table"
--~   if obj_type == "table" and obj_metatable ~= g_traceMeta then
  if is_table then

    for k, v in pairs(o) do
      res[#res+1] = Concat(
        self:valuetotextex(k),
        " = ",
        self:valuetotextex(v)
      )
      if type(k) == "number" then
        sort[res[#res]] = k
      end
    end

  elseif obj_type == "thread" then

    local info, level = true, 0
    while true do
      info = debug.getinfo(o, level, "Slfun")
      if info then
        res[#res+1] = Concat(
          self:HyperLink(function(level, info)
            ExamineThreadLevel_totextex(level, info, o,self)
          end),
          self:HyperLink(ExamineThreadLevel_totextex(level, info, o,self)),
          info.short_src,
          "(",
          info.currentline,
          ") ",
          (info.name or info.name_what or T(302535920000063--[[unknown name--]])),
          HLEnd
        )
      else
        break
      end
      level = level + 1
    end

  elseif obj_type == "function" then

    local i = 1
    while true do
      local k, v = debug.getupvalue(o, i)
      if k then
        res[#res+1] = Concat(
          self:valuetotextex(k),
          " = ",
          self:valuetotextex(v)
        )
      elseif obj_type ~= "table" or obj_metatable ~= g_traceMeta then
        res[#res+1] = self:valuetotextex(o)
        break
      else
        break
      end
      i = i + 1
    end --while

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

--~   if is_table and obj_metatable == g_traceMeta and obj_metatable == g_traceMeta then
--~     local items = 1
--~     for i = 1, #o do
--~       if not (items >= self.page * 150) then
--~         local format_text, e = self:filtersmarttable(o[i])
--~         if format_text then
--~           items = items + 1
--~           if items >= (self.page - 1) * 150 then
--~             local t = self:evalsmarttable(format_text, e)
--~             if t then
--~               if self.show_times ~= "relative" then
--~                 t = Concat("<color 255 255 0>",tostring(e[1]),"</color>:",t)
--~               else
--~                 t = Concat("<color 255 255 0>",tostring(e[1] - GameTime()),"</color>:",t)
--~               end
--~               res[#res+1] = Concat(
--~                 t,
--~                 "<vspace 8>"
--~               )
--~             end
--~           end
--~         end
--~       end
--~     end
--~   end
  if IsValid(o) and o:IsKindOf("CObject") then

      table.insert(res, 1,Concat(
      "<center>--",
      self:HyperLink(function()
        Examine_totextex(obj_metatable,self)
      end),
      o.class,
      HLEnd,
      "@",
      self:valuetotextex(o:GetPos()),
      "--<vspace 6><left>"
    ))
--~     if o:IsValidPos() and IsValidEntity(o:GetEntity()) and 0 < o:GetAnimDuration() then
    if o:IsValidPos() and IsValidEntity(o.entity) and 0 < o:GetAnimDuration() then
      local pos = o:GetVisualPos() + o:GetStepVector() * o:TimeToAnimEnd() / o:GetAnimDuration()
      table.insert(res, 2, Concat(
        GetStateName(o:GetState()),
        ", step:",
        self:HyperLink(function()
          ShowMe(pos)
        end),
        tostring(o:GetStepVector(o:GetState(),0)),
        HLEnd
      ))
    end

  elseif is_table and obj_metatable then
--~     if obj_metatable == g_traceMeta then
--~       table.insert(res, 1, Concat(
--~         "<center>--",
--~         T(302535920000056--[[Trace Log--]]),
--~         "--<vspace 6><left>"
--~       ))
--~       if self.show_times == "relative" then
--~           table.insert(res, 1, Concat(
--~             "<center>--",
--~             T(302535920000057--[[relative times--]]),
--~             "--<vspace 6><left>"
--~           ))
--~       end
--~     else
      table.insert(res, 1, Concat(
        "<center>--",
        self:valuetotextex(obj_metatable),
        ": metatable--<vspace 6><left>"
      ))
--~     end
  end

  return TConcat(res,"\n")
end
---------------------------------------------------------------------------------------------------------------------
--menu
local function Show_menu(o)
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
local function ClearShowMe_menu()
  ChoGGi.ComFuncs.ClearShowMe()
end
local function ShowLog_menu(o,self)
  OpenExamine(o.trace_log, self)
end
local function Destroy_menu(o,self)
  local z = self.ZOrder
  self:SetZOrder(1)
  ChoGGi.ComFuncs.QuestionBox(
    T(302535920000414--[[Are you sure you wish to destroy it?--]]),
    function(answer)
      self:SetZOrder(z)
      if answer and IsValid(o) then
    --~     DoneObject(o)
        ChoGGi.CodeFuncs.DeleteObject(o)
      end
    end,
    T(697--[[Destroy--]])
  )
end
local function Assign_menu(_, _, button,name,o,self)
  return function(button)
    if button == "left" then
      rawset(_G, name, o)
      self.idLinks:SetText(self:menu(o))
    elseif button == "right" then
      ShowMe(rawget(_G, name), RGB(0, 0, 255))
      OpenExamine(rawget(_G, name), self)
    end
  end
end
local function ShowTime_menu(o,self)
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
local function Refresh_menu(o,self)
  if self.obj then
    self:SetObj(self.obj)
  end
end
local function SetTransp_menu(o,self)
  self.transp_mode = not self.transp_mode
  self:SetTranspMode(self.transp_mode)
end
local function Switch_menu(t,o,self)
  return function()
    LocalStorage.trace_config = t
    SaveLocalStorage()
    self:SetObj(self.obj)
  end, LocalStorage.trace_config == t and "<color 0 255 0>"
end
local function Prev_menu(o,self)
  self.page = Max(1, self.page - 1)
  --self:SetObj(self.obj)
end
local function Next_menu(o,self)
  self.page = self.page + 1
  --self:SetObj(self.obj)
end
function Examine:menu(o)
  local obj_metatable = getmetatable(o)
  local obj_type = type(o)
  local res = {"  "}
  res[#res+1] = self:HyperLink(function()
    Refresh_menu(o,self)
  end)
  res[#res+1] = "["
  res[#res+1] = T(1000220--[[Refresh--]])
  res[#res+1] = "]"
  res[#res+1] = HLEnd
  res[#res+1] = " "
  if IsValid(o) and obj_type == "table" then
    res[#res+1] = self:HyperLink(function()
      Show_menu(o)
    end)
    res[#res+1] = T(302535920000058--[[[ShowIt]--]])
    res[#res+1] = HLEnd
    res[#res+1] = " "
  end
  res[#res+1] = self:HyperLink(ClearShowMe_menu)
  res[#res+1] = T(302535920000059--[[[Clear Markers]--]])
  res[#res+1] = HLEnd
  res[#res+1] = " "
  res[#res+1] = self:HyperLink(function()
    SetTransp_menu(o,self)
  end)
  res[#res+1] = T(302535920000064--[[[Transp]--]])
  res[#res+1] = HLEnd
  if IsValid(o) then
    res[#res+1] = " "
    res[#res+1] = self:HyperLink(function()
      Destroy_menu(o,self)
    end)
    res[#res+1] = T(302535920000060--[[[Destroy It!]--]])
    res[#res+1] = HLEnd
    res[#res+1] = " "
--~     if o:HasMember("trace_log") then
--~       res[#res+1] = self:HyperLink(function()
--~         ShowLog_menu(o,self)
--~       end)
--~       res[#res+1] = T(302535920000061--[[[Log]--]])
--~       res[#res+1] = HLEnd
--~       res[#res+1] = " "
--~     end
  end
--~   if obj_type == "table" and obj_metatable == g_traceMeta then
--~     res[#res+1] = self:HyperLink(function()
--~       ShowTime_menu(o,self)
--~     end)
--~     res[#res+1] = T(302535920000062--[[[Times]--]])
--~     res[#res+1] = HLEnd
--~     res[#res+1] = " "
--~   end
  --res[#res+1] = "\n"
--~   if obj_type == "table" and obj_metatable == g_traceMeta then
--~     res[#res+1] = "\n"
--~     res[#res+1] = self:HyperLink(function()
--~       Switch_menu("Short",o,self)
--~     end)
--~     res[#res+1] = "["
--~     res[#res+1] = T(302535920000065--[[Short--]])
--~     res[#res+1] = "]</color>"
--~     res[#res+1] = HLEnd
--~     res[#res+1] = " "
--~     res[#res+1] = self:HyperLink(function()
--~       Switch_menu("Long",o,self)
--~     end)
--~     res[#res+1] = "["
--~     res[#res+1] = T(302535920000066--[[Long--]])
--~     res[#res+1] = "]</color>"
--~     res[#res+1] = HLEnd
--~     res[#res+1] = " "
--~     res[#res+1] = self:HyperLink(function()
--~       Switch_menu("TraceCall",o,self)
--~     end)
--~     res[#res+1] = "["
--~     res[#res+1] = T(302535920000067--[[TraceCall--]])
--~     res[#res+1] = "]</color>"
--~     res[#res+1] = HLEnd
--~     res[#res+1] = " "
--~     res[#res+1] = self:HyperLink(function()
--~       Switch_menu(false,o,self)
--~     end)
--~     res[#res+1] = "["
--~     res[#res+1] = T(1000111--[[General--]])
--~     res[#res+1] = "]</color>"
--~     res[#res+1] = HLEnd
--~     res[#res+1] = self:HyperLink(function()
--~       Prev_menu(false,o,self)
--~     end)
--~     res[#res+1] = "[-]"
--~     res[#res+1] = HLEnd
--~     res[#res+1] = self.page
--~     res[#res+1] = self:HyperLink(function()
--~       Next_menu(false,o,self)
--~     end)
--~     res[#res+1] = "[+]"
--~     res[#res+1] = HLEnd
--~   else
--~     res[#res+1] = "\n  "
--~     res[#res+1] = T(302535920000228--[[Assign to--]])
--~     res[#res+1] = ": "
--~     for i = 1, 3 do
--~       local name = Concat("o",i)
--~       res[#res+1] = self:HyperLink(function()
--~       --rawget(_G, name) == o and "<color 0 255 0>"
--~         Assign_menu(_, _, button,name,o,self)
--~       end)
--~       res[#res+1] = "["
--~       res[#res+1] = name
--~       res[#res+1] = "]"
--~       res[#res+1] = HLEnd
--~       res[#res+1] = "</color> "
--~     end
--~   end
  return TConcat(res)
end

function Examine:SetObj(o)
ChoGGi.ComFuncs.TickStart("Examine:SetObj")
  local ChoGGi = ChoGGi
  self.onclick_handles = {}
  self.obj = o
  self.idText:SetText(self:totextex(o))
  self.idLinks:SetText(self:menu(o))

  local is_table = type(o) == "table"
  local name = RetName(o)

  --update attaches button with attaches amount
  local attaches = is_table and type(o.GetAttaches) == "function" and o:GetAttaches()
  local amount = attaches and #attaches or 0
  self.idAttaches:SetHint(string.format(T(302535920000070--[["Shows list of attachments. This %s has: %s"--]]),name,amount)
  )
  --add object name to title
  if is_table then
    if type(o.handle) == "number" then
      self.idCaption:SetText(Concat(name," (",o.handle,")"))
    else
      --limit length so we don't cover up close button
      self.idCaption:SetText(utf8.sub(name, 1, 50))
    end
    --build list of parents, see about a way to toggle showing ancestors (big list)
    local list = o.__parents
    if list then
      list = RetSortTextAssTable(list)
      local list_items = {{text = Concat("   ---- ",T(302535920000520--[[Parents--]]))}}
      for i = 1, #list do
        list_items[#list_items+1] = {
          text = list[i]
        }
      end
      list_items[#list_items+1] = {text = Concat("   ---- ",T(302535920000525--[[Ancestors--]]))}
      list = RetSortTextAssTable(o.__ancestors,true)
      for i = 1, #list do
        list_items[#list_items+1] = {
          text = list[i]
        }
      end
      self.idParentsMenu:SetContent(list_items, true)
    end
    --i suppose i could do some type checking, ah well
    if not pcall(function()
      --attaches menu
--~       list = type(o) == "table" and o:GetAttaches()
      list = is_table and o:GetAttaches()
      if list and #list > 0 then

        local list_items = {
          {
            text = Concat("   ---- ",T(302535920000053--[[Attaches--]])),
            rollover = T(302535920000053--[[Attaches--]])
          }
        }

        for i = 1, #list do
          local hint = list[i].handle or type(list[i].GetPos) == "function" and Concat("Pos: ",list[i]:GetPos())
          if type(hint) == "number" then
            hint = Concat(T(302535920000955--[[Handle--]]),": ",hint)
          end
          list_items[#list_items+1] = {
            text = RetName(list[i]),
            rollover = hint or list[i].class,
            obj = list[i],
          }
        end

        self.idAttachesMenu:SetContent(list_items, true)

      else
        self.idAttaches:SetVisible(false)
      end
      return true
    end) then
--~       DebugPrint(string.format(T(302535920001001--[[Slight issue with %s you may safely ignore the following error or three.--]]),"\r\n",name))
    end

  else
    self.idCaption:SetText(utf8.sub(name, 1, 50))
  end

ChoGGi.ComFuncs.TickEnd("Examine:SetObj")
end

function Examine:SetText(text)
  if ChoGGi.Testing then
    print("Examine:SetText(text)",Examine:SetText(text))
  end
  self.onclick_handles = {}
  --helps nicely for large lists and Concat function
--~   if IsObjlist(self.obj) then
--~     DoneObject(self.obj)
--~   end
  self.obj = false
  self.idText:SetText(text)
  self.idLinks:SetText(self:menu())
end

function Examine:Done(result)
--~   if self.obj and IsObjlist(self.obj) then
--~     DoneObject(self.obj)
--~   end
  Dialog.Done(self,result)
end
