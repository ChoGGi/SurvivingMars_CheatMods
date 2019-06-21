-- See LICENSE for terms

local type = type
local table_insert = table.insert
local T = T

local function CountDischarge(list)
	local discharge = 0
	for i = 1, #list do
		discharge = discharge + list[i].discharge
	end
	return discharge
end

local orig_ResourceOverview_GetElectricityGridRollover = ResourceOverview.GetElectricityGridRollover
function ResourceOverview.GetElectricityGridRollover(...)
	local ret = orig_ResourceOverview_GetElectricityGridRollover(...)

	ret[1].j = ret[1].j + 1
	local list = ret[1].table
	list[#list+1] = T(519,"Storage") .. " " .. T{7784,
		"Max output<right><power(max_electricity_discharge)>",
		max_electricity_discharge = CountDischarge(UICity.electricity or ""),
	}

	return ret
end

local orig_ResourceOverview_GetLifesupportGridRollover = ResourceOverview.GetLifesupportGridRollover
function ResourceOverview.GetLifesupportGridRollover(...)
	local ret = orig_ResourceOverview_GetLifesupportGridRollover(...)

	-- gotta add air to correct palce
	local list = ret[1].table
	for i = 1, #list do
		local str = list[i]
		-- 12598 = air cap
		if type(str) == "table" and str[1] == 12598 then
			table_insert(list, i+1,
				T(519,"Storage") .. " " .. T{7783,
					"Max output<right><air(max_air_discharge)>",
					max_air_discharge = CountDischarge(UICity.air or ""),
				}
			)
			break
		end
	end

	ret[1].j = ret[1].j + 2
	list[#list+1] = T(519,"Storage") .. " " .. T{7785,
		"Max output<right><water(max_water_discharge)>",
		max_water_discharge = CountDischarge(UICity.water or ""),
	}

	return ret
end
