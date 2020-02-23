-- See LICENSE for terms

-- (awkward) override for wasps
if g_AvailableDlc.gagarin then
	function OnMsg.ClassesPostprocess()
		local orig_g_DustStorm

		-- func called before the check for g_DustStorm
		local orig_FlyingDrone_ReleaseLandingPos = FlyingDrone.ReleaseLandingPos
		function FlyingDrone.ReleaseLandingPos(...)
			orig_g_DustStorm = g_DustStorm
			if orig_g_DustStorm then
				g_DustStorm = false
			end
			return orig_FlyingDrone_ReleaseLandingPos(...)
		end

		-- func called after the check
		local orig_FlyingDrone_IsValidPos = FlyingDrone.IsValidPos
		function FlyingDrone.IsValidPos(...)
			if orig_g_DustStorm then
				g_DustStorm = orig_g_DustStorm
				orig_g_DustStorm = nil
			end
			return orig_FlyingDrone_IsValidPos(...)
		end
	end
end

-- shuttlehubs
local function RemoveBuilding(label, list)
	local idx = table.find(list, label)
	if idx then
		table.remove(list, idx)
	end
end

local function StartupCode()
	RemoveBuilding("ShuttleHub", const.DustStormSuspendBuildings)
	RemoveBuilding("ShuttleHub", g_SuspendLabels)
	RemoveBuilding("JumperShuttleHub", g_SuspendLabels)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
