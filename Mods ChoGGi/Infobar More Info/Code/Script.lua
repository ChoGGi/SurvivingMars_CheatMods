-- See LICENSE for terms

local type = type
local table_insert = table.insert
local T = T

local ResourceOverview = ResourceOverview

-- res per sol
function OnMsg.AddResearchRolloverTexts(ret)
	ret[#ret+1] = "<newline>" .. T{445070088246,
		"Research per Sol<right><research(EstimatedDailyProduction)>",
		EstimatedDailyProduction = ResourceOverviewObj:GetEstimatedRP(),
	}
end

-- grid info
local function CountBoth(list)
	local discharge, production = 0, 0
	for i = 1, #list do
		local grid = list[i]
		discharge = discharge + grid.discharge
		production = production + grid.production
	end
	return discharge, production
end

local orig_ResourceOverview_GetElectricityGridRollover = ResourceOverview.GetElectricityGridRollover
function ResourceOverview.GetElectricityGridRollover(...)
	local ret = orig_ResourceOverview_GetElectricityGridRollover(...)

	local discharge, production = CountBoth(UICity.electricity or "")

	-- add to correct place
	local list = ret[1].table
	for i = 1, #list do
		local str = list[i]

		-- 3620 = Power production
		if type(str) == "table" and str[1] == 3620 then
			table_insert(list, i+1, T{319,
					"Max production<right><power(production)>",
					production = production,
				}
			)

		end
	end

	-- fine on the end
	local list = ret[1].table
	list[#list+1] = T(519,"Storage") .. " " .. T{7784,
		"Max output<right><power(max_electricity_discharge)>",
		max_electricity_discharge = discharge,
	}

	-- add count of all new strings
	ret[1].j = ret[1].j + 2

	return ret
end

local orig_ResourceOverview_GetLifesupportGridRollover = ResourceOverview.GetLifesupportGridRollover
function ResourceOverview.GetLifesupportGridRollover(...)
	local ret = orig_ResourceOverview_GetLifesupportGridRollover(...)

	local discharge_air, production_air = CountBoth(UICity.air or "")
	local discharge_water, production_water = CountBoth(UICity.water or "")

	-- add to correct place
	local list = ret[1].table
	for i = 1, #list do
		local str = list[i]
		if type(str) == "table" then
			str = str[1]

			-- 12598 = Oxygen Capacity
			if str == 12598 then
				table_insert(list, i+1, T(519,"Storage") .. " " .. T{7783,
						"Max output<right><air(max_air_discharge)>",
						max_air_discharge = discharge_air,
					}
				)

			-- 3623 Oxygen production
			elseif str == 3623 then
				table_insert(list, i+1, T{325,
						"Max production<right><air(production)>",
						production = production_air,
					}
				)

			-- 3626 Water production
			elseif str == 3626 then
				table_insert(list, i+1, T{330,
						"Max production<right><water(production)>",
						production = production_water,
					}
				)
			end

		end
	end

	-- fine on the end
	list[#list+1] = T(519,"Storage") .. " " .. T{7785,
		"Max output<right><water(max_water_discharge)>",
		max_water_discharge = discharge_water,
	}

	-- add count of all new strings
	ret[1].j = ret[1].j + 4

	return ret
end


--~ ResourceOverviewObj:getMetalsProducedYesterday()

-- calc n return time left
local function ResRemaining(self, name, ret)
--~ ex(ret)
	local stored = self["GetAvailable" .. name](self)
	local prod = self["Get" .. name .. "ProducedYesterday"](self)
	local consump = self["Get" .. name .. "ConsumedByConsumptionYesterday"](self)
		+ self["Get" .. name .. "ConsumedByMaintenanceYesterday"](self)

	local daily = prod - consump
	local time_left

	if daily < 0 then
		-- losing resources
		time_left = T{12265,
			"Remaining Time<right><time(time)>",
			time = (stored / (daily * -1)) * const.Scale.sols
		}
	else
		-- more prod than consump
		time_left = T(12014, "Remaining Time") .. "<right>" .. T(130, "N/A")
	end

	local list = ret[1].table
	-- 3 is just above production
	table_insert(list, 3, T(0, "<resource('" .. name .. "')> ") .. time_left)

	-- add count of all new strings
	ret[1].j = ret[1].j + 1

	return ret
end

-- could be an indexed table if the devs made up their minds between rare and precious...
local resources = {
	RareMetals = "PreciousMetals",

	Metals = "Metals",
	Concrete = "Concrete",
	Food = "Food",
	Polymers = "Polymers",
	Electronics = "Electronics",
	MachineParts = "MachineParts",
	Seeds = "Seeds",
	WasteRock = "WasteRock",
	Fuel = "Fuel",
}

for func, res in pairs(resources) do
	local func_name = "Get" .. func .. "Rollover"
	local orig_func = ResourceOverview[func_name]
	ResourceOverview[func_name] = function(self, ...)
		return ResRemaining(self, res, orig_func(self, ...))
	end
end
