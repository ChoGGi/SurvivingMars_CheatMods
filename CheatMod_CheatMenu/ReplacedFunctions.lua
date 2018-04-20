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
if ChoGGi.Testing then
    win:SetHint("idFilter")
end

    win = Button:new(self)
    win:SetId("idClose")
    win:SetPos(point(597, 191))
    win:SetSize(point(50, 24))
    win:SetHSizing("AnchorToRight")
    win:SetText(Untranslated("Close"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
    win:SetHint("Good bye")

    win = Button:new(self)
    win:SetId("idNext")
    win:SetPos(point(700, 275))
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

if ChoGGi.Testing then
    win = Button:new(self)
    win:SetId("idEdit")
    win:SetPos(point(460, 275))
    win:SetSize(point(53, 26))
    win:SetText(Untranslated("Edit"))
    win:SetTextColorDisabled(RGBA(127, 127, 127, 255))
end

    self:InitChildrenSizing()
    --have to size children before doing these:
    self:SetPos(point(50,150))
    self:SetSize(point(500,600))
  end
end --OnMsg


--function ChoGGi.ReplacedFunctions_LoadingScreenPreClose()
function ChoGGi.ReplacedFunctions_ClassesBuilt()

  --make the background hide when console not visible (instead of after a second or two)
  ChoGGi.OrigFunc.ConsoleLog_ShowBackground = ConsoleLog.ShowBackground
  function ConsoleLog:ShowBackground(visible, immediate)
    DeleteThread(self.background_thread)
    if visible or immediate then
      self:SetBackground(RGBA(0, 0, 0, visible and 96 or 0))
    else
      self:SetBackground(RGBA(0, 0, 0, 0))
    end
  end

  --add dump buttons/etc
  ChoGGi.OrigFunc.Examine_Init = Examine.Init
  function Examine:Init()
    ChoGGi.OrigFunc.Examine_Init(self)

    function self.idDump.OnButtonPressed()
      local String = self:totextex(self.obj)
      --remove html tags
      String = String:gsub("<[/%s%a%d]*>","")
      ChoGGi.Dump("\r\n" .. String,nil,"DumpedExamine","lua")
    end
    function self.idDumpObj.OnButtonPressed()
      ChoGGi.Dump("\r\n" .. ValueToLuaCode(self.obj),nil,"DumpedExamineObject","lua")
    end

if ChoGGi.Testing then
    function self.idEdit.OnButtonPressed()
      --OpenManipulator(self.obj,self)
      ChoGGi.OpenInObjectManipulator(object,parent)
    end
end

  end --Examine:Init

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

  --so we can build without (as many) limits
  ChoGGi.OrigFunc.CC_ChangeCursorObj = ConstructionController.CreateCursorObj
  function ConstructionController:CreateCursorObj(alternative_entity, template_obj, override_palette)

    local cursor_obj = ChoGGi.OrigFunc.CC_ChangeCursorObj(self,alternative_entity, template_obj, override_palette)

    --set orientation to last object if same entity (should I just do it for everything)
    --if ChoGGi.LastPlacedObject and ChoGGi.LastPlacedObject.entity == cursor_obj.entity then
    if ChoGGi.LastPlacedObject then
      cursor_obj:SetOrientation(ChoGGi.LastPlacedObject:GetOrientation())
    end

    return cursor_obj
  end

  --ignore certain placement limits
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

  end --if

  --was giving a nil error in log, I assume devs'll fix it one day (changed it to check if amount is a number/point/box...)
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
