--[[
CommonLua\UI\uiExamine.lua
  Examine:Init
CommonLua\UI\uiExamine.designer.lua
    ExamineDesigner:Init
CommonLua\UI\Controls\uiFrameWindow.lua
  FrameWindow:PostInit
CommonLua\UI\Dev\uiConsoleLog.lua
  ConsoleLog:ShowBackground
CommonLua\UI\Dev\uiConsole.lua
  Console:Show
  Console:TextChanged
  Console:HistoryDown
  Console:HistoryUp
CommonLua\UI\X\XDialog.lua
  OpenXDialog
Lua\Construction.lua
  ConstructionController:UpdateConstructionStatuses
  ConstructionController:CreateCursorObj
  TunnelConstructionController:UpdateConstructionStatuses
Lua\RequiresMaintenance.lua
  RequiresMaintenance:AddDust
Lua\Buildings\BuildingComponents.lua
  SingleResourceProducer:Produce
Lua\Buildings\SupplyGrid.lua
  SupplyGridElement:SetProduction
Lua\X\Infopanel.lua
  InfopanelObj:CreateCheatActions
  InfopanelDlg:Open
--]]


function ChoGGi.ReplacedFunctions_ClassesGenerate()

--[[
--dumpo(classdefs)
dumpt(classdefs)
dumpl(classdefs)
--]]

  --so we can add hints to info pane cheats
  if not ChoGGi.OrigFunc.InfopanelObj_CreateCheatActions then
    ChoGGi.OrigFunc.InfopanelObj_CreateCheatActions = InfopanelObj.CreateCheatActions
  end
  function InfopanelObj:CreateCheatActions(win)
    local ret = ChoGGi.OrigFunc.InfopanelObj_CreateCheatActions(self,win)
    ChoGGi.SetInfoPanelCheatHints(GetActionsHost(win))
    if ret then
      return ret
    end
  end

  --add dump button to Examine windows
  if not ChoGGi.OrigFunc.ExamineDesigner_Init then
    ChoGGi.OrigFunc.ExamineDesigner_Init = ExamineDesigner.Init
  end
  function ExamineDesigner:Init()
    self:SetMinSize(point(309, 53))
    self:SetSize(point(372, 459))
    self:SetPos(point(278, 191))
    self:SetTranslate(false)
    self:SetMovable(true)
    self:SetZOrder(10000)
    local obj

    obj = StaticText:new(self)
    obj:SetId("idMenu")
    obj:SetPos(point(283, 217))
    obj:SetSize(point(362, 52))
    obj:SetHSizing("Resize")
    obj:SetBackgroundColor(RGBA(0, 0, 0, 16))
    obj:SetFontStyle("Editor12Bold")

    obj = Button:new(self)
    obj:SetId("idClose")
    obj:SetPos(point(629, 194))
    obj:SetSize(point(18, 18))
    obj:SetHSizing("AnchorToRight")
    obj:SetImage("CommonAssets/UI/Controls/Button/Close.tga")
    obj:SetHint("Good bye")

    obj = SingleLineEdit:new(self)
    obj:SetId("idFilter")
    obj:SetPos(point(288, 275))
    obj:SetSize(point(350, 26))
    obj:SetHSizing("Resize")
    obj:SetBackgroundColor(RGBA(0, 0, 0, 16))
    obj:SetFontStyle("Editor12Bold")
    obj:SetHint("Scrolls to text entered")
    obj:SetTextHAlign("center")
    obj:SetTextVAlign("center")
    obj.display_text = "Goto text"

    obj = Button:new(self)
    obj:SetId("idNext")
    obj:SetPos(point(715, 304))
    obj:SetSize(point(53, 26))
    obj:SetText("Next")
    obj:SetHint("Scrolls down one or scrolls between text in \"Goto text\".")

    obj = Button:new(self)
    obj:SetId("idDump")
    obj:SetPos(point(290, 304))
    obj:SetSize(point(75, 26))
    obj:SetText("Dump Text")
    obj:SetHint("Dumps text to AppData/DumpedExamine.lua")

    obj = Button:new(self)
    obj:SetId("idDumpObj")
    obj:SetPos(point(375, 304))
    obj:SetSize(point(75, 26))
    obj:SetText("Dump Obj")
    obj:SetHint("Dumps object to AppData/DumpedExamineObject.lua\n\nThis can take time on something like the \"Building\" metatable")

    obj = Button:new(self)
    obj:SetId("idEdit")
    obj:SetPos(point(460, 304))
    obj:SetSize(point(53, 26))
    obj:SetText("Edit")
    obj:SetHint("Opens object in Object Manipulator.")

    obj = StaticText:new(self)
    obj:SetId("idText")
    obj:SetPos(point(283, 332))
    obj:SetSize(point(362, 310))
    obj:SetHSizing("Resize")
    obj:SetVSizing("Resize")
    obj:SetBackgroundColor(RGBA(0, 0, 0, 16))
    obj:SetFontStyle("Editor12Bold")
    obj:SetScrollBar(true)
    obj:SetScrollAutohide(true)

    self:InitChildrenSizing()
    --have to size children before doing these:
    self:SetPos(point(50,150))
    self:SetSize(point(500,600))
  end
