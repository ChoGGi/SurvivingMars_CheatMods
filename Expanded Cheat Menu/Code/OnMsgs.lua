-- See LICENSE for terms

-- OnMsgs (most of them)

local type, pairs = type, pairs
local table_sort = table.sort
local table_remove = table.remove
local table_find = table.find
local FlushLogFile = FlushLogFile
local Msg = Msg
local OnMsg = OnMsg
local CreateRealTimeThread = CreateRealTimeThread
local T = T

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local Translate = ChoGGi.ComFuncs.Translate
local AttachToNearestDome = ChoGGi.ComFuncs.AttachToNearestDome
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin
local Strings = ChoGGi.Strings
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

do -- custom msgs
	local AddMsgToFunc = ChoGGi.ComFuncs.AddMsgToFunc
	-- true fires msg in a thread to delay it
	AddMsgToFunc("BaseBuilding", "GameInit", "ChoGGi_SpawnedBaseBuilding", true)
	AddMsgToFunc("Drone", "GameInit", "ChoGGi_SpawnedDrone", true)
	AddMsgToFunc("PinnableObject", "TogglePin", "ChoGGi_TogglePinnableObject")

	AddMsgToFunc("AirProducer", "CreateLifeSupportElements", "ChoGGi_SpawnedProducer", nil, "air_production")
	AddMsgToFunc("ElectricityProducer", "CreateElectricityElement", "ChoGGi_SpawnedProducer", nil, "electricity_production")
	AddMsgToFunc("WaterProducer", "CreateLifeSupportElements", "ChoGGi_SpawnedProducer", nil, "water_production")
	AddMsgToFunc("SingleResourceProducer", "Init", "ChoGGi_SpawnedProducer", nil, "production_per_day")
end -- do

-- stops crashing with certain missing pinned objects
if ChoGGi.UserSettings.FixMissingModBuildings then
	local umc = UnpersistedMissingClass
	ChoGGi.ComFuncs.AddParentToClass(umc, "AutoAttachObject")
	ChoGGi.ComFuncs.AddParentToClass(umc, "PinnableObject")
	umc.entity = "ErrorAnimatedMesh"
end

-- use this message to mess with the classdefs (before classes are built)
function OnMsg.ClassesGenerate()
	if ChoGGi.UserSettings.FlushLog then
		FlushLogFile()
	end
end

-- use this message to do some processing to the already final classdefs (still before classes are built)
function OnMsg.ClassesPreprocess()
	-- Add default Consts/const values to ChoGGi.Consts
	if not ChoGGi.Tables.Consts_names then
		local cConsts = ChoGGi.Consts
		local names = {}

		local c = 0
		local Consts = Consts
		for key,value in pairs(Consts) do
			if type(value) == "number" then
				c = c + 1
				names[c] = key
				cConsts[key] = value
			end
		end
		ChoGGi.Tables.Consts_names = names

		local const_names = ChoGGi.Tables.const_names
		for i = 1, #const_names do
			local name = const_names[i]
			cConsts[name] = const[name]
		end
		cConsts.InvalidPos = InvalidPos()
	end

	if ChoGGi.UserSettings.FlushLog then
		FlushLogFile()
	end
end

-- where we can add new BuildingTemplates, and other PlaceObjs
-- use this message to make modifications to the built classes (before they are declared final)
function OnMsg.ClassesPostprocess()
	local XTemplates = XTemplates
	local ChoGGi = ChoGGi
	local UserSettings = ChoGGi.UserSettings

	for key, template in pairs(XTemplates) do
		local xt = template[1]
		-- add some ids to make it easier to fiddle with selection panel (making sure to skip the repeatable ones)
		if key:sub(1, 7) == "section" and key:sub(-3) ~= "Row" then
			if xt and not xt.Id then
				xt.Id = "id" .. template.id .. "_ChoGGi"
			end
		-- add cheats section to stuff without it
		elseif key:sub(1, 2) == "ip" and not table_find(xt, "__template", "sectionCheats") then
			xt[#xt+1] = PlaceObj("XTemplateTemplate", {
				"__template", "sectionCheats",
			})
		end
	end

	-- no sense in firing the func without cheats pane enabled
	XTemplates.sectionCheats[1].__condition = function(parent, context)
		return config.BuildingInfopanelCheats and context:CreateCheatActions(parent)
	end

	-- remove all that spacing between buttons
	XTemplates.sectionCheats[1][1].LayoutHSpacing = 10

	-- add rollovers to cheats toolbar
	XTemplates.EditorToolbarButton[1].RolloverTemplate = "Rollover"

	-- left? right? who cares? I do... *&^%$#@$ designers
	if UserSettings.GUIDockSide then
		XTemplates.NewOverlayDlg[1].Dock = "right"
		XTemplates.SaveLoadContentWindow[1].Dock = "right"
		ChoGGi.ComFuncs.SetTableValue(XTemplates.SaveLoadContentWindow[1], "Dock", "left", "Dock", "right")
		XTemplates.PhotoMode[1].Dock = "right"
	end

	-- change rollover max width
	if UserSettings.WiderRollovers then
		local roll = XTemplates.Rollover[1]
		local idx = table_find(roll, "Id", "idContent")
		if idx then
			roll = roll[idx]
			idx = table_find(roll, "Id", "idText")
			if idx then
				roll[idx].MaxWidth = UserSettings.WiderRollovers
			end
		end
	end

	-- added to stuff spawned with object spawner
	if XTemplates.ipChoGGi_Entity then
		XTemplates.ipChoGGi_Entity:delete()
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipChoGGi_Entity",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "ChoGGi_OBuildingEntityClass",
			"__template", "Infopanel",
		}, {

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", Strings[302535920000682--[[Change Entity]]],
				"RolloverHint", T(608042494285--[[<left_click> Activate]]),
				"ContextUpdateOnOpen", true,
				"OnContextUpdate", function(self)
					self:SetRolloverText(Strings[302535920001151--[[Set Entity For %s]]]:format(RetName(self.context)))
				end,
				"OnPress", function(self)
					ChoGGi.ComFuncs.EntitySpawner(self.context, {
						skip_msg = true,
						list_type = 7,
						planning = self.context.planning and true,
						title_postfix = RetName(self.context),
					})
				end,
				"Icon", "UI/Icons/IPButtons/shuttle.tga",
			}),

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"Icon", "UI/Icons/IPButtons/automated_mode_on.tga",
				"RolloverTitle", T(1000077--[[Rotate]]),
				"RolloverText", T(7519--[[<left_click>]]) .. " "
					.. T(312752058553--[[Rotate Building Left]]).. "\n"
					.. T(7366--[[<right_click>]]) .. " "
					.. T(306325555448--[[Rotate Building Right]]),
				"RolloverHint", "",
				"RolloverHintGamepad", T(7518--[[ButtonA]]) .. " "
					.. T(312752058553--[[Rotate Building Left]]) .. " "
					.. T(7618--[[ButtonX]]) .. " " .. T(306325555448--[[Rotate Building Right]]),
				"OnPress", function (self, gamepad)
					self.context:Rotate(not gamepad and IsMassUIModifierPressed())
					ObjModified(self.context)
				end,
				"AltPress", true,
				"OnAltPress", function (self, gamepad)
					if gamepad then
						self.context:Rotate(gamepad)
					else
						self.context:Rotate(not IsMassUIModifierPressed())
					end
					ObjModified(self.context)
				end,
			}),

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", Strings[302535920000457--[[Anim State Set]]],
				"RolloverHint", T(608042494285--[[<left_click> Activate]]),
				"RolloverText", Strings[302535920000458--[[Make object dance on command.]]],
				"OnPress", function(self)
					ChoGGi.ComFuncs.SetAnimState(self.context)
				end,
				"Icon", "UI/Icons/IPButtons/expedition.tga",
			}),

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", Strings[302535920000129--[[Set]]] .. " " .. Strings[302535920001184--[[Particles]]],
				"RolloverHint", T(608042494285--[[<left_click> Activate]]),
				"RolloverText", Strings[302535920001421--[[Shows a list of particles you can use on the selected obj.]]],
				"OnPress", function(self)
					ChoGGi.ComFuncs.SetParticles(self.context)
				end,
				"Icon", "UI/Icons/IPButtons/status_effects.tga",
			}),

