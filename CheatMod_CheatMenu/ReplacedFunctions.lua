--make some easy to type names
function console(...)
  ConsolePrint(tostring(...))
end
function dumplua(Value)
  ChoGGi.Dump("\r\n" .. ValueToLuaCode(Value),nil,"DumpedLua","lua")
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
con = console
mh = GetTerrainCursorObjSel
mc = GetPreciseCursorObj
m = SelectionMouseObj
c = GetTerrainCursor
cs = terminal.GetMousePos --pos on screen, not map

--add dump buttons/etc
ChoGGi.OrigFunc.Examine_Init = Examine.Init
function Examine:Init()
  ChoGGi.OrigFunc.Examine_Init(self)

  self.DumpText = function(Obj)
    local String = self:totextex(Obj)
    --remove html tags
    String = String:gsub("<[/%s%a%d]*>","")
    ChoGGi.Dump("\r\n" .. String,nil,"DumpedExamine","lua")
  end
  self.DumpObj = function(Obj)
    --dump object code
    ChoGGi.Dump("\r\n" .. ValueToLuaCode(Obj),nil,"DumpedExamineObject","lua")
  end
  function self.idDump.OnButtonPressed()
    self.DumpText(self.obj)
  end
  function self.idDumpObj.OnButtonPressed()
    self.DumpObj(self.obj)
  end
--[[
  function self.idEdit.OnButtonPressed()
    OpenManipulator(self.obj,self)
  end
--]]
end

--so we can add hints to info pane cheats
ChoGGi.OrigFunc.InfopanelObj_CreateCheatActions = InfopanelObj.CreateCheatActions
function InfopanelObj:CreateCheatActions(win)
  local ret = ChoGGi.OrigFunc.InfopanelObj_CreateCheatActions(self,win)
  ChoGGi.SetHintsInfoPaneCheats(GetActionsHost(win),win)
  if ret then
    return ret
  end
end

--make sure console is focused even when construction is opened
ChoGGi.OrigFunc.Console_Show = Console.Show
function Console:Show(show)
  local was_visible = self:GetVisible()
  self:SetVisible(show)
  ShowConsoleLogBackground(show)
  if show and not was_visible then
    self.idEdit:SetFocus()
    self.idEdit:SetText("")
    self:ReadHistory()
    --always on top
    self:SetModal()
  end
  if not show then
    self:CloseAutoComplete()
    --always on top
    self:SetModal(false)
  end
end

--always able to show console
ChoGGi.OrigFunc.ShowConsole = ShowConsole
function ShowConsole(visible)
--[[remvoed from orig func
  if not Platform.developer and not ConsoleEnabled then
    return
  end
--]]
  if visible and not rawget(_G, "dlgConsole") then
    CreateConsole()
  end
  if rawget(_G, "dlgConsole") then
    dlgConsole:Show(visible)
  end
end

--ugly way of making sure console doesn't include ` when using tilde to open console
ChoGGi.OrigFunc.Console_TextChanged = Console.TextChanged
function Console:TextChanged()
  ChoGGi.OrigFunc.Console_TextChanged(self)
  if self.idEdit:GetText() == "`" then
    self.idEdit:SetText("")
  end
end

