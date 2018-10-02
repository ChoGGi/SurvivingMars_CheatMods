local function CleanGrids(name)
	local g_Classes = g_Classes
	local type = type

	local grids = UICity[name]
	-- go backwards (if anything gets removed)
	for i = #grids, 1, -1 do
		-- elements is a combined list of all objects attached to the grid
		local list = grids[i].elements
		for j = #list, 1, -1 do

			local b = list[j].building
			-- check what the class says; false means could be, nil means not happening.
			if type(g_Classes[b.class][name]) == "nil" then
				if name == "electricity" then
					if b.electricity then
						b.SetSupply = ElectricityConsumer.SetSupply
						ElectricityGridObject.SupplyGridDisconnectElement(b, b.electricity, ElectricityGrid)
						b.electricity = nil
						b.SetSupply = nil
					end
				-- air+water
				elseif b.water then
					b.SetSupply = LifeSupportConsumer.SetSupply
					LifeSupportGridObject.SupplyGridDisconnectElement(b, b.water, WaterGrid)
					b.water = nil
					b.air = nil
					b.SetSupply = nil
				end
			end

		end
	end
end

function OnMsg.LoadGame()
	CleanGrids("electricity")
	CleanGrids("water")
	CleanGrids("air")
end
