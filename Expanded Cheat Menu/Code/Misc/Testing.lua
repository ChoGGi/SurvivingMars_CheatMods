-- See LICENSE for terms

-- go away... (mostly just benchmarking funcs, though there is the func i use for "Map Images Pack" to make them)

--~ ChoGGi.ComFuncs.TickStart("Tick.1")
--~ ChoGGi.ComFuncs.TickEnd("Tick.1")

--~ -- for some reason this doesn't work on the selection panel when it's in Generate...
--~ if Mods.ChoGGi_testing then
--~ 	-- centred hud
--~ 	local GetScreenSize = UIL.GetScreenSize
--~ 	local margins = box(2560,0,2560,0)
--~ 	local orig_GetSafeMargins = GetSafeMargins
--~ 	function GetSafeMargins(win_box)
--~ 		if win_box then
--~ 			return orig_GetSafeMargins(win_box)
--~ 		end
--~ 		-- if lookup table doesn't have width we fire orginal func
--~ 		return GetScreenSize():x() == 5760 and margins or orig_GetSafeMargins()
--~ 	end
--~ end

local ChoGGi = ChoGGi
if not ChoGGi.testing then
	return
end

--~ 	local orig_GetStack = GetStack
--~ 	function GetStack(...)
--~ 		print("GetStack:",...)
--~ 		return orig_GetStack(...)
--~ 	end
do -- TraceCall/Trace (commented out in CommonLua\PropertyObject.lua)
--~ g_traceMeta
--~ g_traceEntryMeta
	-- needs to be true for traces to be active (see CommonLua\Classes\StateObject.lua)
	StateObject.so_debug_triggers = true
	-- CommonLua\Movable.lua
	function Movable:SetSpeed(speed)
		pf.SetSpeed(self, speed)
	end

	local GetStack = GetStack
	local GameTime = GameTime
	local rawget,rawset = rawget,rawset
	local setmetatable = setmetatable
	local table_remove = table.remove
	local table_insert = table.insert

	function PropertyObject:TraceCall(member)
		print("PropertyObject:TraceCall",self.class)
		local orig_member_fn = self[member]
		self[member] = function(self, ...)
			self:Trace("[Call]", member, GetStack(2), ...)
			return orig_member_fn(self, ...)
		end
	end
	function PropertyObject:Trace(...)
		print("PropertyObject:Trace",self.class)
		local t = rawget(self, "trace_log")
		if not t then
			t = {}
			setmetatable(t, g_traceMeta)
			rawset(self, "trace_log", t)
		end
		local threshold = GameTime() - (3000)
		while #t >= 50 and threshold > t[#t][1] do
			table_remove(t)
		end
		local data = {
			GameTime(),
			...
		}
		setmetatable(data, g_traceEntryMeta)
		table_insert(t, 1, data)
	end

	function SetCommandErrorChecks(self, command, ...)
		print("SetCommandErrorChecks",self.class)
		local destructors = self.command_destructors
		if command == "->Idle" and destructors and destructors[1] > 0 then
			print("Command", self.class .. "." .. tostring(self.command), "remaining destructors:")
			for i = 1, destructors[1] do
				local destructor = destructors[i + 1]
				local info = debug.getinfo(destructor, "S") or empty_table
				local source = info.source or "Unknown"
				local line = info.linedefined or -1
				printf("\t%d. %s(%d)", i, source, line)
			end
			error(string.format("Command %s.%s did not pop its destructors.", self.class, tostring(self.command)), 2)
		end
		if command and command ~= "->Idle" then
			if type(command) ~= "function" and not self:HasMember(command) then
				error(string.format("Invalid command %s:%s", self.class, tostring(command)), 3)
			end
			if IsBeingDestructed(self) then
				error(string.format("%s:SetCommand('%s') called from Done() or delete()", self.class, tostring(command)), 3)
			end
		end
		self.command_call_stack = GetStack(3)
		if self.trace_setcmd then
			if self.trace_setcmd == "log" then
				self:Trace("SetCommand", tostring(command), self.command_call_stack, ...)
			else
				error(string.format("%s:SetCommand(%s) time %d, old command %s", self.class, concat_params(", ", tostring(command), ...), GameTime(), tostring(self.command)), 3)
			end
		end
	end

end -- do


