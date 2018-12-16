-- See LICENSE for terms

-- go away... (mostly just benchmarking funcs, though there is the func i use for "Map Images Pack")

function OnMsg.ClassesGenerate()
-- flatten sign to ground
--~ local pos = s:GetPos()
--~ s:SetPos(point(pos:x(),pos:y(),terrain.GetSurfaceHeight(pos)-45))

	if ChoGGi.testing then

		local orig = XText.ParseText
		function XText:ParseText(...)
			local varargs = ...
			local ret
			if not procall(function()
				ret = orig(self,varargs)
			end) then
				ChoGGi.ComFuncs.Dump(self.text,"w","ParseText","lua",nil,true)
			end
			return ret
		end

--~ 		-- work on these persist errors
--~ 		function PersistGame(folder)
--~ 			collectgarbage("collect")
--~ 			Msg("SaveGame")
--~ 			rawset(_G, "__error_table__", {})
--~ 			local err = EngineSaveGame(folder .. "persist")
--~ 			for i = 1, #__error_table__ do
--~ 				local err = __error_table__[i]
--~ 				print("Persist error:", err.error or "unknown")
--~ 				print("Persist stack:")
--~ 				for j = 1, #err do
--~ 					print("   ", tostring(err[j]))
--~ 				end
--~ 			end
--~ 			ex(__error_table__)
--~ 			return err
--~ 		end

--~ 		local orig_XImage_DrawContent = XImage.DrawContent
--~ 		local RetName = ChoGGi.ComFuncs.RetName
--~ 		local FileExists = ChoGGi.ComFuncs.FileExists
--~ 		function XImage:DrawContent(...)
--~ 			local image = self:GetImage()
--~ 			-- unless it is bitching about memorysavegame :)
--~ 			if image ~= "" and not image:find("memorysavegame") and not FileExists(image) then
--~ 				print(RetName(self.parent),image,"DC")
--~ 			end
--~ 			return orig_XImage_DrawContent(self,...)
--~ 		end

		-- for some annoying reason my account settings are sometimes reset, so (probably something to do with some pop funcs I block)
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
		-- this is just for Map Images Pack. it loads the map, positions camera to fixed pos, and takes named screenshot
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
				local g_MapSectors = g_MapSectors
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

				-- remove black curtains on the sides
				table.remove_entry(terminal.desktop,XTemplate,"OverviewMapCurtains")
				-- and the rest of the ui
				local Dialogs = Dialogs
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

		function ChoGGi.testing.TestTableIterate()
			local list = MapGet(true)
			TickStart("TestTableIterate.1.Tick")
			for _ = 1, 1000 do
				for _ = 1, #list do
				end
			end
			TickEnd("TestTableIterate.1.Tick")

			TickStart("TestTableIterate.2.Tick")
			for _ = 1, 1000 do
				for _,_ in ipairs(list) do
				end
			end
			TickEnd("TestTableIterate.2.Tick")
		end

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

		function ChoGGi.testing.TestExamine(amount)
			local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
			TickStart("TestExamine.Total")

			local MapGet = MapGet
			local CloseDialogs = ChoGGi.ComFuncs.CloseDialogs
			for _ = 1, amount or 5 do
				TickStart("TestExamine.Tick")
				CloseDialogs("Examine")
				OpenInExamineDlg(MapGet(true))
				TickEnd("TestExamine.Tick")
			end
			CloseDialogs("Examine")

			TickEnd("TestExamine.Total")
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
				TickStart("TestRandomColour.2.Tick")
				RandomColour2(100000)
				TickEnd("TestRandomColour.2.Tick")
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

			TickStart("Random.1.Tick")
				values = {}
				for i = 1, amount or 10000 do
					values[i] = Random1(0,10000)
				end
			TickEnd("Random.1.Tick")
			print("Random1:\n",values)

			TickEnd("TestRandom.Total")
		end

		--[[
		--for ingame editor

		ChoGGi.ComFuncs.OpenInExamineDlg(ChoGGi.ComFuncs.ReturnAllNearby(1000))
		ChoGGi.CurObj:SetPos(GetTerrainCursor())

		if type(s) == "table" and s.ForEachAttach then
			s:ForEachAttach("Colonist",function(a)
				a:Detach()
				a:SetState("idle")
				a.city:AddToLabel("Arrivals", a)
				a.arriving = nil
				a:OnArrival()

				--a:Arrive()
			end)
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

		local ThreadsMessageToThreads = ThreadsMessageToThreads
		for message, _ in pairs(ThreadsMessageToThreads) do
			--print(message)
			--print(threads)
			if message.action and message.action.class == "SA_WaitMsg" then
			print(message.ip)
			end
		end
		local ThreadsRegister = ThreadsRegister
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

	end -- ChoGGi.testing

end
