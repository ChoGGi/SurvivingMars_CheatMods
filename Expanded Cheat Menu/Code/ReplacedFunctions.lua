-- See LICENSE for terms

-- last checked source: Tito Hotfix2

-- In-game functions replaced with custom ones

local table = table
local type, rawget = type, rawget
local Sleep = Sleep
local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local TranslationTable = TranslationTable

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local SetDlgTrans = ChoGGi.ComFuncs.SetDlgTrans
local RetName = ChoGGi.ComFuncs.RetName
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind

local UserSettings = ChoGGi.UserSettings
local testing = ChoGGi.testing

do -- non-class obj funcs

	-- this will reset override, so we sleep and reset it
	local ChoOrig_ClosePlanetCamera = ClosePlanetCamera
	function ClosePlanetCamera(...)
		if UserSettings.Lightmodel then
			CreateRealTimeThread(function()
				Sleep(100)
				SetLightmodelOverride(1, UserSettings.Lightmodel)
			end)
		end
		return ChoOrig_ClosePlanetCamera(...)
	end

	-- don't trigger quakes if setting is enabled
	local ChoOrig_TriggerMarsquake = TriggerMarsquake
	function TriggerMarsquake(...)
		if not UserSettings.DisasterQuakeDisable then
			return ChoOrig_TriggerMarsquake(...)
		end
	end

	-- don't trigger toxic rains if setting is enabled
	local ChoOrig_RainProcedure = RainProcedure
	function RainProcedure(settings, ...)
		if settings.type == "normal" or not UserSettings.DisasterRainsDisable then
			return ChoOrig_RainProcedure(settings, ...)
		end
	end

	-- stops the help webpage from showing up every single time
	if UserSettings.SkipModHelpPage then
		GedOpHelpMod = empty_func
	end

	-- stops mod editor itself
	local ChoOrig_OpenGedApp = OpenGedApp
	function OpenGedApp(template, ...)
		if template == "ModsEditor" and (testing or UserSettings.SkipModEditorDialog) then
			return
		end
		return ChoOrig_OpenGedApp(template, ...)
	end

	-- get rid of "This savegame was loaded in the past without required mods or with an incompatible game version."
	local ChoOrig_WaitMarsMessage = WaitMarsMessage
	function WaitMarsMessage(parent, title, msg, ...)
		if (testing or UserSettings.SkipIncompatibleModsMsg) and IsT(msg) == 10888 then
			return
		end
		return ChoOrig_WaitMarsMessage(parent, title, msg, ...)
	end

	-- examine persist errors (if any)
	local ChoOrig_ReportPersistErrors = ReportPersistErrors
	function ReportPersistErrors(...)
		local errors, warnings = 0, 0
		if UserSettings.DebugPersistSaves and __error_table__ and #__error_table__ > 0 then
			ChoGGi.ComFuncs.OpenInExamineDlg(__error_table__, nil, "__error_table__ (persists)")
		else
			errors, warnings = ChoOrig_ReportPersistErrors(...)
		end
		-- the assert in PersistGame() attempts to concat a nil value
		return errors, warnings
	end

	local ChoOrig_TGetID = TGetID
	function TGetID(t, ...)
		local t_type = type(t)
		if t_type ~= "table" and t_type ~= "userdata" then
			return ChoOrig_TGetID(T(t, ...))
		end
		return ChoOrig_TGetID(t, ...)
	end

	-- I guess, don't pass a string to it?
	local ChoOrig_TDevModeGetEnglishText = TDevModeGetEnglishText
	function TDevModeGetEnglishText(t, ...)
		if type(t) == "string" then
			return t
		end
		return ChoOrig_TDevModeGetEnglishText(t, ...)
	end

	-- fix for sending nil id to it
	local ChoOrig_LoadCustomOnScreenNotification = LoadCustomOnScreenNotification
	function LoadCustomOnScreenNotification(notification, ...)
		-- the first return is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
		if table.unpack(notification) then
			return ChoOrig_LoadCustomOnScreenNotification(notification, ...)
		end
	end

	-- change rocket cargo cap
	local ChoOrig_GetMaxCargoShuttleCapacity = GetMaxCargoShuttleCapacity
	function GetMaxCargoShuttleCapacity(...)
		return UserSettings.StorageShuttle or ChoOrig_GetMaxCargoShuttleCapacity(...)
	end


	-- report building as not-a-wonder to the func that checks for wonders
	local ChoOrig_UIGetBuildingPrerequisites = UIGetBuildingPrerequisites
	function UIGetBuildingPrerequisites(cat_id, template, ...)
		-- missing dlc
		if BuildingTemplates[template.id] then

			-- save orig boolean
			local orig_wonder = template.build_once

			if UserSettings.Building_wonder then
				-- always false so there's no build limit
				template.build_once = false
			end

			-- store ret values as a table since there's more than one, and an update may change the amount
			local ret = {ChoOrig_UIGetBuildingPrerequisites(cat_id, template, ...)}

			-- make sure to restore orig value after func fires
			template.build_once = orig_wonder

			return table.unpack(ret)
		end
	end

	-- stops confirmation dialog about missing mods (still lets you know they're missing)
	local ChoOrig_GetMissingMods = GetMissingMods
	function GetMissingMods(...)
		if UserSettings.SkipMissingMods then
			return "", false
		else
			return ChoOrig_GetMissingMods(...)
		end
	end

	-- lets you load saved games that have dlc
	do -- IsDlcAvailable/IsDlcRequired
		local dlc_funcs = {
			"IsDlcAvailable",
--~ 			"IsDlcAccessible",
			"IsDlcRequired",
		}
		for i = 1, #dlc_funcs do
			local name = dlc_funcs[i]

			local ChoOrig_func = _G[name]
			_G[name] = function(dlc, ...)
				-- stuff added for future dlc is showing up and erroring out
				if not dlc or dlc == "" then
					return ChoOrig_func(dlc, ...)
				end
				-- returns true if the setting is true, or return the orig func
				return UserSettings.SkipMissingDLC or ChoOrig_func(dlc, ...)
			end
		end
	end -- do

	-- lets you load saved games that have dlc
	local ChoOrig_IsDlcRequired = IsDlcRequired
	function IsDlcRequired(dlc, ...)
		-- stuff added for future dlc is showing up and erroring out
		if not dlc or dlc == "" then
			return ChoOrig_IsDlcRequired(dlc, ...)
		end
		-- returns true if the setting is true, or return the orig func
		return UserSettings.SkipMissingDLC or ChoOrig_IsDlcRequired(dlc, ...)
	end

	-- always able to show console
	local ChoOrig_ShowConsole = ShowConsole
	function ShowConsole(visible, ...)
		if visible then
			-- ShowConsole checks for this
			ConsoleEnabled = true
		end
		return ChoOrig_ShowConsole(visible, ...)
	end

	-- console stuff
	local ChoOrig_ShowConsoleLog = ShowConsoleLog
	function ShowConsoleLog(visible, ...)
		-- we only want to show it if it's enabled or we're in mod editor mode
		visible = UserSettings.ConsoleToggleHistory or ChoGGi.ComFuncs.ModEditorActive()

		-- ShowConsoleLog doesn't check for existing dialog like ShowConsole does
		if rawget(_G, "dlgConsoleLog") then
			dlgConsoleLog:SetVisible(visible, ...)
		else
			ChoOrig_ShowConsoleLog(visible, ...)
		end
		SetDlgTrans(dlgConsoleLog)
	end

	do -- ShowPopupNotification
		-- skip the notification hint suggestions
		local suggestions = {}
		local PopupNotificationPresets = PopupNotificationPresets
		for key in pairs(PopupNotificationPresets) do
			if key:sub(1, 9) == "Suggested" then
				suggestions[key] = true
			end
		end

		local ChoOrig_ShowPopupNotification = ShowPopupNotification
		function ShowPopupNotification(preset, ...)
			if UserSettings.DisableHints and suggestions[preset] then
				return
			end
			return ChoOrig_ShowPopupNotification(preset, ...)
		end
	end -- do

	-- UI transparency dialogs (buildmenu, pins, infopanel)
	local ChoOrig_OpenDialog = OpenDialog
	function OpenDialog(...)
		return SetDlgTrans(ChoOrig_OpenDialog(...))
	end

	-- skips story bit dialogs
	local ChoOrig_PopupNotificationBegin = PopupNotificationBegin
	function PopupNotificationBegin(dlg, ...)
		if UserSettings.SkipStoryBitsDialogs and dlg.context and dlg.context.is_storybit
		then
			CreateRealTimeThread(function()
				if testing then
					Sleep(100)
				else
					Sleep(2500)
				end
				if dlg.idList and #dlg.idList > 0 then
					dlg.idList[1]:OnMouseButtonDown(nil, "L")
					dlg.idList[1]:OnMouseButtonUp(nil, "L")
				end
			end)
		end
		return ChoOrig_PopupNotificationBegin(dlg, ...)
	end

end -- do
--
do -- func exists before classes

	-- update production (OnMsgs.lua)
	local ChoOrig_SingleResourceProducer_Init = SingleResourceProducer.Init
	function SingleResourceProducer:Init(...)
		ChoOrig_SingleResourceProducer_Init(self, ...)
		Msg("ChoGGi_SpawnedProducer", self, "production_per_day")
	end
	local ChoOrig_AirProducer_CreateLifeSupportElements = AirProducer.CreateLifeSupportElements
	function AirProducer:CreateLifeSupportElements(...)
		ChoOrig_AirProducer_CreateLifeSupportElements(self, ...)
		Msg("ChoGGi_SpawnedProducer", self, "air_production")
	end
	local ChoOrig_WaterProducer_CreateLifeSupportElements = WaterProducer.CreateLifeSupportElements
	function WaterProducer:CreateLifeSupportElements(...)
		ChoOrig_WaterProducer_CreateLifeSupportElements(self, ...)
		Msg("ChoGGi_SpawnedProducer", self, "water_production")
	end
	local ChoOrig_ElectricityProducer_CreateElectricityElement = ElectricityProducer.CreateElectricityElement
	function ElectricityProducer:CreateElectricityElement(...)
		ChoOrig_ElectricityProducer_CreateElectricityElement(self, ...)
		Msg("ChoGGi_SpawnedProducer", self, "electricity_production")
	end
	local ChoOrig_PinnableObject_TogglePin = PinnableObject.TogglePin
	function PinnableObject:TogglePin(...)
		ChoOrig_PinnableObject_TogglePin(self, ...)
		Msg("ChoGGi_TogglePinnableObject", self)
	end
	local ChoOrig_Drone_GameInit = Drone.GameInit
	function Drone:GameInit(...)
		ChoOrig_Drone_GameInit(self, ...)
		-- slight delay
		CreateRealTimeThread(Msg, "ChoGGi_SpawnedDrone", self)
	end
	local ChoOrig_BaseBuilding_GameInit = BaseBuilding.GameInit
	function BaseBuilding:GameInit(...)
		ChoOrig_BaseBuilding_GameInit(self, ...)
		-- slight delay
		CreateRealTimeThread(Msg, "ChoGGi_SpawnedBaseBuilding", self)
	end

end -- do
--
function OnMsg.ClassesGenerate()



	-- check which can go in before classes




	-- needed for SetDesiredAmount in depots
	local ChoOrig_ResourceStockpileBase_GetMax = ResourceStockpileBase.GetMax
	function ResourceStockpileBase:GetMax(...)
		if UserSettings.StorageUniversalDepot and self.template_name == "UniversalStorageDepot" then
			return UserSettings.StorageUniversalDepot / const.ResourceScale
		end
		return ChoOrig_ResourceStockpileBase_GetMax(self, ...)
	end

	do -- LandscapeConstructionController:Activate
		local max_int = max_int

		-- no more limit to R+T
		local ChoOrig_LandscapeConstructionController_Activate = LandscapeConstructionController.Activate
		function LandscapeConstructionController:Activate(...)
			if UserSettings.RemoveLandScapingLimits then
				self.brush_radius_step = 100
				self.brush_radius_max = max_int
				self.brush_radius_min = 100
			end
			return ChoOrig_LandscapeConstructionController_Activate(self, ...)
		end
	end -- do

	do -- DroneBase:RegisterDustDevil
		local fake_devil = {drone_speed_down = 0}

		-- stop drones/rovers from slowing down in dustdevils
		local ChoOrig_DroneBase_RegisterDustDevil = DroneBase.RegisterDustDevil
		function DroneBase:RegisterDustDevil(devil, ...)
			if (UserSettings.SpeedWaspDrone and self:IsKindOf("FlyingDrone"))
				or (UserSettings.SpeedDrone and self:IsKindOf("Drone") and not self:IsKindOf("FlyingDrone"))
				or (UserSettings.SpeedRC and self:IsKindOf("BaseRover"))
			then
				devil = fake_devil
			end
			return ChoOrig_DroneBase_RegisterDustDevil(self, devil, ...)
		end
	end -- do

	-- all storybit/neg/etc options enabled
	local ChoOrig_Condition_Evaluate = Condition.Evaluate
	function Condition.Evaluate(...)
		return UserSettings.OverrideConditionPrereqs
			or ChoOrig_Condition_Evaluate(...)
	end

	-- limit size of crops to window width - selection panel size
	do -- InfopanelItems:Open()
		local GetScreenSize = UIL.GetScreenSize
		local width = GetScreenSize():x() - 100
		function OnMsg.SystemSize()
			width = GetScreenSize():x() - 100
		end

		local ChoOrig_InfopanelItems_Open = InfopanelItems.Open
		function InfopanelItems:Open(...)
			if UserSettings.LimitCropsUIWidth then
				self:SetMaxWidth(width - Dialogs.Infopanel.box:sizex())
			end
			return ChoOrig_InfopanelItems_Open(self, ...)
		end
	end -- do

	-- using the CheatUpgrade func in the cheats pane with some mods (silva's apt) == inf loop
	-- InfoPaneCheats.lua
	do -- Building:CheatUpgrade*()
		local Building = Building
		for i = 1, 3 do
			local name = "CheatUpgrade" .. i
			local ChoOrig_Building_CheatUpgradeX = Building[name]
			Building[name] = function(...)
				CreateRealTimeThread(ChoOrig_Building_CheatUpgradeX, ...)
			end
		end
	end -- do

	do -- CheatFill (speedup large cheat fills)
		local function SuspendAndFire(func, ...)
			SuspendPassEdits("ChoGGi_SuspendAndFire_CheatFill")
			local ret = func(...)
			ResumePassEdits("ChoGGi_SuspendAndFire_CheatFill")
			return ret
		end

		local ChoOrig_MechanizedDepot_CheatFill = MechanizedDepot.CheatFill
		function MechanizedDepot.CheatFill(...)
			return SuspendAndFire(ChoOrig_MechanizedDepot_CheatFill, ...)
		end

		local ChoOrig_UniversalStorageDepot_CheatFill = UniversalStorageDepot.CheatFill
		function UniversalStorageDepot.CheatFill(...)
			return SuspendAndFire(ChoOrig_UniversalStorageDepot_CheatFill, ...)
		end
	end -- do

	-- that's what we call a small font
	local ChoOrig_XWindow_UpdateMeasure = XWindow.UpdateMeasure
	local ChoOrig_XSizeConstrainedWindow_UpdateMeasure = XSizeConstrainedWindow.UpdateMeasure
	function XSizeConstrainedWindow.UpdateMeasure(...)
		if UserSettings.StopSelectionPanelResize then
			return ChoOrig_XWindow_UpdateMeasure(...)
		end
		return ChoOrig_XSizeConstrainedWindow_UpdateMeasure(...)
	end

	-- allows you to build outside buildings inside and vice
	local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
	function CursorBuilding:GameInit(...)
		if self.template_obj then
			if UserSettings.RemoveBuildingLimits then
				self.template_obj.dome_required = false
				self.template_obj.dome_forbidden = false
			elseif self.template_obj then
				self.template_obj.dome_required = self.template_obj:GetDefaultPropertyValue("dome_required")
				self.template_obj.dome_forbidden = self.template_obj:GetDefaultPropertyValue("dome_forbidden")
			end
		end
		return ChoOrig_CursorBuilding_GameInit(self, ...)
	end

	-- stupid supply pods don't want to play nice (override for custom_travel_time_mars/custom_travel_time_earth)
	local ChoOrig_RocketExpedition_ExpeditionSleep = RocketExpedition.ExpeditionSleep
	function RocketExpedition:ExpeditionSleep(s_t, ...)
		if UserSettings.TravelTimeEarthMars then
			s_t = g_Consts.TravelTimeEarthMars
		end
		return ChoOrig_RocketExpedition_ExpeditionSleep(self, s_t, ...)
	end

	local ChoOrig_RocketBase_FlyToEarth = RocketBase.FlyToEarth
	function RocketBase:FlyToEarth(flight_time, ...)
		if UserSettings.TravelTimeMarsEarth then
			flight_time = g_Consts.TravelTimeMarsEarth
		end
		return ChoOrig_RocketBase_FlyToEarth(self, flight_time, ...)
	end

	local ChoOrig_RocketBase_FlyToMars = RocketBase.FlyToMars
	function RocketBase:FlyToMars(cargo, cost, flight_time, ...)
		if UserSettings.TravelTimeEarthMars then
			flight_time = g_Consts.TravelTimeEarthMars
		end
		return ChoOrig_RocketBase_FlyToMars(self, cargo, cost, flight_time, ...)
	end

	-- no need for fuel to launch rocket
	local ChoOrig_RocketBase_HasEnoughFuelToLaunch = RocketBase.HasEnoughFuelToLaunch
	function RocketBase.HasEnoughFuelToLaunch(...)
		return UserSettings.RocketsIgnoreFuel or ChoOrig_RocketBase_HasEnoughFuelToLaunch(...)
	end

	-- UI transparency cheats menu
	local ChoOrig_XShortcutsHost_SetVisible = XShortcutsHost.SetVisible
	function XShortcutsHost:SetVisible(...)
		SetDlgTrans(self)
		return ChoOrig_XShortcutsHost_SetVisible(self, ...)
	end

	-- larger trib/subsurfheater radius
	local ChoOrig_UIRangeBuilding_SetUIRange = UIRangeBuilding.SetUIRange
	function UIRangeBuilding:SetUIRange(radius, ...)
		local bs = UserSettings.BuildingSettings[self.template_name]
		if bs and bs.uirange then
			if self:IsKindOf("TriboelectricScrubber") then
				local props = self:GetProperties()
				local idx = table.find(props, "id", "UIRange")
				if idx then
					props[idx].max = bs.uirange
				end
			else
				radius = bs.uirange
			end
		end
		return ChoOrig_UIRangeBuilding_SetUIRange(self, radius, ...)
	end

	-- override any performance changes if needed
	local ChoOrig_Workplace_GetWorkshiftPerformance = Workplace.GetWorkshiftPerformance
	function Workplace:GetWorkshiftPerformance(...)
		local set = UserSettings.BuildingSettings[self.template_name]
		return set and set.performance_notauto or ChoOrig_Workplace_GetWorkshiftPerformance(self, ...)
	end

	-- block certain traits from workplaces
	local ChoOrig_Workplace_AddWorker = Workplace.AddWorker
	function Workplace:AddWorker(worker, shift, ...)
		local bs = UserSettings.BuildingSettings[self.template_name]
		-- check that the tables contain at least one trait
		local bt
		local rt
		if bs then
			bt = type(bs.blocktraits) == "table" and next(bs.blocktraits) and bs.blocktraits
			rt = type(bs.restricttraits) == "table" and next(bs.restricttraits) and bs.restricttraits
		end

		if bt or rt then
			local block, restrict = ChoGGi.ComFuncs.RetBuildingPermissions(worker.traits, bs)

			if block then
				return
			end
			if restrict then
				ChoOrig_Workplace_AddWorker(self, worker, shift, ...)
			end

		else
			ChoOrig_Workplace_AddWorker(self, worker, shift, ...)
		end
	end

	do -- SetDustVisuals/AddDust
		local function ChangeDust(dge, obj, dust, func, ...)
			if UserSettings.AlwaysCleanBuildings then
				dust = 0
				if dge then
					obj.dust_current = 0
				end
			elseif UserSettings.AlwaysDustyBuildings then
				if not obj.ChoGGi_AlwaysDust or obj.ChoGGi_AlwaysDust < dust then
					obj.ChoGGi_AlwaysDust = dust
				end
				dust = obj.ChoGGi_AlwaysDust
			end

			return func(obj, dust, ...)
		end

		-- set amount of dust applied
		local ChoOrig_BuildingVisualDustComponent_SetDustVisuals = BuildingVisualDustComponent.SetDustVisuals
		function BuildingVisualDustComponent:SetDustVisuals(dust, ...)
			return ChangeDust(false, self, dust, ChoOrig_BuildingVisualDustComponent_SetDustVisuals, ...)
		end
		--
		local ChoOrig_Building_SetDustVisuals = Building.SetDustVisuals
		function Building:SetDustVisuals(dust, ...)
			return ChangeDust(false, self, dust, ChoOrig_Building_SetDustVisuals, ...)
		end
		--
		local ChoOrig_DustGridElement_AddDust = DustGridElement.AddDust
		function DustGridElement:AddDust(dust, ...)
			return ChangeDust(true, self, dust, ChoOrig_DustGridElement_AddDust, ...)
		end
	end --do

	-- change dist we can charge from cables
	local ChoOrig_BaseRover_GetCableNearby = BaseRover.GetCableNearby
	function BaseRover:GetCableNearby(rad, ...)
		local new_rad = UserSettings.RCChargeDist
		if new_rad then
			rad = new_rad
		end
		return ChoOrig_BaseRover_GetCableNearby(self, rad, ...)
	end

	do -- InfopanelObj:CreateCheatActions
		local SetInfoPanelCheatHints = ChoGGi.InfoFuncs.SetInfoPanelCheatHints
		local GetActionsHost = GetActionsHost

		local ChoOrig_InfopanelObj_CreateCheatActions = InfopanelObj.CreateCheatActions
		function InfopanelObj:CreateCheatActions(win, ...)
			-- fire orig func to build cheats
			if ChoOrig_InfopanelObj_CreateCheatActions(self, win, ...) then
				-- then we can add some hints to the cheats
				return SetInfoPanelCheatHints(GetActionsHost(win))
			end
		end
	end -- do

	do -- XWindow:SetModal
		-- I fucking hate modal windows
		if testing then
			local ChoOrig_XWindow_SetModal = XWindow.SetModal
			function XWindow:SetModal(set, ...)
				if set then
					return
				end
				return ChoOrig_XWindow_SetModal(self, set, ...)
			end

		end
	end -- do

	do -- InfopanelDlg:RecalculateMargins
	-- last checked source: Tito Hotfix2
		local GetSafeMargins = GetSafeMargins
		local box = box

		-- stop using 58 and the pins size for the selection panel margins
		function InfopanelDlg:RecalculateMargins()
			-- If infobar then use min-height of pad
			local top_margin = 0
			local infobar = Dialogs.Infobar
			if infobar then
				top_margin = infobar.box:sizey()
			end

			local margins = GetSafeMargins()
			margins = box(margins:minx(), margins:miny() + top_margin, margins:maxx(), margins:maxy())

			self:SetMargins(margins)
		end
	end -- do

	-- Adding some ... to folders
	do -- XMenuEntry:SetShortcut
		local margin = box(10, 0, 0, 0)

		local ChoOrig_XMenuEntry_SetShortcut = XMenuEntry.SetShortcut
		function XMenuEntry:SetShortcut(...)

			if self.Icon == "CommonAssets/UI/Menu/folder.tga" then
				local label = XLabel:new({
					Dock = "right",
					VAlign = "center",
					Margins = margin,
				}, self)
				label:SetFontProps(self)
				label:SetText("...")
			else
				ChoOrig_XMenuEntry_SetShortcut(self, ...)
			end

		end
	end -- do

	do -- XPopupMenu:RebuildActions
	-- last checked source: Tito Hotfix2
		local XTemplateSpawn = XTemplateSpawn

		-- yeah who gives a rats ass about mouseover hints on menu items
		function XPopupMenu:RebuildActions(host, ...)
			local menu = self.MenuEntries
			local popup = self.ActionContextEntries
			local context = host.context
			local ShowIcons = self.ShowIcons
			self.idContainer:DeleteChildren()
			for i = 1, #host.actions do
				local action = host.actions[i]
				if #popup == 0 and #menu ~= 0 and action.ActionMenubar == menu and host:FilterAction(action) or #popup ~= 0 and host:FilterAction(action, popup) then
					local entry = XTemplateSpawn(action.ActionToggle and self.ToggleButtonTemplate or self.ButtonTemplate, self.idContainer, context)

					-- that was hard...
					if type(action.RolloverText) == "function" then
						entry.RolloverText = action.RolloverText()
					else
						entry.RolloverText = action.RolloverText
					end
					entry.RolloverTitle = TranslationTable[126095410863--[[Info]]]
					-- If this func added the id or something then i wouldn't need to do this copy n paste :(

					function entry.OnPress(this, _)
						if action.OnActionEffect ~= "popup" then
							self:ClosePopupMenus()
						end
						host:OnAction(action, this)
						if action.ActionToggle and IsValidXWin(self) then
							self:RebuildActions(host)
						end
					end
					function entry.OnAltPress(this, _)
						self:ClosePopupMenus()
						if action.OnAltAction then
							action:OnAltAction(host, this)
						end
					end
					entry:SetFontProps(self)
					entry:SetTranslate(action.ActionTranslate)
					entry:SetText(action.ActionName)
					if action.ActionToggle then
						entry:SetToggled(action:ActionToggled(host))
					else
						entry:SetIconReservedSpace(self.IconReservedSpace)
					end
					if ShowIcons then
						entry:SetIcon(action:ActionToggled(host) and action.ActionToggledIcon ~= "" and action.ActionToggledIcon or action.ActionIcon)
					end
					entry:SetShortcut(Platform.desktop and action.ActionShortcut or action.ActionGamepad)
					if action:ActionState(host) == "disabled" then
						entry:SetEnabled(false)
					end

					entry:Open()
				end
			end

		end
	end -- do

	-- this one is easier than XPopupMenu, since it keeps a ref to the action (devs were kind enough to add a single line of "button.action = action")
	local ChoOrig_XToolBar_RebuildActions = XToolBar.RebuildActions
	function XToolBar:RebuildActions(...)
		ChoOrig_XToolBar_RebuildActions(self, ...)
		-- we only care for the cheats menu toolbar tooltips thanks
		if self.Toolbar ~= "DevToolbar" then
			return
		end
		local buttons_c = #self
		-- If any of them are a func then change it to the text
		for i = 1, buttons_c do
			local button = self[i]
			if type(button:GetRolloverText()) == "function" then
				function button.GetRolloverText()
					return button.action.RolloverText()
				end
			end
		end
		-- hide it if no buttons
		if buttons_c == 0 then
			self.parent:SetVisible()
		else
			self.parent:SetVisible(true)
		end

	end

	do --XMenuBar:RebuildActions
		local function SetVis(entry, options, mod_option)
			if options:GetProperty(mod_option) then
				entry:SetVisible(false)
				entry.FoldWhenHidden = true
			else
				entry:SetVisible(true)
			end
		end
		--
		local lookup_id = {
			[27--[[Cheats]]] = "HideCheatsMenu",
			[302535920000002--[[ECM]]] = "HideECMMenu",
			[283142739680--[[Game]]] = "HideGameMenu",
			[1000113--[[Debug]]] = "HideDebugMenu",
			[487939677892--[[Help]]] = "HideHelpMenu",
		}

		local ChoOrig_XMenuBar_RebuildActions = XMenuBar.RebuildActions
		function XMenuBar:RebuildActions(...)

			ChoOrig_XMenuBar_RebuildActions(self, ...)
			-- we only care for the cheats menu thanks (not that there's any other menu toolbars)
			if self.MenuEntries ~= "DevMenu" then
				return
			end

			local TGetID = TGetID
			local options = CurrentModOptions
			-- not built yet (calling options:GetProperty(X) would give us blank options)
			if #options.properties == 0 then
				return
			end

			for i = 1, #self do
				local entry = self[i]
				SetVis(entry, options, lookup_id[TGetID(entry.Text)])
			end
		end
	end -- do

end -- ClassesGenerate

function OnMsg.ClassesPostprocess()

	-- align popups to rightside when using vertical cheat menu
	local ChoOrig_XMenuBar_PopupAction = XMenuBar.PopupAction
	function XMenuBar:PopupAction(action_id, ...)
		if not ChoGGi.UserSettings.VerticalCheatMenu then
			return ChoOrig_XMenuBar_PopupAction(self, action_id, ...)
		end
		-- orig func doesn't return anything anyways
		ChoOrig_XMenuBar_PopupAction(self, action_id, ...)
		local idx = table.find(terminal.desktop, "MenuEntries", action_id)
		if not idx then
			print("ECM Sez: no idx VerticalCheatMenu_Toggle XMenuBar:PopupAction")
			return
		end
		terminal.desktop[idx]:SetAnchorType("smart")
	end

	local ChoOrig_SpaceElevator_DroneUnloadResource = SpaceElevator.DroneUnloadResource
	function SpaceElevator:DroneUnloadResource(...)
		local export_when = ChoGGi.ComFuncs.DotPathToObject("ChoGGi.UserSettings.BuildingSettings.SpaceElevator.export_when_this_amount")
		local amount = self.max_export_storage - self.export_request:GetActualAmount()
		if export_when and amount >= export_when then
			self.pod_thread = CreateGameTimeThread(function()
				self:ExportGoods()
				self.pod_thread = nil
			end)
		end
		return ChoOrig_SpaceElevator_DroneUnloadResource(self, ...)
	end

	local ChoOrig_SpaceElevator_ToggleAllowExport = SpaceElevator.ToggleAllowExport
	function SpaceElevator:ToggleAllowExport(...)
		ChoOrig_SpaceElevator_ToggleAllowExport(self, ...)
		if self.allow_export and UserSettings.SpaceElevatorToggleInstantExport then
			self.pod_thread = CreateGameTimeThread(function()
				self:ExportGoods()
				self.pod_thread = nil
			end)
		end
	end

	-- unbreakable cables/pipes
	local ChoOrig_SupplyGridFragment_IsBreakable = SupplyGridFragment.IsBreakable
	function SupplyGridFragment.IsBreakable(...)
		if UserSettings.CablesAndPipesNoBreak then
			return false
		end
		return ChoOrig_SupplyGridFragment_IsBreakable(...)
	end
	--
	local ChoOrig_BreakableSupplyGridElement_CanBreak = BreakableSupplyGridElement.CanBreak
	function BreakableSupplyGridElement.CanBreak(...)
		if UserSettings.CablesAndPipesNoBreak then
			return false
		end
		return ChoOrig_BreakableSupplyGridElement_CanBreak(...)
	end

	-- no more pulsating pin motion
	local ChoOrig_XBlinkingButtonWithRMB_SetBlinking = XBlinkingButtonWithRMB.SetBlinking
	function XBlinkingButtonWithRMB:SetBlinking(...)
		if UserSettings.DisablePulsatingPinsMotion then
			self.blinking = false
		else
			return ChoOrig_XBlinkingButtonWithRMB_SetBlinking(self, ...)
		end
	end

	do -- MouseEvent/XEvent
		local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
		local function ResetFocus(func, self, event, ...)
			-- If the focus is currently on an ecm dialog then focus on previous xdialog
			if (event == "OnMouseButtonDown" or event == "OnXButtonDown")
					and self.keyboard_focus
					and GetParentOfKind(self.keyboard_focus, "ChoGGi_XWindow")
			then
				local focus_log = terminal.desktop.focus_log
				for i = #focus_log, 1, -1 do
					local obj = focus_log[i]
					if obj:IsKindOf("XDialog") then
						obj:SetFocus()
						break
					end
				end
			end
			return func(self, event, ...)
		end

		-- no more stuck focus on ECM textboxes/lists
		local ChoOrig_XDesktop_MouseEvent = XDesktop.MouseEvent
		function XDesktop:MouseEvent(event, ...)
			return ResetFocus(ChoOrig_XDesktop_MouseEvent, self, event, ...)
		end

		-- make sure focus isn't on my dialogs if gamepad is in play
		local ChoOrig_XDesktop_XEvent = XDesktop.XEvent
		function XDesktop:XEvent(event, ...)
			return ResetFocus(ChoOrig_XDesktop_XEvent, self, event, ...)
		end
	end -- do

	-- removes earthsick effect
	local ChoOrig_Colonist_ChangeComfort = Colonist.ChangeComfort
	function Colonist:ChangeComfort(...)
		ChoOrig_Colonist_ChangeComfort(self, ...)
		if UserSettings.NoMoreEarthsick and self.status_effects.StatusEffect_Earthsick then
			self:Affect("StatusEffect_Earthsick", false)
		end
	end

	-- make sure heater keeps the powerless setting
	local ChoOrig_SubsurfaceHeater_UpdateElectricityConsumption = SubsurfaceHeater.UpdateElectricityConsumption
	function SubsurfaceHeater:UpdateElectricityConsumption(...)
		ChoOrig_SubsurfaceHeater_UpdateElectricityConsumption(self, ...)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.ComFuncs.RemoveBuildingElecConsump(self)
		end
	end

	-- same for tribby
	local ChoOrig_TriboelectricScrubber_OnPostChangeRange = TriboelectricScrubber.OnPostChangeRange
	function TriboelectricScrubber:OnPostChangeRange(...)
		ChoOrig_TriboelectricScrubber_OnPostChangeRange(self, ...)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.ComFuncs.RemoveBuildingElecConsump(self)
		end
	end

	-- remove idiot trait from uni grads (hah!)
	local ChoOrig_MartianUniversity_OnTrainingCompleted = MartianUniversity.OnTrainingCompleted
	function MartianUniversity:OnTrainingCompleted(unit, ...)
		if UserSettings.UniversityGradRemoveIdiotTrait then
			unit:RemoveTrait("Idiot")
		end
		ChoOrig_MartianUniversity_OnTrainingCompleted(self, unit, ...)
	end

	-- used to skip mystery sequences
	do -- SkipMystStep
		local function SkipMystStep(self, func, ...)
			local StopWait = ChoGGi.Temp.SA_WaitMarsTime_StopWait
			local p = self.meta.player

			if StopWait and p and StopWait.seed == p.seed then
				-- Inform user, or if it's a dbl then skip
				if StopWait.skipmsg then
					StopWait.skipmsg = nil
				else
					MsgPopup(
						TranslationTable[302535920000735--[[Timer delay skipped]]],
						TranslationTable[3486--[[Mystery]]]
					)
				end

				-- only set on first SA_WaitExpression, as there's always a SA_WaitMarsTime after it and if we're skipping then skip...
				if StopWait.again == true then
					StopWait.again = nil
					StopWait.skipmsg = true
				else
					--reset it for next time
					StopWait.seed = false
					StopWait.again = false
				end

				-- skip
				return 1
			end

			return func(self, ...)
		end

		local ChoOrig_SA_WaitTime_StopWait = SA_WaitTime.StopWait
		function SA_WaitTime:StopWait(...)
			return SkipMystStep(self, ChoOrig_SA_WaitTime_StopWait, ...)
		end
		--
		local ChoOrig_SA_WaitMarsTime_StopWait = SA_WaitMarsTime.StopWait
		function SA_WaitMarsTime:StopWait(...)
			return SkipMystStep(self, ChoOrig_SA_WaitMarsTime_StopWait, ...)
		end
	end -- do

	-- keep prod at saved values for grid producers (air/water/elec)
	local ChoOrig_SupplyGridElement_SetProduction = SupplyGridElement.SetProduction
	function SupplyGridElement:SetProduction(new_production, new_throttled_production, update, ...)
		local amount = UserSettings.BuildingSettings[self.building.template_name]
		if amount and amount.production then
			-- set prod
			new_production = self.building.working and amount.production or 0
			-- set displayed prod
			if self:IsKindOf("AirGridFragment") then
				self.building.air_production = self.building.working and amount.production or 0
			elseif self:IsKindOf("WaterGrid") then
				self.building.water_production = self.building.working and amount.production or 0
			elseif self:IsKindOf("ElectricityGrid") then
				self.building.electricity_production = self.building.working and amount.production or 0
			end
		end
		ChoOrig_SupplyGridElement_SetProduction(self, new_production, new_throttled_production, update, ...)
	end

	-- and for regular producers (factories/extractors)
	local ChoOrig_SingleResourceProducer_Produce = SingleResourceProducer.Produce
	function SingleResourceProducer:Produce(amount_to_produce, ...)
		local amount = UserSettings.BuildingSettings[self.parent.template_name]
		if amount and amount.production then
			-- set prod
			amount_to_produce = amount.production / guim
			-- set displayed prod
			self.production_per_day = amount.production
		end

		-- get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
		if UserSettings.DroneResourceCarryAmountFix and self:GetStoredAmount() > 1000 then
			ChoGGi.ComFuncs.FuckingDrones(self, "single")
		end

		return ChoOrig_SingleResourceProducer_Produce(self, amount_to_produce, ...)
	end

	-- larger drone work radius
	do -- SetWorkRadius
		local function SetHexRadius(func, setting, obj, orig_radius, ...)
			local new_rad = UserSettings[setting]
			if new_rad then
				return func(obj, new_rad, ...)
			end
			return func(obj, orig_radius, ...)
		end

		local ChoOrig_RCRover_SetWorkRadius = RCRover.SetWorkRadius
		function RCRover:SetWorkRadius(radius, ...)
			SetHexRadius(ChoOrig_RCRover_SetWorkRadius, "RCRoverMaxRadius", self, radius, ...)
		end
		--
		local ChoOrig_DroneHub_SetWorkRadius = DroneHub.SetWorkRadius
		function DroneHub:SetWorkRadius(radius, ...)
			SetHexRadius(ChoOrig_DroneHub_SetWorkRadius, "CommandCenterMaxRadius", self, radius, ...)
		end
	end -- do

	-- toggle trans on mouseover
	local ChoOrig_XWindow_OnMouseEnter = XWindow.OnMouseEnter
	function XWindow:OnMouseEnter(...)
		if UserSettings.TransparencyToggle then
			self:SetTransparency(0)
		end
		return ChoOrig_XWindow_OnMouseEnter(self, ...)
	end
	--
	local ChoOrig_XWindow_OnMouseLeft = XWindow.OnMouseLeft
	function XWindow:OnMouseLeft(...)
		if UserSettings.TransparencyToggle then
			SetDlgTrans(self)
		end
		return ChoOrig_XWindow_OnMouseLeft(self, ...)
	end

	-- remove spire spot limit
	do -- ConstructionController:UpdateCursor
	-- last checked source: Picard 1007933
		local IsValid = IsValid
		local FixConstructPos = FixConstructPos
		local UnbuildableZ = buildUnbuildableZ()

		local ChoOrig_ConstructionController_UpdateCursor = ConstructionController.UpdateCursor
		function ConstructionController:UpdateCursor(pos, force, ...)
			if self.is_template and IsValid(self.cursor_obj)
				and self.template_obj.dome_spot == "Spire"
				and UserSettings.Building_dome_spot
			then
				self.spireless_dome = false
				local hex_world_pos = HexGetNearestCenter(pos)
				local game_map = GetGameMap(self)
--~ 				local build_z = g_BuildableZ and GetBuildableZ(WorldToHex(hex_world_pos)) or UnbuildableZ
				local build_z = game_map.buildable:GetZ(WorldToHex(hex_world_pos)) or UnbuildableZ
				local terrain = game_map.terrain

				if build_z == UnbuildableZ then
					build_z = pos:z() or terrain:GetHeight(pos)
				end
				hex_world_pos = hex_world_pos:SetZ(build_z)

				-- almost complete copy pasta from ConstructionController:UpdateCursor()
				-- just comment out this chunk
--~ 				local placed_on_spot = false
--~ 				if self.is_template and not self.template_obj.dome_forbidden and self.template_obj.dome_spot ~= "none" then --dome not prohibited
--~ 					local dome = GetDomeAtPoint(hex_world_pos)
--~ 					if dome and IsValid(dome) and IsKindOf(dome, "Dome") then
--~ 						if dome:HasSpot(self.template_obj.dome_spot) then
--~ 							local idx = dome:GetNearestSpot(self.template_obj.dome_spot, hex_world_pos)
--~ 							hex_world_pos = HexGetNearestCenter(dome:GetSpotPos(idx))
--~ 							placed_on_spot = true
--~ 							if self.template_obj.dome_spot == "Spire" then
--~ 								if self.template_obj:IsKindOf("SpireBase") then
--~ 									local frame = self.cursor_obj:GetAttach("SpireFrame")
--~ 									if frame then
--~ 										local spot = dome:GetNearestSpot("idle", "Spireframe", self.cursor_obj)
--~ 										local pos = dome:GetSpotPos(spot)
--~ 										frame:SetAttachOffset(pos - hex_world_pos)
--~ 									end
--~ 								end
--~ 							end
--~ 						elseif self.template_obj.dome_spot == "Spire" then
--~ 							self.spireless_dome = true
--~ 						end
--~ 					end
--~ 				end
--~ 				local new_pos = self.snap_to_grid and hex_world_pos or pos
--~ 				if not placed_on_spot then
--~ 					new_pos = FixConstructPos(new_pos)
--~ 				end

				local new_pos = FixConstructPos(terrain, self.snap_to_grid and hex_world_pos or pos)

				if force or (FixConstructPos(terrain, self.cursor_obj:GetPos()) ~= new_pos and hex_world_pos:InBox2D(ConstructableArea)) then
					ShowNearbyHexGrid(hex_world_pos)
					self.cursor_obj:SetPos(new_pos)
					self:UpdateConstructionObstructors()
					self:UpdateConstructionStatuses() --should go after obstructors
					self:UpdateShortConstructionStatus()
					ObjModified(self)
				end

			else
				return ChoOrig_ConstructionController_UpdateCursor(self, pos, force, ...)
			end

		end
	end -- do

	-- make the background hide when console not visible (instead of after a second or two)
	do -- ConsoleLog:ShowBackground
	-- last checked source: Tito Hotfix2
		local RGBA = RGBA

		function ConsoleLog:ShowBackground(visible, immediate)
			if config.ConsoleDim ~= 0 then
				DeleteThread(self.background_thread)
				if visible or immediate then
					self:SetBackground(RGBA(0, 0, 0, visible and 96 or 0))
				else
--~ 					self.background_thread = CreateRealTimeThread(function()
--~ 						Sleep(3000)
--~ 						local r, g, b, a = GetRGBA(self:GetBackground())
--~ 						while a > 0 do
--~ 							a = Max(0, a - 5)
--~ 							self:SetBackground(RGBA(0, 0, 0, a))
--~ 							Sleep(20)
--~ 						end
--~ 					end)
					-- no fade plz
					self:SetBackground(RGBA(0, 0, 0, 0))
				end
			end
		end
	end -- do

	-- ChoGGi.ComFuncs.ToggleConsole(show)

	-- tweak console when it's "opened"
	local ChoOrig_Console_Show = Console.Show
	function Console:Show(show, ...)
		ChoOrig_Console_Show(self, show, ...)
		if show then
			-- adding transparency for console stuff
			SetDlgTrans(self)
			-- and rebuild my console buttons
			ChoGGi.ConsoleFuncs.RebuildConsoleToolbar(self)
			-- show log if console log is enabled
			if UserSettings.ConsoleToggleHistory then
				if dlgConsoleLog then
					dlgConsoleLog:SetVisible(true)
				else
					ShowConsoleLog(true)
				end
			end
		elseif UserSettings.ConsoleShowLogWhenActive then
			if dlgConsoleLog then
				dlgConsoleLog:SetVisible(false)
			end
		end
		-- move log up n down
		ChoGGi.ComFuncs.UpdateConsoleMargins(show)
	end

	do -- Console:AddHistory
		local skip_cmds = {
			quit = true,
			["quit()"] = true,
			exit = true,
			["exit()"] = true,
			reboot = true,
			["reboot()"] = true,
			restart = true,
			["restart()"] = true,
			["quit(\"restart\")"] = true,
			["quit('restart')"] = true,
		}
		-- skip quit from being added to console history to prevent annoyances
		local ChoOrig_Console_AddHistory = Console.AddHistory
		function Console:AddHistory(text, ...)
			if skip_cmds[text] or text:sub(1, 5) == "quit(" then
				return
			end
			return ChoOrig_Console_AddHistory(self, text, ...)
		end
	end -- do

	-- kind of an ugly way of making sure console doesn't include ` when using tilde to open console
	-- I could do a thread and wait till the key isn't pressed, but it's slower
	-- this does block user from typing in `, but eh
	local ChoOrig_Console_TextChanged = Console.TextChanged
	function Console:TextChanged(...)
		ChoOrig_Console_TextChanged(self, ...)
		local text = self.idEdit:GetText()

		if text:sub(-1) == "`" then
			self.idEdit:SetText(text:sub(1, -2))
			self.idEdit:SetCursor(1, #text-1)
		end
	end

	do -- Console HistoryDown/HistoryUp
		-- make it so caret is at the end of the text when you use history (who the heck wants it at the start...)
		local function HistoryEnd(func, self, ...)
			func(self, ...)
			self.idEdit:SetCursor(1, #self.idEdit:GetText())
		end

		local ChoOrig_Console_HistoryDown = Console.HistoryDown
		function Console:HistoryDown(...)
			HistoryEnd(ChoOrig_Console_HistoryDown, self, ...)
		end
		--
		local ChoOrig_Console_HistoryUp = Console.HistoryUp
		function Console:HistoryUp(...)
			HistoryEnd(ChoOrig_Console_HistoryUp, self, ...)
		end
	end -- do

	do -- RequiresMaintenance:AddDust
		-- It wasn't checking if it was a number so we got errors in log
		local tonumber = tonumber

		local ChoOrig_RequiresMaintenance_AddDust = RequiresMaintenance.AddDust
		function RequiresMaintenance:AddDust(amount, ...)
			-- maybe something was sending a "number" instead of number?
			amount = tonumber(amount)
			if amount then
				return ChoOrig_RequiresMaintenance_AddDust(self, amount, ...)
			end
		end
	end -- do

	-- so we can do long spaced tunnels
	local ChoOrig_TunnelConstructionController_UpdateConstructionStatuses = TunnelConstructionController.UpdateConstructionStatuses
	function TunnelConstructionController:UpdateConstructionStatuses(...)
		if UserSettings.RemoveBuildingLimits then
			local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
			self:FinalizeStatusGathering(old_t)
		else
			return ChoOrig_TunnelConstructionController_UpdateConstructionStatuses(self, ...)
		end
	end

	-- add height limits to certain panels (cheats/traits/colonists) till mouseover, and convert workers to vertical list on mouseover if over 14 (visible limit)
	do -- InfopanelDlg:Open
		local function ToggleVis(idx, content, v, h)
			for i = 6, idx do
				local con = content[i]
				if con then
					con:SetVisible(v)
					con:SetMaxHeight(h)
				end
			end
		end
		local cls_training = {"Sanatorium", "School"}
		local infopanel_list = {
			ipBuilding = true,
			ipColonist = true,
			ipDrone = true,
			ipRover = true,
		}

		-- show scroll on hover
		local ChoOrig_InfopanelDlg_OnMouseEnter = InfopanelDlg.OnMouseEnter
		function InfopanelDlg:OnMouseEnter(...)
			-- show scrollbar
			if UserSettings.ScrollSelectionPanel and infopanel_list[self.XTemplate]
				 and IsValidXWin(self.idChoGGi_Scrollbar_thumb)
			then
				self.idChoGGi_Scrollbar_thumb:SetVisible(true)
			end

			return ChoOrig_InfopanelDlg_OnMouseEnter(self, ...)
		end

		local ChoOrig_InfopanelDlg_OnMouseLeft = InfopanelDlg.OnMouseLeft
		function InfopanelDlg:OnMouseLeft(...)
			-- hide scrollbar
			if UserSettings.ScrollSelectionPanel and infopanel_list[self.XTemplate]
				 and IsValidXWin(self.idChoGGi_Scrollbar_thumb)
			then
				self.idChoGGi_Scrollbar_thumb:SetVisible(false)
			end
			return ChoOrig_InfopanelDlg_OnMouseLeft(self, ...)
		end

		local zerobox = box(0, 0, 0, 0)
		local function SetToolbar(section, cls, toggle)
			local toolbar = table.find(section.idContent, "class", cls)
			if toolbar then
				toolbar = section.idContent[toolbar]
				toolbar.FoldWhenHidden = true
				toolbar:SetVisible(toggle)
				return toolbar
			end
		end

		local function ToggleVisSection(section, toolbar, toggle, setting)
			local title = section.idHighlight

			if setting == "InfopanelCheatsVis" then
				section = section.idSectionTitle
			end
			--
			if setting ~= "InfopanelMainButVis" then
				section.OnMouseEnter = function()
					title:SetVisible(true)
				end
				section.OnMouseLeft = function()
					title:SetVisible()
				end
			end
			--
			if toolbar and IsValidXWin(toolbar) then
				section.OnMouseButtonDown = function()
					if toggle then
						toolbar:SetVisible()
						toggle = false
					else
						toolbar:SetVisible(true)
						toggle = true
					end
					if setting then
						ChoGGi.Temp[setting] = not toggle
					end
				end
			end
			--
		end

		local function InfopanelDlgOpen(self)
			-- make sure infopanel is above hud (and pins)
			local hud = Dialogs.HUD
			if hud then
				self:SetZOrder(hud.ZOrder+1 or 1)
			end

			-- give me the scroll. goddamn it blinky
			if UserSettings.ScrollSelectionPanel and infopanel_list[self.XTemplate] then
				if self.idActionButtons then
					self.idActionButtons.parent:SetZOrder(2)
				end
				local g_Classes = g_Classes

				local dlg = self[1]

				-- attach our scroll area to the XSizeConstrainedWindow
				self.idChoGGi_ScrollArea = g_Classes.XWindow:new({
					Id = "idChoGGi_ScrollArea",
				}, dlg)

				self.idChoGGi_ScrollV = g_Classes.XSleekScroll:new({
					Id = "idChoGGi_ScrollV",
					Target = "idChoGGi_ScrollBox",
					Dock = "left",
					MinThumbSize = 30,
					Background = 0,
					AutoHide = true,
				}, self.idChoGGi_ScrollArea)

				self.idChoGGi_Scrollbar_thumb = self.idChoGGi_ScrollV.idThumb

				-- [LUA ERROR] attempt to index a boolean value (local 'desktop')
				self.idChoGGi_ScrollV.idThumb.desktop = terminal.desktop
				self.idChoGGi_ScrollV.idThumb:SetVisible(false)

				self.idChoGGi_ScrollBox = g_Classes.XScrollArea:new({
					Id = "idChoGGi_ScrollBox",
					VScroll = "idChoGGi_ScrollV",
					LayoutMethod = "VList",
				}, self.idChoGGi_ScrollArea)

				if self.idContent then
					-- move content list to scrollarea
					self.idContent:SetParent(self.idChoGGi_ScrollBox)
					-- add ref back
					self.idContent = self.idChoGGi_ScrollBox.idContent
					-- move panel to top of screen (maybe space for infobar?)
					self:SetMargins(zerobox)

					-- add height limit for infopanel
					local height = (terminal.desktop.box:sizey()
						- self.idMainButtons.parent.parent.box:sizey()
					)
					local bb = hud.idMapSwitch
					if not bb then
						height = height + self.idActionButtons.box:sizey()
					end

					self.idChoGGi_ScrollArea:SetMaxHeight(height)
				end
			end

			-- add toggle to main buttons area
			local main_buts = GetParentOfKind(self.idMainButtons, "XFrame")
			if main_buts then
				local title = self.idTitle.parent
				title.FXMouseIn = "ActionButtonHover"
				title.HandleMouse = true
				title.RolloverTemplate = "Rollover"
				title.RolloverTitle = TranslationTable[302535920001367--[[Toggles]]]
				title.RolloverText = TranslationTable[302535920001410--[[Toggle Visibility]]]
				title.RolloverHint = TranslationTable[608042494285--[[<left_click> Activate]]]

				local toggle = not ChoGGi.Temp.InfopanelMainButVis
				local toolbar = main_buts[2]
				toolbar.FoldWhenHidden = true
				toolbar:SetVisible(toggle)

				ToggleVisSection(title, toolbar, toggle, "InfopanelMainButVis")
			end

			local content = self.idContent
			if not content then
				content = self.idChoGGi_ScrollBox and self.idChoGGi_ScrollBox.idContent
			end
			if not content then
				return
			end

			-- this limits height of traits you can choose to 3 till mouse over
			if UserSettings.SanatoriumSchoolShowAll and self.context:IsKindOfClasses(cls_training) then

				local idx
				if self.context:IsKindOf("School") then
					idx = 20
				else
					-- Sanitarium
					idx = 18
				end

				-- Initially set to hidden
				ToggleVis(idx, content, false, 0)

				local visthread
				self.OnMouseEnter = function()
					DeleteThread(visthread)
					ToggleVis(idx, content, true)
				end
				self.OnMouseLeft = function()
					visthread = CreateRealTimeThread(function()
						Sleep(1000)
						ToggleVis(idx, content, false, 0)
					end)
				end

			end
			--
			local section = table.find_value(content, "Id", "idsectionCheats_ChoGGi")
			if section then
				section.idIcon.FXMouseIn = "ActionButtonHover"
				section.idSectionTitle.MouseCursor = "UI/Cursors/Rollover.tga"
				section.RolloverText = TranslationTable[302535920001410--[[Toggle Visibility]]]
				section.RolloverHint = TranslationTable[608042494285--[[<left_click> Activate]]]

				local toggle = not ChoGGi.Temp.InfopanelCheatsVis
				local toolbar = SetToolbar(section, "XToolBar", toggle)

				ToggleVisSection(section, toolbar, toggle, "InfopanelCheatsVis")
				-- sets the scale of the cheats icons
				for j = 1, #toolbar do
					local icon = toolbar[j].idIcon
					icon:SetMaxHeight(27)
					icon:SetMaxWidth(27)
					icon:SetImageFit("largest")
				end
			end

			section = table.find_value(content, "Id", "idsectionResidence_ChoGGi")
			if section then
				local toggle = true
				if self.context.capacity > 100 then
					toggle = false
				end
				ToggleVisSection(section, SetToolbar(section, "XContextControl", toggle), toggle)
			end

			-- add limit to shifts sections
			local worker_count = 0
			for i = 1, #content do

				-- three shifts max
				if worker_count > 2 then
					break
				end

				local section = content[i]
				local content = section.idContent and section.idContent[2]

				-- enlarge worker section if over the max amount visible
				if content and section.idWorkers and #section.idWorkers > 14 then
					worker_count = worker_count + 1
					-- set height to default height
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
				end
			end

		end -- InfopanelDlgOpen

		-- the actual function
		local ChoOrig_InfopanelDlg_Open = InfopanelDlg.Open
		function InfopanelDlg:Open(...)
			CreateRealTimeThread(function()
				WaitMsg("OnRender")
				InfopanelDlgOpen(self)
			end)

			return ChoOrig_InfopanelDlg_Open(self, ...)
		end
	end -- do

end -- ClassesPP

-- blacklist stuff
function OnMsg.ChoGGi_UpdateBlacklistFuncs(env)
	-- Who knows, they may update the game someday?
	local blacklist = false

	-- WARNING: Unable to retrieve a function's source code while saving!
	-- WARNING: Unable to retrieve a function's source code while saving!
	-- WARNING: Unable to retrieve a function's source code while saving!
	if not blacklist then -- GetFuncSourceString
		local GetFuncSource = env.GetFuncSource
		local str1 = "function %s(%s) %s end"
		local str2 = "\nfunction %s(%s)\n%s\nend"

		function env.GetFuncSourceString(f, new_name, new_params)
			local name, params, body = GetFuncSource(f)
			if not body then
--~ 				print("WARNING: Unable to retrieve a function's source code while saving!")
--~ 				return "function() end"
				return RetName(f)
			end
			name = new_name or name
			params = new_params or params
			if type(body) == "string" then
				return str1:format(name, params, body)
			else
				return str2:format(name, params, table.concat(body, "\n"))
			end
		end
	end

	do -- Console:Exec
		-- override orig console rules with mine (thanks devs for making it a global var)
		ConsoleRules = {
			-- print info in console log
			{
				-- $userdata/string id
				"^$(.*)",
				"print(ChoGGi.ComFuncs.Translate(%s))"
			},
			{
				-- @function
				"^@(.*)",
				"print(ChoGGi.ComFuncs.DebugGetInfo(%s))",
			},
			{
				-- @@type
				"^@@(.*)",
				"print(type(%s))"
			},

			-- do stuff
			{
				-- !obj_on_map
				"^!(.*)",
				"ViewAndSelectObject(%s)"
			},
			{
				-- %image string or table
				"^%%(.*)",
				"OpenImageViewer(%s)"
			},
			{
				-- ^string
				"^%^(.*)",
				"OpenTextViewer(%s)"
			},
			{
				-- ~anything
				"^~(.*)",
				[[local params = {%s}
local t2 = type(params[2])
if #params == 1 then
	OpenExamine(params[1])
elseif #params == 3
		and type(params[3]) == "string"
		and (t2 == "table" or t2 == "userdata") then
	OpenExamine(params[1], {
		parent = params[2],
		title = params[3],
		has_params = true,
		override_title = true,
	})
else
	OpenExamine(params, {
		has_params = true,
		override_title = true,
		title = TranslationTable[302535920000069] .. " " .. TranslationTable[302535920001073]
			.. ": " .. ChoGGi.ComFuncs.RetName(params[1]),
	})
end]] -- title strings: Examine Console
			},
			{
				-- ~!obj_with_attachments
				"^~!(.*)",
				[[local obj = %s
local attaches = ChoGGi.ComFuncs.GetAllAttaches(obj)
if attaches[1] then
	OpenExamine(attaches, nil, "GetAllAttaches " .. ChoGGi.ComFuncs.RetName(obj))
end]]
			},
			{
				-- &handle
				"^&(.*)",
				[[OpenExamine(HandleToObject[%s], nil, "HandleToObject")]]
			},
			-- built-in
			{
				-- *r some function/cmd that needs a realtime thread
				"^*[rR]%s*(.*)",
				"CreateRealTimeThread(function() %s end)"
			},
			{
				-- *g gametime
				"^*[gG]%s*(.*)",
				"CreateGameTimeThread(function() %s end)"
			},
			-- prints out cmds entered I assume?
			{
				"^(%a[%w.]*)$",
				"ConsolePrint(print_format(__run(%s)))"
			},
			{
				"(.*)",
				"ConsolePrint(print_format(%s))"
			},
			{
				"(.*)",
				"%s"
			},
		}

		-- ReadHistory fires from :Show(), if it isn't loaded before you :Exec() then goodbye history
		local ChoOrig_Console_Exec = Console.Exec
		function Console:Exec(text, hide_text, ...)
			if not self.history_queue or #self.history_queue == 0 then
				self:ReadHistory()
			end
			if hide_text and not blacklist then
				-- same as Console:Exec(), but skips log text
				self:AddHistory(text)
--~ 				AddConsoleLog("> ", true)
--~ 				AddConsoleLog(text, false)
				local err = env.ConsoleExec(text, ConsoleRules)
				if err then
					ConsolePrint(err)
				end
				return
			end
			return ChoOrig_Console_Exec(self, text, hide_text, ...)
		end

--~ 		-- we can't do anything if blacklist is active
--~ 		if not blacklist then
--~ 			-- and now the console has a blacklist :), though i am a little suprised they left it unfettered this long, been using it as a workaround for months
--~ 			local WaitMsg = WaitMsg
--~ 			CreateRealTimeThread(function()
--~ 				if not g_ConsoleFENV then
--~ 					WaitMsg("Autorun")
--~ 				end
--~ 				while not g_ConsoleFENV do
--~ 					Sleep(1000)
--~ 				end

--~ 				local original_G = _G
--~ 				local rawset = original_G.rawset
--~ 				local run = original_G.rawget(g_ConsoleFENV, "__run")

--~ 				g_ConsoleFENV = {__run = run}
--~ 				setmetatable(g_ConsoleFENV, {
--~ 					__index = function(_, key)
--~ 						return original_G[key]
--~ 					end,
--~ 					__newindex = function(_, key, value)
--~ 						-- bye bye annoying [LUA ERROR] Attempt to create a new global xxx (well for the console at least)
--~ 						rawset(original_G, key, value)
--~ 					end,
--~ 				})
--~ 			end)
--~ 		end

	end -- do

end -- ChoGGi_UpdateBlacklistFuncs
