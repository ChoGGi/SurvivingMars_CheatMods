-- See LICENSE for terms

local type,tostring = type,tostring
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local white = white
local guic = guic

function OnMsg.ClassesGenerate()
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local S = ChoGGi.Strings
	local RetName = ChoGGi.ComFuncs.RetName
	local RetIcon = ChoGGi.ComFuncs.RetIcon
	local RetHint = ChoGGi.ComFuncs.RetHint
	local Random = ChoGGi.ComFuncs.Random
	local Trans = ChoGGi.ComFuncs.Translate

	function ChoGGi.MenuFuncs.ReloadMap()
		local function CallBackFunc(answer)
			if answer then
				ReloadMap()
			end
		end

		ChoGGi.ComFuncs.QuestionBox(
			Trans(6779--[[Warning--]]) .. ": " .. S[302535920001488--[[Reloads map as new game.--]]],
			CallBackFunc,
			S[302535920001487--[[Reload Map--]]]
		)
	end

	function ChoGGi.MenuFuncs.GUIDockSide_Toggle()
		local ChoGGi = ChoGGi
		local XTemplates = XTemplates

		if ChoGGi.UserSettings.GUIDockSide then
			ChoGGi.UserSettings.GUIDockSide = false
			-- command center and such
			XTemplates.NewOverlayDlg[1].Dock = "left"
			-- save/load screens
			XTemplates.SaveLoadContentWindow[1].Dock = "left"
			ChoGGi.ComFuncs.SetTableValue(XTemplates.SaveLoadContentWindow[1],"Dock","right","Dock","left")
			-- photomode
			XTemplates.PhotoMode[1].Dock = "left"
		else
			ChoGGi.UserSettings.GUIDockSide = true
			XTemplates.NewOverlayDlg[1].Dock = "right"
			XTemplates.SaveLoadContentWindow[1].Dock = "right"
			ChoGGi.ComFuncs.SetTableValue(XTemplates.SaveLoadContentWindow[1],"Dock","left","Dock","right")
			XTemplates.PhotoMode[1].Dock = "right"
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.UserSettings.GUIDockSide and Trans(1000459--[[Right--]]) or Trans(1000457--[[Left--]]),
			S[302535920001412--[[GUI Dock Side--]]]
		)
	end

	function ChoGGi.MenuFuncs.NeverShowHints_Toggle()
		if ChoGGi.UserSettings.DisableHints then
			ChoGGi.UserSettings.DisableHints = nil
			mapdata.DisableHints = false
			HintsEnabled = true
		else
			ChoGGi.UserSettings.DisableHints = true
			mapdata.DisableHints = true
			HintsEnabled = false
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisableHints),
			S[302535920000670--[[Never Show Hints--]]]
		)
	end

	function ChoGGi.MenuFuncs.OnScreenHints_Reset()
		g_ShownOnScreenHints = {}
		UpdateOnScreenHintDlg()
		MsgPopup(
			"true",
			S[302535920000668--[[Reset on-screen hints--]]]
		)
	end

	function ChoGGi.MenuFuncs.OnScreenHints_Toggle()
		HintsEnabled = not HintsEnabled
		SetHintNotificationsEnabled(HintsEnabled)
		mapdata.DisableHints = not HintsEnabled
		UpdateOnScreenHintDlg()
		MsgPopup(
			tostring(HintsEnabled),
			S[302535920000666--[[Toggle on-screen hints--]]]
		)
	end

	function ChoGGi.MenuFuncs.Interface_Toggle()
		if hr.RenderUIL == 1 then

			-- retrieve shortcut key to display below
			local options = OptionsCreateAndLoad()
			local key = options["ECM.Game.Interface.Toggle Interface"]
			-- if we don't have a shortcut set then do nothing
			if key then
				key = key[1]
				if not key then
					return
				end
			else
				return
			end

			local function CallBackFunc(answer)
				if answer then
					hr.RenderUIL = 0
				end
			end

			ChoGGi.ComFuncs.QuestionBox(
				S[302535920000244--[[Warning! This will hide everything. Remember the shortcut or have fun restarting.--]]] .. "\n\n" .. key,
				CallBackFunc,
				S[302535920000663--[[Toggle Interface--]]]
			)

		else
			hr.RenderUIL = 1
		end

	end

	function ChoGGi.MenuFuncs.ShowInterfaceInScreenshots_Toggle()
		hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
		-- needs default
		ChoGGi.UserSettings.ShowInterfaceInScreenshots = not ChoGGi.UserSettings.ShowInterfaceInScreenshots

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ShowInterfaceInScreenshots),
			S[302535920000661--[[Show Interface in Screenshots--]]]
		)
	end

	function ChoGGi.MenuFuncs.TakeScreenshot(boolean)
		CreateRealTimeThread(function()
			local filename,created
			if boolean == true then
					WaitNextFrame(3)
					LockCamera("Screenshot")
					filename = ChoGGi.ComFuncs.GenerateScreenshotFilename("SSAA","AppData/","tga")
					MovieWriteScreenshot(filename, 0, 64, false)
					UnlockCamera("Screenshot")
			else
				filename = ChoGGi.ComFuncs.GenerateScreenshotFilename("SS","AppData/","tga")
				created = WriteScreenshot(filename)
			end

			-- MovieWriteScreenshot doesn't return jack, so
			if created or boolean == true then
				-- slight delay so it doesn't show up in the screenshot
				Sleep(50)
				local msg = ConvertToOSPath(filename)
				print("TakeScreenshot:",msg)
				MsgPopup(
					msg,
					S[302535920000657--[[Screenshot--]]]
				)
			end
		end)
	end

	function ChoGGi.MenuFuncs.MapEdgeLimit_Toggle()
		if ChoGGi.UserSettings.MapEdgeLimit then
			ChoGGi.UserSettings.MapEdgeLimit = nil
			hr.CameraRTSBorderAtMinZoom = 0
			hr.CameraRTSBorderAtMaxZoom = 0
		else
			ChoGGi.UserSettings.MapEdgeLimit = true
			hr.CameraRTSBorderAtMinZoom = 1000
			hr.CameraRTSBorderAtMaxZoom = 1000
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.MapEdgeLimit),
			S[302535920001489--[[Toggle Map Edge Limit--]]]
		)
	end

	function ChoGGi.MenuFuncs.ResetCamera()
		SetMouseDeltaMode(false)
		cameraRTS.Activate(1)
		engineShowMouseCursor()
		ChoGGi.ComFuncs.SetCameraSettings()
	end

	function ChoGGi.MenuFuncs.WhiterRocks()
		-- less brown rocks
		SuspendPassEdits("WhiterRocks")
		local white = white
		MapForEach("map",{"Deposition","WasteRockObstructorSmall","WasteRockObstructor","StoneSmall"},function(o)
			if o.class:find("Dark") then
				o:SetColorModifier(white)
--~ 			else
--~ 				-- these ones don't look good like this so buhbye
--~ 				o:delete()
			end
		end)
		ResumePassEdits("WhiterRocks")
	end

	function ChoGGi.MenuFuncs.SetObjectOpacity()
		if not GameState.gameplay then
			return
		end

		local sel = ChoGGi.ComFuncs.SelObject()
		local hint_loop = S[302535920001109--[[Loops though and makes all %s visible.--]]]

		local ItemList = {
			{text = S[302535920001084--[[Reset--]]] .. ": " .. Trans(3984--[[Anomalies--]]),value = "Anomaly",hint = hint_loop:format(Trans(3984--[[Anomalies--]]))},
			{text = S[302535920001084--[[Reset--]]] .. ": " .. Trans(3980--[[Buildings--]]),value = "Building",hint = hint_loop:format(Trans(3980--[[Buildings--]]))},
			{text = S[302535920001084--[[Reset--]]] .. ": " .. S[302535920000157--[[Cables & Pipes--]]],value = "GridElements",hint = hint_loop:format(S[302535920000157--[[Cables & Pipes--]]])},
			{text = S[302535920001084--[[Reset--]]] .. ": " .. Trans(547--[[Colonists--]]),value = "Colonists",hint = hint_loop:format(Trans(547--[[Colonists--]]))},
			{text = S[302535920001084--[[Reset--]]] .. ": " .. Trans(5438--[[Rovers--]]) .. " & " .. Trans(517--[[Drones--]]),value = "Unit",hint = hint_loop:format(Trans(5438--[[Rovers--]]) .. " & " .. Trans(517--[[Drones--]]))},
			{text = S[302535920001084--[[Reset--]]] .. ": " .. Trans(3982--[[Deposits--]]),value = "SurfaceDeposit",hint = hint_loop:format(Trans(3982--[[Deposits--]]))},
		}
		local c = #ItemList
		if sel then
			c = c + 1
			ItemList[c] = {text = 0,value = 0}
			c = c + 1
			ItemList[c] = {text = 50,value = 50}
			c = c + 1
			ItemList[c] = {text = 75,value = 75}
			c = c + 1
			ItemList[c] = {text = 100,value = 100}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				sel:SetOpacity(value)
			elseif type(value) == "string" then
				local function SettingOpacity(label)
					local tab = ChoGGi.ComFuncs.RetAllOfClass(label)
					for i = 1, #tab do
						tab[i]:SetOpacity(100)
					end
				end
				SettingOpacity(value)
				-- extra ones
				if value == "Building" then
					SettingOpacity("AllRockets")
				elseif value == "Anomaly" then
					SettingOpacity("SubsurfaceAnomalyMarker")
				elseif value == "SurfaceDeposit" then
					SettingOpacity("SubsurfaceDeposit")
					SettingOpacity("TerrainDeposit")
				end
			end
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text,S[302535920000769--[[Selected--]]]),
				S[302535920000694--[[Set Opacity--]]]
			)
		end
		local hint = S[302535920001118--[[You can still select items after making them invisible (0), but it may take some effort :).--]]]
		if sel then
			hint = S[302535920000106--[[Current--]]] .. ": " .. sel:GetOpacity() .. "\n\n" .. hint
		end

		local name = RetName(sel)
		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000694--[[Set Opacity--]]] .. (name ~= "nil" and ": " .. name or ""),
			hint = hint,
			skip_sort = true,
			skip_icons = true,
		}
	end

	do -- AnnoyingSounds_Toggle
		local function MirrorSphere_Toggle()
			local tab = UICity.labels.MirrorSpheres or ""
			for i = 1, #tab do
				PlayFX("Freeze", "end", tab[i])
				PlayFX("Freeze", "start", tab[i])
			end
		end
		local function SensorTower_Toggle()
			local ChoGGi = ChoGGi
			local tab = UICity.labels.SensorTower or ""
			for i = 1, #tab do
				ChoGGi.ComFuncs.ToggleWorking(tab[i])
			end
		end
		local function RCRoverDeploy_Toggle()
			local tab = UICity.labels.RCRover or ""
			for i = 1, #tab do
				PlayFX("RoverDeploy", "end", tab[i])
				PlayFX("RoverDeploy", "start", tab[i])
			end
		end
		local function RCRoverEmergencyPower_Toggle()
			local tab = UICity.labels.RCRover or ""
			for i = 1, #tab do
				PlayFX("EmergencyPower", "end", tab[i])
				PlayFX("EmergencyPower", "start", tab[i])
			end
		end

