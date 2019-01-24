local orig_Colonist_ChangeComfort = Colonist.ChangeComfort
function Colonist:ChangeComfort(amount, reason, ...)
	-- half for people with a kitchen in residence
	if reason == "raw food" and self.residence.class == "LivingQuarters" then
		amount = amount / 2
	end
	return orig_Colonist_ChangeComfort(self, amount, reason, ...)
end
