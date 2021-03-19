-- See LICENSE for terms

-- updating medium/high hubs, list of idle drones, list of all drones from medium load hubs
local threshold, idle_drones
-- list of all drones from low/medium load hubs, filtered list of mod option hubs, non-filtered hubs to clear out
local med_drones, low_drones, filtered_hubs, useless_hubs = {}, {}, {}, {}
local hub_count = #filtered_hubs

local mod_AddHeavy
local mod_AddMedium
local mod_HidePackButtons
local mod_SortHubListLoad
local mod_EnableMod
local mod_AddEmpty
local mod_UpdateDelay
local mod_UseDroneHubs
local mod_UseCommanders
local mod_UseRockets
local mod_EarlyGame
local mod_IgnoreUnusedHubs
local mod_DroneWorkDelay
local mod_UsePrefabs

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_AddHeavy = options:GetProperty("AddHeavy")
	mod_AddMedium = options:GetProperty("AddMedium")
	mod_AddEmpty = options:GetProperty("AddEmpty")
	mod_HidePackButtons = options:GetProperty("HidePackButtons")
	mod_SortHubListLoad = options:GetProperty("SortHubListLoad")
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_UpdateDelay = options:GetProperty("UpdateDelay")
	mod_UseDroneHubs = options:GetProperty("UseDroneHubs")
	mod_UseCommanders = options:GetProperty("UseCommanders")
	mod_UseRockets = options:GetProperty("UseRockets")
	mod_EarlyGame = options:GetProperty("EarlyGame")
	mod_IgnoreUnusedHubs = options:GetProperty("IgnoreUnusedHubs")
	mod_DroneWorkDelay = options:GetProperty("DroneWorkDelay")
	mod_UsePrefabs = options:GetProperty("UsePrefabs")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local table = table
local table_ifilter = table.ifilter
local table_iclear = table.iclear
local table_icopy = table.icopy
local table_rand = table.rand
local table_insert = table.insert
local table_remove = table.remove
local CreateGameTimeThread = CreateGameTimeThread
local Sleep = Sleep
local Max = Max
local GameTime = GameTime
local IsValid = IsValid
local IsKindOf = IsKindOf
local floatfloor = floatfloor
local AsyncRand = AsyncRand

local DroneLoadLowThreshold = const.DroneLoadLowThreshold
local DroneLoadMediumThreshold = const.DroneLoadMediumThreshold
local idle_drone_cmds = {
	Idle = true,
	GoHome = true,
	WaitingCommand = true,
	Start = true,
}

local GetIdleDrones = ChoGGi.ComFuncs.GetIdleDrones
local FisherYates_Shuffle = ChoGGi.ComFuncs.FisherYates_Shuffle
local DroneHubLoad = ChoGGi.ComFuncs.DroneHubLoad

-- height is actually 188: point(0, 0, SelectedObj:GetObjectBBox():sizez())
-- just adding some buffer if carrying something whatnot
-- local drone_height = point(0, 0, 500)
-- local work_spots = {21, 22, 23, 24, 25}

local function SendDroneToCC(drone, new_hub)
	if drone.ChoGGi_SendDroneToCC_Wait then
		return
	end
	local old_hub = drone.command_center
	if old_hub == new_hub then
		return
	end

	-- ultra valid
	if IsValid(old_hub) and IsValid(new_hub) and IsValid(drone) then
		-- if drone dist to new hub is further than dist to old hub than teleport near hub before reassignment
		if drone:GetDist(old_hub) < drone:GetDist(new_hub) then
			-- we don't want this func touching a drone already on the move
			drone.ChoGGi_SendDroneToCC_Wait = new_hub

			-- incredible shrinking ray
			local steps = 100
			for i = steps, 1, -1 do
				steps = steps - 1
				drone:SetScale(i)
				Sleep(100)
			end

			-- 15 = inside door
			drone:SetPos(new_hub:GetSpotPos(15))
			drone:SetCommandCenter(false)
			drone:SetHolder(new_hub)

			-- restore back to regular size
			drone:SetScale(100)

			drone.ChoGGi_SendDroneToCC_Wait = nil
		end

		-- and done
		drone:SetCommandCenter(new_hub)
		drone:SetCommand("Idle")
	end

