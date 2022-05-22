-- See LICENSE for terms

local mod_EnableMod

local skip_lightmodels = {
	Curiosity = true,
	Dreamers = true,
	ColdWave = true,
	DustStorm = true,
	GreatDustStorm = true,
	ToxicRain = true,
	WaterRain = true,
}
local lightmodel = "TheMartian"

local function SetLight(msg, timeout)
	-- we only want to change lightmodel on surface
	if not mod_EnableMod or UICity ~= MainCity then
		return
	end

	CreateRealTimeThread(function()
		WaitMsg(msg, timeout)
		-- just in case...
		if lightmodel == "" then
			lightmodel = "TheMartian"
		end
		local map_id = MainCity.map_id

		local lm = CurrentLightmodel[map_id][1]
		local postfix = lm.id
		-- returns 12,12 which doesn't work for what we want :sub for
		local underscore_count = postfix:find("_")
		if not underscore_count then
			print("Change Lightmodel lightmodel id issue:", postfix, map_id, lm)
		else
			if not skip_lightmodels[postfix:sub(1, underscore_count - 1)] then
				postfix = postfix:sub(underscore_count)
				local new = lightmodel .. postfix
				if new ~= CurrentLightmodel[map_id][1].id then

					local blend_time = MulDivRound(lm.blend_time * 2, const.HourDuration, 60)
					SetLightmodel(1, new, blend_time)
				end
			end
		end
	end)
end

local function OverrideIt()
	SetLight("AfterLightmodelChange", 10000)
end
OnMsg.CityStart = OverrideIt
OnMsg.LoadGame = OverrideIt

function OnMsg.AfterLightmodelChange()
	SetLight("OnRender")
end

-- lightmodel is reset when leaving planet view
local ChoOrig_ClosePlanetCamera = ClosePlanetCamera
function ClosePlanetCamera(...)
	OverrideIt()
	return ChoOrig_ClosePlanetCamera(...)
end

local mod_options = {}
local lightmodels = {
	"Terraformed",
	"TheMartian",
}

for i = 1, #lightmodels do
	mod_options["mod_" .. lightmodels[i]] = false
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")

	lightmodel = "TheMartian"
	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
		-- pick whatever is enabled
		if mod_options[id] then
			-- 5 to remove mod_
			lightmodel = id:sub(5)
			break
		end
	end

	-- make sure we're in-game
	if not UICity then
		return
	end

	OverrideIt()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
