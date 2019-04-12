-- See LICENSE for terms

local type = type
local GetMissionSponsor = GetMissionSponsor

local function StartupCode()
	-- try to get the number from japan, or just use 500
	local amount
	local japan = Presets.MissionSponsorPreset.Default.Japan
	if japan then
		amount = japan.research_points_per_explored_sector
	end
	-- just in case it's set to "" by default or some crap
	if type(amount) ~= "number" then
		amount = 500
	end
	-- change current sponsor
	GetMissionSponsor().research_points_per_explored_sector = amount
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
