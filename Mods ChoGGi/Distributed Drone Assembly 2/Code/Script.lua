
local StringIdBase = 499093306 --randomly generated to avoid conflicts

local table = table
local T = T

GlobalVar("DistributedDroneAssembly", false)

local function DdaReinit() --force reinitialization of vars -- this will wipe out the queue
	DistributedDroneAssembly = {
		LocalConstrLimit = 2,
		Queue = {},
		AndroidsInQueue = 0,
		DronesInQueue = 0,
	}
end

local function DdaInstall()
	-- ERprint("DdaInstallControls")
	local xtemplate = XTemplates.customDroneFactory[1]

	-- Uninstall any preexisting controls
	for i = #xtemplate, 1, -1 do
		if xtemplate[i].group == "DistributedDroneAssembly" then
			table.remove(xtemplate, i)
		end
	end

	-- add the infopanel section
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"group", "DistributedDroneAssembly",
		"id", "DdaIpSection",
		"__template", "InfopanelSection",
		"RolloverText", T(StringIdBase + 1, [[<left>"Scheduled" drones have been removed from the global queue and assigned to a particular Drone Assembler.

"Queued" drones are still in the global queue, and have not yet been assigned to a Drone Assembler.]]),
		"RolloverTitle", T(StringIdBase + 2, "Distributed Drone Assembly"),
		"Icon", "UI/Icons/IPButtons/drone.tga",
		"Title", T(StringIdBase + 4, "Distributed Drone Assembly"),
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelText",
				"Text", T("<DdaSectionUI>"),
		})
	})

	-- try to find the controls to wrap
	for i = 1, #xtemplate do
		local v = xtemplate[i]
		if v.__template == "InfopanelButton" then
			if v.OnPressParam == "ConstructDrone"
				or v.OnPressParam == "DdaConstructDrone"
			then
				-- ERprint("Found ConstructDrone")
				v.OnPressParam = "DdaConstructDrone"
				v.OnPress = function(self, gamepad)
					self.context:DdaConstructDrone(1 * (not gamepad and IsMassUIModifierPressed() and 5 or 1))
				end
				v.OnAltPress = function(self, gamepad)
					self.context:DdaConstructDrone(-1 * (not gamepad and IsMassUIModifierPressed() and 5 or 1))
				end
			end
			if v.OnPressParam == "ConstructAndroid"
				or v.OnPressParam == "DdaConstructAndroid"
			then
				-- ERprint("Found ConstructAndroid")
				v.OnPressParam = "DdaConstructAndroid"
				v.OnPress = function(self, gamepad)
					self.context:DdaConstructAndroid(1 * (not gamepad and IsMassUIModifierPressed() and 5 or 1))
				end
				v.OnAltPress = function(self, gamepad)
					self.context:DdaConstructAndroid(-1 * (not gamepad and IsMassUIModifierPressed() and 5 or 1))
				end
			end
		end
	end

	if not DistributedDroneAssembly then
		DdaReinit()
	end
end

OnMsg.CityStart = DdaInstall
OnMsg.LoadGame = DdaInstall

local function DdaRecalcQueueAmounts()
	local dda = DistributedDroneAssembly

	dda.DronesInQueue = 0
	dda.AndroidsInQueue = 0

	for i = 1, #dda.Queue do
		if dda.Queue[i] == "Android" then
			dda.AndroidsInQueue = dda.AndroidsInQueue + 1
		else
			dda.DronesInQueue = dda.DronesInQueue + 1
		end
	end
end

