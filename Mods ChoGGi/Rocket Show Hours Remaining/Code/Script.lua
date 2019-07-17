-- See LICENSE for terms

local T = T
local GameTime = GameTime
local Min = Min
local Clamp = Clamp
local MulDivRound = MulDivRound
local HourDuration = const.HourDuration

function SupplyRocket:GetArrivalTimePercent()
	if not self.launch_time or (self.flight_time or 0) <= 0 then
		return 0
	end

	local start = GameTime() - self.launch_time
	local left = (self.flight_time - start) / HourDuration
	if left < 0 then
		left = 0
	end

	return left .. " " .. T(3778, "Hours") .. " "
		.. Min(100, MulDivRound(start, 100, self.flight_time))
end

function RocketExpedition:GetArrivalTimePercent()
	if not self.expedition_start_time or not self.expedition_return_time then
		return 0
	end
	if self.is_paused then
		return 0
	end

	local duration = self.expedition_return_time - self.expedition_start_time
	local t = GameTime() - self.expedition_start_time

	local left = (duration - t) / HourDuration
	if left < 0 then
		left = 0
	end

	return left .. " " .. T(3778, "Hours") .. " "
		.. Clamp(MulDivRound(t, 100, duration), 0, 100)
end

local function AppendTime(self)
	self.pin_rollover = self.pin_rollover .. "\n" .. T(708, "<ArrivalTimePercent>%")
end

local orig_UIStatusMissionReturn = RocketExpedition.UIStatusMissionReturn
function RocketExpedition:UIStatusMissionReturn(...)
	orig_UIStatusMissionReturn(self, ...)
	AppendTime(self)
end

local orig_UIStatusFlyToColony = ForeignTradeRocket.UIStatusFlyToColony
function ForeignTradeRocket:UIStatusFlyToColony(...)
	orig_UIStatusFlyToColony(self, ...)
	AppendTime(self)
end
