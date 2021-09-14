-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local type = type
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