local function DdaAdjustQueue(amount, kind)
	-- ERprint("DdaAdjustQueue -- %s -- %s", amount, kind)
	local dda = DistributedDroneAssembly
	if amount >= 0 then
		-- positive change
		while amount > 0 do
			dda.Queue[#dda.Queue+1] = kind
			amount = amount - 1
		end
	else
		-- negative change
		for i = #dda.Queue, 1, -1 do
			if dda.Queue[i] == kind then
				table.remove(dda.Queue, i)
				amount = amount + 1
				if amount >= 0 then
					DdaRecalcQueueAmounts()
					return
				end
			end
		end

		DdaRecalcQueueAmounts()
		return
	end

	DdaRecalcQueueAmounts()
end

function OnMsg.NewHour()
	-- ERprint("DdaHandler")

	local dda = DistributedDroneAssembly

	-- smaller vars don't make shit faster, just more annoying to figure out what's up
	local df = {}
	local df_c = 0
	local changed = false

	if #dda.Queue == 0 then
		return
	end

	-- won't work for mods that add it underground/asteroids
	local objs = MainCity.labels.DroneFactory or ""

	for i = 1, #objs do
		local obj = objs[i]
		if (obj.drones_in_construction + obj.androids_in_construction) < dda.LocalConstrLimit then
			df_c = df_c + 1
			df[df_c] = obj
		end
	end

	local rem = {}
	local rem_c = 0
	while #df > 0 and #dda.Queue > 0 do
		table.iclear(rem)
		rem_c = 0

		for i = #df, 1, -1 do
			local obj = df[i]

			if (obj.drones_in_construction + obj.androids_in_construction) < dda.LocalConstrLimit then
				if dda.Queue[1] == "Android" then
					obj:ConstructAndroid(1)
				else
					obj:ConstructDrone(1)
				end
				table.remove(dda.Queue, 1)
				changed = true
			end
			if (obj.drones_in_construction + obj.androids_in_construction) >= dda.LocalConstrLimit then
				rem_c = rem_c + 1
				rem[rem_c] = i
			end

			if #dda.Queue == 0 then
				break
			end
		end

		for i = 1, #rem do
			df[rem[i]] = nil
		end
	end

	if changed then
		DdaRecalcQueueAmounts()
	end

end

function DroneFactory:GetDdaSectionUI()
	local assigned_drones = 0
	local assigned_androids = 0

	local objs = self.city.labels.DroneFactory or ""
	for i = 1, #objs do
		local obj = objs[i]
		assigned_drones = assigned_drones + obj.drones_in_construction
		assigned_androids = assigned_androids + obj.androids_in_construction
	end

	local str_list = {
		T(StringIdBase + 6, "<left>Scheduled Drone (Global)<right>"),
		assigned_drones,
		T("<icon_Drone>"),
	}
	local c = 3

	local brain = UIColony:IsTechResearched("ThePositronicBrain")

	if brain then
		c = c + 1
		str_list[c] = T(StringIdBase + 7, "\n<left>Scheduled Biorobots (Global)<right>")
		c = c + 1
		str_list[c] = assigned_androids
		c = c + 1
		str_list[c] = T("<icon_Colonist>")
	end

	c = c + 1
	str_list[c] = T(StringIdBase + 8, "\n<left>Queued Drone (Global)<right>")
	c = c + 1
	str_list[c] = DistributedDroneAssembly.DronesInQueue
	c = c + 1
	str_list[c] = T("<icon_Drone>")

	if brain then
		c = c + 1
		str_list[c] = T(StringIdBase + 9, "\n<left>Queued Biorobots (Global)<right>")
		c = c + 1
		str_list[c] = DistributedDroneAssembly.AndroidsInQueue
		c = c + 1
		str_list[c] = T("<icon_Colonist>")
	end

	return table.concat(str_list)
end

function DroneFactory:DdaConstructDrone(change, requestor)
	-- ERprint("DroneFactory:DdaConstructDrone -- %s", change)
	local dda = DistributedDroneAssembly
	local count = abs(change)
	while count > 0 do
		if change > 0
			and (self.drones_in_construction + self.androids_in_construction) < dda.LocalConstrLimit
		then
			--Not busy locally; pass construction to local handler
			self:ConstructDrone(1, requestor)
		elseif change < 0 and #dda.Queue < 1 then
			--Cancelling a construction, but global queue is empty; pass cancellation to local handler
			self:ConstructDrone(-1, requestor)
		else
			DdaAdjustQueue(change / abs(change), "Drone")
		end
		count = count - 1
	end
end

function DroneFactory:DdaConstructAndroid(change, requestor)
	-- ERprint("DroneFactory:DdaConstructAndroid -- %s", change)
	local dda = DistributedDroneAssembly
	local count = abs(change)
	while count > 0 do
		if change > 0
			and (self.drones_in_construction + self.androids_in_construction) < dda.LocalConstrLimit
		then
			--Not busy locally; pass construction to local handler
			self:ConstructAndroid(1, requestor)
		elseif change < 0 and #dda.Queue < 1 then
			--Cancelling a construction, but global queue is empty; pass cancellation to local handler
			self:ConstructAndroid(-1, requestor)
		else
			DdaAdjustQueue(change / abs(change), "Android")
		end
		count = count - 1
	end
end


-- it's never called anywhere, so commented out
