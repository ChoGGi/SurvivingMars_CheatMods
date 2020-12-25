-- See LICENSE for terms

local mod_EnableDrones
local mod_EnableColonists

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableDrones = CurrentModOptions:GetProperty("EnableDrones")
	mod_EnableColonists = CurrentModOptions:GetProperty("EnableColonists")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local table = table
local ObjModified = ObjModified
local Sleep = Sleep
local SelectObj = SelectObj
local InteractionRand = InteractionRand
local empty_table = empty_table

local sort_obj
local function SortByDist(a, b)
	return a:GetVisualDist2D(sort_obj) < b:GetVisualDist2D(sort_obj)
end

local orig_RocketExpedition_ExpeditionLoadDrones = RocketExpedition.ExpeditionLoadDrones
function RocketExpedition:ExpeditionLoadDrones(num_drones, ...)
	if not mod_EnableDrones then
		return orig_RocketExpedition_ExpeditionLoadDrones(self, num_drones, ...)
	end

	while true do
		-- wait to have enough drones
		local drones = {}

		-- prefer own drones first
		while #drones < num_drones and #(self.drones or empty_table) > 0 do
			local drone = self:ExpeditionPickDroneFrom(self, drones)
			if not drone then
				break
			end
			table.insert(drones, drone)
		end

--~ 		-- pick from other drone controllers
--~ 		local list = table.copy(UICity.labels.DroneControl or empty_table)
--~ 		local idx = 1
--~ 		while #drones < num_drones and #list > 0 do
--~ 			local drone = self:ExpeditionPickDroneFrom(list[idx], drones)
--~ 			if drone then
--~ 				table.insert(drones, drone)
--~ 				idx = idx + 1
--~ 			else
--~ 				table.remove(list, idx)
--~ 			end
--~ 			if idx > #list then
--~ 				idx = 1
--~ 			end
--~ 		end

		-- sort drone controller list to be closest to rocket
		local list = table.copy((self.city or UICity).labels.DroneControl or empty_table)
		sort_obj = self
		table.sort(list, SortByDist)
		-- pick from other drone controllers
		local idx = 1
		while #drones < num_drones and #list > 0 do
			local success

			local controller = list[idx]
			for i = 1, #(controller.drones or "") do
				local drone = controller.drones[i]
				-- find any idle drones and check if we've hit max added
				if drone.command == "Idle" and #drones < num_drones and
					drone:CanBeControlled() and not table.find(drones, drone)
				then
					table.insert(drones, drone)
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

		self.drone_summon_fail = #drones < num_drones
		ObjModified(self)
		if #drones >= num_drones then
--~ 			for _, drone in ipairs(drones) do
			for i = 1, #drones do
				local drone = drones[i]
				if drone == SelectedObj then
					SelectObj()
				end
				drone:SetCommandCenter(false, "do not orphan!")
				drone:SetHolder(self)
				drone:SetCommand("Disappear", "keep in holder")
			end
			self.expedition.drones = drones
			break
		else
			Sleep(1000)
		end
	end
end

local function adult_filter(_, colonist)
	return not colonist.traits.Child
end
local orig_RocketExpedition_ExpeditionGatherCrew = RocketExpedition.ExpeditionGatherCrew
function RocketExpedition:ExpeditionGatherCrew(num_crew, label, ...)
	if not mod_EnableColonists then
		return orig_RocketExpedition_ExpeditionGatherCrew(self, num_crew, label, ...)
	end

	-- instead of going through UICity.label, we'll go through each dome in order of distance to rocket
	label = label or "Colonist"
	while true do
		local domes = table.copy((self.city or UICity).labels.Dome or empty_table)
		sort_obj = self
		table.sort(domes, SortByDist)

		local list = self.city.labels[label] and table.ifilter(self.city.labels[label], adult_filter) or empty_table
		if #list >= num_crew then
			if not self.expedition.crew then
				self.expedition.crew = {}
			end
			local crew = self.expedition.crew

			for i = 1, #domes do
				local dome = domes[i]
				local list = dome.labels[label] and table.ifilter(dome.labels[label], adult_filter) or empty_table

	--~ 			self.colonist_summon_fail = #list < num_crew
				self.colonist_summon_fail = #crew < num_crew
				ObjModified(self)

				for _ = 1, #list do
					if #crew < num_crew then
						local unit = table.rand(list, InteractionRand("PickCrew"))
						table.remove_value(list, unit)
						table.insert(crew, unit)
						if unit == SelectedObj then
							SelectObj()
						end
						unit:SetHolder(self)
						unit:SetCommand("Disappear", "keep in holder")
					end
				end

				-- all filled up
				if #crew == num_crew then
					break
				end
			end
		end

		-- for some reason this while true do doesn't "abort" like ExpeditionLoadDrones does (probably something I did it doesn't like but eh this works)
		if #(self.expedition.crew or "") == num_crew then
			break
		else
			Sleep(1000)
		end
	end
end
