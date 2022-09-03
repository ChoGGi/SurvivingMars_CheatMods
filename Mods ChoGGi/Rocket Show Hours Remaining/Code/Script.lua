-- See LICENSE for terms

local T = T
local GameTime = GameTime
local Min = Min
local Clamp = Clamp
local MulDivRound = MulDivRound
local HourDuration = const.HourDuration

local mod_EnableMod

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_RocketBase_GetArrivalTimePercent = RocketBase.GetArrivalTimePercent
function RocketBase:GetArrivalTimePercent(...)
	if not mod_EnableMod then
		return ChoOrig_RocketBase_GetArrivalTimePercent(self, ...)
	end

	if not self.launch_time or (self.flight_time or 0) <= 0 then
		return 0
	end

	local start = GameTime() - self.launch_time
	local left = (self.flight_time - start) / HourDuration
	if left < 0 then
		left = 0
	end

	return left .. " " .. T(3778, "Hours") .. ", "
		.. Min(100, MulDivRound(start, 100, self.flight_time))
end

local ChoOrig_RocketExpedition_GetArrivalTimePercent = RocketExpedition.GetArrivalTimePercent
function RocketExpedition:GetArrivalTimePercent(...)
	if not mod_EnableMod then
		return ChoOrig_RocketExpedition_GetArrivalTimePercent(self, ...)
	end

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

	return left .. " " .. T(3778, "Hours") .. ", "
		.. Clamp(MulDivRound(t, 100, duration), 0, 100)
end

local function AppendTime(self)
	self.pin_rollover = self.pin_rollover .. "\n" .. T(708, "<ArrivalTimePercent>%")
end

local ChoOrig_RocketExpedition_UIStatusMissionReturn = RocketExpedition.UIStatusMissionReturn
function RocketExpedition:UIStatusMissionReturn(...)
	if not mod_EnableMod then
		return ChoOrig_RocketExpedition_UIStatusMissionReturn(self, ...)
	end

	ChoOrig_RocketExpedition_UIStatusMissionReturn(self, ...)
	AppendTime(self)
end

local ChoOrig_ForeignTradeRocket_UIStatusFlyToColony = ForeignTradeRocket.UIStatusFlyToColony
function ForeignTradeRocket:UIStatusFlyToColony(...)
	if not mod_EnableMod then
		return ChoOrig_ForeignTradeRocket_UIStatusFlyToColony(self, ...)
	end

	ChoOrig_ForeignTradeRocket_UIStatusFlyToColony(self, ...)
	AppendTime(self)
end