--~ 		-- ParseText is picky about the text it'll parse
--~ 		local orig = XText.ParseText
--~ 		function XText:ParseText(...)
--~ 			local varargs = ...
--~ 			local ret
--~ 			if not procall(function()
--~ 				ret = orig(self,varargs)
--~ 			end) then
--~ 				ChoGGi.ComFuncs.Dump(self.text,"w","ParseText","lua",nil,true)
--~ 			end
--~ 			return ret
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
	as.CompletedTutorials = as.CompletedTutorials or {}
	as.CompletedTutorials.Tutorial1 = true
	as.Shortcuts["ECM.Debug.Delete Object(s)"] = {"Ctrl-Shift-D"}
end

function ChoGGi.testing.MissingStrings(string_limit)
	-- amount of entries in the CSV file
	string_limit = string_limit or 1550

	local Translate = ChoGGi.ComFuncs.Translate
	local missing_strs = {}
	local c = 0
	-- we need to pad some zeros
--~ 			local pad_str = "30253592000%s%s"
	local function TransZero(pad,first,last)
		for i = first, last do
			if i > string_limit then
				break
			end
			local num = tonumber("30253592000" .. pad .. i)
			local str = Translate(num)
			-- Missing text is from TDevModeGetEnglishText
			if str == "Missing text" then
				c = c + 1
				missing_strs[c] = num
			end
		end
	end

	-- 0000 = 0 if we try to pass as a number (as well as 001 to 1)
	TransZero("000",0,9)
	TransZero("00",10,99)
	TransZero(0,100,999)
	TransZero("",1000,9999)

	if #missing_strs > 0 then
		ex(missing_strs)
	end
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
		while not Dialogs.PopupNotification do
			Sleep(500)
		end
		-- close welcome to mars msg
		Dialogs.PopupNotification:Close()

		-- hide signs (just in case any are in the currently exposed sector)
		SetSignsVisible(false)
		-- hide all the sector markers
		local g_MapSectors = g_MapSectors
		for sector in pairs(g_MapSectors) do
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

		WriteScreenshot("AppData/" .. map .. ".png")
	end)
end

-- just needs the save file name
-- ExportSave("NOMODS")
function ChoGGi.testing.ExportSave(name)
	-- LoadWithBackup needs a thread
	CreateRealTimeThread(function()
		name = name .. ".savegame.sav"

		-- make sure the folder exists
		AsyncDeletePath("AppData/ExportedSave")
		AsyncCreatePath("AppData/ExportedSave")

		local err = MountPack("exported", "AppData/ExportedSave/" .. name, "create, compress")
		if err then
			print(err)
			return
		end
		Savegame.LoadWithBackup(name, function(folder)
			local err, files = AsyncListFiles(folder, "*", "relative")
			if err then
				print(err)
				return
			end
			for i = 1, #files do
				local file = files[i]
				AsyncCopyFile(folder .. file, "AppData/ExportedSave/" .. file, "raw")
			end
		end)

		Unmount("exported")
		print("Exported",name)
	end)
end
--[[
MountPack("exported", "AppData/ExportedSave/NAME.savegame.sav")
CreateRealTimeThread(function()
Savegame.LoadWithBackup("NAME.savegame.sav", function(folder,...)
print(folder,...)
local err, files = io.listfiles(folder, "*", "relative")
if err then
	print(err)
end
for i = 1, #files do
	print(folder,files[i])
end
end)
end)
--]]
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

function ChoGGi.testing.TestToStr()
	local tostring = tostring

	TickStart("TestToStr.Tick.1")
	for _ = 1,1000000 do
		local num = 12345
		num = num .. ""
	end
	TickEnd("TestToStr.Tick.1")

	TickStart("TestToStr.Tick.2")
	for _ = 1,1000000 do
		local num = 12345
		num = tostring(num)
	end
	TickEnd("TestToStr.Tick.2")

end

function ChoGGi.testing.TestAttaches(obj)
	obj = obj or ChoGGi.ComFuncs.SelObject()
	if not IsValid(obj) then
		print("TestAttaches invalid obj")
		return
	end

	TickStart("TestAttaches.Tick.1")
	for _ = 1,1000 do
		local attaches = obj:GetAttaches() or ""
		for i = 1, #attaches do
			local a = attaches[i]
			if a.handle then
			end
		end
	end
	TickEnd("TestAttaches.Tick.1")

	TickStart("TestAttaches.Tick.2")
	for _ = 1,1000 do
		obj:ForEachAttach(function(a)
			if a.handle then
			end
		end)
	end
	TickEnd("TestAttaches.Tick.2")
