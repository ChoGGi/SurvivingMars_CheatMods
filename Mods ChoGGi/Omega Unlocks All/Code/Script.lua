-- See LICENSE for terms

local orig = OmegaTelescope.UnlockBreakthroughs
function OmegaTelescope:UnlockBreakthroughs(...)
	orig(self, ...)

	local UICity = UICity
  local breakthroughs = UICity:GetUnregisteredBreakthroughs()
  StableShuffle(breakthroughs, UICity:CreateResearchRand("OmegaTelescope"), 100)
	for i = 1, #breakthroughs do
		UICity:SetTechDiscovered(breakthroughs[i])
	end
end
