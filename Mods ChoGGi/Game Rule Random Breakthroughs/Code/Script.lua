-- See LICENSE for terms

local pcall = pcall
local IsGameRuleActive = IsGameRuleActive

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
local function ChoFake_StableShuffle(tbl, _, max, ...)
	return ChoOrig_StableShuffle(tbl, AsyncRand, max, ...)
end

-- anomalies for ground/planetary (last checked class picard 1008224)
local ChoOrig_City_InitBreakThroughAnomalies = City.InitBreakThroughAnomalies
function City.InitBreakThroughAnomalies(...)
	if IsGameRuleActive("ChoGGi_RandomBreakthroughs") then
		StableShuffle = ChoFake_StableShuffle
	end
	local result, ret = pcall(ChoOrig_City_InitBreakThroughAnomalies, ...)
	StableShuffle = ChoOrig_StableShuffle
	if result then
		return ret
	else
		print("ChoOrig_City_InitBreakThroughAnomalies failed!:", ret)
	end
end

-- make omega true random (well truer)
local ChoOrig_OmegaTelescope_UnlockBreakthroughs = OmegaTelescope.UnlockBreakthroughs
function OmegaTelescope.UnlockBreakthroughs(...)
	if IsGameRuleActive("ChoGGi_RandomBreakthroughs") then
		StableShuffle = ChoFake_StableShuffle
	end
	local result, ret = pcall(ChoOrig_OmegaTelescope_UnlockBreakthroughs, ...)
	StableShuffle = ChoOrig_StableShuffle
	if result then
		return ret
	else
		print("ChoOrig_OmegaTelescope_UnlockBreakthroughs failed!:", ret)
	end
end
