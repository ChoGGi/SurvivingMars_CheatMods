-- See LICENSE for terms

-- add some shortened func names
dump = ChoGGi.ComFuncs.Dump
dumplua = ChoGGi.ComFuncs.DumpLua
dumptable = ChoGGi.ComFuncs.DumpTable
MonitorFunc = ChoGGi.ComFuncs.MonitorFunctionResults
--
function restart()
	quit("restart")
end
reboot = restart
exit = quit
mh = GetTerrainCursorObjSel -- returns selected obj under cursor
mhc = GetTerrainCursorObj -- returns obj under cursor
mc = GetPreciseCursorObj
m = SelectionMouseObj
c = not ChoGGi.is_gp and GetCursorWorldPos or function() -- cursor position on map (GP compat)
	return UseGamepadUI() and GetTerrainGamepadCursor() or GetTerrainCursor()
end
cs = terminal.GetMousePos -- cursor pos on screen
s = false -- used to store SelectedObj
FlushLog = FlushLogFile -- easier to remember

function toboolean(str)
	if str == "true" then
		return true
	elseif str == "false" then
		return false
	end
--~ 	return 0/0
end

-- add some simple functions to the cheatmenu for moving it/getting pos
function XShortcutsHost:SetPos(pt)
	-- doesn't "stick"
	self:SetBox(pt:x(), pt:y(), self.box:sizex(), self.box:sizey())
end
function XShortcutsHost:GetPos()
	return ChoGGi_XWindow.GetPos(self, "idMenuBar")
end
function XShortcutsHost:GetSize()
	local GetSize = ChoGGi_XWindow.GetSize
	return GetSize(self, "idMenuBar") + GetSize(self, "idBottomContainer")
end

local function DiscoverTech(tech_id)
	UIColony:SetTechDiscovered(tech_id)
end
DiscoverTech_Old = DiscoverTech

-- for anyone still using it post-gagarin
if not rawget(_G, "DiscoverTech") then
	_G.DiscoverTech = DiscoverTech
end

-- seems like a useful func to have
if not Colonist.HasTrait then
	function Colonist:HasTrait(trait)
		if self.traits[trait] then
			return true
		end
	end
end
