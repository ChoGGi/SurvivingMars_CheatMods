-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	-- add some shortened func names
	dump = ChoGGi.ComFuncs.Dump
	dumplua = ChoGGi.ComFuncs.DumpLua
	dumptable = ChoGGi.ComFuncs.DumpTable
	trans = ChoGGi.ComFuncs.Translate
	imgview = ChoGGi.ComFuncs.OpenInImageViewerDlg
	txtview = ChoGGi.ComFuncs.OpenInMultiLineTextDlg
	so = ChoGGi.ComFuncs.SelObject
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

local function DiscoverTech_local(tech_id)
	UICity:SetTechDiscovered(tech_id)
end
DiscoverTech_Old = DiscoverTech_local

-- for anyone still using it post-gagarin
if not rawget(_G, "DiscoverTech") then
	DiscoverTech = DiscoverTech_local
end

-- seems like a useful func to have
if not rawget(Colonist,"HasTrait") then
	function Colonist:HasTrait(trait)
		if self.traits[trait] then
			return true
		end
	end
end
