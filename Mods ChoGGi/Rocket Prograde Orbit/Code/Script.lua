-- See LICENSE for terms

local IsValid = IsValid

local ChoOrig_PlacePlanet = PlacePlanet
function PlacePlanet(...)
	-- there isn't a ret, but if a mod does something then...
	local ret = ChoOrig_PlacePlanet(...)

	local obj = PlanetRotationObj
	-- check for PlanetRocket and skip scenes without it
	if IsValid(PlanetRocket) and IsValid(obj) then
		obj:SetAnim(1, obj:GetAnim(), 1)
	end

	return ret
end
