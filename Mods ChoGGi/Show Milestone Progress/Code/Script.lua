-- See LICENSE for terms

local table = table
local T = T
local GameTime = GameTime
local TimeToDayHour = TimeToDayHour
local MulDivTrunc = MulDivTrunc
local MulDivRound = MulDivRound
local Max = Max

-- Milestone:GetScore()
local function GetScore(self)
--~ 	local time = MilestoneCompleted[self.id]
	local time = GameTime()
	local expiration_days = self.bonus_score_expiration

	local bonus_time = expiration_days - (TimeToDayHour(time) - 1)
	-- If bonus time is expired return base score
	if bonus_time < 0 then
		return self.base_score
	end

	-- give full score on day 1
	local score = self.base_score + Max(0, MulDivTrunc(self.bonus_score, bonus_time, expiration_days))
	-- Milestone:GetChallengeScore()
	return score and MulDivRound(score, ChallengeRating, 100) or 0
end

local info = {T(1155--[[Bonus Score]]), ": ", "", "<newline><newline>", T(1156--[[Bonus score expiration Sols]]), ": ", ""}
local function BonusInfo(milestone)
	if MilestoneCompleted[milestone.id] then
		return milestone:GetCompleteText()
	end
	info[3] = GetScore(milestone) or 0
	info[7] = milestone.bonus_score_expiration - (TimeToDayHour(GameTime()) - 1)
	return table.concat(info)
end

local function StartupCode()
	local milestones = Presets.Milestone.Default

	-- No need to add if already added (from previous load)
	if milestones.WorkersInWorkshops.description ~= "" then
		return
	end

	milestones.WorkersInWorkshops.description = T{0000, "Percent of current workers across all shifts: <percent>",
		percent = function()
			-- I'm using maincity because that's what the milestone checks
			return MainCity:GetWorkshopWorkersPercent()
			-- Hey devs, why have a Colonly:GetWorkshopWorkersPercent() that does literally nothing?
		end,
	}

	milestones.ScanAllSectors.description = T{0000, "Sectors scanned out of 100: <count>",
		count = function()
			local count = 0
			local n = const.SectorCount
			for x = 1, n do
				for y = 1, n do
					if MainCity.MapSectors[x][y].status ~= "unexplored" then
						count = count + 1
					end
				end
			end
			return count
		end,
	}

	-- Add bonus info amount to each one
	for i = 1, #milestones do
		local milestone = milestones[i]
		-- Append or replace
		if milestone.description == "" then
			milestone.description = T{0000, "<bonus>",
				bonus = function()
					return BonusInfo(milestone)
				end,
			}
		else
			milestone.description = milestone.description .. "<newline><newline>" .. T{0000, "<bonus>",
				bonus = function()
					return BonusInfo(milestone)
				end,
			}
		end
	end

end

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode
