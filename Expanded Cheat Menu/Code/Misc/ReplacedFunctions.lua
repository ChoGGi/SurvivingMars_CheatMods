-- See LICENSE for terms

-- in-game functions replaced with custom ones

--~ local orig_XTemplateSpawn = XTemplateSpawn
--~ function XTemplateSpawn(template_or_class, parent, context)
--~ 	print(template_or_class)
--~ 	return orig_XTemplateSpawn(template_or_class, parent, context)
--~ end

local type = type
local TableFindValue = table.find_value
local TableUnpack = table.unpack

local MsgPopup
local DebugGetInfo
local S
local blacklist
local ChoGGi_OrigFuncs
--~ local Trans

local SaveOrigFunc
local SetTrans

function OnMsg.ClassesGenerate()
	MsgPopup = ChoGGi.ComFuncs.MsgPopup
	S = ChoGGi.Strings
	blacklist = ChoGGi.blacklist
	DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	--~ Trans = ChoGGi.ComFuncs.Translate

	ChoGGi_OrigFuncs = ChoGGi.OrigFuncs

	-- set UI transparency
	SetTrans = function(obj)
		if not obj then
			return
		end
		local trans = ChoGGi.UserSettings.Transparency
		if obj.class and trans[obj.class] then
			obj:SetTransparency(trans[obj.class])
		end
	end

	SaveOrigFunc = function(class_or_func,func_name)
		if func_name then
			local newname = class_or_func .. "_" .. func_name
			if not ChoGGi_OrigFuncs[newname] then
				ChoGGi_OrigFuncs[newname] = _G[class_or_func][func_name]
			end
		else
			if not ChoGGi_OrigFuncs[class_or_func] then
				ChoGGi_OrigFuncs[class_or_func] = _G[class_or_func]
			end
		end
	end

	do -- do some stuff
		local Platform = Platform
		Platform.editor = true
		-- fixes UpdateInterface nil value in editor mode
		local d_before = Platform.developer
		Platform.developer = true
		editor.LoadPlaceObjConfig()
		Platform.developer = d_before
		-- needed for HashLogToTable(), SM was planning to have multiple cities (or from a past game from this engine)?
		if not rawget(_G,"g_Cities") then
			GlobalVar("g_Cities",{})
		end
		-- editor wants a table
		GlobalVar("g_revision_map",{})
		-- stops some log spam in editor (function doesn't exist in SM)
		UpdateMapRevision = empty_func
		AsyncGetSourceInfo = empty_func
	end -- do

	do -- funcs without a class
		SaveOrigFunc("GetFuncSourceString")
		SaveOrigFunc("GetMaxCargoShuttleCapacity")
		SaveOrigFunc("GetMissingMods")
		SaveOrigFunc("IsDlcAvailable")
		SaveOrigFunc("LoadCustomOnScreenNotification")
		SaveOrigFunc("OpenDialog")
		SaveOrigFunc("OutputDebugString")
		SaveOrigFunc("PersistGame")
		SaveOrigFunc("ShowConsole")
		SaveOrigFunc("ShowConsoleLog")
		SaveOrigFunc("ShowPopupNotification")
		SaveOrigFunc("TDevModeGetEnglishText")
		SaveOrigFunc("TGetID")
		SaveOrigFunc("UIGetBuildingPrerequisites")

		-- work on these persist errors
		function PersistGame(folder,...)
			-- collectgarbage is blacklisted, and I'm not sure what issue it'd cause if it doesn't fire (saving weird shit maybe)...
			if not blacklist and ChoGGi.UserSettings.DebugPersistSaves then
				collectgarbage("collect")
				Msg("SaveGame")
				rawset(_G, "__error_table__", {})
				local err = EngineSaveGame(folder .. "persist")
				local error_amt = #__error_table__

				for i = 1, error_amt do
					local errors = __error_table__[i]
					print("Persist error:", errors.error or "unknown")
					print("Persist stack:")
					for j = 1, #errors do
						print("	", tostring(errors[j]))
					end
				end

				if error_amt > 0 then
					ChoGGi.ComFuncs.OpenInExamineDlg(__error_table__)
				end
				-- be useful for restarting threads, see if devs will add it
				Msg("PostSaveGame")
				return err
			end

			-- be useful for restarting threads, see if devs will add it
			Msg("PostSaveGame")
			return ChoGGi_OrigFuncs.PersistGame(folder,...)
		end

		-- used by a func in examine for examining functions (i think), i know something gives an error without this
		GetFuncSourceString = DebugGetInfo

		function TGetID(t,...)
			local t_type = type(t)
			if t_type ~= "table" and t_type ~= "userdata" then
				return ChoGGi_OrigFuncs.TGetID(T(t,...))
			end
			return ChoGGi_OrigFuncs.TGetID(t,...)
		end

		-- I guess, don't pass a string to it?
		function TDevModeGetEnglishText(t,...)
			if type(t) == "string" then
				return t
			end
			return ChoGGi_OrigFuncs.TDevModeGetEnglishText(t,...)
		end

		-- fix for sending nil id to it
		function LoadCustomOnScreenNotification(notification,...)
			-- the first return is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
			if TableUnpack(notification) then
				return ChoGGi_OrigFuncs.LoadCustomOnScreenNotification(notification,...)
			end
		end

		function GetMaxCargoShuttleCapacity(...)
			local ChoGGi = ChoGGi
			if ChoGGi.UserSettings.StorageShuttle then
				return ChoGGi.UserSettings.StorageShuttle
			else
				return ChoGGi_OrigFuncs.GetMaxCargoShuttleCapacity(...)
			end
		end

		-- SkipMissingDLC and no mystery dlc installed means the buildmenu tries to add missing buildings, and call a func that doesn't exist
		function UIGetBuildingPrerequisites(cat_id, template, bCreateItems,...)
			if BuildingTemplates[template.id] then
				return ChoGGi_OrigFuncs.UIGetBuildingPrerequisites(cat_id, template, bCreateItems,...)
			end
		end

		-- stops confirmation dialog about missing mods (still lets you know they're missing)
		function GetMissingMods(...)
			if ChoGGi.UserSettings.SkipMissingMods then
				return "", false
			else
				return ChoGGi_OrigFuncs.GetMissingMods(...)
			end
		end

		-- lets you load saved games that have dlc
		function IsDlcAvailable(...)
			if ChoGGi.UserSettings.SkipMissingDLC then
				return true
			else
				return ChoGGi_OrigFuncs.IsDlcAvailable(...)
			end
		end

		-- always able to show console
		local CreateConsole = CreateConsole
		function ShowConsole(visible)
			local dlgConsole = dlgConsole

			if visible and not dlgConsole then
				CreateConsole()
			end
	--~ 		if visible then
	--~ 			ShowConsoleLog(true)
	--~ 		end
			if dlgConsole then
				dlgConsole:Show(visible)
			end

		end
		-- convert popups to console text
		function ShowPopupNotification(preset, params, bPersistable, parent,...)
			--actually actually disable hints
			if ChoGGi.UserSettings.DisableHints and preset == "SuggestedBuildingConcreteExtractor" then
				return
			end

	--~		 if type(ChoGGi.testing) == "function" then
	--~		 --if ChoGGi.UserSettings.ConvertPopups and type(preset) == "string" and not preset:find("LaunchIssue_") then
	--~			 if not procall(function()
	--~				 local function ColourText(Text,Bool)
	--~					 if Bool == true then
	--~						 return "<color 200 200 200>" .. Text .. "</color>"
	--~					 else
	--~						 return "<color 75 255 75>" .. Text .. "</color>"
	--~					 end
	--~				 end
	--~				 local function ReplaceParam(Name,Text,SearchName)
	--~					 SearchName = SearchName or "<" .. Name .. ">"
	--~					 if not Text:find(SearchName) then
	--~						 return Text
	--~					 end
	--~					 return Text:gsub(SearchName,ColourText(Trans(params[Name])))
	--~				 end
	--~				 --show popups in console log
	--~				 local presettext = PopupNotificationPresets[preset]
	--~				 --print(ColourText("Title: ",true),ColourText(Trans(presettext.title)))
	--~				 local context = _GetPopupNotificationContext(preset, params or empty_table, bPersistable)
	--~				 context.parent = parent
	--~				 if bPersistable then
	--~					 context.sync_popup_id = SyncPopupId
	--~				 else
	--~					 context.async_signal = {}
	--~				 end
	--~				 local text = Trans(presettext.text,context,true)


	--~				 text = ReplaceParam("number1",text)
	--~				 text = ReplaceParam("number2",text)
	--~				 text = ReplaceParam("effect",text)
	--~				 text = ReplaceParam("reason",text)
	--~				 text = ReplaceParam("hint",text)
	--~				 text = ReplaceParam("objective",text)
	--~				 text = ReplaceParam("target",text)
	--~				 text = ReplaceParam("timeout",text)
	--~				 text = ReplaceParam("count",text)
	--~				 text = ReplaceParam("sponsor_name",text)
	--~				 text = ReplaceParam("commander_name",text)

	--~				 --text = text:gsub("<ColonistName(colonist)>",ColourText("<ColonistName(",Trans(params.colonist)) ,")>")

	--~				 --print(ColourText("Text: ",true),text)
	--~				 --print(ColourText("Voiced Text: ",true),Trans(presettext.voiced_text))
	--~			 end) then
	--~				 print("<color 255 0 0>Encountered an error trying to convert popup to console msg; showing popup instead (please let me know which popup it is).</color>")
	--~				 return ChoGGi_OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
	--~			 end
	--~		 else
	--~			 return ChoGGi_OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
	--~		 end
			return ChoGGi_OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent,...)
		end

		-- UI transparency dialogs (buildmenu, pins, infopanel)
		function OpenDialog(...)
			local ret = {ChoGGi_OrigFuncs.OpenDialog(...)}
			SetTrans(ret)
			return TableUnpack(ret)
		end

		--console stuff
		function ShowConsoleLog(...)
			ChoGGi_OrigFuncs.ShowConsoleLog(...)
			SetTrans(dlgConsoleLog)
		end
	end -- do

	-- Custom Msgs
	local AddMsgToFunc = ChoGGi.ComFuncs.AddMsgToFunc
	AddMsgToFunc("BaseBuilding","GameInit","ChoGGi_SpawnedBaseBuilding")
	AddMsgToFunc("Drone","GameInit","ChoGGi_SpawnedDrone")
	AddMsgToFunc("PinnableObject","TogglePin","ChoGGi_TogglePinnableObject")

	AddMsgToFunc("AirProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducer","air_production")
	AddMsgToFunc("ElectricityProducer","CreateElectricityElement","ChoGGi_SpawnedProducer","electricity_production")
	AddMsgToFunc("WaterProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducer","water_production")
	AddMsgToFunc("SingleResourceProducer","Init","ChoGGi_SpawnedProducer","production_per_day")

	SaveOrigFunc("BaseRover","GetCableNearby")
	SaveOrigFunc("Building","ApplyUpgrade")
	SaveOrigFunc("BuildingVisualDustComponent","SetDustVisuals")
	SaveOrigFunc("ConstructionController","IsObstructed")
	SaveOrigFunc("CursorBuilding","GameInit")
	SaveOrigFunc("DontBuildHere","Check")
	SaveOrigFunc("DustGridElement","AddDust")
	SaveOrigFunc("GridObject","GetPipeConnections")
	SaveOrigFunc("InfopanelDlg","RecalculateMargins")
	SaveOrigFunc("SupplyRocket","FlyToEarth")
	SaveOrigFunc("SupplyRocket","FlyToMars")
	SaveOrigFunc("SupplyRocket","HasEnoughFuelToLaunch")
	SaveOrigFunc("UIRangeBuilding","SetUIRange")
	SaveOrigFunc("Workplace","AddWorker")
	SaveOrigFunc("Workplace","GetWorkshiftPerformance")
	SaveOrigFunc("XMenuEntry","SetShortcut")
	SaveOrigFunc("XPopupMenu","RebuildActions")
	SaveOrigFunc("XToolBar","RebuildActions")
	SaveOrigFunc("XShortcutsHost","SetVisible")
	SaveOrigFunc("XSizeConstrainedWindow","UpdateMeasure")

	-- that's what we call a small font
	if ChoGGi.UserSettings.StopSelectionPanelResize then
		XSizeConstrainedWindow.UpdateMeasure = XWindow.UpdateMeasure

		local GetSafeMargins = GetSafeMargins
		local GetDialog = GetDialog
		local GetInGameInterface = GetInGameInterface
		local box = box
		-- I don't see the reason it needs to be 58 (the margin at the top)
		function InfopanelDlg:RecalculateMargins()
			local margins = GetSafeMargins()
			local bottom_margin = 0
			local pins = GetDialog("PinsDlg")
			if pins then
				local igi = GetInGameInterface()
				bottom_margin = igi.box:maxy() - pins.box:miny() - margins:maxy()
			end
--~ 			margins = box(margins:minx(), margins:miny() + 58, margins:maxx(), margins:maxy() + bottom_margin)
			margins = box(margins:minx(), margins:miny() + 32, margins:maxx(), margins:maxy() + bottom_margin)
			self:SetMargins(margins)
		end
	end

	-- allows you to build on geysers
	function ConstructionController:IsObstructed(...)
		if ChoGGi.UserSettings.BuildOnGeysers then
			local o = self.construction_obstructors
			-- we need to make sure it's the only obstructor
			if o and #o == 1 and o[1] == g_DontBuildHere then
				return false
			end
		end
		return ChoGGi_OrigFuncs.ConstructionController_IsObstructed(self,...)
	end

	-- allows you to build on geysers
	function DontBuildHere:Check(...)
		if ChoGGi.UserSettings.BuildOnGeysers then
			return false
		end
		return ChoGGi_OrigFuncs.DontBuildHere_Check(self,...)
	end

	-- allows you to build outside buildings inside and vice
	function CursorBuilding:GameInit(...)
		if self.template_obj then
			if ChoGGi.UserSettings.RemoveBuildingLimits then
				self.template_obj.dome_required = false
				self.template_obj.dome_forbidden = false
			elseif self.template_obj then
				self.template_obj.dome_required = cc.template_obj:GetDefaultPropertyValue("dome_required")
				self.template_obj.dome_forbidden = cc.template_obj:GetDefaultPropertyValue("dome_forbidden")
			end
		end
		return ChoGGi_OrigFuncs.CursorBuilding_GameInit(self,...)
	end

	-- stupid supply pods don't want to play nice
	function SupplyRocket:FlyToEarth(flight_time, launch_time,...)
		if ChoGGi.UserSettings.TravelTimeMarsEarth then
			return ChoGGi_OrigFuncs.SupplyRocket_FlyToEarth(self,g_Consts.TravelTimeMarsEarth, launch_time,...)
		end
		return ChoGGi_OrigFuncs.SupplyRocket_FlyToEarth(self,flight_time, launch_time,...)
	end

	function SupplyRocket:FlyToMars(cargo, cost, flight_time, initial, launch_time,...)
		if ChoGGi.UserSettings.TravelTimeEarthMars then
			return ChoGGi_OrigFuncs.SupplyRocket_FlyToMars(self,cargo, cost, g_Consts.TravelTimeEarthMars, initial, launch_time,...)
		end
		return ChoGGi_OrigFuncs.SupplyRocket_FlyToMars(self,cargo, cost, flight_time, initial, launch_time,...)
	end

	-- no need for fuel to launch rocket
	function SupplyRocket:HasEnoughFuelToLaunch(...)
		if ChoGGi.UserSettings.RocketsIgnoreFuel then
			return true
		else
			return ChoGGi_OrigFuncs.SupplyRocket_HasEnoughFuelToLaunch(self,...)
		end
	end

	-- override any performance changes if needed
	function Workplace:GetWorkshiftPerformance(...)
		local set = ChoGGi.UserSettings.BuildingSettings[self.template_name]
		if set and set.performance_notauto then
			return set.performance_notauto
		end
		return ChoGGi_OrigFuncs.Workplace_GetWorkshiftPerformance(self,...)
	end

	-- UI transparency cheats menu
	function XShortcutsHost:SetVisible(...)
		SetTrans(self)
		return ChoGGi_OrigFuncs.XShortcutsHost_SetVisible(self,...)
	end

	-- pretty much a copy n paste, just slight addition to change font colour (i use a darker menu, so the menu icons background blends)
	do -- XMenuEntry:SetShortcut
		local margin = box(10, 0, 0, 0)
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
	function XToolBar:RebuildActions(...)
		ChoGGi_OrigFuncs.XToolBar_RebuildActions(self,...)
		-- we only care for the cheats menu toolbar tooltips thanks
		if self.Toolbar ~= "DevToolbar" then
			return
		end
		-- if any of them are a func then change it to the text
		for i = 1, #self do
			local button = self[i]
			if type(button:GetRolloverText()) == "function" then
				function button.GetRolloverText()
					return button.action.RolloverText()
				end
			end
		end

	end

	do -- XPopupMenu:RebuildActions
		local XTemplateSpawn = XTemplateSpawn
		local type = type
		-- yeah who gives a rats ass about mouseover hints on menu items
		-- i probably should also do this for the toolbar items as well, since those are also missing the tooltips
		function XPopupMenu:RebuildActions(host,...)
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
					entry.RolloverTitle = S[126095410863--[[Info--]]]
					-- if this func added the id or something then i wouldn't need to do this copy n paste :(

					function entry.OnPress(this, _)
						if action.OnActionEffect ~= "popup" then
							self:ClosePopupMenus()
						end
						host:OnAction(action, this)
						if action.ActionToggle and self.window_state ~= "destroying" then
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

	do -- Large Water Tank + Pipes + Chrome skin = borked looking pipes
		local spots = {"Tube", "Tubeleft", "Tuberight", "Tubestraight"}
		local spot_attach = {"Tube", "TubeLeft", "TubeRight", "TubeStraight"}
		local decor_spot = "Tubedecor"
		local IsValidEntity = IsValidEntity
		local point = point
		local WorldToHex = WorldToHex
		local IsKindOf = IsKindOf
		function GridObject:GetPipeConnections(...)
			if ChoGGi.Temp.FixingPipes then
				if not IsKindOf(self, "LifeSupportGridObject") then
					return
				end

				local gsn = self:GetGridSkinName()
				local entity = self:GetEntity()
				local cache_key = self:GetEntityNameForPipeConnections(gsn)
				local list = PipeConnectionsCache[cache_key]
				if not list then
					local skin = TubeSkinsBuildingConnections[gsn]

					list = {}
					PipeConnectionsCache[cache_key] = list

					--figure out if there is a "decor" spot.
					local decor_spot_info_t = HasSpot(entity, "idle", decor_spot) and {entity, false} or false
					if not decor_spot_info_t and self.configurable_attaches then
						for i = #self.configurable_attaches, 1, -1 do
							local attach = self.configurable_attaches[i]
							local attach_entity, attach_spot = _G[attach[1]]:GetEntity(), attach[2]
							if HasSpot(attach_entity, "idle", decor_spot) then
								decor_spot_info_t = {attach_entity, attach_spot}
								break
							end
						end
					end

					for s, spot in ipairs(spots) do
						local first, last = GetSpotRange(entity, "idle", spot)
						local pipe_entity, pt_end, angle_end
						for i = first, last do
							pipe_entity = pipe_entity or (cache_key .. spot_attach[s])
							if not IsValidEntity(pipe_entity) then
								--default connection tube.
								pipe_entity = skin.default_tube
							end
							pt_end = pt_end or GetEntitySpotPos(pipe_entity, GetSpotBeginIndex(pipe_entity, "idle", "End"))
							angle_end = angle_end or CalcOrientation(pt_end)
							if pt_end:x() ~= 0 or pt_end:y() ~= 0 then
								local spot_pos_pt = GetEntitySpotPos(entity, i)
								local dir = HexAngleToDirection(angle_end + GetEntitySpotAngle(entity, i))
								local pt = point(WorldToHex(spot_pos_pt + Rotate(point(guim, 0), angle_end + GetEntitySpotAngle(entity, i))))
								-- this will allow us to ignore the error and change the skin
	--~								 for _, entry in ipairs(list) do
	--~									 if entry[1] == pt and entry[2] == dir then
	--~										 printf("Duplicate pipe connection: entity %s, spot %s, pipe entity %s", entity, spot, pipe_entity)
	--~										 pt = nil
	--~									 end
	--~								 end
								if pt then
									local decor_t = nil
									if decor_spot_info_t then
										decor_t = {skin.decor_entity}
										if not decor_spot_info_t[2] then
											--decor spot on main entity
											decor_t[2] = {GetEntityNearestSpotIdx(entity, decor_spot, spot_pos_pt), entity}
										else
											--decor spot on auto attach
											decor_t[2] = {GetEntityNearestSpotIdx(entity, decor_spot_info_t[2], spot_pos_pt), entity}
											decor_t[3] = {GetEntityNearestSpotIdx(decor_spot_info_t[1], decor_spot, Rotate(spot_pos_pt - GetEntitySpotPos(entity, decor_t[2][1]), -GetEntitySpotAngle(entity, decor_t[2][1])) ), decor_spot_info_t[1]}
										end
									end

									list[#list + 1] = { pt, dir, i, pipe_entity, decor_t }
								end
							else
								printf("Pipe entity %s does not have a valid 'End' spot", pipe_entity)
							end
						end
					end
				end
				return list
			else
				return ChoGGi_OrigFuncs.GridObject_GetPipeConnections(self,...)
			end
		end
	end

	-- larger trib/subsurfheater radius
	function UIRangeBuilding:SetUIRange(radius,...)
		local bs = ChoGGi.UserSettings.BuildingSettings[self.template_name]
		if bs and bs.uirange then
			radius = bs.uirange
		end
		return ChoGGi_OrigFuncs.UIRangeBuilding_SetUIRange(self, radius,...)
	end

	-- block certain traits from workplaces
	function Workplace:AddWorker(worker, shift,...)
		local ChoGGi = ChoGGi
		local bs = ChoGGi.UserSettings.BuildingSettings[self.template_name]
		-- check that the tables contain at least one trait
		local bt
		local rt
		if bs then
			bt = type(bs.blocktraits) == "table" and next(bs.blocktraits) and bs.blocktraits
			rt = type(bs.restricttraits) == "table" and next(bs.restricttraits) and bs.restricttraits
		end

		if bt or rt then
			local block,restrict = ChoGGi.ComFuncs.RetBuildingPermissions(worker.traits,bs)

			if block then
				return
			end
			if restrict then
				ChoGGi_OrigFuncs.Workplace_AddWorker(self, worker, shift,...)
			end

		else
			ChoGGi_OrigFuncs.Workplace_AddWorker(self, worker, shift,...)
		end
	end

	do -- SetDustVisuals/AddDust
		local function ChangeDust(obj,func,dust,...)
			local UserSettings = ChoGGi.UserSettings

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

			return ChoGGi_OrigFuncs[func](obj,dust, ...)
		end

		-- set amount of dust applied
		function BuildingVisualDustComponent:SetDustVisuals(dust,...)
			return ChangeDust(self,"BuildingVisualDustComponent_SetDustVisuals",dust,...)
		end
		function DustGridElement:AddDust(dust,...)
			return ChangeDust(self,"DustGridElement_AddDust",dust,...)
		end
	end --do

	-- change dist we can charge from cables
	function BaseRover:GetCableNearby(rad,...)
		local new_rad = ChoGGi.UserSettings.RCChargeDist
		if new_rad then
			rad = new_rad
		end
		return ChoGGi_OrigFuncs.BaseRover_GetCableNearby(self, rad,...)
	end

	-- i fucking hate modal windows
	if ChoGGi.testing then
		SaveOrigFunc("XWindow","SetModal")

		function XWindow:SetModal(set,...)
			if set == false then
				return ChoGGi_OrigFuncs.XWindow_SetModal(self,set,...)
			end
		end
	end

end --onmsg library

-- ClassesPreprocess
function OnMsg.ClassesPreprocess()
	local ChoGGi = ChoGGi
	SaveOrigFunc("InfopanelObj","CreateCheatActions")

	local GetActionsHost = GetActionsHost
	function InfopanelObj:CreateCheatActions(win,...)
		-- fire orig func to build cheats
		if ChoGGi_OrigFuncs.InfopanelObj_CreateCheatActions(self,win,...) then
			-- then we can add some hints to the cheats
			return ChoGGi.InfoFuncs.SetInfoPanelCheatHints(GetActionsHost(win))
		end
	end

end -- ClassesPreprocess

-- ClassesPostprocess
--~ function OnMsg.ClassesPostprocess()
--~ end -- ClassesPostprocess

-- ClassesBuilt
function OnMsg.ClassesBuilt()
	local UserSettings = ChoGGi.UserSettings

	SaveOrigFunc("Colonist","ChangeComfort")
	SaveOrigFunc("Console","AddHistory")
	SaveOrigFunc("Console","Exec")
	SaveOrigFunc("Console","HistoryDown")
	SaveOrigFunc("Console","HistoryUp")
	SaveOrigFunc("Console","Show")
	SaveOrigFunc("Console","TextChanged")
	SaveOrigFunc("ConsoleLog","SetVisible")
	SaveOrigFunc("ConsoleLog","ShowBackground")
	SaveOrigFunc("ConstructionController","CreateCursorObj")
	SaveOrigFunc("ConstructionController","UpdateConstructionStatuses")
	SaveOrigFunc("ConstructionController","UpdateCursor")
	SaveOrigFunc("DroneHub","SetWorkRadius")
	SaveOrigFunc("InfopanelDlg","Open")
	SaveOrigFunc("MartianUniversity","OnTrainingCompleted")
	SaveOrigFunc("RCRover","SetWorkRadius")
	SaveOrigFunc("RequiresMaintenance","AddDust")
	SaveOrigFunc("SA_WaitMarsTime","StopWait")
	SaveOrigFunc("SA_WaitTime","StopWait")
	SaveOrigFunc("SingleResourceProducer","Produce")
	SaveOrigFunc("SpaceElevator","DroneUnloadResource")
	SaveOrigFunc("SpaceElevator","ToggleAllowExport")
	SaveOrigFunc("SubsurfaceHeater","UpdatElectricityConsumption")
	SaveOrigFunc("SupplyGridElement","SetProduction")
	SaveOrigFunc("SupplyGridFragment","RandomElementBreakageOnWorkshiftChange")
	SaveOrigFunc("terminal","SysEvent")
	SaveOrigFunc("TriboelectricScrubber","OnPostChangeRange")
	SaveOrigFunc("TunnelConstructionController","UpdateConstructionStatuses")
	SaveOrigFunc("XBlinkingButtonWithRMB","SetBlinking")
	SaveOrigFunc("XDesktop","MouseEvent")
	SaveOrigFunc("XWindow","OnMouseEnter")
	SaveOrigFunc("XWindow","OnMouseLeft")
	SaveOrigFunc("XWindow","SetId")

	function SpaceElevator:DroneUnloadResource(...)
		local export_when = ChoGGi.ComFuncs.DotNameToObject("ChoGGi.UserSettings.BuildingSettings.SpaceElevator.export_when_this_amount")
		local amount = self.max_export_storage - self.export_request:GetActualAmount()
		if export_when and amount >= export_when then
			self.pod_thread = CreateGameTimeThread(function()
				self:ExportGoods()
				self.pod_thread = nil
			end)
		end
		return ChoGGi_OrigFuncs.SpaceElevator_DroneUnloadResource(self,...)
	end

	function SpaceElevator:ToggleAllowExport(...)
		ChoGGi_OrigFuncs.SpaceElevator_ToggleAllowExport(self,...)
		if self.allow_export and ChoGGi.UserSettings.SpaceElevatorToggleInstantExport then
			self.pod_thread = CreateGameTimeThread(function()
				self:ExportGoods()
				self.pod_thread = nil
			end)
		end
	end

	-- unbreakable cables/pipes
	function SupplyGridFragment:RandomElementBreakageOnWorkshiftChange(...)
		if not ChoGGi.UserSettings.BreakChanceCablePipe then
			return ChoGGi_OrigFuncs.SupplyGridFragment_RandomElementBreakageOnWorkshiftChange(self,...)
		end
	end

	-- stops the help webpage from showing up every single time
	if Platform.editor and UserSettings.SkipModHelpPage then
		GedOpHelpMod = empty_func
	end

	-- no more pulsating pin motion
	function XBlinkingButtonWithRMB:SetBlinking(...)
		if ChoGGi.UserSettings.DisablePulsatingPinsMotion then
			self.blinking = false
		else
			return ChoGGi_OrigFuncs.XBlinkingButtonWithRMB_SetBlinking(self,...)
		end
	end

	-- no more stuck focus on textboxes and so on
	function XDesktop:MouseEvent(event, pt, button, time,...)
		if event == "OnMouseButtonDown" and self.keyboard_focus and self.keyboard_focus:IsKindOfClasses("XTextEditor","XList") then
			local hud = Dialogs.HUD
			if hud then
				hud:SetFocus()
			else
				-- hud should always be around, but just in case focus on desktop
				self:SetFocus()
			end
		end

		return ChoGGi_OrigFuncs.XDesktop_MouseEvent(self, event, pt, button, time,...)
	end

	-- remove annoying msg that happens everytime you click anything (nice)
	function XWindow:SetId(id)
		local node = self.parent
		while node and not node.IdNode do
			node = node.parent
		end
		if node then
			local old_id = self.Id
			if old_id ~= "" then
				rawset(node, old_id, nil)
			end
			if id ~= "" then
				--local win = rawget(node, id)
				--if win and win ~= self then
				--	printf("[UI WARNING] Assigning window id '%s' of %s to %s", tostring(id), win.class, self.class)
				--end
				rawset(node, id, self)
			end
		end
		self.Id = id
	end

	-- removes earthsick effect
	function Colonist:ChangeComfort(...)
		ChoGGi_OrigFuncs.Colonist_ChangeComfort(self, ...)
		if ChoGGi.UserSettings.NoMoreEarthsick and self.status_effects.StatusEffect_Earthsick then
			self:Affect("StatusEffect_Earthsick", false)
		end
	end

	-- make sure heater keeps the powerless setting
	function SubsurfaceHeater:UpdatElectricityConsumption(...)
		ChoGGi_OrigFuncs.SubsurfaceHeater_UpdatElectricityConsumption(self,...)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.ComFuncs.RemoveBuildingElecConsump(self)
		end
	end

	-- same for tribby
	function TriboelectricScrubber:OnPostChangeRange(...)
		ChoGGi_OrigFuncs.TriboelectricScrubber_OnPostChangeRange(self,...)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.ComFuncs.RemoveBuildingElecConsump(self)
		end
	end

	-- remove idiot trait from uni grads (hah!)
	function MartianUniversity:OnTrainingCompleted(unit,...)
		if ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait then
			unit:RemoveTrait("Idiot")
		end
		ChoGGi_OrigFuncs.MartianUniversity_OnTrainingCompleted(self, unit,...)
	end

	-- used to skip mystery sequences
	do -- SkipMystStep
		local function SkipMystStep(self,myst_func,...)
			local ChoGGi = ChoGGi
			local StopWait = ChoGGi.Temp.SA_WaitMarsTime_StopWait
			local p = self.meta.player

			if StopWait and p and StopWait.seed == p.seed then
				-- inform user, or if it's a dbl then skip
				if StopWait.skipmsg then
					StopWait.skipmsg = nil
				else
					MsgPopup(
						302535920000735--[[Timer delay skipped--]],
						3486--[[Mystery--]]
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

			return ChoGGi_OrigFuncs[myst_func](self,...)
		end

		function SA_WaitTime:StopWait(...)
			return SkipMystStep(self,"SA_WaitTime_StopWait",...)
		end
		function SA_WaitMarsTime:StopWait(...)
			return SkipMystStep(self,"SA_WaitMarsTime_StopWait",...)
		end
	end -- do

	-- keep prod at saved values for grid producers (air/water/elec)
	function SupplyGridElement:SetProduction(new_production, new_throttled_production, update, ...)
		local amount = ChoGGi.UserSettings.BuildingSettings[self.building.template_name]
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

--~ -- see if this gets called less then produce
--~ function SingleResourceProducer:DroneUnloadResource(drone, request, resource, amount)
--~ end
	--and for regular producers (factories/extractors)
	function SingleResourceProducer:Produce(amount_to_produce,...)
		local amount = ChoGGi.UserSettings.BuildingSettings[self.parent.template_name]
		if amount and amount.production then
			-- set prod
			amount_to_produce = amount.production / guim
			-- set displayed prod
			self.production_per_day = amount.production
		end

		-- get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
		if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
			ChoGGi.ComFuncs.FuckingDrones(self)
		end

		return ChoGGi_OrigFuncs.SingleResourceProducer_Produce(self, amount_to_produce,...)
	end

	-- larger drone work radius
	do -- SetWorkRadius
		local function SetHexRadius(orig_func,setting,obj,orig_radius,...)
			local new_rad = ChoGGi.UserSettings[setting]
			if new_rad then
				return ChoGGi_OrigFuncs[orig_func](obj,new_rad,...)
			end
			return ChoGGi_OrigFuncs[orig_func](obj,orig_radius,...)
		end
		function RCRover:SetWorkRadius(radius,...)
			SetHexRadius("RCRover_SetWorkRadius","RCRoverMaxRadius",self,radius,...)
		end
		function DroneHub:SetWorkRadius(radius,...)
			SetHexRadius("DroneHub_SetWorkRadius","CommandCenterMaxRadius",self,radius,...)
		end
	end -- do

	-- toggle trans on mouseover
	function XWindow:OnMouseEnter(pt, child,...)
		if ChoGGi.UserSettings.TransparencyToggle then
			self:SetTransparency(0)
		end
		return ChoGGi_OrigFuncs.XWindow_OnMouseEnter(self, pt, child,...)
	end
	function XWindow:OnMouseLeft(pt, child,...)
		if ChoGGi.UserSettings.TransparencyToggle then
			SetTrans(self)
		end
		return ChoGGi_OrigFuncs.XWindow_OnMouseLeft(self, pt, child,...)
	end

	-- remove spire spot limit
	do -- ConstructionController:UpdateCursor
		local IsValid = IsValid
		local UnbuildableZ = buildUnbuildableZ()
		local HexGetNearestCenter = HexGetNearestCenter
		local GetBuildableZ = GetBuildableZ
		local WorldToHex = WorldToHex
		local GetHeight = terrain.GetHeight
		local FixConstructPos = FixConstructPos
		local ShowNearbyHexGrid = ShowNearbyHexGrid
		local ObjModified = ObjModified

		function ConstructionController:UpdateCursor(pos, force,...)
			if ChoGGi.UserSettings.Building_dome_spot then
				if IsValid(self.cursor_obj) then
					self.spireless_dome = false
					local hex_world_pos = HexGetNearestCenter(pos)
					local build_z = g_BuildableZ and GetBuildableZ(WorldToHex(hex_world_pos)) or UnbuildableZ
					if build_z == UnbuildableZ then
						build_z = pos:z() or GetHeight(pos)
					end
					hex_world_pos = hex_world_pos:SetZ(build_z)

					local new_pos = self.snap_to_grid and hex_world_pos or pos
					new_pos = FixConstructPos(new_pos)

					if force or (self.cursor_obj:GetPos() ~= new_pos and hex_world_pos:InBox2D(ConstructableArea)) then
						ShowNearbyHexGrid(hex_world_pos)
						self.cursor_obj:SetPos(new_pos)
						self:UpdateConstructionObstructors()
						self:UpdateConstructionStatuses() --should go after obstructors
						self:UpdateShortConstructionStatus()
						ObjModified(self)
					end
				end
			else
				return ChoGGi_OrigFuncs.ConstructionController_UpdateCursor(self, pos, force,...)
			end

		end
	end -- do

	-- add height limits to certain panels (cheats/traits/colonists) till mouseover, and convert workers to vertical list on mouseover if over 14 (visible limit)
	do -- InfopanelDlg:Open
		local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
		local CreateRealTimeThread = CreateRealTimeThread
		local DeleteThread = DeleteThread
		local Sleep = Sleep
		local function ToggleVis(idx,content,v,h)
			for i = 6, idx do
				local con = content[i]
				con:SetVisible(v)
				con:SetMaxHeight(h)
			end
		end
--~ 		local infopanel_list = {
--~ 			ipBuilding = true,
--~ 			ipColonist = true,
--~ 			ipDrone = true,
--~ 			ipRover = true,
--~ 		}

		local function SetToolbar(section,cls,toggle)
			local toolbar = table.find(section.idContent,"class",cls)
			if toolbar then
				toolbar = section.idContent[toolbar]
				toolbar.FoldWhenHidden = true
				toolbar:SetVisible(toggle)
				return toolbar
			end
		end

		local function ToggleVisSection(section,toolbar,toggle,setting)
			if setting ~= "InfopanelMainButVis" then
				section.OnMouseEnter = function()
					section.idHighlight:SetVisible(true)
				end
				section.OnMouseLeft = function()
					section.idHighlight:SetVisible()
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
					UserSettings[setting] = toggle
				end
			end
		end

		local function InfopanelDlgOpen(self)
			local UserSettings = ChoGGi.UserSettings

			-- add toggle to main buttons area
			local main_buts = GetParentOfKind(self.idMainButtons,"XFrame")
			if main_buts then
				local title = self.idTitle.parent
				title.FXMouseIn = "ActionButtonHover"
				title.HandleMouse = true
				title.RolloverTemplate = "Rollover"
				title.RolloverTitle = S[302535920001367--[[Toggles--]]]
				title.RolloverText = S[302535920001410--[[Toggle Visibility--]]]
				title.RolloverHint = S[302535920000083--[[<left_click> Activate--]]]

				local toggle = false
				if UserSettings.InfopanelMainButVis then
					toggle = true
				end
				local toolbar = main_buts[2]
				toolbar.FoldWhenHidden = true
				toolbar:SetVisible(toggle)

				ToggleVisSection(title,toolbar,toggle,"InfopanelMainButVis")
			end

			local c = self.idContent
			if not c then
				c = self.idChoGGi_ScrollBox and self.idChoGGi_ScrollBox.idContent
			end
			if not c then
				return
			end

			-- this limits height of traits you can choose to 3 till mouse over
			if UserSettings.SanatoriumSchoolShowAll and self.context:IsKindOfClasses("Sanatorium","School") then

				local idx
				if self.context:IsKindOf("School") then
					idx = 20
				else
					-- Sanitarium
					idx = 18
				end

				-- initially set to hidden
				ToggleVis(idx,c,false,0)

				local visthread
				self.OnMouseEnter = function()
					DeleteThread(visthread)
					ToggleVis(idx,c,true)
				end
				self.OnMouseLeft = function()
					visthread = CreateRealTimeThread(function()
						Sleep(1000)
						ToggleVis(idx,c,false,0)
					end)
				end

			end
			--

			local section = TableFindValue(c,"Id","idSectionCheats_ChoGGi")
			if section then
				section.idIcon.FXMouseIn = "ActionButtonHover"
				section.HandleMouse = true
				section.MouseCursor = "UI/Cursors/Rollover.tga"
				section.RolloverText = S[302535920001410--[[Toggle Visibility--]]]
				section.RolloverHint = S[302535920000083--[[<left_click> Activate--]]]
				local toggle = false
				if UserSettings.InfopanelCheatsVis then
					toggle = true
				end
				local toolbar = SetToolbar(section,"XToolBar",toggle)

				ToggleVisSection(section,toolbar,toggle,"InfopanelCheatsVis")
				-- sets the scale of the cheats icons
				for j = 1, #toolbar do
					local icon = toolbar[j].idIcon
					icon:SetMaxHeight(27)
					icon:SetMaxWidth(27)
					icon:SetImageFit("largest")
				end
			end

			section = TableFindValue(c,"Id","idSectionResidence_ChoGGi")
			if section then
				local toggle = true
				if self.context.capacity > 100 then
					toggle = false
				end
				ToggleVisSection(section,SetToolbar(section,"XContextControl",toggle),toggle)
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
		function InfopanelDlg:Open(...)
			CreateRealTimeThread(function()
--~ 				repeat
--~ 					Sleep(10)
--~ 				until self.visible
				WaitMsg("OnRender")
				InfopanelDlgOpen(self)
			end)

			return ChoGGi_OrigFuncs.InfopanelDlg_Open(self,...)
		end
	end -- do

	-- make the background hide when console not visible (instead of after a second or two)
	do -- ConsoleLog:ShowBackground
		local DeleteThread = DeleteThread
		local RGBA = RGBA
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
	function Console:Show(show,...)
		ChoGGi_OrigFuncs.Console_Show(self, show,...)
		if show then
			-- adding transparency for console stuff
			SetTrans(self)
			-- and rebuild my console buttons
			ChoGGi.ConsoleFuncs.RebuildConsoleToolbar(self)
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
		function Console:AddHistory(text,...)
			if skip_cmds[text] or text:sub(1,5) == "quit(" then
				return
			end
			return ChoGGi_OrigFuncs.Console_AddHistory(self,text,...)
		end
	end -- do

	-- kind of an ugly way of making sure console doesn't include ` when using tilde to open console
	function Console:TextChanged(...)
		ChoGGi_OrigFuncs.Console_TextChanged(self,...)
		if self.idEdit:GetText() == "`" then
			self.idEdit:SetText("")
		end
	end

	-- make it so caret is at the end of the text when you use history (who the heck wants it at the start...)
	function Console:HistoryDown(...)
		ChoGGi_OrigFuncs.Console_HistoryDown(self,...)
		self.idEdit:SetCursor(1,#self.idEdit:GetText())
	end

	function Console:HistoryUp(...)
		ChoGGi_OrigFuncs.Console_HistoryUp(self,...)
		self.idEdit:SetCursor(1,#self.idEdit:GetText())
	end

	do -- RequiresMaintenance:AddDust
		local IsBox = IsBox
		local IsPoint = IsPoint
		local MulDivRound = MulDivRound
		-- was giving a nil error in log, I assume devs'll fix it one day
		function RequiresMaintenance:AddDust(amount,...)
			-- this wasn't checking if it was a number/point/box so errors in log, now it checks
			if type(amount) == "number" or IsPoint(amount) or IsBox(amount) then
				if self:IsKindOf("Building") then
					amount = MulDivRound(amount, g_Consts.BuildingDustModifier, 100)
				end
				if self.accumulate_dust then
					self:AccumulateMaintenancePoints(amount)
				end
			end
		end
	end -- do

	do -- ConstructionController:CreateCursorObj
		local IsValid = IsValid
		-- set orientation to same as last object
		function ConstructionController:CreateCursorObj(...)
			local ChoGGi = ChoGGi
			local ret = {ChoGGi_OrigFuncs.ConstructionController_CreateCursorObj(self, ...)}

			local last = ChoGGi.Temp.LastPlacedObject
			if self.template_obj and self.template_obj.can_rotate_during_placement and ChoGGi.UserSettings.UseLastOrientation and IsValid(last) then
				if ret[1].SetAngle then
					ret[1]:SetAngle(last:GetAngle() or 0)
				end
			end

			return TableUnpack(ret)
		end
	end -- do

	-- so we can build without (as many) limits
	function ConstructionController:UpdateConstructionStatuses(dont_finalize,...)
		if ChoGGi.UserSettings.RemoveBuildingLimits then
			-- send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
			ChoGGi_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,"dont_finalize",...)


			if self.is_template then
				local cobj = rawget(self.cursor_obj, true)
				local tobj = setmetatable({
					[true] = cobj,
					city = UICity
				}, {
					__index = self.template_obj
				})
				tobj:GatherConstructionStatuses(self.construction_statuses)
			end

			local statuses = self.construction_statuses

			-- we copy it so the statuses table remains the same
			local statuses_copy = table.copy(statuses)
			table.clear(statuses)
			local c = 0

			local UnevenTerrain = ConstructionStatus.UnevenTerrain
			local BlockingObjects = ConstructionStatus.BlockingObjects
			local warning = "Placeable"

			for i = 1, #statuses_copy do
				local status = statuses_copy[i]
				-- UnevenTerrain: causes issues when placing buildings (martian ground viagra)
				if status == UnevenTerrain then
					c = c + 1
					statuses[c] = status
					warning = "Blocked"
				elseif status == BlockingObjects then
					warning = "Obstructing"
				-- might as well add all the non-errors since they don't block from building
				elseif status.type ~= "error" then
					c = c + 1
					statuses[c] = status
				end
			end

			-- make sure we don't get errors down the line
			if type(statuses) ~= "table" then
				statuses = {}
			end

			-- update cursor obj colour
			self.cursor_obj:SetColorModifier(g_PlacementStateToColor[warning])

			self.construction_statuses = statuses
			if not dont_finalize then
				self:FinalizeStatusGathering(statuses)
			else
				return statuses
			end

		else
			return ChoGGi_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,dont_finalize,...)
		end
	end --ConstructionController:UpdateConstructionStatuses

	-- so we can do long spaced tunnels
	function TunnelConstructionController:UpdateConstructionStatuses(...)
		if ChoGGi.UserSettings.RemoveBuildingLimits then
			local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
			self:FinalizeStatusGathering(old_t)
		else
			return ChoGGi_OrigFuncs.TunnelConstructionController_UpdateConstructionStatuses(self,...)
		end
	end

	-- custom console rules
	if not blacklist then
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
				"ChoGGi.ComFuncs.OpenInImageViewerDlg(%s)"
			},
			{
				-- ~anything
				"^~(.*)",
				"ChoGGi.ComFuncs.OpenInExamineDlg(%s)"
			},
			{
				-- ~!obj_with_attachments
				"^~!(.*)",
				[[local attaches = ChoGGi.ComFuncs.GetAllAttaches(%s)
if #attaches > 0 then
	ChoGGi.ComFuncs.OpenInExamineDlg(attaches)
end]]
			},
			{
				-- &handle
				"^&(.*)",
				"ChoGGi.ComFuncs.OpenInExamineDlg(HandleToObject[%s])"
			},
			-- built-in
			{
				-- *r some function/cmd that needs a realtime thread
				"^*[rR]%s*(.*)",
				"CreateRealTimeThread(function() %s end) return"
			},
			{
				-- *g gametime
				"^*[gG]%s*(.*)",
				"CreateGameTimeThread(function() %s end) return"
			},
			{
				-- *m maprealtime
				"^*[mM]%s*(.*)",
				"CreateMapRealTimeThread(function() %s end) return"
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

		local AddConsoleLog = AddConsoleLog
		local ConsolePrint = ConsolePrint
		local ConsoleExec = ConsoleExec

		-- skip is used for ECM Scripts
		function Console:Exec(text,skip)
			if not skip then
				self:AddHistory(text)
				AddConsoleLog("> ", true)
				AddConsoleLog(text, false)
			end
			-- i like my rules kthxbai
			local err = ConsoleExec(text, console_rules)
			if err then
				ConsolePrint(err)
			end
		end

		-- and now the console has a blacklist :), though i am a little suprised they left it unfettered this long, been using it as a workaround for months
		if not blacklist and rawget(_G,"g_ConsoleFENV") == false then
			local Sleep = Sleep
			CreateRealTimeThread(function()
				if not g_ConsoleFENV then
					WaitMsg("Autorun")
				end
				while not g_ConsoleFENV do
					Sleep(250)
				end

				local rawget,rawset = rawget,rawset
				local run = rawget(g_ConsoleFENV,"__run")
				g_ConsoleFENV = {__run = run}
				setmetatable(g_ConsoleFENV, {
					__index = function(_, key)
						return rawget(_G, key)
					end,
					__newindex = function(_, key, value)
						rawset(_G, key, value)
					end
				})

			end)
		end

	end

end -- ClassesBuilt