end

function ChoGGi.testing.TextExamine()
	local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
	local WaitMsg = WaitMsg
	local list = MapGet(true)

	CreateRealTimeThread(function()
		TickStart("TextExamine.Tick")
		for _ = 1, 10 do
			TickStart("TextExamine.1.Tick")
			local dlg = OpenInExamineDlg(list)
			WaitMsg("OnRender")
			dlg:delete()
			TickEnd("TextExamine.1.Tick")
		end
		TickEnd("TextExamine.Tick")
	end)

end

function ChoGGi.testing.TestTableIterate()
	local list = MapGet(true)

	TickStart("TestTableIterate.1.Tick")
	for _ = 1, 1000 do
		for _ = 1, #list do
		end
	end
	TickEnd("TestTableIterate.1.Tick")

	local ipairs = ipairs
	TickStart("TestTableIterate.2.Tick")
	for _ = 1, 1000 do
		for _ in ipairs(list) do
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

function ChoGGi.testing.TestRandomColour(amount)
	local RandomColour = ChoGGi.ComFuncs.RandomColour
	local RandomColour2 = ChoGGi.ComFuncs.RandomColour2

	TickStart("TestRandomColour.1.Total")
	for _ = 1, amount or 5 do
		TickStart("TestRandomColour.1.Tick")
		RandomColour(100000)
		TickEnd("TestRandomColour.1.Tick")
	end
	TickEnd("TestRandomColour.1.Total")

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

print("ChoGGi.testing")

------------------------------------------------------------------------------------------
--~ 	function OnMsg.ClassesGenerate()

--~ 	 end -- ClassesGenerate
------------------------------------------------------------------------------------------
--~ 	function OnMsg.ClassesPreprocess()

--~ 		-- fix the arcology dome spot
--~ 		SaveOrigFunc("SpireBase","GameInit")
--~ 		function SpireBase:GameInit()
--~ 			local dome = IsObjInDome(self)
--~ 			if self.spire_frame_entity ~= "none" and IsValidEntity(self.spire_frame_entity) then
--~ 				local frame = PlaceObject("Shapeshifter")
--~ 				frame:ChangeEntity(self.spire_frame_entity)
--~ 				local spot = dome:GetNearestSpot("idle", "Spireframe", self)

--~ 				local pos = self:GetSpotPos(spot or 1)

--~ 				frame:SetAttachOffset(pos - self:GetPos())
--~ 				self:Attach(frame, self:GetSpotBeginIndex("Origin"))
--~ 			end
--~ 		end
------------------------------------------------------------------------------------------
--~ 		end -- ClassesPreprocess

--~ 		-- where we add new BuildingTemplates
--~ 		function OnMsg.ClassesPostprocess()

--~ 		end -- ClassesPostprocess
------------------------------------------------------------------------------------------
--~ 	function OnMsg.ClassesBuilt()

--~ 		-- add an overlay for dead rover
--~ 		SaveOrigFunc("PinsDlg","GetPinConditionImage")
--~ 		function PinsDlg:GetPinConditionImage(obj)
--~ 			local ret = ChoGGi.OrigFuncs.PinsDlg_GetPinConditionImage(self,obj)
--~ 			if obj.command == "Dead" and not obj.working then
--~ 				print(obj.class)
--~ 				return "UI/Icons/pin_not_working.tga"
--~ 			else
--~ 				return ret
--~ 			end
--~ 		end

--~ local list = {}
--~ local c = 0
--~ local dlg
--~ local table_iclear = table.iclear
--~ local function hookTick(...)
--~ 	if not dlg then
--~ 		dlg = ChoGGi.ComFuncs.OpenInExamineDlg(list)
--~ 		dlg:EnableAutoRefresh()
--~ 	end
--~ 	c = c + 1
--~ 	list[c] = ...
--~ 	if c > 100 then
--~ 		table_iclear(list)
--~ 		c = 0
--~ 	end
--~ end

