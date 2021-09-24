-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_RandomBreakthroughs then
		return
	end

	PlaceObj("GameRules", {
		challenge_mod = 10,
		description = T(302535920011749, "This will randomise breakthroughs."),
		display_name = T(302535920011750, "Randomise Breakthroughs"),
		group = "Default",
		id = "ChoGGi_RandomBreakthroughs",
	})
end

-- change func to always use rand number instead of supplied num
local AsyncRand = AsyncRand
local ChoOrig_StableShuffle = StableShuffle
local function fake_StableShuffle(tbl, _, max, ...)
	return ChoOrig_StableShuffle(tbl, AsyncRand, max, ...)
end

-- anomalies for ground/planetary
local ChoOrig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City.InitBreakThroughAnomalies(...)
	if g_CurrentMissionParams.idGameRules.ChoGGi_RandomBreakthroughs then
		StableShuffle = fake_StableShuffle
	end
	local ret = ChoOrig_City_InitBreakThroughAnomalies(...)
	StableShuffle = ChoOrig_StableShuffle
	return ret
end

-- make omega true random (well truer)
local ChoOrig_OmegaTelescope_UnlockBreakthroughs = OmegaTelescope.UnlockBreakthroughs
function OmegaTelescope.UnlockBreakthroughs(...)
	if g_CurrentMissionParams.idGameRules.ChoGGi_RandomBreakthroughs then
		StableShuffle = fake_StableShuffle
	end
	local ret = ChoOrig_OmegaTelescope_UnlockBreakthroughs(...)
	StableShuffle = ChoOrig_StableShuffle
	return ret
end
