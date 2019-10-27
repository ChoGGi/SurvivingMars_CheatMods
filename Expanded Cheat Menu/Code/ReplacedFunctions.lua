-- See LICENSE for terms

-- in-game functions replaced with custom ones

local type, rawget = type, rawget
local table_unpack = table.unpack
local Sleep = Sleep

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Translate = ChoGGi.ComFuncs.Translate
local TableConcat = ChoGGi.ComFuncs.TableConcat
local SetDlgTrans = ChoGGi.ComFuncs.SetDlgTrans
local RetName = ChoGGi.ComFuncs.RetName
local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
local UserSettings = ChoGGi.UserSettings
local Strings = ChoGGi.Strings
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

do -- non-class obj funcs

	-- this will reset override, so we sleep and reset it
	SaveOrigFunc("ClosePlanetCamera")
	function ClosePlanetCamera(...)
		if UserSettings.Lightmodel then
			CreateRealTimeThread(function()
				Sleep(100)
				SetLightmodelOverride(1, UserSettings.Lightmodel)
			end)
		end
		return ChoGGi_OrigFuncs.ClosePlanetCamera(...)
	end

	-- don't trigger quakes if setting is enabled
	SaveOrigFunc("TriggerMarsquake")
	function TriggerMarsquake(...)
		if not UserSettings.DisasterQuakeDisable then
			return ChoGGi_OrigFuncs.TriggerMarsquake(...)
		end
	end

	-- don't trigger toxic rains if setting is enabled
	SaveOrigFunc("RainProcedure")
	function RainProcedure(settings, ...)
		if settings.type == "normal" or not UserSettings.DisasterRainsDisable then
			return ChoGGi_OrigFuncs.RainProcedure(settings, ...)
		end
	end

	-- stops the help webpage from showing up every single time
	SaveOrigFunc("GedOpHelpMod")
	if Platform.editor and UserSettings.SkipModHelpPage then
		GedOpHelpMod = empty_func
	end

	-- get rid of "This savegame was loaded in the past without required mods or with an incompatible game version."
	SaveOrigFunc("WaitMarsMessage")
	function WaitMarsMessage(parent, title, msg, ...)
		if (testing or UserSettings.SkipIncompatibleModsMsg) and IsT(msg) == 10888 then
			return
		end
		return ChoGGi_OrigFuncs.WaitMarsMessage(parent, title, msg, ...)
	end

	-- examine persist errors (if any)
	function ReportPersistErrors(...)
		if UserSettings.DebugPersistSaves and __error_table__ and #__error_table__ > 0 then
			ChoGGi.ComFuncs.OpenInExamineDlg(__error_table__, nil, "__error_table__ (persists)")
		else
			ChoGGi_OrigFuncs.ReportPersistErrors(...)
		end
	end

	-- WARNING: Unable to retrieve a function's source code while saving!
	-- WARNING: Unable to retrieve a function's source code while saving!
	-- WARNING: Unable to retrieve a function's source code while saving!
	if not blacklist then -- GetFuncSourceString
		local GetFuncSource = GetFuncSource
		local str1 = "function %s(%s) %s end"
		local str2 = "\nfunction %s(%s)\n%s\nend"

		SaveOrigFunc("GetFuncSourceString")
		function GetFuncSourceString(f, new_name, new_params)
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
				return str2:format(name, params, TableConcat(body, "\n"))
			end
		end
	end

	SaveOrigFunc("TGetID")
	function TGetID(t, ...)
		local t_type = type(t)
		if t_type ~= "table" and t_type ~= "userdata" then
			return ChoGGi_OrigFuncs.TGetID(T(t, ...))
		end
		return ChoGGi_OrigFuncs.TGetID(t, ...)
	end

	-- I guess, don't pass a string to it?
	SaveOrigFunc("TDevModeGetEnglishText")
	function TDevModeGetEnglishText(t, ...)
		if type(t) == "string" then
			return t
		end
		return ChoGGi_OrigFuncs.TDevModeGetEnglishText(t, ...)
	end

	-- fix for sending nil id to it
	SaveOrigFunc("LoadCustomOnScreenNotification")
	function LoadCustomOnScreenNotification(notification, ...)
		-- the first return is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
		if table_unpack(notification) then
			return ChoGGi_OrigFuncs.LoadCustomOnScreenNotification(notification, ...)
		end
	end

	-- change rocket cargo cap
	SaveOrigFunc("GetMaxCargoShuttleCapacity")
	function GetMaxCargoShuttleCapacity(...)
		return UserSettings.StorageShuttle or ChoGGi_OrigFuncs.GetMaxCargoShuttleCapacity(...)
	end

	-- SkipMissingDLC and no mystery dlc installed means the buildmenu tries to add missing buildings, and call a func that doesn't exist
	SaveOrigFunc("UIGetBuildingPrerequisites")
	function UIGetBuildingPrerequisites(cat_id, template, bCreateItems, ...)
		if BuildingTemplates[template.id] then
			return ChoGGi_OrigFuncs.UIGetBuildingPrerequisites(cat_id, template, bCreateItems, ...)
		end
	end

	-- stops confirmation dialog about missing mods (still lets you know they're missing)
	SaveOrigFunc("GetMissingMods")
	function GetMissingMods(...)
		if UserSettings.SkipMissingMods then
			return "", false
		else
			return ChoGGi_OrigFuncs.GetMissingMods(...)
		end
	end

	-- lets you load saved games that have dlc
	SaveOrigFunc("IsDlcAvailable")
	function IsDlcAvailable(...)
		-- returns true if the setting is true, or return the orig func
		return UserSettings.SkipMissingDLC or ChoGGi_OrigFuncs.IsDlcAvailable(...)
	end

	-- always able to show console
	SaveOrigFunc("ShowConsole")
	function ShowConsole(visible, ...)
		if visible then
			-- ShowConsole checks for this
			ConsoleEnabled = true
		end
		return ChoGGi_OrigFuncs.ShowConsole(visible, ...)
	end

	-- console stuff
	SaveOrigFunc("ShowConsoleLog")
	function ShowConsoleLog(visible, ...)
		-- we only want to show it if:
		visible = UserSettings.ConsoleToggleHistory

		-- ShowConsoleLog doesn't check for existing like ShowConsole
		if rawget(_G, "dlgConsoleLog") then
			dlgConsoleLog:SetVisible(visible, ...)
		else
			ChoGGi_OrigFuncs.ShowConsoleLog(visible, ...)
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

		SaveOrigFunc("ShowPopupNotification")
		function ShowPopupNotification(preset, ...)
			if UserSettings.DisableHints and suggestions[preset] then
				return
			end
			return ChoGGi_OrigFuncs.ShowPopupNotification(preset, ...)
		end
	end -- do

	-- UI transparency dialogs (buildmenu, pins, infopanel)
	SaveOrigFunc("OpenDialog")
	function OpenDialog(...)
		return SetDlgTrans(ChoGGi_OrigFuncs.OpenDialog(...))
	end
end -- do

function OnMsg.ClassesGenerate()

	do -- LandscapeConstructionController:Activate
		local max_int = max_int

		-- no more limit to R+T
		SaveOrigFunc("LandscapeConstructionController", "Activate")
		function LandscapeConstructionController:Activate(...)
			if UserSettings.RemoveLandScapingLimits then
				self.brush_radius_step = 100
				self.brush_radius_max = max_int
				self.brush_radius_min = 100
			end
			return ChoGGi_OrigFuncs.LandscapeConstructionController_Activate(self, ...)
		end
	end -- do

	do -- DroneBase:RegisterDustDevil
		local fake_devil = {drone_speed_down = 0}
		-- stop drones/rovers from slowing down in dustdevils
		SaveOrigFunc("DroneBase", "RegisterDustDevil")
		function DroneBase:RegisterDustDevil(devil, ...)
			if (UserSettings.SpeedWaspDrone and self:IsKindOf("FlyingDrone"))
					or (UserSettings.SpeedDrone and self:IsKindOf("Drone") and not self:IsKindOf("FlyingDrone"))
					or (UserSettings.SpeedRC and self:IsKindOf("BaseRover")) then
				devil = fake_devil
			end
			return ChoGGi_OrigFuncs.DroneBase_RegisterDustDevil(self, devil, ...)
		end
	end -- do

	-- all storybit/neg/etc options enabled
	SaveOrigFunc("Condition", "Evaluate")
	function Condition.Evaluate(...)
		if UserSettings.OverrideConditionPrereqs then
			return true
		end
		return ChoGGi_OrigFuncs.Condition_Evaluate(...)
	end

	-- limit size of crops to window width - selection panel size
	do -- InfopanelItems:Open()
		local GetScreenSize = UIL.GetScreenSize
		local width = GetScreenSize():x() - 100
		function OnMsg.SystemSize()
			width = GetScreenSize():x() - 100
		end

		SaveOrigFunc("InfopanelItems", "Open")
		function InfopanelItems:Open(...)
			if UserSettings.LimitCropsUIWidth then
				self:SetMaxWidth(width - Dialogs.Infopanel.box:sizex())
			end
			return ChoGGi_OrigFuncs.InfopanelItems_Open(self, ...)
		end
	end -- do

	-- using the CheatUpgrade func in the cheats pane with Silva's Modular Apartments == inf loop
	do -- Building:CheatUpgrade*()
		local CreateRealTimeThread = CreateRealTimeThread
		local Building = Building
		for i = 1, 3 do
			local name = "CheatUpgrade" .. i
			SaveOrigFunc("Building", name)
			Building[name] = function(...)
				CreateRealTimeThread(ChoGGi_OrigFuncs["Building_CheatUpgrade" .. i], ...)
			end
		end
	end -- do

	do -- speedup large cheat fills
		local function SuspendAndFire(func, ...)
			SuspendPassEdits("SuspendAndFire:CheatFill")
			local ret = ChoGGi_OrigFuncs[func](...)
			ResumePassEdits("SuspendAndFire:CheatFill")
			return ret
		end

		SaveOrigFunc("MechanizedDepot", "CheatFill")
		function MechanizedDepot.CheatFill(...)
			return SuspendAndFire("MechanizedDepot_CheatFill", ...)
		end

		SaveOrigFunc("UniversalStorageDepot", "CheatFill")
		function UniversalStorageDepot.CheatFill(...)
			return SuspendAndFire("UniversalStorageDepot_CheatFill", ...)
		end
	end -- do

	-- that's what we call a small font
	do -- XSizeConstrainedWindow.UpdateMeasure
		local XWindow_UpdateMeasure = XWindow.UpdateMeasure

		SaveOrigFunc("XSizeConstrainedWindow", "UpdateMeasure")
		function XSizeConstrainedWindow.UpdateMeasure(...)
			if UserSettings.StopSelectionPanelResize then
				return XWindow_UpdateMeasure(...)
			end
			return ChoGGi_OrigFuncs.XSizeConstrainedWindow_UpdateMeasure(...)
		end
	end -- do

	do -- InfopanelDlg:RecalculateMargins
		local GetSafeMargins = GetSafeMargins
		local box = box

		-- stop using 58 and the pins size for the selection panel margins
		SaveOrigFunc("InfopanelDlg", "RecalculateMargins")
		function InfopanelDlg:RecalculateMargins()
			-- if infobar then use min-height of pad
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

	-- allows you to build on geysers
	SaveOrigFunc("ConstructionController", "IsObstructed")
	function ConstructionController:IsObstructed(...)
		if UserSettings.BuildOnGeysers then
			local o = self.construction_obstructors
			-- we need to make sure it's the only obstructor
			if o and #o == 1 and o[1] == g_DontBuildHere then
				return false
			end
		end
		return ChoGGi_OrigFuncs.ConstructionController_IsObstructed(self, ...)
	end

	SaveOrigFunc("DontBuildHere", "Check")
	function DontBuildHere.Check(...)
		if UserSettings.BuildOnGeysers then
			return false
		end
		return ChoGGi_OrigFuncs.DontBuildHere_Check(...)
	end

	-- allows you to build outside buildings inside and vice
	SaveOrigFunc("CursorBuilding", "GameInit")
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
		return ChoGGi_OrigFuncs.CursorBuilding_GameInit(self, ...)
	end

	-- stupid supply pods don't want to play nice
	SaveOrigFunc("SupplyRocket", "FlyToEarth")
	function SupplyRocket:FlyToEarth(flight_time, ...)
		if UserSettings.TravelTimeMarsEarth then
			flight_time = g_Consts.TravelTimeMarsEarth
		end
		return ChoGGi_OrigFuncs.SupplyRocket_FlyToEarth(self, flight_time, ...)
	end

	SaveOrigFunc("SupplyRocket", "FlyToMars")
	function SupplyRocket:FlyToMars(cargo, cost, flight_time, ...)
		if UserSettings.TravelTimeEarthMars then
			flight_time = g_Consts.TravelTimeEarthMars
		end
		return ChoGGi_OrigFuncs.SupplyRocket_FlyToMars(self, cargo, cost, flight_time, ...)
	end

	-- no need for fuel to launch rocket
	SaveOrigFunc("SupplyRocket", "HasEnoughFuelToLaunch")
	function SupplyRocket.HasEnoughFuelToLaunch(...)
		return UserSettings.RocketsIgnoreFuel or ChoGGi_OrigFuncs.SupplyRocket_HasEnoughFuelToLaunch(...)
	end

	-- override any performance changes if needed
	SaveOrigFunc("Workplace", "GetWorkshiftPerformance")
	function Workplace:GetWorkshiftPerformance(...)
		local set = UserSettings.BuildingSettings[self.template_name]
		return set and set.performance_notauto or ChoGGi_OrigFuncs.Workplace_GetWorkshiftPerformance(self, ...)
	end

	-- UI transparency cheats menu
	SaveOrigFunc("XShortcutsHost", "SetVisible")
	function XShortcutsHost:SetVisible(...)
		SetDlgTrans(self)
		return ChoGGi_OrigFuncs.XShortcutsHost_SetVisible(self, ...)
	end

	-- pretty much a copy n paste, just slight addition to change font colour (i use a darker menu, so the menu icons background blends)
	do -- XMenuEntry:SetShortcut
		local margin = box(10, 0, 0, 0)

		SaveOrigFunc("XMenuEntry", "SetShortcut")
		function XMenuEntry:SetShortcut(shortcut_text)

			if self.Icon == "CommonAssets/UI/Menu/folder.tga" then
				local label = XLabel:new({
					Dock = "right",
					VAlign = "center",
					Margins = margin,
				}, self)
				label:SetFontProps(self)
				label:SetText("...")

				-- folders don't have a shortcut so off we go
				return
			end

			local shortcut = rawget(self, "idShortcut") or shortcut_text ~= "" and XLabel:new({
				Dock = "right",
				VAlign = "center",
				Margins = margin,
			}, self)
			if shortcut then
				shortcut:SetFontProps(self)
				shortcut:SetText(shortcut_text)
			end
		end
	end -- do

	-- this one is easier than XPopupMenu, since it keeps a ref to the action (devs were kind enough to add a single line of "button.action = action")
	SaveOrigFunc("XToolBar", "RebuildActions")
	function XToolBar:RebuildActions(...)
		ChoGGi_OrigFuncs.XToolBar_RebuildActions(self, ...)
		-- we only care for the cheats menu toolbar tooltips thanks
		if self.Toolbar ~= "DevToolbar" then
			return
		end
		local buttons_c = #self
		-- if any of them are a func then change it to the text
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

	do -- XPopupMenu:RebuildActions
		local XTemplateSpawn = XTemplateSpawn

		-- yeah who gives a rats ass about mouseover hints on menu items
		SaveOrigFunc("XPopupMenu", "RebuildActions")
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
					entry.RolloverTitle = Translate(126095410863--[[Info]])
					-- if this func added the id or something then i wouldn't need to do this copy n paste :(

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

	-- larger trib/subsurfheater radius
	SaveOrigFunc("UIRangeBuilding", "SetUIRange")
	function UIRangeBuilding:SetUIRange(radius, ...)
		local bs = UserSettings.BuildingSettings[self.template_name]
		if bs and bs.uirange then
			radius = bs.uirange
		end
		return ChoGGi_OrigFuncs.UIRangeBuilding_SetUIRange(self, radius, ...)
	end

	-- block certain traits from workplaces
	SaveOrigFunc("Workplace", "AddWorker")
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
				ChoGGi_OrigFuncs.Workplace_AddWorker(self, worker, shift, ...)
			end

		else
			ChoGGi_OrigFuncs.Workplace_AddWorker(self, worker, shift, ...)
		end
	end

	do -- SetDustVisuals/AddDust
		local function ChangeDust(obj, func, dust, ...)
			if UserSettings.AlwaysCleanBuildings then
				dust = 0
				if func == "DustGridElement_AddDust" then
					obj.dust_current = 0
				end
			elseif UserSettings.AlwaysDustyBuildings then
				if not obj.ChoGGi_AlwaysDust or obj.ChoGGi_AlwaysDust < dust then
					obj.ChoGGi_AlwaysDust = dust
				end
				dust = obj.ChoGGi_AlwaysDust
			end

			return ChoGGi_OrigFuncs[func](obj, dust, ...)
		end

		-- set amount of dust applied
		SaveOrigFunc("BuildingVisualDustComponent", "SetDustVisuals")
		function BuildingVisualDustComponent:SetDustVisuals(dust, ...)
			return ChangeDust(self, "BuildingVisualDustComponent_SetDustVisuals", dust, ...)
		end
		SaveOrigFunc("DustGridElement", "AddDust")
		function DustGridElement:AddDust(dust, ...)
			return ChangeDust(self, "DustGridElement_AddDust", dust, ...)
		end
	end --do

	-- change dist we can charge from cables
	SaveOrigFunc("BaseRover", "GetCableNearby")
	function BaseRover:GetCableNearby(rad, ...)
		local new_rad = UserSettings.RCChargeDist
		if new_rad then
			rad = new_rad
		end
		return ChoGGi_OrigFuncs.BaseRover_GetCableNearby(self, rad, ...)
	end

	do -- InfopanelObj:CreateCheatActions
		local SetInfoPanelCheatHints = ChoGGi.InfoFuncs.SetInfoPanelCheatHints
		local GetActionsHost = GetActionsHost

		SaveOrigFunc("InfopanelObj", "CreateCheatActions")
		function InfopanelObj:CreateCheatActions(win, ...)
			-- fire orig func to build cheats
			if ChoGGi_OrigFuncs.InfopanelObj_CreateCheatActions(self, win, ...) then
				-- then we can add some hints to the cheats
				return SetInfoPanelCheatHints(GetActionsHost(win))
			end
		end
	end -- do

	do -- XWindow:SetModal
		-- i fucking hate modal windows
		if testing then
			SaveOrigFunc("XWindow", "SetModal")

			function XWindow:SetModal(set, ...)
				if set then
					return
				end
				return ChoGGi_OrigFuncs.XWindow_SetModal(self, set, ...)
			end
		end
	end -- do

end -- ClassesGenerate

--~ function OnMsg.ClassesPreprocess()
--~ end -- ClassesPreprocess
--~ function OnMsg.ClassesPostprocess()
--~ end -- ClassesPostprocess

function OnMsg.ClassesBuilt()

	SaveOrigFunc("SpaceElevator", "DroneUnloadResource")
	function SpaceElevator:DroneUnloadResource(...)
		local export_when = ChoGGi.ComFuncs.DotNameToObject("ChoGGi.UserSettings.BuildingSettings.SpaceElevator.export_when_this_amount")
		local amount = self.max_export_storage - self.export_request:GetActualAmount()
		if export_when and amount >= export_when then
			self.pod_thread = CreateGameTimeThread(function()
				self:ExportGoods()
				self.pod_thread = nil
			end)
		end
		return ChoGGi_OrigFuncs.SpaceElevator_DroneUnloadResource(self, ...)
	end

	SaveOrigFunc("SpaceElevator", "ToggleAllowExport")
	function SpaceElevator:ToggleAllowExport(...)
		ChoGGi_OrigFuncs.SpaceElevator_ToggleAllowExport(self, ...)
		if self.allow_export and UserSettings.SpaceElevatorToggleInstantExport then
			self.pod_thread = CreateGameTimeThread(function()
				self:ExportGoods()
				self.pod_thread = nil
			end)
		end
	end

	-- unbreakable cables/pipes
	SaveOrigFunc("SupplyGridFragment", "IsBreakable")
	function SupplyGridFragment.IsBreakable(...)
		if UserSettings.CablesAndPipesNoBreak then
			return false
		end
		return ChoGGi_OrigFuncs.SupplyGridFragment_IsBreakable(...)
	end
	SaveOrigFunc("BreakableSupplyGridElement", "CanBreak")
	function BreakableSupplyGridElement.CanBreak(...)
		if UserSettings.CablesAndPipesNoBreak then
			return false
		end
		return ChoGGi_OrigFuncs.BreakableSupplyGridElement_CanBreak(...)
	end

	-- no more pulsating pin motion
	SaveOrigFunc("XBlinkingButtonWithRMB", "SetBlinking")
	function XBlinkingButtonWithRMB:SetBlinking(...)
		if UserSettings.DisablePulsatingPinsMotion then
			self.blinking = false
		else
			return ChoGGi_OrigFuncs.XBlinkingButtonWithRMB_SetBlinking(self, ...)
		end
	end

	do -- MouseEvent/XEvent
		local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
		local function ResetFocus(func_name, self, event, ...)
			-- if the focus is currently on an ecm dialog then focus on previous xdialog
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
			return ChoGGi_OrigFuncs[func_name](self, event, ...)
		end

		-- no more stuck focus on ECM textboxes/lists
		SaveOrigFunc("XDesktop", "MouseEvent")
		function XDesktop:MouseEvent(event, ...)
			return ResetFocus("XDesktop_MouseEvent", self, event, ...)
		end

		-- make sure focus isn't on my dialogs if gamepad is in play
		SaveOrigFunc("XDesktop", "XEvent")
		function XDesktop:XEvent(event, ...)
			return ResetFocus("XDesktop_XEvent", self, event, ...)
		end
	end -- do

	-- removes earthsick effect
	SaveOrigFunc("Colonist", "ChangeComfort")
	function Colonist:ChangeComfort(...)
		ChoGGi_OrigFuncs.Colonist_ChangeComfort(self, ...)
		if UserSettings.NoMoreEarthsick and self.status_effects.StatusEffect_Earthsick then
			self:Affect("StatusEffect_Earthsick", false)
		end
	end

	-- make sure heater keeps the powerless setting
	SaveOrigFunc("SubsurfaceHeater", "UpdatElectricityConsumption")
	function SubsurfaceHeater:UpdatElectricityConsumption(...)
		ChoGGi_OrigFuncs.SubsurfaceHeater_UpdatElectricityConsumption(self, ...)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.ComFuncs.RemoveBuildingElecConsump(self)
		end
	end

	-- same for tribby
	SaveOrigFunc("TriboelectricScrubber", "OnPostChangeRange")
	function TriboelectricScrubber:OnPostChangeRange(...)
		ChoGGi_OrigFuncs.TriboelectricScrubber_OnPostChangeRange(self, ...)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.ComFuncs.RemoveBuildingElecConsump(self)
		end
	end

	-- remove idiot trait from uni grads (hah!)
	SaveOrigFunc("MartianUniversity", "OnTrainingCompleted")
	function MartianUniversity:OnTrainingCompleted(unit, ...)
		if UserSettings.UniversityGradRemoveIdiotTrait then
			unit:RemoveTrait("Idiot")
		end
		ChoGGi_OrigFuncs.MartianUniversity_OnTrainingCompleted(self, unit, ...)
	end

	-- used to skip mystery sequences
	do -- SkipMystStep
		local function SkipMystStep(self, myst_func, ...)
			local StopWait = ChoGGi.Temp.SA_WaitMarsTime_StopWait
			local p = self.meta.player

			if StopWait and p and StopWait.seed == p.seed then
				-- inform user, or if it's a dbl then skip
				if StopWait.skipmsg then
					StopWait.skipmsg = nil
				else
					MsgPopup(
						Strings[302535920000735--[[Timer delay skipped]]],
						Translate(3486--[[Mystery]])
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

			return ChoGGi_OrigFuncs[myst_func](self, ...)
		end

		SaveOrigFunc("SA_WaitTime", "StopWait")
		function SA_WaitTime:StopWait(...)
			return SkipMystStep(self, "SA_WaitTime_StopWait", ...)
		end
		SaveOrigFunc("SA_WaitMarsTime", "StopWait")
		function SA_WaitMarsTime:StopWait(...)
			return SkipMystStep(self, "SA_WaitMarsTime_StopWait", ...)
		end
	end -- do

	-- keep prod at saved values for grid producers (air/water/elec)
	SaveOrigFunc("SupplyGridElement", "SetProduction")
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
		ChoGGi_OrigFuncs.SupplyGridElement_SetProduction(self, new_production, new_throttled_production, update, ...)
	end

	-- and for regular producers (factories/extractors)
	SaveOrigFunc("SingleResourceProducer", "Produce")
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
			ChoGGi.ComFuncs.FuckingDrones(self,"single")
		end

		return ChoGGi_OrigFuncs.SingleResourceProducer_Produce(self, amount_to_produce, ...)
	end

	-- larger drone work radius
	do -- SetWorkRadius
		local function SetHexRadius(orig_func, setting, obj, orig_radius, ...)
			local new_rad = UserSettings[setting]
			if new_rad then
				return ChoGGi_OrigFuncs[orig_func](obj, new_rad, ...)
			end
			return ChoGGi_OrigFuncs[orig_func](obj, orig_radius, ...)
		end

		SaveOrigFunc("RCRover", "SetWorkRadius")
		function RCRover:SetWorkRadius(radius, ...)
			SetHexRadius("RCRover_SetWorkRadius", "RCRoverMaxRadius", self, radius, ...)
		end
		SaveOrigFunc("DroneHub", "SetWorkRadius")
		function DroneHub:SetWorkRadius(radius, ...)
			SetHexRadius("DroneHub_SetWorkRadius", "CommandCenterMaxRadius", self, radius, ...)
		end
	end -- do

	-- toggle trans on mouseover
	SaveOrigFunc("XWindow", "OnMouseEnter")
	function XWindow:OnMouseEnter(pt, child, ...)
		if UserSettings.TransparencyToggle then
			self:SetTransparency(0)
		end
		return ChoGGi_OrigFuncs.XWindow_OnMouseEnter(self, pt, child, ...)
	end
	SaveOrigFunc("XWindow", "OnMouseLeft")
	function XWindow:OnMouseLeft(pt, child, ...)
		if UserSettings.TransparencyToggle then
			SetDlgTrans(self)
		end
		return ChoGGi_OrigFuncs.XWindow_OnMouseLeft(self, pt, child, ...)
	end

	-- remove spire spot limit
	do -- ConstructionController:UpdateCursor
		local IsValid = IsValid
		local FixConstructPos = FixConstructPos
		local UnbuildableZ = buildUnbuildableZ()

		SaveOrigFunc("ConstructionController", "UpdateCursor")
		function ConstructionController:UpdateCursor(pos, force, ...)
			if self.is_template and IsValid(self.cursor_obj)
				and self.template_obj.dome_spot == "Spire"
				and UserSettings.Building_dome_spot
			then
				self.spireless_dome = false
				local hex_world_pos = HexGetNearestCenter(pos)
				local build_z = g_BuildableZ and GetBuildableZ(WorldToHex(hex_world_pos)) or UnbuildableZ
				if build_z == UnbuildableZ then
					build_z = pos:z() or terrain.GetHeight(pos)
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

				local new_pos = FixConstructPos(self.snap_to_grid and hex_world_pos or pos)

				if force or (FixConstructPos(self.cursor_obj:GetPos()) ~= new_pos and hex_world_pos:InBox2D(ConstructableArea)) then
					ShowNearbyHexGrid(hex_world_pos)
					self.cursor_obj:SetPos(new_pos)
					self:UpdateConstructionObstructors()
					self:UpdateConstructionStatuses() --should go after obstructors
					self:UpdateShortConstructionStatus()
					ObjModified(self)
				end

			else
				return ChoGGi_OrigFuncs.ConstructionController_UpdateCursor(self, pos, force, ...)
			end

		end
	end -- do

	-- add height limits to certain panels (cheats/traits/colonists) till mouseover, and convert workers to vertical list on mouseover if over 14 (visible limit)
	do -- InfopanelDlg:Open
		local table_find_value = table.find_value
		local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
		local CreateRealTimeThread = CreateRealTimeThread
		local DeleteThread = DeleteThread
		local function ToggleVis(idx, content, v, h)
			for i = 6, idx do
				local con = content[i]
				con:SetVisible(v)
				con:SetMaxHeight(h)
			end
		end
		local cls_training = {"Sanatorium", "School"}
--~ 		local infopanel_list = {
--~ 			ipBuilding = true,
--~ 			ipColonist = true,
--~ 			ipDrone = true,
--~ 			ipRover = true,
--~ 		}

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

			if setting ~= "InfopanelMainButVis" then
				section.OnMouseEnter = function()
					title:SetVisible(true)
				end
				section.OnMouseLeft = function()
					title:SetVisible()
				end
			end

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

		local function InfopanelDlgOpen(self)
			-- make sure infopanel is above hud (and pins)
			local hud = Dialogs.HUD
			if hud then
				self:SetZOrder(hud.ZOrder+1 or 1)
			end

			-- add toggle to main buttons area
			local main_buts = GetParentOfKind(self.idMainButtons, "XFrame")
			if main_buts then
				local title = self.idTitle.parent
				title.FXMouseIn = "ActionButtonHover"
				title.HandleMouse = true
				title.RolloverTemplate = "Rollover"
				title.RolloverTitle = Strings[302535920001367--[[Toggles]]]
				title.RolloverText = Strings[302535920001410--[[Toggle Visibility]]]
				title.RolloverHint = Translate(608042494285--[[<left_click> Activate]])

				local toggle = not ChoGGi.Temp.InfopanelMainButVis
				local toolbar = main_buts[2]
				toolbar.FoldWhenHidden = true
				toolbar:SetVisible(toggle)

				ToggleVisSection(title, toolbar, toggle, "InfopanelMainButVis")
			end

			local c = self.idContent
			if not c then
				c = self.idChoGGi_ScrollBox and self.idChoGGi_ScrollBox.idContent
			end
			if not c then
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

				-- initially set to hidden
				ToggleVis(idx, c, false, 0)

				local visthread
				self.OnMouseEnter = function()
					DeleteThread(visthread)
					ToggleVis(idx, c, true)
				end
				self.OnMouseLeft = function()
					visthread = CreateRealTimeThread(function()
						Sleep(1000)
						ToggleVis(idx, c, false, 0)
					end)
				end

			end
			--

			local section = table_find_value(c, "Id", "idsectionCheats_ChoGGi")
			if section then
				section.idIcon.FXMouseIn = "ActionButtonHover"
				section.idSectionTitle.MouseCursor = "UI/Cursors/Rollover.tga"
				section.RolloverText = Strings[302535920001410--[[Toggle Visibility]]]
				section.RolloverHint = Translate(608042494285--[[<left_click> Activate]])

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

			section = table_find_value(c, "Id", "idsectionResidence_ChoGGi")
			if section then
				local toggle = true
				if self.context.capacity > 100 then
					toggle = false
				end
				ToggleVisSection(section, SetToolbar(section, "XContextControl", toggle), toggle)
			end

			-- add limit to shifts sections
			local worker_count = 0
			for i = 1, #c do

				-- three shifts max
				if worker_count > 2 then
					break
				end

				local section = c[i]
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
		SaveOrigFunc("InfopanelDlg", "Open")
		function InfopanelDlg:Open(...)
			CreateRealTimeThread(function()
				WaitMsg("OnRender")
				InfopanelDlgOpen(self)
			end)

			return ChoGGi_OrigFuncs.InfopanelDlg_Open(self, ...)
		end
	end -- do

	-- make the background hide when console not visible (instead of after a second or two)
	do -- ConsoleLog:ShowBackground
		local DeleteThread = DeleteThread
		local RGBA = RGBA

		SaveOrigFunc("ConsoleLog", "ShowBackground")
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
	end -- do

	-- tweak console when it's "opened"
	SaveOrigFunc("Console", "Show")
	function Console:Show(show, ...)
		ChoGGi_OrigFuncs.Console_Show(self, show, ...)
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
		SaveOrigFunc("Console", "AddHistory")
		function Console:AddHistory(text, ...)
			if skip_cmds[text] or text:sub(1, 5) == "quit(" then
				return
			end
			return ChoGGi_OrigFuncs.Console_AddHistory(self, text, ...)
		end
	end -- do

	-- kind of an ugly way of making sure console doesn't include ` when using tilde to open console
	SaveOrigFunc("Console", "TextChanged")
	function Console:TextChanged(...)
		ChoGGi_OrigFuncs.Console_TextChanged(self, ...)
		local text = self.idEdit:GetText()
		if text:sub(-1) == "`" then
			self.idEdit:SetText(text:sub(1, -2))
			self.idEdit:SetCursor(1, #text-1)
		end
	end

	do -- Console HistoryDown/HistoryUp
		-- make it so caret is at the end of the text when you use history (who the heck wants it at the start...)
		local function HistoryEnd(func, self, ...)
			ChoGGi_OrigFuncs[func](self, ...)
			self.idEdit:SetCursor(1, #self.idEdit:GetText())
		end

		SaveOrigFunc("Console", "HistoryDown")
		function Console:HistoryDown(...)
			HistoryEnd("Console_HistoryDown", self, ...)
		end

		SaveOrigFunc("Console", "HistoryUp")
		function Console:HistoryUp(...)
			HistoryEnd("Console_HistoryUp", self, ...)
		end
	end -- do

	do -- RequiresMaintenance:AddDust
		-- it wasn't checking if it was a number so we got errors in log
		local tonumber = tonumber

		SaveOrigFunc("RequiresMaintenance", "AddDust")
		function RequiresMaintenance:AddDust(amount, ...)
			-- maybe something was sending a "number" instead of number?
			amount = tonumber(amount)
			if amount then
				return ChoGGi_OrigFuncs.RequiresMaintenance_AddDust(self, amount, ...)
			end
		end
	end -- do

	-- so we can do long spaced tunnels
	SaveOrigFunc("TunnelConstructionController", "UpdateConstructionStatuses")
	function TunnelConstructionController:UpdateConstructionStatuses(...)
		if UserSettings.RemoveBuildingLimits then
			local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
			self:FinalizeStatusGathering(old_t)
		else
			return ChoGGi_OrigFuncs.TunnelConstructionController_UpdateConstructionStatuses(self, ...)
		end
	end

	do -- Console:Exec
		-- add a bunch of rules to console input
		local console_rules = {
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
		ex_params = true,
		override_title = true,
	})
else
	OpenExamine(params, {
		ex_params = true,
		override_title = true,
		title = ChoGGi.Strings[302535920000069] .. " " .. ChoGGi.Strings[302535920001073]
			.. ": " .. ChoGGi.ComFuncs.RetName(params[1]),
	})
end]] -- title strings: Examine Console
			},
			{
				-- ~!obj_with_attachments
				"^~!(.*)",
				[[local obj = %s
local attaches = ChoGGi.ComFuncs.GetAllAttaches(obj)
if #attaches > 0 then
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

		-- override with my rules (thanks devs)
		ConsoleRules = console_rules

		-- ReadHistory fires from :Show(), if it isn't loaded before you :Exec() then goodbye history
		SaveOrigFunc("Console", "Exec")
		function Console:Exec(...)
			if not self.history_queue or #self.history_queue == 0 then
				self:ReadHistory()
			end
			return ChoGGi_OrigFuncs.Console_Exec(self, ...)
		end

		if not blacklist then
			-- and now the console has a blacklist :), though i am a little suprised they left it unfettered this long, been using it as a workaround for months
			local WaitMsg = WaitMsg
			CreateRealTimeThread(function()
				if not g_ConsoleFENV then
					WaitMsg("Autorun")
				end
				while not g_ConsoleFENV do
					Sleep(1000)
				end

				local original_G = _G
				local rawset = original_G.rawset
				local run = original_G.rawget(g_ConsoleFENV, "__run")

				g_ConsoleFENV = {__run = run}
				setmetatable(g_ConsoleFENV, {
					__index = function(_, key)
						return original_G[key]
					end,
					__newindex = function(_, key, value)
						-- bye bye annoying [LUA ERROR] Attempt to create a new global xxx (well for the console at least)
						rawset(original_G, key, value)
--~ 						original_G[key] = value
					end,
				})
			end)
		end

	end -- do

end -- ClassesBuilt