--make it so it goes to the end of the text when you use history
ChoGGi.OrigFunc.Console_HistoryDown = Console.HistoryDown
function Console:HistoryDown()
  ChoGGi.OrigFunc.Console_HistoryDown(self)
  self.idEdit:SetCursorPos(#self.idEdit:GetText())
end

ChoGGi.OrigFunc.Console_HistoryUp = Console.HistoryUp
function Console:HistoryUp()
  ChoGGi.OrigFunc.Console_HistoryUp(self)
  self.idEdit:SetCursorPos(#self.idEdit:GetText())
end

--some dev removed this from the Spirit update... (harumph)
function AddConsolePrompt(text)
  if dlgConsole then
    local self = dlgConsole
    self:Show(true)
    self.idEdit:Replace(self.idEdit.cursor_pos, self.idEdit.cursor_pos, text, true)
    self.idEdit:SetCursorPos(#text)
  end
end

--toggle visiblity of console log
--(ok, so it isn't a replaced func, but all the other console stuff is here)
function ToggleConsoleLog()
  if dlgConsoleLog then
    local isVis = dlgConsoleLog:GetVisible()
    if isVis then
      dlgConsoleLog:SetVisible(false)
    else
      dlgConsoleLog:SetVisible(true)
    end
  else
    dlgConsoleLog = ConsoleLog:new({}, terminal.desktop)
  end
end

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

--RemoveBuildingLimits
function ChoGGi.ReplacedFunctions_ClassesBuilt()

  if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then

    --so we can build without (as many) limits
    ChoGGi.OrigFunc.CC_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
    function ConstructionController:UpdateConstructionStatuses(dont_finalize)
      --send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
      ChoGGi.OrigFunc.CC_UpdateConstructionStatuses(self,"dont_finalize")

      --CityConstruction[UICity].construction_statuses

      local status = self.construction_statuses

      if self.is_template then
        local cobj = rawget(self.cursor_obj, true)
        local tobj = setmetatable({
          [true] = cobj,
          ["city"] = UICity
        }, {
          __index = self.template_obj
        })
        tobj:GatherConstructionStatuses(self.construction_statuses)
      end

      --remove errors we want to remove
      local statusNew = {}
      if #status > 0 then
        for i = 1, #status do
          if status[i].type == "warning" then
            table.insert(statusNew,status[i])
          --UnevenTerrain < causes issues when placing buildings (martian ground viagra)
          --ResourceRequired < no point in building an extractor when there's nothing to extract
          --BlockingObjects < place buildings in each other
          elseif status[i] == ConstructionStatus.UnevenTerrain then
            table.insert(statusNew,status[i])
          end
        end
      end
      --make sure we don't get errors down the line
      if type(statusNew) == "boolean" then
        statusNew = {}
      end

      self.construction_statuses = statusNew
      status = self.construction_statuses


      if not dont_finalize then
        self:FinalizeStatusGathering(status)
      else
        return status
      end

    end --ConstructionController:UpdateConstructionStatuses

    --so we can do long spaced tunnels
    ChoGGi.OrigFunc.TC_UpdateConstructionStatuses = TunnelConstructionController.UpdateConstructionStatuses
    function TunnelConstructionController:UpdateConstructionStatuses(pt)
      local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
      --[[
      if self.placed_obj and not IsCloser2D(self.placed_obj, self.cursor_obj, self.max_range * const.GridSpacing) then
        table.insert(self.construction_statuses, ConstructionStatus.TooFarFromTunnelEntrance)
      end
      --]]
      self:FinalizeStatusGathering(old_t)
    end --TunnelConstructionController:UpdateConstructionStatuses

--[[
    --sometimes gets stuck in placement mode when placing domes (and others, but usually domes), so I changed
    ChoGGi.OrigFunc.CC_UpdateShortConstructionStatus = ConstructionController.UpdateShortConstructionStatus
    function ConstructionController:UpdateShortConstructionStatus()
      local dlg = GetDialog("HUD")
      if not dlg then
        return
      end
      local ctrl = dlg.idtxtConstructionStatus
      local text = ""
      if #self.construction_statuses > 0 then
      local st
        for i = 1, #self.construction_statuses do
          st = self.construction_statuses[i]
          -- (dev check)
          --if st.short then
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
    end --ConstructionController:UpdateShortConstructionStatus

    --doesn't cause any real problems, but it does spam the log with st.test missing, so I did the same as UpdateShortConstructionStatus
    ChoGGi.OrigFunc.CC_Getconstruction_statuses_property = ConstructionController.Getconstruction_statuses_property
    function ConstructionController:Getconstruction_statuses_property()
      local items = {}
      if #self.construction_statuses > 0 then
        for i = 1, Min(#self.construction_statuses, 2) do
          local st = self.construction_statuses[i]
          -- (dev check)
          --if st.text then
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
    end --ConstructionController:Getconstruction_statuses_property

    --doesn't cause any real problems, but it does spam the log with b is nil value
    ChoGGi.OrigFunc.SortConstructionStatuses = SortConstructionStatuses
    function SortConstructionStatuses(statuses)
      if not statuses then
        return
      else
        ChoGGi.OrigFunc.SortConstructionStatuses(statuses)
      end
    end --SortConstructionStatuses
--]]

  end --if

  --was giving a nil error in log, I assume devs'll fix it one day (changed it to check if amount is a number...)
  ChoGGi.OrigFunc.RequiresMaintenance_AddDust = RequiresMaintenance.AddDust
  function RequiresMaintenance:AddDust(amount)
    --(dev check)
    if type(amount) == "number" or luadebugger and (luadebugger:Type(amount) == "Point" or luadebugger:Type(amount) == "Box") then
      if self:IsKindOf("Building") then
        amount = MulDivRound(amount, Consts.BuildingDustModifier, 100)
      end
      if self.accumulate_dust then
        self:AccumulateMaintenancePoints(amount)
      end
    end
  end

end --OnMsg


function ChoGGi.ReplacedFunctions_ClassesGenerate()

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
    win:SetScrollAutohide(true)

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
    win:SetHint("Scrolls down")

    win = Button:new(self)
    win:SetId("idDump")
    win:SetPos(point(290, 275))
    win:SetSize(point(75, 26))
    win:SetText(Untranslated("Dump Text"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
    win:SetHint("Dumps text to AppData/DumpedExamine.lua")

    win = Button:new(self)
    win:SetId("idDumpObj")
    win:SetPos(point(375, 275))
    win:SetSize(point(75, 26))
    win:SetText(Untranslated("Dump Obj"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
    win:SetHint("Dumps object to AppData/DumpedExamineObject.lua\n\nThis can take time on something like the \"Building\" metatable")
--[[
    win = Button:new(self)
    win:SetId("idEdit")
    win:SetPos(point(475, 275))
    win:SetSize(point(53, 26))
    win:SetText(Untranslated("Edit"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
--]]
    self:InitChildrenSizing()
    --have to size children before doing these:
    self:SetPos(point(50,150))
    self:SetSize(point(500,600))
  end
end --OnMsg
