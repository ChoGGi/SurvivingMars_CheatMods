-- See LICENSE for terms

local IsTechResearched = IsTechResearched
local PlaceResourcePile = PlaceResourcePile
local ResourceScale = const.ResourceScale

function OnMsg.ColonistDie(colonist)
	if colonist.traits and colonist.traits.Glutton and
		IsTechResearched("SoylentGreen")
	then
		PlaceResourcePile(
			GetRealm(colonist):GetPassablePointNearby(building:GetPos()) or colonist:GetVisualPos(),
			"Food",
			1 * ResourceScale
		)
	end
end
