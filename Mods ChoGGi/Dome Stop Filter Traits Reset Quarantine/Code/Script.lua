local orig_Dome_OpenFilterTraits = Dome.OpenFilterTraits

function Dome:OpenFilterTraits(...)
	local orig = self.accept_colonists
	orig_Dome_OpenFilterTraits(self,...)
	self.accept_colonists = orig
end
