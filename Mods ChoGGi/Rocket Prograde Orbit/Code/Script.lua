-- See LICENSE for terms

local ChoOrig_PlacePlanet = PlacePlanet
function PlacePlanet(...)
	local ret = ChoOrig_PlacePlanet(...)
	local obj = PlanetRotationObj
	obj:SetAnim(1, obj:GetAnim(), 1)
	return ret
end