--~ 	-- Data\SoundPreset.lua, and Lua\Config\__SoundTypes.lua
--~ 	-- test sounds:
--~ 	local function TestSound(snd)
--~ 		StopSound(ChoGGi.Temp.Sound)
--~ 		ChoGGi.Temp.Sound = PlaySound(snd,"UI")
--~ 	end
--~ 	TestSound("Object MOXIE Loop")

		function ChoGGi.MenuFuncs.AnnoyingSounds_Toggle(manual)
			local ChoGGi = ChoGGi
			--make a list
			local ItemList = {
				{text = S[302535920001084--[[Reset--]]],value = "Reset"},
				{text = S[302535920001085--[[Sensor Tower Beeping--]]],value = "SensorTowerWorking"},
				{text = S[302535920001086--[[RC Rover Drones Deployed--]]],value = "RCRoverAntenna"},
				{text = S[302535920001087--[[Mirror Sphere Crackling--]]],value = "MirrorSphereFreeze"},
				{text = S[302535920000220--[[RC Rover Emergency Power--]]],value = "RCRoverEmergencyPower"},
			}

			local function CallBackFunc(choice,skip)
				if choice.nothing_selected then
					return
				end
				local value = choice[1].value
				local FXRules = FXRules
				if value == "SensorTowerWorking" then
					table.remove(FXRules.Working.start.SensorTower.any,3)
					RemoveFromRules("Object SensorTower Loop")
					SensorTower_Toggle()

				elseif value == "MirrorSphereFreeze" then
					table.remove(FXRules.Freeze.start.MirrorSphere.any,2)
					FXRules.Freeze.start.any = nil
	--~ 				RemoveFromRules("Freeze")
					RemoveFromRules("Mystery Sphere Freeze")
					MirrorSphere_Toggle()

				elseif value == "RCRoverAntenna" then
					local list = FXRules.RoverDeploy.start.RCRover.any
					for i = #list, 1, -1 do
						if list[i].Sound == "Unit Rover DeployAntennaON" or list[i].Sound == "Unit Rover DeployLoop" then
							table.remove(list,i)
						end
					end
					RemoveFromRules("Unit Rover DeployLoop")
					RemoveFromRules("Unit Rover DeployAntennaON")
					RCRoverDeploy_Toggle()

				elseif value == "RCRoverEmergencyPower" then
					table.remove(FXRules.EmergencyPower.start.RCRover.any,1)
	--~ 				table.remove(FXRules.EmergencyPower.start.RCRover.any,3)
	--~ 				RemoveFromRules("Unit Rover EmergencyPower")
					RemoveFromRules("Unit Rover EmergencyPower")
					RCRoverEmergencyPower_Toggle()

				elseif value == "Reset" then
					RebuildFXRules()
					MirrorSphere_Toggle()
					SensorTower_Toggle()
					RCRoverDeploy_Toggle()
					RCRoverEmergencyPower_Toggle()
				end

				if not skip then
					MsgPopup(
						S[302535920001088--[[%s: Stop that bloody bouzouki!--]]]:format(choice[1].text),
						S[302535920000680--[[Annoying Sounds--]]]
					)
				end
			end

			if manual then
				-- added this for someone i think?
				CallBackFunc({{value = manual}},true)
			else
				ChoGGi.ComFuncs.OpenInListChoice{
					callback = CallBackFunc,
					items = ItemList,
					title = S[302535920000680--[[Annoying Sounds--]]],
					hint = S[302535920001090--[[You can only reset all sounds at once.--]]],
					skip_sort = true,
				}
			end
		end
	end -- do

	do -- ListAllObjects
		local IsValid = IsValid
		local CmpLower = CmpLower
		local function ViewAndSelectObject(choice)
			if choice.nothing_selected then
				return
			end
			ViewObjectMars(choice[1].obj)
			SelectObj(choice[1].obj)
		end

		local function BuildItemList_Class(value)
			local handles = {}

			-- build our list of objects (we use an ass table of handles to skip dupes)
			if value == S[302535920000306--[[Everything--]]] then
				local labels = UICity.labels or empty_table
				for id,label in pairs(labels) do
					if id ~= "Consts" then
						for i = 1, #label do
							local obj = label[i]
							if IsValid(obj) and not handles[obj.handle] then
								handles[obj.handle] = obj
							end
						end
					end
				end
			else
				-- don't need to dupe skip these, but I'm lazy and it's quick enough
				local labels = UICity.labels[value] or ""
				for i = 1, #labels do
					local obj = labels[i]
					if IsValid(obj) and not handles[obj.handle] then
						handles[obj.handle] = obj
					end
				end
			end

			-- and build the ass table into an idx one
			local ItemList = {}
			local c = 0
			for _,obj in pairs(handles) do
				local name = RetName(obj)
				local class = obj.class
				if name ~= class then
					name = class .. ": " .. name
				end
				local icon,icon_scale = RetIcon(obj)
				c = c + 1
				ItemList[c] = {
					text = name,
					value = tostring(obj:GetVisualPos()),
					obj = obj,
					hint = RetHint(obj),
					icon = icon,
					icon_scale = icon_scale,
				}
			end
			return ItemList
		end

		local function CallBackFunc_List(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			local ItemList = BuildItemList_Class(value)

			-- and display them
			ChoGGi.ComFuncs.OpenInListChoice{
				callback = ViewAndSelectObject,
				items = ItemList,
				title = S[302535920001292--[[List All Objects--]]] .. ": " .. value,
				custom_type = 1,
				custom_func = ViewAndSelectObject,
				check = {
					{
						title = Trans(1000220--[[Refresh--]]),
						hint = S[302535920000548--[[List is updated each time you click this.--]]],
						func = function(dlg)
							ItemList = BuildItemList_Class(value)
							table.sort(ItemList,function(a,b)
								return CmpLower(a.text, b.text)
							end)

							dlg.items = ItemList
							dlg:BuildList(true)
						end,
					},
				},
			}
		end

		local function BuildItemList_All()
			local ItemList = {
				{
				text = " " .. S[302535920000306--[[Everything--]]],
				value = S[302535920000306--[[Everything--]]],hint = S[302535920001294--[[Laggy--]]],
				},
			}
			local c = 1
			local labels = UICity.labels or empty_table
			for label,list in pairs(labels) do
				if label ~= "Consts" and #list > 0 then
					local item = list[1]
					local icon,icon_scale = RetIcon(item)
					c = c + 1
					ItemList[c] = {
						text = label .. ": " .. #list,
						value = label,
						hint = RetHint(item),
						icon = icon,
						icon_scale = icon_scale,
					}
				end
			end
			return ItemList
		end

		function ChoGGi.MenuFuncs.ListAllObjects()
			local ItemList = BuildItemList_All()

			ChoGGi.ComFuncs.OpenInListChoice{
				callback = CallBackFunc_List,
				items = ItemList,
				title = S[302535920001292--[[List All Objects--]]],
				custom_type = 1,
				custom_func = CallBackFunc_List,
				height = 800,
				check = {
					{
						title = Trans(1000220--[[Refresh--]]),
						hint = S[302535920000548--[[List is updated each time you click this.--]]],
						func = function(dlg)
							ItemList = BuildItemList_All()
							table.sort(ItemList,function(a,b)
								return CmpLower(a.text, b.text)
							end)

							dlg.items = ItemList
							dlg:BuildList(true)
						end,
					},
				},
			}
		end
	end -- do

	function ChoGGi.MenuFuncs.DisableTextureCompression_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.DisableTextureCompression = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DisableTextureCompression)
		hr.TR_ToggleTextureCompression = 1

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisableTextureCompression),
			S[302535920000641--[[Disable Texture Compression--]]]
		)
	end

	do -- FlattenGround
		local ToggleCollisions = ChoGGi.ComFuncs.ToggleCollisions
		local GetHeight = terrain.GetHeight
		local SetHeightCircle = terrain.SetHeightCircle
		local GetTerrainCursor = GetTerrainCursor
		local Sleep = Sleep

		local are_we_flattening
		local visual_circle
		local flatten_height
		local size
		local radius

		local temp_height
		local function ToggleHotkeys(bool)
			if bool then
				local us = ChoGGi.UserSettings
				local XAction = XAction
				local XShortcutsTarget = XShortcutsTarget

				XShortcutsTarget:AddAction(XAction:new{
					ActionId = "ChoGGi_FlattenGround_RaiseHeight",
					OnAction = function()
						temp_height = flatten_height + us.FlattenGround_HeightDiff or 100
						--guess i found the ceiling limit
						if temp_height > 65535 then
							temp_height = 65535
						end
						flatten_height = temp_height
					end,
					ActionShortcut = "Shift-Up",
				})
				XShortcutsTarget:AddAction(XAction:new{
					ActionId = "ChoGGi_FlattenGround_LowerHeight",
					OnAction = function()
						temp_height = flatten_height - (us.FlattenGround_HeightDiff or 100)
						--and the floor limit (oh look 0 go figure)
						if temp_height < 0 then
							temp_height = 0
						end
						flatten_height = temp_height
					end,
					ActionShortcut = "Shift-Down",
				})
				XShortcutsTarget:AddAction(XAction:new{
					ActionId = "ChoGGi_FlattenGround_WidenRadius",
					OnAction = function()
						us.FlattenGround_Radius = (us.FlattenGround_Radius or 2500) + (us.FlattenGround_RadiusDiff or 100)
						size = us.FlattenGround_Radius
						visual_circle:SetRadius(size)
						radius = size * guic
					end,
					ActionShortcut = "Shift-Right",
				})
				XShortcutsTarget:AddAction(XAction:new{
					ActionId = "ChoGGi_FlattenGround_ShrinkRadius",
					OnAction = function()
						us.FlattenGround_Radius = (us.FlattenGround_Radius or 2500) - (us.FlattenGround_RadiusDiff or 100)
						size = us.FlattenGround_Radius
						visual_circle:SetRadius(size)
						radius = size * guic
					end,
					ActionShortcut = "Shift-Left",
				})
			else
				ReloadShortcuts()
			end
		end

		function ChoGGi.MenuFuncs.FlattenTerrain_Toggle(square)
			local ChoGGi = ChoGGi

			if are_we_flattening then
				-- disable shift-arrow keys
				ToggleHotkeys()
				DeleteThread(are_we_flattening)
				are_we_flattening = false
				visual_circle:delete()
				-- update saved settings (from hotkeys)
				ChoGGi.SettingFuncs.WriteSettings()

				MsgPopup(
					S[302535920001164--[[Flattening has been stopped, now updating buildable.--]]],
					S[302535920000485--[[Terrain Flatten Toggle--]]],
					"UI/Icons/Sections/WasteRock_1.tga"
				)
				-- disable collisions on pipes beforehand, so they don't get marked as uneven terrain
				ToggleCollisions(ChoGGi)
				-- update uneven terrain checker thingy
				RecalcBuildableGrid()
				-- and back on when we're done
				ToggleCollisions(ChoGGi)

			else
				-- have to set it here after settings are loaded or it'll be default radius till user adjusts it
				size = ChoGGi.UserSettings.FlattenGround_Radius or 2500
				radius = size * guic

				ToggleHotkeys(true)
				flatten_height = GetHeight(GetTerrainCursor())
				MsgPopup(
					S[302535920001163--[[Flatten height has been choosen %s, press shortcut again to update buildable.--]]]:format(flatten_height),
					S[302535920000485--[[Terrain Flatten Toggle--]]],
					"UI/Icons/Sections/warning.tga"
				)
				visual_circle = Circle:new()
				visual_circle:SetRadius(size)
				visual_circle:SetColor(white)

