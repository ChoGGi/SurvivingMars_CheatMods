-- See LICENSE for terms

local table = table
local ObjModified = ObjModified
local Sleep = Sleep
local SelectObj = SelectObj

function RocketExpedition:ExpeditionLoadDrones(num_drones)
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
		-- sort drone controller list to be closest to rocket (sort order doesn't matter that I know of)
		local list = table.copy((self.city or UICity).labels.DroneControl or empty_table)
		table.sort(list, function(a, b)
			return a:GetVisualDist2D(self) < b:GetVisualDist2D(self)
		end)
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
