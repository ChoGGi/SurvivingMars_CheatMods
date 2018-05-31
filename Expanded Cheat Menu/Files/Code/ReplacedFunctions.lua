--See LICENSE for terms

--[[
files to check after update:

CommonLua\Classes\Sequences\SequenceAction.lua
  SA_WaitBase>SA_WaitTime:StopWait
  SA_WaitBase>SA_WaitMarsTime:StopWait
CommonLua\UI\uiUAMenu.lua
  UAMenu:SetBtns
CommonLua\UI\Controls\uiFrameWindow.lua
  FrameWindow:PostInit
  UAMenu>FrameWindow:OnMouseEnter
  UAMenu>FrameWindow:OnMouseLeft
CommonLua\UI\Dev\uiConsole.lua
  Console:Show
  Console:TextChanged
  Console:HistoryDown
  Console:HistoryUp
CommonLua\UI\Dev\uiConsoleLog.lua
  ConsoleLog:ShowBackground
CommonLua\UI\X\XDialog.lua
  OpenXDialog
CommonLua\X\XMenu.lua
  XPopupMenu:RebuildActions

Lua\Construction.lua
  ConstructionController:UpdateConstructionStatuses
  ConstructionController:CreateCursorObj
  TunnelConstructionController:UpdateConstructionStatuses
Lua\Heat.lua
  SubsurfaceHeater:UpdatElectricityConsumption
Lua\MissionGoals.lua
  MG_Colonists:GetProgress
  MG_Martianborn:GetProgress
Lua\RequiresMaintenance.lua
  RequiresMaintenance:AddDust
Lua\SupplyGrid.lua
  SupplyGridElement:SetProduction
Lua\Buildings\BaseRover.lua
  BaseRover:GetCableNearby
Lua\Buildings\BuildingComponents.lua
  BuildingVisualDustComponent:SetDustVisuals
  SingleResourceProducer:Produce
Lua\Buildings\MartianUniversity.lua
  MartianUniversity:OnTrainingCompleted
Lua\Buildings\TriboelectricScrubber.lua
  TriboelectricScrubber:OnPostChangeRange
Lua\Buildings\UIRangeBuilding.lua
  UIRangeBuilding:SetUIRange
Lua\Buildings\Workplace.lua
  Workplace:AddWorker
Lua\UI\PopupNotification.lua
  ShowPopupNotification
Lua\Units\Colonist.lua
  Colonist:ChangeComfort
Lua\X\Infopanel.lua
  InfopanelObj:CreateCheatActions
  InfopanelDlg:Open
--]]

local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesGenerate()

  --larger trib/subsurfheater radius
  SaveOrigFunc("UIRangeBuilding","SetUIRange")
  function UIRangeBuilding:SetUIRange(radius)
    local ChoGGi = ChoGGi
    local rad = ChoGGi.UserSettings.BuildingSettings[self.encyclopedia_id]
    if rad and rad.uirange then
      radius = rad.uirange
    end
    return ChoGGi.OrigFuncs.UIRangeBuilding_SetUIRange(self, radius)
  end

  --block certain traits from workplaces
  SaveOrigFunc("Workplace","AddWorker")
  function Workplace:AddWorker(worker, shift)
    local ChoGGi = ChoGGi
    local s = ChoGGi.UserSettings.BuildingSettings[self.encyclopedia_id]
    --check that the tables contain at least one trait
    local bt = s and s.blocktraits and type(s.blocktraits) == "table" and next(s.blocktraits) and s.blocktraits
    local rt = s and s.restricttraits and type(s.restricttraits) == "table" and next(s.restricttraits) and s.restricttraits
    if bt or rt then

      local block,restrict = ChoGGi.CodeFuncs.RetBuildingPermissions(worker.traits,s)
      if block then
        return
      end
      if restrict then
        self.workers[shift] = self.workers[shift] or {}
        table.insert(self.workers[shift], worker)
        self:UpdatePerformance()
        self:SetWorkplaceWorking()
        self:UpdateAttachedSigns()
      end

    else
      return ChoGGi.OrigFuncs.Workplace_AddWorker(self, worker, shift)
    end
  end

  --set amount of dust applied
  SaveOrigFunc("BuildingVisualDustComponent","SetDustVisuals")
  function BuildingVisualDustComponent:SetDustVisuals(dust, in_dome)
    if ChoGGi.UserSettings.AlwaysDustyBuildings then
      if not self.ChoGGi_AlwaysDust or self.ChoGGi_AlwaysDust < dust then
        self.ChoGGi_AlwaysDust = dust
      end
      dust = self.ChoGGi_AlwaysDust
    end

    local normalized_dust = MulDivRound(dust, 255, self.visual_max_dust)
    ApplyToObjAndAttaches(self, SetObjDust, normalized_dust, in_dome)
  end

  --change dist we can charge from cables
  SaveOrigFunc("BaseRover","GetCableNearby")
  function BaseRover:GetCableNearby(rad)
    local ChoGGi = ChoGGi
    if ChoGGi.UserSettings.RCChargeDist then
      rad = ChoGGi.UserSettings.RCChargeDist
    end
    return ChoGGi.OrigFuncs.BaseRover_GetCableNearby(self, rad)
  end

  --so we can add hints to info pane cheats
  SaveOrigFunc("InfopanelObj","CreateCheatActions")
  function InfopanelObj:CreateCheatActions(win)
    local ChoGGi = ChoGGi
    local ret = {ChoGGi.OrigFuncs.InfopanelObj_CreateCheatActions(self,win)}
    ChoGGi.InfoFuncs.SetInfoPanelCheatHints(GetActionsHost(win))
    return table.unpack(ret)
  end

