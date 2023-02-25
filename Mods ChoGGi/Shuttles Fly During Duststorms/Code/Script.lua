-- See LICENSE for terms

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
