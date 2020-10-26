-- See LICENSE for terms

local orig_PlacePlanet = PlacePlanet
function PlacePlanet(...)
	local ret = orig_PlacePlanet(...)
	local obj = PlanetRotationObj
	obj:SetAnim(1, obj:GetAnim(), 1)
	return ret
end
