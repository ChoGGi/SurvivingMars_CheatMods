-- See LICENSE for terms

-- nope not hacky at all
local is_loaded
function OnMsg.ChoGGi_Library_Loaded()
	if is_loaded then
		return
	end
	is_loaded = true
	-- nope nope nope

	-- add some shortened func names
	do -- for those that don't know "do ... end" is a way of keeping "local =" local to the do
		-- make some easy to type names
		local ChoGGi = ChoGGi
		if not ChoGGi.blacklist then
			function dump(...)
				ChoGGi.ComFuncs.Dump(...)
			end
			function dumplua(...)
				ChoGGi.ComFuncs.DumpLua(...)
			end
			function dumptable(...)
				ChoGGi.ComFuncs.DumpTable(...)
			end
			function dumpl(...)
				ChoGGi.ComFuncs.DumpLua(...)
			end
			function dumpt(...)
				ChoGGi.ComFuncs.DumpTable(...)
			end
		end

	--~	 local function RemoveLast(str)
	--~		 --remove restart/quit as the last cmd so we don't hit it by accident
	--~		 local dlgConsole = dlgConsole
	--~		 if dlgConsole.history_queue[1] == str then
	--~			 table.remove(dlgConsole.history_queue,1)
	--~			 --and save it?
	--~			 if rawget(_G, "dlgConsole") then
	--~				 dlgConsole:StoreHistory()
	--~			 end
	--~		 end
	--~	 end
	--~	 local orig_quit = quit
	--~	 function quit(...)
	--~		 orig_quit(...)
	--~		 RemoveLast("quit")
	--~	 end

		-- works with userdata or index number
		trans = ChoGGi.ComFuncs.Translate
		function so()
			return ChoGGi.ComFuncs.SelObject()
		end
	end
	-- no need to have these in the do
	function restart()
		quit("restart")
	end
	reboot = restart
	exit = quit
	mh = GetTerrainCursorObjSel -- only returns selected obj under cursor
	mhc = GetTerrainCursorObj -- returns obj under cursor
	mc = GetPreciseCursorObj
	m = SelectionMouseObj
	c = GetTerrainCursor -- cursor position on map
	cs = terminal.GetMousePos -- cursor pos on screen
	s = false -- used to store SelectedObj


	-- add some simple functions to the cheatmenu for moving it/getting pos
	XShortcutsHost.SetPos = function(self,pt)
		self:SetBox(pt:x(),pt:y(),self.box:sizex(),self.box:sizey())
	end
	XShortcutsHost.GetPos = function(self)
		return ChoGGi_Window.GetPos(self,"idMenuBar")
	end
	XShortcutsHost.GetSize = function(self)
		local GetSize = ChoGGi_Window.GetSize
		return GetSize(self,"idMenuBar") + GetSize(self,"idBottomContainer")
	end

	-- some other functions someday
end
