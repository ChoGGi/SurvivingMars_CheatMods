-- See LICENSE for terms

local mod_RainType

local ChoOrig_GetTerraformParamPct = GetTerraformParamPct
local function fake_GetTerraformParamPct(param, ...)
	if not mod_RainType then
		return ChoOrig_GetTerraformParamPct(param, ...)
	end

	if mod_RainType == "normal" and (param == "Atmosphere" or param == "Temperature" or param == "Water") then
		-- atmo/temp need to be 55 or above and water needs to be above 5, so 55 it is
		return 56
	elseif mod_RainType == "toxic" and (param == "Atmosphere" or param == "Temperature") then
		-- atmo/temp need to be 25 or above and below 55, so 25 is it
		return 26
	end

	-- otherwise return whatever
	return ChoOrig_GetTerraformParamPct(param, ...)
end


local ChoOrig_UpdateRainsThreads = UpdateRainsThreads
function UpdateRainsThreads(...)
	GetTerraformParamPct = fake_GetTerraformParamPct
	ChoOrig_UpdateRainsThreads(...)
	GetTerraformParamPct = ChoOrig_GetTerraformParamPct
end

local lookup_rain = {
	-- 0 == nil
	[1] = "toxic",
	[2] = "normal",
}

-- fired when settings are changed/init
local function ModOptions()
	mod_RainType = lookup_rain[CurrentModOptions:GetProperty("RainType")]

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateRainsThreads()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

-- probably called?
--~ OnMsg.CityStart = UpdateRainsThreads
--~ OnMsg.LoadGame = UpdateRainsThreads

local ChoOrig_RainProcedure = RainProcedure
function RainProcedure(settings, ...)
	if not mod_RainType then
		return ChoOrig_RainProcedure(settings, ...)
	end

	settings.type = mod_RainType

	return ChoOrig_RainProcedure(settings, ...)
end
