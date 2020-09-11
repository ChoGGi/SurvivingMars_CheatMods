-- See LICENSE for terms

-- local some globals
local table = table
local table_insert = table.insert
local table_clear = table.clear
local table_iclear = table.iclear
local table_concat = table.concat
local table_copy = table.copy
local pairs = pairs
local type = type
local IsT = IsT
local T = T
local IsValid = IsValid
local MapGet = MapGet
local HexBoundingCircle = HexBoundingCircle
local point = point
local FormatResource = FormatResource
local floatfloor = floatfloor

local scale_hours = const.HourDuration
local scale_sols = const.DayDuration
local remaining_time_str = {12265, "Remaining Time<right><time(time)>"}



-- mod options
local options
local mod_SkipGrid0
local mod_SkipGrid1
local mod_SkipGridX
local mod_MergedGrids
local mod_RolloverWidth
local mod_DisableTransparency

local function UpdateTrans()
	CreateRealTimeThread(function()
		local Dialogs = Dialogs
		if not Dialogs.Infobar then
			local Sleep = Sleep
			while not Dialogs.Infobar do
				Sleep(250)
			end
		end
		local image = CurrentModPath .. "UI/resources.png"
		local infobar = Dialogs.Infobar
		if mod_DisableTransparency then
			infobar.idPad:SetImage(image)
			if infobar.idTerraformingBar then
				infobar.idTerraformingBar.idPad:SetImage(image)
			end
		else
			-- get this path from game maybe?
			infobar.idPad:SetImage("UI/CommonNew/resources.tga")
			if infobar.idTerraformingBar then
				infobar.idTerraformingBar.idPad:SetImage("UI/CommonNew/resources.tga")
			end
		end
	end)
end

OnMsg.InGameInterfaceCreated = UpdateTrans

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_SkipGrid0 = options:GetProperty("SkipGrid0")
	mod_SkipGrid1 = options:GetProperty("SkipGrid1")
	mod_SkipGridX = options:GetProperty("SkipGridX")
	mod_MergedGrids = options:GetProperty("MergedGrids")
	mod_RolloverWidth = options:GetProperty("RolloverWidth") * 10
	mod_DisableTransparency = options:GetProperty("DisableTransparency")

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

	if Dialogs.Infobar then
		UpdateTrans()
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

