local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc

--[[
add files for:
  ("DefenceTower","DefenceTick")
  ("ShowPopupNotification")
  ("MG_Colonists","GetProgress")
  ("MG_Martianborn","GetProgress")
  ("BuildingVisualDustComponent","SetDustVisuals")
  ("BaseRover","GetCableNearby")

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

--[[
fix one bug in Drone Build Failure.savegame
https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-drone-build-failure.1099375/
function TaskRequester:ConnectToCommandCenters()
	local dome = IsObjInDome(self)
	if dome then
		for i = 1, #(dome.command_centers or "") do
			local cc = dome.command_centers[i]
			self:AddCommandCenter(cc)
		end
	else
		command_center_search.area = self
		ForEach(command_center_search, self)
		command_center_search.area = false
	end
end

function TaskRequester:ConnectToOtherBuildingCommandCenters(other_building)
	local dome = IsObjInDome(other_building) --if other bld is in dome connect to dome's cc's instead.

	if dome then
		for i = 1, #(dome.command_centers or "") do
			local cc = dome.command_centers[i]
			self:AddCommandCenter(cc)
		end
	else
		command_center_search.area = other_building
		ForEach(command_center_search, self, other_building)
		command_center_search.area = false
	end
end
--]]

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesGenerate()

  --add anti dust devil functions to defence tower
  SaveOrigFunc("DefenceTower","GameInit")
  function DefenceTower:GameInit()
    local ChoGGi = ChoGGi
    local Sleep = Sleep
    local IsValid = IsValid
    self.defence_thread_ChoGGi_Dust = CreateGameTimeThread(function()
      while IsValid(self) and not self.destroyed do
        if self.working then
          if not self:DefenceTick_ChoGGi_Dust(ChoGGi) then
            Sleep(1000)
          end
        else
          Sleep(1000)
        end
      end
    end)
    return ChoGGi.OrigFuncs.DefenceTower_GameInit(self)
  end

  --if it idles it'll go home, so we return my command till we remove thread
  SaveOrigFunc("CargoShuttle","Idle")
  function CargoShuttle:Idle()
    local ChoGGi = ChoGGi
    if type(ChoGGi.Temp.CargoShuttleThreads[self.handle]) == "boolean" then
      self:SetCommand("ChoGGi_FollowMouse")
      Sleep(250)
    else
      return ChoGGi.OrigFuncs.CargoShuttle_Idle(self)
    end
  end

  --meteor targeting
  SaveOrigFunc("CargoShuttle","GameInit")
  function CargoShuttle:GameInit()
    local ChoGGi = ChoGGi

    --if it's an attack shuttle
    if ChoGGi.Temp.CargoShuttleThreads[self.handle] then
      local IsValid = IsValid
      local Sleep = Sleep
      self.shoot_range = 25 * ChoGGi.Consts.guim
      self.reload_time = const.HourDuration
      self.track_thread = false

      self.defence_thread_DD = CreateGameTimeThread(function()
        while IsValid(self) and not self.destroyed do
          if self.working then
            if not self:ChoGGi_DefenceTickD(ChoGGi) then
              Sleep(1000)
            end
          else
            Sleep(1000)
          end
        end
      end)
    end

    return ChoGGi.OrigFuncs.CargoShuttle_GameInit(self)
  end

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

  --add dump button to Examine windows
  SaveOrigFunc("ExamineDesigner","Init")
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
    self.idFilter:SetBackgroundColor(RGBA(0, 0, 0, 100))
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

    obj = Button:new(self)
    obj:SetId("idCodeExec")
    obj:SetPos(point(520, 304))
    obj:SetSize(point(50, 26))
    obj:SetText("Exec")
    obj:SetHint("Execute code (using console for output). ChoGGi.CurObj is whatever object is opened in examiner.\nWhich you can then mess around with some more in the console.")

    obj = Button:new(self)
    obj:SetId("idAttaches")
    obj:SetPos(point(575, 304))
    obj:SetSize(point(75, 26))
    obj:SetText("Attaches")
    obj:SetHint("Opens attachments in new examine window.")

    self:InitChildrenSizing()
    --have to size children before doing these:
    self:SetPos(point(50,150))
    self:SetSize(point(500,600))

  end
end --OnMsg

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesPreprocess()

  --gives error when we make shuttles a pinnable object (Modifiable and PinnableObject don't like each other...)
  SaveOrigFunc("LabelContainer","RemoveFromLabel")
  function LabelContainer:RemoveFromLabel(label, obj, leave_modifiers)
    --one-liner ifs: ewww
    if not label or not obj then
      return
    end
    local label_list = self.labels[label]
    if label_list and table.remove_entry(label_list, obj) then
      if not leave_modifiers then
        local modifiers = self.label_modifiers[label]
        if modifiers then
          for id, mod in pairs(modifiers) do
            --added to check for pinnable shuttles
            if type(obj.UpdateModifier) == "function" then
              obj:UpdateModifier("remove", mod, - mod.amount, - mod.percent)
            end
          end
        end
      end
      return true
    end
  end
  SaveOrigFunc("LabelContainer","AddToLabel")
  function LabelContainer:AddToLabel(label, obj)
    if not label or not obj then
      return
    end
    local label_list = self.labels[label]
    if label_list then
      if not table.find(label_list, obj) then
        --insert into label
        label_list[#label_list + 1] = obj
      else
        --obj alraedy in label
        --exit so we don't modify properties multiple times
        return
      end
    else
      label_list = { obj }
      self.labels[label] = label_list
    end
    local modifiers = self.label_modifiers[label]
    if modifiers then
      for id, mod in pairs(modifiers) do
        if type(obj.UpdateModifier) == "function" then
          obj:UpdateModifier("add", mod, mod.amount, mod.percent)
        end
      end
    end
    return true
  end

end

function ChoGGi.MsgFuncs.ReplacedFunctions_ClassesBuilt()

  --gives an error when we spawn shuttle since i'm using a fake task
  SaveOrigFunc("CargoShuttle","OnTaskAssigned")
  function CargoShuttle:OnTaskAssigned()
    if self.ChoGGi_FollowMouseShuttle then
      return true
    else
      return ChoGGi.OrigFuncs.CargoShuttle_OnTaskAssigned(self)
    end
  end

  --add a call shuttle action on rightclick
  SaveOrigFunc("PinsDlg","InitPinButton")
  function PinsDlg:InitPinButton(button)
    local ret = {ChoGGi.OrigFuncs.PinsDlg_InitPinButton(self, button)}
      for i = 1, #self do
        local pin = self[i]
        if pin.Icon == "UI/Icons/Buildings/res_shuttle.tga" then
          function pin:OnMouseButtonDown(pt, button)
            if button == "R" then
              CreateGameTimeThread(function()
                --give it a bit for user to move mouse away from pinsdlg so shuttle doesn't fly there
                Sleep(1500)
                if not self.context.scanning then
                  self.context:SetCommand("ChoGGi_FollowMouse",GetTerrainCursor())
                end
              end)
            end
          end
        end
      end
    return table.unpack(ret)
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
if ChoGGi.Temp.Testing then
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
          local expandthread

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

  --update attaches button with attaches amount
  SaveOrigFunc("Examine","SetObj")
  function Examine:SetObj(o)
    ChoGGi.OrigFuncs.Examine_SetObj(self,o)
    local attaches = type(o) == "table" and o.GetAttaches and o:GetAttaches()
    local amount = type(attaches) == "table" and #attaches or "scraping the barrel (0)"
    local hint = "Opens attachments in new examine window."
    local name = type(o) == "table" and o.class
    self.idAttaches:SetHint(hint .. "\nThis " .. (name or "\"Missing\"") .. " has: " .. amount)
  end

  --add functions for dump buttons/etc
  SaveOrigFunc("Examine","Init")
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

    function self.idAttaches.OnButtonPressed()
      if type(self.obj) == "table" then
        if self.obj.GetAttaches then
          ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(self.obj:GetAttaches(),self)
        end
      else
        print("Zero attachments means zero...")
      end
    end

    function self.idEdit.OnButtonPressed()
      ChoGGi.ComFuncs.OpenInObjectManipulator(self.obj,self)
    end
    function self.idCodeExec.OnButtonPressed()
      ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj,self)
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
