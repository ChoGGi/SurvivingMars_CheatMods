-- See LICENSE for terms

local default_InstantPassages = 0
local default_NonHomeDomePerformancePenalty = 10
local default_NonHomeDomeServiceThresholdDecrement = 10000

function OnMsg.ClassesPostprocess()
	default_InstantPassages = Consts.InstantPassages
	default_NonHomeDomePerformancePenalty = Consts.NonHomeDomePerformancePenalty
	default_NonHomeDomeServiceThresholdDecrement = Consts.NonHomeDomeServiceThresholdDecrement
end

--~ local SetConsts = ChoGGi.ComFuncs.SetConsts
local function SetConsts(id, value)
	Consts[id] = value
	g_Consts[id] = value
end

local mod_EnableMod
local mod_InstantPassages

local function SetOptions()
	if mod_EnableMod then
		if mod_InstantPassages then
			SetConsts("InstantPassages", 1)
		else
			SetConsts("InstantPassages", default_InstantPassages)
		end

		SetConsts("NonHomeDomePerformancePenalty", 0)
		SetConsts("NonHomeDomeServiceThresholdDecrement", 0)
	else
		SetConsts("InstantPassages", default_InstantPassages)
		SetConsts("NonHomeDomePerformancePenalty", default_NonHomeDomePerformancePenalty)
		SetConsts("NonHomeDomeServiceThresholdDecrement", default_NonHomeDomeServiceThresholdDecrement)
	end
end
OnMsg.CityStart = SetOptions
OnMsg.LoadGame = SetOptions

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_InstantPassages = CurrentModOptions:GetProperty("InstantPassages")

	-- make sure we're in-game
	if not UIColony then
		return
	end
	SetOptions()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
