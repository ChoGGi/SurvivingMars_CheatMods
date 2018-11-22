local TableFind = table.find
local TableRemove = table.remove
local IsValid = IsValid
local InvalidPos = InvalidPos()

local function RemoveInvalid(count,list)
	for i = #list, 1, -1 do
		if not IsValid(list[i]) then
			count = count + 1
			TableRemove(list,i)
		end
	end
	return count
end

function OnMsg.LoadGame()
	local UICity = UICity
	local rockets = UICity.labels.AllRockets or ""
	for i = 1, #rockets do
		local r = rockets[i]

		-- skip any pods and ones not on the ground
		if not r:IsKindOf("SupplyPod") and r:GetPos() ~= InvalidPos then
			if r.command == "Unload" then

				-- has expectation of passengers, but none are on the rocket
				local pass = TableFind(r.cargo,"class","Passengers")
				pass = r.cargo[pass]
				if pass and pass.amount > 0 and #pass.applicants_data == 0 then
					r:SetCommand("Unload")
				end

				-- invalid drones
				local invalid = RemoveInvalid(0,r.drones_exiting or "")
				invalid = RemoveInvalid(invalid,r.drones_entering or "")
				invalid = RemoveInvalid(invalid,r.drones_in_queue_to_charge or "")
				invalid = RemoveInvalid(invalid,r.drones or "")
				UICity.drone_prefabs = UICity.drone_prefabs + invalid

			-- resends main com with whatever res is needed
			elseif r.command == "WaitMaintenance" then
				r:SetCommand("WaitMaintenance",r.maintenance_requirements.resource, r.maintenance_request:GetTargetAmount())
			end
		end

	end
end