------------------- Salvage
		PlaceObj('XTemplateTemplate', {
			'comment', "salvage",
			'__context_of_kind', "Demolishable",
			'__condition', function (_, context) return context:ShouldShowDemolishButton() end,
			'__template', "InfopanelButton",
			'RolloverTitle', T(3973, --[[XTemplate ipBuilding RolloverTitle]] "Salvage"),
			'RolloverHintGamepad', T(7657, --[[XTemplate ipBuilding RolloverHintGamepad]] "<ButtonY> Activate"),
			'Id', "idSalvage",
			'OnContextUpdate', function (self, context, ...)
				local refund = context:GetRefundResources() or empty_table
				local rollover = T(7822, "Destroy this building.")
				if IsKindOf(context, "LandscapeConstructionSiteBase") then
					self:SetRolloverTitle(T(12171, "Cancel Landscaping"))
					rollover = T(12172, "Cancel this landscaping project. The terrain will remain in its current state")
				end
				if #refund > 0 then
					rollover = rollover .. "<newline><newline>" .. T(7823, "<UIRefundRes> will be refunded upon salvage.")
				end
				self:SetRolloverText(rollover)
				context:ToggleDemolish_Update(self)
			end,
			'OnPressParam', "ToggleDemolish",
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
------------------- Salvage


			PlaceObj("XTemplateTemplate", {
				"__template", "sectionCheats",
			}),
		}),
	})

	-- add HiddenX cat for Hidden items
	local bc = BuildCategories
	if ChoGGi.UserSettings.Building_hide_from_build_menu and not table_find(bc, "id", "HiddenX") then
		bc[#bc+1] = {
			id = "HiddenX",
			name = T(1000155--[[Hidden]]),
			image = "UI/Icons/bmc_placeholder.tga",
			highlight = "UI/Icons/bmc_placeholder_shine.tga",
		}
	end

	if ChoGGi.UserSettings.FlushLog then
		FlushLogFile()
	end
end

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	if ChoGGi.UserSettings.FlushLog then
		FlushLogFile()
	end
end

