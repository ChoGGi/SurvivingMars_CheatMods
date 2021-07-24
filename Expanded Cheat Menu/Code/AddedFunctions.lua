-- See LICENSE for terms

-- add some shortened func names
dump = ChoGGi.ComFuncs.Dump
dumplua = ChoGGi.ComFuncs.DumpLua
dumptable = ChoGGi.ComFuncs.DumpTable
trans = ChoGGi.ComFuncs.Translate
so = ChoGGi.ComFuncs.SelObject
MonitorFunc = ChoGGi.ComFuncs.MonitorFunctionResults
MapGetC = ChoGGi.ComFuncs.MapGet
-- used for console rules, so we can get around it spamming the log
local OpenInImageViewerDlg = ChoGGi.ComFuncs.OpenInImageViewerDlg
function OpenImageViewer(...)
	OpenInImageViewerDlg(...)
end
local OpenInMultiLineTextDlg = ChoGGi.ComFuncs.OpenInMultiLineTextDlg
function OpenTextViewer(...)
	OpenInMultiLineTextDlg(...)
end

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
	UICity:SetTechDiscovered(tech_id)
end
DiscoverTech_Old = DiscoverTech

-- for anyone still using it post-gagarin
if not rawget(_G, "DiscoverTech") then
	_G.DiscoverTech = DiscoverTech
end

-- seems like a useful func to have
if not rawget(Colonist, "HasTrait") then
	function Colonist:HasTrait(trait)
		if self.traits[trait] then
			return true
		end
	end
end
