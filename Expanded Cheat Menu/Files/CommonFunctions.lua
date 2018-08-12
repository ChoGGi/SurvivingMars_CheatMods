-- See LICENSE for terms

-- simplest entity object possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local, so who knows)
DefineClass.ChoGGi_HexSpot = {
  __parents = {"CObject"},
  entity = "GridTile"
}

--~ -- used for flatten ground
--~ DefineClass.ChoGGi_Square = {
--~   __parents = {"Polyline"}
--~ }
--~ function ChoGGi_Square:Init()
--~   Polyline.Init(self)
--~   self.max_vertices = #self.points
--~   self:SetMesh(self.points)
--~   self:SetPos(self.points[1])
--~ end

function DestroyRolloverWindow(_, instant)
  XDestroyRolloverWindow(instant)
end
function CreateRolloverWindow(ctrl, text, bXInput)
  if (text or "") == "" then
    return
  end
  XCreateRolloverWindow(ctrl, bXInput, true, {RolloverText = text})
end


local TableConcat -- added in Init.lua
local Concat = ChoGGi.ComFuncs.Concat -- added in Init.lua
local S = ChoGGi.Strings

local pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable = pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable
local table,debug = table,debug

local _InternalTranslate = _InternalTranslate
local AsyncCopyFile = AsyncCopyFile
local AsyncFileToString = AsyncFileToString
local AsyncListFiles = AsyncListFiles
local AsyncRand = AsyncRand
local AsyncStringToFile = AsyncStringToFile
local box = box
local CreateRealTimeThread = CreateRealTimeThread
local CreateRolloverWindow = CreateRolloverWindow
local DelayedCall = DelayedCall
local FilterObjects = FilterObjects
local GetLogFile = GetLogFile
local GetObjects = GetObjects
local GetPreciseTicks = GetPreciseTicks
local GetTerrainCursor = GetTerrainCursor
local HexGridGetObject = HexGridGetObject
local HexGridGetObjects = HexGridGetObjects
local IsBox = IsBox
local IsObjlist = IsObjlist
local IsPoint = IsPoint
local IsValid = IsValid
local Msg = Msg
local OpenDialog = OpenDialog
local point = point
local RGB = RGB
local Sleep = Sleep
local TechDef = TechDef
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey
local ViewObjectMars = ViewObjectMars
local WaitMarsQuestion = WaitMarsQuestion
local WaitPopupNotification = WaitPopupNotification
local WorldToHex = WorldToHex

local local_T = T -- T replaced below
local guic = guic
local white = white

--~ local UserActions_SetMode = UserActions.SetMode
local UIL_MeasureText = UIL.MeasureText
local terrain_IsPointInBounds = terrain.IsPointInBounds
local FontStyles_GetFontId = FontStyles.GetFontId

-- backup orginal function for later use (checks if we already have a backup, or else problems)
function ChoGGi.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local ChoGGi = ChoGGi
  if Func then
    local newname = Concat(ClassOrFunc,"_",Func)
    if not ChoGGi.OrigFuncs[newname] then
--~       ChoGGi.OrigFuncs[newname] = _G[ClassOrFunc][Func]
      ChoGGi.OrigFuncs[newname] = g_Classes[ClassOrFunc][Func]
    end
  else
    if not ChoGGi.OrigFuncs[ClassOrFunc] then
      ChoGGi.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

-- changes a function to also post a Msg for use with OnMsg
function ChoGGi.ComFuncs.AddMsgToFunc(ClassName,FuncName,sMsg)
  local ChoGGi = ChoGGi
  -- save orig
  ChoGGi.ComFuncs.SaveOrigFunc(ClassName,FuncName)
  -- redefine it
  g_Classes[ClassName][FuncName] = function(...)
--~   _G[ClassName][FuncName] = function(...)
    -- I just care about adding self to the msgs
    Msg(sMsg,select(1,...))

--~     --use to debug if getting an error
--~     local params = {...}
--~     --pass on args to orig func
--~     if not pcall(function()
--~       return ChoGGi.OrigFuncs[Concat(ClassName,"_",FuncName)](table.unpack(params))
--~     end) then
--~       print("Function Error: ",Concat(ClassName,"_",FuncName))
--~       OpenExamine({params})
--~     end
    return ChoGGi.OrigFuncs[Concat(ClassName,"_",FuncName)](...)
  end
end
-- Custom Msgs
local AddMsgToFunc = ChoGGi.ComFuncs.AddMsgToFunc
AddMsgToFunc("CargoShuttle","GameInit","ChoGGi_SpawnedShuttle")
AddMsgToFunc("Drone","GameInit","ChoGGi_SpawnedDrone")
AddMsgToFunc("RCTransport","GameInit","ChoGGi_SpawnedRCTransport")
AddMsgToFunc("RCRover","GameInit","ChoGGi_SpawnedRCRover")
AddMsgToFunc("ExplorerRover","GameInit","ChoGGi_SpawnedExplorerRover")
AddMsgToFunc("Residence","GameInit","ChoGGi_SpawnedResidence")
AddMsgToFunc("Workplace","GameInit","ChoGGi_SpawnedWorkplace")
AddMsgToFunc("ElectricityProducer","CreateElectricityElement","ChoGGi_SpawnedProducerElectricity")
AddMsgToFunc("AirProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerAir")
AddMsgToFunc("WaterProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerWater")
AddMsgToFunc("SingleResourceProducer","Init","ChoGGi_SpawnedProducerSingle")
AddMsgToFunc("PinnableObject","TogglePin","ChoGGi_TogglePinnableObject")
AddMsgToFunc("ResourceStockpileLR","GameInit","ChoGGi_SpawnedResourceStockpileLR")
AddMsgToFunc("DroneHub","GameInit","ChoGGi_SpawnedDroneHub")
AddMsgToFunc("Diner","GameInit","ChoGGi_SpawnedDinerGrocery")
AddMsgToFunc("Grocery","GameInit","ChoGGi_SpawnedDinerGrocery")
AddMsgToFunc("SpireBase","GameInit","ChoGGi_SpawnedSpireBase")
AddMsgToFunc("ElectricityStorage","GameInit","ChoGGi_SpawnedElectricityStorage")
AddMsgToFunc("LifeSupportGridObject","GameInit","ChoGGi_SpawnedLifeSupportGridObject")

do -- memoize
  local memoize = {
    _VERSION     = 'memoize v2.0',
    _DESCRIPTION = 'Memoized functions in Lua',
    _URL         = 'https://github.com/kikito/memoize.lua',
    _LICENSE     = [[
      MIT LICENSE

      Copyright (c) 2018 Enrique García Cota

      Permission is hereby granted, free of charge, to any person obtaining a
      copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:

      The above copyright notice and this permission notice shall be included
      in all copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]]
  }
  -- Inspired by http://stackoverflow.com/questions/129877/how-do-i-write-a-generic-memoize-function

  -- private stuff

  local function is_callable(f)
    local tf = type(f)
    if tf == 'function' then return true end
    if tf == 'table' then
      local mt = getmetatable(f)
      return type(mt) == 'table' and is_callable(mt.__call)
    end
    return false
  end

  local function cache_get(cache, params)
    local node = cache
    for i=1, #params do
      node = node.children and node.children[params[i]]
      if not node then return nil end
    end
    return node.results
  end

  local function cache_put(cache, params, results)
    local node = cache
    local param
    for i=1, #params do
      param = params[i]
      node.children = node.children or {}
      node.children[param] = node.children[param] or {}
      node = node.children[param]
    end
    node.results = results
  end

  -- public function

  function memoize.memoize(f, cache)
    cache = cache or {}

    if not is_callable(f) then
      local str = [[If you get this msg contact me, thanks.

  Only functions and callable tables are memoizable. Received %s (a %s)]]
      print(str:format(tostring(f), type(f)))
    end
    return function (...)
      local params = {...}

      local results = cache_get(cache, params)
      if not results then
        results = { f(...) }
        cache_put(cache, params, results)
      end

      return table.unpack(results)
    end
  end
  setmetatable(memoize, { __call = function(_, ...) return memoize.memoize(...) end })
  ChoGGi.ComFuncs.Memoize = memoize.memoize
