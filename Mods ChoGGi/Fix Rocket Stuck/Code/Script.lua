local TableFind = table.find

function OnMsg.LoadGame()
	local rockets = UICity.labels.SupplyRocket or ""
	for i = 1, #rockets do

		local r = rockets[i]

		-- has expectation of passengers, but none are on the rocket
		if r.command == "Unload" then
			local pass = TableFind(r.cargo,"class","Passengers")
			pass = r.cargo[pass]
			if pass and pass.amount > 0 and #pass.applicants_data == 0 then
				r:SetCommand("Unload")
			end

		-- resends main com with whatever res is needed
		elseif r.command == "WaitMaintenance" then
			r:SetCommand("WaitMaintenance",r.maintenance_requirements.resource, r.maintenance_request:GetTargetAmount())
		end

	end

end
