-- See LICENSE for terms

local DoneObject = DoneObject

local function StartupCode()
	if not CurrentModOptions:GetProperty("EnableMod") then
		return
	end

	SuspendPassEdits("ChoGGi.FixDredgerMarkLeftOnGround")
	--
	local GameMaps = GameMaps
	for _, map in pairs(GameMaps) do

		local markers = map.realm:MapGet("map", "AlienDiggerMarker")
		for j = 1, #markers do
			local marker = markers[j]

			local rocket_mark = map.realm:MapGet(marker:GetPos(), 0, "ParSystem", function(par)
				return par:GetParticlesName() == "Rocket_Landing_Pos_02"
			end)

			if rocket_mark[1] then
				DoneObject(rocket_mark[1])
				DoneObject(marker)
			end
		end

	end
	--
	ResumePassEdits("ChoGGi.FixDredgerMarkLeftOnGround")
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