function OnMsg.ModsReloaded()
	local ChoGGi = ChoGGi
	local UserSettings = ChoGGi.UserSettings

	-- added this here, as it's early enough to load during the New Game Menu
	local Actions = ChoGGi.Temp.Actions
	if UserSettings.DisableECM then
		-- remove all my actions from ecm
		for i = #Actions, 1, -1 do
			local a = Actions[i]
			-- if it's a . than we haven't updated it yet
			if a.ActionId:sub(1, 1) == "." then
				table_remove(Actions, i)
			end
		end
	else
		local c = #Actions

		c = c + 1
		Actions[c] = {
			ActionMenubar = "ECM.Debug",
			ActionName = Strings[302535920001074--[[Ged Presets]]],
			ActionId = ".Ged Presets",
			ActionIcon = "CommonAssets/UI/Menu/folder.tga",
			OnActionEffect = "popup",
		}

		-- add preset menu items
		local Presets = Presets
		ClassDescendantsList("Preset", function(name, class)
			if not name:find("ChoGGi") then
				c = c + 1
				Actions[c] = {
					ActionMenubar = "ECM.Debug.Ged Presets",
					ActionName = name,
					ActionId = "." .. name,
					ActionIcon = "CommonAssets/UI/Menu/SelectByClassName.tga",
					RolloverText = Strings[302535920000733--[[Open a preset in the editor.]]],
					OnAction = function()
						OpenGedApp(class.GedEditor, Presets[name], {
							PresetClass = name,
							SingleFile = class.SingleFile
						})
					end,
				}
			end
		end)

		-- add the defaults we skipped to my actions
		for i = 1, c do
			local a = Actions[i]
			-- if it's a . than we haven't updated it yet
			if a.ActionId:sub(1, 1) == "." then
				a.ActionTranslate = false
				a.replace_matching_id = true
				a.ActionId = (a.ActionMenubar ~= "" and a.ActionMenubar or "ECM") .. a.ActionId
				a.ChoGGi_ECM = true
			end
		end

		-- show console log history
		if UserSettings.ConsoleToggleHistory then
			ShowConsoleLog(true)
		end

		if UserSettings.ConsoleHistoryWin then
			ChoGGi.ComFuncs.ShowConsoleLogWin(true)
		end

		-- dim that console bg
		if UserSettings.ConsoleDim then
			config.ConsoleDim = 1
		end

		-- build console buttons
		local dlgConsole = dlgConsole
		if dlgConsole and not dlgConsole.ChoGGi_MenuAdded then
			local edit = dlgConsole.idEdit

			-- add a context menu
			edit.OnKillFocus = g_Classes.ChoGGi_XInputContextMenu.OnKillFocus
			edit.OnMouseButtonDown = g_Classes.ChoGGi_XInputContextMenu.OnMouseButtonDown
			edit.RetContextList = g_Classes.ChoGGi_XInputContextMenu.RetContextList

			-- removes comments from code, and adds a space to each newline, so pasting multi line works
			local XEditEditOperation = XEdit.EditOperation
			local StripComments = ChoGGi.ComFuncs.StripComments
			function edit:EditOperation(insert_text, is_undo_redo, cursor_to_text_start, ...)
				if type(insert_text) == "string" then
					insert_text = StripComments(insert_text)
					insert_text = insert_text:gsub("\n", " \n")
				end
				return XEditEditOperation(self, insert_text, is_undo_redo, cursor_to_text_start, ...)
			end

			edit.RolloverTemplate = "Rollover"
			edit.RolloverTitle = Strings[302535920001073--[[Console]]] .. " " .. T(487939677892--[[Help]])
			-- add tooltip
			edit.RolloverText = Strings[302535920001440--[["~obj opens object in examine dlg.
~~obj opens object's attachments in examine dlg.

&handle examines object with that handle.

@GetMissionSponsor prints file name and line number of function.

@@EntityData prints type(EntityData).

%""UI/Vignette.tga"" opens image in image viewer.

$123 or $EffectDeposit.display_name prints translated string.

""*r Sleep(1000) print(""sleeping"")"" to wrap in a real time thread (or *g or *m).

!UICity.labels.TerrainDeposit[1] move camera and select obj.

s = SelectedObj, c() = GetTerrainCursor(), restart() = quit(""restart"")"]]]
			edit.Hint = Strings[302535920001439--[["~obj, @func, @@type, $id, %image, *r/*g/*m threads. Hover mouse for more info."]]]

			dlgConsole.ChoGGi_MenuAdded = true
			-- and buttons
			ChoGGi.ConsoleFuncs.ConsoleControls(dlgConsole)
		end

		-- show cheat pane in selection panel
		if UserSettings.InfopanelCheats then
			config.BuildingInfopanelCheats = true
		end

		-- remove some uselessish Cheats to clear up space
		if UserSettings.CleanupCheatsInfoPane then
			ChoGGi.InfoFuncs.InfopanelCheatsCleanup()
		end

		-- cheats menu fun
		local XShortcutsTarget = XShortcutsTarget
		if XShortcutsTarget then

			for i = 1, #XShortcutsTarget do
				local item = XShortcutsTarget[i]
				-- yeah... i don't need the menu taking up the whole width of my screen
				item:SetHAlign("left")

				-- add some ids for easier selection later on
				if item:IsKindOf("XMenuBar") then
					XShortcutsTarget.idMenuBar = item
				elseif item:IsKindOf("XWindow") then
					XShortcutsTarget.idToolbar = item
					break
				end
			end

			-- add a hint about rightclicking
			if UserSettings.EnableToolTips then
				local toolbar = XShortcutsTarget.idMenuBar
				toolbar:SetRolloverTemplate("Rollover")
				toolbar:SetRolloverTitle(T(126095410863--[[Info]]))
				toolbar:SetRolloverText(Strings[302535920000503--[[Right-click an item/submenu to add/remove it from the quickbar.]]])
				toolbar:SetRolloverHint(Strings[302535920001441--[["<left_click> Activate MenuItem <right_click> Add/Remove"]]])
			end

			-- always show menu
			XShortcutsTarget:SetVisible(true)
			if UserSettings.KeepCheatsMenuPosition then
				XShortcutsTarget:SetPos(UserSettings.KeepCheatsMenuPosition)
			end

			-- that info text about right-clicking expands the menu instead of just hiding or something
			for i = 1, #XShortcutsTarget.idToolbar do
				if XShortcutsTarget.idToolbar[i]:IsKindOf("XText") then
					XShortcutsTarget.idToolbar[i]:delete()
				end
			end

			-- add a little spacer to the top of cheats menu you can drag around
			ChoGGi.ComFuncs.DraggableCheatsMenu(
				UserSettings.DraggableCheatsMenu
			)
		end

	end -- DisableECM

	local SponsorBuildingLimits = UserSettings.SponsorBuildingLimits
	local Building_hide_from_build_menu = UserSettings.Building_hide_from_build_menu
	local Building_wonder = UserSettings.Building_wonder

	local BuildingTechRequirements = BuildingTechRequirements
	local BuildingTemplates = BuildingTemplates
	for id, bld in pairs(BuildingTemplates) do

		-- remove sponsor limits on buildings
		if SponsorBuildingLimits then
			-- set each status to false if it isn't
			for i = 1, 3 do
				local str = "sponsor_status" .. i
				local status = bld[str]
				if status ~= false then
					bld["sponsor_status" .. i .. "_ChoGGi_orig"] = status
					bld[str] = false
				end
			end

			-- and this bugger screws me over on GetBuildingTechsStatus (probably need to update if they add sponsor locked buildable rockets)
			local name = id
			if name:sub(1, 2) == "RC" and name:sub(-8) == "Building" then
				name = name:gsub("Building", "")
			end
			local reqs = BuildingTechRequirements[id]
			local idx = table_find(reqs, "check_supply", name)
			if idx then
				table_remove(reqs, idx)
			end
		end

		-- make hidden buildings visible
		if Building_hide_from_build_menu then
			if bld.id ~= "LifesupportSwitch" and bld.id ~= "ElectricitySwitch" then
				bld.hide_from_build_menu_ChoGGi = bld.hide_from_build_menu
				bld.hide_from_build_menu = false
			end
			if bld.group == "Hidden" and bld.id ~= "RocketLandingSite" and bld.id ~= "ForeignTradeRocket" then
				bld.build_category = "HiddenX"
			end
		end

		-- wonder building limit
		if Building_wonder then
			bld.wonder = nil
		end

	end

	-- unlock buildings that cannot rotate
	if UserSettings.RotateDuringPlacement then
		local buildings = ClassTemplates.Building
		for _, bld in pairs(buildings) do
			if bld.can_rotate_during_placement == false then
				bld.can_rotate_during_placement_ChoGGi_orig = true
				bld.can_rotate_during_placement = true
			end
		end
	end
end -- ModsReloaded

function OnMsg.PersistPostLoad()
	if ChoGGi.UserSettings.FixMissingModBuildings then
		-- [LUA ERROR] Mars/Lua/Construction.lua:860: attempt to index a boolean value (global 'ControllerMarkers')
		if type(ControllerMarkers) == "boolean" then
			ControllerMarkers = {}
		end

		-- [LUA ERROR] Mars/Lua/Heat.lua:65: attempt to call a nil value (method 'ApplyForm')
		local s_Heaters = s_Heaters or {}
		for obj in pairs(s_Heaters) do
			if obj:IsKindOf("UnpersistedMissingClass") then
				s_Heaters[obj] = nil
			end
		end

		-- if there's a missing id print/return a warning
		local printit = ChoGGi.UserSettings.FixMissingModBuildingsLog
		-- GetFreeSpace, GetFreeLivingSpace, GetFreeWorkplaces, GetFreeWorkplacesAround
		local labels = UICity.labels or empty_table
		for label_id, label in pairs(labels) do
			if label_id ~= "Consts" then
				for i = #label, 1, -1 do
					local obj = label[i]
					if obj:IsKindOf("UnpersistedMissingClass") then
						if printit then
							print(Strings[302535920001401--[["Removed missing mod building from %s: %s, entity: %s, handle: %s"]]]:format(label_id, RetName(obj), obj:GetEntity(), obj.handle))
						end
						obj:delete()
						table_remove(label, i)
					end
				end
			end
		end

	end -- if FixMissingModBuildings
end

-- for instant build
function OnMsg.BuildingPlaced(obj)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end --OnMsg

do -- ConstructionSitePlaced/ConstructionPrefabPlaced
	local function SitePlaced(site)
		if site:IsKindOf("Building") then
			ChoGGi.Temp.LastPlacedObject = site
		end

		-- use a delay, so domes don't screw up
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			-- some issue bypass?
			if ChoGGi.UserSettings.Building_instant_build and (not site.construction_group
					or site.construction_group and site.construction_group[1] == site) then
				site:Complete("quick_build")
			end
			-- spire needs a pointy end
			if site.building_class_proto:IsKindOf("Temple") then
				local frame = site:GetAttaches("SpireFrame")
				if not frame then
					frame = ChoGGi.ComFuncs.AttachSpireFrame(site)
					frame:SetGameFlags(const.gofUnderConstruction)
				end
				ChoGGi.ComFuncs.AttachSpireFrameOffset(frame)
			end
		end)
	end --OnMsg

	OnMsg.ConstructionSitePlaced = SitePlaced
	OnMsg.ConstructionPrefabPlaced = SitePlaced
end -- do

-- make sure they use with our new values
function OnMsg.ChoGGi_SpawnedProducer(obj, prod_type)
	local prod = ChoGGi.UserSettings.BuildingSettings[obj.template_name]
	if prod and prod.production then
		obj[prod_type] = prod.production
	end
end

function OnMsg.ChoGGi_SpawnedDrone(obj)
	local UserSettings = ChoGGi.UserSettings
	if UserSettings.SpeedDrone then
		if obj:IsKindOf("FlyingDrone") then
			if UserSettings.SpeedWaspDrone then
				obj:SetBase("move_speed", UserSettings.SpeedWaspDrone)
			end
		else
			obj:SetBase("move_speed", UserSettings.SpeedDrone)
		end
	end

	if UserSettings.DroneBatteryMax then
		obj.battery_max = UserSettings.DroneBatteryMax
	end

end


-- some upgrades change amounts, so reset them to ours
function OnMsg.BuildingUpgraded(obj)
	if obj:IsKindOf("ElectricityProducer") then
		Msg("ChoGGi_SpawnedProducer", obj, "electricity_production")
	elseif obj:IsKindOf("AirProducer") then
		Msg("ChoGGi_SpawnedProducer", obj, "air_production")
	elseif obj:IsKindOf("WaterProducer") then
		Msg("ChoGGi_SpawnedProducer", obj, "water_production")
	elseif obj:IsKindOf("SingleResourceProducer") then
		Msg("ChoGGi_SpawnedProducer", obj, "production_per_day")
--~ 	else
--~ 		Msg("ChoGGi_SpawnedBaseBuilding", obj)
	end
	Msg("ChoGGi_SpawnedBaseBuilding", obj)
end

-- :GameInit() (Msg.BuildingInit only does Building, not BaseBuilding)
function OnMsg.ChoGGi_SpawnedBaseBuilding(obj)
	local UserSettings = ChoGGi.UserSettings

	if obj:IsKindOf("ConstructionSite")
			or obj:IsKindOf("ConstructionSiteWithHeightSurfaces") then
		return
	end

	-- not working code from when trying to have passages placed in entrances
--~ 	-- if it's a fancy dome then we allow building in the removed entrances
--~ 	if obj:IsKindOf("Dome") then
--~ 		local id_start, id_end = obj:GetAllSpots(obj:GetState())
--~ 		for i = id_start, id_end do
--~ 			if obj:GetSpotName(i) == "Entrance" or obj:GetSpotAnnotation(i) == "att, DomeRoad_04, show" then
--~ 				print(111)
--~ 			end
--~ 		end
--~ 	end

	if UserSettings.CommandCenterMaxRadius and obj:IsKindOf("DroneHub") then
		-- we set it from the func itself
		obj:SetWorkRadius()

	elseif UserSettings.ServiceWorkplaceFoodStorage
			and (obj:IsKindOf("Grocery") or obj:IsKindOf("Diner")) then
		-- for some reason InitConsumptionRequest always adds 5 to it
		local storedv = UserSettings.ServiceWorkplaceFoodStorage - (5 * const.ResourceScale)
		obj.consumption_stored_resources = storedv
		obj.consumption_max_storage = UserSettings.ServiceWorkplaceFoodStorage

	elseif UserSettings.RocketMaxExportAmount and obj:IsKindOf("SupplyRocket") then
		obj.max_export_storage = UserSettings.RocketMaxExportAmount

	elseif obj:IsKindOf("BaseRover") then
		if UserSettings.RCTransportStorageCapacity and obj:IsKindOf("RCTransport") then
			obj.max_shared_storage = UserSettings.RCTransportStorageCapacity
		elseif UserSettings.RCRoverMaxRadius and obj:IsKindOf("RCRover") then
			-- I override the func so no need to send a value here
			obj:SetWorkRadius()
		end
		-- applied to all rovers
		if UserSettings.SpeedRC then
			obj:SetBase("move_speed", UserSettings.SpeedRC)
		end

	elseif obj:IsKindOf("CargoShuttle") then
		if UserSettings.StorageShuttle then
			obj.max_shared_storage = UserSettings.StorageShuttle
		end
		if UserSettings.SpeedShuttle then
			obj:SetBase("move_speed", UserSettings.SpeedShuttle)
		end

	elseif UserSettings.StorageUniversalDepot and obj:GetEntity() == "StorageDepot"
			and obj:IsKindOf("UniversalStorageDepot") then
		obj.max_storage_per_resource = UserSettings.StorageUniversalDepot

	elseif UserSettings.StorageMechanizedDepot and obj:IsKindOf("MechanizedDepot") then
		obj.max_storage_per_resource = UserSettings.StorageMechanizedDepot

	elseif UserSettings.StorageWasteDepot and obj:IsKindOf("WasteRockDumpSite") then
		obj.max_amount_WasteRock = UserSettings.StorageWasteDepot
		if obj:GetStoredAmount() < 0 then
			obj:CheatEmpty()
			obj:CheatFill()
		end

	elseif UserSettings.ShuttleHubFuelStorage and obj:IsKindOf("ShuttleHub") then
		obj.consumption_max_storage = UserSettings.ShuttleHubFuelStorage

	elseif UserSettings.SchoolTrainAll and obj:IsKindOf("School") then
		local list = ChoGGi.Tables.PositiveTraits
		for i = 1, #list do
			obj:SetTrait(i, list[i])
		end

	elseif UserSettings.SanatoriumCureAll and obj:IsKindOf("Sanatorium") then
		local list = ChoGGi.Tables.NegativeTraits
		for i = 1, #list do
			obj:SetTrait(i, list[i])
		end

	elseif obj:IsKindOf("Temple") then
		CreateRealTimeThread(function()
			local frame = obj:GetAttaches("SpireFrame")
			if not frame then
				-- spire needs a pointy end
				frame = ChoGGi.ComFuncs.AttachSpireFrame(obj)
				for i = 1, 4 do
					frame:SetColorizationMaterial(i, obj:GetColorizationMaterial(i))
				end
			end
			ChoGGi.ComFuncs.AttachSpireFrameOffset(frame)
		end)

	elseif UserSettings.StorageMechanizedDepotsTemp
			and obj:IsKindOf("ResourceStockpileLR")
			and obj.parent:IsKindOf("MechanizedDepot") then
		-- attached temporary resource depots
		ChoGGi.ComFuncs.SetMechanizedDepotTempAmount(obj.parent)
	end

	-- if an inside building is placed outside of dome, attach it to nearest dome (if there is one)
	if obj:GetDefaultPropertyValue("dome_required") then
		-- a slight delay is needed
		CreateRealTimeThread(function()
			if not IsValid(obj.parent_dome) then
				-- we use this to update the parent_dome (if there's a working/closer one)
				UICity:AddToLabel("ChoGGi_InsideForcedOutDome", obj)

				AttachToNearestDome(obj)
			end
		end)
	end

	if UserSettings.StorageOtherDepot then
		if (obj:GetEntity() ~= "StorageDepot"
				and (obj:IsKindOf("UniversalStorageDepot")) or obj:IsKindOf("MysteryDepot")) then
			obj.max_storage_per_resource = UserSettings.StorageOtherDepot
		elseif UserSettings.StorageOtherDepot and obj:IsKindOf("BlackCubeDumpSite") then
			obj.max_amount_BlackCube = UserSettings.StorageOtherDepot
		end
	end

	if UserSettings.InsideBuildingsNoMaintenance and obj:IsKindOf("Constructable") then
		obj.ChoGGi_InsideBuildingsNoMaintenance = true
		obj.maintenance_build_up_per_hr = -10000
	end

	if UserSettings.RemoveMaintenanceBuildUp and obj:IsKindOf("RequiresMaintenance") then
		obj.ChoGGi_RemoveMaintenanceBuildUp = true
		obj.maintenance_build_up_per_hr = -10000
	end

	-- saved building settings
	local bs = UserSettings.BuildingSettings[obj.template_name]
	if type(bs) == "table" then
		if next(bs) then
			-- saved settings for capacity, shuttles
			if bs.capacity then
				if obj.base_capacity then
					obj.capacity = bs.capacity
				elseif obj.base_air_capacity then
					obj.air_capacity = bs.capacity
				elseif obj.base_water_capacity then
					obj.water_capacity = bs.capacity
				elseif obj.base_max_shuttles then
					obj.max_shuttles = bs.capacity
				end
			end
			-- max visitors
			if bs.visitors and obj.base_max_visitors then
				obj.max_visitors = bs.visitors
			end
			-- max workers
			if bs.workers then
				obj.max_workers = bs.workers
			end
			-- no power needed
			if bs.nopower then
				ChoGGi.ComFuncs.RemoveBuildingElecConsump(obj)
			end
			if bs.noair then
				ChoGGi.ComFuncs.RemoveBuildingAirConsump(obj)
			end
			if bs.nowater then
				ChoGGi.ComFuncs.RemoveBuildingWaterConsump(obj)
			end
			-- large protect_range for defence buildings
			if bs.protect_range then
				obj.protect_range = bs.protect_range
				obj.shoot_range = bs.protect_range * guim
			end
			-- fully auto building
			if bs.auto_performance then
--~ 				obj.max_workers = 0
				obj.automation = 1
				obj.auto_performance = bs.auto_performance
			end
			-- legacy setting
			-- changed saving as performance to auto_performance, get rid of this in a few months
			if bs.performance then
--~ 				obj.max_workers = 0
				obj.automation = 1
				obj.auto_performance = bs.performance
			end
			-- just perf boost
			if bs.performance_notauto then
				obj.performance = bs.performance_notauto
			end
			-- space ele export amount
			if bs.max_export_storage then
				obj.max_export_storage = bs.max_export_storage
			end
			-- space ele import amount
			if bs.cargo_capacity then
				obj.cargo_capacity = bs.cargo_capacity
			end
			-- service comforts
			if bs.service_stats and next(bs.service_stats) then
				ChoGGi.ComFuncs.UpdateServiceComfortBld(obj, bs.service_stats)
			end
			-- training points
			if bs.evaluation_points then
				obj.evaluation_points = bs.evaluation_points
			end
			-- need to wait a sec for the grid objects to be created
			CreateRealTimeThread(function()
				-- dis/charge rates
				local prod_type = obj.GetStoredAir and "air"
					or obj.GetStoredWater and "water"
					or obj.GetStoredPower and "electricity"
				while not obj[prod_type] do
					Sleep(100)
				end
				if bs.charge then
					obj[prod_type].max_charge = bs.charge
					obj["max_" .. prod_type .. "_charge"] = bs.charge
				end
				if bs.discharge then
					obj[prod_type].max_discharge = bs.discharge
					obj["max_" .. prod_type .. "_discharge"] = bs.discharge
				end
			end)

		else
			-- empty table so remove
			UserSettings.BuildingSettings[obj.template_name] = nil
		end
	end
end --OnMsg

do -- ColonistCreated
	local function ColonistCreated(obj, skip)
		local UserSettings = ChoGGi.UserSettings

		if UserSettings.NewColonistGender then
			ChoGGi.ComFuncs.ColonistUpdateGender(obj, UserSettings.NewColonistGender)
		end
		if UserSettings.NewColonistAge then
			ChoGGi.ComFuncs.ColonistUpdateAge(obj, UserSettings.NewColonistAge)
		end
		-- children don't have spec models so they get black cube
		if UserSettings.NewColonistSpecialization and not skip then
			ChoGGi.ComFuncs.ColonistUpdateSpecialization(obj, UserSettings.NewColonistSpecialization)
		end
		if UserSettings.NewColonistRace then
			ChoGGi.ComFuncs.ColonistUpdateRace(obj, UserSettings.NewColonistRace)
		end
		if UserSettings.NewColonistTraits then
			ChoGGi.ComFuncs.ColonistUpdateTraits(obj, true, UserSettings.NewColonistTraits)
		end
		if UserSettings.SpeedColonist then
			obj:SetBase("move_speed", UserSettings.SpeedColonist)
		end
		if UserSettings.DeathAgeColonist then
			obj.death_age = UserSettings.DeathAgeColonist
		end

	end

	OnMsg.ColonistArrived = ColonistCreated
	OnMsg.ColonistBorn = ColonistCreated
end -- do

function OnMsg.SelectionAdded(obj)
	-- update selection shortcut
	s = obj
	-- update last placed (or selected)
	if obj:IsKindOf("Building") then
		ChoGGi.Temp.LastPlacedObject = obj
	end
end

-- remove selected obj when nothing selected
function OnMsg.SelectionRemoved()
	s = false
end

function OnMsg.ChangeMapDone(map)
	-- first time run info
	if map == "PreGame" and ChoGGi.UserSettings.FirstRun ~= false then
	print("ChangeMapDone")
		ChoGGi.UserSettings.FirstRun = false
		DestroyConsoleLog()
		ChoGGi.SettingFuncs.WriteSettings()

		ChoGGi.ComFuncs.MsgWait(
			Strings[302535920000001--[["F2 to toggle Cheats Menu (Ctrl-F2 for Cheats Pane), and F9 to clear console log text.
If this isn't a new install, then see Menu>Help>Changelog and search for ""To import your old settings""."]]]
				.. "\n\n" .. Strings[302535920000030--[["To show the console log text; press Tilde or Enter and click the ""%s"" button then make sure ""%s"" is checked."]]]:format(Strings[302535920001308--[[Settings]]], Strings[302535920001112--[[Console Log]]]),
			Translate(10126--[[Installed Mods]]) .. ": " .. Strings[302535920000000--[[Expanded Cheat Menu]]],
			ChoGGi.mod_path .. "Preview.png",
			Strings[302535920001465--[[Stop talking and start cheating!]]]
		)
	end
end

-- const.DayDuration is 720 000 ticks (GameTime)
function OnMsg.NewDay() -- NewSol...
--~ 	Msg("NewSol")
	local ChoGGi = ChoGGi

	-- remove any closed examine dialogs from the list
	local ChoGGi_dlgs_examine = ChoGGi_dlgs_examine or empty_table
	for obj, dlg in pairs(ChoGGi_dlgs_examine) do
		if not IsValidXWin(dlg) then
			ChoGGi_dlgs_examine[obj] = nil
		end
	end

	-- sorts cc list by dist to building
	if ChoGGi.UserSettings.SortCommandCenterDist then
		local objs = UICity.labels.Building or ""
		for i = 1, #objs do
			local obj = objs[i]
			-- no sense in doing it with only one center
			if #obj.command_centers > 1 then
				table_sort(obj.command_centers, function(a, b)
					return obj:GetVisualDist(a) < obj:GetVisualDist(b)
				end)
			end
		end
	end

	-- dump log to disk
	if ChoGGi.UserSettings.FlushLog then
		FlushLogFile()
	end

	-- loop through and remove any old popups
	local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin
	local popups = ChoGGi.Temp.MsgPopups or ""
	for i = #popups, 1, -1 do
		if not IsValidXWin(popups[i]) then
			table_remove(popups, i)
		end
	end

	local objs = UICity.labels.ChoGGi_InsideForcedOutDome or ""
	for i = #objs, 1, -1 do
		local obj = objs[i]
		-- got removed or something
		if not IsValid(obj) then
			UICity:RemoveFromLabel("ChoGGi_InsideForcedOutDome", obj)
		else
			-- check if there's a nearer dome
			AttachToNearestDome(obj)
		end
	end

end

-- const.HourDuration is 30 000 ticks (GameTime)
function OnMsg.NewHour()
	local UserSettings = ChoGGi.UserSettings

	-- make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
	if UserSettings.DroneResourceCarryAmountFix then
		local labels = UICity.labels
		local FuckingDrones = ChoGGi.ComFuncs.FuckingDrones

		-- Hey. Do I preach at you when you're lying stoned in the gutter? No!
		local prods = labels.ResourceProducer or ""
		for i = 1, #prods do
			local prod = prods[i]
			-- most are fine with GetProducerObj, but some like water extractor don't have one
			local obj = prod:GetProducerObj() or prod
			local func = obj.GetStoredAmount and "GetStoredAmount" or obj.GetAmountStored and "GetAmountStored"
			if obj[func](obj) > 1000 then
				FuckingDrones(obj)
			end
			obj = prod.wasterock_producer
			if obj and obj:GetStoredAmount() > 1000 then
				FuckingDrones(obj, "single")
			end
		end

		prods = labels.BlackCubeStockpiles or ""
		for i = 1, #prods do
			local obj = prods[i]
			if obj:GetStoredAmount() > 1000 then
				FuckingDrones(obj)
			end
		end

	end

	-- pathing? pathing in domes works great... watch out for that invisible wall!
	-- update: seems like this is an issue from one of those smarter work ai mods
	if UserSettings.ColonistsStuckOutsideServiceBuildings then
		ChoGGi.ComFuncs.ResetHumanCentipedes()
	end

	-- some types of crashing won't allow SM to gracefully close and leave a log/minidump as the devs envisioned... No surprise to anyone who's ever done any sort of debugging before.
	if UserSettings.FlushLogConstantly then
		FlushLogFile()
	end
end

-- const.MinuteDuration is 500 ticks (GameTime)
--~ OnMsg.NewMinute = FlushLogFile
--~ function OnMsg.NewMinute()
--~ 	FlushLogFile()
--~ end

function OnMsg.AfterLightmodelChange()
	if ChoGGi.UserSettings.Lightmodel then
		SetLightmodelOverride(1, ChoGGi.UserSettings.Lightmodel)
	end
end

function OnMsg.ResearchQueueChange(city, tech_id)
	if ChoGGi.UserSettings.InstantResearch then
		CreateRealTimeThread(function()
			Sleep(100)
			GrantResearchPoints(city.tech_status[tech_id].cost)
			-- updates the researchdlg by toggling it.
			if GetDialog("ResearchDlg") then
				CloseDialog("ResearchDlg")
				OpenDialog("ResearchDlg")
			end
		end)
	end
end

-- if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
	if ChoGGi.UserSettings.ShowMysteryMsgs then
		MsgPopup(
			ChoGGi.Tables.Mystery[UICity.mystery_id].name .. ": "
				.. Strings[302535920000729--[[You've started a mystery!]]],
			T(3486, "Mystery")
		)
	end
end
function OnMsg.MysteryChosen()
	if ChoGGi.UserSettings.ShowMysteryMsgs then
		MsgPopup(
			ChoGGi.Tables.Mystery[UICity.mystery_id].name .. ": "
				.. Strings[302535920000730--[[You've chosen a mystery!]]],
			T(3486, "Mystery")
		)
	end
end
function OnMsg.MysteryEnd(outcome)
	if ChoGGi.UserSettings.ShowMysteryMsgs then
		MsgPopup(
			ChoGGi.Tables.Mystery[UICity.mystery_id].name .. ": "
				.. tostring(outcome),
			T(3486, "Mystery")
		)
	end
end

-- fired when cheats menu is toggled
function OnMsg.DevMenuVisible(visible)
	if visible then
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			ChoGGi.ComFuncs.SetCheatsMenuPos()
		end)
	end
end

local once_ApplicationQuit
function OnMsg.ApplicationQuit()
	if once_ApplicationQuit then
		return
	end
	once_ApplicationQuit = true

	-- from GedSocket.lua
	local desktop = terminal.desktop
	for i = #desktop, 1, -1 do
		local d = desktop[i]
		if d:IsKindOf("GedApp") then
			d:Close()
		end
	end

	local ChoGGi = ChoGGi

	-- resetting settings?
	if testing or ChoGGi.Temp.ResetECMSettings then
		return
	end

	-- console window settings
	local dlg = dlgChoGGi_DlgConsoleLogWin
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

function OnMsg.ChoGGi_TogglePinnableObject(obj)
	CreateRealTimeThread(function()
		WaitMsg("OnRender")
		if not (obj:IsPinned() and obj:CanBeUnpinned()) then
			return
		end
		local UnpinObjects = ChoGGi.UserSettings.UnpinObjects
		if type(UnpinObjects) == "table" and next(UnpinObjects) then
			if UnpinObjects[obj.class] then
				obj:TogglePin(true)
			end
		end
	end)
end

-- hidden milestones
function OnMsg.ChoGGi_DaddysLittleHitler()
	local MilestoneCompleted = MilestoneCompleted
	PlaceObj("Milestone", {
		base_score = 0,
		display_name = Strings[302535920000731--[[Deutsche Gesellschaft für Rassenhygiene]]],
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
		display_name = Strings[302535920000732--[[Childkiller (You evil, evil person.)]]],
		group = "Default",
		id = "Childkiller"
	})
	if not MilestoneCompleted.Childkiller then
		MilestoneCompleted.Childkiller = 479000000
	end
end

-- show how long loading takes
function OnMsg.ChangeMap()
	if testing or ChoGGi.UserSettings.ShowStartupTicks then
		ChoGGi.Temp.StartupTicks = GetPreciseTicks()
	end
end

do -- LoadGame/CityStart
--~ 	local function SetMissionBonuses(UserSettings, Presets, preset, which, Func)
--~ 		local list = Presets[preset].Default or ""
--~ 		for i = 1, #list do
--~ 			local id = list[i].id
--~ 			if UserSettings[which .. id] then
--~ 				Func(id)
--~ 			end
--~ 		end
--~ 	end
	local function UpdateLabelSpeed(labels, speed, cls)
		local objs = labels[cls] or ""
		for i = 1, #objs do
			objs[i]:SetBase("move_speed", speed)
		end
	end

	-- saved game is loaded
	function OnMsg.LoadGame()
		Msg("ChoGGi_Loaded", "Load")
	end
	-- new game is loaded (this is before the map is loaded)
	function OnMsg.CityStart()
		-- reset my mystery msgs to hidden
		ChoGGi.UserSettings.ShowMysteryMsgs = nil
		Msg("ChoGGi_Loaded", "New")
	end

	function OnMsg.ChoGGi_Loaded(game_type)
		local UICity = UICity
		local ChoGGi = ChoGGi

		-- a place to store per-game values... that i'll use one of these days (tm)
		if not UICity.ChoGGi then
			UICity.ChoGGi = {}
		end

		local UserSettings = ChoGGi.UserSettings
		local g_Classes = g_Classes
		local const = const
		local BuildMenuPrerequisiteOverrides = BuildMenuPrerequisiteOverrides
		local hr = hr
		local labels = UICity.labels
		local sponsor = GetMissionSponsor()

		-- late enough that I can set g_Consts.
		ChoGGi.SettingFuncs.SetConstsToSaved()

		-- any saved Consts settings (from the Consts menu)
		local SetConstsG = ChoGGi.ComFuncs.SetConstsG
		local ChoGGi_Consts = ChoGGi.UserSettings.Consts
		for key, value in pairs(ChoGGi_Consts) do
			SetConstsG(key, value)
		end
		-- think about removing other Consts from other menus

		-- needed for DroneResourceCarryAmount (set in Consts)
		UpdateDroneResourceUnits()

		-- clear out Temp settings
		ChoGGi.Temp.UnitPathingHandles = {}

		-- not needed, removing from old saves, so people don't notice them
		labels.ChoGGi_GridElements = nil
		labels.ChoGGi_LifeSupportGridElement = nil
		labels.ChoGGi_ElectricityGridElement = nil
		-- re-binding is now an in-game thing, so keys are just defaults
		UserSettings.KeyBindings = nil

--~ 		SetMissionBonuses(UserSettings, Presets, "MissionSponsorPreset", "Sponsor", ChoGGi.ComFuncs.SetSponsorBonuses)
--~ 		SetMissionBonuses(UserSettings, Presets, "CommanderProfilePreset", "Commander", ChoGGi.ComFuncs.SetCommanderBonuses)




---------------------do the above stuff before the below stuff



		-- update pod price
		if type(UserSettings.PodPrice) == "number" then
			sponsor.pod_price = UserSettings.PodPrice
		end
		-- use ark pass pod with any sponsor
		if UserSettings.PassengerArkPod then
			sponsor.passenger_pod_class = "ArkPod"
		end
		-- allow camera closer to edge
		if UserSettings.MapEdgeLimit then
			hr.CameraRTSBorderAtMinZoom = 1000
			hr.CameraRTSBorderAtMaxZoom = 1000
		end
		-- update existing speeds
		if UserSettings.SpeedColonist then
			UpdateLabelSpeed(labels, UserSettings.SpeedColonist, "Colonist")
		end
		if UserSettings.SpeedRC then
			UpdateLabelSpeed(labels, UserSettings.SpeedRC, "Rover")
		end
		if UserSettings.SpeedShuttle then
			local speed = UserSettings.SpeedShuttle
			local objs = labels.CargoShuttle or ""
			for i = 1, #objs do
				objs[i]:SetBase("move_speed", speed)
			end
		end
		-- i figure looping through it twice is better then some complicated if else
		if UserSettings.SpeedWaspDrone then
			local speed = UserSettings.SpeedWaspDrone
			local objs = labels.Drone or ""
			for i = 1, #objs do
				local obj = objs[i]
				if obj:IsKindOf("FlyingDrone") then
					obj:SetBase("move_speed", speed)
				end
			end
		end
		if UserSettings.SpeedDrone then
			local speed = UserSettings.SpeedDrone
			local objs = labels.Drone or ""
			for i = 1, #objs do
				local obj = objs[i]
				if not obj:IsKindOf("FlyingDrone") then
					obj:SetBase("move_speed", speed)
				end
			end
		end

		if UserSettings.DroneResourceCarryAmount then
			if UserSettings.DroneResourceCarryAmount == 1 then
				UserSettings.DroneResourceCarryAmountFix = nil
			else
				-- fucking drones, pick yer shit up
				UserSettings.DroneResourceCarryAmountFix = true
			end
		end

		if type(UserSettings.UnpinObjects) == "table" and #UserSettings.UnpinObjects > 0 then
			local new = {}
			for i = 1, #UserSettings.UnpinObjects do
				new[UserSettings.UnpinObjects[i]] = true
			end
			UserSettings.UnpinObjects = new
			ChoGGi.Temp.WriteSettings = true
		end

		if UserSettings.FrameCounterLocation then
			hr.FpsCounterPos = UserSettings.FrameCounterLocation
		end

		if UserSettings.mediumGameSpeed then
			const.mediumGameSpeed = UserSettings.mediumGameSpeed
		end
		if UserSettings.fastGameSpeed then
			const.fastGameSpeed = UserSettings.fastGameSpeed
		end

		-- make hidden buildings visible
		if UserSettings.Building_hide_from_build_menu then
			local bmpo = BuildMenuPrerequisiteOverrides
			for key, value in pairs(bmpo) do
				if value == "hide" then
					bmpo[key] = true
				end
			end
			bmpo.StorageMysteryResource = true
			bmpo.MechanizedDepotMysteryResource = true
		end

		-- show all traits in trainable popup
		if UserSettings.SanatoriumSchoolShowAllTraits then
			g_SchoolTraits = ChoGGi.Tables.PositiveTraits
			g_SanatoriumTraits = ChoGGi.Tables.NegativeTraits
		end

		-- all yours XxUnkn0wnxX
		if not blacklist then
			local autoexec = ChoGGi.scripts .. "/autoexec.lua"
			if ChoGGi.ComFuncs.FileExists(autoexec) then
				print("ECM auto-executing: ", ConvertToOSPath(autoexec))
				dofile(autoexec)
			end
		end

		-- bloody hint popups
		if ChoGGi.UserSettings.DisableHints then
			if mapdata.DisableHints == false then
				mapdata.DisableHints = true
			end
			HintsEnabled = false
		end

		-- show completed hidden milestones
		if UICity.ChoGGi.DaddysLittleHitler then
			PlaceObj("Milestone", {
				base_score = 0,
				display_name = Strings[302535920000731--[[Deutsche Gesellschaft für Rassenhygiene]]],
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
				display_name = Strings[302535920000732--[[Childkiller (You evil, evil person.)]]],
				group = "Default",
				id = "Childkiller"
			})
			--it doesn't hurt
			if not MilestoneCompleted.Childkiller then
				MilestoneCompleted.Childkiller = 479000000 -- 666
			end
		end

		-- if there's a lightmodel name saved
		if UserSettings.Lightmodel then
			SetLightmodelOverride(1, UserSettings.Lightmodel)
		end

		-- long arsed cables
		if UserSettings.UnlimitedConnectionLength then
			g_Classes.GridConstructionController.max_hex_distance_to_allow_build = 1000
			const.PassageConstructionGroupMaxSize = 1000
		end

		-- render settings
		if UserSettings.ShadowmapSize then
			hr.ShadowmapSize = UserSettings.ShadowmapSize
		end
		if UserSettings.VideoMemory then
			hr.DTM_VideoMemory = UserSettings.VideoMemory
		end
		if UserSettings.TerrainDetail then
			hr.TR_MaxChunks = UserSettings.TerrainDetail
		end
		if UserSettings.LightsRadius then
			hr.LightsRadiusModifier = UserSettings.LightsRadius
		end
		if UserSettings.DisableTextureCompression then
			-- uses more vram (1 toggles it, not sure what 0 does...)
			hr.TR_ToggleTextureCompression = 1
		end

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
		local domes = labels.Dome or ""
		for i = 1, #domes do
			local dome = domes[i]
			if dome.achievement == "FirstDome" and type(dome.connected_domes) ~= "table" then
				dome.connected_domes = {}
			end
		end

		-- something messed up if storage is negative (usually setting an amount then lowering it)
		local storages = labels.Storages or ""
		procall(function()
			for i = 1, #storages do
				local obj = storages[i]
				if obj.GetStoredAmount and not obj:IsKindOf("ConstructionSite") and obj:GetStoredAmount() < 0 then
					-- we have to empty it first (just filling doesn't fix the issue)
					obj:CheatEmpty()
					obj:CheatFill()
				end
			end
		end)

		-- so we can change the max_amount for concrete
		local terr_props = g_Classes.TerrainDepositConcrete.properties or ""
		for i = 1, #terr_props do
			local prop = terr_props[i]
			if prop.id == "max_amount" then
				prop.read_only = nil
			end
		end

		-- show all traits
		if UserSettings.SanatoriumSchoolShowAll then
			g_Classes.Sanatorium.max_traits = #ChoGGi.Tables.NegativeTraits
			g_Classes.School.max_traits = #ChoGGi.Tables.PositiveTraits
		end

		-- everyone loves a new titlebar, unless they don't
		if UserSettings.ChangeWindowTitle then
			terminal.SetOSWindowTitle(Translate(1079--[[Surviving Mars]]) .. ": " .. Strings[302535920000887--[[ECM]]] .. " " .. ChoGGi._VERSION)
		end

		-- first time run info
		if UserSettings.FirstRun ~= false then
			UserSettings.FirstRun = false
			DestroyConsoleLog()
			ChoGGi.Temp.WriteSettings = true
			ChoGGi.ComFuncs.MsgWait(
				Strings[302535920000001--[["F2 to toggle Cheats Menu (Ctrl-F2 for Cheats Pane), and F9 to clear console log text.
If this isn't a new install, then see Menu>Help>Changelog and search for ""To import your old settings""."]]]
					.. "\n\n" .. Strings[302535920000030--[["To show the console log text; press Tilde or Enter and click the ""%s"" button then make sure ""%s"" is checked."]]]:format(Strings[302535920001308--[[Settings]]], Strings[302535920001112--[[Console Log]]]),
				T(10126, "Installed Mods") .. ": " .. Strings[302535920000000--[[Expanded Cheat Menu]]],
				ChoGGi.mod_path .. "Preview.png",
				Strings[302535920001465--[[Stop talking and start cheating!]]]
			)
		end

		-- added ifs and pcall for xbox (for some reason settings aren't being saved)

		-- set zoom/border scrolling
		if SetMouseDeltaMode then
			SetMouseDeltaMode(false)
		end
		if cameraRTS and cameraRTS.Activate then
			cameraRTS.Activate(1)
		end
		if engineShowMouseCursor then
			engineShowMouseCursor()
		end
		pcall(function()
			ChoGGi.ComFuncs.SetCameraSettings()
		end)



		------------------------------- always fired last



		-- make sure to save anything we changed above
		if ChoGGi.Temp.WriteSettings then
			ChoGGi.SettingFuncs.WriteSettings()
			ChoGGi.Temp.WriteSettings = nil
		end

		if UserSettings.FlushLog then
			FlushLogFile()
		end

		-- used to check when game has started and it's safe to print() etc
		ChoGGi.Temp.GameLoaded = true

		-- anything that needs a thread/delay
		CreateRealTimeThread(function()
			-- always pause on start (for saves with missing mod buildings)
			if testing and game_type == "Load" then
				Sleep(100)
				if UISpeedState ~= "pause" then
					UICity:SetGameSpeed(0)
				end
			end

			-- clean up my old notifications (doesn't actually matter if there's a few left, but it can spam log)
			local shown = g_ShownOnScreenNotifications or empty_table
			for key in pairs(shown) do
				if type(key) == "number" or tostring(key):find("ChoGGi_") then
					shown[key] = nil
				end
			end

			-- remove any dialogs we opened
			if UserSettings.CloseDialogsECM then
				ChoGGi.ComFuncs.CloseDialogsECM()
			end

		end)

		-- how long startup takes
		if testing or UserSettings.ShowStartupTicks then
			print("<color 200 200 200>", Strings[302535920000887--[[ECM]]], "</color>:", Strings[302535920000247--[[Startup ticks]]], ":", GetPreciseTicks() - ChoGGi.Temp.StartupTicks)
		end
	end --OnMsg
end -- do

-- if i need to do something on a new game that needs the map (or objs on the map)
--~ function OnMsg.MapSectorsReady()
--~ end
-- you can also do a thread and a WaitMsg for DepositsSpawned or Resume
-- or MessageBoxOpened/MessageBoxClosed (the welcome msg)
-- even later
--~ function OnMsg.DepositsSpawned()
--~ end