end --OnMsg

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesPreprocess()
end
function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesPostprocess()
end

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesBuilt()

  --limit width of cheats menu till hover
  do
    local cheats_width = 450
    if ChoGGi.UserSettings.ToggleWidthOfCheatsHover then
      cheats_width = 80
      local thread
      SaveOrigFunc("UAMenu","OnMouseEnter")
      function UAMenu:OnMouseEnter(...)
        ChoGGi.OrigFuncs.UAMenu_OnMouseEnter(self,...)
        DeleteThread(thread)
        self:SetSize(point(450,self:GetSize():y()))
      end
      SaveOrigFunc("UAMenu","OnMouseLeft")
      function UAMenu:OnMouseLeft(...)
        ChoGGi.OrigFuncs.UAMenu_OnMouseLeft(self,...)
        thread = CreateRealTimeThread(function()
          Sleep(2500)
        self:SetSize(point(80,self:GetSize():y()))
        end)
      end
    end
    --default menu width
    SaveOrigFunc("UAMenu","SetBtns")
    function UAMenu:SetBtns()
      ChoGGi.OrigFuncs.UAMenu_SetBtns(self)
      self:SetSize(point(cheats_width,self:GetSize():y()))
    end
  end

  --make it so the script button on the console shows above the button/consolelog, and builds our scripts menu listing
  SaveOrigFunc("XPopupMenu","RebuildActions")
  function XPopupMenu:RebuildActions(host)
    local ischoggi
    local menu = self.MenuEntries

    --clear out old scripts
    for i = #host.actions, 1, -1 do
        local action = host.actions[i]
      if action.ActionMenubar == "ChoGGi_Scripts" and host:FilterAction(action) then
        ischoggi = true
        action:delete()
        table.remove(host.actions,i)
      end
    end
    --rebuild list of scripts
    ChoGGi.ComFuncs.ListScriptFiles()

    local context = host.context
    local ShowIcons = self.ShowIcons
    self.idContainer:DeleteChildren()
    for i = 1, #host.actions do
      local action = host.actions[i]
      if action.ActionMenubar == menu and host:FilterAction(action) then
        local entry = XMenuEntry:new({
          OnPress = function(this, gamepad)
            host:OnAction(action, self)
            if action.OnActionEffect ~= "popup" then
              self:Close(action.ActionId)
            end
          end
        }, self.idContainer, context)
        entry:SetFontProps(self)
        entry:SetTranslate(action.ActionTranslate)
        entry:SetText(action.ActionName)
        if ShowIcons then
          entry:SetIcon(action.ActionIcon)
        end
        entry:SetShortcut(Platform.desktop and action.ActionShortcut or action.ActionGamepad)
        entry:Open()

      end --if
    end --for

    if ischoggi then
      --make the menu start above the button
      self:SetMargins(box(0, 0, 0, 32))
      -- 1 above consolelog
      self:SetZOrder(2000001)
    end
  end

  --removes earthsick effect
  SaveOrigFunc("Colonist","ChangeComfort")
  function Colonist:ChangeComfort(amount, reason)
    local ChoGGi = ChoGGi
    ChoGGi.OrigFuncs.Colonist_ChangeComfort(self, amount, reason)
    if ChoGGi.UserSettings.NoMoreEarthsick and self.status_effects.StatusEffect_Earthsick then
      self:Affect("StatusEffect_Earthsick", false)
    end
  end

  --make sure heater keeps the powerless setting
  SaveOrigFunc("SubsurfaceHeater","UpdatElectricityConsumption")
  function SubsurfaceHeater:UpdatElectricityConsumption()
    local ChoGGi = ChoGGi
    ChoGGi.OrigFuncs.SubsurfaceHeater_UpdatElectricityConsumption(self)
    if self.ChoGGi_mod_electricity_consumption then
      ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
    end
  end
  --same for tribby
  SaveOrigFunc("TriboelectricScrubber","OnPostChangeRange")
  function TriboelectricScrubber:OnPostChangeRange()
    local ChoGGi = ChoGGi
    ChoGGi.OrigFuncs.TriboelectricScrubber_OnPostChangeRange(self)
    if self.ChoGGi_mod_electricity_consumption then
      ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
    end
  end

  --remove idiot trait from uni grads (hah!)
  SaveOrigFunc("MartianUniversity","OnTrainingCompleted")
  function MartianUniversity:OnTrainingCompleted(unit)
    local ChoGGi = ChoGGi
    if ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait then
      unit:RemoveTrait("Idiot")
    end
    ChoGGi.OrigFuncs.MartianUniversity_OnTrainingCompleted(self, unit)
  end

  --used to skip mystery sequences
  local function SkipMystStep(self,MystFunc)
    local ChoGGi = ChoGGi
    local StopWait = ChoGGi.Temp.SA_WaitMarsTime_StopWait
    local p = self.meta.player

    if StopWait and p and StopWait.seed == p.seed then
      --inform user, or if it's a dbl then skip
      if StopWait.skipmsg then
        StopWait.skipmsg = nil
      else
        ChoGGi.ComFuncs.MsgPopup("Timer delay skipped","Mystery")
      end

      --only set on first SA_WaitExpression, as there's always a SA_WaitMarsTime after it and if we're skipping then skip...
      if StopWait.again == true then
        StopWait.again = nil
        StopWait.skipmsg = true
      else
        --reset it for next time
        StopWait.seed = false
        StopWait.again = false
      end

      --skip
      return 1
    end

    return ChoGGi.OrigFuncs[MystFunc](self)
  end

  SaveOrigFunc("SA_WaitTime","StopWait")
  function SA_WaitTime:StopWait()
    SkipMystStep(self,"SA_WaitTime_StopWait")
  end
  SaveOrigFunc("SA_WaitMarsTime","StopWait")
  function SA_WaitMarsTime:StopWait()
    SkipMystStep(self,"SA_WaitMarsTime_StopWait")
  end
