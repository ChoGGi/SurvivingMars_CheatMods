-- See LICENSE for terms

-- go away... (though there's HexPainter(building) if you wanna have some fun)

function OnMsg.ClassesGenerate()
-- flatten sign to ground
--~ local pos = s:GetPos()
--~ s:SetPos(point(pos:x(),pos:y(),terrain.GetSurfaceHeight(pos)-45))

	if ChoGGi.testing then

		do -- tell me if traits are different
			local ChoGGi = ChoGGi
			local const = const
			local textstart = "<color 255 0 0>"
			local textend = " is different length</color>"
			if #const.SchoolTraits ~= 5 then
				ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = string.format("%sSchoolTraits%s",textstart,textend)
			end
			if #const.SanatoriumTraits ~= 7 then
				ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = string.format("%sSanatoriumTraits%s",textstart,textend)
			end
			local empty_table = empty_table
			local nonerare,rare = GetCompatibleTraits(empty_table,empty_table,empty_table)
--~ 			printC(#nonerare + #rare)
			if #nonerare + #rare ~= 54 then
				ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = string.format("%sGetCompatibleTraits%s",textstart,textend)
			end
		end

		-- for some fucking annoying reason my account settings are sometimes reset, so
		if not ChoGGi.blacklist then
			local as = AccountStorage
			as.Options.AutoPinDomes = false
			as.Options.AutoPinDroneHubs = false
			as.Options.AutoPinFounders = false
			as.Options.AutoPinRareColonists = false
			as.Options.AutoPinRovers = false
			as.Options.Autosave = false
			as.Options.HintsEnabled = false
			as.Shortcuts["ECM.Debug.Delete Object(s).Delete Object(s)"] = {"Ctrl-Shift-D"}
		end

--~ 		-- stop welcome to mars msg for LoadMapForScreenShot
--~ 		ShowStartGamePopup = empty_func
		-- this is just for View Colony Map. it loads map, positions camera to fixed pos, and takes named screenshot
--~ 		ChoGGi.testing.LoadMapForScreenShot("BlankBigTerraceCMix_13")
		function ChoGGi.testing.LoadMapForScreenShot(map)

			-- a mystery without anything visible added to the ground
			g_CurrentMissionParams.idMystery = "BlackCubeMystery"
			local gen = RandomMapGenerator:new()
			gen.BlankMap = map
			-- see PrefabMarker.lua for these
			gen.AnomEventCount = 0
			gen.AnomTechUnlockCount = 0
			gen.AnomFreeTechCount = 0
			gen.FeaturesRatio = 0
			-- load the map
			gen:Generate()
			CreateRealTimeThread(function()
				-- don't fire the rest till map is good n loaded
				WaitMsg("RocketLaunchFromEarth")
				Sleep(350)
				-- hide signs (just in case any are in the currently exposed sector)
				SetSignsVisible(false)
				-- hide all the sector markers
				for sector,_ in pairs(g_MapSectors) do
					if type(sector) ~= "number" and sector.decal then
						sector.decal:SetVisible(false)
					end
				end

				-- lightmodel
				LightmodelPresets.TheMartian1_Night.exterior_envmap = nil
				SetLightmodelOverride(1,"TheMartian1_Night")

				-- larger render dist (we zoom out a fair bit)
				hr.FarZ = 7000000
				-- zoom out for the whole map (more purple)
				local cam_params = {GetCamera()}
				cam_params[4] = 10500
				SetCamera(table.unpack(cam_params))
--~ 				cam_params[4] = 25000

				-- remove some interfaces
				local idx = table.find(terminal.desktop,XTemplate,"OverviewMapCurtains")
				if idx then
					terminal.desktop[idx]:delete()
				end
				for _,value in pairs(Dialogs) do
					if type(value) ~= "string" then
						value:delete()
					end
				end
				-- and a bit more delay
				Sleep(100)

				WriteScreenshot(string.format("AppData/%s.png",map))
			end)
		end

		-- just needs the save file name
		-- ExportSave("NOMODS")
		function ChoGGi.testing.ExportSave(name)
			-- LoadWithBackup needs a thread
			CreateRealTimeThread(function()
				name = string.format("%s.savegame.sav",name)

				-- make sure the folder exists
				AsyncDeletePath("AppData/ExportedSave")
				AsyncCreatePath("AppData/ExportedSave")

				local output_folder = "AppData/ExportedSave/%s"

				local err = MountPack("exported", output_folder:format(name), "create, compress")
				if err then
					return err
				end

				Savegame.LoadWithBackup(name, function(folder)
					local err, files = AsyncListFiles(folder, "*", "relative")
					if err then
						return err
					end
					for i = 1, #files do
						local filename = string.format("%s%s",folder,files[i])
						AsyncCopyFile(filename, output_folder:format(files[i]), "raw")
					end
				end)

				Unmount("exported")
				print("Exported",name)
				return err
			end)
		end
--~ 	local size = io.getsize("D:/SteamGames/steamapps/common/Surviving Mars/!profile/ExportedSave/persist")
--~ 	local str = select(2,
--~ 	AsyncFileToString("D:/SteamGames/steamapps/common/Surviving Mars/!profile/ExportedSave/persist", size, 0, "string", "raw")
--~ 	)
--~ 	print(AsyncDecompress(str))
--~
--~ 	ChoGGi.ComFuncs.Dump(str,nil,"DumpedLua","lua")



		-- benchmarking stuff

		local TickStart = ChoGGi.ComFuncs.TickStart
		local TickEnd = ChoGGi.ComFuncs.TickEnd

		function ChoGGi.testing.TestTableInsert()
			TickStart("TestTableInsert.Tick")
			local t1 = {}
			local c = 0
			for i=0, 10000000 do
				c = c + 1
				t1[c] = i
			end
			TickEnd("TestTableInsert.Tick")
			TickStart("TestTableInsert.Tick")
			local rawset = rawset
			local t2 = {}
			local c2 = 0
			for i=0, 10000000 do
				c2 = c2 + 1
				rawset(t2, c2, i)
			end
			TickEnd("TestTableInsert.Tick")

		end

		-- compare compression speed/size
		function ChoGGi.testing.TestCompress(amount)
			-- uncompressed TableToLuaCode(TranslationTable)
			-- #786351

			-- lz4 compressed to #407672
			-- 50 loops of AsyncDecompress(lz4_data)
			-- 155 ticks
			-- 50 loops of AsyncCompress(lz4_data)
			-- 1404 ticks
			-- 50 loops of compress/decompress
			-- 1512,1491,1491 ticks (did it three times)

			-- zstd compressed to #251660
			-- 50 loops of AsyncDecompress(zstd_data)
			-- 205 ticks
			-- 50 loops of AsyncCompress(zstd_data)
			-- 1508 ticks
			-- 50 loops of compress/decompress
			-- 1650,1676,1691 ticks (did it three times)

			TickStart("TestCompress_lz4.Tick")
			for _ = 1, amount or 50 do
				local _,lz4_data = AsyncCompress(TableToLuaCode(TranslationTable), false, "lz4")
				AsyncDecompress(lz4_data)
			end
			TickEnd("TestCompress_lz4.Tick")

			TickStart("TestCompress_zstd.Tick")
			for _ = 1, amount or 50 do
				local _,zstd_data = AsyncCompress(TableToLuaCode(TranslationTable), false, "zstd")
				AsyncDecompress(zstd_data)
			end
			TickEnd("TestCompress_zstd.Tick")

		end

		-- checking how fast examine is for examining large amounts of objects
		function ChoGGi.testing.TestConcatExamine(amount)
			local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
			TickStart("TestConcatExamine.Total")

			local GetObjects = GetObjects
			local RemoveOldDialogs = ChoGGi.ComFuncs.RemoveOldDialogs
			for _ = 1, amount or 5 do
				TickStart("TestConcatExamine.Tick")
				RemoveOldDialogs("Examine")
				OpenInExamineDlg(GetObjects{})
				TickEnd("TestConcatExamine.Tick")
			end
			RemoveOldDialogs("Examine")

			TickEnd("TestConcatExamine.Total")
		end
		function ChoGGi.testing.TestRandomColour(amount)
			local RandomColour = ChoGGi.ComFuncs.RandomColour
			local RandomColour2 = ChoGGi.ComFuncs.RandomColour2

			TickStart("TestRandomColour.Total")
			for _ = 1, amount or 5 do
				TickStart("TestRandomColour.Tick")
				RandomColour(100000)
				TickEnd("TestRandomColour.Tick")
			end
			TickEnd("TestRandomColour.Total")
			print("\n\n")
			TickStart("TestRandomColour2.Total")
			for _ = 1, amount or 5 do
				TickStart("TestRandomColour2.Tick")
				RandomColour2(100000)
				TickEnd("TestRandomColour2.Tick")
			end
			TickEnd("TestRandomColour2.Total")
		end

		function ChoGGi.testing.TestRandom(amount)
			TickStart("TestRandom.Total")
			local Random = Random
			local Random1 = ChoGGi.ComFuncs.Random

			TickStart("TestRandom.Tick")
				local values = {}
				for i = 1, amount or 10000 do
					values[i] = Random(0,10000)
				end
			TickEnd("TestRandom.Tick")
			print("Random:\n",values)

			TickStart("Random1.Tick")
				values = {}
				for i = 1, amount or 10000 do
					values[i] = Random1(0,10000)
				end
			TickEnd("Random1.Tick")
			print("Random1:\n",values)

			TickEnd("TestRandom.Total")
		end

		--[[
		--for ingame editor

		ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.ComFuncs.ReturnAllNearby(1000))
		ChoGGi.CurObj:SetPos(GetTerrainCursor())

		local Attaches = type(s) == "table" and o.ForEachAttach and s:GetAttaches("Colonist") or ""
		for i = #Attaches, 1, -1 do
				Attaches[i]:Detach()
				Attaches[i]:SetState("idle")
				Attaches[i].city:AddToLabel("Arrivals", Attaches[i])
				Attaches[i].arriving = nil
				Attaches[i]:OnArrival()

				--Attaches[i]:Arrive()
			--end
		end


		function ChoGGi.Temp.ReplaceDome(dome)
			dome = dome or {}
			local olddome = {}
			for Key,Value in pairs(dome) do
				olddome[Key] = Value
			end
			local pos = dome:GetPos()
			dome:delete()

			local newdome = PlaceObj('GeoscapeDome', {
				'template_name', "GeoscapeDome",
				'Pos', pos,
			})
			for Key,Value in pairs(olddome) do
				if Key ~= "entity" and Key ~= "dome_enterances" and Key ~= "id" and Key ~= "my_interior" and Key ~= "waypoint_chains" and Key ~= "handle" then
					newdome[Key] = Value
				end
			end
			newdome:Init()
			newdome:GameInit()
			newdome:InitResourceSpots()
			newdome:InitPassageTables()

			newdome:Rebuild()
			newdome:ApplyToGrids()
			newdome:AddOutskirtBuildings()
			newdome:GenerateWalkablePoints()
			newdome:InitAttaches()
		end

		local Table1 = GetObjects{class = "Destlock"}
		for i = 1, #Table1 do

		local wp = PlaceObject("WayPoint")
		wp:SetPos(Table[i]:GetPos())

		end

		local Table2 = GetObjects{class = "ParSystem"}
		for i = 1, #Table2 do
			Table2[i]:delete()
		end



		dofolder_files("CommonLua/UI/UIDesignerData")

		ChoGGi.ComFuncs.SaveOrigFunc("CargoShuttle","Idle")
		function CargoShuttle:Idle()
		print(self.command)
			if self.ChoGGi_FollowMouseShuttle and self.command == "Home" or self.command == "Idle" then
				self:SetCommand("ChoGGi_FollowMouse")
			end
			return ChoGGi.OrigFuncs.CargoShuttle_Idle(self)
		end

		for message, _ in pairs(ThreadsMessageToThreads) do
			--print(message)
			--print(threads)
			if message.action and message.action.class == "SA_WaitMsg" then
			print(message.ip)
			end
		end
		for thread in pairs(ThreadsRegister) do
			print(thread)
		end

		function ChoGGi.ComFuncs.StartDebugger()
			config.Haerald = {
				platform = GetDebuggeePlatform(),
				ip = "localhost",
				RemoteRoot = "",
				ProjectFolder = "",
			}
			SetupRemoteDebugger(
				config.Haerald.ip,
				config.Haerald.RemoteRoot,
				config.Haerald.ProjectFolder
			)
			StartDebugger()
		--~	 ProjectSync()
		end
		--]]

	---------
		print("ChoGGi.testing")

	--~	 function OnMsg.ClassesGenerate()

	--~		 local config = config
	--~		 config.TraceEnable = true
	--~		 Platform.editor = true
	--~		 config.LuaDebugger = true
	--~		 GlobalVar("outputSocket", false)
	--~		 dofile("CommonLua/Core/luasocket.lua")
	--~		 dofile("CommonLua/Core/luadebugger.lua")
	--~		 dofile("CommonLua/Core/luaDebuggerOutput.lua")
	--~		 dofile("CommonLua/Core/ProjectSync.lua")

			--fixes error msg from the human centipede bug
		--~	 SaveOrigFunc("Unit","Goto")
		--~ function Unit:Goto(...)
		--~	 if ... then
		--~		 return ChoGGi_OrigFuncs.Unit_Goto(self, ...)
		--~	 end
		--~ end

		 ------
	--~	 end

	--~	 function OnMsg.ClassesPreprocess()
			--fix the arcology dome spot
			--[[
			SaveOrigFunc("SpireBase","GameInit")
			function SpireBase:GameInit()
				local dome = IsObjInDome(self)
				if self.spire_frame_entity ~= "none" and IsValidEntity(self.spire_frame_entity) then
					local frame = PlaceObject("Shapeshifter")
					frame:ChangeEntity(self.spire_frame_entity)
					local spot = dome:GetNearestSpot("idle", "Spireframe", self)

					local pos = self:GetSpotPos(spot or 1)

					frame:SetAttachOffset(pos - self:GetPos())
					self:Attach(frame, self:GetSpotBeginIndex("Origin"))
				end
			end
			--]]
			------
	--~	 end --ClassesPreprocess

		--where we add new BuildingTemplates
	--~	 function OnMsg.ClassesPostprocess()
	--~		 ------
	--~	 end

	--~	 function OnMsg.ClassesBuilt()

			--add an overlay for dead rover
			--[[
			SaveOrigFunc("PinsDlg","GetPinConditionImage")
			function PinsDlg:GetPinConditionImage(obj)
				local ret = ChoGGi.OrigFuncs.PinsDlg_GetPinConditionImage(self,obj)
				if obj.command == "Dead" and not obj.working then
					print(obj.class)
					return "UI/Icons/pin_not_working.tga"
				else
					return ret
				end
			end
			--]]

		--[[
			--don't expect much, unless you've got a copy of Haerald around
			function luadebugger:Start()
			if self.started then
				print("Already started")
				return
			end
			print("Starting the Lua debugger...")
			DebuggerInit()
			DebuggerClearBreakpoints()
			self.started = true
			local server = self.server
			local debugger_port = controller_port + 2
			controller_host = not Platform.pc and config.Haerald and config.Haerald.ip or "localhost"
			server:connect(controller_host, debugger_port)
			server:update()
			if not server:isconnected() then
				if Platform.pc then
					local processes = os.enumprocesses()
					local running = false
					for i = 1, #processes do
						if string.find(processes[i], "Haerald.exe") then
							running = true
							break
						end
					end
					if not running then
						local os_path = ConvertToOSPath(config.LuaDebuggerPath)
						local exit_code, std_out, std_error = os.exec(os_path)
						if exit_code ~= 0 then
						print("Could not launch Haerald Debugger from:", os_path, "\n\nExec error:", std_error)

							self:Stop()
							return
						end
					end
				end
				local total_timeout = 6000
				local retry_timeout = Platform.pc and 100 or 2000
				local steps_before_reset = Platform.pc and 10 or 1
				local num_retries = total_timeout / retry_timeout
				for i = 1, num_retries do
					server:update()
					if not server:isconnected() then
						if not server:isconnecting() or i % steps_before_reset == 0 then
							server:close()
							server:connect(controller_host, debugger_port, retry_timeout)
						end
						os.sleep(retry_timeout)
					end
				end
				if not server:isconnected() then
					print("Could not connect to debugger at " .. controller_host .. ":" .. debugger_port)
					self:Stop()
					return
				end
			end
			server.timeout = 5000
			self.watches = {}
			self.handle_to_obj = {}
			self.obj_to_handle = {}
			local PathRemapping
			if not Platform.pc then
				PathRemapping = config.Haerald and config.Haerald.PathRemapping or {}
			else
				PathRemapping = config.Haerald and config.Haerald.PathRemapping or {
					CommonLua = "CommonLua",
					Lua = Platform.cmdline and "" or "Lua",
					Data = Platform.cmdline and "" or "Data",
					Dlc = Platform.cmdline and "" or "Data/../Dlc",
					HGO = "HGO",
					Build = "CommonLua/../Tools/Build",
					Server = "Lua/../Tools/Server/Project",
					Shaders = "Shaders",
					ProjectShaders = "ProjectShaders"
				}
				for key, value in pairs(PathRemapping) do
					if value ~= "" then
						local game_path = value .. "/."
						local os_path, failed = ConvertToOSPath(game_path)
						if failed or not io.exists(os_path) then
							os_path = ""
						end
						PathRemapping[key] = os_path
					end
				end
			end
				local FileDictionaryPath = {
					"CommonLua",
					"Lua",
					"Dlc",
					"HGO",
					"Server",
					"Build"
				}
				local FileDictionaryExclude = {
					".svn",
					"__load.lua",
					".prefab.lua",
					".designer.lua",
					"/UIDesignerData/",
					"/Storage/"
				}
				local FileDictionaryIgnore = {
					"^exec$",
					"^items$",
					"^filter$",
					"^action$",
					"^state$",
					"^f$",
					"^func$",
					"^no_edit$"
				}
				local SearchExclude = {
					".svn",
					"/Prefabs/",
					"/Storage/",
					"/Collections/",
					"/BuildCache/"
				}
			local TablesToKeys = {}
				local TableDictionary = {
					"const",
					"config",
					"hr",
					"Platform",
					"EntitySurfaces",
					"terrain",
					"ShadingConst",
					"table",
					"coroutine",
					"debug",
					"io",
					"os",
					"string"
				}
			for i = 1, #TableDictionary do
				local name = TableDictionary[i]
				local t = rawget(_G, name)
				local keys = type(t) == "table" and table.keys(t) or ""
				if type(keys) == "table" then
					local vars = EnumVars(name .. ".")
					for key in pairs(vars) do
						keys[#keys + 1] = key
					end
					if #keys > 0 then
						table.sort(keys)
						TablesToKeys[name] = keys
					end
				end
			end
			local InitPacket = {
				Event = "InitPacket",
				PathRemapping = PathRemapping,
				ExeFileName = string.gsub(GetExecName(), "/", "\\"),
				ExePath = string.gsub(GetExecDirectory(), "/", "\\"),
				CurrentDirectory = Platform.pc and string.gsub(GetCWD(), "/", "\\") or "",
				FileDictionaryPath = FileDictionaryPath,
				FileDictionaryExclude = FileDictionaryExclude,
				FileDictionaryIgnore = FileDictionaryIgnore,
				SearchExclude = SearchExclude,
				TablesToKeys = TablesToKeys,
				ConsoleHistory = rawget(_G, "LocalStorage") and LocalStorage.history_log or {}
			}
			InitPacket.Platform = GetDebuggeePlatform()
		--~	 if Platform.console or Platform.ios then
		--~		 InitPacket.UploadData = "true"
		--~		 InitPacket.UploadPartSize = config.Haerald and config.Haerald.UploadPartSize or 2097152
		--~		 InitPacket.UploadFolders = config.Haerald and config.Haerald.UploadFolders or {}
		--~	 end
			local project_name = const.HaeraldProjectName
			if not project_name then
				local dir, filename, ext = SplitPath(GetExecName())
				project_name = filename or "unknown"
			end
			InitPacket.ProjectName = project_name
			self:Send(InitPacket)
			for i = 1, 500 do
				if self:DebuggerTick() and not self.init_packet_received then
					os.sleep(10)
				end
			end
		--~	 if not self.init_packet_received then
		--~		 print("Didn't receive initialization packages (maybe Haerald is taking too long to upload the files?)")
		--~		 self:Stop()
		--~		 return
		--~	 end
			SetThreadDebugHook(DebuggerSetHook)
			DebuggerSetHook()
		--~	 if DebuggerTracingEnabled() then
				do
					local coroutine_resume, coroutine_status = coroutine.resume, coroutine.status
		--~			 SetThreadResumeFunc(function(thread)
					CreateRealTimeThread(function(thread)
						collectgarbage("stop")
						DebuggerPreThreadResume(thread)
						local r1, r2 = coroutine.resume(thread)
						local time = DebuggerPostThreadYield(thread)
						collectgarbage("restart")
						if coroutine_status(thread) ~= "suspended" then
							DebuggerClearThreadHistory(thread)
						end
						return r1, r2
					end)
				end
		--~	 else
		--~	 end
			DeleteThread(self.update_thread)
			self.update_thread = CreateRealTimeThread(function()
				print("Debugger connected.")
				while self:DebuggerTick() do
					Sleep(25)
				end
				self:Stop()
			end)
		--~	 if Platform.console then
		--~		 RemoteCompileRequestShaders()
		--~	 end
		end
		--]]

			------
	--~	 end

	--~	 function ChoGGi.MsgFuncs.Testing_ChoGGi_Loaded()

	--~		 ------

	--~	 end
	end

	GlobalVar("painted_hexes", false)
	GlobalVar("painted_hexes_thread", false)
	function PaintHexArray(arr, mid_hex_pt) --paints zero based hex shapes (such as from GetEntityHexShapes)
		if IsValidThread(painted_hexes_thread) then
			DeleteThread(painted_hexes_thread)
		end

		if painted_hexes then
			for i = 1, #painted_hexes do
				painted_hexes[i]:delete()
			end
			painted_hexes = false
		end
		if arr then
			painted_hexes_thread = CreateRealTimeThread(function()
				local last_q, last_r
				painted_hexes = {}

				while true do
					local q, r
					if mid_hex_pt then
						q, r = mid_hex_pt:x(), mid_hex_pt:y()
					else
						q, r = WorldToHex(GetTerrainCursor())
					end
					if last_q ~= q or last_r ~= r then
						for i = 1, #arr do
							local q_i, r_i = q + arr[i]:x(), r + arr[i]:y()
							local c = painted_hexes[i] or ChoGGi_HexSpot:new()
							c:SetPos(point(HexToWorld(q_i, r_i)))
	--~ 							c:SetRadius(const.GridSpacing/2)
	--~ 							c:SetColorModifier(RGBA(100, 255, 100, 0))
							painted_hexes[i] = c
						end
						last_q = q
						last_r = r
					end
					Sleep(50)
				end
			end)
		end
	end

	--~ HexPainter()
	--~ HexPainter(GetEntityHexShapes(s.entity))
	--~ HexPainter(GetEntityBuildShape(s.entity))
	--~ HexPainter(GetEntityInverseBuildShape(s.entity))
	--~ HexPainter(GetEntityCombinedShape(s.entity))

	-- allows you to redefine hex shapes (right-click offsets the hex grid)
	local HexPainter_toggle
	function HexPainter(arr)
		if HexPainter_toggle then
			HexPainter_toggle = nil
			Dialogs.InGameInterface:SetMode("selection")
		else
			HexPainter_toggle = true
			Dialogs.InGameInterface:SetMode("hex_painter", {res_arr = arr, hex_mid_pt = point(WorldToHex(GetTerrainCursor()))})
		end
	end

	GlobalVar("HexPainterResultArr", false)

	DefineClass.HexPainterModeDialog = {
		__parents = { "InterfaceModeDialog" },
		mode_name = "hex_painter",

		hex_mid_pt = false,
		hex_mid_circle = false,
		res_arr = false,
	}

	function HexPainterModeDialog:Init()
		self:SetFocus()
		self.res_arr = self.context.res_arr or {}
		self.hex_mid_pt = self.context.hex_mid_pt
	end

	function HexPainterModeDialog:Open(...)
		InterfaceModeDialog.Open(self, ...)
	--~	 self:PaintMid()
		PaintHexArray(self.res_arr, self.hex_mid_pt)
	end

	function HexPainterModeDialog:Close(...)
		InterfaceModeDialog.Close(self, ...)
		HexPainterResultArr = self.res_arr
		PaintHexArray()
		if self.hex_mid_circle then
			self.hex_mid_circle:delete()
		end
	end

	--~ function HexPainterModeDialog:OnMouseButtonDown(pt, button)
	function HexPainterModeDialog:OnMouseButtonDown(_, button)
		if button == "L" then
			local p = point(WorldToHex(GetTerrainCursor()))
			if self.hex_mid_pt then
				p = p - self.hex_mid_pt
			end

			local idx = table.find(self.res_arr, p)
			if idx then
				table.remove(self.res_arr, idx)
			else
				table.insert(self.res_arr, p)
			end

			PaintHexArray(self.res_arr, self.hex_mid_pt)

			return "break"
		elseif button == "R" then
			if self.hex_mid_pt then
				for i = 1, #self.res_arr do
					self.res_arr[i] = self.res_arr[i] + self.hex_mid_pt
				end


			end
			self.hex_mid_pt = point(WorldToHex(GetTerrainCursor()))

			if self.hex_mid_pt then
				for i = 1, #self.res_arr do
					self.res_arr[i] = self.res_arr[i] - self.hex_mid_pt
				end
				self:PaintMid()
			end


			PaintHexArray(self.res_arr, self.hex_mid_pt)
			return "break"
		end
	end

	function HexPainterModeDialog:PaintMid()
		if self.hex_mid_circle then
			self.hex_mid_circle:delete()
		end
		if self.hex_mid_pt then
			self.hex_mid_circle = ChoGGi_HexSpot:new()
			self.hex_mid_circle:SetPos(point(HexToWorld(self.hex_mid_pt:x(), self.hex_mid_pt:y())))
				self.hex_mid_circle:SetColorModifier(RGB(100, 255, 100))
	--~ 			self.hex_mid_circle:SetRadius(const.GridSpacing/2)
		end
	end

end