end --OnMsg


function ChoGGi.ReplacedFunctions_ClassesBuilt()

  --keep prod at saved values for grid producers (air/water/elec)
  if not ChoGGi.OrigFunc.SupplyGridElement_SetProduction then
    ChoGGi.OrigFunc.SupplyGridElement_SetProduction = SupplyGridElement.SetProduction
  end
  function SupplyGridElement:SetProduction(new_production, new_throttled_production, update)
    local amount = ChoGGi.CheatMenuSettings.BuildingSettings[self.building.encyclopedia_id]
    if amount and amount.production then
      --set prod
      new_production = self.building.working and amount.production or 0
      --set displayed prod
      if self:IsKindOf("AirGridFragment") then
        self.building.air_production = self.building.working and amount.production or 0
      elseif self:IsKindOf("WaterGrid") then
        self.building.water_production = self.building.working and amount.production or 0
      elseif self:IsKindOf("ElectricityGrid") then
        self.building.electricity_production = self.building.working and amount.production or 0
      end
    end
    ChoGGi.OrigFunc.SupplyGridElement_SetProduction(self, new_production, new_throttled_production, update)
  end

  --and for regular producers (factories/extractors)
  if not ChoGGi.OrigFunc.SingleResourceProducer_Produce then
    ChoGGi.OrigFunc.SingleResourceProducer_Produce = SingleResourceProducer.Produce
  end
  function SingleResourceProducer:Produce(amount_to_produce)

    local amount = ChoGGi.CheatMenuSettings.BuildingSettings[self.parent.encyclopedia_id]
    if amount and amount.production then
      --set prod
      amount_to_produce = amount.production / ChoGGi.Consts.guim
      --set displayed prod
      self.production_per_day = amount.production
    end

    --get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
    if ChoGGi.CheatMenuSettings.DroneResourceCarryAmountFix then
      ChoGGi.FuckingDrones(self)
    end

    return ChoGGi.OrigFunc.SingleResourceProducer_Produce(self, amount_to_produce)
  end

  --larger drone work radius
  local function SetRadius(OrigFunc,Setting,self,radius)
    local rad = ChoGGi.CheatMenuSettings[Setting]
    if rad then
      OrigFunc(self,rad)
    else
      OrigFunc(self,radius)
    end
  end
  if not ChoGGi.OrigFunc.RCRover_SetWorkRadius then
    ChoGGi.OrigFunc.RCRover_SetWorkRadius = RCRover.SetWorkRadius
  end
  function RCRover:SetWorkRadius(radius)
    SetRadius(ChoGGi.OrigFunc.RCRover_SetWorkRadius,"RCRoverDefaultRadius",self,radius)
  end
  if not ChoGGi.OrigFunc.DroneHub_SetWorkRadius then
    ChoGGi.OrigFunc.DroneHub_SetWorkRadius = DroneHub.SetWorkRadius
  end
  function DroneHub:SetWorkRadius(radius)
    SetRadius(ChoGGi.OrigFunc.DroneHub_SetWorkRadius,"CommandCenterDefaultRadius",self,radius)
  end

  --set UI transparency:
  local trans = ChoGGi.CheatMenuSettings.Transparency
  if not ChoGGi.CheatMenuSettings.Transparency then
    ChoGGi.CheatMenuSettings.Transparency = {}
  end

  local function SetTrans(Obj)
    if Obj.class and trans[Obj.class] then
      Obj:SetTransparency(trans[Obj.class])
    end
  end
  --xdialogs (buildmenu, pins, infopanel)
  if not ChoGGi.OrigFunc.OpenXDialog then
    ChoGGi.OrigFunc.OpenXDialog = OpenXDialog
  end
  function OpenXDialog(template, parent, context, reason, id)
    local ret = ChoGGi.OrigFunc.OpenXDialog(template, parent, context, reason, id)
    SetTrans(ret)
    return ret
  end
  --"desktop" dialogs (toolbar)
  if not ChoGGi.OrigFunc.FrameWindow_Init then
    ChoGGi.OrigFunc.FrameWindow_Init = FrameWindow.Init
  end
  function FrameWindow:Init()
    local ret = ChoGGi.OrigFunc.FrameWindow_Init(self)
    SetTrans(self)
    return ret
  end
  --console stuff (it's visible before mods are loaded so I can't use FrameWindow_Init)
  if not ChoGGi.OrigFunc.ShowConsoleLog then
    ChoGGi.OrigFunc.ShowConsoleLog = ShowConsoleLog
  end
  function ShowConsoleLog(toggle)
    ChoGGi.OrigFunc.ShowConsoleLog(toggle)
    SetTrans(dlgConsoleLog)
  end

  --toggle trans on mouseover
  if not ChoGGi.OrigFunc.XWindow_OnMouseEnter then
    ChoGGi.OrigFunc.XWindow_OnMouseEnter = XWindow.OnMouseEnter
  end
  function XWindow:OnMouseEnter(pt, child)
    local ret = ChoGGi.OrigFunc.XWindow_OnMouseEnter(self, pt, child)
    if ChoGGi.CheatMenuSettings.TransparencyToggle then
      self:SetTransparency(0)
    end
    return ret
  end
  if not ChoGGi.OrigFunc.XWindow_OnMouseLeft then
    ChoGGi.OrigFunc.XWindow_OnMouseLeft = XWindow.OnMouseLeft
  end
  function XWindow:OnMouseLeft(pt, child)
    local ret = ChoGGi.OrigFunc.XWindow_OnMouseLeft(self, pt, child)
    if ChoGGi.CheatMenuSettings.TransparencyToggle then
      SetTrans(self)
    end
    return ret
  end

  --remove spire spot limit
  if not ChoGGi.OrigFunc.CC_UpdateCursor then
    ChoGGi.OrigFunc.CC_UpdateCursor = ConstructionController.UpdateCursor
  end
  function ConstructionController:UpdateCursor(pos, force)
    local force_override

    if ChoGGi.CheatMenuSettings.Building_instant_build then
      --instant_build on domes = missing textures on domes
      if self.template_obj.achievement ~= "FirstDome" then
        self.template_obj.instant_build = true
      end
    else
      self.template_obj.instant_build = self.template_obj:GetDefaultPropertyValue("instant_build")
    end

    if ChoGGi.CheatMenuSettings.Building_dome_spot then
      self.template_obj.dome_spot = "none"
      --force_override = true
    else
      self.template_obj.dome_spot = self.template_obj:GetDefaultPropertyValue("dome_spot")
    end

    if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then
      self.template_obj.dome_required = false
      self.template_obj.dome_forbidden = false
      force_override = true
    else
      self.template_obj.dome_required = self.template_obj:GetDefaultPropertyValue("dome_required")
      self.template_obj.dome_forbidden = self.template_obj:GetDefaultPropertyValue("dome_forbidden")
    end

    if force_override then
      return ChoGGi.OrigFunc.CC_UpdateCursor(self, pos, false)
    else
      return ChoGGi.OrigFunc.CC_UpdateCursor(self, pos, force)
    end

  end

  --if certain panels (cheats/traits/colonists) are too large then hide most of them till mouseover
  if not ChoGGi.OrigFunc.InfopanelDlg_Open then
    ChoGGi.OrigFunc.InfopanelDlg_Open = InfopanelDlg.Open
  end
  --ex(GetInGameInterface()[6][2][3])
  -- list control GetInGameInterface()[6][2][3][2]:SetMaxHeight(165)
  function InfopanelDlg:Open(...)
    --fire the orig func and keep it's return value to pass on later
    local ret = ChoGGi.OrigFunc.InfopanelDlg_Open(self,...)

    CreateRealTimeThread(function()
      self = self.idContent
      if self then
        for i = 1, #self do
          local section = self[i]
          if section.class == "XSection" then
            --local title = section[2][1].text
            local title = section.idSectionTitle.text
            local content = section.idContent[2]
            if section.idWorkers and (#section.idWorkers > 14 and title == "") then
              --sets height
                content:SetMaxHeight(32)

              section.OnMouseEnter = function()
                content:SetLayoutMethod("HWrap")
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                content:SetLayoutMethod("HList")
                content:SetMaxHeight(32)
              end
            elseif title and (title == "Traits" or title == "Cheats" or title:find("Residents")) then
              --hides overflow
              content:SetClip(true)
              --sets height
              content:SetMaxHeight(168)

              section.OnMouseEnter = function()
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                content:SetMaxHeight(168)
              end
            end
          end --if XSection
        end
      end
    end)

    return ret
  end

  --make the background hide when console not visible (instead of after a second or two)
  if not ChoGGi.OrigFunc.ConsoleLog_ShowBackground then
    ChoGGi.OrigFunc.ConsoleLog_ShowBackground = ConsoleLog.ShowBackground
  end
  function ConsoleLog:ShowBackground(visible, immediate)
    DeleteThread(self.background_thread)
    if visible or immediate then
      self:SetBackground(RGBA(0, 0, 0, visible and 96 or 0))
    else
      self:SetBackground(RGBA(0, 0, 0, 0))
    end
  end

  --add dump buttons/etc
  if not ChoGGi.OrigFunc.Examine_Init then
    ChoGGi.OrigFunc.Examine_Init = Examine.Init
  end
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

    function self.idEdit.OnButtonPressed()
      ChoGGi.OpenInObjectManipulator(self.obj,self)
    end

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

  end --Examine:Init

  --make sure console is focused even when construction is opened
  if not ChoGGi.OrigFunc.Console_Show then
    ChoGGi.OrigFunc.Console_Show = Console.Show
  end
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
    --adding transparency for console stuff (it's always visible so I can't use FrameWindow_PostInit)
    SetTrans(self)
  end

  --always able to show console
  if not ChoGGi.OrigFunc.ShowConsole then
    ChoGGi.OrigFunc.ShowConsole = ShowConsole
  end
  function ShowConsole(visible)
  --[[
    removed from orig func:
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
  if not ChoGGi.OrigFunc.Console_TextChanged then
    ChoGGi.OrigFunc.Console_TextChanged = Console.TextChanged
  end
  function Console:TextChanged()
    ChoGGi.OrigFunc.Console_TextChanged(self)
    if self.idEdit:GetText() == "`" then
      self.idEdit:SetText("")
    end
  end

  --make it so it goes to the end of the text when you use history
  if not ChoGGi.OrigFunc.Console_HistoryDown then
    ChoGGi.OrigFunc.Console_HistoryDown = Console.HistoryDown
  end
  function Console:HistoryDown()
    ChoGGi.OrigFunc.Console_HistoryDown(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end
  if not ChoGGi.OrigFunc.Console_HistoryUp then
    ChoGGi.OrigFunc.Console_HistoryUp = Console.HistoryUp
  end
  function Console:HistoryUp()
    ChoGGi.OrigFunc.Console_HistoryUp(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end

  --set orientation to same as last object
  if not ChoGGi.OrigFunc.CC_ChangeCursorObj then
    ChoGGi.OrigFunc.CC_ChangeCursorObj = ConstructionController.CreateCursorObj
  end
  function ConstructionController:CreateCursorObj(alternative_entity, template_obj, override_palette)
    local ret = ChoGGi.OrigFunc.CC_ChangeCursorObj(self, alternative_entity, template_obj, override_palette)

    local last = ChoGGi.LastPlacedObject
    if last and ChoGGi.CheatMenuSettings.UseLastOrientation then
      --shouldn't fail anymore, but we'll still pcall for now
      pcall(function()
        ret:SetOrientation(last:GetOrientation())
      end)
    end

    return ret
  end

  --was giving a nil error in log, I assume devs'll fix it one day (changed it to check if amount is a number/point/box...)
  if not ChoGGi.OrigFunc.RequiresMaintenance_AddDust then
    ChoGGi.OrigFunc.RequiresMaintenance_AddDust = RequiresMaintenance.AddDust
  end
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

  --so we can build without (as many) limits
  if not ChoGGi.OrigFunc.CC_UpdateConstructionStatuses then
    ChoGGi.OrigFunc.CC_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
  end
  function ConstructionController:UpdateConstructionStatuses(dont_finalize)

    if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then
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
      --if #status > 0 then
      if next(status) then
        for i = 1, #status do
          if status[i].type == "warning" then
            table.insert(statusNew,status[i])
          --UnevenTerrain < causes issues when placing buildings (martian ground viagra)
          --ResourceRequired < no point in building an extractor when there's nothing to extract
          --BlockingObjects < place buildings in each other

          --PassageAngleToSteep might be needed?
          elseif status[i] == ConstructionStatus.UnevenTerrain then
            table.insert(statusNew,status[i])
          --probably good to have, but might be fun if it doesn't fuck up?
          elseif status[i] == ConstructionStatus.PassageRequiresDifferentDomes then
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
    else
      return ChoGGi.OrigFunc.CC_UpdateConstructionStatuses(self,dont_finalize)
    end
  end --ConstructionController:UpdateConstructionStatuses

  --so we can do long spaced tunnels
  if not ChoGGi.OrigFunc.TC_UpdateConstructionStatuses then
    ChoGGi.OrigFunc.TC_UpdateConstructionStatuses = TunnelConstructionController.UpdateConstructionStatuses
  end
  function TunnelConstructionController:UpdateConstructionStatuses()
    if ChoGGi.CheatMenuSettings.RemoveBuildingLimits then
      local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
      self:FinalizeStatusGathering(old_t)
    else
      return ChoGGi.OrigFunc.TC_UpdateConstructionStatuses(self)
    end
  end

end --OnMsg
