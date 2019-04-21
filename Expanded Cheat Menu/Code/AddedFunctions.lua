-- See LICENSE for terms

-- add some shortened func names
dump = ChoGGi.ComFuncs.Dump
dumplua = ChoGGi.ComFuncs.DumpLua
dumptable = ChoGGi.ComFuncs.DumpTable
trans = ChoGGi.ComFuncs.Translate
imgview = ChoGGi.ComFuncs.OpenInImageViewerDlg
txtview = ChoGGi.ComFuncs.OpenInMultiLineTextDlg
MonitorFunc = ChoGGi.ComFuncs.MonitorFunctionResults
so = ChoGGi.ComFuncs.SelObject

local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
-- legacy (and used for console rules, so we can get around it spamming the log)
function OpenExamine(...)
	OpenInExamineDlg(...)
end
-- short n sweet
ex = OpenExamine

function restart()
	quit("restart")
end
reboot = restart
exit = quit
mh = GetTerrainCursorObjSel -- returns selected obj under cursor
mhc = GetTerrainCursorObj -- returns obj under cursor
mc = GetPreciseCursorObj
m = SelectionMouseObj
c = GetTerrainCursor -- cursor position on map
cs = terminal.GetMousePos -- cursor pos on screen
s = false -- used to store SelectedObj

-- add some simple functions to the cheatmenu for moving it/getting pos
function XShortcutsHost:SetPos(pt)
	-- doesn't "stick"
	self:SetBox(pt:x(),pt:y(),self.box:sizex(),self.box:sizey())
end
function XShortcutsHost:GetPos()
	return ChoGGi_Window.GetPos(self,"idMenuBar")
end
function XShortcutsHost:GetSize()
	local GetSize = ChoGGi_Window.GetSize
	return GetSize(self,"idMenuBar") + GetSize(self,"idBottomContainer")
end

local function DiscoverTech(tech_id)
	UICity:SetTechDiscovered(tech_id)
end
DiscoverTech_Old = DiscoverTech

-- for anyone still using it post-gagarin
if not rawget(_G, "DiscoverTech") then
	_G.DiscoverTech = DiscoverTech
end

-- seems like a useful func to have
if not rawget(Colonist,"HasTrait") then
	function Colonist:HasTrait(trait)
		if self.traits[trait] then
			return true
		end
	end
end
