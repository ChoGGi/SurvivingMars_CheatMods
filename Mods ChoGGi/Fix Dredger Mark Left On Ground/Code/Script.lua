-- See LICENSE for terms

local MapGet = MapGet
local type = type

function OnMsg.LoadGame()
	-- get all the marks then check pos of each for the parsystem and remove it as well
	local marks = MapGet("map", "AlienDiggerMarker")
	for i = 1, #marks do
		local mark = marks[i]
		-- get all pars at the same pos
		local pars = MapGet(mark:GetPos(), 0, "ParSystem")
		for j = 1, #pars do
			local par = pars[j]
			-- check that it's the right particle
			if par:GetParticlesName() == "Rocket_Landing_Pos_02" and type(par.polyline) == "string" and par.polyline:find("\0") then
				par:delete()
			end
		end
		mark:delete()
	end
end
