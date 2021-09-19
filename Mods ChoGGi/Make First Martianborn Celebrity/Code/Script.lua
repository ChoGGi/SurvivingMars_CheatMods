-- See LICENSE for terms

GlobalVar("ChoGGi_MakeFirstMartianbornCelebrity", false)

function OnMsg.ColonistBorn(obj)
	if not ChoGGi_MakeFirstMartianbornCelebrity then
		obj:AddTrait("Celebrity", true)
		ChoGGi_MakeFirstMartianbornCelebrity = obj.handle
	end
end
