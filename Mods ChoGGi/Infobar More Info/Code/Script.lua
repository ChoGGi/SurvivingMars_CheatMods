-- See LICENSE for terms

-- See LICENSE for terms

local options
local mod_SkipGrid0
local mod_SkipGrid1
local mod_MergedGrids
local mod_RolloverWidth

-- fired when settings are changed and new/load
local function ModOptions()
	mod_SkipGrid0 = options.SkipGrid0
	mod_SkipGrid1 = options.SkipGrid1
	mod_MergedGrids = options.MergedGrids
	mod_RolloverWidth = options.RolloverWidth * 10

	-- ECM already changes it
	if not table.find(ModsLoaded, "id", "ChoGGi_CheatMenu") then
		-- update rollovers
		local roll = XTemplates.Rollover[1]
		local idx = table.find(roll, "Id", "idContent")
		if idx then
			roll = roll[idx]
			idx = table.find(roll, "Id", "idText")
			if idx then
				roll[idx].MaxWidth = mod_RolloverWidth
			end
		end
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_InfobarAddDischargeRates" then
		return
	end

	ModOptions()
end

-- local some globals
local type = type
local table_insert = table.insert
local table_clear = table.clear
local table_iclear = table.iclear
local table_concat = table.concat
local table_copy = table.copy
local T = T
local IsValid = IsValid
local MapGet = MapGet
local HexBoundingCircle = HexBoundingCircle
local point = point
local FormatResource = FormatResource

local scale_hours = const.HourDuration
local scale_sols = const.DayDuration

-- research per sol
function OnMsg.AddResearchRolloverTexts(ret)
	ret[#ret+1] = "<newline><left>" .. T{445070088246,
		"Research per Sol<right><research(EstimatedDailyProduction)>",
		EstimatedDailyProduction = ResourceOverviewObj:GetEstimatedRP(),
	}
end

-- should the grid be displayed
local function SkipGrid(g)
	if mod_MergedGrids then
		return true
	end
	-- use max_production instead of production as that can be throttled and hide grids that "do stuff"
	-- and maybe think of something better to use, as this won't work for anal-retentive grids
	if mod_SkipGrid0 and (g.max_production + g.consumption) == 0 then
		return
	end

	if mod_SkipGrid1 and g.bld_count < 2 then
		return
	end

	return true
end

-- return time left or N/A
local function RemainingTime(g, scale)
	local timeleft = g.production - g.consumption
	if timeleft < 0 then
		-- losing resources
		return T{12265,
			"Remaining Time<right><time(time)>",
			time = (g.stored / (timeleft * -1)) * (scale or scale_hours)
		}
	else
		-- more prod than consump
		return T(12014, "Remaining Time") .. "<right>" .. T(130, "N/A")
	end
end

-- table cleared in funcs
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

local function CountSubDeposit(cls, city)
	local remaining_res = 0
	table_clear(count_deposit)
	local objs = (city or UICity).labels.ResourceExploiter or ""
	for i = 1, #objs do
		local deposits = objs[i].nearby_deposits
		local d1 = deposits and deposits[1]
		if d1 and d1:IsKindOf(cls) then
			remaining_res = CountDepositRemaining(remaining_res, deposits)
		end
	end
	return remaining_res
end

-- default grid info table
local default_grid = {
	discharge = 0,
	production = 0,
	max_production = 0,
	consumption = 0,
	storage_capacity = 0,
	stored = 0,
	bld_count = 0,
}
local merged_grid = table_copy(default_grid)
-- stores some string ids and grid info
local elec_grid_info = {
	string_ids = {
		-- Max production<right><power(production)>
		max_prod = 319,
		-- Max output<right><power(max_electricity_discharge)>
		max_output = 7784,
		max_output_value = "max_electricity_discharge",
		icon = T("<icon_Power>"),
	},
}
local air_grid_info = {
	string_ids = {
		-- Max production<right><air(production)>
		max_prod = 325,
		-- Max output<right><air(max_air_discharge)>
		max_output = 7783,
		max_output_value = "max_air_discharge",
		icon = T("<icon_Air>"),
	},
}
local water_grid_info = {
	string_ids = {
		-- Max production<right><water(production)>
		max_prod = 330,
		-- Max output<right><water(max_water_discharge)>
		max_output = 7785,
		max_output_value = "max_water_discharge",
		icon = T("<icon_Water>"),
	},
}

