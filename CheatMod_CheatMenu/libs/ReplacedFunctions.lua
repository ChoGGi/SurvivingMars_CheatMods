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
s = ChoGGi.SelectedObj
sp = SelectionMouseObj
--GetTerrainCursorObjSel()
--GetPreciseCursorObj()
--[[
Selection
SelectionAdd
SelectionRemove
--]]
function cur()
  return GetTerrainCursor()
end
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
log = ChoGGi.Dump
dump = ChoGGi.Dump
dumpobject = ChoGGi.DumpObject
dumpo = ChoGGi.DumpObject
dumptable = ChoGGi.DumpTable
dumpt = ChoGGi.DumpTable
alert = ChoGGi.MsgPopup
exit = quit
reboot = restart

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
function OnMsg.LoadGame()

  --save teh OrigFunc
  ChoGGi.OrigFunc.CC_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
  --ChoGGi.OrigFunc.CC_UpdateConstructionObstructors = ConstructionController.UpdateConstructionObstructors
  ChoGGi.OrigFunc.TC_UpdateConstructionStatuses = TunnelConstructionController.UpdateConstructionStatuses
  --ChoGGi.OrigFunc.TC_UpdateConstructionObstructors = TunnelConstructionController.UpdateConstructionObstructors
  if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then
    ConstructionController.UpdateConstructionStatuses = ChoGGi.ReplacedFunc.CC_UpdateConstructionStatuses
    --ConstructionController.UpdateConstructionObstructors = ChoGGi.ReplacedFunc.CC_UpdateConstructionObstructors
    TunnelConstructionController.UpdateConstructionStatuses = ChoGGi.ReplacedFunc.TC_UpdateConstructionStatuses
    --TunnelConstructionController.UpdateConstructionObstructors = ChoGGi.ReplacedFunc.TC_UpdateConstructionObstructors
  end
end
--[[
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
function ChoGGi.ReplacedFunc.CC_UpdateConstructionObstructors()
  function ConstructionController.UpdateConstructionObstructors()
    local self = GetSelf
    ChoGGi.OrigFunc.CC_UpdateConstructionObstructors(self)
  end
end

function ChoGGi.ReplacedFunc.TC_UpdateConstructionObstructors()
  function TunnelConstructionController.UpdateConstructionObstructors()
    local self = GetSelf
    ChoGGi.OrigFunc.TC_UpdateConstructionObstructors(self)
  end
end
--]]
function ChoGGi.ReplacedFunc.CC_UpdateConstructionStatuses(dont_finalize)
  function ConstructionController.UpdateConstructionStatuses(dont_finalize)
      ChoGGi.OrigFunc.CC_UpdateConstructionStatuses(dont_finalize)
      local self = CityConstruction[UICity]
      local constr_dlg = GetInGameInterface() and GetInGameInterface().mode_dialog
      if constr_dlg and constr_dlg:IsKindOf("GridConstructionDialog") then
        self = CityGridConstruction[UICity]
      elseif constr_dlg and constr_dlg:IsKindOf("TunnelConstructionDialog") then
        self = CityTunnelConstruction[UICity]
      end
      --no errors for construction
      self.construction_statuses = {}
      --we still want to block UnevenTerrain as it breaks the buildings
      if not self.template_obj:IsKindOf("OrbitalProbe") and not self:IsTerrainFlatForPlacement() then
        self.construction_statuses[#self.construction_statuses + 1] = ConstructionStatus.UnevenTerrain
        hr.NearestHexCenterZ = 0
      end
  end
end

--we only want to block uneven terrain
function ChoGGi.ReplacedFunc.TC_UpdateConstructionStatuses(pt)
  function TunnelConstructionController.UpdateConstructionStatuses(pt)
    ChoGGi.OrigFunc.TC_UpdateConstructionStatuses(pt)

    local self = CityTunnelConstruction[UICity]

    local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")

    if not self.template_obj:IsKindOf("OrbitalProbe") and not self:IsTerrainFlatForPlacement() then
      self.construction_statuses = {}
      self.construction_statuses[#self.construction_statuses + 1] = ConstructionStatus.UnevenTerrain
      hr.NearestHexCenterZ = 0
      self:FinalizeStatusGathering(old_t)
    else
      self:FinalizeStatusGathering(old_t)
    end
  --no errors for construction
  end
end

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
    if ChoGGi.ChoGGiTest then
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

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"ReplacedFunctions")
end
