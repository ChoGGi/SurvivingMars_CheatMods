--for redirecting print/ConsolePrint to consolelog
function ChoGGi.ReplacedFunc.print(...)
  if ... then
    AddConsoleLog(...,true)
  end
  ChoGGi.OrigFunc.print(...)
end

function ChoGGi.ReplacedFunc.ConsolePrint(...)
  if ... then
    AddConsoleLog(...,true)
  end
  ChoGGi.OrigFunc.ConsolePrint(...)
end

--output results to console
ChoGGi.OrigFunc.print = print
ChoGGi.OrigFunc.ConsolePrint = ConsolePrint
print = ChoGGi.ReplacedFunc.print
ConsolePrint = ChoGGi.ReplacedFunc.ConsolePrint

--make some easy to type names
function console(...)
  ConsolePrint(tostring(...))
end

sm = SelectionMouseObj
st = GetTerrainCursorObjSel
cur = GetTerrainCursorObjSel
sp = GetPreciseCursorObj
sc = GetTerrainCursor
--[[
Selection
SelectionAdd
SelectionRemove
--]]
function dumplua(...)
  ChoGGi.Dump(TupleToLuaCode(...))
end
function restart()
  quit("restart")
end
function examine(Obj)
  OpenExamine(Obj)
end
ex = examine
dump = ChoGGi.Dump
dumpobject = ChoGGi.DumpObject
dumpo = ChoGGi.DumpObject
dumptable = ChoGGi.DumpTable
dumpt = ChoGGi.DumpTable
alert = ChoGGi.MsgPopup
exit = quit
reboot = restart
trans = _InternalTranslate

--change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function ChoGGi.UserAddActions(ActionsToAdd)
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


--RemoveBuildingLimits
function OnMsg.ClassesBuilt()

  --save teh OrigFuncs
  --so we can build without (as many) limits
  ChoGGi.OrigFunc.CC_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
  --so we can do long spaced tunnels
  ChoGGi.OrigFunc.TC_UpdateConstructionStatuses = TunnelConstructionController.UpdateConstructionStatuses
