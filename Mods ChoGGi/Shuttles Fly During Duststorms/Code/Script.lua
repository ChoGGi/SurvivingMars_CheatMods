-- See LICENSE for terms

-- override for wasps
if g_AvailableDlc.gagarin then
	local ChoOrig_FlyingDrone_Goto = FlyingDrone.Goto
	function FlyingDrone.Goto(...)
		local ChoOrig_storm = g_DustStorm
		g_DustStorm = false
		local result, ret = pcall(ChoOrig_FlyingDrone_Goto, ...)
		g_DustStorm = ChoOrig_storm
		return result and ret
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
