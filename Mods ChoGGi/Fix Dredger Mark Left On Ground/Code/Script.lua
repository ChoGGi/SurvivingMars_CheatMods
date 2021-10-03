-- See LICENSE for terms

local MapGet = MapGet
local DoneObject = DoneObject
local function HasParticles(par)
	return par:GetParticlesName() == "Rocket_Landing_Pos_02"
end

local function StartupCode()
	if not CurrentModOptions:GetProperty("EnableMod") then
		return
	end

	local markers = MapGet("map", "AlienDiggerMarker")
	for i = 1, #markers do
		local marker = markers[i]

		local rocket_mark = MapGet(marker:GetPos(), 0, "ParSystem", HasParticles)
		if rocket_mark[1] then
			DoneObject(rocket_mark[1])
			DoneObject(marker)
		end

	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