end

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

local function AssignWorkingDrones(drones, count, hub, not_rand)
	local drones_c = #drones
	for _ = 1, count do

		local drone, idx
		if not_rand then
			drone, idx = drones[drones_c], drones_c
		else
			drone, idx = table_rand(drones)
		end

		if drone and idx then
			-- need to remove entry right away (before table idx changes)
			table_remove(drones, idx)
			-- no need to move to same hub
			if not drone.ChoGGi_WaitingForIdleDrone and drone.command_center ~= hub then
				drone.ChoGGi_WaitingForIdleDrone = CreateGameTimeThread(function()
					-- wait till drone is idle then send it off
					local count = 0
					while not idle_drone_cmds[drone.command] do
						-- stop waiting after so long
						if mod_DroneWorkDelay > 0 and count >= mod_DroneWorkDelay then
							break
						end
						Sleep(1000)
						count = count + 1
					end
					drone.ChoGGi_WaitingForIdleDrone = nil
					SendDroneToCC(drone, hub)
				end)
				drones_c = drones_c - 1
				if drones_c == 0 then
					break
				end
			end
		end
	end
end

local function AssignDrones(hub)
	local count = threshold == "heavy" and mod_AddHeavy or mod_AddMedium

	-- use up any prefabs
	if mod_UsePrefabs then
		for _ = 1, (AsyncRand(count)+1) do
			hub:UseDronePrefab()
		end
	end

	-- reassign idle drones
	local idle_drones_c = #idle_drones
	if idle_drones_c > 0 then
		for _ = 1, count do
			local drone, idx = table_rand(idle_drones)
			if drone and idx then
				table_remove(idle_drones, idx)
				CreateGameTimeThread(SendDroneToCC, drone, hub)
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
		AssignWorkingDrones(low_drones, count, hub)
	end
	-- reassign medium load drones
	AssignWorkingDrones(med_drones, count, hub)
end

local function FilterBorkedDrones(_, drone)
	return not drone:IsDisabled()
end

