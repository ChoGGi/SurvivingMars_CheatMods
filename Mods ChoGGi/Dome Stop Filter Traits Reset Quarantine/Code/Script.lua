-- See LICENSE for terms

local ChoOrig_Community_OpenFilterTraits = Community.OpenFilterTraits
function Community:OpenFilterTraits(...)
	local orig = self.accept_colonists
	ChoOrig_Community_OpenFilterTraits(self, ...)
	self.accept_colonists = orig
end
