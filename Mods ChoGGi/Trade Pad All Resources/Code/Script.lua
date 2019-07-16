-- See LICENSE for terms

local CreateRealTimeThread = CreateRealTimeThread

local res_list = {}
local res_list_c = 0

-- skip some res we can't trade (I mean we could, but...)
local added = {
	MysteryResource = true,
	BlackCube = true,
}
-- skip seeds if no GP
if not g_AvailableDlc.armstrong then
	added.Seeds = true
end

-- and add any other res
local function BuildList(objs)
	for i = 1, #(objs or "") do
		local res = objs[i]
		if not added[res] then
			res_list_c = res_list_c + 1
			res_list[res_list_c] = res
			added[res] = true
		end
	end
end
BuildList(OtherResourceList)
BuildList(StockpileResourceList)

table.sort(res_list)
TradePad.trade_resources = res_list

local options
local mod_EnableWasteRock

local WaitForRocket
local UpdateRivalRes
-- fired when settings are changed/init
local function ModOptions()
	mod_EnableWasteRock = options.EnableWasteRock

	UpdateRivalRes()

	if mod_EnableWasteRock then
		if not table.find(res_list, "WasteRock") then
			res_list[#res_list+1] = "WasteRock"
		end
	else
		local idx = table.find(res_list, "WasteRock")
		if idx then
			table.remove(res_list, idx)
		end
	end
	table.sort(res_list)

	-- update any existing trade pad res lists
	if UICity then
		local objs = UICity.labels.TradePad or ""
		for i = 1, #objs do
			local obj = objs[i]
			obj.trade_resources = res_list
			if not mod_EnableWasteRock then
				if obj.export_resource == "WasteRock" then
					CreateRealTimeThread(WaitForRocket, obj, "export_resource")
				end
				if obj.import_resource == "WasteRock" then
					CreateRealTimeThread(WaitForRocket, obj, "import_resource")
				end
			end
		end
	end
	-- cls obj trade list (needed for new pads)
	TradePad.trade_resources = res_list
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_TradePadAllResources" then
		return
	end

	ModOptions()
end

-- update existing pads
local function StartupCode()
	-- could add a check, but even if people have the map filled with pads it won't take much
	local objs = UICity.labels.TradePad or ""
	for i = 1, #objs do
		objs[i].trade_resources = res_list
	end

	-- hide my shame (and remember to test on new games)
	local presets = Presets.Cargo
  local seeds = presets["Basic Resources"].Seeds
  local presets_or = presets["Other Resources"]
	for i = #presets_or, 1, -1 do
		local cargo = presets_or[i]
		if cargo.id == "Seeds" and cargo ~= seeds then
			table.remove(presets_or, i)
		end
	end
	local defs = ResupplyItemDefinitions
	local found_unlocked
	local found = {}
	local max_idx = 0
	for i = #defs, 1, -1 do
		local def = defs[i]
		if def.id == "Seeds" then
			-- found unlocked seeds
			if not found_unlocked and not def.locked then
				found_unlocked = def
			end
			-- any others
			if def.locked then
				found[i] = def
				if i > max_idx then
					max_idx = i
				end
			end
		end
	end

	local skipped_one
	for i = max_idx, 1, -1 do
		-- we only added a few random numbers, so we need to check the table for the def
		if found[i] then
			-- if we found unlocked seeds then remove all thr rest
			if found_unlocked then
				table.remove(defs, i)
			-- otherwise skip the first one
			elseif not skipped_one then
				skipped_one = true
			-- and remove the rest
			else
				table.remove(defs, i)
			end
		end
	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- don't reset till rocket is gone
WaitForRocket = function(obj, name)
	if obj.trade_rocket then
		while obj.trade_rocket do
			Sleep(1000)
		end
		obj[name] = false
	else
		obj[name] = false
	end
end

UpdateRivalRes = function()
	local RivalAIs = RivalAIs or empty_table
	for _, rival in pairs(RivalAIs) do
		local res = rival.resources
		if mod_EnableWasteRock then
			res.wasterock = (res.concrete_production * 4) + (res.concrete * 2)
		else
			res.wasterock = 0
		end
		res.seeds = (res.oxygen_production) * 10 + (res.water_production * 5)
		-- if only the devs settled on one
		res.preciousmetals = res.raremetals
	end
end

OnMsg.NewHour = UpdateRivalRes

-- use the "grey" icons for missing ones
local replace_lookup = {
	-- seeds didn't get fancy section icons
--~ 	Seeds = true,
	WasteRock = true,
	PreciousMetals = true,
	Fuel = true,
}
local function FixIcon(orig_func, self, icon, ...)
	if icon then
		-- get resource name
		local res = icon:sub(19):gsub("_6.tga", ""):gsub("_5.tga", "")
		-- check if it's one of ours and replace with icons that are included
		if replace_lookup[res] then
			icon = icon:gsub("6", "2"):gsub("5", "3")
		-- some icon is better than no icon
		elseif res == "Seeds" then
			icon = "UI/Icons/res_seeds.tga"
		end
	end
	return orig_func(self, icon, ...)
end

function OnMsg.ClassesPostprocess()
	-- use the "grey" icons for missing ones
	local active = XTemplates.InfopanelActiveSection
	local idx = table.find(active, "id", "Icon")
	if idx then
		local icon = active[idx]
		local orig_func = icon.Set
		function icon.Set(...)
			return FixIcon(orig_func, ...)
		end
	end

	-- add missing cargo items
  local presets = Presets.Cargo
  local presets_br = presets["Basic Resources"]
  local presets_ar = presets["Advanced Resources"]

	-- seeds are already a cargo, so we can just add a ref in basic
	if not presets_br.Seeds then
		presets_br.Seeds = presets["Other Resources"].Seeds
	end
	-- the rest need a cargo added
	if not presets_br.WasteRock then
		local c = presets_br.Concrete
		presets_br.WasteRock = PlaceObj("Cargo", {
			id = "WasteRock",
			pack = 5,
			price = c.price / 16,
			kg = c.kg,
			group = "Basic Resources",
			description = T(9249, "Waste Rock is a byproduct of all extractors and is best stored at designated locations. This way you can ensure that it will not be in the way of future construction."),
			name = T(4518, "Waste Rock"),
			locked = true,
		})
	end

	if not presets_br.PreciousMetals then
		local e = presets_ar.Electronics
		presets_br.PreciousMetals = PlaceObj("Cargo", {
			id = "PreciousMetals",
			pack = 5,
			price = e.price * 2,
			kg = e.kg,
			group = "Basic Resources",
			description = T(4140, "Rare Metals can be exported by refueled Rockets that return to Earth, increasing the Funding for the Colony. They are also used for creating Electronics."),
			name = T(4139, "Rare Metals"),
			locked = true,
		})
	end
	if not presets_ar.Fuel then
		local p = presets_ar.Polymers
		presets_ar.Fuel = PlaceObj("Cargo", {
			id = "Fuel",
			pack = 5,
			price = p.price / 2,
			kg = p.kg,
			group = "Basic Resources",
			description = T(5385, [[Fuel <image UI/Icons/Sections/Fuel_1.tga> is synthesized in <em>Fuel Refineries</em> and is used to for refueling <em>Rockets</em> bound for Earth, for keeping <em>Shuttle Hubs</em> operational and for polymer production.

<center><image UI/Common/rollover_line.tga 2000> <left>

Using the CO2 from the Martian atmosphere and hydrogen (from water) we can produce fuel to fly our rockets back to Earth. The process uses a series of relatively simple chemical reactions to produce methane and oxygen which are used as propellant for both our rockets and shuttles.]]),
			name = T(4765, "Fuel"),
			locked = true,
		})
	end

end
