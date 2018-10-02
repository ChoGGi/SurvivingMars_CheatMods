local g_Classes = g_Classes
local type = type

local function CleanGrid(list)
	for i = #list, 1, -1 do
		local b = list[i].building
		-- check what the class says; false means could be, nil means not happening.
		if type(g_Classes[b.class][name]) == "nil" then
			if name == "electricity" and b.electricity then
				b.SetSupply = ElectricityConsumer.SetSupply
				ElectricityGridObject.SupplyGridDisconnectElement(b, b.electricity, ElectricityGrid)
				b.electricity = nil
				b.SetSupply = nil
			-- water/air
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

local function LoopGrids(name)
	local grids = UICity[name]
	-- go backwards (if anything gets removed)
	for i = #grids, 1, -1 do
		-- elements is a combined list of all objects attached to the grid
		CleanGrid(grids[i].elements)
	end
end

function OnMsg.LoadGame()
	LoopGrids("electricity")
	LoopGrids("water")
	LoopGrids("air")
end
