-- See LICENSE for terms

local mod_RainType

local ChoOrig_GetTerraformParamPct = GetTerraformParamPct
local function ChoFake_GetTerraformParamPct(param, ...)
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
	GetTerraformParamPct = ChoFake_GetTerraformParamPct
	-- I do pcalls for safety when wanting to change back a global var
	pcall(ChoOrig_UpdateRainsThreads, ...)
	GetTerraformParamPct = ChoOrig_GetTerraformParamPct
end

local lookup_rain = {
	-- 0 == nil
	[1] = "toxic",
	[2] = "normal",
}

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_RainType = lookup_rain[CurrentModOptions:GetProperty("RainType")]

	-- make sure we're in-game
	if not MainCity then
		return
	end

	UpdateRainsThreads()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

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