end -- do
local Memoize = ChoGGi.ComFuncs.Memoize

-- cache translation strings
_InternalTranslate = Memoize(_InternalTranslate)
IsT = Memoize(IsT)
T = Memoize(T)
TDevModeGetEnglishText = Memoize(TDevModeGetEnglishText)

ChoGGi.ComFuncs.TableConcat = Memoize(ChoGGi.ComFuncs.TableConcat)
TableConcat = ChoGGi.ComFuncs.TableConcat

-- I want a translate func to always return a string
function ChoGGi.ComFuncs.Trans(...)
  local trans
  local vararg = {...}
  -- just in case a
  pcall(function()
    if type(vararg[1]) == "userdata" then
      trans = _InternalTranslate(table.unpack(vararg))
    else
      trans = _InternalTranslate(local_T(vararg))
    end
  end)
  -- just in case b
  if type(trans) ~= "string" then
    if type(vararg[2]) == "string" then
      return vararg[2]
    end
    -- done fucked up (just in case c)
    return Concat(vararg[1]," < Missing locale string id")
  end
  return trans
end
ChoGGi.ComFuncs.Trans = Memoize(ChoGGi.ComFuncs.Trans)
local T = ChoGGi.ComFuncs.Trans

-- check if text is already translated or needs to be, and return the text
function ChoGGi.ComFuncs.CheckText(text,fallback)
  if type(text) == "string" then
    return text
  else
    text = S[text]
  end
  -- probably missing locale id
  if type(text) ~= "string" and fallback then
    text = tostring(fallback)
  end
  return text
end

-- returns object name or at least always some string
function ChoGGi.ComFuncs.RetName(obj)
  if obj == _G then
    return "_G"
  end

  if type(obj) == "table" then
    local name_type = type(obj.name)

    -- custom name from user (probably)
    if name_type == "string" and obj.name ~= "" then
      return obj.name

    -- colonist names
    elseif name_type == "table" and #obj.name == 3 then
      return TableConcat{
        T(obj.name[1]),
        " ",
        T(obj.name[3]),
      }

    --translated name
    elseif obj.display_name and obj.display_name ~= "" then
      return T(obj.display_name)

    -- encyclopedia_id
    elseif type(obj.encyclopedia_id) == "string" then
      return obj.encyclopedia_id

    -- class
    elseif type(obj.class) == "string" then
      return obj.class

    -- added this here as doing tostring lags the shit outta kansas if this is a large objlist
    elseif IsObjlist(obj) then
      return "objlist"
    end

  end

  -- falling back baby
--~   return tostring(obj):sub(1,150) --limit length of string in case it's a large one
  return tostring(obj)
end
local RetName = ChoGGi.ComFuncs.RetName

-- shows a popup msg with the rest of the notifications
-- objects can be a single obj, or {obj1,obj2,etc}
function ChoGGi.ComFuncs.MsgPopup(text,title,icon,size,objects)
  local ChoGGi = ChoGGi
  if not ChoGGi.Temp.MsgPopups then
    ChoGGi.Temp.MsgPopups = {}
  end
  local g_Classes = g_Classes
  -- build our popup
  local timeout = 10000
  if size then
    timeout = 30000
  end
  local params = {
    expiration = timeout,
--~     {expiration = 99999999999999999},
--~     dismissable = false,
  }
  -- if there's no interface then we probably shouldn't open the popup
  local dlg = Dialogs.OnScreenNotificationsDlg
  if not dlg then
    local igi = Dialogs.InGameInterface
    if not igi then
      return
    end
    dlg = OpenDialog("OnScreenNotificationsDlg", igi)
  end
  --build the popup
  local data = {
    id = AsyncRand(),
    title = ChoGGi.ComFuncs.CheckText(title,""),
    text = ChoGGi.ComFuncs.CheckText(text,S[3718--[[NONE--]]]),
    image = type(tostring(icon):find(".tga")) == "number" and icon or Concat(ChoGGi.MountPath,"TheIncal.tga")
  }
  table.set_defaults(data, params)
  table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
  if objects then
    if type(objects) ~= "table" then
      objects = {objects}
    end
    params.cycle_objs = objects
  end
  --and show the popup
  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, params.cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
    ChoGGi.Temp.MsgPopups[#ChoGGi.Temp.MsgPopups+1] = popup

    -- large amount of text option (four long lines o' text, or is it five?)
    if size then
      --larger text limit
      popup.idText.Margins = box(0,0,0,-500)
      --resize title, or move it?
      popup.idTitle.Margins = box(0,-20,0,0)
      --check if this is doing something
      Sleep(0)
      --size/pos of background image
      popup[1].scale = point(2800,2600)
      popup[1].Margins = box(-5,-30,0,-5)
      --update dialog size
      popup:InvalidateMeasure()
      --i don't care for sounds
--~       if type(params.fx_action) == "string" and params.fx_action ~= "" then
--~         PlayFX(params.fx_action)
--~       end
    end
  end)
end
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

do --g_Classes
  local g_Classes = g_Classes
  function ChoGGi.ComFuncs.AddAction(entry,menu,action,key,des,icon,toolbar,mode,xinput,toolbar_default)
    local ChoGGi = ChoGGi

    -- build function
    local name = "NOFUNC"
    -- tooltip menu item
    if action == "blank_function" then
      name = action
      action = function()end
    -- make the id the func location (filename/linenum)
    elseif type(action) == "function" then
      local debug_info = debug.getinfo(action, "Sn")
      local text = Concat(debug_info.short_src,"(",debug_info.linedefined,")")
      name = text:gsub(ChoGGi.ModPath,"")
      name = name:gsub(ChoGGi.ModPath:gsub("AppData","...ata"),"")
      name = name:gsub(ChoGGi.ModPath:gsub("AppData","...a"),"")
      name = name:gsub("...Mods/Expanded Cheat Menu/","")
    else
      ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat("<color 255 100 100>",S[302535920000000--[[Expanded Cheat Menu--]]],"</color><color 0 0 0>: </color><color 128 255 128>",S[302535920000166--[[BROKEN FUNCTION--]]],": </color>",menu)
    end

    -- description (we leave funcs as they are, so UAMenu.UpdateUAMenu works)
    if type(des) ~= "function" then
      des = ChoGGi.ComFuncs.CheckText(des,menu)
    end

    local path
    if entry then
      path = TableConcat(entry)
      entry = entry[2]
    end

    ChoGGi.Temp.MenuitemsKeys[#ChoGGi.Temp.MenuitemsKeys+1] = {
      ActionMenubar = "CUSTOM",
      ActionName = menu,
      ActionId = Concat("ChoGGi_",name,"-",AsyncRand()),
      ActionIcon = icon,
      ActionTranslate = false,
      ActionShortcut = key,
      ActionMode = "Game",
      RolloverText = des,
      RolloverTemplate = "Rollover",
      RolloverTitle = S[126095410863--[[Info--]]],
--~       ActionSortKey = "Displayname as well?",
--~       OnAltAction = ,
      OnAction = action,
    }

--~     ChoGGi.ComFuncs.UserAddActions{
--~       -- AsyncRand needed for items made from same line (like a loop)
--~       [Concat("ChoGGi_",name,"-",AsyncRand())] = {
--~         -- name of button
--~         entry = entry,
--~         -- button path needed for UAMenu, so i don't have to go through the whole pattern match utf (they translated the strings used for the cheats menu, but didn't make it actually support utf)
--~         path = path,
--~         -- the below are all part of default table

--~         -- menu path needed for UAMenu
--~         menu = menu,
--~         -- func
--~         action = action,
--~         -- shortcut
--~         key = key,
--~         -- good question
--~         description = des,
--~         -- i should change the built-in func to use full paths
--~         icon = icon,
--~         -- dunno the rest
--~         toolbar = toolbar,
--~         mode = mode,
--~         xinput = xinput,
--~         toolbar_default = toolbar_default
--~       },
--~     }
  end

