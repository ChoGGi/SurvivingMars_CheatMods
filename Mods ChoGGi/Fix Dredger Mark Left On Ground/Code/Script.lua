-- See LICENSE for terms

local DoneObject = DoneObject

local function HasParticles(par)
	return par:GetParticlesName() == "Rocket_Landing_Pos_02"
end

local function StartupCode()
	if not CurrentModOptions:GetProperty("EnableMod") then
		return
	end

	local GameMaps = GameMaps
	for i = 1, #GameMaps do
		local realm = GameMaps[i].realm

		local markers = realm:MapGet("map", "AlienDiggerMarker")
		for j = 1, #markers do
			local marker = markers[j]

			local rocket_mark = realm:MapGet(marker:GetPos(), 0, "ParSystem", HasParticles)
			if rocket_mark[1] then
				DoneObject(rocket_mark[1])
				DoneObject(marker)
			end
		end

	end


end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
