-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	-- add some shortened func names
	do
		local ChoGGi = ChoGGi
		-- make some easy to type names
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
		trans = ChoGGi.ComFuncs.Translate
		function so()
			return ChoGGi.ComFuncs.SelObject()
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
function XShortcutsHost:SetPos(pt)
	self:SetBox(pt:x(),pt:y(),self.box:sizex(),self.box:sizey())
end
function XShortcutsHost:GetPos()
	return ChoGGi_Window.GetPos(self,"idMenuBar")
end
function XShortcutsHost:GetSize()
	local GetSize = ChoGGi_Window.GetSize
	return GetSize(self,"idMenuBar") + GetSize(self,"idBottomContainer")
end

-- for anyone still wanting to use it pre-gagarin
if not rawget(_G, "DiscoverTech") then
	function DiscoverTech(tech_id)
		UICity:SetTechDiscovered(tech_id)
	end
end

function DiscoverTech_Old(tech_id)
	UICity:SetTechDiscovered(tech_id)
end

