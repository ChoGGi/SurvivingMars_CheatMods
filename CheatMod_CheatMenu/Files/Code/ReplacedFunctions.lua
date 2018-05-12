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

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesGenerate()
--dofolder_files("CommonLua/UI/UIDesignerData")

  --change dist we can charge from cables
  ChoGGi.ComFuncs.SaveOrigFunc("GetCableNearby","BaseRover")
  function BaseRover:GetCableNearby(rad)
    local amount = ChoGGi.UserSettings.RCChargeDist
    if amount then
      rad = amount
    end
    return ChoGGi.OrigFuncs.BaseRover_GetCableNearby(self, rad)
  end

  --so we can add hints to info pane cheats
  ChoGGi.ComFuncs.SaveOrigFunc("CreateCheatActions","InfopanelObj")
  function InfopanelObj:CreateCheatActions(win)
    local ret = ChoGGi.OrigFuncs.InfopanelObj_CreateCheatActions(self,win)
    ChoGGi.InfoFuncs.SetInfoPanelCheatHints(GetActionsHost(win))
    return ret
  end

  --add dump button to Examine windows
  ChoGGi.ComFuncs.SaveOrigFunc("Init","ExamineDesigner")
  function ExamineDesigner:Init()
    ChoGGi.OrigFuncs.ExamineDesigner_Init(self)

    --change already added elements
    self.idNext:SetHint("Scrolls down one or scrolls between text in \"Goto text\".")
    self.idNext:SetPos(point(715, 304))

    self.idText:SetScrollAutohide(true)
    self.idText:SetBackgroundColor(RGBA(0, 0, 0, 50))
    self.idText:SetPos(point(283, 332))
    self.idText:SetSize(point(362, 310))

    self.idFilter:SetPos(point(288, 275))
    self.idFilter:SetSize(point(350, 26))
    self.idFilter:SetHint("Scrolls to text entered")
    self.idFilter:SetTextHAlign("center")
    self.idFilter:SetTextVAlign("center")
    self.idFilter:SetBackgroundColor(RGBA(0, 0, 0, 50))
    self.idFilter.display_text = "Goto text"

    self.idClose:SetPos(point(629, 194))
    self.idClose:SetSize(point(18, 18))
    self.idClose:SetImage("CommonAssets/UI/Controls/Button/Close.tga")
    self.idClose:SetHint("Good bye")
    self.idClose:SetText("")

    --add some more
    local obj
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

    self:InitChildrenSizing()

    --have to size children before doing these:
    self:SetPos(point(50,150))
    self:SetSize(point(500,600))
  end