--~ function SetThreadDebugHookX(hook)
--~ 	local set_hook = hook or debug.sethook
--~ 	for thread in pairs(ThreadsRegister) do
--~ 		set_hook(thread,hookTick,"c",10)
--~ 	end
--~ 	ThreadsEnableDebugHook(hook)
--~ 	ThreadDebugHook = hook or false
--~ end
--~ function DisableThreadDebugHookX(hook)
--~ 	local set_hook = hook or debug.sethook
--~ 	for thread in pairs(ThreadsRegister) do
--~ 		set_hook(thread)
--~ 	end
--~ 	ThreadsEnableDebugHook(hook)
--~ 	ThreadDebugHook = hook or false
--~ end

--~ if false then
--~ 	SetThreadDebugHookX(DebuggerSetHook)
--~ 	DebuggerSetHook()
--~ -- ThreadDebugHook
--~ end

-- load needed debug files
--~ 		local config = config
--~ 		config.TraceEnable = true
--~ 		config.LuaDebugger = true
--~ 		FirstLoad = true
--~ 		Loading = true
--~ 		Platform.developer = true
--~ 		dofile("CommonLua/Core/luasocket.lua")
--~ 		dofile("CommonLua/Core/luadebugger.lua")
--~ 		dofile("CommonLua/Core/luaDebuggerOutput.lua")
--~ 		dofile("CommonLua/Core/ProjectSync.lua")
--~ 		Platform.developer = false
--~ 		FirstLoad = false
--~ 		Loading = false
--[[
	-- don't expect much, unless you've got a copy of Haerald around
	GlobalVar("outputSocket", false)
	local function Mine_luadebugger_Start(self)
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
					print("Could not launch Haerald Debugger from:", os_path, "\n\nExec error:", std_error , std_out)

print(0,"stop")
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
print(1,"stop")
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
--~ 				local dir, filename, ext = SplitPath(GetExecName())
			local _, filename = SplitPath(GetExecName())
			project_name = filename or "unknown"
		end
		InitPacket.ProjectName = project_name
		self:Send(InitPacket)
		for _ = 1, 500 do
			if self:DebuggerTick() and not self.init_packet_received then
				os.sleep(10)
			end
		end
		SetThreadDebugHook(DebuggerSetHook)
		DebuggerSetHook()
--~ ThreadDebugHook
--~ 			local coroutine_resume, coroutine_status = coroutine.resume, coroutine.status
--~ 			local IsValidThread = IsValidThread
--~ 			self.garbage_thread = CreateRealTimeThread(function(thread)
--~ 				collectgarbage("stop")
--~ 				DebuggerPreThreadResume(thread)
--~ 				local r1, r2 = coroutine_resume(thread)
--~ 				local time = DebuggerPostThreadYield(thread)
--~ 				collectgarbage("restart")
--~ 				if coroutine_status(thread) ~= "suspended" then
--~ 					DebuggerClearThreadHistory(thread)
--~ 				end
--~ 				return r1, r2
--~ 			end)

		DeleteThread(self.update_thread)
		self.update_thread = CreateRealTimeThread(function()
			print("Debugger connected.")
			while self:DebuggerTick() do
				Sleep(25)
			end
print(2,"stop")
			self:Stop()
		end)

	end -- :Start()

--~ 		function dfggfhgfhgfh()
--~ 			return 0/0
--~ 		end

	local function AddHooks()
		function hookBreakLuaDebugger()
			if g_LuaDebugger then
				print("Break")
				g_LuaDebugger:Break()
			end
		end
		function hookTickLuaDebugger()
			if g_LuaDebugger then
--~ 					print("DebuggerTick")
				g_LuaDebugger:DebuggerTick()
			end
		end
	end

	local debug_enabled
	function ChoGGi.testing.StartDebugger()
		if debug_enabled then
			StopDebugger()
			debug_enabled = false
			return
		end
		debug_enabled = true

		AddHooks()

		local ReadPacket = luadebugger.ReadPacket
		function luadebugger:ReadPacket(packet)
			print(packet)
			return ReadPacket(self,packet)
		end

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
		if not luadebugger.Start_ORIG then
			luadebugger.Start_ORIG = luadebugger.Start
			luadebugger.Start = Mine_luadebugger_Start
		end
		StartDebugger()
	--~	 ProjectSync()
	end
--]]
--~ 	end -- ClassesBuilt
------------------------------------------------------------------------------------------

function OnMsg.ModsReloaded()
	if not ChoGGi.testing then
		return
	end

	local msgs = ChoGGi.Temp.StartupMsgs
	local print = print
	for i = 1, #msgs do
		print(msgs[i])
	end
	table.iclear(ChoGGi.Temp.StartupMsgs)
end
