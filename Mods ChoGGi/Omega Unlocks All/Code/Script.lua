-- See LICENSE for terms

local orig = OmegaTelescope.UnlockBreakthroughs
function OmegaTelescope:UnlockBreakthroughs(...)
	orig(self, ...)

	local UIColony = UIColony
	local breakthroughs = UIColony:GetUnregisteredBreakthroughs()
	StableShuffle(breakthroughs, UIColony:CreateResearchRand("OmegaTelescope"), 100)
	for i = 1, #breakthroughs do
		UIColony:SetTechDiscovered(breakthroughs[i])
	end
end
