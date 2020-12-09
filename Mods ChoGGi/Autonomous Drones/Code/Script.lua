-- See LICENSE for terms

-- list of drone controllers, updating medium/high controllers, list of idle drones, list of all drones from low load ccs, list of all drones from medium load ccs
local ccs, threshold, idle_drones, low_drones, med_drones

local mod_AddHeavy
local mod_AddMedium
local mod_UsePrefabs
local mod_HidePackButtons
local mod_RandomiseHubList
local mod_EnableMod
local mod_AddEmpty

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_AddHeavy = options:GetProperty("AddHeavy")
	mod_AddMedium = options:GetProperty("AddMedium")
	mod_AddEmpty = options:GetProperty("AddEmpty")
	mod_UsePrefabs = options:GetProperty("UsePrefabs")
	mod_HidePackButtons = options:GetProperty("HidePackButtons")
	mod_RandomiseHubList = options:GetProperty("RandomiseHubList")
	mod_EnableMod = options:GetProperty("EnableMod")

	if not med_drones then
		med_drones = {}
	end
	if not low_drones then
		low_drones = {}
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local table_icopy = table.icopy
local table_ifilter = table.ifilter
local table_iclear = table.iclear
local table_rand = table.rand
local table_remove = table.remove
local table_remove_entry = table.remove_entry
local CreateGameTimeThread = CreateGameTimeThread
local Sleep = Sleep
local Max = Max
local GameTime = GameTime
local IsValid = IsValid
local IsKindOf = IsKindOf
local SelectionArrowRemove = SelectionArrowRemove
local Random = ChoGGi.ComFuncs.Random

local DroneLoadLowThreshold = const.DroneLoadLowThreshold
local DroneLoadMediumThreshold = const.DroneLoadMediumThreshold
local idle_drone_cmds = {
	Idle = true,
	GoHome = true,
	WaitingCommand = true,
	Start = true,
}

--~ local GetIdleDrones = ChoGGi.ComFuncs.GetIdleDrones
--~ local FisherYates_Shuffle = ChoGGi.ComFuncs.FisherYates_Shuffle
-- remove after update
local function IsDroneIdle(_, drone)
	return idle_drone_cmds[drone.command]
end
local GetIdleDrones = ChoGGi.ComFuncs.GetIdleDrones or function()
	return table_ifilter(table_icopy(UICity.labels.Drone or empty_table), IsDroneIdle)
end
local FisherYates_Shuffle = ChoGGi.ComFuncs.FisherYates_Shuffle or function(list, min)
	if not min then
		min = 1
	end
  for i = #list, 2, -1 do
    local j = Random(min, i)
    list[i], list[j] = list[j], list[i]
  end
end
-- remove after update

local function Template__condition(_, context)
	return not mod_HidePackButtons and IsKindOf(context, "DroneControl")
end

-- unhardcode these someday...
function OnMsg.ClassesPostprocess()
	local template = XTemplates.customDroneHub
	template[1].__condition = Template__condition
	template[2].__condition = Template__condition

	template = XTemplates.ipRover[1]
	template[3].__condition = Template__condition
	template[4].__condition = Template__condition
end

local function AssignDronePrefabs(cc)
	local count = threshold == "red" and mod_AddHeavy or mod_AddMedium
	for _ = 1, count do
		cc:UseDronePrefab()
	end
end

-- ChoGGi.ComFuncs.SendDroneToCC
local function SendDroneToCC(drone, new_cc)
	local old_cc = drone.command_center
	if old_cc == new_cc then
		return
	end
	-- ultra valid
	if IsValid(old_cc) and IsValid(new_cc) and IsValid(drone)
	-- if drone dist to new cc is further than dist to old cc than pack and unpack, otherwise SetCommandCenter() to drive over
		and drone:GetDist(old_cc) < drone:GetDist(new_cc)
	then
		-- function DroneControl:ConvertDroneToPrefab(bulk)
		if drone.demolishing then
			drone:ToggleDemolish()
		end
		drone.can_demolish = false
		local UICity = UICity
		UICity.drone_prefabs = UICity.drone_prefabs + 1
		table_remove_entry(old_cc.drones, drone)
		SelectionArrowRemove(drone)
		drone:SetCommand("DespawnAtHub")
		-- wait till drone is sucked up
		while IsValid(drone) do
			Sleep(1000)
		end
		-- spawn drone from prefab at new cc
		new_cc:UseDronePrefab()
	else
		-- close enough to drive
		drone:SetCommandCenter(cc)
	end
end

local function AssignWorkingDrones(drones, count, cc)
	local drones_c = #drones
	for _ = 1, count do
		local drone, idx = table_rand(drones)
		if drone and idx and not drone.ChoGGi_WaitingForIdleDrone then
			-- need to remove entry right away (before table idx changes)
			table_remove(drones, idx)
			drone.ChoGGi_WaitingForIdleDrone = true
			CreateGameTimeThread(function()
				-- wait till drone is idle then send it off
				while not idle_drone_cmds[drone.command] do
					Sleep(500)
				end
				SendDroneToCC(drone, cc)
 			end)
			drones_c = drones_c - 1
			if drones_c == 0 then
				break
			end
		end
	end
