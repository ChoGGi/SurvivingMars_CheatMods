-- See LICENSE for terms

local orig_Community_OpenFilterTraits = Community.OpenFilterTraits
function Community:OpenFilterTraits(...)
	local orig = self.accept_colonists
	orig_Community_OpenFilterTraits(self, ...)
	self.accept_colonists = orig
end
