-- See LICENSE for terms

local IsValid = IsValid

local ChoOrig_Colonist_ChangeComfort = Colonist.ChangeComfort
function Colonist:ChangeComfort(amount, reason, ...)
	-- half for people with a kitchen in residence
	if reason == "raw food" and IsValid(self)
		and IsValid(self.residence) and self.residence.class == "LivingQuarters"
	then
		amount = amount / 2
	end

	return ChoOrig_Colonist_ChangeComfort(self, amount, reason, ...)
end
