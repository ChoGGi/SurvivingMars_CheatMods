-- See LICENSE for terms (for my code only, not sure what Crysm used)


--~ AutomaticDronePlant

local table = table
local T = T

GlobalVar("DistributedDroneAssembly", false)

local mod_AutoPrefabDrones
local mod_OverrideCtrlBiorobot
local mod_OverrideCtrlDrone

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AutoPrefabDrones = CurrentModOptions:GetProperty("AutoPrefabDrones")
	mod_OverrideCtrlBiorobot = CurrentModOptions:GetProperty("OverrideCtrlBiorobot")
	mod_OverrideCtrlDrone = CurrentModOptions:GetProperty("OverrideCtrlDrone")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function StartupCode()
	if not DistributedDroneAssembly then
		DistributedDroneAssembly = {
			LocalConstrLimit = 2,
			Queue = {},
			AndroidsInQueue = 0,
			DronesInQueue = 0,
		}
	end
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function AddNewConstructs(xtemplate, id)
	local idx = table.find(xtemplate, "OnPressParam", id)
	if not idx then
		return
	end
	local button = xtemplate[idx]
	--
	local new_id = "Dda" .. id
	button.OnPressParam = new_id
	button.OnPress = function(self, gamepad)
		local c = self.context
		c[new_id](c, 1 * (not gamepad and IsMassUIModifierPressed() and 5 or 1))
	end
	button.OnAltPress = function(self, gamepad)
		local c = self.context
		c[new_id](c, -1 * (not gamepad and IsMassUIModifierPressed() and 5 or 1))
	end
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.customDroneFactory[1]

	-- Uninstall any preexisting control
	local idx = table.find(xtemplate, "group", "DistributedDroneAssembly")
	if idx then
		table.remove(xtemplate, idx)
	end

	-- add the infopanel section
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"group", "DistributedDroneAssembly",
		"id", "DdaIpSection",
		"__template", "InfopanelSection",
		"RolloverText", T(499093307, [[<left>"Scheduled" drones have been removed from the global queue and assigned to a particular Drone Assembler.

"Queued" drones are still in the global queue, and have not yet been assigned to a Drone Assembler.]]),
		"RolloverTitle", T(499093308, "Distributed Drone Assembly"),
		"Icon", "UI/Icons/IPButtons/drone.tga",
		"Title", T(499093310, "Distributed Drone Assembly"),
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelText",
				"Text", T("<DdaSectionUI>"),
		})
	})

	-- try to find the controls to wrap
	AddNewConstructs(xtemplate, "ConstructDrone")
	AddNewConstructs(xtemplate, "ConstructAndroid")
	--
end
--
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
	local dda = DistributedDroneAssembly

	-- won't work for mods that add it underground/asteroids
	local objs = UIColony:GetCityLabels("DroneFactory")

	-- queue up prefabs
	if mod_AutoPrefabDrones > 0 and #objs > 0 then

		local drone_prefabs_count = 0
		local Cities = Cities
		for i = 1, #Cities do
			drone_prefabs_count = drone_prefabs_count + (Cities[i].drone_prefabs or 0)
		end

		-- -1 for drone being built
		local add_amount = mod_AutoPrefabDrones - drone_prefabs_count - dda.DronesInQueue - 1
--~ 		print("add_amount",add_amount,mod_AutoPrefabDrones,MainCity.drone_prefabs,dda.DronesInQueue)

		if add_amount > 0 then
			dda.DronesInQueue = dda.DronesInQueue + add_amount
			for _ = 1, add_amount do
				dda.Queue[#dda.Queue+1] = "Drone"
			end
		end
	end

	-- smaller vars don't make shit faster, just more annoying to figure out what's up
	local df = {}
	local df_c = 0
	local changed = false

	if #dda.Queue == 0 then
		return
	end

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
		T(499093312, "<left>Scheduled Drone (Global)<right>"),
		assigned_drones,
		T("<icon_Drone>"),
	}
	local c = 3

	local brain = UIColony:IsTechResearched("ThePositronicBrain")

	if brain then
		c = c + 1
		str_list[c] = T(499093313, "\n<left>Scheduled Biorobots (Global)<right>")
		c = c + 1
		str_list[c] = assigned_androids
		c = c + 1
		str_list[c] = T("<icon_Colonist>")
	end

	c = c + 1
	str_list[c] = T(499093314, "\n<left>Queued Drone (Global)<right>")
	c = c + 1
	str_list[c] = DistributedDroneAssembly.DronesInQueue
	c = c + 1
	str_list[c] = T("<icon_Drone>")

	if brain then
		c = c + 1
		str_list[c] = T(499093315, "\n<left>Queued Biorobots (Global)<right>")
		c = c + 1
		str_list[c] = DistributedDroneAssembly.AndroidsInQueue
		c = c + 1
		str_list[c] = T("<icon_Colonist>")
	end

	return table.concat(str_list)
end

function DroneFactory:DdaConstructDrone(change, requestor)
	if change == 5 then
		change = mod_OverrideCtrlDrone
	end

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
	if change == 5 then
		change = mod_OverrideCtrlBiorobot
	end

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
