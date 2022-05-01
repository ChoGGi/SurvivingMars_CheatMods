-- See LICENSE for terms

local ChoOrig_Research_UnlockBreakthroughs = Research.UnlockBreakthroughs
function Research:UnlockBreakthroughs(count, name, ...)
	ChoOrig_Research_UnlockBreakthroughs(self, count, name, ...)

	if name == "OmegaTelescope" then
		local breakthroughs = self:GetUnregisteredBreakthroughs()
		StableShuffle(breakthroughs, self:CreateResearchRand("OmegaTelescope"), 100)
		for i = 1, #breakthroughs do
			self:SetTechDiscovered(breakthroughs[i])
		end
	end
end