--[[
  --convert popups to console text
  SaveOrigFunc("ShowPopupNotification")
  function ShowPopupNotification(preset, params, bPersistable, parent)
    local ChoGGi = ChoGGi
    --actually actually disable hints
    if ChoGGi.UserSettings.DisableHints and preset == "SuggestedBuildingConcreteExtractor" then
      return
    end

    if type(ChoGGi.Temp.Testing) == "function" then
    --if ChoGGi.UserSettings.ConvertPopups and type(preset) == "string" and not preset:find("LaunchIssue_") then
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
          return Text:gsub(SearchName,ColourText(ChoGGi.CodeFuncs.Trans(params[Name])))
        end
        --show popups in console log
        local presettext = DataInstances.PopupNotificationPreset[preset]
        --print(ColourText("Title: ",true) .. ColourText(ChoGGi.CodeFuncs.Trans(presettext.title)))
        local context = _GetPopupNotificationContext(preset, params or {}, bPersistable)
        context.parent = parent
        if bPersistable then
          context.sync_popup_id = SyncPopupId
        else
          context.async_signal = {}
        end
        local text = ChoGGi.CodeFuncs.Trans(presettext.text,context,true)


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

        --text = text:gsub("<ColonistName(colonist)>",ColourText("<ColonistName(" .. ChoGGi.CodeFuncs.Trans(params.colonist)) .. ")>")

        --print(ColourText("Text: ",true) .. text)
        --print(ColourText("Voiced Text: ",true) .. ChoGGi.CodeFuncs.Trans(presettext.voiced_text))
      end) then
        print("<color 255 0 0>Encountered an error trying to convert popup to console msg; showing popup instead (please let me know which popup it is).</color>")
        return ChoGGi.OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
      end
    else
      return ChoGGi.OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
    end
    --return ChoGGi.OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
  end
--]]
  --Msg("ColonistDied",UICity.labels.Colonist[1],"low health")
  --local temp = DataInstances.PopupNotificationPreset.FirstColonistDeath
  --ChoGGi.CodeFuncs.Trans(temp.text,s)

  --some mission goals check colonist amounts
  local MG_target = GetMissionSponsor().goal_target + 1
  SaveOrigFunc("MG_Colonists","GetProgress")
  function MG_Colonists:GetProgress()
    local ChoGGi = ChoGGi
    if ChoGGi.Temp.InstantMissionGoal then
      return MG_target
    else
      return ChoGGi.OrigFuncs.MG_Colonists_GetProgress(self)
    end
  end
  SaveOrigFunc("MG_Martianborn","GetProgress")
  function MG_Martianborn:GetProgress()
    local ChoGGi = ChoGGi
    if ChoGGi.Temp.InstantMissionGoal then
      return MG_target
    else
      return ChoGGi.OrigFuncs.MG_Martianborn_GetProgress(self)
    end
  end

  --keep prod at saved values for grid producers (air/water/elec)
  SaveOrigFunc("SupplyGridElement","SetProduction")
  function SupplyGridElement:SetProduction(new_production, new_throttled_production, update)
    local ChoGGi = ChoGGi
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
  SaveOrigFunc("SingleResourceProducer","Produce")
  function SingleResourceProducer:Produce(amount_to_produce)
    local ChoGGi = ChoGGi
    local amount = ChoGGi.UserSettings.BuildingSettings[self.parent.encyclopedia_id]
    if amount and amount.production then
      --set prod
      amount_to_produce = amount.production / ChoGGi.Consts.guim
      --set displayed prod
      self.production_per_day = amount.production
    end