function OnMsg.AddResearchRolloverTexts(ret, city)
	local res_points = ResourceOverviewObj:GetEstimatedRP() + 0.0

	-- research per sol
	ret[#ret+1] = "<newline>" .. T{445070088246,
		"Research per Sol<right><research(EstimatedDailyProduction)>",
		EstimatedDailyProduction = res_points,
	}
	-- time left of current res
	local id, points, max_points = city:GetResearchInfo()
	if not id then
		return
	end
	remaining_time_str.time = floatfloor(((max_points - points) / res_points) * scale_sols)
	ret[#ret+1] = T(311, "Research") .. " " .. T(remaining_time_str)
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

	if mod_SkipGridX > 0 and g.bld_count <= mod_SkipGridX then
		return
	end

	return true
end

-- return time left or N/A
local under_an_hour = {"<red><text></red>"}
local function RemainingTime(g, scale)
	local time_left = g.production - g.consumption + 0.0
	-- losing resources
	if time_left < 0 then
		remaining_time_str.time = floatfloor((g.stored / (time_left * -1)) * (scale or scale_hours))
		local text = T(remaining_time_str)

		-- less than an hour
		if time_left == 0 then
			under_an_hour.text = text
			return T(under_an_hour)
		end

		return text
	else
		-- more prod than consump
		return T(12014, "Remaining Time") .. "<right>" .. T(130, "N/A")
	end
end

local count_deposit = {}
local function CountDepositRemaining(remaining, deposits)
	for i = 1, #deposits do
		local deposit = deposits[i]
		if not count_deposit[deposit] and IsValid(deposit) then
			remaining = remaining + (deposit.amount or 0)
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
		-- If old/new grid is the same count, no need for a new table, just overwrite existing numbers
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
			local deposit = CountSubDeposit("SubsurfaceDepositWater")
			if deposit > 0 then
				table_insert(ret, 1, T(681, "Water") .. " " .. T(3982, "Deposits")
					.. "<right>" .. T{"<water(number)>",
					number = deposit}
				)
				table_insert(ret, 2, "<newline><newline><left>")
			end
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
	local list = ret[1]

	fake_grid.stored = self["GetAvailable" .. res_name](self)
	fake_grid.production = self["Get" .. res_name .. "ProducedYesterday"](self)
	fake_grid.consumption = self["Get" .. res_name .. "ConsumedByConsumptionYesterday"](self)
		+ self["Get" .. res_name .. "ConsumedByMaintenanceYesterday"](self)

	-- 3 is "production"
	table_insert(list.table, 3, T(359672804540, "Stored Resources") .. " "
		.. RemainingTime(fake_grid, scale_sols))

	-- add count of all new strings
	list.j = list.j + 1

	return ret
end

local function DepositRemaining(self, res_name, ret)
--~ 	ex(ret)
	table_clear(count_deposit)
	local list = ret[1]

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

	-- just above Remaining Time
	table_insert(list.table, 3,
		T{"<resource(res)>", res = res_name} .. " " .. T(3982, "Deposits")
			.. "<right>" .. T(res_str)
	)

	-- add count of all new strings
	list.j = list.j + 1

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

-- add biorobots count/colonist percent
local colonist_age_lookup = {
	[554] = "children",
	[555] = "youths",
	[556] = "adults",
	[557] = "middleageds",
	[558] = "seniors",
	[8035] = "martianborn",
	[8036] = "earthborn",
}
local colonist_age_data = {
	children = 0,
	youths = 0,
	adults = 0,
	middleageds = 0,
	seniors = 0,
	martianborn = 0,
	earthborn = 0,
}
local orig_ResourceOverview_GetColonistsRollover = ResourceOverview.GetColonistsRollover
function ResourceOverview:GetColonistsRollover(...)
	local ret = orig_ResourceOverview_GetColonistsRollover(self, ...)
	local list = ret[1]
	local c = list.j

	-- add percent count to colonists
	-- 0.0 needed for maths (try 10/100 in console)
	local total = self:GetColonistCount() + 0.0
	-- floatfloor to cleanup numbers
	colonist_age_data.children = floatfloor((self.data.children / total) * 100)
	colonist_age_data.youths = floatfloor((self.data.youths / total) * 100)
	colonist_age_data.adults = floatfloor((self.data.adults / total) * 100)
	colonist_age_data.middleageds = floatfloor((self.data.middleageds / total) * 100)
	colonist_age_data.seniors = floatfloor((self.data.seniors / total) * 100)
	colonist_age_data.martianborn = floatfloor((self.data.martianborn / total) * 100)
	colonist_age_data.earthborn = floatfloor((self.data.earthborn / total) * 100)

	for i = 1, c do
		local item = list.table[i]
		if type(item) == "table" then
			local group = colonist_age_lookup[item[1]]
			if group then
				-- use 0 as string id to override text
				item[1] = 0
				item[2] = item[2] .. " " .. colonist_age_data[group] .. "%"
			end
		end
	end

--~ 	ex(list)

	-- biorobots count
	local UICity = UICity
	if UICity:IsTechResearched("ThePositronicBrain") then
		-- get android count in each dome (maybe faster than counting each colonist?)
		local ac = 0
		local objs = UICity.labels.Dome or ""
		for i = 1, #objs do
			ac = ac + #(objs[i].labels.Android or "")
		end
		-- add new entry to list
		c = c + 1
		list.table[c] = T("<left>") .. T(7303, "Biorobot") .. T{
			"<right><colonist(number)>", number = ac,
		}
		-- add count of all new strings
		list.j = c
	end


	return ret
end

-- add action + borked drone count
function OnMsg.ClassesPostprocess()
	-- sure be nice if xtemplates weren't so ugly to navigate
	local xtemplate = XTemplates.Infobar[1][3][1]
	local idx = table.find(xtemplate, "Id", "idColonists")
	if not idx then
		return
	end
	xtemplate = xtemplate[idx][2][1] -- IdTotalDrones

	local borked_str = T(65, "Malfunctioned") ..  " " .. T(517, "Drones")
	xtemplate.RolloverHint = T(11704, "<left_click> Cycle drone controllers")
		.. T("\n<right_click>") .. borked_str
	xtemplate.RolloverHintGamepad = T(11715, "<ButtonA> Cycle drone controllers<newline><DPad> Navigate <DPadDown> Close")
		.. T("\n<ButtonX>") .. borked_str

	xtemplate.AltPress = true
	xtemplate.OnAltPress = function(self)
		self.context:ChoGGi_CycleBorkedDrones()
	end
end

-- see Drone:IsDisabled()
local borked_drones_list = {}
function InfobarObj:ChoGGi_GetBrokenDrones()
	table_iclear(borked_drones_list)
	local c = 0
	-- gotta use mapget instead of labels since dead drones aren't included
	local objs = MapGet("map", "Drone")
	for i = 1, #objs do
		local obj = objs[i]
		if obj:IsDisabled() then
			c = c + 1
			borked_drones_list[c] = obj
		end
	end
	return borked_drones_list, c
end

local shuttlehubcount_str = {302535920011373, "<left>Shuttles Max/Total/Current<right><max>/<total>/<current>"}
local orig_GetDronesRollover = InfobarObj.GetDronesRollover
function InfobarObj:GetDronesRollover(...)
	local ret = orig_GetDronesRollover(self, ...)
	local list = ret[1]

	local _, count = self:ChoGGi_GetBrokenDrones()
	local c = list.j
	c = c + 1
	list.table[c] = T("<left>") .. T(65, "Malfunctioned") ..  " "
		.. T(517, "Drones") .. T{"<right><drone(number)>",
			number = count,
		}

	-- shuttle count
	local max, total, current = 0, 0, 0
	local labels = UICity.labels
	local hubs = labels.ShuttleHub
	if hubs then
		for i = 1, #hubs do
			local obj = hubs[i]
			max = max + (obj.max_shuttles or 0)
			total = total + #(obj.shuttle_infos or "")
		end
		-- currently flying around
		current = #(labels.CargoShuttle or "")

		c = c + 1
		shuttlehubcount_str.max = max
		shuttlehubcount_str.total = total
		shuttlehubcount_str.current = current
		list.table[c] = T(shuttlehubcount_str)
	end

	-- add count of all new strings
	list.j = c

	return ret
end

-- cycle borked drones on rightclick
function InfobarObj:ChoGGi_CycleBorkedDrones()
	local list, count = self:ChoGGi_GetBrokenDrones()
	if count > 0 then
		-- dunno why they localed it, instead of making it InfobarObj:CycleObjects()...
		local idx = SelectedObj and table.find(list, SelectedObj) or 0
		idx = (idx % count) + 1
		local next_obj = list[idx]

		ViewAndSelectObject(next_obj)
		XDestroyRolloverWindow()
	end
end

-- max food consumption
local foodcon_str = {3644, "Food consumption<right><food(FoodConsumedByConsumptionYesterday)>"}
local orig_GetFoodRollover = InfobarObj.GetFoodRollover
function InfobarObj.GetFoodRollover(...)
	local ret = orig_GetFoodRollover(...)
	local list = ret[1]

	local eat_food_per_visit = g_Consts.eat_food_per_visit
	local fc = 0
	local objs = UICity.labels.Dome or ""
	for i = 1, #objs do
		local dome = objs[i]
		fc = fc + (#(dome.labels.Colonist or "") + #(dome.labels.Glutton or "")) * eat_food_per_visit
	end

	foodcon_str.FoodConsumedByConsumptionYesterday = fc
	local c = list.j
	c = c + 1
	-- just below Food Consumption
	table_insert(list.table, 6,	T(8780, "MAX") .. " " .. T(foodcon_str))

	-- add count of all new strings
	list.j = c

	return ret
end

local needed_specs
local str_id_to_spec = {
	[3866] = "botanist",
	[3854] = "engineer",
	[3860] = "geologist",
	[3863] = "medic",
	[3848] = "none",
	[3851] = "scientist",
	[3857] = "security",
}

local orig_GetJobsRollover = InfobarObj.GetJobsRollover
function InfobarObj.GetJobsRollover(...)
	local ret = orig_GetJobsRollover(...)
	local list = ret[1]

	-- reset or add counts
	if needed_specs then
		for id in pairs(needed_specs) do
			needed_specs[id] = 0
		end
	else
		needed_specs = {none = 0}
		local ColonistClasses = ColonistClasses
		for id in pairs(ColonistClasses) do
			needed_specs[id] = 0
		end
	end

	-- add needed counts
	local workplaces = UICity.labels.Workplace or ""
	for i = 1, #workplaces do
		local bld = workplaces[i]
		local spec = bld.specialist
		-- modded specs aren't always in ColonistClasses
		local count = needed_specs[spec]
--~ 		if count and not bld.destroyed and not bld.demolishing and not bld.bulldozed then
		if count and bld.working then
			needed_specs[spec] = count + (bld:GetFreeWorkSlots() or 0)
		end
	end

	-- append to existing
	for i = 1, list.j do
		local item = list.table[i]
		if type(item) == "table" then
			local spec = str_id_to_spec[IsT(item.specialization)]
			if spec then
				list.table[i] = item .. (needed_specs[spec] or 0)
			end
		end
	end
--~ 	ex(ret)

	return ret
end

-- use tribbies to reduce maintenance est to lower amounts
local tribby_range
local function ReturnWorking(obj)
	return obj.working
end

local orig_RequiresMaintenance_GetDailyMaintenance = RequiresMaintenance.GetDailyMaintenance
function RequiresMaintenance:GetDailyMaintenance(...)
	-- so mods can change and have it reflect in infobar
	tribby_range = tribby_range or TriboelectricScrubber.UIRange
	-- only add main amount if we're not in range of a tribby
	if not MapGet(self, "hex", tribby_range, "TriboelectricScrubber", ReturnWorking)[1] then
		return orig_RequiresMaintenance_GetDailyMaintenance(self, ...)
	end
end
