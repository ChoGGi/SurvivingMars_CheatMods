-- See LICENSE for terms

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
