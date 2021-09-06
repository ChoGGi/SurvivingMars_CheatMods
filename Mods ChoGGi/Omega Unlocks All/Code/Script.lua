-- See LICENSE for terms

local orig = OmegaTelescope.UnlockBreakthroughs
function OmegaTelescope:UnlockBreakthroughs(...)
	orig(self, ...)

	local colony = UIColony
	local breakthroughs = colony:GetUnregisteredBreakthroughs()
	StableShuffle(breakthroughs, colony:CreateResearchRand("OmegaTelescope"), 100)
	for i = 1, #breakthroughs do
		colony:SetTechDiscovered(breakthroughs[i])
	end
end