--~   function ChoGGi.ComFuncs.DialogXAddButton(parent,text,hint,onpress)
--~     g_Classes.XTextButton:new({
--~       RolloverTemplate = "Rollover",
--~       RolloverText = hint or "",
--~       RolloverTitle = S[126095410863--[[Info--]]],
--~       MinWidth = 60,
--~       Text = ChoGGi.ComFuncs.CheckText(text,S[6878--[[OK--]]]),
--~       OnPress = onpress,
--~       --center text
--~       LayoutMethod = "VList",
--~     }, parent)
--~   end

  function ChoGGi.ComFuncs.PopupToggle(parent,popup_id,anchor,items)
    local popup = g_Classes.XPopupList:new({
      Opened = true,
      Id = popup_id,
      ZOrder = 999999,
      -- anchor usually means bottom, nil means top
--~       Margins = anchor and box(0, 5, 0, 0) or  box(0, 0, 0, 5),
      LayoutMethod = "VList",
    }, terminal.desktop)

    for i = 1, #items do
      local item = items[i]
      -- defaults to XTextButton. class = "ChoGGi_CheckButtonMenu",
      local button = g_Classes[item.class or "ChoGGi_ButtonMenu"]:new({
        RolloverText = ChoGGi.ComFuncs.CheckText(item.hint,""),
        Text = ChoGGi.ComFuncs.CheckText(item.name,""),
--~         OnMouseButtonDown = item.clicked or function()end,
        OnMouseButtonUp = function()
          popup:Close()
        end,
      }, popup.idContainer)

      if item.clicked then
        button.OnMouseButtonDown = item.clicked
      end

      if item.showme then
        function button.OnMouseEnter()
          ChoGGi.ComFuncs.ClearShowMe()
          ChoGGi.ComFuncs.ShowMe(item.showme, nil, true, true)
        end
      elseif item.pos then
        function button.OnMouseEnter()
          ViewObjectMars(item.pos)
        end
      end

      -- i just love checkmarks
      if item.value then

        local is_vis
        local value

        if type(item.value) == "table" then
          value = ChoGGi.UserSettings[item.value[1]]
        else
          value = _G[item.value]
        end

        if type(value) == "table" then
          if value.visible then
            is_vis = true
          end
        else
          if value then
            is_vis = true
          end
        end


        if is_vis then
          button:SetCheck(true)
        else
          button:SetCheck(false)
        end
      end

    end

    popup:SetAnchor(parent.box)
    popup:SetAnchorType(anchor or "top")
--~     "smart",
--~     "left",
--~     "right",
--~     "top",
--~     "center-top",
--~     "bottom",
--~     "mouse"

    popup:Open()
    popup:SetFocus()
--~     return popup
  end

  function ChoGGi.ComFuncs.ShowMe(o, color, time, both)
    if not o then
      return ChoGGi.ComFuncs.ClearShowMe()
    end

    if type(o) == "table" and #o == 2 then
      if IsPoint(o[1]) and terrain_IsPointInBounds(o[1]) and IsPoint(o[2]) and terrain_IsPointInBounds(o[2]) then
        local m = g_Classes.Vector:new()
        m:Set(o[1], o[2], color)
        markers[m] = "vector"
        o = m
      end
    else
      -- both is for objs i also want a sphere over
      if IsPoint(o) or both then
        local o2 = IsPoint(o) and o or IsValid(o) and o:GetVisualPos()
        if o2 and terrain_IsPointInBounds(o2) then
          local m = g_Classes.Sphere:new()
          m:SetPos(o2)
          m:SetRadius(50 * guic)
          m:SetColor(color or RGB(0, 255, 0))
          markers[m] = "point"
          if not time then
            ViewObjectMars(o2)
          end
          o2 = m
        end
      end

      if IsValid(o) then
        markers[o] = markers[o] or o:GetColorModifier()
        o:SetColorModifier(color or RGB(0, 255, 0))
        local pos = o:GetVisualPos()
        if not time and terrain_IsPointInBounds(pos) then
          ViewObjectMars(pos)
        end
      end
    end
  --~   lm = o
  end

  -- show a circle for time and delete it
  function ChoGGi.ComFuncs.Circle(pos, radius, color, time)
    local c = g_Classes.Circle:new()
    c:SetPos(pos and pos:SetTerrainZ(10 * guic) or GetTerrainCursor())
    c:SetRadius(radius or 1000)
    c:SetColor(color or white)
    DelayedCall(time or 50000, function()
      if IsValid(c) then
        c:delete()
      end
    end)
  end

end

-- centred msgbox with Ok
function ChoGGi.ComFuncs.MsgWait(text,title,image)
  text = ChoGGi.ComFuncs.CheckText(text,text)
  title = ChoGGi.ComFuncs.CheckText(title,S[1000016--[[Title--]]])

  local preset
  if image then
    preset = "ChoGGi_TempPopup"
    local DataInstances = DataInstances
    DataInstances.PopupNotificationPreset[preset] = {
      name = preset,
      image = image,
    }
  end

  CreateRealTimeThread(function()
    WaitPopupNotification(preset, {title = title, text = text})
    if preset then
      DataInstances.PopupNotificationPreset[preset] = nil
    end
  end)
end

-- well that's the question isn't it?
function ChoGGi.ComFuncs.QuestionBox(text,func,title,ok_msg,cancel_msg,image,context,parent)
  local ChoGGi = ChoGGi
  -- thread needed for WaitMarsQuestion
  CreateRealTimeThread(function()
    if WaitMarsQuestion(
      parent,
      ChoGGi.ComFuncs.CheckText(title,S[1000016--[[Title--]]]),
      ChoGGi.ComFuncs.CheckText(text,S[3718--[[NONE--]]]),
      ChoGGi.ComFuncs.CheckText(ok_msg,S[6878--[[OK--]]]),
      ChoGGi.ComFuncs.CheckText(cancel_msg,S[6879--[[Cancel--]]]),
      image,
      context
    ) == "ok" then
      if func then
        func(true)
      end
      return "ok"
    else
      -- user canceled / closed it
      if func then
        func()
      end
      return "cancel"
    end
  end)
