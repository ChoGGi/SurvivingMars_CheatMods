-- See LICENSE for terms

local T = T
local GameTime = GameTime
local Min = Min
local Clamp = Clamp
local MulDivRound = MulDivRound
local HourDuration = const.HourDuration

local mod_ShowPinHours
local mod_EnableMod

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ShowPinHours = CurrentModOptions:GetProperty("ShowPinHours")
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_RocketBase_GetArrivalTimePercent = RocketBase.GetArrivalTimePercent
RocketBase.GetArrivalTimePercent_ChoOrig = ChoOrig_RocketBase_GetArrivalTimePercent
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
RocketExpedition.GetArrivalTimePercent_ChoOrig = ChoOrig_RocketExpedition_GetArrivalTimePercent
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

local function ShowPinTime(func, self, ...)
	if not mod_EnableMod then
		return func(self, ...)
	end
	-- Always show hours in rollover
	self.pin_rollover = self.pin_rollover .. "\n" .. T(708, "<ArrivalTimePercent>%")

	-- This func will change pin_summary1 to "<ArrivalTimePercent>%"
	func(self, ...)

	-- change it to not use my ArrivalTimePercent func
	if not mod_ShowPinHours then
		self.pin_summary1 = T(0, "<ArrivalTimePercent_ChoOrig>%")
	end
end


-- calls for a table of some sort someday

local ChoOrig_RocketBase_UIStatusArrive = RocketBase.UIStatusArrive
function RocketBase:UIStatusArrive(...)
	return ShowPinTime(ChoOrig_RocketBase_UIStatusArrive, self, ...)
end
local ChoOrig_RocketBase_UIStatusDeparting = RocketBase.UIStatusDeparting
function RocketBase:UIStatusDeparting(...)
	return ShowPinTime(ChoOrig_RocketBase_UIStatusDeparting, self, ...)
end
--
local ChoOrig_ForeignTradeRocket_UIStatusFlyToColony = ForeignTradeRocket.UIStatusFlyToColony
function ForeignTradeRocket:UIStatusFlyToColony(...)
	return ShowPinTime(ChoOrig_ForeignTradeRocket_UIStatusFlyToColony, self, ...)
end
--
local ChoOrig_RocketExpedition_UIStatusTradeExport = RocketExpedition.UIStatusTradeExport
function RocketExpedition:UIStatusTradeExport(...)
	return ShowPinTime(ChoOrig_RocketExpedition_UIStatusTradeExport, self, ...)
end
local ChoOrig_RocketExpedition_UIStatusTradeImport = RocketExpedition.UIStatusTradeImport
function RocketExpedition:UIStatusTradeImport(...)
	return ShowPinTime(ChoOrig_RocketExpedition_UIStatusTradeImport, self, ...)
end
local ChoOrig_RocketExpedition_UIStatusMission = RocketExpedition.UIStatusMission
function RocketExpedition:UIStatusMission(...)
	return ShowPinTime(ChoOrig_RocketExpedition_UIStatusMission, self, ...)
end
local ChoOrig_RocketExpedition_UIStatusMissionReturn = RocketExpedition.UIStatusMissionReturn
function RocketExpedition:UIStatusMissionReturn(...)
	return ShowPinTime(ChoOrig_RocketExpedition_UIStatusMissionReturn, self, ...)
end
local ChoOrig_RocketExpedition_UIStatusTask = RocketExpedition.UIStatusTask
function RocketExpedition:UIStatusTask(...)
	return ShowPinTime(ChoOrig_RocketExpedition_UIStatusTask, self, ...)
end
local ChoOrig_RocketExpedition_UIStatusTaskReturn = RocketExpedition.UIStatusTaskReturn
function RocketExpedition:UIStatusTaskReturn(...)
	return ShowPinTime(ChoOrig_RocketExpedition_UIStatusTaskReturn, self, ...)
end
--
if g_AvailableDlc.picard then
	local ChoOrig_LanderRocketBase_UIStatusDeparting = LanderRocketBase.UIStatusDeparting
	function LanderRocketBase:UIStatusDeparting(...)
		return ShowPinTime(ChoOrig_LanderRocketBase_UIStatusDeparting, self, ...)
	end
end
