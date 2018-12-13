-- See LICENSE for terms

function OnMsg.ClassesGenerate()
	local ChoGGi = ChoGGi

	-- add some shortened func names
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
end

-- no need to have these in the do

function ImageView(image)
	ChoGGi.ComFuncs.OpenInImageViewerDlg(image)
end

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

-- seems like a useful func to have
if not rawget(Colonist,"HasTrait") then
	function Colonist:HasTrait(trait)
		if self.traits[trait] then
			return true
		end
	end
end
