-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local type, tostring = type, tostring
local T = T

local ChoGGi_Funcs = ChoGGi_Funcs
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local RetName = ChoGGi_Funcs.Common.RetName
local RetTemplateOrClass = ChoGGi_Funcs.Common.RetTemplateOrClass
local RetObjectCapAndGrid = ChoGGi_Funcs.Common.RetObjectCapAndGrid
local Translate = ChoGGi_Funcs.Common.Translate
local GetCityLabels = ChoGGi_Funcs.Common.GetCityLabels

function ChoGGi_Funcs.Menus.StorageMechanizedDepotsTemp_Toggle()
	ChoGGi.UserSettings.StorageMechanizedDepotsTemp = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.StorageMechanizedDepotsTemp)

	local amount
	if not ChoGGi.UserSettings.StorageMechanizedDepotsTemp then
		amount = 5
	end
	local SetMechanizedDepotTempAmount = ChoGGi_Funcs.Common.SetMechanizedDepotTempAmount
	local objs = GetCityLabels("MechanizedDepots")
	for i = 1, #objs do
		SetMechanizedDepotTempAmount(objs[i], amount)
	end

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.StorageMechanizedDepotsTemp),
		T(302535920000565--[[Storage Mechanized Depots Temp]])
	)
end

function ChoGGi_Funcs.Menus.SetWorkerCapacity()
	local obj = SelectedObj
	local _, capacity = RetObjectCapAndGrid(obj, 16)

	if not capacity then
		MsgPopup(
			T(302535920000954--[[You need to select a building that has workers.]]),
			T(302535920000567--[[Worker Capacity]])
		)
		return
	end

	local default_setting = capacity
	local hint_toolarge = T(6779--[[Warning]]) .. " " .. T(302535920000956--[[for colonist capacity: Above a thousand is laggy (above 60K may crash).]])

	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000, hint = hint_toolarge},
		{text = 2000, value = 2000, hint = hint_toolarge},
		{text = 3000, value = 3000, hint = hint_toolarge},
		{text = 4000, value = 4000, hint = hint_toolarge},
		{text = 5000, value = 5000, hint = hint_toolarge},
		{text = 10000, value = 10000, hint = hint_toolarge},
		{text = 25000, value = 25000, hint = hint_toolarge},
	}

	-- check if there's an entry for building
	local id = RetTemplateOrClass(obj)
	if not ChoGGi.UserSettings.BuildingSettings[id] then
		ChoGGi.UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = ChoGGi.UserSettings.BuildingSettings[id]
	if setting and setting.workers then
		hint = tostring(setting.workers)
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			local objs = GetCityLabels("Workplace")
			for i = 1, #objs do
				local o = objs[i]
				if RetTemplateOrClass(o) == id then
					o.max_workers = value
				end
			end

			if value == default_setting then
				ChoGGi.UserSettings.BuildingSettings[id].workers = nil
			else
				ChoGGi.UserSettings.BuildingSettings[id].workers = value
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000957--[[%s capacity is now %s.]]):format(RetName(obj), choice[1].text),
				T(302535920000567--[[Worker Capacity]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. RetName(obj) .. " " .. T(302535920000567--[[Worker Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint .. "\n\n" .. hint_toolarge,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetBuildingCapacity()
	local obj = SelectedObj
	local cap_type, capacity = RetObjectCapAndGrid(obj, 15)

	if not cap_type then
		MsgPopup(
			T(302535920000958--[[You need to select a building that has capacity (colonists/air/water/elec).]]),
			T(302535920000569--[[Building Capacity]])
		)
		return
	end
	local r = const.ResourceScale
	local hint_toolarge = T(6779--[[Warning]]) .. " " .. T(302535920000956--[[for colonist capacity: Above a thousand is laggy (above 60K may crash).]])

	local default_setting = capacity

	-- colonist cap doesn't use res scale
	if cap_type ~= "colonist" then
		default_setting = default_setting / r
	end

	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000, hint = hint_toolarge},
		{text = 2000, value = 2000, hint = hint_toolarge},
		{text = 3000, value = 3000, hint = hint_toolarge},
		{text = 4000, value = 4000, hint = hint_toolarge},
		{text = 5000, value = 5000, hint = hint_toolarge},
		{text = 10000, value = 10000, hint = hint_toolarge},
		{text = 25000, value = 25000, hint = hint_toolarge},
		{text = 50000, value = 50000, hint = hint_toolarge},
		{text = 100000, value = 100000, hint = hint_toolarge},
	}

	-- check if there's an entry for building
	local id = RetTemplateOrClass(obj)
	if not ChoGGi.UserSettings.BuildingSettings[id] then
		ChoGGi.UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = ChoGGi.UserSettings.BuildingSettings[id]
	if setting and setting.capacity then
		if cap_type ~= "colonist" then
			hint = tostring(setting.capacity / r)
		else
			hint = tostring(setting.capacity)
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			-- colonist cap doesn't use res scale
			local amount
			if cap_type == "colonist" then
				amount = value
			else
				amount = value * r
			end

			local function StoredAmount(prod, current)
				local percent = prod:GetStoragePercent()
				if percent == 0 then
					return "empty"
				elseif percent == 100 then
					return "full"
				elseif current == "discharging" then
					return "discharging"
				else
					return "charging"
				end
			end

			-- updating time
			if cap_type == "electricity" then
				local ToggleWorking = ChoGGi_Funcs.Common.ToggleWorking
				local objs = GetCityLabels("Power")
				for i = 1, #objs do
					local o = objs[i]
					if RetTemplateOrClass(o) == id then
						o.capacity = amount
						local grid = o[cap_type]
						grid.storage_capacity = amount
						grid.storage_mode = StoredAmount(grid, grid.storage_mode)
						ToggleWorking(o)
					end
				end

			elseif cap_type == "colonist" then
				local objs = GetCityLabels("Residence")
				for i = 1, #objs do
					local o = objs[i]
					if RetTemplateOrClass(o) == id then
						o.capacity = amount
					end
				end

			else -- water and air
				local ToggleWorking = ChoGGi_Funcs.Common.ToggleWorking
				local cap_name = cap_type .. "_capacity"
				local objs = GetCityLabels("Life-Support")
				for i = 1, #objs do
					local o = objs[i]
					if RetTemplateOrClass(o) == id then
						o[cap_name] = amount
						local grid = o[cap_type]
						grid.storage_capacity = amount
						grid.storage_mode = StoredAmount(grid, grid.storage_mode)
						ToggleWorking(o)
					end
				end
			end

			if value == default_setting then
				setting.capacity = nil
			else
				setting.capacity = amount
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000957--[[%s capacity is now %s.]]):format(RetName(obj), choice[1].text),
				T(302535920000569--[[Building Capacity]])
			)
		end

	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. RetName(obj) .. " " .. T(109035890389--[[Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint .. "\n\n" .. hint_toolarge,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetVisitorCapacity()
	local obj = SelectedObj
	local _, capacity = RetObjectCapAndGrid(obj, 32)

	if not capacity then
		MsgPopup(
			T(302535920000959--[[You need to select something that has space for visitors (services/trainingbuildings).]]),
			T(302535920000571--[[Building Visitor Capacity]])
		)
		return
	end
	local default_setting = capacity
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
	}

	-- check if there's an entry for building
	local id = RetTemplateOrClass(obj)
	if not ChoGGi.UserSettings.BuildingSettings[id] then
		ChoGGi.UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = ChoGGi.UserSettings.BuildingSettings[id]
	if setting and setting.visitors then
		hint = tostring(setting.visitors)
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local objs = GetCityLabels("BuildingNoDomes")
			for i = 1, #objs do
				local o = objs[i]
				if RetTemplateOrClass(o) == id then
					o.max_visitors = value
				end
			end

			if value == default_setting then
				ChoGGi.UserSettings.BuildingSettings[id].visitors = nil
			else
				ChoGGi.UserSettings.BuildingSettings[id].visitors = value
			end

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920000960--[[%s visitor capacity is now %s.]]):format(RetName(obj), choice[1].text),
				T(302535920000571--[[Building Visitor Capacity]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. " " .. RetName(obj) .. " " .. T(302535920000961--[[Visitor Capacity]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetStorageDepotSize(action)
	if not action then
		return
	end

	local bld_type = action.bld_type

	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts[bld_type] / r
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 20000, value = 20000},
		{text = 100000, value = 100000},
		{text = 1000000, value = 1000000},
	}

	local hint = default_setting
	if ChoGGi.UserSettings[bld_type] then
		hint = ChoGGi.UserSettings[bld_type] / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			local value = value * r
			if bld_type == "StorageWasteDepot" then
				-- loop through and change all existing

				local objs = GetCityLabels("WasteRockDumpSite")
				for i = 1, #objs do
					local o = objs[i]
					o.max_amount_WasteRock = value
					if o:GetStoredAmount() < 0 then
						o:CheatEmpty()
						o:CheatFill()
					end
				end

			elseif bld_type == "StorageOtherDepot" then
				local objs = GetCityLabels("UniversalStorageDepot")
				for i = 1, #objs do
					local o = objs[i]
					if o.template_name ~= "UniversalStorageDepot" then
						o.max_storage_per_resource = value
					end
				end

				objs = GetCityLabels("MysteryDepot")
				for i = 1, #objs do
					objs[i].max_storage_per_resource = value
				end
				objs = GetCityLabels("BlackCubeDumpSite")
				for i = 1, #objs do
					objs[i].max_amount_BlackCube = value
				end
				if value > 5000 then
					ChoGGi.UserSettings.RemoveHeightLimitObjs = true
				end

			elseif bld_type == "StorageUniversalDepot" then
				local objs = GetCityLabels("UniversalStorageDepot")
				for i = 1, #objs do
					local o = objs[i]
					if o.template_name == "UniversalStorageDepot" then
						o.max_storage_per_resource = value
					end
				end
				if value > 2000 then
					ChoGGi.UserSettings.RemoveHeightLimitObjs = true
				end

			elseif bld_type == "StorageMechanizedDepot" then
				local objs = GetCityLabels("MechanizedDepots")
				for i = 1, #objs do
					objs[i].max_storage_per_resource = value
				end
			end

			-- for new buildings
			ChoGGi_Funcs.Common.SetSavedConstSetting(bld_type, value)

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				choice[1].text .. ": " .. bld_type,
				T(302535920000573--[[Storage Universal Depot]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000129--[[Set]]) .. ": " .. bld_type .. " " .. T(302535920000963--[[Size]]),
		hint = T(302535920000914--[[Current capacity]]) .. ": " .. hint,
		skip_sort = true,
	}
end