--~ 				local terrain_type_idx = table.find(TerrainTextures, "name", "Grass_03")
				are_we_flattening = CreateRealTimeThread(function()
					-- thread gets deleted, but just in case
					while are_we_flattening do
						local cursor = GetTerrainCursor()
						visual_circle:SetPos(cursor)
						local outer
						if square == true then
							outer = radius / 2
						end
						SetHeightCircle(cursor, radius, outer or radius, flatten_height)
--~ 						terrain.SetTypeCircle(cursor, radius, terrain_type_idx)
						-- used to set terrain type (see above)
						Sleep(10)
					end
				end)
			end
		end

	end

	--~ -- we'll get more concrete one of these days
	--~ local terrain_type_idx = table.find(TerrainTextures, "name", "Regolith")
	--~ terrain.SetTypeCircle(GetTerrainCursor(), 5000, terrain_type_idx)
	function ChoGGi.MenuFuncs.ChangeMap()
		local lookup_table = {
			[Trans(3474--[[Mission Sponsor--]])] = "idMissionSponsor",
			[Trans(3478--[[Commander Profile--]])] = "idCommanderProfile",
			[Trans(3486--[[Mystery--]])] = "idMystery",
			[Trans(3482--[[Colony Logo--]])] = "idMissionLogo",
			ResPreset_Concrete = "ResPreset_Concrete",
			ResPreset_Metals = "ResPreset_Metals",
			ResPreset_Polymers = "ResPreset_Polymers",
			ResPreset_PreciousMetals = "ResPreset_PreciousMetals",
			ResPreset_Water = "ResPreset_Water",
			ResTag_Concrete = "ResTag_Concrete",
			ResTag_Metals = "ResTag_Metals",
			ResTag_Polymers = "ResTag_Polymers",
			ResTag_PreciousMetals = "ResTag_PreciousMetals",
			ResTag_Water = "ResTag_Water",
		}
		local custom_params = {
			idGameRules = {},
		}
		local str_hint_rules = S[302535920000803--[[For rules separate with spaces: Hunger ColonyPrefab (or leave blank for none).--]]]

		-- open a list dialog to set g_CurrentMissionParams
		local ItemList_MissionParams = {
			{text = Trans(3474--[[Mission Sponsor--]]),value = "IMM",hint = S[302535920001386--[[Can be changed after in %s>%s>%s.--]]]:format(S[302535920000887--[[ECM--]]],Trans(1635--[[Mission--]]),S[302535920000712--[[Set Sponsor--]]])},
			{text = Trans(3478--[[Commander Profile--]]),value = "rocketscientist",hint = S[302535920001386--[[Can be changed after in %s>%s>%s.--]]]:format(S[302535920000887--[[ECM--]]],Trans(1635--[[Mission--]]),S[302535920000716--[[Set Commander--]]])},
			{text = Trans(3486--[[Mystery--]]),value = "random",hint = S[302535920001386--[[Can be changed after in %s>%s>%s.--]]]:format(Trans(27--[[Cheats--]]),S[302535920000331--[[Start Mystery--]]],"")},
			{text = Trans(3482--[[Colony Logo--]]),value = "MarsExpress",hint = S[302535920001386--[[Can be changed after in %s>%s>%s.--]]]:format(S[302535920000887--[[ECM--]]],Trans(1635--[[Mission--]]),S[302535920000710--[[Change Logo--]]])},
			{text = Trans(8800--[[Game Rules--]]),value = "",hint = str_hint_rules},
--~ 				{text = "ResPreset_Concrete",value = ""},
--~ 				{text = "ResPreset_Metals",value = ""},
--~ 				{text = "ResPreset_Polymers",value = ""},
--~ 				{text = "ResPreset_PreciousMetals",value = ""},
--~ 				{text = "ResPreset_Water",value = ""},
--~ 				{text = "ResTag_Concrete",value = ""},
--~ 				{text = "ResTag_Metals",value = ""},
--~ 				{text = "ResTag_Polymers",value = ""},
--~ 				{text = "ResTag_PreciousMetals",value = ""},
--~ 				{text = "ResTag_Water",value = ""},
		}

		local function CallBackFunc_MissionParams(choice)
			if choice.nothing_selected then
				return
			end
			for i = 1, #choice do
				local text = choice[i].text
				local value = choice[i].value

				-- only game rules needs something something, the rest can use the lookup_table
				if text == Trans(8800--[[Game Rules--]]) then
					-- if more than one entry
					if value:find(" ") then
						for i in value:gmatch("%S+") do
							custom_params.idGameRules[i] = true
						end
					-- just the one
					elseif value ~= "" then
						custom_params.idGameRules[value] = true
					end
				else
					custom_params[lookup_table[text]] = value
				end
			end
		end

		local dlg_list_MissionParams = ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc_MissionParams,
			items = ItemList_MissionParams,
			title = S[302535920000866--[[Set MissionParams NewMap--]]],
			hint = S[302535920000867--[["Attention: You must press ""OK"" for these settings to take effect before choosing a map!

See the examine list for ids."--]]] .. "\n\n" .. str_hint_rules,
			custom_type = 4,
		}

		-- shows the mission params for people to look at
		local info_lists = {
			[0] = S[302535920001385--[[Use these lists to find the correct ids.--]]],
			table.icopy(MissionParams.idCommanderProfile.items),
			table.icopy(MissionParams.idMissionSponsor.items),
			table.icopy(MissionParams.idMissionLogo.items),
			table.icopy(MissionParams.idGameRules.items),
			table.icopy(MissionParams.idMystery.items),
--~ 				table.icopy(DataInstances.ResourcePreset),
		}
		info_lists[1].name = Trans(3478--[[Commander Profile--]])
		info_lists[2].name = Trans(3474--[[Mission Sponsor--]])
		info_lists[3].name = Trans(3482--[[Colony Logo--]])
		info_lists[4].name = Trans(8800--[[Game Rules--]])
		info_lists[5].name = Trans(3486--[[Mystery--]])
--~ 			info_lists[6].name = Trans(692--[[Resources--]])
		local dlg_ex_params = ChoGGi.ComFuncs.OpenInExamineDlg(info_lists)

		local dlg_list_maps

		-- map list dialog
		local ItemList_MapList = {}
		local c = 0
		local maps = ListMaps()
		for i = 1, #maps do
			if not (maps[i]:find_lower("^prefab") and maps[i]:find("^_")) then
				c = c + 1
				ItemList_MapList[c] = {
					text = maps[i],
					value = maps[i],
				}
			end
		end

		local function CallBackFunc_LoadMapQuestion(choice)
			if choice.nothing_selected then
				return
			end

			local map = choice[1].value
			local function CallBackFunc(answer)
				if answer then
					-- close dialogs we opened
					dlg_list_MissionParams:Done()
					dlg_ex_params:Done()
					dlg_list_maps:Done()

					-- cleans out missions params
					InitNewGameMissionParams()
					-- rocket name
					GenerateRandomMapParams()

					-- select new MissionParams
					g_CurrentMissionParams.idMissionSponsor = custom_params.idMissionSponsor or "IMM"
					g_CurrentMissionParams.idCommanderProfile = custom_params.idCommanderProfile or "rocketscientist"
					g_CurrentMissionParams.idMystery = custom_params.idMystery or "random"
					g_CurrentMissionParams.idMissionLogo = custom_params.idMissionLogo or "MarsExpress"
					g_CurrentMissionParams.idGameRules = custom_params.idGameRules or {}
					g_CurrentMissionParams.GameSessionID = srp.random_encode64(96)

					-- this is a mostly copy of GenerateCurrentRandomMap()
					-- .rand returns a bunch of args, and we just want the first one (or it screws up getmod)
					local rand_props = table.rand(DataInstances.RandomMapPreset)
					local props = GetModifiedProperties(rand_props)

					local gen = RandomMapGenerator:new()
					gen:SetProperties(props)
					FillRandomMapProps(gen)
					-- add the name of map we want
					gen.BlankMap = map
					-- add any custom res values
					for key,value in pairs(custom_params) do
						if (key:sub(1,10) == "ResPreset_" or key:sub(1,7) == "ResTag_")
								and value ~= "" then
							gen[key] = value
						end
					end
--~ ex(gen)

--~ gen.ResPreset_Concrete = "Concrete_VeryHigh"
--~ gen.ResPreset_Polymers = "Polymers_VeryHigh"
--~ gen.ResPreset_PreciousMetals = "PreciousMetals_VeryHigh"
--~ gen.ResPreset_Water = "Water_VeryHigh"
--~ gen.ResPreset_Metals = "Metals_VeryHigh"
--~ gen.ResTag_Concrete = "Concrete_VeryHigh"
--~ gen.ResTag_Metals = "Metals_VeryHigh"
--~ gen.ResTag_PreciousMetals = "PreciousMetals_VeryHigh"
--~ gen.ResTag_Polymers = "Polymers_VeryHigh"
--~ gen.ResTag_Water = "Water_VeryHigh"
--~ MapDelete("SubsurfaceAnomaly")

					-- generates/loads map
					gen:Generate()
					-- update local store
					LocalStorage.last_map = map
					SaveLocalStorage()

				end
			end

			ChoGGi.ComFuncs.QuestionBox(
				S[302535920000868--[[Choose Map--]]] .. ": " .. map .. "?",
				CallBackFunc,
				S[302535920000868--[[Choose Map--]]]
			)
		end

		dlg_list_maps = ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc_LoadMapQuestion,
			close_func = function()
				-- close dialogs we opened
				dlg_list_MissionParams:Done()
				dlg_ex_params:Done()
			end,
			items = ItemList_MapList,
			title = S[302535920000868--[[Choose Map--]]],
			custom_type = 7,
		}

		dlg_list_maps:SetPos(point(350,50))
		dlg_list_MissionParams:SetPos(point(0,50))
		dlg_ex_params:SetPos(point(750,50))
	end

	function ChoGGi.MenuFuncs.PulsatingPins_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.DisablePulsatingPinsMotion = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DisablePulsatingPinsMotion)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DisablePulsatingPinsMotion),
			S[302535920000265--[[Pulsating Pins--]]]
		)
	end

	function ChoGGi.MenuFuncs.ChangeTerrainType()
		local GridOpFree = GridOpFree
		local AsyncSetTypeGrid = AsyncSetTypeGrid
		local MulDivRound = MulDivRound
		local sqrt = sqrt

		local TerrainTextures = TerrainTextures
		local NoisePreset = DataInstances.NoisePreset
		local guim = ChoGGi.Consts.guim

		local ItemList = {}
		local c = 0
		for i = 1, #TerrainTextures do
			c = c + 1
			ItemList[c] = {
				text = TerrainTextures[i].name,
				value = i,
				icon = "<image " .. TerrainTextures[i].texture .. " 100>",
				hint = "<image " .. TerrainTextures[i].texture .. ">\n\n",
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if TerrainTextures[value] then
				terrain.SetTerrainType{type = value}

				-- add back dome grass
				local domes = UICity.labels.Dome or ""
				for i = 1, #domes do
					domes[i]:ChangeSkin(domes[i]:GetCurrentSkin())
				end

				-- re-build concrete marker textures
				local texture_idx1 = table.find(TerrainTextures, "name", "Regolith") + 1
				local texture_idx2 = table.find(TerrainTextures, "name", "Regolith_02") + 1

				local deposits = UICity.labels.TerrainDeposit or ""
				for i = 1, #deposits do
					local d = deposits[i]
					if IsValid(d) then
						local pattern = NoisePreset.ConcreteForm:GetNoise(128, Random())
						pattern:land_i(NoisePreset.ConcreteNoise:GetNoise(128, Random()))
						-- any over 1000 get the more noticeable texture
						if d.max_amount > 1000000 then
							pattern:mul_i(texture_idx2, 1)
						else
							pattern:mul_i(texture_idx1, 1)
						end
						-- blend in with surrounding ground
						pattern:sub_i(1, 1)
						-- ?
						pattern = GridOpFree(pattern, "repack", 8)
						-- paint deposit
						AsyncSetTypeGrid{
							type_grid = pattern,
							pos = d:GetPos(),
							scale = sqrt(MulDivRound(10000, d.max_amount / guim, d.radius_max)),
							centered = true,
							invalid_type = -1,
						}
					end
				end

			end -- if type(value) == "number" then
		end -- CallBackFunc

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000973--[[Change Terrain Texture--]]],
			hint = S[302535920000974--[[Map default: %s--]]]:format(mapdata.BaseLayer),
			custom_type = 7,
		}
	end

	function ChoGGi.MenuFuncs.EditLightmodelCustom(name)
		local ItemList = {}

		-- always load defaults, then override with custom settings so list is always full
		local def = LightmodelPreset:GetProperties()
		local help_str = Trans(487939677892--[[Help--]])
		local default_str = Trans(1000121--[[Default--]])
		local min_str = S[302535920000110--[[Min--]]]
		local max_str = S[302535920000941--[[Max--]]]
		local scale_str = Trans(1000081--[[Scale--]])
		for i = 1, #def do
			if def[i].editor ~= "image" and def[i].editor ~= "dropdownlist" and def[i].editor ~= "combo" and type(def[i].value) ~= "userdata" then
				ItemList[#ItemList+1] = {
					text = (def[i].editor == "color" and "<color 100 100 255>" or "") .. def[i].id .. "</color>",
					sort = def[i].id,
					value = def[i].default,
					default = def[i].default,
					editor = def[i].editor,
					hint = (def[i].id or "") .. "\n"
						.. help_str .. ": " .. (def[i].help or "") .. "\n\n"
						.. default_str .. ": " .. (def[i].default or "") .. " "
						.. min_str .. ": " .. (def[i].min or "") .. " "
						.. max_str .. ": " .. (def[i].max or "") .. " "
						.. scale_str .. ": " .. (def[i].scale or "")
				}
			end
		end

		-- or loading style from presets
		name = LightmodelPresets[name or "ChoGGi_Custom"]
		if not name then
			return
		end

		for i = 1, #ItemList do
			if name[ItemList[i].sort] then
				ItemList[i].value = name[ItemList[i].sort]
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local model_table = {}
			for i = 1, #choice do
				local value = choice[i].value
				if value ~= choice[i].default then
					model_table[choice[i].sort] = value
				end
			end
			model_table.id = "ChoGGi_Custom"

			-- make a copy, as LightmodelPreset:new will change it into an object, and i don't want to save that to the settings
			local temp_lm = table.copy(model_table)

			LightmodelPresets.ChoGGi_Custom = LightmodelPreset:new(temp_lm)
			if choice[1].check1 then
				SetLightmodelOverride(1,"ChoGGi_Custom")
			else
				SetLightmodel(1,"ChoGGi_Custom")
			end

			ChoGGi.UserSettings.LightmodelCustom = model_table
			ChoGGi.SettingFuncs.WriteSettings()
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			sortby = "sort",
			title = S[302535920000975--[[Custom Lightmodel--]]],
			hint = S[302535920000976--[[Use double right click to test without closing dialog

	Some settings can't be changed in the editor, but you can manually add them in the settings file (type OpenExamine(LightmodelPresets) and use dump obj).--]]],
			check = {
				{
					title = S[302535920000977--[[Semi-Permanent--]]],
					hint = S[302535920000978--[[Make it stay at selected light model till reboot (use Misc>Change Light Model for Permanent).--]]],
				},
				{
					title = S[302535920000979--[[Presets--]]],
					hint = S[302535920000980--[[Opens up the list of premade styles so you can start with the settings from one.--]]],
				},
			},
			custom_type = 5,
		}
	end

	function ChoGGi.MenuFuncs.ChangeLightmodel(mode)
		-- if it gets opened by menu then has object so easy way to do this
		local browse
		if mode == true then
			browse = mode
		end

		local ItemList = {}
		if not browse then
			ItemList[#ItemList+1] = {
				text = " " .. Trans(1000121--[[Default--]]),
				value = "ChoGGi_Default",
				hint = S[302535920000981--[[Choose to this remove Permanent setting.--]]],
			}
			ItemList[#ItemList+1] = {
				text = " " .. S[302535920000982--[[Custom--]]],
				value = "ChoGGi_Custom",
				hint = S[302535920000983--[["Custom Lightmodel made with ""Change Light Model Custom""."--]]],
			}
		end
		local LightmodelPresets = LightmodelPresets
		for key in pairs(LightmodelPresets) do
			ItemList[#ItemList+1] = {
				text = key,
				value = key,
				func = key,
				hint = S[302535920000986--[[Change Lightmodel--]]],
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if type(value) == "string" then
				if browse or choice[1].check2 then
					ChoGGi.MenuFuncs.EditLightmodelCustom(value)
				else
					if value == "ChoGGi_Default" then
						ChoGGi.UserSettings.Lightmodel = nil
						SetLightmodelOverride(1)
					else
						if choice[1].check1 then
							ChoGGi.UserSettings.Lightmodel = value
							SetLightmodelOverride(1,value)
						else
							SetLightmodelOverride(1)
							SetLightmodel(1,value)
						end
					end

					ChoGGi.SettingFuncs.WriteSettings()
					MsgPopup(
						ChoGGi.ComFuncs.SettingState(choice[1].text,S[302535920000769--[[Selected--]]]),
						S[302535920000625--[[Change Light Model--]]]
					)
				end
			end
		end

		local hint = {}
		local check
		local title = S[302535920000985--[[Select Lightmodel Preset--]]]
		if not browse then
			title = S[302535920000986--[[Change Lightmodel--]]]
			hint[#hint+1] = S[302535920000987--[[If you used Permanent; you must choose default to remove the setting (or it'll set the lightmodel next time you start the game).--]]]
			local lightmodel = ChoGGi.UserSettings.Lightmodel
			if lightmodel then
				hint[#hint+1] = "\n\n"
				hint[#hint+1] = S[302535920000988--[[Permanent--]]]
				hint[#hint+1] = ": "
				hint[#hint+1] = lightmodel
			end
			check = {
				{
					title = S[302535920000988--[[Permanent--]]],
					hint = S[302535920000989--[[Make it stay at selected light model all the time (including reboots).--]]],
				},
				{
					title = Trans(327465361219--[[Edit--]]),
					hint = S[302535920000990--[[Open this style in "Change Light Model Custom".--]]],
				},
			}
		end

		hint[#hint+1] = "\n\n"
		hint[#hint+1] = S[302535920000991--[[Double right-click to preview lightmodel without closing dialog.--]]]
		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = title,
			hint = TableConcat(hint),
			check = check,
			custom_type = 6,
			custom_func = function(value)
				SetLightmodel(1,value)
			end,
		}
	end

	function ChoGGi.MenuFuncs.TransparencyUI_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.TransparencyToggle = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.TransparencyToggle)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.TransparencyToggle),
			S[302535920000631--[[UI Transparency Mouseover--]]]
		)
	end

	function ChoGGi.MenuFuncs.SetTransparencyUI()
		local desk = terminal.desktop
		local igi = Dialogs.InGameInterface

		local function GetSetTrans(iType,sName,iWhich)
			local name = ChoGGi.UserSettings.Transparency[sName]
			if not iWhich and name then
				return name
			end

			local uilist
			if iType == 1 then
				uilist = desk
			else
				if not igi or not igi:GetVisible() then
					return 0
				end
				uilist = igi
			end
			for i = 1, #uilist do
				local ui = uilist[i]
				if ui:IsKindOf(sName) then
					if iWhich then
						ui:SetTransparency(iWhich)
					else
						return ui:GetTransparency()
					end
				end
			end
		end

		local ItemList = {
			{text = "ConsoleLog",value = GetSetTrans(1,"ConsoleLog"),hint = S[302535920000994--[[Console logging text--]]]},
			{text = "Console",value = GetSetTrans(1,"Console"),hint = S[302535920000996--[[Console text input--]]]},
			{text = "XShortcutsHost",value = GetSetTrans(1,"XShortcutsHost"),hint = S[302535920000998--[[Cheat Menu--]]]},

			{text = "HUD",value = GetSetTrans(2,"HUD"),hint = S[302535920001000--[[Buttons at bottom--]]]},
			{text = "XBuildMenu",value = GetSetTrans(2,"XBuildMenu"),hint = S[302535920000993--[[Build menu--]]]},
			{text = "InfopanelDlg",value = GetSetTrans(2,"InfopanelDlg"),hint = S[302535920000995--[[Infopanel (selection)--]]]},
			{text = "PinsDlg",value = GetSetTrans(2,"PinsDlg"),hint = S[302535920000997--[[Pins menu--]]]},
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			for i = 1, #choice do
				local value = choice[i].value
				local text = choice[i].text

				if type(value) == "number" then

					if text == "XShortcutsHost" or text == "Console" or text == "ConsoleLog" then
						GetSetTrans(1,text,value)
					else
						GetSetTrans(2,text,value)
					end

					if value == 0 then
						ChoGGi.UserSettings.Transparency[text] = nil
					else
						ChoGGi.UserSettings.Transparency[text] = value
					end

				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				S[302535920000999--[[Transparency has been updated.--]]],
				S[302535920000629--[[UI Transparency--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000629--[[Set UI Transparency--]]],
			hint = S[302535920001002--[[For some reason they went opposite day with this one: 255 is invisible and 0 is visible.--]]],
			custom_type = 4,
		}
	end

	function ChoGGi.MenuFuncs.SetLightsRadius()
		local hr = hr
		local ItemList = {
			{text = Trans(1000121--[[Default--]]),value = Trans(1000121--[[Default--]]),hint = S[302535920001003--[[restart to enable--]]]},
			{text = S[302535920001004--[[01 Lowest (25)--]]],value = 25},
			{text = S[302535920001005--[[02 Lower (50)--]]],value = 50},
			{text = S[302535920001006--[[03 Low (90)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 90},
			{text = S[302535920001007--[[04 Medium (95)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 95},
			{text = S[302535920001008--[[05 High (100)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 100},
			{text = S[302535920001009--[[06 Ultra (200)--]]],value = 200},
			{text = S[302535920001010--[[07 Ultra-er (400)--]]],value = 400},
			{text = S[302535920001011--[[08 Ultra-er (600)--]]],value = 600},
			{text = S[302535920001012--[[09 Ultra-er (1000)--]]],value = 1000},
			{text = S[302535920001013--[[10 Laggy (10000)--]]],value = 10000},
		}

		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end
			if type(value) == "number" then
				if value > 100000 then
					value = 100000
				end
				hr.LightsRadiusModifier = value
				ChoGGi.ComFuncs.SetSavedSetting("LightsRadius",value)
			else
				ChoGGi.UserSettings.LightsRadius = nil
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text),
				S[302535920000633--[[Lights Radius--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001016--[[Set Lights Radius--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hr.LightsRadiusModifier
				.. "\n\n" .. S[302535920001017--[[Turns up the radius for light bleedout, doesn't seem to hurt FPS much.--]]],
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetTerrainDetail()
		local ChoGGi = ChoGGi
		local hr = hr
		local ItemList = {
			{text = Trans(1000121--[[Default--]]),value = Trans(1000121--[[Default--]]),hint = S[302535920001003--[[restart to enable--]]]},
			{text = S[302535920001004--[[01 Lowest (25)--]]],value = 25},
			{text = S[302535920001005--[[02 Lower (50)--]]],value = 50},
			{text = S[302535920001021--[[03 Low (100)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 100},
			{text = S[302535920001022--[[04 Medium (150)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 150},
			{text = S[302535920001008--[[05 High (100)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 100},
			{text = S[302535920001024--[[06 Ultra (200)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 200},
			{text = S[302535920001010--[[07 Ultra-er (400)--]]],value = 400},
			{text = S[302535920001011--[[08 Ultra-er (600)--]]],value = 600},
			{text = S[302535920001012--[[09 Ultraist (1000)--]]],value = 1000,hint = "\n" .. S[302535920001018--[[Above 1000 will add a long delay to loading (and might crash).--]]]},
		}

		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end
			if type(value) == "number" then
				if value > 1000 then
					value = 1000
				end
				hr.TR_MaxChunks = value
				ChoGGi.ComFuncs.SetSavedSetting("TerrainDetail",value)
			else
				ChoGGi.UserSettings.TerrainDetail = nil
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text),
				S[302535920000635--[[Terrain Detail--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000129--[[Set--]]] .. " " .. S[302535920000635--[[Terrain Detail--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hr.TR_MaxChunks .. "\n" .. S[302535920001030--[["Doesn't seem to use much CPU, but load times will probably increase. I've limited max to 1000, if you've got a Nvidia Volta and want to use more memory then do it through the settings file.

And yes Medium is using a higher setting than High..."--]]],
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetVideoMemory()
		local ChoGGi = ChoGGi
		local hr = hr
		local ItemList = {
			{text = Trans(1000121--[[Default--]]),value = Trans(1000121--[[Default--]]),hint = S[302535920001003--[[restart to enable--]]]},
			{text = S[302535920001031--[[1 Crap (32)--]]],value = 32},
			{text = S[302535920001032--[[2 Crap (64)--]]],value = 64},
			{text = S[302535920001033--[[3 Crap (128)--]]],value = 128},
			{text = S[302535920001034--[[4 Low (256)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 256},
			{text = S[302535920001035--[[5 Medium (512)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 512},
			{text = S[302535920001036--[[6 High (1024)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 1024},
			{text = S[302535920001037--[[7 Ultra (2048)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 2048},
			{text = S[302535920001038--[[8 Ultra-er (4096)--]]],value = 4096},
			{text = S[302535920001039--[[9 Ultra-er-er (8192)--]]],value = 8192},
		}

		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end
			if type(value) == "number" then
				hr.DTM_VideoMemory = value
				ChoGGi.ComFuncs.SetSavedSetting("VideoMemory",value)
			else
				ChoGGi.UserSettings.VideoMemory = nil
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text),
				S[302535920000637--[[Video Memory--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001041--[[Set Video Memory Use--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hr.DTM_VideoMemory,
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetShadowmapSize()
		local ChoGGi = ChoGGi
		local hr = hr
		local hint_highest = Trans(6779--[[Warning--]]) .. ": " .. S[302535920001042--[[Highest uses vram (one gig for starter base, a couple for large base).--]]]
		local ItemList = {
			{text = Trans(1000121--[[Default--]]),value = Trans(1000121--[[Default--]]),hint = S[302535920001003--[[restart to enable--]]]},
			{text = S[302535920001043--[[1 Crap (256)--]]],value = 256},
			{text = S[302535920001044--[[2 Lower (512)--]]],value = 512},
			{text = S[302535920001045--[[3 Low (1536)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 1536},
			{text = S[302535920001046--[[4 Medium (2048)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 2048},
			{text = S[302535920001047--[[5 High (4096)--]]] .. " < " .. S[302535920001065--[[Menu Option--]]],value = 4096},
			{text = S[302535920001048--[[6 Higher (8192)--]]],value = 8192},
			{text = S[302535920001049--[[7 Highest (16384)--]]],value = 16384,hint = hint_highest},
		}

		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end

			if type(value) == "number" then
				if value > 16384 then
					value = 16384
				end
				hr.ShadowmapSize = value
				ChoGGi.ComFuncs.SetSavedSetting("ShadowmapSize",value)
			else
				ChoGGi.UserSettings.ShadowmapSize = nil
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice[1].text),
				S[302535920000639--[[Shadow Map--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001051--[[Set Shadowmap Size--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hr.ShadowmapSize .. "\n\n" .. hint_highest .. "\n\n" .. S[302535920001052--[[Max limited to 16384 (or crashing).--]]],
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.HigherShadowDist_Toggle()
		ChoGGi.UserSettings.HigherShadowDist = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.HigherShadowDist)

		hr.ShadowRangeOverride = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowRangeOverride,0,1000000)
		hr.ShadowFadeOutRangePercent = ChoGGi.ComFuncs.ValueRetOpp(hr.ShadowFadeOutRangePercent,30,0)

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.HigherShadowDist),
			S[302535920000645--[[Higher Shadow Distance--]]]
		)
	end

	function ChoGGi.MenuFuncs.HigherRenderDist_Toggle()
		local DefaultSetting = ChoGGi.Consts.HigherRenderDist
		local hint_min = S[302535920001054--[[Minimal FPS hit on large base--]]]
		local hint_small = S[302535920001055--[[Small FPS hit on large base--]]]
		local hint_fps = S[302535920001056--[[FPS hit--]]]
		local ItemList = {
			{text = Trans(1000121--[[Default--]]) .. ": " .. DefaultSetting,value = DefaultSetting},
			{text = 240,value = 240,hint = hint_min},
			{text = 360,value = 360,hint = hint_min},
			{text = 480,value = 480,hint = hint_min},
			{text = 600,value = 600,hint = hint_small},
			{text = 720,value = 720,hint = hint_small},
			{text = 840,value = 840,hint = hint_fps},
			{text = 960,value = 960,hint = hint_fps},
			{text = 1080,value = 1080,hint = hint_fps},
			{text = 1200,value = 1200,hint = hint_fps},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.HigherRenderDist then
			hint = tostring(ChoGGi.UserSettings.HigherRenderDist)
		end

		--callback
		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end
			if type(value) == "number" then
				hr.LODDistanceModifier = value
				ChoGGi.ComFuncs.SetSavedSetting("HigherRenderDist",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.HigherRenderDist,S[302535920000643--[[Higher Render Distance--]]]),
					S[302535920000643--[[Higher Render Distance--]]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000643--[[Higher Render Distance--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hint,
			skip_sort = true,
		}
	end


	--use hr.FarZ = 7000000 for viewing full map with 128K zoom
	do -- CameraFree_Toggle
		-- used to keep pos/lookat/zoom
		local cur_pos, cur_la, zoom
		function ChoGGi.MenuFuncs.CameraFree_Toggle()
			if cameraFly.IsActive() then
				SetMouseDeltaMode(false)
				cameraRTS.Activate(1)
				-- since we used engineHideMouseCursor, we need this as well
				engineShowMouseCursor()
				-- restore pos/zoom
				if cur_pos and cur_la and zoom then
					cameraRTS.SetCamera(cur_pos, cur_la)
					cameraRTS.SetZoom(zoom)
				end
				-- make sure camera uses our settings after fly is done
				ChoGGi.ComFuncs.SetCameraSettings()
				MsgPopup(
					S[302535920001059--[[RTS--]]],
					S[302535920000651--[[Toggle Free Camera--]]]
				)
			else
				cur_pos, cur_la = cameraRTS.GetPosLookAt()
				zoom = cameraRTS.GetZoom()
				cameraFly.Activate(1)
				SetMouseDeltaMode(true)
				-- IsMouseCursorHidden works by checking whatever this sets
				engineHideMouseCursor()
				MsgPopup(
					S[302535920001060--[[Fly--]]],
					S[302535920000651--[[Toggle Free Camera--]]]
				)
			end
			-- resets zoom so...
			ChoGGi.ComFuncs.SetCameraSettings()
		end

		function ChoGGi.MenuFuncs.CameraFollow_Toggle()
			-- it was on the free camera so
			if not mapdata.GameLogic then
				return
			end

			-- turn it off
			if camera3p.IsActive() then
				SetMouseDeltaMode(false)
				cameraRTS.Activate(1)
				engineShowMouseCursor()
				-- reset camera fov settings
				if ChoGGi.cameraFovX then
					camera.SetFovX(ChoGGi.cameraFovX)
				end
				-- show log again if it was hidden
				if ChoGGi.UserSettings.ConsoleToggleHistory then
					cls() --if it's going to spam the log, might as well clear it
					ChoGGi.ComFuncs.ToggleConsoleLog()
				end
				-- restore pos/zoom
				if cur_pos and cur_la and zoom then
					cameraRTS.SetCamera(cur_pos, cur_la)
					cameraRTS.SetZoom(zoom)
				end
				-- reset camera zoom settings
				ChoGGi.ComFuncs.SetCameraSettings()
			else
				-- crashes game if we attach to "false"
				local obj = ChoGGi.ComFuncs.SelObject()
				if not obj then
					return
				end

				-- let user know the camera mode
				MsgPopup(
					S[302535920001061--[[Follow--]]],
					S[302535920000651--[[Toggle Free Camera--]]]
				)

				-- save pos/zoom
				cur_pos, cur_la = cameraRTS.GetPosLookAt()
				zoom = cameraRTS.GetZoom()
				-- we only want to follow one object
				if ChoGGi.LastFollowedObject then
					camera3p.DetachObject(ChoGGi.LastFollowedObject)
				end
				-- save for DetachObject
				ChoGGi.LastFollowedObject = obj
				-- save for fovX reset
				ChoGGi.cameraFovX = camera.GetFovX()
				-- zoom further out unless it's a colonist
				if not obj.base_death_age then
					--up the horizontal fov so we're further away from object
					camera.SetFovX(8400)
				end
				-- consistent zoom level
				cameraRTS.SetZoom(8000)
				-- activate it
				camera3p.Activate(1)
				camera3p.AttachObject(obj)
				camera3p.SetLookAtOffset(point(0,0,-1500))
				camera3p.SetEyeOffset(point(0,0,-1000))
				-- moving mouse moves camera
				camera3p.EnableMouseControl(true)
				-- IsMouseCursorHidden works by checking whatever this sets
				engineHideMouseCursor()

				-- toggle showing console history as console spams transparent something (and it'd be annoying to replace that function)
				if ChoGGi.UserSettings.ConsoleToggleHistory then
					ChoGGi.ComFuncs.ToggleConsoleLog()
				end

				-- if it's a rover then stop the ctrl control mode from being active (from pressing ctrl-shift-f)
				if type(obj.SetControlMode) == "function" then
					obj:SetControlMode(false)
				end
			end
		end

	end -- do

	-- LogCameraPos(print)
	function ChoGGi.MenuFuncs.CursorVisible_Toggle()
		if IsMouseCursorHidden() then
			SetMouseDeltaMode(false)
			engineShowMouseCursor()
		else
			SetMouseDeltaMode(true)
			-- IsMouseCursorHidden works by checking whatever this sets
			engineHideMouseCursor()
		end
	end

	function ChoGGi.MenuFuncs.SetBorderScrolling()
		local DefaultSetting = 5
		local hint_down = S[302535920001062--[[Down scrolling may not work (dependant on aspect ratio?).--]]]
		local ItemList = {
			{text = Trans(1000121--[[Default--]]),value = DefaultSetting},
			{text = 0,value = 0,hint = S[302535920001063--[[disable mouse border scrolling, WASD still works fine.--]]]},
			{text = 1,value = 1,hint = hint_down},
			{text = 2,value = 2,hint = hint_down},
			{text = 3,value = 3},
			{text = 4,value = 4},
			{text = 10,value = 10},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.BorderScrollingArea then
			hint = tostring(ChoGGi.UserSettings.BorderScrollingArea)
		end

		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetSavedSetting("BorderScrollingArea",value)
				ChoGGi.ComFuncs.SetCameraSettings()

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					choice[1].value .. ": " .. S[302535920001064--[[Mouse--]]] .. " " .. S[302535920000647--[[Border Scrolling--]]],
					S[302535920000647--[[Border Scrolling--]]],
					"UI/Icons/IPButtons/status_effects.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000129--[[Set--]]] .. " " .. S[302535920000647--[[Border Scrolling--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hint,
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetCameraLookatDist()
		local DefaultSetting = ChoGGi.Consts.CameraLookatDist
		local ItemList = {
			{text = Trans(1000121--[[Default--]]) .. ": " .. DefaultSetting,value = DefaultSetting},
			{text = 10,value = 10},
			{text = 20,value = 20},
			{text = 30,value = 30},
			{text = 50,value = 50},
			{text = 60,value = 60},
			{text = 70,value = 70},
			{text = 80,value = 80},
			{text = 90,value = 90},
			{text = 100,value = 100},
		}
		local hint = DefaultSetting
		if ChoGGi.UserSettings.CameraLookatDist then
			hint = tostring(ChoGGi.UserSettings.CameraLookatDist)
		end

		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetSavedSetting("CameraLookatDist",value)
				ChoGGi.ComFuncs.SetCameraSettings()

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					choice[1].text .. ": " .. S[302535920001375--[[Bird's Eye--]]],
					S[302535920001375--[[Bird's Eye--]]],
					"UI/Icons/IPButtons/status_effects.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920001375--[[Bird's Eye--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hint,
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetCameraZoom()
		local DefaultSetting = ChoGGi.Consts.CameraZoomToggle
		local ItemList = {
			{text = Trans(1000121--[[Default--]]) .. ": " .. DefaultSetting,value = DefaultSetting},
			{text = 16000,value = 16000},
			{text = 20000,value = 20000},
			{text = 24000,value = 24000, hint = S[302535920001066--[[What used to be the default for this ECM setting--]]]},
			{text = 32000,value = 32000},
			{text = 64000,value = 64000},
			{text = 128000,value = 128000},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings.CameraZoomToggle then
			hint = tostring(ChoGGi.UserSettings.CameraZoomToggle)
		end

		local function CallBackFunc(choice)
			local value = choice[1].value
			if not value then
				return
			end
			if type(value) == "number" then
				ChoGGi.ComFuncs.SetSavedSetting("CameraZoomToggle",value)
				ChoGGi.ComFuncs.SetCameraSettings()

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					choice[1].text,
					S[302535920000649--[[Zoom Distance--]]],
					"UI/Icons/IPButtons/status_effects.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000649--[[Zoom Distance--]]],
			hint = S[302535920000106--[[Current--]]] .. ": " .. hint,
			skip_sort = true,
		}
	end

end