local function UpdateHubs()
	for i = 1, hub_count do
		local hub = filtered_hubs[i]
		local drones = hub.drones

		-- no drones/no working drones
		if (threshold == "empty" or threshold == "all") and
			(#drones == 0 or #table_ifilter(drones, FilterBorkedDrones) == 0)
		then
			AssignDrones(hub)
		else
			-- function DroneControl:CalcLapTime()
			local lap_time = Max(hub.lap_time, GameTime() - hub.lap_start)

			if lap_time < DroneLoadLowThreshold then
				-- low load
			elseif lap_time < DroneLoadMediumThreshold then
				if threshold == "medium" or threshold == "all" then
					-- medium load
					AssignDrones(hub)
				end
			elseif (threshold == "heavy" or threshold == "all") then
				-- high load
				AssignDrones(hub)
			end
			--
		end

	end
end

local function BuildDroneList()
	for i = 1, hub_count do
		local hub = filtered_hubs[i]
		local drones = hub.drones

		if #drones == 0 or #table_ifilter(drones, FilterBorkedDrones) < 1 then
			-- no drones
		else
			-- function DroneControl:CalcLapTime(), wanted the funcs local since we call this a lot
			local lap_time = Max(hub.lap_time, GameTime() - hub.lap_start)
--~ 			local lap_time = #drones == 0 and 0 or Max(hub.lap_time, GameTime() - hub.lap_start)

			if lap_time < DroneLoadLowThreshold then
				-- low load
				local c = #low_drones
				for j = 1, #drones do
					c = c + 1
					low_drones[c] = drones[j]
				end
			elseif lap_time < DroneLoadMediumThreshold then
				-- medium load
				local c = #med_drones
				for j = 1, #drones do
					c = c + 1
					med_drones[c] = drones[j]
				end
			end
		end

	end
end

local function UpdateDrones()
	if not mod_EnableMod then
		return
	end

	local UICity = UICity
	local hubs = UICity.labels.DroneControl or ""

--~ 	ex(filtered_hubs)

	-- build list of filtered hubs
	table_iclear(filtered_hubs)
	hub_count = 0
	table_iclear(useless_hubs)
	local use_hubs_c = 0
	for i = 1, #hubs do
		local hub = hubs[i]
		-- build list of hubs to use
		if hub.working and
			(mod_UseCommanders and hub:IsKindOf("RCRover")
			or mod_UseDroneHubs and hub:IsKindOf("DroneHub")
			or mod_UseRockets and hub:IsKindOf("RocketBase"))
		then
			hub_count = hub_count + 1
			filtered_hubs[hub_count] = hub
		else
			-- we only clear these hubs if mod option (and only after checking hub_count)
			if hub.working then
				use_hubs_c = use_hubs_c + 1
				useless_hubs[use_hubs_c] = hub
			else
				-- always clear out borked hubs
				for _ = 1, #(hub.drones or "") do
					hub:ConvertDroneToPrefab()
				end
			end
		end
	end

	-- not much point if there's only one hub
	if hub_count < 2 then
		return
	end

	-- remove any drones from hubs we don't use
	if not mod_IgnoreUnusedHubs then
		for i = 1, use_hubs_c do
			local hub = useless_hubs[i]
			for _ = 1, #(hub.drones or "") do
				hub:ConvertDroneToPrefab()
			end
		end
	end

	-- sort hubs by drone load (empty, heavy, med, low)
	if mod_SortHubListLoad then
		table.sort(filtered_hubs, function(a, b)
			return DroneHubLoad(a, true) > DroneHubLoad(b, true)
		end)
	-- randomise hub list (firsters get more drones)
	else
		FisherYates_Shuffle(filtered_hubs)
		-- stick all empty hubs at start (otherwise they may stay empty for too long)
		for i = 1, hub_count do
			if #filtered_hubs[i].drones == 0 then
				table_insert(filtered_hubs, 1, table_remove(filtered_hubs, i))
			end
		end
	end

	-- if there's less drones then the threshold set in mod options we evenly split drones across hubs
	-- copied so we can table.remove from it (maybe filter out the not working drones?)
	local drones = table_icopy(UICity.labels.Drone or empty_table)
	if mod_EarlyGame == 0 or mod_EarlyGame > #drones then
		-- get numbers for amount of drones split between hubs (rounded down)
		local split_count = floatfloor(#drones / hub_count)
		local leftovers = #drones - (split_count * hub_count)

		-- if all hubs have the same/more than the "split" amount skip assigning drones
		local low_count = false
		for i = 1, hub_count do
			local hub = filtered_hubs[i]
			if #hub.drones < split_count then
				low_count = true
			end
		end
		if not low_count then
			return
		end

		-- assign drones to hubs
		for i = 1, hub_count do
			AssignWorkingDrones(drones, split_count, filtered_hubs[i], true)
		end

		-- random assign for leftover round down drones
		CreateGameTimeThread(function()
			Sleep(1000)
			for _ = 1, leftovers do
				AssignWorkingDrones(drones, 1, filtered_hubs[AsyncRand(hub_count)+1], true)
			end
		end)

		-- we don't want the load sorting to happen
		return
	end
	-- nothing below happens if early game enabled

	-- build list of idle drones from all hubs
	idle_drones = GetIdleDrones()

	-- update empty drone hubs first
	threshold = "empty"
	UpdateHubs()

	-- build list of drones from low/medium load hubs
	table_iclear(med_drones)
	table_iclear(low_drones)
	BuildDroneList()

	-- update heavy load drone hubs (some may turn into medium after)
	threshold = "heavy"
	UpdateHubs()

	-- update med load drone hubs
	threshold = "medium"
	UpdateHubs()


	threshold = "all"
	UpdateHubs()
end

function OnMsg.NewDay()
	if mod_UpdateDelay then
		UpdateDrones()
	end
end

function OnMsg.NewHour()
	if not mod_UpdateDelay then
		UpdateDrones()
	end
end
