-- See LICENSE for terms

function OnMsg.ColonistDie(colonist)
	if colonist.traits and colonist.traits.Glutton and
		colonist.city:IsTechResearched("SoylentGreen")
	then
		PlaceResourcePile(
			GetPassablePointNearby(colonist) or colonist:GetPos(),
			"Food",
			1*const.ResourceScale
		)
	end
end
