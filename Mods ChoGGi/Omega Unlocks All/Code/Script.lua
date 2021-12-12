-- See LICENSE for terms

local ChoOrig_UnlockBreakthroughs = Research.UnlockBreakthroughs
function Research.UnlockBreakthroughs(...)
	ChoOrig_UnlockBreakthroughs(...)

	local UIColony = UIColony
	local breakthroughs = UIColony:GetUnregisteredBreakthroughs()
	StableShuffle(breakthroughs, UIColony:CreateResearchRand("OmegaTelescope"), 100)
	for i = 1, #breakthroughs do
		UIColony:SetTechDiscovered(breakthroughs[i])
	end
end
