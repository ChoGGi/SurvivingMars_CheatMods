local table_find = table.find

function OnMsg.LoadGame()
	local rockets = UICity.labels.SupplyRocket or ""
	for i = 1, #rockets do
		local r = rockets[i]
		if r.command == "Unload" then
			local pass = table_find(r.cargo, "class", "Passengers")
			pass = r.cargo[pass]
			-- has expectation of passengers, but none are on the rocket
			if pass and pass.amount > 0 and #pass.applicants_data == 0 then
				r:SetCommand("Unload")
			end
		end
	end
end