end --OnMsg

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesBuilt()

  --actually disable hints
  --[[
  ChoGGi.ComFuncs.SaveOrigFunc("HintTrigger")
  function HintTrigger(id, force)
    if not ChoGGi.UserSettings.DisableHints then
      ChoGGi.OrigFuncs.HintTrigger(self, id, force)
    end
  end

  ChoGGi.ComFuncs.SaveOrigFunc("_InternalTranslate")
  function _InternalTranslate(T, context_obj, check)
    local ret = ChoGGi.OrigFuncs._InternalTranslate(T, context_obj, check)
    --if ChoGGi.IsGameLoaded and context_obj and context_obj.class and s and s.class and context_obj.class ~= s.class then
    if ChoGGi.IsGameLoaded and context_obj then
      ex(context_obj)
    end
    return ret
  end

  --]]

  --convert popups to console text
  ChoGGi.ComFuncs.SaveOrigFunc("ShowPopupNotification")
  function ShowPopupNotification(preset, params, bPersistable, parent)
    --actually actually disable hints
    if ChoGGi.UserSettings.DisableHints and preset == "SuggestedBuildingConcreteExtractor" then
      return
    end

    if ChoGGi.UserSettings.ConvertPopups and type(preset) == "string" and not preset:find("LaunchIssue_") then
      if not pcall(function()
        local function ColourText(Text,Bool)
          if Bool == true then
            return "<color 200 200 200>" .. Text .. "</color>"
          else
            return "<color 75 255 75>" .. Text .. "</color>"
          end
        end
        local function ReplaceParam(Name,Text,SearchName)
          SearchName = SearchName or "<" .. Name .. ">"
          if not Text:find(SearchName) then
            return Text
          end
          return Text:gsub(SearchName,ColourText(_InternalTranslate(params[Name])))
        end
        --show popups in console log
        local presettext = DataInstances.PopupNotificationPreset[preset]
        --print(ColourText("Title: ",true) .. ColourText(_InternalTranslate(presettext.title)))
        local context = _GetPopupNotificationContext(preset, params or {}, bPersistable)
        context.parent = parent
        if bPersistable then
          context.sync_popup_id = SyncPopupId
        else
          context.async_signal = {}
        end
        local text = _InternalTranslate(presettext.text,context,true)
        --[[
        text = ReplaceParam("number1",text)
        text = ReplaceParam("number2",text)
        text = ReplaceParam("effect",text)
        text = ReplaceParam("reason",text)
        text = ReplaceParam("hint",text)
        text = ReplaceParam("objective",text)
        text = ReplaceParam("target",text)
        text = ReplaceParam("timeout",text)
        text = ReplaceParam("count",text)
        text = ReplaceParam("sponsor_name",text)
        text = ReplaceParam("commander_name",text)
        --]]

        --text = text:gsub("<ColonistName(colonist)>",ColourText("<ColonistName(" .. _InternalTranslate(params.colonist)) .. ")>")

        --print(ColourText("Text: ",true) .. text)
        --print(ColourText("Voiced Text: ",true) .. _InternalTranslate(presettext.voiced_text))
      end) then
        print("<color 255 0 0>Encountered an error trying to convert popup to console msg; showing popup instead (please let me know which popup it is).</color>")
        return ChoGGi.OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
      end
    else
      return ChoGGi.OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
    end
    --return ChoGGi.OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)

  end
  --Msg("ColonistDied",UICity.labels.Colonist[1],"low health")
  --local temp = DataInstances.PopupNotificationPreset.FirstColonistDeath
  --_InternalTranslate(T({temp.text,s}))

  --some mission goals check colonist amounts
  local MG_target = GetMissionSponsor().goal_target + 1
  ChoGGi.ComFuncs.SaveOrigFunc("GetProgress","MG_Colonists")
  function MG_Colonists:GetProgress()
    if ChoGGi.Temp.InstantMissionGoal then
      return MG_target
    else
      return ChoGGi.OrigFuncs.MG_Colonists_GetProgress(self)
    end
  end
  ChoGGi.ComFuncs.SaveOrigFunc("GetProgress","MG_Martianborn")
  function MG_Martianborn:GetProgress()
    if ChoGGi.Temp.InstantMissionGoal then
      return MG_target
    else
      return ChoGGi.OrigFuncs.MG_Martianborn_GetProgress(self)
    end
  end

  --keep prod at saved values for grid producers (air/water/elec)
  ChoGGi.ComFuncs.SaveOrigFunc("SetProduction","SupplyGridElement")
  function SupplyGridElement:SetProduction(new_production, new_throttled_production, update)
    local amount = ChoGGi.UserSettings.BuildingSettings[self.building.encyclopedia_id]
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
    ChoGGi.OrigFuncs.SupplyGridElement_SetProduction(self, new_production, new_throttled_production, update)
  end

  --and for regular producers (factories/extractors)
  ChoGGi.ComFuncs.SaveOrigFunc("Produce","SingleResourceProducer")
  function SingleResourceProducer:Produce(amount_to_produce)

    local amount = ChoGGi.UserSettings.BuildingSettings[self.parent.encyclopedia_id]
    if amount and amount.production then
      --set prod
      amount_to_produce = amount.production / ChoGGi.Consts.guim
      --set displayed prod
      self.production_per_day = amount.production
    end

    --get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
    if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
      ChoGGi.CodeFuncs.FuckingDrones(self)
    end

    return ChoGGi.OrigFuncs.SingleResourceProducer_Produce(self, amount_to_produce)
  end

  --larger drone work radius
  local function SetDroneRadius(OrigFunc,Setting,Obj,OrigRadius)
    local rad = ChoGGi.UserSettings[Setting]
    if rad then
      ChoGGi.OrigFuncs[OrigFunc .. "_SetWorkRadius"](Obj,rad)
    else
      ChoGGi.OrigFuncs[OrigFunc .. "_SetWorkRadius"](Obj,OrigRadius)
    end
  end
  ChoGGi.ComFuncs.SaveOrigFunc("SetWorkRadius","RCRover")
  function RCRover:SetWorkRadius(radius)
    SetDroneRadius("RCRover","RCRoverMaxRadius",self,radius)
  end
  ChoGGi.ComFuncs.SaveOrigFunc("SetWorkRadius","DroneHub")
  function DroneHub:SetWorkRadius(radius)
    SetDroneRadius("DroneHub","CommandCenterMaxRadius",self,radius)
  end

  --set UI transparency:
  local trans = ChoGGi.UserSettings.Transparency
  local function SetTrans(Obj)
    if type(trans) == "table" and Obj.class and trans[Obj.class] then
      Obj:SetTransparency(trans[Obj.class])
    end
  end
  --xdialogs (buildmenu, pins, infopanel)
  ChoGGi.ComFuncs.SaveOrigFunc("OpenXDialog")
  function OpenXDialog(template, parent, context, reason, id)
    local ret = ChoGGi.OrigFuncs.OpenXDialog(template, parent, context, reason, id)
    SetTrans(ret)
    return ret
  end
  --"desktop" dialogs (toolbar)
  ChoGGi.ComFuncs.SaveOrigFunc("Init","FrameWindow")
  function FrameWindow:Init()
    local ret = ChoGGi.OrigFuncs.FrameWindow_Init(self)
    SetTrans(self)
    return ret
  end
  --console stuff (it's visible before mods are loaded so I can't use FrameWindow_Init)
  ChoGGi.ComFuncs.SaveOrigFunc("ShowConsoleLog")
  function ShowConsoleLog(toggle)
    ChoGGi.OrigFuncs.ShowConsoleLog(toggle)
    SetTrans(dlgConsoleLog)
  end

  --toggle trans on mouseover
  ChoGGi.ComFuncs.SaveOrigFunc("OnMouseEnter","XWindow")
  function XWindow:OnMouseEnter(pt, child)
    local ret = ChoGGi.OrigFuncs.XWindow_OnMouseEnter(self, pt, child)
    if ChoGGi.UserSettings.TransparencyToggle then
      self:SetTransparency(0)
    end
    return ret
  end
  ChoGGi.ComFuncs.SaveOrigFunc("OnMouseLeft","XWindow")
  function XWindow:OnMouseLeft(pt, child)
    local ret = ChoGGi.OrigFuncs.XWindow_OnMouseLeft(self, pt, child)
    if ChoGGi.UserSettings.TransparencyToggle then
      SetTrans(self)
    end
    return ret
  end

  --remove spire spot limit, and other limits on placing buildings
  ChoGGi.ComFuncs.SaveOrigFunc("UpdateCursor","ConstructionController")
  function ConstructionController:UpdateCursor(pos, force)
    local function SetDefault(Name)
      self.template_obj[Name] = self.template_obj:GetDefaultPropertyValue(Name)
    end
    local force_override

    if ChoGGi.UserSettings.Building_instant_build then
      --instant_build on domes = missing textures on domes
      if self.template_obj.achievement ~= "FirstDome" then
        self.template_obj.instant_build = true
      end
    else
      SetDefault("instant_build")
      --self.template_obj.instant_build = self.template_obj:GetDefaultPropertyValue("instant_build")
    end

    if ChoGGi.UserSettings.Building_dome_spot then
      self.template_obj.dome_spot = "none"
      --force_override = true
    else
      SetDefault("dome_spot")
    end

    if ChoGGi.UserSettings.RemoveBuildingLimits then
      self.template_obj.dome_required = false
      self.template_obj.dome_forbidden = false
      force_override = true
    else
      SetDefault("dome_required")
      SetDefault("dome_forbidden")
    end

    if force_override then
      return ChoGGi.OrigFuncs.ConstructionController_UpdateCursor(self, pos, false)
    else
      return ChoGGi.OrigFuncs.ConstructionController_UpdateCursor(self, pos, force)
    end

  end

  --add height limits to certain panels (cheats/traits/colonists) till mouseover, and convert workers to vertical list on mouseover if over 14 (visible limit)
  ChoGGi.ComFuncs.SaveOrigFunc("Open","InfopanelDlg")
  --ex(GetInGameInterface()[6][2][3])
  -- list control GetInGameInterface()[6][2][3][2]:SetMaxHeight(165)
  function InfopanelDlg:Open(...)
    --fire the orig func so we can edit the dialog (and keep it's return value to pass on later)
    local ret = ChoGGi.OrigFuncs.InfopanelDlg_Open(self,...)

    CreateRealTimeThread(function()
      self = self.idContent
      if self then
        for i = 1, #self do
          local section = self[i]
          if section.class == "XSection" then
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
  ChoGGi.ComFuncs.SaveOrigFunc("ShowBackground","ConsoleLog")
  function ConsoleLog:ShowBackground(visible, immediate)
    if config.ConsoleDim ~= 0 then
      DeleteThread(self.background_thread)
      if visible or immediate then
        self:SetBackground(RGBA(0, 0, 0, visible and 96 or 0))
      else
        self:SetBackground(RGBA(0, 0, 0, 0))
      end
    end
  end

  --add functions for dump buttons/etc
  ChoGGi.ComFuncs.SaveOrigFunc("Init","Examine")
  function Examine:Init()
    ChoGGi.OrigFuncs.Examine_Init(self)

    function self.idDump.OnButtonPressed()
      local String = self:totextex(self.obj)
      --remove html tags
      String = String:gsub("<[/%s%a%d]*>","")
      ChoGGi.ComFuncs.Dump("\r\n" .. String,nil,"DumpedExamine","lua")
    end
    function self.idDumpObj.OnButtonPressed()
      ChoGGi.ComFuncs.Dump("\r\n" .. ValueToLuaCode(self.obj),nil,"DumpedExamineObject","lua")
    end

    function self.idEdit.OnButtonPressed()
      ChoGGi.CodeFuncs.OpenInObjectManipulator(self.obj,self)
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
  ChoGGi.ComFuncs.SaveOrigFunc("Show","Console")
  function Console:Show(show)
    ChoGGi.OrigFuncs.Console_Show(self, show)
    local was_visible = self:GetVisible()
    if show and not was_visible then
      --always on top
      self:SetModal()
    end
    if not show then
      --always on top off
      self:SetModal(false)
    end
    --adding transparency for console stuff (it's always visible so I can't use FrameWindow_PostInit)
    SetTrans(self)
  end

  --always able to show console
  ChoGGi.ComFuncs.SaveOrigFunc("ShowConsole")
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

  --kind of an ugly way of making sure console doesn't include ` when using tilde to open console
  ChoGGi.ComFuncs.SaveOrigFunc("TextChanged","Console")
  function Console:TextChanged()
    ChoGGi.OrigFuncs.Console_TextChanged(self)
    if self.idEdit:GetText() == "`" then
      self.idEdit:SetText("")
    end
  end

  --make it so caret is at the end of the text when you use history
  ChoGGi.ComFuncs.SaveOrigFunc("HistoryDown","Console")
  function Console:HistoryDown()
    ChoGGi.OrigFuncs.Console_HistoryDown(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end
  ChoGGi.ComFuncs.SaveOrigFunc("HistoryUp","Console")
  function Console:HistoryUp()
    ChoGGi.OrigFuncs.Console_HistoryUp(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end

  --was giving a nil error in log, I assume devs'll fix it one day (changed it to check if amount is a number/point/box...)
  ChoGGi.ComFuncs.SaveOrigFunc("AddDust","RequiresMaintenance")
  function RequiresMaintenance:AddDust(amount)
    --(dev check)
    if type(amount) == "number" or ChoGGi.CodeFuncs.RetType(amount) == "Point" or ChoGGi.CodeFuncs.RetType(amount) == "Box" then
      if self:IsKindOf("Building") then
        amount = MulDivRound(amount, g_Consts.BuildingDustModifier, 100)
      end
      if self.accumulate_dust then
        self:AccumulateMaintenancePoints(amount)
      end
    end
  end

  --set orientation to same as last object
  ChoGGi.ComFuncs.SaveOrigFunc("CreateCursorObj","ConstructionController")
  function ConstructionController:CreateCursorObj(alternative_entity, template_obj, override_palette)
    local ret = ChoGGi.OrigFuncs.ConstructionController_CreateCursorObj(self, alternative_entity, template_obj, override_palette)

    local last = ChoGGi.LastPlacedObject
    if last and ChoGGi.UserSettings.UseLastOrientation then
      --shouldn't fail anymore, but we'll still pcall for now
      pcall(function()
        ret:SetAngle(last:GetAngle())
        --ret:SetOrientation(last:GetOrientation())

        --check if angle is slightly off?
      end)
    end

    return ret
  end

  --so we can build without (as many) limits
  ChoGGi.ComFuncs.SaveOrigFunc("UpdateConstructionStatuses","ConstructionController")
  function ConstructionController:UpdateConstructionStatuses(dont_finalize)

    if ChoGGi.UserSettings.RemoveBuildingLimits then
      --send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
      ChoGGi.OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,"dont_finalize")

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
      if type(status) == "table" and next(status) then
        for i = 1, #status do
          if status[i].type == "warning" then
            statusNew[#statusNew+1] = status[i]
          --UnevenTerrain < causes issues when placing buildings (martian ground viagra)
          --ResourceRequired < no point in building an extractor when there's nothing to extract
          --BlockingObjects < place buildings in each other

          --PassageAngleToSteep might be needed?
          elseif status[i] == ConstructionStatus.UnevenTerrain then
            statusNew[#statusNew+1] = status[i]
          --probably good to have, but might be fun if it doesn't fuck up?
          elseif status[i] == ConstructionStatus.PassageRequiresDifferentDomes then
            statusNew[#statusNew+1] = status[i]
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
      return ChoGGi.OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,dont_finalize)
    end
  end --ConstructionController:UpdateConstructionStatuses

  --so we can do long spaced tunnels
  ChoGGi.ComFuncs.SaveOrigFunc("UpdateConstructionStatuses","TunnelConstructionController")
  function TunnelConstructionController:UpdateConstructionStatuses()
    if ChoGGi.UserSettings.RemoveBuildingLimits then
      local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
      self:FinalizeStatusGathering(old_t)
    else
      return ChoGGi.OrigFuncs.TunnelConstructionController_UpdateConstructionStatuses(self)
    end
  end

end --OnMsg