--[[
  sometimes gets stuck in placement mode when placing domes (and others, but usually domes), so I changed
    if st.short then
  to
    if st and st.short then
--]]
  ChoGGi.OrigFunc.CC_UpdateShortConstructionStatus = ConstructionController.UpdateShortConstructionStatus
  --doesn't cause any real problems, but it does spam the log with st.test missing, so I did the same as UpdateShortConstructionStatus
  ChoGGi.OrigFunc.CC_Getconstruction_statuses_property = ConstructionController.Getconstruction_statuses_property

  --replace teh OrigFuncs
  if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then

    function ConstructionController:UpdateConstructionStatuses(dont_finalize)
      pcall(function()
        ChoGGi.OrigFunc.CC_UpdateConstructionStatuses(self,dont_finalize)
      end)
      --remove errors we want to remove
      local status = self.construction_statuses
      if #status > 0 then
        for i = 1, #status do
          if ChoGGi.ConstructionSkipErrors[_InternalTranslate(status[i].short)] then
            status[i] = nil
          end
        end
      end
    end --ConstructionController

    --we only want to block uneven terrain
    function TunnelConstructionController:UpdateConstructionStatuses(pt)
      local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
      local status = self.construction_statuses
      if #status > 0 then
        for i = 1, #status do
          if ChoGGi.ConstructionSkipErrors[_InternalTranslate(status[i].short)] then
            status[i] = nil
          end
        end
      end
      self:FinalizeStatusGathering(old_t)
    end --TunnelConstructionController

    function ConstructionController:UpdateShortConstructionStatus()
    --ChoGGi.OrigFunc.CC_UpdateShortConstructionStatus
      local dlg = GetDialog("HUD")
      if not dlg then
        return
      end
      local ctrl = dlg.idtxtConstructionStatus
      local text = ""
      if #self.construction_statuses > 0 then
        for i = 1, #self.construction_statuses do
          local st = self.construction_statuses[i]
          if st and st.short then
            text = T({878,"<col><short></color>",col = ConstructionStatusColors[st.type].color_tag_short,st})
            break
          end
        end
      end
      ctrl:SetText(text)
      ctrl:SetVisible(text ~= "")
      ctrl:SetMargins(box(-ctrl.text_width / 2, 30, 0, 0))
      return text, ctrl
    end --UpdateShortConstructionStatus

    function ConstructionController:Getconstruction_statuses_property()
      local items = {}
      if #self.construction_statuses > 0 then
        for i = 1, Min(#self.construction_statuses, 2) do
          local st = self.construction_statuses[i]
          if st and st.text then
            items[#items + 1] = T({879,"<col><text></color>",col = ConstructionStatusColors[st.type].color_tag,text = st.text})
          end
        end
        if #self.construction_statuses < 2 then
          local constr_dlg = GetInGameInterface() and GetInGameInterface().mode_dialog
          if constr_dlg and constr_dlg.class == "ConstructionModeDialog" and constr_dlg.params and constr_dlg.params.passengers then
            local domes = GetDomesInWalkableDistance(UICity, self.cursor_obj:GetPos())
            items[#items + 1] = T({7688,"<green>Domes in walkable distance: <number></color></shadowcolor>",number = #domes})
          end
        end
      else
        local constr_dlg = GetInGameInterface() and GetInGameInterface().mode_dialog
        if constr_dlg and constr_dlg.class == "ConstructionModeDialog" and constr_dlg.params and constr_dlg.params.passengers then
          local domes = GetDomesInWalkableDistance(UICity, self.cursor_obj:GetPos())
          items[#items + 1] = T({7688,"<green>Domes in walkable distance: <number></color></shadowcolor>",number = #domes})
        else
          items[#items + 1] = T({880,"<color 138 223 47>All Clear!</color>"})
        end
      end
      return table.concat(items, "\n")
    end --Getconstruction_statuses_property

  end --if

  --was giving a nil error in log, I assume devs'll fix it one day (changed amount to amount or 0)
  function RequiresMaintenance:AddDust(amount)
    if self:IsKindOf("Building") then
      amount = MulDivRound(amount or 0, g_Consts.BuildingDustModifier, 100)
    end
    if self.accumulate_dust then
      self:AccumulateMaintenancePoints(amount)
    end
  end
end --OnMsg

--[[
  CityConstruction[UICity] = ConstructionController:new()
  CityGridConstruction[UICity] = GridConstructionController:new()
  CityGridSwitchConstruction[UICity] = GridSwitchConstructionController:new()
  CityTunnelConstruction[UICity] = TunnelConstructionController:new()
  CityUnitController[UICity] = UnitController:new()
IGIModeClasses = {
    construction = ConstructionModeDialog
    demolish = DemolishModeDialog
    electricity_grid = GridConstructionDialog
    electricity_switch = GridSwitchConstructionDialog
    hex_painter = HexPainterModeDialog
    life_support_grid = GridConstructionDialogPipes
    lifesupport_switch = GridSwitchConstructionDialogPipes
    overview = OverviewModeDialog
    selection = SelectionModeDialog
    tunnel_construction = TunnelConstructionDialog
    unit_direction_internal_use_only = UnitDirectionModeDialog
}
--]]


--[[
  XMultiLineEdit < make console multilined?


    function Console.children[2].OnKbdKeyUp()
    GetText()
    SetCursorPos()
    end
    function Console.children[2].OnKbdKeyDown()

    end
    dlgConsole.autoCompleteList = {"Consts"}
    dlgConsole:UpdateAutoCompleteList()
    dlgConsole:visible =

  ChoGGi.OrigFunc.ConsoleShow = Console.Show
  function Console.Show(bShow)
    ChoGGi.OrigFunc.ConsoleShow(bShow)
    local c = dlgConsole
    --set console how I like it
    if ChoGGi.Testing then
      local l = dlgConsoleLog
      local size = UIL.GetSafeArea()
      local w = size:sizex() / 3
      local h = size:sizey()
      if w > 100 or h > 100 then
        c:GetSize():y()
        c:SetPos(point(320,h - c:GetSize():y() - 8))
        c:SetSize(point(w - 325,24))
        l:SetTextOffset(point(16,h - 32))
        l:SetPos(point(512,48))
        l:SetSize(point(1920 - 512 - 16,h - 32 - 48 - 16))
      end
    end

    --console settings
    c.children[2].cursor_blink_time = 196
    --dlgConsole.children[2].auto_select_all = false
  end

  --move the log window a bit
  function ConsoleLog.Resize()
    local self = dlgConsoleLog

    local size = UIL.GetSafeArea()
    local w = size:sizex()
    local h = size:sizey()
    if w < 100 or h < 100 then
      return
    end
    self:SetSize(point(
      w - 8,
      h - 44 - VirtualKeyboardHeight() - (h - 44) % self:GetFontHeight())
    )
    self:SetTextOffset(point(0, self:GetSize():y() - self:GetTextHeight()))
    self:SetPos(point(size:minx() + 4, size:miny() + 4))
  end
  --]]

function OnMsg.ClassesGenerate()
--[[
--dumpo(classdefs)
dumpt(classdefs)
dumpl(classdefs)
--]]

--CommonLua\UI\uiExamine.lua
--CommonLua\UI\uiExamine.designer.lua
  --add dump button to Examine windows
  function ExamineDesigner:Init()
    self:SetPos(point(278, 191))
    self:SetTranslate(false)
    self:SetMinSize(point(309, 53))
    self:SetMovable(true)
    self:SetSize(point(372, 459))
    self:SetZOrder(10000)
    local win

    win = StaticText:new(self)
    win:SetId("idText")
    win:SetPos(point(283, 306))
    win:SetSize(point(362, 332))
    win:SetHSizing("Resize")
    win:SetVSizing("Resize")
    win:SetBackgroundColor(RGBA(0, 0, 0, 16))
    win:SetFontStyle("Editor12Bold")
    win:SetScrollBar(true)

    win = StaticText:new(self)
    win:SetId("idMenu")
    win:SetPos(point(283, 217))
    win:SetSize(point(362, 52))
    win:SetHSizing("Resize")
    win:SetBackgroundColor(RGBA(0, 0, 0, 16))
    win:SetFontStyle("Editor12Bold")

    win = SingleLineEdit:new(self)
    win:SetId("idFilter")
    win:SetPos(point(283, 275))
    win:SetSize(point(306, 26))
    win:SetHSizing("Resize")
    win:SetBackgroundColor(RGBA(0, 0, 0, 16))
    win:SetFontStyle("Editor12Bold")

    win = Button:new(self)
    win:SetId("idClose")
    win:SetPos(point(597, 191))
    win:SetSize(point(50, 24))
    win:SetHSizing("AnchorToRight")
    win:SetText(Untranslated("Close"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))

    win = Button:new(self)
    win:SetId("idNext")
    win:SetPos(point(592, 275))
    win:SetSize(point(53, 26))
    win:SetText(Untranslated("Next"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))

    win = Button:new(self)
    win:SetId("idDump")
    win:SetPos(point(290, 275))
    win:SetSize(point(53, 26))
    win:SetText(Untranslated("Dump"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
--[[
    win = Button:new(self)
    win:SetId("idEdit")
    win:SetPos(point(350, 275))
    win:SetSize(point(53, 26))
    win:SetText(Untranslated("Edit"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
--]]
    self:InitChildrenSizing()
  end

  function Examine:Init()
    self.Dump = function(String)
      --remove html tags
      String = String:gsub("<[/%s%a%d]*>","")
      ChoGGi.Dump(String,nil,"DumpedExamine","lua")
    end
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
    function self.idDump.OnButtonPressed()
      self.Dump(self:totextex(self.obj) .. "\n")
    end
--[[
    function self.idEdit.OnButtonPressed()
      OpenManipulator(self.obj,self)
    end
--]]
    self.idFilter:AddInterpolation({
      type = const.intAlpha,
      startValue = 255,
      flags = const.intfIgnoreParent
    })
    function self.idFilter.OnValueChanged(this, value)
      self:FindNext(value)
    end
    function self.idFilter.OnKbdKeyDown(_, char, virtual_key)
      if virtual_key == const.vkEnter then
        self:FindNext(self.idFilter:GetText())
        return "break"
      end
      StaticText.OnKbdKeyDown(self, char, virtual_key)
    end
    function self.idClose.OnButtonPressed()
      self:delete()
    end
    self:SetTranspMode(self.transp_mode)
  end

end --OnMsg

if ChoGGi.Testing then
  table.insert(ChoGGi.FilesCount,"ReplacedFunctions")
end
