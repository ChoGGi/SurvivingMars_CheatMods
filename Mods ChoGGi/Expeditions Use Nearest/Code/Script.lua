-- See LICENSE for terms

local IsValid = IsValid
local table = table
local ObjModified = ObjModified
local Sleep = Sleep
local InteractionRand = InteractionRand

local mod_EnableDrones
local mod_EnableColonists

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableDrones = CurrentModOptions:GetProperty("EnableDrones")
	mod_EnableColonists = CurrentModOptions:GetProperty("EnableColonists")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local sort_obj
local function SortByDist(a, b)
	return a:GetVisualDist2D(sort_obj) < b:GetVisualDist2D(sort_obj)
end
-- filter for ExpeditionPickDroneFrom (thanks SkiRich)
local function FilterOutsideDrones(drone)
	return not drone.holder
end

local ChoOrig_CargoTransporter_ExpeditionFindDrones = CargoTransporter.ExpeditionFindDrones
function CargoTransporter:ExpeditionFindDrones(num_drones, ...)
	if not mod_EnableDrones then
		return ChoOrig_CargoTransporter_ExpeditionFindDrones(self, num_drones, ...)
	end

	local Cities = Cities

	-- wait to have enough drones, load if we are a go, stop if not (thanks SkiRich)
	while IsValid(self) do
		local found_drones = {}

		-- prefer own drones first
		while #found_drones < num_drones and #(self.drones or empty_table) > 0 do
			local drone = ExpeditionPickDroneFrom(self, found_drones, FilterOutsideDrones)
			if not drone then
				break
			end
			table.insert(found_drones, drone)
		end

		-- thanks Ski
		local city = self.city or (Cities[self:GetMapID()]) or empty_table
		-- sort drone controller list to be closest to rocket
		local list = table.copy(city.labels.DroneControl or empty_table)
		sort_obj = self
		table.sort(list, SortByDist)

		-- pick from other drone controllers
		local idx = 1
		while #found_drones < num_drones and #list > 0 do
			local success

			local controller = list[idx]
			for i = 1, #(controller.drones or "") do
				local drone = controller.drones[i]
				-- find any idle drones and check if we've hit max added
				if drone.command == "Idle" and #found_drones < num_drones and
					drone:CanBeControlled() and not table.find(found_drones, drone)
				then
					table.insert(found_drones, drone)
					success = true
				end
			end

			if success then
				idx = idx + 1
			else
				table.remove(list, idx)
			end
			if idx > #list then
				idx = 1
			end
		end

		self.drone_summon_fail = #found_drones < num_drones
		ObjModified(self)
		if #found_drones >= num_drones then
			return found_drones
		else
			Sleep(1000)
		end
	end
end

local function adult_filter(_, colonist)
	return not colonist.traits.Child
end
local ChoOrig_CargoTransporter_ExpeditionGatherCrew = CargoTransporter.ExpeditionGatherCrew
function CargoTransporter:ExpeditionGatherCrew(num_crew, label, quick_load, ...)
	if not mod_EnableColonists then
		return ChoOrig_CargoTransporter_ExpeditionGatherCrew(self, num_crew, label, quick_load, ...)
	end

	-- instead of going through UICity.label, we'll go through each dome in order of distance to rocket
	label = label or "Colonist"
	local count = 0
	while true do
		local domes = table.copy((self.city or UICity).labels.Dome or empty_table)
		sort_obj = self
		table.sort(domes, SortByDist)

		local new_crew = {}

		local list = self.city.labels[label] and table.ifilter(self.city.labels[label], adult_filter) or empty_table
		-- grab colonists from closest domes
		if #list >= num_crew then
			for i = 1, #domes do
				local dome = domes[i]
				local dome_list = dome.labels[label] and table.ifilter(dome.labels[label], adult_filter) or empty_table
				for _ = 1, #dome_list do
					if #new_crew < num_crew then
						local unit = table.rand(dome_list, InteractionRand("PickCrew"))
						table.remove_value(dome_list, unit)
						table.insert(new_crew, unit)
					else
						break
					end
				end
			end
		end

		self.colonist_summon_fail = num_crew > #new_crew
		ObjModified(self)

		if num_crew <= #new_crew or quick_load then
			local crew = {}
			while 0 < #new_crew and num_crew > #crew do
				local unit = table.rand(new_crew, InteractionRand("PickCrew"))
				table.remove_value(new_crew, unit)
				table.insert(crew, unit)
			end
			return crew
		end

		if count> 10 then
			return {}
		end

		count = count + 1
		Sleep(1000)
	end
end
