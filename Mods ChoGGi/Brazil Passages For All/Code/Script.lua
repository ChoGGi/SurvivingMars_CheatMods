-- See LICENSE for terms

local default_InstantPassages = 0
local default_NonHomeDomePerformancePenalty = 10
local default_NonHomeDomeServiceThresholdDecrement = 10000

function OnMsg.ClassesPostprocess()
	default_InstantPassages = Consts.InstantPassages
	default_NonHomeDomePerformancePenalty = Consts.NonHomeDomePerformancePenalty
	default_NonHomeDomeServiceThresholdDecrement = Consts.NonHomeDomeServiceThresholdDecrement
end

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

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_InstantPassages = CurrentModOptions:GetProperty("InstantPassages")

	-- make sure we're ingame
	if not UICity then
		return
	end
	SetOptions()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = SetOptions
OnMsg.LoadGame = SetOptions
