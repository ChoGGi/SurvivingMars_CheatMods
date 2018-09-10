-- See LICENSE for terms

-- in-game functions replaced with custom ones

--~ local Trans
local MsgPopup
local S
local blacklist
local ChoGGi_OrigFuncs
local SaveOrigFunc

-- set UI transparency:
local function SetTrans(obj)
	if not obj then
		return
	end
	local trans = ChoGGi.UserSettings.Transparency
	if obj.class and trans[obj.class] then
		obj:SetTransparency(trans[obj.class])
	end
end


function OnMsg.ClassesGenerate()

	--~ Trans = ChoGGi.ComFuncs.Translate
	MsgPopup = ChoGGi.ComFuncs.MsgPopup
	S = ChoGGi.Strings
	blacklist = ChoGGi.blacklist
	ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
	SaveOrigFunc = function(class_or_func,func_name)
		if func_name then
			local newname = string.format("%s_%s",class_or_func,func_name)
			if not ChoGGi_OrigFuncs[newname] then
				ChoGGi_OrigFuncs[newname] = _G[class_or_func][func_name]
			end
		else
			if not ChoGGi_OrigFuncs[class_or_func] then
				ChoGGi_OrigFuncs[class_or_func] = _G[class_or_func]
			end
		end
	end

	-- do some stuff
	local Platform = Platform
	Platform.editor = true
	-- fixes UpdateInterface nil value in editor mode
	local d_before = Platform.developer
	Platform.developer = true
	editor.LoadPlaceObjConfig()
	Platform.developer = d_before
	-- needed for HashLogToTable(), SM was planning to have multiple cities (or from a past game from this engine)?
	GlobalVar("g_Cities",{})
	-- editor wants a table
	GlobalVar("g_revision_map",{})
	-- stops some log spam in editor (function doesn't exist in SM)
	function UpdateMapRevision()end
	function AsyncGetSourceInfo()end

	do -- funcs without a class
--~ 		local function SaveOrigFunc(func_name)
--~ 			if not ChoGGi_OrigFuncs[func_name] then
--~ 				ChoGGi_OrigFuncs[func_name] = _G[func_name]
--~ 			end
--~ 		end

		SaveOrigFunc("OpenDialog")
		SaveOrigFunc("ShowConsole")
		SaveOrigFunc("ShowConsoleLog")
		SaveOrigFunc("ShowPopupNotification")
		SaveOrigFunc("GetMissingMods")
		SaveOrigFunc("IsDlcAvailable")
		SaveOrigFunc("UIGetBuildingPrerequisites")
		SaveOrigFunc("GetMaxCargoShuttleCapacity")
		SaveOrigFunc("LoadCustomOnScreenNotification")
		SaveOrigFunc("TDevModeGetEnglishText")

		-- I guess, don't pass a string to it?
		function TDevModeGetEnglishText(T, deep, no_assert,...)
			if type(T) == "string" then
				return T
			end
			return ChoGGi_OrigFuncs.TDevModeGetEnglishText(T, deep, no_assert,...)
		end

		-- fix for sending nil id to it
		local unpack_params = unpack_params
		function LoadCustomOnScreenNotification(notification)
			-- the first return is id, and some mods (cough Ambassadors cough) send a nil id, which breaks the func
			if unpack_params(notification) then
				return ChoGGi_OrigFuncs.LoadCustomOnScreenNotification(notification)
			end
		end

		function GetMaxCargoShuttleCapacity()
			local ChoGGi = ChoGGi
			if ChoGGi.UserSettings.StorageShuttle then
				return ChoGGi.UserSettings.StorageShuttle
			else
				return ChoGGi_OrigFuncs.GetMaxCargoShuttleCapacity()
			end
		end

	--~	 -- if i need the names of xelements
	--~	 function XTemplateSpawn(template_or_class, parent, context)
	--~		 print(template_or_class)
	--~		 return ChoGGi_OrigFuncs.XTemplateSpawn(template_or_class, parent, context)
	--~	 end

		-- SkipMissingDLC and no mystery dlc installed means the buildmenu tries to add missing buildings, and call a func that doesn't exist
		function UIGetBuildingPrerequisites(cat_id, template, bCreateItems)
			local class = template and g_Classes[template.template_class]
			if class and class:IsKindOf("Building") then
				return ChoGGi_OrigFuncs.UIGetBuildingPrerequisites(cat_id, template, bCreateItems)
			end
		end

		--stops confirmation dialog about missing mods (still lets you know they're missing)
		function GetMissingMods()
			if ChoGGi.UserSettings.SkipMissingMods then
				return "", false
			else
				return ChoGGi_OrigFuncs.GetMissingMods()
			end
		end

		--lets you load saved games that have dlc
		function IsDlcAvailable()
			if ChoGGi.UserSettings.SkipMissingDLC then
				return true
			else
				return ChoGGi_OrigFuncs.IsDlcAvailable()
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
		function ShowPopupNotification(preset, params, bPersistable, parent)
			--actually actually disable hints
			if ChoGGi.UserSettings.DisableHints and preset == "SuggestedBuildingConcreteExtractor" then
				return
			end

	--~		 if type(ChoGGi.testing) == "function" then
	--~		 --if ChoGGi.UserSettings.ConvertPopups and type(preset) == "string" and not preset:find("LaunchIssue_") then
	--~			 if not pcall(function()
	--~				 local function ColourText(Text,Bool)
	--~					 if Bool == true then
	--~						 return string.format("<color 200 200 200>%s</color>",Text)
	--~					 else
	--~						 return string.format("<color 75 255 75>%s</color>",Text)
	--~					 end
	--~				 end
	--~				 local function ReplaceParam(Name,Text,SearchName)
	--~					 SearchName = SearchName or string.format("<%s>",Name)
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
			return ChoGGi_OrigFuncs.ShowPopupNotification(preset, params, bPersistable, parent)
		end
		--Msg("ColonistDied",UICity.labels.Colonist[1],"low health")
		--local temp = PopupNotificationPresets.FirstColonistDeath

	 -- UI transparency dialogs (buildmenu, pins, infopanel)
		function OpenDialog(...)
			local ret = {ChoGGi_OrigFuncs.OpenDialog(...)}
			SetTrans(ret)
			return table.unpack(ret)
		end

		--console stuff
		function ShowConsoleLog(...)
			ChoGGi_OrigFuncs.ShowConsoleLog(...)
			SetTrans(dlgConsoleLog)
		end
	end -- do

	local AddMsgToFunc = ChoGGi.ComFuncs.AddMsgToFunc
	AddMsgToFunc("BaseBuilding","GameInit","ChoGGi_SpawnedBaseBuilding")
	AddMsgToFunc("DroneBase","GameInit","ChoGGi_SpawnedDrone")
	AddMsgToFunc("ElectricityProducer","CreateElectricityElement","ChoGGi_SpawnedProducer","electricity_production")
	AddMsgToFunc("AirProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducer","air_production")
	AddMsgToFunc("WaterProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducer","water_production")
	AddMsgToFunc("SingleResourceProducer","Init","ChoGGi_SpawnedProducer","production_per_day")
	AddMsgToFunc("PinnableObject","TogglePin","ChoGGi_TogglePinnableObject")

	-- Custom Msgs
	SaveOrigFunc("CursorBuilding","GameInit")
	SaveOrigFunc("SupplyRocket","HasEnoughFuelToLaunch")
	SaveOrigFunc("Workplace","GetWorkshiftPerformance")
	SaveOrigFunc("BaseRover","GetCableNearby")
	SaveOrigFunc("BuildingVisualDustComponent","SetDustVisuals")
	SaveOrigFunc("GridObject","GetPipeConnections")
	SaveOrigFunc("UIRangeBuilding","SetUIRange")
	SaveOrigFunc("Workplace","AddWorker")
	SaveOrigFunc("XPopupMenu","RebuildActions")
	SaveOrigFunc("XShortcutsHost","SetVisible")
	SaveOrigFunc("DustGridElement","AddDust")
	SaveOrigFunc("Building","ApplyUpgrade")

	-- allows you to build outside buildings inside and vice
	do -- CursorBuilding:GameInit
		function CursorBuilding:GameInit()
			if self.template_obj then
				if ChoGGi.UserSettings.RemoveBuildingLimits then
					self.template_obj.dome_required = false
					self.template_obj.dome_forbidden = false
				elseif self.template_obj then
					self.template_obj.dome_required = cc.template_obj:GetDefaultPropertyValue("dome_required")
					self.template_obj.dome_forbidden = cc.template_obj:GetDefaultPropertyValue("dome_forbidden")
				end
			end
			return ChoGGi_OrigFuncs.CursorBuilding_GameInit(self)
		end
	end -- do

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
		local set = ChoGGi.UserSettings.BuildingSettings[self.encyclopedia_id]
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

	-- yeah who gives a shit about mouseover hints on menu items
	function XPopupMenu:RebuildActions(host)
		local menu = self.MenuEntries
		local context = host.context
		local ShowIcons = self.ShowIcons
		self.idContainer:DeleteChildren()
		for i = 1, #host.actions do
			local action = host.actions[i]
			if action.ActionMenubar == menu and host:FilterAction(action) then
				local entry = XTemplateSpawn(action.ActionToggle and self.ToggleButtonTemplate or self.ButtonTemplate, self.idContainer, context)

				-- that was hard...
				if type(action.RolloverText) == "function" then
					entry.RolloverText = action.RolloverText()
				else
					entry.RolloverText = action.RolloverText
				end
				entry.RolloverTitle = S[126095410863--[[Info--]]]

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
					action:OnAltAction(host, this)
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
				entry:Open()
			end
		end
	end

	do -- Large Water Tank + Pipes + Chrome skin = borked looking pipes
		local spots = {"Tube", "Tubeleft", "Tuberight", "Tubestraight" }
		local spot_attach = {"Tube", "TubeLeft", "TubeRight", "TubeStraight" }
		local decor_spot = "Tubedecor"
		local IsValidEntity = IsValidEntity
		local point = point
		local WorldToHex = WorldToHex
		local IsKindOf = IsKindOf
		function GridObject:GetPipeConnections()
			if ChoGGi.Temp.FixingPipes then
				if not IsKindOf(self, "LifeSupportGridObject") then
					return
				end

				local gsn = self:GetGridSkinName()
				local entity = self.entity
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
				return ChoGGi_OrigFuncs.GridObject_GetPipeConnections(self)
			end
		end
	end

	--larger trib/subsurfheater radius
	function UIRangeBuilding:SetUIRange(radius)
		local rad = ChoGGi.UserSettings.BuildingSettings[self.encyclopedia_id]
		if rad and rad.uirange then
			radius = rad.uirange
		end
		return ChoGGi_OrigFuncs.UIRangeBuilding_SetUIRange(self, radius)
	end

	--block certain traits from workplaces
	function Workplace:AddWorker(worker, shift)
		local ChoGGi = ChoGGi
		local s = ChoGGi.UserSettings.BuildingSettings[self.encyclopedia_id]
		--check that the tables contain at least one trait
		local bt = s and s.blocktraits and type(s.blocktraits) == "table" and next(s.blocktraits) and s.blocktraits
		local rt = s and s.restricttraits and type(s.restricttraits) == "table" and next(s.restricttraits) and s.restricttraits
		if bt or rt then

			local block,restrict = ChoGGi.ComFuncs.RetBuildingPermissions(worker.traits,s)
			if block then
				return
			end
			if restrict then
				self.workers[shift] = self.workers[shift] or empty_table
				self.workers[shift][#self.workers[shift]+1] = worker
				--table.insert(self.workers[shift], worker)
				self:UpdatePerformance()
				self:SetWorkplaceWorking()
				self:UpdateAttachedSigns()
			end

		else
			return ChoGGi_OrigFuncs.Workplace_AddWorker(self, worker, shift)
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
		function DustGridElement:AddDust(dust)
			return ChangeDust(self,"DustGridElement_AddDust",dust)
		end
	end --do

	--change dist we can charge from cables
	function BaseRover:GetCableNearby(rad)
		local new_rad = ChoGGi.UserSettings.RCChargeDist
		if new_rad then
			rad = new_rad
		end
		return ChoGGi_OrigFuncs.BaseRover_GetCableNearby(self, rad)
	end

end --onmsg library

-- ClassesPreprocess
function OnMsg.ClassesPreprocess()
	SaveOrigFunc("InfopanelObj","CreateCheatActions")

	local GetActionsHost = GetActionsHost
	function InfopanelObj:CreateCheatActions(win)
		-- fire orig func to build cheats
		if ChoGGi_OrigFuncs.InfopanelObj_CreateCheatActions(self,win) then
			--then we can add some hints to the cheats
			return ChoGGi.InfoFuncs.SetInfoPanelCheatHints(GetActionsHost(win))
		end
	end

end -- ClassesPreprocess

-- ClassesPostprocess
--~ function OnMsg.ClassesPostprocess()
--~ end -- ClassesPostprocess

-- ClassesBuilt
function OnMsg.ClassesBuilt()
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
	SaveOrigFunc("MG_Colonists","GetProgress")
	SaveOrigFunc("MG_Martianborn","GetProgress")
	SaveOrigFunc("RCRover","SetWorkRadius")
	SaveOrigFunc("RCTransport","TransportRouteLoad")
	SaveOrigFunc("RCTransport","TransportRouteUnload")
	SaveOrigFunc("RequiresMaintenance","AddDust")
	SaveOrigFunc("SA_WaitMarsTime","StopWait")
	SaveOrigFunc("SA_WaitTime","StopWait")
	SaveOrigFunc("SingleResourceProducer","Produce")
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
	SaveOrigFunc("SpaceElevator","ToggleAllowExport")
	SaveOrigFunc("SpaceElevator","DroneUnloadResource")
--~	 SaveOrigFunc("RCRover","LeadIn")
	local UserSettings = ChoGGi.UserSettings

	function SpaceElevator:DroneUnloadResource(...)
		local export_when = ChoGGi.ComFuncs.DotNameToObject("ChoGGi.UserSettings.BuildingSettings.SpaceElevator.export_when_this_amount")
		local amount = s.max_export_storage - s.export_request:GetActualAmount()
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

--~	 function RCRover:LeadIn(drone)
--~		 self.drone_charged = drone

--~		 drone:GotoUnitSpot(self, "Charge", true) --get in pos to charge
--~		 if ChoGGi.UserSettings.DroneChargesFromRoverWrongAngle then
--~		 print("fix")
--~			 drone:Face(self:GetSpotRotation(self:GetSpotBeginIndex("Charge")), 200)
--~		 else
--~		 print("not")
--~			 drone:SetAngle(self:GetSpotRotation(self:GetSpotBeginIndex("Charge")), 200)
--~		 end

--~		 drone:StartFX("EmergencyRecharge")
--~		 drone:PlayState( "rechargeDroneStart" )
--~	 end

	-- hopefully they fix this in the next update... (though they didn't fix it in Curo so, or maybe they fixed one type of it)
	if LuaRevision == 231777 then
		-- check transports for borked paths
		function RCTransport:TransportRouteLoad()
			ChoGGi_OrigFuncs.RCTransport_TransportRouteLoad(self)
			if ChoGGi.UserSettings.CheckForBorkedTransportPath then
				ChoGGi.CodeFuncs.CheckForBorkedTransportPath(self)
			end
		end
		function RCTransport:TransportRouteUnload()
			ChoGGi_OrigFuncs.RCTransport_TransportRouteUnload(self)
			if ChoGGi.UserSettings.CheckForBorkedTransportPath then
				ChoGGi.CodeFuncs.CheckForBorkedTransportPath(self)
			end
		end
	end

	-- unbreakable cables/pipes
	function SupplyGridFragment:RandomElementBreakageOnWorkshiftChange()
		if not ChoGGi.UserSettings.BreakChanceCablePipe then
			return ChoGGi_OrigFuncs.SupplyGridFragment_RandomElementBreakageOnWorkshiftChange(self)
		end
	end

	-- stops the help webpage from showing up every single time
	if Platform.editor and UserSettings.SkipModHelpPage then
		function GedOpHelpMod() end
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
	function XDesktop:MouseEvent(event, pt, button, time)
--~ 		if event == "OnMouseButtonDown" and self.keyboard_focus and self.keyboard_focus:IsKindOf("XTextEditor") then
		if event == "OnMouseButtonDown" and self.keyboard_focus and self.keyboard_focus:IsKindOfClasses("XTextEditor","XList") then
			local hud = Dialogs.HUD
			if hud then
				hud:SetFocus()
			else
				-- hud should always be visible, but just in case focus on desktop
				self:SetFocus()
			end
		end

		return ChoGGi_OrigFuncs.XDesktop_MouseEvent(self, event, pt, button, time)
	end

	-- function from github as the actual function has a whoopsie, or something does...
	-- going to be a fix in next version:
	-- https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-game-becomes-unresponsive-under-certain-circumstances.1102544/page-2#post-24366021
	if LuaRevision <= 231139 then
		local CurrentThread = CurrentThread
		local DeleteThread = DeleteThread
		local IsValid = IsValid
		local Sleep = Sleep
		local WaitWakeup = WaitWakeup
		function RCRover:ExitAllDrones()
			if self.exit_drones_thread and self.exit_drones_thread ~= CurrentThread() then
				DeleteThread(self.exit_drones_thread)
				self.exit_drones_thread = CurrentThread()
			end

			while #self.attached_drones > 0 and self.siege_state_name == "Siege" do
				local drone = self.attached_drones[#self.attached_drones]
				if IsValid(drone) then
					if drone.command_center ~= self then
						--damage control, this should never happen
						assert(false, "Rover has foreign drones attached")
						drone:Detach()
						assert(drone == table.remove(self.attached_drones))
					else
						while self.guided_drone or #self.embarking_drones > 0 do
							Sleep(1000)
						end
						if IsValid(drone) then
							self.guided_drone = drone
							drone:SetCommand("ExitRover", self)
							while not WaitWakeup(10000) do end
						end
					end
				end
			end

			if self.exit_drones_thread and self.exit_drones_thread == CurrentThread() then
				self.exit_drones_thread = false
			end
		end
	end

	--remove annoying msg that happens everytime you click anything (nice)
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

	--removes earthsick effect
	function Colonist:ChangeComfort(...)
		ChoGGi_OrigFuncs.Colonist_ChangeComfort(self, ...)
		if ChoGGi.UserSettings.NoMoreEarthsick and self.status_effects.StatusEffect_Earthsick then
			self:Affect("StatusEffect_Earthsick", false)
		end
	end

	--make sure heater keeps the powerless setting
	function SubsurfaceHeater:UpdatElectricityConsumption()
		ChoGGi_OrigFuncs.SubsurfaceHeater_UpdatElectricityConsumption(self)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
		end
	end
	--same for tribby
	function TriboelectricScrubber:OnPostChangeRange()
		ChoGGi_OrigFuncs.TriboelectricScrubber_OnPostChangeRange(self)
		if self.ChoGGi_mod_electricity_consumption then
			ChoGGi.CodeFuncs.RemoveBuildingElecConsump(self)
		end
	end

	--remove idiot trait from uni grads (hah!)
	function MartianUniversity:OnTrainingCompleted(unit)
		if ChoGGi.UserSettings.UniversityGradRemoveIdiotTrait then
			unit:RemoveTrait("Idiot")
		end
		ChoGGi_OrigFuncs.MartianUniversity_OnTrainingCompleted(self, unit)
	end

	--used to skip mystery sequences
	do -- SkipMystStep
		local function SkipMystStep(self,MystFunc)
			local ChoGGi = ChoGGi
			local StopWait = ChoGGi.Temp.SA_WaitMarsTime_StopWait
			local p = self.meta.player

			if StopWait and p and StopWait.seed == p.seed then
				--inform user, or if it's a dbl then skip
				if StopWait.skipmsg then
					StopWait.skipmsg = nil
				else
					MsgPopup(
						302535920000735--[[Timer delay skipped--]],
						3486--[[Mystery--]]
					)
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

			return ChoGGi_OrigFuncs[MystFunc](self)
		end

		function SA_WaitTime:StopWait()
			SkipMystStep(self,"SA_WaitTime_StopWait")
		end
		function SA_WaitMarsTime:StopWait()
			SkipMystStep(self,"SA_WaitMarsTime_StopWait")
		end
	end -- do

	do -- GetProgress
		local GetMissionSponsor = GetMissionSponsor
		--some mission goals check colonist amounts
		function MG_Colonists:GetProgress()
			if ChoGGi.Temp.InstantMissionGoal then
				return GetMissionSponsor().goal_target + 1
			else
				return ChoGGi_OrigFuncs.MG_Colonists_GetProgress(self)
			end
		end
		function MG_Martianborn:GetProgress()
			if ChoGGi.Temp.InstantMissionGoal then
				return GetMissionSponsor().goal_target + 1
			else
				return ChoGGi_OrigFuncs.MG_Martianborn_GetProgress(self)
			end
		end
	end -- do

	--keep prod at saved values for grid producers (air/water/elec)
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
		ChoGGi_OrigFuncs.SupplyGridElement_SetProduction(self, new_production, new_throttled_production, update)
	end

	--and for regular producers (factories/extractors)
	function SingleResourceProducer:Produce(amount_to_produce)
		local amount = ChoGGi.UserSettings.BuildingSettings[self.parent.encyclopedia_id]
		if amount and amount.production then
			--set prod
			amount_to_produce = amount.production / guim
			--set displayed prod
			self.production_per_day = amount.production
		end

--see if this gets called less then produce
--~ function SingleResourceProducer:DroneUnloadResource(drone, request, resource, amount)
--~	 if resource == self.resource_produced and self.parent and self.parent ~= self then
--~		 self.parent:DroneUnloadResource(drone, request, resource, amount)
--~	 end
--~ end
		--get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
		if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
			ChoGGi.CodeFuncs.FuckingDrones(self)
		end

		return ChoGGi_OrigFuncs.SingleResourceProducer_Produce(self, amount_to_produce)
	end

	-- larger drone work radius
	do -- SetWorkRadius
		local function SetHexRadius(orig_func,setting,obj,orig_radius)
			local UserSettings = ChoGGi.UserSettings[setting]
			if UserSettings then
				return ChoGGi_OrigFuncs[orig_func](obj,UserSettings)
			end
			return ChoGGi_OrigFuncs[orig_func](obj,orig_radius)
		end
		function RCRover:SetWorkRadius(radius)
			SetHexRadius("RCRover_SetWorkRadius","RCRoverMaxRadius",self,radius)
		end
		function DroneHub:SetWorkRadius(radius)
			SetHexRadius("DroneHub_SetWorkRadius","CommandCenterMaxRadius",self,radius)
		end
	end -- do

	--toggle trans on mouseover
	function XWindow:OnMouseEnter(pt, child)
		if ChoGGi.UserSettings.TransparencyToggle then
			self:SetTransparency(0)
		end
		return ChoGGi_OrigFuncs.XWindow_OnMouseEnter(self, pt, child)
	end
	function XWindow:OnMouseLeft(pt, child)
		if ChoGGi.UserSettings.TransparencyToggle then
			SetTrans(self)
		end
		return ChoGGi_OrigFuncs.XWindow_OnMouseLeft(self, pt, child)
	end

	--remove spire spot limit
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

		function ConstructionController:UpdateCursor(pos, force)
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
				return ChoGGi_OrigFuncs.ConstructionController_UpdateCursor(self, pos, force)
			end

		end
	end -- do

	-- add height limits to certain panels (cheats/traits/colonists) till mouseover, and convert workers to vertical list on mouseover if over 14 (visible limit)
	do -- InfopanelDlg:Open
		local CreateRealTimeThread = CreateRealTimeThread
		local DeleteThread = DeleteThread
		local Sleep = Sleep
		local TGetID = TGetID
		local function ToggleVis(idx,content,v,h)
			for i = 6, idx do
				content[i]:SetVisible(v)
				content[i]:SetMaxHeight(h)
			end
		end

		local infopanel_list = {
			ipBuilding = true,
			ipColonist = true,
--~ 			ipConstruction = true,
			ipDrone = true,
			ipRover = true,
		}

		local function InfopanelDlgOpen(self)
			local UserSettings = ChoGGi.UserSettings

			-- give me the scroll. goddamn it blinky
			if UserSettings.ScrollSelection and infopanel_list[self.XTemplate] then
				self.idActionsFrame.parent:SetZOrder(2)
				ChoGGi.CodeFuncs.AddScrollDialogXTemplates(self)
			end

			local c = self.idContent
			if not c then
				return
			end

			-- this limits height of traits you can choose to 3 till mouse over
			if not UserSettings.ScrollSelection and UserSettings.SanatoriumSchoolShowAll and self.context:IsKindOfClasses("Sanatorium","School") then

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

			-- loop all the sections
			for i = 1, #c do
				local section = c[i]
				if section.class == "XSection" then
					local title = TGetID(section.idSectionTitle.Text)
					local content = section.idContent[2]

					-- enlarge worker section if over the max amount visible
					if section.idWorkers and #section.idWorkers > 14 then
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

					elseif not UserSettings.ScrollSelection then
						if title == 27--[[Cheats--]] then

							local expandthread
							section.OnMouseEnter = function()
								DeleteThread(expandthread)
								content:SetMaxHeight()
							end
							section.OnMouseLeft = function()
								expandthread = CreateRealTimeThread(function()
									Sleep(UserSettings.CheatsInfoPanelHideDelay or 1500)
									content:SetMaxHeight(0)
								end)
							end

						elseif title == 235--[[Traits--]] or title == 702480492408--[[Residents--]] then

							if title == 702480492408 then
								-- in certain situations the UI will flash if you make Clip = true, so we'll only set it if the cap has been changed
								if self.context.capacity ~= self.context.base_capacity then
									content.Clip = true
								end
							else
								content.Clip = true
							end

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
					end -- UserSettings.ScrollSelection

				end -- if XSection
			end
		end

		-- the actual function
		function InfopanelDlg:Open(...)
			CreateRealTimeThread(function()
				while not self.visible do
					Sleep(10)
				end
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

	-- make sure console is focused even when construction is opened
	function Console:Show(show)
		ChoGGi_OrigFuncs.Console_Show(self, show)
		local was_visible = self:GetVisible()
		if show and not was_visible then
			-- always on top
			self:SetModal()
		end
		if not show then
			-- always on top off
			self:SetModal(false)
		end
		-- adding transparency for console stuff
		SetTrans(self)

		-- and rebuild the console buttons (added by ECM)
		ChoGGi.ConsoleFuncs.RebuildConsoleToolbar(self)
	end

	do -- skip quit from being added to console history to prevent annoyances
		local skip_cmds = {
			quit = true,
			["quit()"] = true,
			exit = true,
			["exit()"] = true,
			reboot = true,
			["reboot()"] = true,
			restart = true,
			["restart()"] = true,
		}
		function Console:AddHistory(text)
			if skip_cmds[text] then
				return
			end
			return ChoGGi_OrigFuncs.Console_AddHistory(self,text)
		end
	end -- do

	-- kind of an ugly way of making sure console doesn't include ` when using tilde to open console
	function Console:TextChanged()
		ChoGGi_OrigFuncs.Console_TextChanged(self)
		if self.idEdit:GetText() == "`" then
			self.idEdit:SetText("")
		end
	end

	--make it so caret is at the end of the text when you use history
	function Console:HistoryDown()
		ChoGGi_OrigFuncs.Console_HistoryDown(self)
		self.idEdit:SetCursor(1,#self.idEdit:GetText())
	end

	function Console:HistoryUp()
		ChoGGi_OrigFuncs.Console_HistoryUp(self)
		self.idEdit:SetCursor(1,#self.idEdit:GetText())
	end

	do -- RequiresMaintenance:AddDust
		local IsBox = IsBox
		local IsPoint = IsPoint
		local MulDivRound = MulDivRound
		--was giving a nil error in log, I assume devs'll fix it one day
		function RequiresMaintenance:AddDust(amount)
			--this wasn't checking if it was a number/point/box so errors in log, now it checks
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
			if IsValid(last) and ChoGGi.UserSettings.UseLastOrientation then
--~ 				if type(ret[1].SetAngle) == "function" then
				if ret[1].SetAngle then
					ret[1]:SetAngle(last:GetAngle() or 0)
				end
			end

			return table.unpack(ret)
		end
	end -- do

	--so we can build without (as many) limits
	function ConstructionController:UpdateConstructionStatuses(dont_finalize)
		if ChoGGi.UserSettings.RemoveBuildingLimits then
			--send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
			ChoGGi_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,"dont_finalize")

			local status = self.construction_statuses

			if self.is_template then
				local cobj = rawget(self.cursor_obj, true)
				local tobj = setmetatable({
					[true] = cobj,
--~ 					["city"] = UICity
					city = UICity
				}, {
					__index = self.template_obj
				})
				tobj:GatherConstructionStatuses(self.construction_statuses)
			end

			--remove errors we want to remove
			local statusNew = {}
			local c = 0
			local ConstructionStatus = ConstructionStatus
			if type(status) == "table" and #status > 0 then
				for i = 1, #status do
					if status[i].type == "warning" then
						c = c + 1
						statusNew[c] = status[i]
					--ResourceRequired < no point in building an extractor when there's nothing to extract
					--BlockingObjects < place buildings in each other
					--NoPlaceForSpire
					--PassageTooCloseToLifeSupport
					--PassageAngleToSteep might be needed?

					--UnevenTerrain < causes issues when placing buildings (martian ground viagra)
					elseif status[i] == ConstructionStatus.UnevenTerrain then
						c = c + 1
						statusNew[c] = status[i]
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
			return ChoGGi_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,dont_finalize)
		end
	end --ConstructionController:UpdateConstructionStatuses

	--so we can do long spaced tunnels
	function TunnelConstructionController:UpdateConstructionStatuses()
		if ChoGGi.UserSettings.RemoveBuildingLimits then
			local old_t = ConstructionController.UpdateConstructionStatuses(self, "dont_finalize")
			self:FinalizeStatusGathering(old_t)
		else
			return ChoGGi_OrigFuncs.TunnelConstructionController_UpdateConstructionStatuses(self)
		end
	end

	--add a bunch of rules to console input
	local ConsoleRules = {

		-- print info in console log
		{
			-- $userdata/string id
			"^$(.*)",
			"print(ChoGGi.ComFuncs.Translate(%s))"
		},
		{
			-- @function
			"^@(.*)",
			"print(debug.getinfo(%s))"
		},
		{
			-- @@anything
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
			-- ~anything
			"^~(.*)",
			"ChoGGi.ComFuncs.OpenInExamineDlg(%s)"
		},
		{
			-- &handle
			"^&(.*)",
			"ChoGGi.ComFuncs.OpenInExamineDlg(HandleToObject[%s])"
		},
		{
			-- !!obj_with_attachments
			"^!!(.*)",
			"local o = (%s) local attaches = type(o) == 'table' and o:IsKindOf('ComponentAttach') and o:GetAttaches() if attaches and #attaches > 0 then ChoGGi.ComFuncs.OpenInExamineDlg(attaches,true) end"
		},

		-- built-in
		{
			-- r* some function/cmd that needs a realtime thread
			"^*r%s*(.*)",
			"CreateRealTimeThread(function() %s end) return"
		},
		{
			-- g* or a gametime
			"^*g%s*(.*)",
			"CreateGameTimeThread(function() %s end) return"
		},
		{
			-- m* or a maprealtime
			"^*g%s*(.*)",
			"CreateMapRealTimeThread(function() %s end) return"
		},
		-- something screenshot
		{
		"^SSA?A?0%d+ (.*)",
		"ViewShot([[%s]])"
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
	local ConsoleExecute
	if blacklist then
		dlgConsole:Exec("ChoGGi.Temp.ConsoleExec=ConsoleExec")
		ConsoleExecute = ChoGGi.Temp.ConsoleExec
	else
		ConsoleExecute = ConsoleExec
	end
	local ConsolePrint = ConsolePrint
	function Console:Exec(text,skip)
		if not skip then
			self:AddHistory(text)
			AddConsoleLog("> ", true)
			AddConsoleLog(text, false)
		end
		-- i like my rules kthxbai
		local err = ConsoleExecute(text, ConsoleRules)
		if err then
			ConsolePrint(err)
		end
	end

end -- ClassesBuilt