-- the "main" func for grids
local function BuildRollover(ret, grid_info, grid)
	local grid_c = #grid
	-- grid count was changed, so clear list
	if grid_c ~= #grid_info then
		table_iclear(grid_info)
	end

	-- clean up merged_grid if we're using it
	if mod_MergedGrids then
		merged_grid.discharge = 0
		merged_grid.production = 0
		merged_grid.max_production = 0
		merged_grid.consumption = 0
		merged_grid.storage_capacity = 0
		merged_grid.stored = 0
	end

	-- collect numbers (have to do two loops to play fair with mod_MergedGrids)
	for i = 1, grid_c do
		-- if old/new grid is the same count, no need for a new table, just overwrite existing numbers
		if not grid_info[i] then
			grid_info[i] = table_copy(default_grid)
		end
		local info = grid_info[i]
		local grid = grid[i]

		-- get grid total storage cap
		local cap = 0
		for j = 1, #grid.storages do
			cap = cap + grid.storages[j].storage_capacity
		end

		if mod_MergedGrids then
			merged_grid.discharge = merged_grid.discharge + (grid.discharge or 0)
			merged_grid.production = merged_grid.production + (grid.current_production or 0)
			merged_grid.max_production = merged_grid.production + (grid.current_throttled_production or 0)
			merged_grid.consumption = merged_grid.consumption + (grid.current_consumption or 0)
			merged_grid.stored = merged_grid.stored + (grid.current_storage or 0)
			merged_grid.storage_capacity = merged_grid.storage_capacity + cap
		else
			-- grids without storage have no discharge, so screw or 0 for all
			info.discharge = grid.discharge or 0
			-- not quite sure of the diff between .current_production and .production...
			info.production = grid.current_production or 0
			info.max_production = info.production + (grid.current_throttled_production or 0)
			info.consumption = grid.current_consumption or 0
			info.stored = grid.current_storage or 0
			info.storage_capacity = cap
			info.bld_count = #(grid.elements or "")
		end
	end

	-- have to get this BEFORE the below
	local str = grid_info.string_ids

	-- merged into one grid
	if mod_MergedGrids then
		grid_info = {merged_grid}
		grid_c = 1
	end

	-- cache Ts (every bit counts?)
	local str_header = {T("<color 119 212 255>")}
	local str_Count = T(3732, "Count")
	local str_grid1 = T(" <yellow>")
	local str_grid2 = T("</yellow><newline><left>")
	local str_Production = T(80, "Production")
	local str_Consumption = T(347, "Consumption")
	local str_Capacity = T(109035890389, "Capacity")
	local str_Storage = T(519, "Storage")

	-- now we can build the string to return
	local c = 0
	for i = 1, grid_c do
		local g = grid_info[i]
		if SkipGrid(g) then
			-- no need for the header if there's just the one grid
			if grid_c > 1 then
				if ret then
					c = c + 1
					ret[c] = "<newline><left><color 119 212 255>"
				else
					c = c + 1
					ret = str_header
				end
				c = c + 1
				ret[c] = T{11629, "GRID <i>", i = i}
				c = c + 1
				ret[c] = "</color> "
				c = c + 1
				ret[c] = str_Count
				c = c + 1
				ret[c] = str_grid1
				c = c + 1
				ret[c] = g.bld_count
				c = c + 1
				ret[c] = str_grid2
			elseif not ret then
				ret = {}
			end
			-- prod/max prod
			c = c + 1
			ret[c] = str_Production
			c = c + 1
			ret[c] = "/"
			c = c + 1
			ret[c] = T{str.max_prod,production = g.production}
			c = c + 1
			ret[c] = FormatResource(nil, g.max_production)
			-- capacity/demand
			c = c + 1
			ret[c] = "<newline><left>"
			c = c + 1
			ret[c] = str_Capacity
			c = c + 1
			ret[c] = "/"
			c = c + 1
			ret[c] = str_Consumption
			c = c + 1
			ret[c] = "<right>"
			c = c + 1
			ret[c] = FormatResource(nil, g.storage_capacity)
			c = c + 1
			ret[c] = str.icon
			c = c + 1
			ret[c] = FormatResource(nil, g.consumption)
			-- stored/max output
			c = c + 1
			ret[c] = "<newline><left>"
			c = c + 1
			ret[c] = str_Storage
			c = c + 1
			ret[c] = "/"
			c = c + 1
			ret[c] = T{str.max_output, [str.max_output_value] = g.stored}
			c = c + 1
			ret[c] = FormatResource(nil, g.discharge)
			-- grid time remaining
			c = c + 1
			ret[c] = "<newline><left>"
			c = c + 1
			ret[c] = str_Storage .. " " .. RemainingTime(g)
		end
	end
	return ret