end

local function AssignDrones(cc)
	local count = threshold == "red" and mod_AddHeavy or mod_AddMedium

	-- reassign idle drones
	local idle_drones_c = #idle_drones
	if idle_drones_c > 0 then
		for _ = 1, count do
			local drone, idx = table_rand(idle_drones)
			if drone and idx then
				table_remove(idle_drones, idx)
				CreateGameTimeThread(SendDroneToCC, drone, cc)
			end
			-- no sense in looping for naught
			idle_drones_c = idle_drones_c - 1
			if idle_drones_c == 0 then
				break
			end
		end
	end
	-- reassign low load drones
	if #low_drones > 0 then
		AssignWorkingDrones(low_drones, count, cc)
	end
	-- reassign medium load drones
	AssignWorkingDrones(med_drones, count, cc)
end

-- function DroneControl:CalcLapTime(), just wanted the funcs local since we call this a lot
local function CalcLapTime(cc, drones)
	return drones == 0 and 0 or Max(cc.lap_time, GameTime() - cc.lap_start)
end
--~ -- function DroneControl:GetIdleDronesCount(), same but now with more idle
--~ local function GetIdleDronesCount(cc)
--~ 	local count = 0
--~ 	local drones = self.drones
--~ 	for i = 1, #drones do
--~ 		if idle_drone_cmds[drones[i].command]
--~ 			count = count + 1
--~ 		end
--~ 	end
--~ 	return count
--~ end
local DisablingCommands = {
	Malfunction = true,
	NoBattery = true,
	Freeze = true,
	Dead = true,
	DespawnAtHub = true,
	DieNow = true,
}

local function UpdateHub(cc, build_list, drone_prefabs)
	local drones = cc.drones

	if (threshold == "empty" or threshold == "all") and #table_ifilter(drones, function(_, drone)
--~ 		return not drone:IsDisabled()
		return not DisablingCommands[drone.command] or false
	end) < 1 then
		-- no drones
		if drone_prefabs then
			AssignDronePrefabs(cc)
		else
			AssignDrones(cc)
		end
--~ 	elseif GetIdleDronesCount(cc) == #cc.drones then
--~ 		-- all idle drones
	else
		local lap_time = CalcLapTime(cc, #drones)
		if lap_time < DroneLoadLowThreshold then
			-- low load
			if build_list == "low" then
				local c = #low_drones
				for i = 1, #(drones or "") do
					c = c + 1
					low_drones[c] = drones[i]
				end
			end
		elseif (threshold == "red" or threshold == "all") and lap_time >= DroneLoadMediumThreshold then
			-- high load
			if drone_prefabs then
				AssignDronePrefabs(cc)
			else
				AssignDrones(cc)
			end
--~ 		elseif (threshold == "orange" or threshold == "all") and lap_time < DroneLoadMediumThreshold then
		elseif (threshold == "orange" or threshold == "all") then
			-- medium load
			if build_list == "medium" then
				local c = #med_drones
				for i = 1, #(drones or "") do
					c = c + 1
					med_drones[c] = drones[i]
				end
			else
				if drone_prefabs then
					AssignDronePrefabs(cc)
				else
					AssignDrones(cc)
				end
			end
		end
	end

end

local function ListHubs(build_list, drone_prefabs)
	for i = 1, #ccs do
		local cc = ccs[i]
		-- skip disabled ccs/off map rockets
		if cc.working then
			UpdateHub(cc, build_list, drone_prefabs)
		else
			-- remove any drones from busted ccs?
			for _ = 1, #cc.drones do
				cc:ConvertDroneToPrefab()
			end
		end
	end
end

-- needs list of drones from medium load ccs to reassign to high load

function OnMsg.NewHour()
	if not mod_EnableMod then
		return
	end

	local UICity = UICity
	ccs = UICity.labels.DroneControl or ""
	-- not much point if there's only one cc
	if #ccs > 1 then
		-- rand cc list (firsters get more drones)
		if mod_RandomiseHubList then
			FisherYates_Shuffle(ccs)
		end

		-- Assign any prefabs to ccs
		if mod_UsePrefabs then
			local drone_prefabs = UICity.drone_prefabs
			if drone_prefabs > 0 then
				threshold = "all"
				ListHubs(nil, drone_prefabs)
			end
		end

		-- list of idle drones (prefab-able)
		idle_drones = GetIdleDrones()

		-- update empty drone ccs first
		threshold = "empty"
		ListHubs()

		-- build list of drones from medium load ccs (for "reassignment" instead of packing away)
		table_iclear(med_drones)
		threshold = "orange"
		ListHubs("medium")
		-- low
		table_iclear(low_drones)
		threshold = "orange"
		ListHubs("low")

		-- update heavy load drone ccs (some may turn into medium after)
		threshold = "red"
		ListHubs()

		-- update med load drone ccs
--~ 		threshold = "orange"
		ListHubs()
	end
end