end

function ChoGGi.ComFuncs.Dump(obj,mode,file,ext,skip_msg)
  if mode == "w" or mode == "w+" then
    mode = nil
  else
    mode = "-1"
  end
  local filename = Concat("AppData/logs/",file or "DumpedText",".",ext or "txt")

  ThreadLockKey(filename)
  AsyncStringToFile(filename,obj,mode)
  ThreadUnlockKey(filename)

  -- let user know
  if not skip_msg then
    MsgPopup(
      S[302535920000002--[[Dumped: %s--]]]:format(RetName(obj)),
      filename,
      "UI/Icons/Upgrades/magnetic_filtering_04.tga",
      nil,
      obj
    )
  end
end

function ChoGGi.ComFuncs.DumpLua(obj)
--~   local v_type = type(value)
--~   local which = "TupleToLuaCode"
--~   if v_type == "table" then
--~     which = "TableToLuaCode"
--~   elseif v_type == "string" then
--~     which = "StringToLuaCode"
--~   elseif v_type == "userdata" then
--~     which = "ValueToLuaCode"
--~   end
  ChoGGi.ComFuncs.Dump(Concat("\r\n",ValueToLuaCode(obj)),nil,"DumpedLua","lua")
end

--[[
Mode = -1 to append or nil to overwrite (default: -1)
Funcs = true to dump functions as well (default: false)
ChoGGi.ComFuncs.DumpTable(Object)
--]]
function ChoGGi.ComFuncs.DumpTable(obj,mode,funcs)
  local ChoGGi = ChoGGi
  if not obj then
    MsgPopup(
      302535920000003--[[Can't dump nothing--]],
      302535920000004--[[Dump--]]
    )
    return
  end
  mode = mode or "-1"
  --make sure it's empty
  ChoGGi.Temp.TextFile = ""
  ChoGGi.ComFuncs.DumpTableFunc(obj,nil,funcs)
  AsyncStringToFile("AppData/logs/DumpedTable.txt",ChoGGi.Temp.TextFile,mode)

  MsgPopup(
    S[302535920000002--[[Dumped: %s--]]]:format(RetName(obj)),
    "AppData/logs/DumpedText.txt",
    nil,
    nil,
    obj
  )
end

do -- DumpTableFunc
  local function RetTextForDump(obj,funcs)
    local obj_type = type(obj)
    if obj_type == "userdata" then
      return T(obj)
    elseif funcs and obj_type == "function" then
      return Concat("Func: \n\n",obj:dump(),"\n\n")
    elseif obj_type == "table" then
      return Concat(tostring(obj)," len: ",#obj)
    else
      return tostring(obj)
    end
  end

  function ChoGGi.ComFuncs.DumpTableFunc(obj,hierarchyLevel,funcs)
    local ChoGGi = ChoGGi
    if (hierarchyLevel == nil) then
      hierarchyLevel = 0
    elseif (hierarchyLevel == 4) then
      return 0
    end

    if type(obj) == "table" then
      if obj.id then
        ChoGGi.Temp.TextFile = Concat(ChoGGi.Temp.TextFile,"\n-----------------obj.id: ",obj.id," :")
      end
      for k,v in pairs(obj) do
        if type(v) == "table" then
          ChoGGi.ComFuncs.DumpTableFunc(v, hierarchyLevel+1)
        else
          if k ~= nil then
            ChoGGi.Temp.TextFile = Concat(ChoGGi.Temp.TextFile,"\n",tostring(k)," = ")
          end
          if v ~= nil then
            ChoGGi.Temp.TextFile = Concat(ChoGGi.Temp.TextFile,RetTextForDump(v,funcs))
          end
          ChoGGi.Temp.TextFile = Concat(ChoGGi.Temp.TextFile,"\n")
        end
      end
    end
  end
end --do

function ChoGGi.ComFuncs.PrintFiles(filename,func,text,...)
  text = text or ""
  ChoGGi.ComFuncs.Dump(Concat(text,...,"\r\n"),nil,filename,"log",true)
  if type(func) == "function" then
    func(...)
  end
end

-- positive or 1 return TrueVar || negative or 0 return FalseVar
-- ChoGGi.Consts.XXX = ChoGGi.ComFuncs.NumRetBool(ChoGGi.Consts.XXX,0,ChoGGi.Consts.XXX)
function ChoGGi.ComFuncs.NumRetBool(num,true_var,false_var)
  if type(num) ~= "number" then
    return
  end
  local bool = true
  if num < 1 then
    bool = false
  end
  return bool and true_var or false_var
end

-- return opposite value or first value if neither
function ChoGGi.ComFuncs.ValueRetOpp(setting,value1,value2)
  if setting == value1 then
    return value2
  elseif setting == value2 then
    return value1
  end
  --just in case
  return value1
end

-- return as num
function ChoGGi.ComFuncs.BoolRetNum(bool)
  if bool == true then
    return 1
  end
  return 0
end

-- toggle 0/1
function ChoGGi.ComFuncs.ToggleBoolNum(n)
  if n == 0 then
    return 1
  end
  return 0
end

-- toggle true/nil (so it doesn't add setting to file as = false
function ChoGGi.ComFuncs.ToggleValue(value)
  if value then
    return
  end
  return true
end

-- return equal or higher amount
function ChoGGi.ComFuncs.CompareAmounts(a,b)
  --if ones missing then just return the other
  if not a then
    return b
  elseif not b then
    return a
  --else return equal or higher amount
  elseif a >= b then
    return a
  elseif b >= a then
    return b
  end
end

-- compares two values, if types are different then makes them both strings
--[[
    if sort[a] and sort[b] then
      return sort[a] < sort[b]
    end
    if sort[a] or sort[b] then
      return sort[a] and true
    end
    return CmpLower(a, b)
--]]

--[[
  table.sort(Items,
    function(a,b)
      return ChoGGi.ComFuncs.CompareTableValue(a,b,"text")
    end
  )
--]]
function ChoGGi.ComFuncs.CompareTableValue(a,b,name)
  if not a and not b then
    return
  end
  if type(a[name]) == type(b[name]) then
    return a[name] < b[name]
  else
    return tostring(a[name]) < tostring(b[name])
  end
end

--[[
table.sort(s.command_centers,
  function(a,b)
    return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",s)
  end
)
--]]
function ChoGGi.ComFuncs.CompareTableFuncs(a,b,func,obj)
  if not a and not b then
    return
  end
  if obj then
    return obj[func](obj,a) < obj[func](obj,b)
  else
    return a[func](a,b) < b[func](b,a)
  end
end

-- write logs funcs
do -- WriteLogs_Toggle
  local function ReplaceFunc(name,which,ChoGGi)
    ChoGGi.ComFuncs.SaveOrigFunc(name)
    _G[name] = function(...)
      ChoGGi.ComFuncs.PrintFiles(which,ChoGGi.OrigFuncs[name],nil,...)
    end
  end
  local function ResetFunc(name,ChoGGi)
    if ChoGGi.OrigFuncs[name] then
      _G[name] = ChoGGi.OrigFuncs[name]
      ChoGGi.OrigFuncs[name] = nil
    end
  end
  function ChoGGi.ComFuncs.WriteLogs_Toggle(which)
    local ChoGGi = ChoGGi
    if which == true then
      -- remove old logs
      local console = "AppData/logs/ConsoleLog.log"
      AsyncCopyFile(console, "AppData/logs/ConsoleLog.previous.log")
      AsyncStringToFile(console,"")

      -- redirect functions
      if ChoGGi.testing then
        ReplaceFunc("dlc_print","ConsoleLog",ChoGGi)
--~         ReplaceFunc("printf","DebugLog",ChoGGi)
--~         ReplaceFunc("DebugPrint","DebugLog",ChoGGi)
--~         ReplaceFunc("OutputDebugString","DebugLog",ChoGGi)
      end
      ReplaceFunc("AddConsoleLog","ConsoleLog",ChoGGi)
      ReplaceFunc("print","ConsoleLog",ChoGGi)
    else
      if ChoGGi.testing then
        ResetFunc("dlc_print",ChoGGi)
--~         ResetFunc("printf",ChoGGi)
--~         ResetFunc("DebugPrint",ChoGGi)
--~         ResetFunc("OutputDebugString",ChoGGi)
      end
      ResetFunc("AddConsoleLog",ChoGGi)
      ResetFunc("print","ConsoleLog",ChoGGi)
    end
  end
end -- do

-- ChoGGi.ComFuncs.PrintIds(Object)
function ChoGGi.ComFuncs.PrintIds(list)
  local text = ""

  for i = 1, #list do
    text = Concat(text,"----------------- ",list[i].id,": ",i,"\n")
    for j = 1, #list[i] do
      text = Concat(text,list[i][j].id,": ",j,"\n")
    end
  end

  ChoGGi.ComFuncs.Dump(text)
end

-- check for and remove broken objects from UICity.labels
function ChoGGi.ComFuncs.RemoveMissingLabelObjects(label)
  local UICity = UICity
  local list = UICity.labels[label] or ""
  for i = #list, 1, -1 do
    if not IsValid(list[i]) then
      table.remove(UICity.labels[label],i)
    end
  end
end

function ChoGGi.ComFuncs.RemoveMissingTableObjects(list,obj)
  if obj then
    for i = #list, 1, -1 do
      if #list[i][list] == 0 then
        table.remove(list,i)
      end
    end
  else
    for i = #list, 1, -1 do
      if not IsValid(list[i]) then
        table.remove(list,i)
      end
    end
  end
  return list
end

function ChoGGi.ComFuncs.RemoveFromLabel(label,obj)
  local UICity = UICity
  local tab = UICity.labels[label] or ""
  for i = 1, #tab do
    if tab[i] and tab[i].handle and tab[i] == obj.handle then
      table.remove(UICity.labels[label],i)
    end
  end
end

function toboolean(str)
  if str:lower() == "true" then
    return true
  elseif str:lower() == "false" then
    return false
  end
end

-- tries to convert "65" to 65, "boolean" to boolean, "nil" to nil, or just returns "str" as "str"
function ChoGGi.ComFuncs.RetProperType(value)
  -- number?
  local num = tonumber(value)
  if num then
    return num
  end
  -- stringy boolean
  if value == "true" then
    return true
  elseif value == "false" then
    return false
  end
  -- nadda
  if value == "nil" then
    return
  end
  -- then it's a string (probably)
  return value
end

-- used to check for some SM objects (Points/Boxes)
function ChoGGi.ComFuncs.RetType(obj)
  if getmetatable(obj) then
    if IsPoint(obj) then
      return "Point"
    end
    if IsBox(obj) then
      return "Box"
    end
  end
end

-- takes "example1 example2" and returns {[1] = "example1",[2] = "example2"}
function ChoGGi.ComFuncs.StringToTable(str)
  local temp = {}
  for i in str:gmatch("%S+") do
    temp[#temp+1] = i
  end
  return temp
end

--~ -- change some annoying stuff about UserActions.AddActions()
--~ local g_idxAction = 0
--~ function ChoGGi.ComFuncs.UserAddActions(actions_to_add)
--~   for k, v in pairs(actions_to_add or empty_table) do
--~     if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
--~       if v.key ~= nil and v.key ~= "" then
--~         if type(v.key) == "table" then
--~           local keys = v.key
--~           if #keys <= 0 then
--~             v.description = ""
--~           else
--~             v.description = Concat(v.description," (",keys[1])
--~             for i = 2, #keys do
--~               v.description = Concat(v.description," ",S[302535920000165--[[or--]]]," ",keys[i])
--~             end
--~             v.description = Concat(v.description,")")
--~           end
--~         else
--~           v.description = Concat(tostring(v.description)," (",v.key,")")
--~         end
--~       end
--~       v.id = k
--~       v.idx = g_idxAction
--~       g_idxAction = g_idxAction + 1
--~       UserActions.Actions[k] = v
--~     else
--~       UserActions.RejectedActions[k] = v
--~     end
--~   end
--~   UserActions_SetMode(UserActions.mode)
--~ end

-- while ChoGGi.ComFuncs.CheckForTypeInList(terminal.desktop,"Examine") do
function ChoGGi.ComFuncs.CheckForTypeInList(list,cls)
  local ret = false
  for i = 1, #list do
    if list[i]:IsKindOf(cls) then
      ret = true
    end
  end
  return ret
end

--[[
ChoGGi.ComFuncs.ReturnTechAmount(Tech,Prop)
returns number from Object (so you know how much it changes)
see: Data/Object.lua, or examine(Object)

ChoGGi.ComFuncs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
^returns 10
ChoGGi.ComFuncs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
^ returns 0.7

it returns percentages in decimal for ease of mathing (SM removed the math.functions from lua)
ie: SupportiveCommunity is -70 this returns it as 0.7
it also returns negative amounts as positive (I prefer num - Amt, not num + NegAmt)
--]]
function ChoGGi.ComFuncs.ReturnTechAmount(tech,prop)
  local techdef = TechDef[tech] or ""
  for i = 1, #techdef do
    if techdef[i].Prop == prop then
      tech = techdef[i]
      local RetObj = {}

      if tech.Percent then
        local percent = tech.Percent
        if percent < 0 then
          percent = percent * -1 -- -50 > 50
        end
        RetObj.p = (percent + 0.0) / 100 -- (50 > 50.0) > 0.50
      end

      if tech.Amount then
        if tech.Amount < 0 then
          RetObj.a = tech.Amount * -1 -- always gotta be positive
        else
          RetObj.a = tech.Amount
        end
      end

      --With enemies you know where they stand but with Neutrals, who knows?
      if RetObj.a == 0 then
        return RetObj.p
      elseif RetObj.p == 0.0 then
        return RetObj.a
      end
    end
  end
end

--[[
  --need to see if research is unlocked
  if IsResearched and UICity:IsTechResearched(IsResearched) then
    --boolean consts
    Value = ChoGGi.ComFuncs.ReturnTechAmount(IsResearched,Name)
    --amount
    Consts["TravelTimeMarsEarth"] = Value
  end
--]]
-- function ChoGGi.ComFuncs.SetConstsG(Name,Value,IsResearched)
function ChoGGi.ComFuncs.SetConstsG(name,value)
  --we only want to change it if user set value
  if value then
    --some mods change Consts or g_Consts, so we'll just do both to be sure
    Consts[name] = value
    g_Consts[name] = value
  end
end

-- if value is the same as stored then make it false instead of default value, so it doesn't apply next time
function ChoGGi.ComFuncs.SetSavedSetting(setting,value)
  local ChoGGi = ChoGGi
  --if setting is the same as the default then remove it
  if ChoGGi.Consts[setting] == value then
    ChoGGi.UserSettings[setting] = nil
  else
    ChoGGi.UserSettings[setting] = value
  end
end

function ChoGGi.ComFuncs.RetTableNoDupes(list)
  local temp_t = {}
  local dupe_t = {}

  for i = 1, #list do
    if not dupe_t[list[i]] then

      temp_t[#temp_t+1] = list[i]
      dupe_t[list[i]] = true

    end
  end

  return temp_t
end

function ChoGGi.ComFuncs.RetTableNoClassDupes(list)
  local ChoGGi = ChoGGi
  table.sort(list,
    function(a,b)
      return ChoGGi.ComFuncs.CompareTableValue(a,b,"class")
    end
  )
  local tempt = {}
  local dupe = {}

  for i = 1, #list do
    if not dupe[list[i].class] then
      tempt[#tempt+1] = list[i]
      dupe[list[i].class] = true
    end
  end
  return tempt
end

-- ChoGGi.ComFuncs.RemoveFromTable(sometable,"class","SelectionArrow")
function ChoGGi.ComFuncs.RemoveFromTable(list,cls,text)
  local tempt = {}
  list = list or ""
  for i = 1, #list do
    if list[i][cls] ~= text then
      tempt[#tempt+1] = list[i]
    end
  end
  return tempt
end

-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Building or "",{ParSystem = true,ResourceStockpile = true},nil,"class")
-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Unit or "",nil,nil,"working")
function ChoGGi.ComFuncs.FilterFromTable(list,exclude_list,include_list,name)
  if #list < 1 then
    return
  end
  return FilterObjects({
    filter = function(o)
      if exclude_list or include_list then
        if exclude_list and include_list then
          if not exclude_list[o[name]] then
            return o
          elseif include_list[o[name]] then
            return o
          end
        elseif exclude_list then
          if not exclude_list[o[name]] then
            return o
          end
        elseif include_list then
          if include_list[o[name]] then
            return o
          end
        end
      else
        if o[name] then
          return o
        end
      end
    end,
  },list)
end

-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Building,"IsKindOf","Residence")
-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Unit or "","IsValid",nil,true)
function ChoGGi.ComFuncs.FilterFromTableFunc(list,func,value,is_bool)
  return FilterObjects({
    filter = function(o)
      if is_bool then
        if _G[func](o) then
          return o
        end
      elseif o[func](o,value) then
        return o
      end
    end
  },list)
end

function ChoGGi.ComFuncs.OpenInMonitorInfoDlg(list,parent)
  if type(list) ~= "table" then
    return
  end

  return ChoGGi_MonitorInfoDlg:new({}, terminal.desktop,{
    object = list,
    parent = parent,
    tables = list.tables,
    values = list.values,
  })
end

function ChoGGi.ComFuncs.OpenInExecCodeDlg(obj,parent)
  if not obj then
    obj = ChoGGi.CodeFuncs.SelObject()
  end
  if not obj then
    return
  end

  return ChoGGi_ExecCodeDlg:new({}, terminal.desktop,{
    obj = obj,
    parent = parent,
  })
end

function ChoGGi.ComFuncs.OpenInObjectManipulator(obj,parent)
  if not obj then
    obj = ChoGGi.CodeFuncs.SelObject()
  end
  if not obj then
    return
  end

  return ChoGGi_ObjectManipulator:new({}, terminal.desktop,{
    obj = obj,
    parent = parent,
  })
end

--[[
get around to merging some of these types into funcs?

custom_type=1 : updates selected item with custom value type, hides ok/cancel buttons, dblclick fires custom_func with self.sel, and sends back all items
custom_type=2 : colour selector
custom_type=3 : updates selected item with custom value type, and sends back selected item.
custom_type=4 : updates selected item with custom value type, and sends back all items
custom_type=5 : for Lightmodel: show colour selector when listitem.editor = color,pressing check2 applies the lightmodel without closing dialog, dbl rightclick shows lightmodel lists and lets you pick one to use in new window
custom_type=6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)
custom_type=7 : dblclick fires custom_func with self.sel

ChoGGi.ComFuncs.OpenInListChoice{
  callback = CallBackFunc,
  items = ItemList,
  title = "Title",
  hint = Concat("Current: ",hint),
  multisel = true,
  custom_type = custom_type,
  custom_func = CustomFunc,
  check1 = "Check1",
  check1_hint = "Check1Hint",
  check1_checked = true,
  check2 = "Check2",
  check2_hint = "Check2Hint",
  check2_checked = true,
}
--]]
function ChoGGi.ComFuncs.OpenInListChoice(list)
  -- if table isn't a table or it doesn't have items/callback func or it has zero items
  if not list or (list and type(list) ~= "table" or not list.callback or not list.items) or #list.items < 1 then
    return
  end

  local ChoGGi = ChoGGi

  --sort table by display text
  if not list.skip_sort then
    local sortby = list.sortby or "text"
    table.sort(list.items,
      function(a,b)
        return ChoGGi.ComFuncs.CompareTableValue(a,b,sortby)
      end
    )
  end

  --only insert blank item if we aren't updating other items with it
  if not list.custom_type then
    --insert blank item for adding custom value
    list.items[#list.items+1] = {text = "",hint = "",value = false}
  end

  local dlg = ChoGGi_ListChoiceCustomDialog:new({}, terminal.desktop,{
    list = list,
  })

  if not dlg then
    return
  end

  -- fires callback func when dialog closes
  CreateRealTimeThread(function()
    --waiting for choice
    local option = dlg.idDialog:Wait()

    if option and #option > 0 then
      list.callback(option)
    end
  end)

--~   -- if anything is hidden this makes it so we don't have a bunch of blank areas.
--~   dlg:UpdateElementPositions()

  return dlg
end

-- returns table with list of files without path or ext and path, or exclude ext to return all files
function ChoGGi.ComFuncs.RetFilesInFolder(folder,ext)
  local err, files = AsyncListFiles(folder,ext and Concat("*",ext) or "*")
  if not err and #files > 0 then
    local table_path = {}
    local path = Concat(folder,"/")
    for i = 1, #files do
      local name
      if ext then
        name = files[i]:gsub(path,""):gsub(ext,"")
      else
        name = files[i]:gsub(path,"")
      end
      table_path[#table_path+1] = {
        path = files[i],
        name = name,
      }
    end
    return table_path
  end
end

function ChoGGi.ComFuncs.RetFoldersInFolder(folder)
  --local err, folders = AsyncListFiles(Folder, "*", "recursive,folders")
  local err, folders = AsyncListFiles(folder,"*","folders")
  if not err and #folders > 0 then
    local table_path = {}
    local temp_path = Concat(folder,"/")
    for i = 1, #folders do
      table_path[#table_path+1] = {
        path = folders[i],
        name = folders[i]:gsub(temp_path,""),
      }
    end
    return table_path
  end
end

-- i keep forgetting this so, i'm adding it here
function ChoGGi.ComFuncs.HandleToObject(h)
  return HandleToObject[h]
end

function ChoGGi.ComFuncs.DialogUpdateMenuitems(parent)
  parent:CreateDropdownBox()

  local list = parent.list
  list:SetBackgroundColor(RGB(125,125,125))

  --of course combomenu sets the scrollbar images to blank, why not...
  list:SetScrollBackImage("CommonAssets/UI/Controls/ScrollBar/scroll_back_vertical.tga")
  list:SetScrollButtonImage("CommonAssets/UI/Controls/ScrollBar/scroll_buttons_vertical.tga")
  list:SetScrollThumbImage("CommonAssets/UI/Controls/ScrollBar/scroll_thumb_vertical.tga")

  --loop through and set hints (sure would be nice to have List do that for you)
  local windows = list.item_windows
  for i = 1, #windows do
    windows[i].orig_OnSetState = windows[i].OnSetState
    windows[i].OnSetState = function(self, list, item, rollovered, selected)
      if self.RolloverText ~= "" and (selected or rollovered) then
        CreateRolloverWindow(self.parent, self.RolloverText)
      end
      return self.orig_OnSetState(self,list, item, rollovered, selected)
    end
  end
end

-- return a string setting/text for menus
function ChoGGi.ComFuncs.SettingState(setting,text)
  -- have it return false instead of nil
  if type(setting) == "nil" then
    setting = false
  end

  return Concat(setting,": ",ChoGGi.ComFuncs.CheckText(S[text],text))
end

-- Copyright L. H. de Figueiredo, W. Celes, R. Ierusalimschy: Lua Programming Gems
function ChoGGi.ComFuncs.VarDump(value, depth, key)
  local ChoGGi = ChoGGi
  local linePrefix = ""
  local spaces = ""
  local v_type = type(value)
  if key ~= nil then
    linePrefix = "["..key.."] = "
  end
  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for _ = 1, depth do
      spaces = Concat(spaces," ")
    end
  end
  if v_type == "table" then
    local mTable = getmetatable(value)
    if mTable == nil then
      print(Concat(spaces,linePrefix,"(table) "))
    else
      print(Concat(spaces,"(metatable) "))
      value = mTable
    end
    for tableKey, tableValue in pairs(value) do
      ChoGGi.ComFuncs.VarDump(tableValue, depth, tableKey)
    end
  elseif v_type == "function"
    or v_type == "thread"
    or v_type == "userdata"
    or value == nil
    then
      print(Concat(spaces,tostring(value)))
  else
    print(Concat(spaces,linePrefix,"(",v_type,") ",tostring(value)))
  end
end


function ChoGGi.ComFuncs.RetBuildingPermissions(traits,settings)
  local block = false
  local restrict = false

  local rtotal = 0
  for _,_ in pairs(settings.restricttraits or empty_table) do
    rtotal = rtotal + 1
  end

  local rcount = 0
  for trait,_ in pairs(traits or empty_table) do
    if settings.restricttraits[trait] then
      rcount = rcount + 1
    end
    if settings.blocktraits[trait] then
      block = true
    end
  end
  --restrict is empty so allow all or since we're restricting then they need to be the same
  if not next(settings.restricttraits) or rcount == rtotal then
    restrict = true
  end

  return block,restrict
end

-- get all objects, then filter for ones within *radius*, returned sorted by dist, or *sort* for name
-- OpenExamine(ChoGGi.CodeFuncs.ReturnAllNearby(1000,"class"))
function ChoGGi.ComFuncs.ReturnAllNearby(radius,sort,pos)
  radius = radius or 5000
  pos = pos or GetTerrainCursor()

  -- get all objects on map (18K+ on a new map)
  local list = GetObjects{
    -- we only want stuff within *radius*
    filter = function(o)
      if o:GetDist2D(pos) <= radius then
        return o
      end
    end,
  }

  -- sort list custom
  if sort then
    table.sort(list,
      function(a,b)
        return a[sort] < b[sort]
      end
    )
  else
    -- sort nearest
    table.sort(list,
      function(a,b)
        return a:GetDist2D(pos) < b:GetDist2D(pos)
      end
    )
  end

  return list
end

function ChoGGi.ComFuncs.RetObjectAtPos(pos,q,r)
  if pos then
    q, r = WorldToHex(pos or GetTerrainCursor())
  end
  return HexGridGetObject(ObjectGrid, q, r)
end

function ChoGGi.ComFuncs.RetObjectsAtPos(pos,q,r)
  if pos then
    q, r = WorldToHex(pos or GetTerrainCursor())
  end
  return HexGridGetObjects(ObjectGrid, q, r)
end

function ChoGGi.ComFuncs.RetSortTextAssTable(list,for_type)
  local temp_table = {}

  --add
  if for_type then
    for k,_ in pairs(list or empty_table) do
      temp_table[#temp_table+1] = k
    end
  else
    for _,v in pairs(list or empty_table) do
      temp_table[#temp_table+1] = v
    end
  end
  table.sort(temp_table)
  --and send back sorted
  return temp_table
end

-- Haemimont Games code from examine.lua (moved here for local)
function OpenExamine(obj, parent, return_dlg)
  local ChoGGi = ChoGGi
  if not obj then
    return ChoGGi.ComFuncs.ClearShowMe()
  end

  local dlg = Examine:new({}, terminal.desktop,{
    obj = obj,
    parent = parent,
  })

  if return_dlg then
    return dlg
  end
end
local OpenExamine = OpenExamine

ex = OpenExamine
function OpenExamineRet(obj, parent)
  return OpenExamine(obj, parent, true)
end

--~ local lm = false
markers = {}
function ChoGGi.ComFuncs.ClearShowMe()
  pcall(function()
    for k, v in pairs(markers) do
      if IsValid(k) then
        if v == "point" then
          k:delete()
        else
          k:SetColorModifier(v)
        end
        markers[k] = nil
      end
    end
  end)
end

local times = {}
function ChoGGi.ComFuncs.TickStart(id)
  times[id] = GetPreciseTicks()
end
function ChoGGi.ComFuncs.TickEnd(id)
  print(id,": ",GetPreciseTicks() - times[id])
  times[id] = nil
end

function ChoGGi.ComFuncs.SelectConsoleLogText()
  local dlgConsoleLog = dlgConsoleLog
  if not dlgConsoleLog then
    return
  end
  local text = dlgConsoleLog.idText:GetText()
  if text:len() == 0 then
    print(S[302535920000692--[[Log is blank (well not anymore).--]]])
    return
  end
  local dialog = ChoGGi_MultiLineText:new({}, terminal.desktop,{
    wrap = true,
    text = text,
  })
--~   dialog:Open()
end

function ChoGGi.ComFuncs.ShowConsoleLogWin(visible)
  if visible and not dlgChoGGi_ConsoleLogWin then
    dlgChoGGi_ConsoleLogWin = ChoGGi_ConsoleLogWin:new({}, terminal.desktop,{})

    --update it with console log text
    local dlg = dlgConsoleLog
    if dlg then
      dlgChoGGi_ConsoleLogWin.idText:SetText(dlg.idText:GetText())
    else
      --if for some reason consolelog isn't around, then grab the log file
      dlgChoGGi_ConsoleLogWin.idText:SetText(select(2,AsyncFileToString(GetLogFile())))
    end

  end

  local dlg = dlgChoGGi_ConsoleLogWin
  if dlg then
    dlg:SetVisible(visible)

    --size n position
    local size = ChoGGi.UserSettings.ConsoleLogWin_Size
    local pos = ChoGGi.UserSettings.ConsoleLogWin_Pos
    --make sure dlg is within screensize
    if size then
      dlg:SetSize(size)
    end
    if pos then
      dlg:SetPos(pos)
    else
      dlg:SetPos(point(100,100))
    end

  end
end

function ChoGGi.ComFuncs.UpdateDataTables(cargo_update)
  local ChoGGi = ChoGGi
  local Nations = Nations
  local DataInstances = DataInstances
  local g_Classes = g_Classes

  if #const.SchoolTraits < 5 then
    ChoGGi.Tables.SchoolTraits = const.SchoolTraits
  else
    ChoGGi.Tables.SchoolTraits = {"Nerd","Composed","Enthusiast","Religious","Survivor"}
  end
  if #const.SanatoriumTraits < 7 then
    ChoGGi.Tables.SanatoriumTraits = const.SanatoriumTraits
  else
    ChoGGi.Tables.SanatoriumTraits = {"Alcoholic","Gambler","Glutton","Lazy","ChronicCondition","Melancholic","Coward"}
  end

  -- mysteries
  ChoGGi.Tables.Mystery = {}

  --build mysteries list (sometimes we need to reference Mystery_1, sometimes BlackCubeMystery
  ClassDescendantsList("MysteryBase",function(class)
    local scenario_name = g_Classes[class].scenario_name or S[302535920000009--[[Missing Scenario Name--]]]
    local display_name = T(g_Classes[class].display_name) or S[302535920000010--[[Missing Name--]]]
    local description = T(g_Classes[class].rollover_text) or S[302535920000011--[[Missing Description--]]]

    local temptable = {
      class = class,
      number = scenario_name,
      name = display_name,
      description = description
    }
    --we want to be able to access by for loop, Mystery 7, and WorldWar3
    ChoGGi.Tables.Mystery[scenario_name] = temptable
    ChoGGi.Tables.Mystery[class] = temptable
    ChoGGi.Tables.Mystery[#ChoGGi.Tables.Mystery+1] = temptable
  end)

  -- colonists
  ChoGGi.Tables.ColonistBirthplaces = {}
  ChoGGi.Tables.NegativeTraits = {}
  ChoGGi.Tables.PositiveTraits = {}
  ChoGGi.Tables.OtherTraits = {}
  ChoGGi.Tables.ColonistAges = {}
  ChoGGi.Tables.ColonistGenders = {}
  ChoGGi.Tables.ColonistSpecializations = {}

  --add as index and associative tables for ease of filtering
  for _,t in pairs(DataInstances.Trait) do
    if t.category == "Positive" then
      ChoGGi.Tables.PositiveTraits[#ChoGGi.Tables.PositiveTraits+1] = t.name
      ChoGGi.Tables.PositiveTraits[t.name] = true
    elseif t.category == "Negative" then
      ChoGGi.Tables.NegativeTraits[#ChoGGi.Tables.NegativeTraits+1] = t.name
      ChoGGi.Tables.NegativeTraits[t.name] = true
    elseif t.category == "other" then
      ChoGGi.Tables.OtherTraits[#ChoGGi.Tables.OtherTraits+1] = t.name
      ChoGGi.Tables.OtherTraits[t.name] = true
    elseif t.category == "Age Group" then
      ChoGGi.Tables.ColonistAges[#ChoGGi.Tables.ColonistAges+1] = t.name
      ChoGGi.Tables.ColonistAges[t.name] = true
    elseif t.category == "Gender" then
      ChoGGi.Tables.ColonistGenders[#ChoGGi.Tables.ColonistGenders+1] = t.name
      ChoGGi.Tables.ColonistGenders[t.name] = true
    elseif t.category == "Specialization" and t.name ~= "none" then
      ChoGGi.Tables.ColonistSpecializations[#ChoGGi.Tables.ColonistSpecializations+1] = t.name
      ChoGGi.Tables.ColonistSpecializations[t.name] = true
    end
  end

  for i = 1, #Nations do
    ChoGGi.Tables.ColonistBirthplaces[#ChoGGi.Tables.ColonistBirthplaces+1] = Nations[i].value
    ChoGGi.Tables.ColonistBirthplaces[Nations[i].value] = true
  end

  table.sort(ChoGGi.Tables.ColonistBirthplaces)
  table.sort(ChoGGi.Tables.NegativeTraits)
  table.sort(ChoGGi.Tables.PositiveTraits)
  table.sort(ChoGGi.Tables.OtherTraits)
  table.sort(ChoGGi.Tables.ColonistAges)
  table.sort(ChoGGi.Tables.ColonistGenders)
  table.sort(ChoGGi.Tables.ColonistSpecializations)

  -- easier access to cargo
  ChoGGi.Tables.Cargo = {}
  ChoGGi.Tables.CargoPresets = {}

  -- only called when ResupplyItemDefinitions is built
  if cargo_update == true then
    local ResupplyItemDefinitions = ResupplyItemDefinitions
    for i = 1, #ResupplyItemDefinitions do
      local meta = getmetatable(ResupplyItemDefinitions[i]).__index
      ChoGGi.Tables.Cargo[i] = meta
      ChoGGi.Tables.Cargo[meta.id] = meta
    end

    -- just used to check defaults for cargo
    local preset = Presets.Cargo
    for i = 1, #preset do
      for j = 1, #preset[i] do
        local c = preset[i][j]
        ChoGGi.Tables.CargoPresets[#ChoGGi.Tables.CargoPresets+1] = c
        ChoGGi.Tables.CargoPresets[c.id] = c
      end
    end
  end
end

function ChoGGi.ComFuncs.Random(m, n)
  -- m = min, n = max
  if n then

--~     -- return nil instead of just returning max without any randomness
--~     if n-m < 0 then
--~       return
--~     end

    return AsyncRand(n - m + 1) + m

  else
    -- m = max, min = 0 OR number between 0 and max_int
    return m and AsyncRand(m) or AsyncRand()
  end
end

function ChoGGi.ComFuncs.GetObjects(query, obj, query_width, ignore_classes)
  if type(query) ~= "table" then
    return GetObjects{class = query}
  end
  -- ForEach,CountObjects
  return GetObjects({
    class = query.class,
    classes = query.classes,
    area = query.area,
    areapoint1 = query.areapoint1,
    areapoint2 = query.areapoint2,
    arearadius = query.arearadius,
    areafilter = query.areafilter,
    hexradius = query.hexradius,
    collection = query.collection,
    attached = query.attached,
    recursive = query.recursive,
    enum_flags_any = query.enum_flags_any,
    game_flags_all = query.game_flags_all,
    class_flags_all = query.class_flags_all,
    filter = query.filter,
  }, obj, query_width, ignore_classes)
--~     area = "line",
--~ "realm" = every object
--~ "outsiders" = prefab markers
--~ "detached" = invalid positions
--~ "line" = ?
--~     areapoint1 = self.point0,
--~     areapoint2 = self.point1,
--~     arearadius = 100,
--~       areafilter = function(o)
--~         return o:GetParent() == nil
--~       end,
--~     class = "Object",
--~     classes = {"EditorDummy","Text"},
--~     hexradius = self.exploitation_radius,
--~     collection = self.Index,
--~     attached = false,
--~     recursive = true,
--~     enum_flags_any = const.efBakedTerrainDecal,
--~     class_flags_all = const.cfLuaObject,
--~     game_flags_all = const.gofPermanent,
--~     filter = function(o)
--~       return not IsKindOf(o, "Collection")
--~     end,

end
