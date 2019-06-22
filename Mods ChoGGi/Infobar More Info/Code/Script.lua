-- See LICENSE for terms

local type = type
local table_insert = table.insert
local table_clear = table.clear
local T = T
local IsValid = IsValid
local MapGet = MapGet
local HexBoundingCircle = HexBoundingCircle
local point = point


-- research per sol
function OnMsg.AddResearchRolloverTexts(ret)
	ret[#ret+1] = "<newline>" .. T{445070088246,
		"Research per Sol<right><research(EstimatedDailyProduction)>",
		EstimatedDailyProduction = ResourceOverviewObj:GetEstimatedRP(),
	}
end

-- used for a couple funcs below
local count_deposit = {}

local function CountDepositRemaining(remaining, deposits)
	for i = 1, #deposits do
		local deposit = deposits[i]
		if not count_deposit[deposit] and IsValid(deposit) then
			remaining = remaining + deposit.amount
			-- skip counted deposits
			count_deposit[deposit] = true
		end
	end
	return remaining
end

-- grid info
local function CountBoth(list, city)
	local discharge, production, remaining_water = 0, 0, 0

	if city then
		table_clear(count_deposit)
		local objs = city.labels.ResourceExploiter or ""
		for i = 1, #objs do
			local deposits = objs[i].nearby_deposits
			local d1 = deposits and deposits[1]
			if d1 and d1:IsKindOf("SubsurfaceDepositWater") then
				remaining_water = CountDepositRemaining(remaining_water, deposits)
			end
		end
	end

	-- grids keep prod numbers for us
	for i = 1, #list do
		local grid = list[i]
		discharge = discharge + grid.discharge
		production = production + grid.production
	end

	return discharge, production, remaining_water
end

local ResourceOverview = ResourceOverview

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

	local UICity = UICity
	local discharge_air, production_air = CountBoth(UICity.air or "")
	local discharge_water, production_water, remaining_water = CountBoth(UICity.water or "", UICity)

	local prod_water_idx = 10
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
				prod_water_idx = i
			end

		end
	end

	-- above production
	table_insert(list, prod_water_idx, T(681, "Water") .. " " .. T(3982, "Deposits")
		.. "<right>" .. T{0, "<water(number)>", number = remaining_water}
	)

	-- fine on the end
	list[#list+1] = T(519,"Storage") .. " " .. T{7785,
		"Max output<right><water(max_water_discharge)>",
		max_water_discharge = discharge_water,
	}

	-- add count of all new strings
	ret[1].j = ret[1].j + 5

	return ret
end

-- calc n return time left
local function ResRemaining(self, res_name, ret)
--~ ex(ret)
	local stored = self["GetAvailable" .. res_name](self)
	local prod = self["Get" .. res_name .. "ProducedYesterday"](self)
	local consump = self["Get" .. res_name .. "ConsumedByConsumptionYesterday"](self)
		+ self["Get" .. res_name .. "ConsumedByMaintenanceYesterday"](self)

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

	-- 3 is "production"
	table_insert(list, 3, T(0, "<resource('" .. res_name .. "')> ") .. time_left)

	-- add count of all new strings
	ret[1].j = ret[1].j + 1

	return ret
end

local function DepositRemaining(self, res_name, ret)
--~ 	ex(ret)
	table_clear(count_deposit)

	local remaining_res = 0
	local res_str
	if res_name == "Concrete" then
		-- local what we can
		local MaxTerrainDepositRadius = MaxTerrainDepositRadius

		local objs = MapGet("map", "TerrainDepositExtractor")
		for i = 1, #objs do
			local obj = objs[i]
			-- get all concrete deposits around the miner
			-- almost copy pasta from TerrainDepositExtractor:FindClosestDeposit()
			local info = obj:GetRessourceInfo()
			local shape = obj:GetExtractionShape() or ""
			if not info or #shape == 0 then
				return
			end
			local radius, xc, yc = HexBoundingCircle(shape, obj)
			local center = point(xc, yc)

			remaining_res = CountDepositRemaining(remaining_res,
				MapGet(center, center, MaxTerrainDepositRadius + radius, info.deposit_class)
			)
		end

		res_str = {0, "<concrete(number)>", number = remaining_res}
	else

		local cls = "SubsurfaceDeposit" .. res_name
		local objs = UICity.labels.ResourceExploiter or ""
		for i = 1, #objs do
			local deposits = objs[i].nearby_deposits
			local d1 = deposits and deposits[1]
			if d1 and d1:IsKindOf(cls) then
				remaining_res = CountDepositRemaining(remaining_res, deposits)
			end
		end

		if res_name == "PreciousMetals" then
			res_str = {0, "<preciousmetals(number)>", number = remaining_res}
		elseif res_name == "Metals" then
			res_str = {0, "<metals(number)>", number = remaining_res}
		end
	end


	local list = ret[1].table

	-- just above Remaining Time
	table_insert(list, 3,
		T{0, "<resource(res)>", res = res_name} .. " " .. T(3982, "Deposits")
			.. "<right>" .. T(res_str)
	)

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

local deposit_info = {
	PreciousMetals = true,
	Metals = true,
	Concrete = true,
}

for func, res_name in pairs(resources) do
	local func_name = "Get" .. func .. "Rollover"
	local orig_func = ResourceOverview[func_name]
	ResourceOverview[func_name] = function(self, ...)
		local ret = ResRemaining(self, res_name, orig_func(self, ...))
		-- deposit remaining info
		if deposit_info[res_name] then
			ret = DepositRemaining(self, res_name, ret)
		end
		return ret
	end
end