end

local ResourceOverview = ResourceOverview

local orig_ResourceOverview_GetElectricityGridRollover = ResourceOverview.GetElectricityGridRollover
function ResourceOverview.GetElectricityGridRollover(...)
	local ret = BuildRollover(nil, elec_grid_info, UICity.electricity or "")

	-- no grids so return orig func
	return not ret and orig_ResourceOverview_GetElectricityGridRollover(...)
		or table_concat(ret)
--~ 			.. "\n\n\n" .. orig_ResourceOverview_GetElectricityGridRollover(...)
end

local infobar_cache
local terminal_GetMousePos = terminal.GetMousePos

local orig_ResourceOverview_GetLifesupportGridRollover = ResourceOverview.GetLifesupportGridRollover
function ResourceOverview.GetLifesupportGridRollover(...)
	-- get infobar
	if not infobar_cache or infobar_cache.window_state == "destroying" then
		infobar_cache = Dialogs.Infobar.idPad.idLifeSupport
	end

	-- air/water is a single text box, so we have to find out which side we're on
	local content_box = infobar_cache.content_box
	local half = content_box:sizex() / 2
	local offset = terminal_GetMousePos():x() - content_box:xyxy()

	local ret
	if offset > half then
		ret = BuildRollover(ret, water_grid_info, UICity.water or "")

		-- add water deposit remaining (to the top)
		if ret then
			table_insert(ret, 1, T(681, "Water") .. " " .. T(3982, "Deposits")
				.. "<right>" .. T{"<water(number)>",
				number = CountSubDeposit("SubsurfaceDepositWater")}
			)
			table_insert(ret, 2, "<newline><newline><left>")
		end
	else
		ret = BuildRollover(ret, air_grid_info, UICity.air or "")
	end

	-- no grids so return orig func
	return not ret and orig_ResourceOverview_GetLifesupportGridRollover(...)
		or table_concat(ret)
end

-- calc n return time left
local fake_grid = table_copy(default_grid)
local function ResRemaining(self, res_name, ret)
--~ ex(ret)

	fake_grid.stored = self["GetAvailable" .. res_name](self)
	fake_grid.production = self["Get" .. res_name .. "ProducedYesterday"](self)
	fake_grid.consumption = self["Get" .. res_name .. "ConsumedByConsumptionYesterday"](self)
		+ self["Get" .. res_name .. "ConsumedByMaintenanceYesterday"](self)

	local list = ret[1].table

	-- 3 is "production"
	table_insert(list, 3, T(359672804540, "Stored Resources") .. " "
		.. RemainingTime(fake_grid, scale_sols))

	-- add count of all new strings
	ret[1].j = ret[1].j + 1

	return ret
end

local function DepositRemaining(self, res_name, ret)
--~ 	ex(ret)
	table_clear(count_deposit)

	local res_str
	if res_name == "Concrete" then
		local remaining_res = 0
		-- get all concrete deposits around the miner

		-- local what we can
		local MaxTerrainDepositRadius = MaxTerrainDepositRadius

		local objs = UICity.labels.ResourceExploiter or ""
		for i = 1, #objs do
			-- kinda copy pasta from TerrainDepositExtractor:FindClosestDeposit()
			local obj = objs[i]
			if obj:IsKindOf("TerrainDepositExtractor") then
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
		end

		res_str = {"<concrete(number)>", number = remaining_res}
	elseif res_name == "PreciousMetals" then
		res_str = {"<preciousmetals(number)>", number = CountSubDeposit("SubsurfaceDeposit" .. res_name)}
	elseif res_name == "Metals" then
		res_str = {"<metals(number)>", number = CountSubDeposit("SubsurfaceDeposit" .. res_name)}
	end


	local list = ret[1].table

	-- just above Remaining Time
	table_insert(list, 3,
		T{"<resource(res)>", res = res_name} .. " " .. T(3982, "Deposits")
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
