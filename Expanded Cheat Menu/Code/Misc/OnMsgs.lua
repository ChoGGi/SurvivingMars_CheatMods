--	See LICENSE for terms

-- most OnMsgs

-- nope not hacky at all
local is_loaded
function OnMsg.ChoGGi_Library_Loaded()
	if is_loaded then
		return
	end
	is_loaded = true
	-- nope nope nope

	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local S = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist

	local pairs,type,next,tostring,print,pcall = pairs,type,next,tostring,print,pcall

	local box = box
	local FlushLogFile = FlushLogFile
	local Msg = Msg

	local OnMsg = OnMsg

	-- be too annoying to add templates to all of these manually
	XMenuEntry.RolloverTemplate = "Rollover"
	XListItem.RolloverTemplate = "Rollover"
	-- sure, lets have them appear under certain items (though i think mostly just happens from console, and I've changed that so I could remove this?)
	XRolloverWindow.ZOrder = max_int

	-- when it's not visible it doesn't take up space
	--~	 XListItem.FoldWhenHidden = true

	-- changed from 2000000
	ConsoleLog.ZOrder = 2
	Console.ZOrder = 3
	-- changed from 10000000
	XShortcutsHost.ZOrder = 4
	-- make cheats menu look like older one (more gray, less white)
	local dark_gray = -9868951
	XMenuBar.Background = dark_gray
	XMenuBar.TextColor = -1
	XPopupMenu.Background = dark_gray
	XPopupMenu.TextColor = -1

	-- use this message to mess with the classdefs (before classes are built)
	--~ function OnMsg.ClassesGenerate()
	--~ end

	-- use this message to do some processing to the already final classdefs (still before classes are built)
	function OnMsg.ClassesPreprocess()
	--~	 local ChoGGi = ChoGGi

	--~	 InfopanelItems.LayoutMethod = "VList"
	--~	 InfopanelItems.MaxWidth = 500
	--~	 InfopanelItems.Clip = true
	--~	 InfopanelItems.LayoutVSpacing = 50
	--~	 InfopanelItems.Margins = box(0,135,-30,0)
	--~	 box(left,top, right, bottom)


	--~	 "None",
	--~	 "Box",
	--~	 "HOverlappingList",
	--~	 "VOverlappingList",
	--~	 "HList",
	--~	 "VList",
	--~	 "HPanel",
	--~	 "Grid",
	--~	 "HWrap",
	--~	 "VWrap"

		-- stops crashing with certain missing pinned objects
		if ChoGGi.UserSettings.FixMissingModBuildings then
			local umc = UnpersistedMissingClass
			local c = #umc.__parents
			c = c + 1
			umc.__parents[c] = "AutoAttachObject"
			c = c + 1
			umc.__parents[c] = "PinnableObject"
		end
	end

	-- where we can add new BuildingTemplates
	-- use this message to make modifications to the built classes (before they are declared final)
	--~ function OnMsg.ClassesPostprocess()
	--~ end

	do -- OnMsg ClassesBuilt/XTemplatesLoaded
		local function OnMsgXTemplates()
			local XTemplates = XTemplates
			local PlaceObj = PlaceObj

			XTemplates.sectionCheats[1].__condition = function(parent, context)
				-- no sense in doing anything without cheats pane enabled, and there's not cheats for res overview
				if not config.BuildingInfopanelCheats or context.class == "ResourceOverview" then
					return false
				end
				return context:CreateCheatActions(parent)
			end

			if not ChoGGi.UserSettings.ScrollSelection then
				-- limit height of cheats pane and others in the selection panel
				XTemplates.sectionCheats[1][1].Clip = true
				XTemplates.sectionCheats[1][1].MaxHeight = 0
				XTemplates.sectionResidence[1][1].MaxHeight = 256
			end
			-- add rollovers to cheats toolbar
			XTemplates.EditorToolbarButton[1].RolloverTemplate = "Rollover"

			-- added to stuff spawned with object spawner
			if XTemplates.ipChoGGi_Everything then
				XTemplates.ipChoGGi_Everything:delete()
			end
			PlaceObj('XTemplate', {
				group = "Infopanel Sections",
				id = "ipChoGGi_Everything",
				PlaceObj('XTemplateTemplate', {
					'__condition', function (_, context) return context.ChoGGi_Spawned end,
					'__template', "Infopanel",
					'Description', S[313911890683--[[<description>--]]],
				}, {
				PlaceObj('XTemplateTemplate', {
					'comment', "salvage",
					'__template', "InfopanelButton",
					'RolloverText', S[640016954592--[[Remove this switch or valve.--]]],
					'RolloverTitle', S[3973--[[Salvage--]]],
					'RolloverHintGamepad', S[7657--[[<ButtonY> Activate--]]],
					'ContextUpdateOnOpen', false,
					'OnPressParam', "Demolish",
					'Icon', "UI/Icons/IPButtons/salvage_1.tga",
				}, {
						PlaceObj('XTemplateFunc', {
							'name', "OnXButtonDown(self, button)",
							'func', function (self, button)
								if button == "ButtonY" then
									return self:OnButtonDown(false)
								elseif button == "ButtonX" then
									return self:OnButtonDown(true)
								end
								return (button == "ButtonA") and "break"
							end,
						}),
						PlaceObj('XTemplateFunc', {
							'name', "OnXButtonUp(self, button)",
							'func', function (self, button)
								if button == "ButtonY" then
									return self:OnButtonUp(false)
								elseif button == "ButtonX" then
									return self:OnButtonUp(true)
								end
								return (button == "ButtonA") and "break"
							end,
						}),
					}),
				}),
			})
		end

		-- called when new DLC is added (or a new game)
		function OnMsg.XTemplatesLoaded()
			OnMsgXTemplates()
		end

		-- use this message to perform post-built actions on the final classes
		function OnMsg.ClassesBuilt()
			--add HiddenX cat for Hidden items
			if ChoGGi.UserSettings.Building_hide_from_build_menu then
				BuildCategories[#BuildCategories+1] = {id = "HiddenX",name = S[1000155--[[Hidden--]]],img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",}
			end

			OnMsgXTemplates()
		end

	end -- do

	function OnMsg.ModsLoaded()
		local ChoGGi = ChoGGi

		-- easy access to colonist data, cargo, mystery
		ChoGGi.ComFuncs.UpdateDataTables()

	--~ 	ForEachPreset("Cargo", function(cargo, group, self, props)
	--~		 if cargo.id == "RegolithExtractor" then
	--~			 -- needed to show it in the menu
	--~			 cargo.locked = nil
	--~			 cargo.group = "Prefabs"
	--~			 -- set weight/price
	--~			 cargo.kg = 1234
	--~			 cargo.price = 123400000
	--~		 end
	--~	 end)

		-- added this here, as it's early enough to load during the New Game Menu
		if not ChoGGi.UserSettings.DisableECM then
			local Actions = ChoGGi.Temp.Actions
			local c = #Actions

			-- add preset menu items
			ClassDescendantsList("Preset", function(name, cls)
				c = c + 1
				Actions[c] = {
					ActionMenubar = "Presets",
					ActionName = name,
					ActionId = string.format("Presets.%s",name),
					ActionIcon = cls.EditorIcon or "CommonAssets/UI/Menu/CollectionsEditor.tga",
					RolloverText = S[302535920000733--[[Open a preset in the editor.--]]],
					OnAction = function()
						OpenGedApp(g_Classes[name].GedEditor, Presets[name], {
							PresetClass = name,
							SingleFile = cls.SingleFile
						})
					end,
				}
			end)

			-- add the defaults we skip to my actions
			for i = 1, c do
				local a = Actions[i]
				-- if it's a . than we haven't updated it yet
				if a.ActionId:sub(1,1) == "." then
					a.ActionTranslate = false
					a.replace_matching_id = true
					a.ActionId = string.format("%s%s",a.ActionMenubar,a.ActionId)
				end
			end

			-- show console log history
			if ChoGGi.UserSettings.ConsoleToggleHistory then
				ShowConsoleLog(true)
			end

			if ChoGGi.UserSettings.ConsoleHistoryWin then
				ChoGGi.ComFuncs.ShowConsoleLogWin(true)
			end

			--dim that console bg
			if ChoGGi.UserSettings.ConsoleDim then
				config.ConsoleDim = 1
			end

			-- build console buttons
			if dlgConsole and not dlgConsole.ChoGGi_MenuAdded then
				dlgConsole.ChoGGi_MenuAdded = true
				ChoGGi.ConsoleFuncs.ConsoleControls(dlgConsole)
			end

		end -- DisableECM
	end

	function OnMsg.PersistPostLoad()
		if ChoGGi.UserSettings.FixMissingModBuildings then
			--[LUA ERROR] Mars/Lua/Construction.lua:860: attempt to index a boolean value (global 'ControllerMarkers')
			if type(ControllerMarkers) == "boolean" then
				ControllerMarkers = {}
			end

			--[LUA ERROR] Mars/Lua/Heat.lua:65: attempt to call a nil value (method 'ApplyForm')
			local s_Heaters = s_Heaters or empty_table
			for obj,_ in pairs(s_Heaters) do
				if obj:IsKindOf("UnpersistedMissingClass") then
					s_Heaters[obj] = nil
				end
			end

			--GetFreeSpace,GetFreeLivingSpace,GetFreeWorkplaces,GetFreeWorkplacesAround
			local UICity = UICity
			for _,label in pairs(UICity.labels or empty_table) do
				for i = #label, 1, -1 do
					if IsKindOf(label[i],"UnpersistedMissingClass") then
						label[i]:delete()
						table.remove(label,i)
					end
				end
			end

	--~		 local domes = UICity.labels.Dome or ""
	--~		 for i = 1, #domes do
	--~			 for _,label in pairs(domes[i].labels or empty_table) do
	--~				 for j = #label, 1, -1 do
	--~					 if type(label[j].SetBase) ~= "function" then
	--~						 label[j]:delete()
	--~						 table.remove(label,j)
	--~					 end
	--~				 end
	--~			 end
	--~		 end

		end
	end

	-- removes all the dev shortcuts/etc and adds mine
	local function Rebuildshortcuts()
		local XShortcutsTarget = XShortcutsTarget

		-- remove all built-in shortcuts (pretty much just a cutdown copy of ReloadShortcuts)
		XShortcutsTarget.actions = {}
		-- re-add certain ones
		if not Platform.ged then
			if XTemplates.GameShortcuts then
				XTemplateSpawn("GameShortcuts", XShortcutsTarget)
			end
		elseif XTemplates.GedShortcuts then
			XTemplateSpawn("GedShortcuts", XShortcutsTarget)
		end

		-- remove stuff from GameShortcuts
		local table_remove = table.remove
		for i = #XShortcutsTarget.actions, 1, -1 do
			-- removes pretty much all the dev actions added, and leaves the game ones intact
			local id = XShortcutsTarget.actions[i].ActionId
			if id and (not id:starts_with("action") --[[or id:starts_with("actionPOC")--]] or id == "actionToggleFullscreen") then
				table_remove(XShortcutsTarget.actions,i)
			end
		end

		-- and add mine
		local XAction = XAction
		local Actions = ChoGGi.Temp.Actions

	--~ Actions = {}
	--~ Actions[#Actions+1] = {
	--~	 ActionId = "ChoGGi_ShowConsoleTilde",
	--~	 OnAction = function()
	--~	 local dlgConsole = dlgConsole
	--~	 if dlgConsole then
	--~		 ShowConsole(not dlgConsole:GetVisible())
	--~	 end
	--~	 end,
	--~	 ActionShortcut = ChoGGi.Defaults.KeyBindings.ShowConsoleTilde,
	--~ }

		for i = 1, #Actions do
			-- and add to the actual actions
			XShortcutsTarget:AddAction(XAction:new(Actions[i]))
		end

		-- add rightclick action to menuitems
		XShortcutsTarget:UpdateToolbar()
		-- got me
		XShortcutsThread = false
	end

	function OnMsg.ShortcutsReloaded()
		-- we don't add shortcuts and ain't supposed to drink no booze
		if not ChoGGi.UserSettings.DisableECM then
			Rebuildshortcuts()

			local dlgConsole = dlgConsole
			if dlgConsole then
				ShowConsole(not dlgConsole:GetVisible())
				ShowConsole(not dlgConsole:GetVisible())
			end
		end
	end

	-- for instant build
	function OnMsg.BuildingPlaced(obj)
		if obj:IsKindOf("Building") then
			ChoGGi.Temp.LastPlacedObject = obj
		end
	end --OnMsg

	local function QuickBuild(sites)
		for i = 1, #sites do
			if not sites[i].construction_group or sites[i].construction_group[1] == sites[i] then
				sites[i]:Complete("quick_build")
			end
		end
	end

	-- regular build
	function OnMsg.ConstructionSitePlaced(obj)
		local ChoGGi = ChoGGi
		if obj:IsKindOf("Building") then
			ChoGGi.Temp.LastPlacedObject = obj
		end

		if ChoGGi.UserSettings.Building_instant_build then
			-- i do it this way instead of using .instant_build so domes don't fuck up
			DelayedCall(100, function()
				local UICity = UICity
				QuickBuild(UICity.labels.ConstructionSite or "")
				QuickBuild(UICity.labels.ConstructionSiteWithHeightSurfaces or "")
			end)
		end
	end --OnMsg

	-- this gets called before buildings are completely initialized (no air/water/elec attached)
	function OnMsg.ConstructionComplete(obj)

		-- skip rockets
		if obj.class == "RocketLandingSite" then
			return
		end
		local ChoGGi = ChoGGi
		local UserSettings = ChoGGi.UserSettings

	--~ 	-- if it's a fancy dome then we allow building in the removed entrances
	--~ 	if obj:IsKindOf("Dome") then
	--~ 		local startid, endid = obj:GetAllSpots(obj:GetState())
	--~ 		for i = startid, endid do
	--~ 			if obj:GetSpotName(i) == "Entrance" or obj:GetSpotAnnotation(i) == "att,DomeRoad_04,show" then
	--~ 				print(111)
	--~ 			end
	--~ 		end
	--~ 	end

		--print(obj.encyclopedia_id) print(obj.class)
		if obj.class == "UniversalStorageDepot" then
			if UserSettings.StorageUniversalDepot and obj.entity == "StorageDepot" then
				obj.max_storage_per_resource = UserSettings.StorageUniversalDepot
			--other
			elseif UserSettings.StorageOtherDepot and obj.entity ~= "StorageDepot" then
				obj.max_storage_per_resource = UserSettings.StorageOtherDepot
			end

		elseif UserSettings.StorageMechanizedDepot and obj.class:find("MechanizedDepot") then
			obj.max_storage_per_resource = UserSettings.StorageMechanizedDepot

		elseif UserSettings.StorageWasteDepot and obj.class == "WasteRockDumpSite" then
			obj.max_amount_WasteRock = UserSettings.StorageWasteDepot
			if obj:GetStoredAmount() < 0 then
				obj:CheatEmpty()
				obj:CheatFill()
			end

		elseif UserSettings.StorageOtherDepot and obj.class == "MysteryDepot" then
			obj.max_storage_per_resource = UserSettings.StorageOtherDepot

		elseif UserSettings.StorageOtherDepot and obj.class == "BlackCubeDumpSite" then
			obj.max_amount_BlackCube = UserSettings.StorageOtherDepot

		elseif UserSettings.ShuttleHubFuelStorage and obj.class:find("ShuttleHub") then
			obj.consumption_max_storage = UserSettings.ShuttleHubFuelStorage

		elseif UserSettings.SchoolTrainAll and obj.class == "School" then
			for i = 1, #ChoGGi.Tables.PositiveTraits do
				obj:SetTrait(i,ChoGGi.Tables.PositiveTraits[i])
			end

		elseif UserSettings.SanatoriumCureAll and obj.class == "Sanatorium" then
			for i = 1, #ChoGGi.Tables.NegativeTraits do
				obj:SetTrait(i,ChoGGi.Tables.NegativeTraits[i])
			end

		end --end of elseifs

		if UserSettings.InsideBuildingsNoMaintenance and obj.dome_required then
			obj.ChoGGi_InsideBuildingsNoMaintenance = true
			obj.maintenance_build_up_per_hr = -10000
		end

		if UserSettings.RemoveMaintenanceBuildUp and obj.base_maintenance_build_up_per_hr then
			obj.ChoGGi_RemoveMaintenanceBuildUp = true
			obj.maintenance_build_up_per_hr = -10000
		end

		-- saved building settings
		local setting = UserSettings.BuildingSettings[obj.encyclopedia_id]
		if setting then
			if next(setting) then
				-- saved settings for capacity, shuttles
				if setting.capacity then
					if obj.base_capacity then
						obj.capacity = setting.capacity
					elseif obj.base_air_capacity then
						obj.air_capacity = setting.capacity
					elseif obj.base_water_capacity then
						obj.water_capacity = setting.capacity
					elseif obj.base_max_shuttles then
						obj.max_shuttles = setting.capacity
					end
				end
				-- max visitors
				if setting.visitors and obj.base_max_visitors then
					obj.max_visitors = setting.visitors
				end
				-- max workers
				if setting.workers then
					obj.max_workers = setting.workers
				end
				-- no power needed
				if setting.nopower then
					ChoGGi.CodeFuncs.RemoveBuildingElecConsump(obj)
				end
				if setting.noair then
					ChoGGi.CodeFuncs.RemoveBuildingAirConsump(obj)
				end
				if setting.nowater then
					ChoGGi.CodeFuncs.RemoveBuildingWaterConsump(obj)
				end
				-- large protect_range for defence buildings
				if setting.protect_range then
					obj.protect_range = setting.protect_range
					obj.shoot_range = setting.protect_range * ChoGGi.Consts.guim
				end
				-- fully auto building
				if setting.auto_performance then
					obj.max_workers = 0
					obj.automation = 1
					obj.auto_performance = setting.auto_performance
				end
				-- legacy setting
				if setting.performance then
					obj.max_workers = 0
					obj.automation = 1
					obj.auto_performance = setting.performance
				end
				-- just perf boost
				if setting.performance_notauto then
					obj.performance = setting.performance_notauto
				end
				-- space ele export amount
				if setting.max_export_storage then
					obj.max_export_storage = setting.max_export_storage
				end
				-- space ele import amount
				if setting.cargo_capacity then
					obj.cargo_capacity = setting.cargo_capacity
				end
				-- service comforts
				if next(setting.service_stats) then
					ChoGGi.CodeFuncs.UpdateServiceComfortBld(obj,setting.service_stats)
				end

			else
				-- empty table so remove
				UserSettings.BuildingSettings[obj.encyclopedia_id] = nil
			end
		end

	end --OnMsg

	function OnMsg.Demolished(obj)
		local UICity = UICity
		--update our list of working domes for AttachToNearestDome (though I wonder why this isn't already a label)
		if obj.achievement == "FirstDome" then
			local UICity = obj.city or UICity
			UICity.labels.Domes_Working = nil
			UICity:InitEmptyLabel("Domes_Working")
			local table_temp = UICity.labels.Dome or ""
			local c = #UICity.labels.Domes_Working
			for i = 1, #table_temp do
				c = c + 1
				UICity.labels.Domes_Working[c] = table_temp[i]
			end
		end
	end --OnMsg

	do -- ColonistCreated
		local function ColonistCreated(obj,skip)
			local UserSettings = ChoGGi.UserSettings

			if UserSettings.GravityColonist then
				obj:SetGravity(UserSettings.GravityColonist)
			end
			if UserSettings.NewColonistGender then
				ChoGGi.CodeFuncs.ColonistUpdateGender(obj,UserSettings.NewColonistGender)
			end
			if UserSettings.NewColonistAge then
				ChoGGi.CodeFuncs.ColonistUpdateAge(obj,UserSettings.NewColonistAge)
			end
			-- children don't have spec models so they get black cube
			if UserSettings.NewColonistSpecialization and not skip then
				ChoGGi.CodeFuncs.ColonistUpdateSpecialization(obj,UserSettings.NewColonistSpecialization)
			end
			if UserSettings.NewColonistRace then
				ChoGGi.CodeFuncs.ColonistUpdateRace(obj,UserSettings.NewColonistRace)
			end
			if UserSettings.NewColonistTraits then
				ChoGGi.CodeFuncs.ColonistUpdateTraits(obj,true,UserSettings.NewColonistTraits)
			end
			if UserSettings.SpeedColonist then
				obj:SetMoveSpeed(UserSettings.SpeedColonist)
			end
			if UserSettings.DeathAgeColonist then
				obj.death_age = UserSettings.DeathAgeColonist
			end

		end

		function OnMsg.ColonistArrived(obj)
			ColonistCreated(obj)
		end --OnMsg

		function OnMsg.ColonistBorn(obj)
			ColonistCreated(obj,true)
		end --OnMsg
	end -- do

	function OnMsg.SelectionAdded(obj)
		--update selection shortcut
		s = obj
		--update last placed (or selected)
		if obj:IsKindOf("Building") then
			ChoGGi.Temp.LastPlacedObject = obj
		end
	end

	-- remove selected obj when nothing selected
	function OnMsg.SelectionRemoved()
		s = false
	end

	-- const.Scale.sols is 720 000 ticks (GameTime)
	function OnMsg.NewDay() -- NewSol...
		-- let everyone else go first
		DelayedCall(1000, function()
			local ChoGGi = ChoGGi

			-- sorts cc list by dist to building
			if ChoGGi.UserSettings.SortCommandCenterDist then
				local objs = UICity.labels.Building or ""
				local sort = table.sort
				local CompareTableFuncs = ChoGGi.ComFuncs.CompareTableFuncs
				for i = 1, #objs do
					-- no sense in doing it with only one center
					if #objs[i].command_centers > 1 then
						sort(objs[i].command_centers,
							function(a,b)
								return CompareTableFuncs(a,b,"GetDist2D",objs[i])
							end
						)
					end
				end
			end

			-- dump log to disk
			if ChoGGi.UserSettings.FlushLog then
				FlushLogFile()
			end

			-- loop through and remove any missing popups
			local popups = ChoGGi.Temp.MsgPopups or ""
			local remove = table.remove
			for i = #popups, 1, -1 do
				if not popups[i]:IsVisible() then
					popups[i]:delete()
					remove(popups,i)
				end
			end

		end)
	end

	-- const.Scale.hours is 30 000 ticks (GameTime)
	function OnMsg.NewHour()
		-- let everyone else go first
		DelayedCall(500, function()
			local ChoGGi = ChoGGi

			-- make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
			if ChoGGi.UserSettings.DroneResourceCarryAmountFix then
				local labels = UICity.labels

				-- Hey. Do I preach at you when you're lying stoned in the gutter? No!
				local prods = labels.ResourceProducer or ""
				for i = 1, #prods do
					ChoGGi.CodeFuncs.FuckingDrones(prods[i]:GetProducerObj())
					if prods[i].wasterock_producer then
						ChoGGi.CodeFuncs.FuckingDrones(prods[i].wasterock_producer)
					end
				end
				prods = labels.BlackCubeStockpiles or ""
				for i = 1, #prods do
					ChoGGi.CodeFuncs.FuckingDrones(prods[i])
				end
			end

			-- pathing? pathing in domes works great... watch out for that invisible wall!
			-- update: seems like this is an issue from one of those smarter work ai mods
			if ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings then
				ChoGGi.CodeFuncs.ResetHumanCentipedes()
			end

			-- some types of crashing won't allow SM to gracefully close and leave a log/minidump as the devs envisioned... No surprise to anyone who's ever done any sort of debugging before.
			if ChoGGi.UserSettings.FlushLogConstantly then
				FlushLogFile()
			end
		end)
	end

	-- const.MinuteDuration is 500 ticks (GameTime)
	--~ function OnMsg.NewMinute()
	--~ end

	ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100 or 100
	-- used for resizing my dialogs to scale
	function OnMsg.SystemSize()
		ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100
	end

	function OnMsg.ResearchQueueChange(city, tech_id)
		if ChoGGi.UserSettings.InstantResearch then
			GrantResearchPoints(city.tech_status[tech_id].cost)
			-- updates the researchdlg by toggling it.
			if GetDialog("ResearchDlg") then
				CloseDialog("ResearchDlg")
				OpenDialog("ResearchDlg")
			end
		end
	end

	-- if you pick a mystery from the cheat menu
	local icon_logo_13 = "UI/Icons/Logos/logo_13.tga"
	function OnMsg.MysteryBegin()
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.ShowMysteryMsgs then
			MsgPopup(
				302535920000729--[[You've started a mystery!--]],
				3486--[[Mystery--]],
				icon_logo_13
			)
		end
	end
	function OnMsg.MysteryChosen()
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.ShowMysteryMsgs then
			MsgPopup(
				302535920000730--[[You've chosen a mystery!--]],
				3486--[[Mystery--]],
				icon_logo_13
			)
		end
	end
	function OnMsg.MysteryEnd(outcome)
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.ShowMysteryMsgs then
			MsgPopup(
				tostring(outcome),
				3486--[[Mystery--]],
				icon_logo_13
			)
		end
	end

	-- fired when cheats menu is toggled
	function OnMsg.DevMenuVisible(visible)
		if visible then
			if ChoGGi.UserSettings.KeepCheatsMenuPosition then
				XShortcutsTarget:SetPos(ChoGGi.UserSettings.KeepCheatsMenuPosition)
			else
				-- if user turns off menu pos then it'll stay where it's put, so set back to default pos
				XShortcutsTarget:SetPos(point(0,0))
			end
		end
	end

	function OnMsg.ApplicationQuit()
		local ChoGGi = ChoGGi

		-- resetting settings?
		if ChoGGi.Temp.ResetECMSettings or ChoGGi.testing then
			return
		end

		-- console log window settings
		local dlg = dlgChoGGi_ConsoleLogWin
		if dlg then
			ChoGGi.UserSettings.ConsoleLogWin_Pos = dlg:GetPos()
			ChoGGi.UserSettings.ConsoleLogWin_Size = dlg:GetSize()
		end

		-- save menu pos
		if ChoGGi.UserSettings.KeepCheatsMenuPosition then
			ChoGGi.UserSettings.KeepCheatsMenuPosition = XShortcutsTarget:GetPos()
		end

		-- save any unsaved settings on exit
		ChoGGi.SettingFuncs.WriteSettings()
	end

	-- attached temporary resource depots
	function OnMsg.ChoGGi_SpawnedResourceStockpileLR(obj)
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.StorageMechanizedDepotsTemp and obj.parent.class:find("MechanizedDepot") then
			ChoGGi.CodeFuncs.SetMechanizedDepotTempAmount(obj.parent)
		end
	end

	function OnMsg.ChoGGi_TogglePinnableObject(obj)
		local UnpinObjects = ChoGGi.UserSettings.UnpinObjects
		if type(UnpinObjects) == "table" and next(UnpinObjects) then
			local table_temp = UnpinObjects or ""
			for i = 1, #table_temp do
				if obj.class == table_temp[i] and obj:IsPinned() then
					obj:TogglePin()
					break
				end
			end
		end
	end

	-- shuttle comes out of a hub
	function OnMsg.ChoGGi_SpawnedShuttle(obj)
		local UserSettings = ChoGGi.UserSettings
		if UserSettings.StorageShuttle then
			obj.max_shared_storage = UserSettings.StorageShuttle
		end
		if UserSettings.SpeedShuttle then
			obj.move_speed = UserSettings.SpeedShuttle
		end
	end

	function OnMsg.ChoGGi_SpawnedDrone(obj)
		local UserSettings = ChoGGi.UserSettings
		if UserSettings.GravityDrone then
			obj:SetGravity(UserSettings.GravityDrone)
		end
		if UserSettings.SpeedDrone then
			obj:SetMoveSpeed(UserSettings.SpeedDrone)
		end
	end

	do -- SpawnedRover
		local function SpawnedRover(obj)
			local UserSettings = ChoGGi.UserSettings
			if UserSettings.SpeedRC then
				obj:SetMoveSpeed(UserSettings.SpeedRC)
			end
			if UserSettings.GravityRC then
				obj:SetGravity(UserSettings.GravityRC)
			end
		end

		function OnMsg.ChoGGi_SpawnedRCTransport(obj)
			local UserSettings = ChoGGi.UserSettings
			if UserSettings.RCTransportStorageCapacity then
				obj.max_shared_storage = UserSettings.RCTransportStorageCapacity
			end
			SpawnedRover(obj)
		end
		function OnMsg.ChoGGi_SpawnedRCRover(obj)
			if ChoGGi.UserSettings.RCRoverMaxRadius then
				-- I override the func so no need to send a value here
				obj:SetWorkRadius()
			end
			SpawnedRover(obj)
		end
		function OnMsg.ChoGGi_SpawnedExplorerRover(obj)
			SpawnedRover(obj)
		end
	end -- do

	function OnMsg.ChoGGi_SpawnedDroneHub(obj)
		if ChoGGi.UserSettings.CommandCenterMaxRadius then
			obj:SetWorkRadius()
		end
	end

	-- if an inside building is placed outside of dome, attach it to nearest dome (if there is one)
	function OnMsg.ChoGGi_SpawnedResidence(obj)
		ChoGGi.CodeFuncs.AttachToNearestDome(obj)
	end
	function OnMsg.ChoGGi_SpawnedWorkplace(obj)
		ChoGGi.CodeFuncs.AttachToNearestDome(obj)
	end
	function OnMsg.ChoGGi_SpawnedSpireBase(obj)
		ChoGGi.CodeFuncs.AttachToNearestDome(obj)
	end
	function OnMsg.ChoGGi_SpawnedDinerGrocery(obj)
		local ChoGGi = ChoGGi
		-- more food for diner/grocery
		if ChoGGi.UserSettings.ServiceWorkplaceFoodStorage then
			-- for some reason InitConsumptionRequest always adds 5 to it
			local storedv = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage - (5 * ChoGGi.Consts.ResourceScale)
			obj.consumption_stored_resources = storedv
			obj.consumption_max_storage = ChoGGi.UserSettings.ServiceWorkplaceFoodStorage
		end
	end

	function OnMsg.ChoGGi_SpawnedSupplyRocket(obj)
		local ChoGGi = ChoGGi
		if ChoGGi.UserSettings.RocketMaxExportAmount then
			obj.max_export_storage = ChoGGi.UserSettings.RocketMaxExportAmount
		end
	end

	-- make sure they use with our new values
	do -- SetProd
		local function SetProd(obj,sType)
			local prod = ChoGGi.UserSettings.BuildingSettings[obj.encyclopedia_id]
			if prod and prod.production then
				obj[sType] = prod.production
			end
		end
		function OnMsg.ChoGGi_SpawnedProducerElectricity(obj)
			SetProd(obj,"electricity_production")
		end
		function OnMsg.ChoGGi_SpawnedProducerAir(obj)
			SetProd(obj,"air_production")
		end
		function OnMsg.ChoGGi_SpawnedProducerWater(obj)
			SetProd(obj,"water_production")
		end
		function OnMsg.ChoGGi_SpawnedProducerSingle(obj)
			SetProd(obj,"production_per_day")
		end
	end -- do

	do -- CheckForRate
		local function SetValue(obj,value,res)
			if value.charge then
				obj[res].max_charge = value.charge
				obj[string.format("max_%s_charge",res)] = value.charge
			end
			if value.discharge then
				obj[res].max_discharge = value.discharge
				obj[string.format("max_%s_discharge",res)] = value.discharge
			end
		end
		local function CheckForRate(obj)
			--charge/discharge
			local value = ChoGGi.UserSettings.BuildingSettings[obj.encyclopedia_id]

			if value then

				if type(obj.GetStoredAir) == "function" then
					SetValue(obj,value,"air")
				elseif type(obj.GetStoredWater) == "function" then
					SetValue(obj,value,"water")
				elseif type(obj.GetStoredPower) == "function" then
					SetValue(obj,value,"electricity")
				end
			end
		end

		--water/air tanks
		function OnMsg.ChoGGi_SpawnedLifeSupportGridObject(obj)
			CheckForRate(obj)
		end
		--battery
		function OnMsg.ChoGGi_SpawnedElectricityStorage(obj)
			CheckForRate(obj)
		end
	end -- do

	-- hidden milestones
	function OnMsg.ChoGGi_DaddysLittleHitler()
		local MilestoneCompleted = MilestoneCompleted
		PlaceObj("Milestone", {
	--~		 Complete = function(self)
	--~			 WaitMsg("ChoGGi_DaddysLittleHitler2")
	--~			 return true
	--~		 end,
			base_score = 0,
			display_name = S[302535920000731--[[Deutsche Gesellschaft für Rassenhygiene--]]],
			group = "Default",
			id = "DaddysLittleHitler"
		})
		if not MilestoneCompleted.DaddysLittleHitler then
			MilestoneCompleted.DaddysLittleHitler = 3025359200000
		end
	end

	function OnMsg.ChoGGi_Childkiller()
		local MilestoneCompleted = MilestoneCompleted
		PlaceObj("Milestone", {
			base_score = 0,
			display_name = S[302535920000732--[[Childkiller (You evil, evil person.)--]]],
			group = "Default",
			id = "Childkiller"
		})
		if not MilestoneCompleted.Childkiller then
			MilestoneCompleted.Childkiller = 479000000
		end
	end

	-- earliest on-ground objects are loaded?
	--~ function OnMsg.PersistLoad()
	--~ end
	-- show how long loading takes
	function OnMsg.ChangeMap()
		local ChoGGi = ChoGGi
		if ChoGGi.testing or ChoGGi.UserSettings.ShowStartupTicks then
			ChoGGi.Temp.StartupTicks = GetPreciseTicks()
		end
	end

	-- so we at least have keys when it happens
	function OnMsg.ReloadLua()
		if type(XShortcutsTarget.UpdateToolbar) == "function" then
			Rebuildshortcuts()
		end
	end

	-- saved game is loaded
	function OnMsg.LoadGame()
		ChoGGi.Temp.IsChoGGiMsgLoaded = false
		Msg("ChoGGi_Loaded")
	end

	-- for new games
	function OnMsg.CityStart()
		local ChoGGi = ChoGGi
		ChoGGi.Temp.IsChoGGiMsgLoaded = false
		-- reset my mystery msgs to hidden
		ChoGGi.UserSettings.ShowMysteryMsgs = nil
		Msg("ChoGGi_Loaded")
	end


	do -- LoadGame/CityStart
		local function SetMissionBonuses(UserSettings,Presets,preset,which,Func)
			local tab = Presets[preset].Default or ""
			for i = 1, #tab do
				if UserSettings[string.format("%s%s",which,tab[i].id)] then
					Func(tab[i].id)
				end
			end
		end

		function OnMsg.ChoGGi_Loaded()
			local UICity = UICity
			--for new games
			if not UICity then
				return
			end

			-- a place to store per-game values
			if not UICity.ChoGGi then
				UICity.ChoGGi = {}
			end

			local ChoGGi = ChoGGi

			-- so ChoGGi_Loaded gets fired only every load, rather than also everytime we save
			if ChoGGi.Temp.IsChoGGiMsgLoaded == true then
				return
			end
			ChoGGi.Temp.IsChoGGiMsgLoaded = true

			local UserSettings = ChoGGi.UserSettings
			local g_Classes = g_Classes
			local config = config
			local const = const
			local BuildMenuPrerequisiteOverrides = BuildMenuPrerequisiteOverrides
			local Presets = Presets
			local hr = hr

			-- gets used a few times
			local table_temp

			-- late enough that I can set g_Consts.
			ChoGGi.SettingFuncs.SetConstsToSaved()

			-- needed for DroneResourceCarryAmount?
			UpdateDroneResourceUnits()

			-- clear out Temp settings
			ChoGGi.Temp.UnitPathingHandles = {}

			-- not needed, removing from old saves, so people don't notice them
			UICity.labels.ChoGGi_GridElements = nil
			UICity.labels.ChoGGi_LifeSupportGridElement = nil
			UICity.labels.ChoGGi_ElectricityGridElement = nil
			-- re-binding is now an in-game thing, so keys are just defaults
			UserSettings.KeyBindings = nil

			-- fix an issue I added...
			for _,settings in pairs(UserSettings.BuildingSettings) do
				if settings.performance and settings.auto_performance then
					settings.performance = nil
					ChoGGi.Temp.WriteSettings = true
				end
				for key,value in pairs(settings) do
					if key == "performance" and value == "disable" then
						settings.performance = nil
						ChoGGi.Temp.WriteSettings = true
					end
				end
			end

			-- update cargo resupply
			ChoGGi.ComFuncs.UpdateDataTables(true)
			for Key,Value in pairs(UserSettings.CargoSettings or empty_table) do
				if ChoGGi.Tables.Cargo[Key] then
					if Value.pack then
						ChoGGi.Tables.Cargo[Key].pack = Value.pack
					end
					if Value.kg then
						ChoGGi.Tables.Cargo[Key].kg = Value.kg
					end
					if Value.price then
						ChoGGi.Tables.Cargo[Key].price = Value.price
					end
				end
			end

			SetMissionBonuses(UserSettings,Presets,"MissionSponsorPreset","Sponsor",ChoGGi.CodeFuncs.SetSponsorBonuses)
			SetMissionBonuses(UserSettings,Presets,"CommanderProfilePreset","Commander",ChoGGi.CodeFuncs.SetCommanderBonuses)

			if not UserSettings.DisableECM then

				-- show cheat pane in selection panel
				if UserSettings.InfopanelCheats then
					config.BuildingInfopanelCheats = true
				end

				-- remove some uselessish Cheats to clear up space
				if UserSettings.CleanupCheatsInfoPane then
					ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
				end

				-- reloads actions (cheat menu/menu items/shortcuts)
				Rebuildshortcuts()

				-- cheats menu fun
				local XShortcutsTarget = XShortcutsTarget
				if XShortcutsTarget then

					-- add some ids for easier selection later on
					for i = 1, #XShortcutsTarget do
						if XShortcutsTarget[i].class == "XMenuBar" then
							XShortcutsTarget.idMenuBar = XShortcutsTarget[i]
						elseif XShortcutsTarget[i].class == "XWindow" then
							XShortcutsTarget.idToolbar = XShortcutsTarget[i]
							break
						end
					end

					-- add a hint about rightclicking
					XShortcutsTarget:SetRolloverTemplate("Rollover")
					XShortcutsTarget:SetRolloverTitle(S[126095410863--[[Info--]]])
					XShortcutsTarget:SetRolloverText(S[302535920000503--[[Right-click an item/submenu to add/remove it from the quickbar.--]]])

					-- yeah... i don't need the menu taking up the whole width of my screen
					XShortcutsTarget:SetHAlign("left")

					-- always show menu on my computer
					if UserSettings.ShowCheatsMenu or ChoGGi.testing then
						XShortcutsTarget:SetVisible(true)
					end

					-- that info text about right-clicking expands the menu instead of just hiding or something
					for i = 1, #XShortcutsTarget.idToolbar do
						if XShortcutsTarget.idToolbar[i].class == "XText" then
							XShortcutsTarget.idToolbar[i]:delete()
						end
					end

					ChoGGi.CodeFuncs.DraggableCheatsMenu(UserSettings.DraggableCheatsMenu)
				end
			end -- DisableECM





	---------------------do the above stuff before the below stuff




			-- show all traits in trainable popup
			if UserSettings.SanatoriumSchoolShowAllTraits then
				g_SchoolTraits = ChoGGi.Tables.PositiveTraits
				g_SanatoriumTraits = ChoGGi.Tables.NegativeTraits
			end

			-- all yours XxUnkn0wnxX
			if not blacklist then
				local autoexec = string.format("%s/autoexec.lua",ChoGGi.scripts)
				if ChoGGi.ComFuncs.FileExists(autoexec) then
					print("ECM executing: ",autoexec)
					dofile(autoexec)
				end
			end

			-- bloody hint popups
			if ChoGGi.UserSettings.DisableHints then
				mapdata.DisableHints = true
				HintsEnabled = false
			end

			-- show completed hidden milestones
			if UICity.ChoGGi.DaddysLittleHitler then
				PlaceObj("Milestone", {
					base_score = 0,
					display_name = S[302535920000731--[[Deutsche Gesellschaft für Rassenhygiene--]]],
					group = "Default",
					id = "DaddysLittleHitler"
				})
				if not MilestoneCompleted.DaddysLittleHitler then
					MilestoneCompleted.DaddysLittleHitler = 3025359200000 -- hitler's birthday
				end
			end
			if UICity.ChoGGi.Childkiller then
				PlaceObj("Milestone", {
					base_score = 0,
					display_name = S[302535920000732--[[Childkiller (You evil, evil person.)--]]],
					group = "Default",
					id = "Childkiller"
				})
				--it doesn't hurt
				if not MilestoneCompleted.Childkiller then
					MilestoneCompleted.Childkiller = 479000000 -- 666
				end
			end

			--add custom lightmodel
			local lm = LightmodelPresets
			if type(lm.ChoGGi_Custom and lm.ChoGGi_Custom.delete) == "function" then
				lm.ChoGGi_Custom:delete()
			end

			-- we have to copy the table, so :new doesn't replace my saved settings
			local temp_lm
			if UserSettings.LightmodelCustom then
				temp_lm = table.copy(UserSettings.LightmodelCustom)
			else
				temp_lm = table.copy(ChoGGi.Consts.LightmodelCustom)
			end
			lm.ChoGGi_Custom = LightmodelPreset:new(temp_lm)

			-- if there's a lightmodel name saved
			if UserSettings.Lightmodel then
				SetLightmodelOverride(1,UserSettings.Lightmodel)
			end

			-- defaults to 20 items
			const.nConsoleHistoryMaxSize = 100

			--long arsed cables
			if UserSettings.UnlimitedConnectionLength then
				g_Classes.GridConstructionController.max_hex_distance_to_allow_build = 1000
				const.PassageConstructionGroupMaxSize = 1000
			end

			-- on by default, you know all them martian trees (might make a cpu difference, probably not)
			hr.TreeWind = 0

			if UserSettings.DisableTextureCompression then
				-- uses more vram (1 toggles it, not sure what 0 does...)
				hr.TR_ToggleTextureCompression = 1
			end

			-- render settings
			hr.ShadowmapSize = UserSettings.ShadowmapSize or hr.ShadowmapSize
			hr.DTM_VideoMemory = UserSettings.VideoMemory or hr.DTM_VideoMemory
			hr.TR_MaxChunks = UserSettings.TerrainDetail or hr.TR_MaxChunks
			hr.LightsRadiusModifier = UserSettings.LightsRadius or hr.LightsRadiusModifier

			if UserSettings.HigherRenderDist then
				-- lot of lag for some small rocks in distance
				-- hr.AutoFadeDistanceScale = 2200 --def 2200

				-- render objects from further away (going to 960 makes a minimal difference, other than FPS on bigger cities)
				if type(UserSettings.HigherRenderDist) == "number" then
					hr.DistanceModifier = UserSettings.HigherRenderDist
					hr.LODDistanceModifier = UserSettings.HigherRenderDist
				else
					hr.DistanceModifier = 600
					hr.LODDistanceModifier = 600
				end
			end

			if UserSettings.HigherShadowDist then
				if type(UserSettings.HigherShadowDist) == "number" then
					hr.ShadowRangeOverride = UserSettings.HigherShadowDist
				else
					-- shadow cutoff dist
					hr.ShadowRangeOverride = 1000000 --def 0
				end
				-- no shadow fade out when zooming
				hr.ShadowFadeOutRangePercent = 0 --def 30
			end

			-- default to showing interface in ss
			if UserSettings.ShowInterfaceInScreenshots then
				hr.InterfaceInScreenshot = 1
			end

			-- not sure why this would be false on a dome
			table_temp = UICity.labels.Dome or ""
			for i = 1, #table_temp do
				if table_temp[i].achievement == "FirstDome" and type(table_temp[i].connected_domes) ~= "table" then
					table_temp[i].connected_domes = {}
				end
			end

			-- something messed up if storage is negative (usually setting an amount then lowering it)
			table_temp = UICity.labels.Storages or ""
			pcall(function()
				for i = 1, #table_temp do
					if table_temp[i]:GetStoredAmount() < 0 then
						-- we have to empty it first (just filling doesn't fix the issue)
						table_temp[i]:CheatEmpty()
						table_temp[i]:CheatFill()
					end
				end
			end)

			--so we can change the max_amount for concrete
			table_temp = g_Classes.TerrainDepositConcrete.properties or ""
			for i = 1, #table_temp do
				if table_temp[i].id == "max_amount" then
					table_temp[i].read_only = nil
				end
			end

			-- override building templates

			for _,temp in pairs(BuildingTemplates or {}) do
				--make hidden buildings visible
				if UserSettings.Building_hide_from_build_menu then
					BuildMenuPrerequisiteOverrides.StorageMysteryResource = true
					BuildMenuPrerequisiteOverrides.MechanizedDepotMysteryResource = true
					if temp.id ~= "LifesupportSwitch" and temp.id ~= "ElectricitySwitch" then
						temp.hide_from_build_menu = nil
					end
					if temp.build_category == "Hidden" and temp.id ~= "RocketLandingSite" then
						temp.build_category = "HiddenX"
					end
				end

				--wonder building limit
				if UserSettings.Building_wonder then
					temp.wonder = nil
				end
			end

			--set zoom/border scrolling
			ChoGGi.CodeFuncs.SetCameraSettings()

			--show all traits
			if UserSettings.SanatoriumSchoolShowAll then
				g_Classes.Sanatorium.max_traits = #ChoGGi.Tables.NegativeTraits
				g_Classes.School.max_traits = #ChoGGi.Tables.PositiveTraits
			end

			-- new version, not that i really need this anymore...
			if ChoGGi._VERSION ~= UserSettings._VERSION then
				-- update saved version
				UserSettings._VERSION = ChoGGi._VERSION
				ChoGGi.Temp.WriteSettings = true
			end

			CreateRealTimeThread(function()
				--clean up my old notifications (doesn't actually matter if there's a few left, but it can spam log)
				local shown = g_ShownOnScreenNotifications or empty_table
				for Key,_ in pairs(shown) do
					if type(Key) == "number" or tostring(Key):find("ChoGGi_")then
						shown[Key] = nil
					end
				end

				--remove any dialogs we opened
				ChoGGi.CodeFuncs.CloseDialogsECM()

				--remove any outside buildings i accidentally attached to domes ;)
				table_temp = UICity.labels.BuildingNoDomes or ""
				local sType
				for i = 1, #table_temp do
					if table_temp[i].dome_required == false and table_temp[i].parent_dome then

						sType = false
						--remove it from the dome label
						if table_temp[i].closed_shifts then
							sType = "Residence"
						elseif table_temp[i].colonists then
							sType = "Workplace"
						end

						if sType then --get a fucking continue lua
							if table_temp[i].parent_dome.labels and table_temp[i].parent_dome.labels[sType] then
								local dome = table_temp[i].parent_dome.labels[sType]
								for j = 1, #dome do
									if dome[j].class == table_temp[i].class then
										dome[j] = nil
									end
								end
							end
							--remove parent_dome
							table_temp[i].parent_dome = nil
						end

					end
				end

	--~			 -- make the change map dialog movable
	--~ print("DataInstances.UIDesignerData")
	--~			 if next(DataInstances.UIDesignerData) then
	--~				 DataInstances.UIDesignerData.MapSettingsDialog.parent_control.Movable = true
	--~				 DataInstances.UIDesignerData.MessageQuestionBox.parent_control.Movable = true
	--~			 end
			end)

			-- print startup msgs to console log
			local msgs = ChoGGi.Temp.StartupMsgs
			for i = 1, #msgs do
				print(msgs[i])
			end

			-- everyone loves a new titlebar, unless they don't
			if UserSettings.ChangeWindowTitle then
				terminal.SetOSWindowTitle(string.format("%s: %s v%s",S[1079--[[Surviving Mars--]]],S[302535920000887--[[ECM--]]],ChoGGi._VERSION))
			end

			-- first time run info
			if ChoGGi.UserSettings.FirstRun ~= false then
				ChoGGi.ComFuncs.MsgWait(
					string.format("%s\n%s",S[302535920000001--[["F2 to toggle Cheats Menu (Ctrl-F2 for Cheats Pane), and F9 to clear console log text.
	If this isn't a new install, then see Menu>Help>Changelog and search for ""To import your old settings""."--]]],S[302535920001309--[["Press Tilde or Enter and click the ""Settings"" button to stop showing console log."--]]]),
					string.format("%s %s",S[302535920000000--[[Expanded Cheat Menu--]]],S[302535920000201--[[Active--]]]),
					string.format("%sPreview.png",ChoGGi.ModPath)
				)
				ChoGGi.UserSettings.FirstRun = false
				ChoGGi.Temp.WriteSettings = true
			end



			------------------------------- always fired last



			-- make sure to save anything we changed above
			if ChoGGi.Temp.WriteSettings then
				ChoGGi.SettingFuncs.WriteSettings()
				ChoGGi.Temp.WriteSettings = nil
			end

			if UserSettings.FlushLog then
				FlushLogFile()
			end

			printC("<color 200 200 200>",S[302535920000887--[[ECM--]]],"</color>: <color 128 255 128>Testing Enabled</color>")

			-- how long startup takes
			if ChoGGi.testing or UserSettings.ShowStartupTicks then
				print("<color 200 200 200>",S[302535920000887--[[ECM--]]],"</color>:",S[302535920000247--[[Startup ticks--]]],":",GetPreciseTicks() - ChoGGi.Temp.StartupTicks)
			end

			if not ChoGGi.testing then
				-- getting tired of people asking how to disable console log
				print("<color 200 200 200>",S[302535920000887--[[ECM--]]],"</color>:",S[302535920001309--[["Press Tilde or Enter and click the ""Settings"" button to stop showing console log."--]]])
			end

			-- used to check when game has started and it's safe to print() etc
			ChoGGi.Temp.GameLoaded = true


	--~ CreateRealTimeThread(function()
	--~	 if not g_gedListener then
	--~		 ListenForGed(true)
	--~	 end

	--~	 local id = AsyncRand()
	--~	 local template = "GedInspector"
	--~	 local context = {}
	--~	 context.in_game = true
	--~	 local ged = OpenGed(id, true)
	--~	 if not ged then
	--~		 return
	--~	 end
	--~	 ged:BindObj("root", s)
	--~	 ged.app_template = template
	--~	 ged.context = context
	--~	 local err = ged:Rfc("rpcOpenApp", template, context)
	--~	 if err then
	--~		 print("OpenGedApp('%s') error: %s", tostring(template), tostring(err))
	--~	 end

	--~	 Msg("GedOpened", ged.ged_id)
	--~	 ChoGGi.ged = ged
	--~ end)


		end --OnMsg
	end -- do

end
