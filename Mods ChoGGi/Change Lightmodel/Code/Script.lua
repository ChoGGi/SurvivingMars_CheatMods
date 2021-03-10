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
	if not mod_EnableMod then
		return
	end

	CreateRealTimeThread(function()
		WaitMsg(msg, timeout)
		-- just in case...
		if lightmodel == "" then
			lightmodel = "TheMartian"
		end
		local postfix = CurrentLightmodel[1].id
		-- returns 12,12 which doesn't work for what we want :sub for
		local underscore_count = postfix:find("_")
		if not skip_lightmodels[postfix:sub(1, underscore_count - 1)] then
			postfix = postfix:sub(underscore_count)
			local new = lightmodel .. postfix
			if new ~= CurrentLightmodel[1].id then
				SetLightmodel(1, new)
--~ 				SetLightmodelOverride(1, new)
			end
		end
	end)
end

local function OverrideIt()
	SetLight("AfterLightmodelChange", 10000)
end

function OnMsg.AfterLightmodelChange()
	SetLight("OnRender")
end

-- lightmodel is reset when leaving planet view
local orig_ClosePlanetCamera = ClosePlanetCamera
function ClosePlanetCamera(...)
	OverrideIt()
	return orig_ClosePlanetCamera(...)
end

local mod_options = {}
local lightmodels = {
	"Terraformed",
	"TheMartian",
}

for i = 1, #lightmodels do
	mod_options["mod_" .. lightmodels[i]] = false
end

-- fired when settings are changed/init
local function ModOptions()
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

	-- make sure we're ingame
	if not UICity then
		return
	end

	OverrideIt()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = OverrideIt
OnMsg.LoadGame = OverrideIt