--[[
function SingleResourceProducer:DroneUnloadResource(drone, request, resource, amount)
  if resource == self.resource_produced and self.parent and self.parent ~= self then
    self.parent:DroneUnloadResource(drone, request, resource, amount)
  end
end
--]]
    --get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
    if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
      ChoGGi.CodeFuncs.FuckingDrones(self)
    end

    return ChoGGi.OrigFuncs.SingleResourceProducer_Produce(self, amount_to_produce)
  end

  --larger drone work radius
  local function SetHexRadius(OrigFunc,Setting,Obj,OrigRadius)
    local ChoGGi = ChoGGi
    if ChoGGi.UserSettings[Setting] then
      return ChoGGi.OrigFuncs[OrigFunc](Obj,ChoGGi.UserSettings[Setting])
    end
    return ChoGGi.OrigFuncs[OrigFunc](Obj,OrigRadius)
  end
  SaveOrigFunc("RCRover","SetWorkRadius")
  function RCRover:SetWorkRadius(radius)
    SetHexRadius("RCRover_SetWorkRadius","RCRoverMaxRadius",self,radius)
  end
  SaveOrigFunc("DroneHub","SetWorkRadius")
  function DroneHub:SetWorkRadius(radius)
    SetHexRadius("DroneHub_SetWorkRadius","CommandCenterMaxRadius",self,radius)
  end

  --set UI transparency:
  local trans = ChoGGi.UserSettings.Transparency
  local function SetTrans(Obj)
    if type(trans) == "table" and Obj and Obj.class and trans[Obj.class] then
      Obj:SetTransparency(trans[Obj.class])
    end
  end
  --xdialogs (buildmenu, pins, infopanel)
  SaveOrigFunc("OpenXDialog")
  function OpenXDialog(template, parent, context, reason, id)
    local ret = {ChoGGi.OrigFuncs.OpenXDialog(template, parent, context, reason, id)}
    SetTrans(ret)
    return table.unpack(ret)
  end
  --"desktop" dialogs (toolbar)
  SaveOrigFunc("FrameWindow","Init")
  function FrameWindow:Init()
    local ret = {ChoGGi.OrigFuncs.FrameWindow_Init(self)}
    SetTrans(self)
    return table.unpack(ret)
  end
  --console stuff (it's visible before mods are loaded so I can't use FrameWindow_Init)
  SaveOrigFunc("ShowConsoleLog")
  function ShowConsoleLog(toggle)
    ChoGGi.OrigFuncs.ShowConsoleLog(toggle)
    SetTrans(dlgConsoleLog)
  end

  --toggle trans on mouseover
  SaveOrigFunc("XWindow","OnMouseEnter")
  function XWindow:OnMouseEnter(pt, child)
    local ChoGGi = ChoGGi
    local ret = {ChoGGi.OrigFuncs.XWindow_OnMouseEnter(self, pt, child)}
    if ChoGGi.UserSettings.TransparencyToggle then
      self:SetTransparency(0)
    end
    return table.unpack(ret)
  end
  SaveOrigFunc("XWindow","OnMouseLeft")
  function XWindow:OnMouseLeft(pt, child)
    local ChoGGi = ChoGGi
    local ret = {ChoGGi.OrigFuncs.XWindow_OnMouseLeft(self, pt, child)}
    if ChoGGi.UserSettings.TransparencyToggle then
      SetTrans(self)
    end
    return table.unpack(ret)
  end

  --remove spire spot limit, and other limits on placing buildings
  SaveOrigFunc("ConstructionController","UpdateCursor")
  function ConstructionController:UpdateCursor(pos, force)
    local ChoGGi = ChoGGi
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
  SaveOrigFunc("InfopanelDlg","Open")
  --ex(GetInGameInterface()[6][2])
  -- list control GetInGameInterface()[6][2][3][2]:SetMaxHeight(165)
  function InfopanelDlg:Open(...)
    --fire the orig func so we can edit the dialog (and keep it's return value to pass on later)
    local ret = {ChoGGi.OrigFuncs.InfopanelDlg_Open(self,...)}
    CreateRealTimeThread(function()
      local TGetID = TGetID
      local c = self.idContent

      --see about adding age to colonist info
if type(ChoGGi.Temp.Testing) == "function" then
      if self.context and self.context.class == "Colonist" then
        local con = c[2].idContent
        --con[#con+1] = XText:new()
        con = con[#con]
        --con.text = con.text .. "age: "
        --ex(con)
      end
end

      --probably don't need this...
      if c then
        --this limits height of traits you can choose to 3 till mouse over
        --7422="Select A Trait"
        if #c > 19 and c[18].idSectionTitle and TGetID(c[18].idSectionTitle.Text) == 7422 then
          --sanitarium
          local idx = 18
          --school
          if TGetID(c[20].idSectionTitle.Text) == 7422 then
            idx = 20
          end
          local function ToggleVis(v,h)
            for i = 6, idx do
              c[i]:SetVisible(v)
              c[i]:SetMaxHeight(h)
            end
          end
          --init set to hidden
          ToggleVis(false,0)
          local visthread

          self.OnMouseEnter = function()
            DeleteThread(visthread)
            ToggleVis(true)
          end
          self.OnMouseLeft = function()
            visthread = CreateRealTimeThread(function()
              Sleep(1000)
              ToggleVis(false,0)
            end)
          end

        end

        --loop all the sections
        for i = 1, #c do
          local section = c[i]
          if section.class == "XSection" then
            local title = section.idSectionTitle.Text
            local content = section.idContent[2]
            --if section.idWorkers and #section.idWorkers > 14 and title == "" then
            if section.idWorkers and #section.idWorkers > 14 then
              --sets height
              content:SetMaxHeight(32)
              local expandthread

              section.OnMouseEnter = function()
                DeleteThread(expandthread)
                content:SetLayoutMethod("HWrap")
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                expandthread = CreateRealTimeThread(function()
                  Sleep(500)
                  content:SetLayoutMethod("HList")
                  content:SetMaxHeight(32)
                end)
              end

            --Cheats
            elseif TGetID(title) == 27 then
              --hides overflow
              content:SetClip(true)
              --sets height
              content:SetMaxHeight(0)
              local expandthread

              section.OnMouseEnter = function()
                DeleteThread(expandthread)
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                expandthread = CreateRealTimeThread(function()
                  Sleep(500)
                  content:SetMaxHeight(0)
                end)
              end

            --[[
              235=Traits
              702480492408=Residents
              TranslationTable[27]
              --]]
            elseif TGetID(title) == 235 or TGetID(title) == 702480492408 then

              --hides overflow
              content:SetClip(true)
              --sets height
              content:SetMaxHeight(256)
              local expandthread

              section.OnMouseEnter = function()
                DeleteThread(expandthread)
                content:SetMaxHeight()
              end
              section.OnMouseLeft = function()
                expandthread = CreateRealTimeThread(function()
                  Sleep(500)
                  content:SetMaxHeight(256)
                end)
              end
            end

          end --if XSection
        end
      end
    end)

    return table.unpack(ret)
  end

  --make the background hide when console not visible (instead of after a second or two)
  SaveOrigFunc("ConsoleLog","ShowBackground")
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

  --make sure console is focused even when construction is opened
  SaveOrigFunc("Console","Show")
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
  SaveOrigFunc("ShowConsole")
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
  SaveOrigFunc("Console","TextChanged")
  function Console:TextChanged()
    ChoGGi.OrigFuncs.Console_TextChanged(self)
    if self.idEdit:GetText() == "`" then
      self.idEdit:SetText("")
    end
  end

  --make it so caret is at the end of the text when you use history
  SaveOrigFunc("Console","HistoryDown")
  function Console:HistoryDown()
    ChoGGi.OrigFuncs.Console_HistoryDown(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end
  SaveOrigFunc("Console","HistoryUp")
  function Console:HistoryUp()
    ChoGGi.OrigFuncs.Console_HistoryUp(self)
    self.idEdit:SetCursorPos(#self.idEdit:GetText())
  end

  --was giving a nil error in log, I assume devs'll fix it one day (changed it to check if amount is a number/point/box...)
  SaveOrigFunc("RequiresMaintenance","AddDust")
  function RequiresMaintenance:AddDust(amount)
    local ChoGGi = ChoGGi
    --this wasn't checking if it was a number so errors in log, now it does
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
  SaveOrigFunc("ConstructionController","CreateCursorObj")
  function ConstructionController:CreateCursorObj(alternative_entity, template_obj, override_palette)
    local ChoGGi = ChoGGi
    local ret = {ChoGGi.OrigFuncs.ConstructionController_CreateCursorObj(self, alternative_entity, template_obj, override_palette)}

    local last = ChoGGi.Temp.LastPlacedObject
    if last and ChoGGi.UserSettings.UseLastOrientation then
      --shouldn't fail anymore, but we'll still pcall
      pcall(function()
        local angle = type(last.GetAngle) == "function" and last:GetAngle()
        if angle and type(ret[1].SetAngle) == "function" then
          ret[1]:SetAngle(angle)
        end
      end)
    end

    return table.unpack(ret)
  end


  --so we can build without (as many) limits
  SaveOrigFunc("ConstructionController","UpdateConstructionStatuses")
  function ConstructionController:UpdateConstructionStatuses(dont_finalize)
    local ChoGGi = ChoGGi
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
--NoPlaceForSpire
--PassageTooCloseToLifeSupport
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
  SaveOrigFunc("TunnelConstructionController","UpdateConstructionStatuses")
  function TunnelConstructionController:UpdateConstructionStatuses()
    local ChoGGi = ChoGGi
    if ChoGGi.UserSettings.RemoveBuildingLimits then
      local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
      self:FinalizeStatusGathering(old_t)
    else
      return ChoGGi.OrigFuncs.TunnelConstructionController_UpdateConstructionStatuses(self)
    end
  end

end --OnMsg
