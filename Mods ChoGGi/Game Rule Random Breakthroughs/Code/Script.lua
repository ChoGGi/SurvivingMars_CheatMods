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
local orig_StableShuffle = StableShuffle
local function fake_StableShuffle(tbl, _, max, ...)
	return orig_StableShuffle(tbl, AsyncRand, max, ...)
end

-- anomalies for ground/planetary
local orig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City.InitBreakThroughAnomalies(...)
	if g_CurrentMissionParams.idGameRules.ChoGGi_RandomBreakthroughs then
		StableShuffle = fake_StableShuffle
	end
	local ret = orig_City_InitBreakThroughAnomalies(...)
	StableShuffle = orig_StableShuffle
	return ret
end

-- make omega true random (well truer)
local orig_OmegaTelescope_UnlockBreakthroughs = OmegaTelescope.UnlockBreakthroughs
function OmegaTelescope.UnlockBreakthroughs(...)
	if g_CurrentMissionParams.idGameRules.ChoGGi_RandomBreakthroughs then
		StableShuffle = fake_StableShuffle
	end
	local ret = orig_OmegaTelescope_UnlockBreakthroughs(...)
	StableShuffle = orig_StableShuffle
	return ret
end
