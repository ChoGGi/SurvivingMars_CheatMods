-- See LICENSE for terms

local type = type

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Strings = ChoGGi.Strings
local Translate = ChoGGi.ComFuncs.Translate
--~	local RetName = ChoGGi.ComFuncs.RetName

do -- ChangeResupplySettings
	local function CheckResupplySetting(cargo_val, name, value, meta)
		if ChoGGi.Tables.CargoPresets[name][cargo_val] == value then
			ChoGGi.UserSettings.CargoSettings[name][cargo_val] = nil
		else
			ChoGGi.UserSettings.CargoSettings[name][cargo_val] = value
		end
		meta[cargo_val] = value
	end

	local function ShowResupplyList(name, meta)
		local item_list = {
			{text = "pack", value = meta.pack, hint = Strings[302535920001269--[[Amount Per Click--]]]},
			{text = "kg", value = meta.kg, hint = Strings[302535920001270--[[Weight Per Item--]]]},
			{text = "price", value = meta.price, hint = Strings[302535920001271--[[Price Per Item--]]]},
			{text = "locked", value = meta.locked, hint = Strings[302535920000126--[[Locked From Resupply View--]]]},
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			if not ChoGGi.UserSettings.CargoSettings[name] then
				ChoGGi.UserSettings.CargoSettings[name] = {}
			end

			for i = 1, #choice do
				local value, value_type = ChoGGi.ComFuncs.RetProperType(choice[i].value)
				local text = choice[i].text
				if text == "pack" and value_type == "number" then
					CheckResupplySetting("pack", name, value, meta)
				elseif text == "kg" and value_type == "number" then
					CheckResupplySetting("kg", name, value, meta)
				elseif text == "price" and value_type == "number" then
					CheckResupplySetting("price", name, value, meta)
				elseif text == "locked" and value_type == "boolean" then
					CheckResupplySetting("locked", name, value, meta)
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920001272--[[Updated--]]],
				Strings[302535920000850--[[Change Resupply Settings--]]]
			)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000850--[[Change Resupply Settings--]]] .. ": " .. name,
			hint = Strings[302535920001121--[[Edit value for each setting you wish to change then press OK to save.--]]],
			custom_type = 4,
		}
	end

	function ChoGGi.MenuFuncs.ChangeResupplySettings()
		local CargoPresets = ChoGGi.Tables.CargoPresets or ""
		local BuildingTemplates = BuildingTemplates

		local item_list = {}

		local Cargo = ChoGGi.Tables.Cargo or ""
		for i = 1, #Cargo do
			local item = Cargo[i]
			local template = BuildingTemplates[item.id]
			if not template then
				template = BuildingTemplates[item.id .. "Building"]
			end
			item_list[i] = {
				text = Translate(item.name),
				value = item.id,
				meta = item,
				hint = template and (template.description
					.. (template.encyclopedia_image ~= "" and "\n\n\n<image "
					.. template.encyclopedia_image .. ">" or "")),
			}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			if choice[1].check1 then
				ChoGGi.UserSettings.CargoSettings = nil

				for cargo_id, cargo in pairs(Cargo) do
					local preset = CargoPresets[cargo_id]
					cargo.pack = preset.pack
					cargo.kg = preset.kg
					cargo.price = preset.price
					cargo.locked = preset.locked
				end

				return
			end

			ShowResupplyList(choice[1].value, choice[1].meta)
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000850--[[Change Resupply Settings--]]],
			hint = Strings[302535920001094--[["Shows a list of all cargo and allows you to change the price, weight taken up, if it's locked from view, and how many per click."--]]],
			custom_type = 7,
			checkboxes = {
				{
					title = Strings[302535920001084--[[Reset--]]],
					hint = Strings[302535920000237--[[Check this to reset settings.--]]],
				},
			},
		}
	end
end -- do

--~ 	function ChoGGi.MenuFuncs.LaunchEmptyRocket()
--~ 		local function CallBackFunc(answer)
--~ 			if answer then
--~ 				UICity:OrderLanding()
--~ 			end
--~ 		end
--~ 		ChoGGi.ComFuncs.QuestionBox(
--~ 			Strings[302535920000942--[[Are you sure you want to launch an empty rocket?--]]],
--~ 			CallBackFunc,
--~ 			Strings[302535920000943--[[Launch rocket to Mars.--]]],
--~ 			Strings[302535920000944--[[Yamato Hasshin!--]]]
--~ 		)
--~ 	end

function ChoGGi.MenuFuncs.SetRocketCargoCapacity()
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("CargoCapacity")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting .. " kg", value = default_setting},
		{text = "50 000 kg", value = 50000},
		{text = "100 000 kg", value = 100000},
		{text = "250 000 kg", value = 250000},
		{text = "500 000 kg", value = 500000},
		{text = "1 000 000 kg", value = 1000000},
		{text = "10 000 000 kg", value = 10000000},
		{text = "100 000 000 kg", value = 100000000},
		{text = "1 000 000 000 kg", value = 1000000000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			ChoGGi.ComFuncs.SetConstsG("CargoCapacity", value)
			ChoGGi.ComFuncs.SetSavedConstSetting("CargoCapacity")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				Translate(4598--[[Payload Capacity--]])
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000946--[[Set Rocket Cargo Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. g_Consts.CargoCapacity,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRocketTravelTime()
	local r = const.ResourceScale
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("TravelTimeEarthMars") / r
	local item_list = {
		{text = Strings[302535920000947--[[Instant--]]], value = 0},
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting, value = default_setting},
		{text = Strings[302535920000948--[[Original--]]] .. ": " .. 750, value = 750},
		{text = Strings[302535920000949--[[Half of Original--]]] .. ": " .. 375, value = 375},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 150, value = 150},
		{text = 200, value = 200},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.TravelTimeEarthMars then
		hint = ChoGGi.UserSettings.TravelTimeEarthMars / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local value = value * r
			ChoGGi.ComFuncs.SetConstsG("TravelTimeEarthMars", value)
			ChoGGi.ComFuncs.SetConstsG("TravelTimeMarsEarth", value)
			ChoGGi.ComFuncs.SetSavedConstSetting("TravelTimeEarthMars")
			ChoGGi.ComFuncs.SetSavedConstSetting("TravelTimeMarsEarth")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000950--[[%s: 88 MPH--]]]:format(choice.text),
				Strings[302535920000561--[[Travel Time--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000951--[[Rocket Travel Time--]]],
		hint = Strings[302535920000106--[[Current--]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetColonistsPerRocket()
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("MaxColonistsPerRocket")
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. default_setting, value = default_setting},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 10000, value = 10000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			ChoGGi.ComFuncs.SetConstsG("MaxColonistsPerRocket", value)
			ChoGGi.ComFuncs.SetSavedConstSetting("MaxColonistsPerRocket")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000952--[[%s: Long pig sardines--]]]:format(choice[1].text),
				Translate(4594--[[Colonists Per Rocket--]])
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000953--[[Set Colonist Capacity--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. g_Consts.MaxColonistsPerRocket,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRocketMaxExportAmount()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.RocketMaxExportAmount
	local item_list = {
		{text = Translate(1000121--[[Default--]]) .. ": " .. (default_setting / r), value = default_setting},
		{text = 5, value = 5 * r},
		{text = 10, value = 10 * r},
		{text = 15, value = 15 * r},
		{text = 25, value = 25 * r},
		{text = 50, value = 50 * r},
		{text = 100, value = 100 * r},
		{text = 1000, value = 1000 * r},
		{text = 10000, value = 10000 * r},
	}

	if not ChoGGi.UserSettings.RocketMaxExportAmount then
		ChoGGi.UserSettings.RocketMaxExportAmount = default_setting
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			if value == default_setting then
				ChoGGi.UserSettings.RocketMaxExportAmount = nil
			else
				ChoGGi.UserSettings.RocketMaxExportAmount = value
			end

			local rockets = UICity.labels.AllRockets or ""
			for i = 1, #rockets do
				local rocket = rockets[i]
				if rocket.export_requests then
					ChoGGi.ComFuncs.SetTaskReqAmount(rocket, value, "export_requests", "max_export_storage")
				else
					rocket.max_export_storage = value
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				Strings[302535920001291--[[Max Export Amount--]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001291--[[Max Export Amount--]]],
		hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. ChoGGi.UserSettings.RocketMaxExportAmount,
		skip_sort = true,
	}
end

do -- RocketsIgnoreFuel_Toggle/LaunchFuelPerRocket
	local function SetRocketFuelAmount(amount)
		local rockets = UICity.labels.AllRockets or ""
		for i = 1, #rockets do
			local rocket = rockets[i]
			if rocket.refuel_request then
				ChoGGi.ComFuncs.SetTaskReqAmount(rocket, amount, "refuel_request", "launch_fuel")
			else
				rocket.launch_fuel = amount
			end
		end
	end

	function ChoGGi.MenuFuncs.RocketsIgnoreFuel_Toggle()
		if ChoGGi.UserSettings.RocketsIgnoreFuel then
			ChoGGi.UserSettings.RocketsIgnoreFuel = nil
			SetRocketFuelAmount(ChoGGi.Consts.LaunchFuelPerRocket)
		else
			ChoGGi.UserSettings.RocketsIgnoreFuel = true
			SetRocketFuelAmount(0)
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RocketsIgnoreFuel),
			Strings[302535920001319--[[Rockets Ignore Fuel--]]]
		)
	end

	function ChoGGi.MenuFuncs.SetLaunchFuelPerRocket()
		local r = const.ResourceScale
		local default_setting = ChoGGi.Consts.LaunchFuelPerRocket
		local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("FuelRocket")
		local item_list = {
			{text = Translate(1000121--[[Default--]]) .. ": " .. (default_setting / r), value = default_setting},
			{text = 5, value = 5 * r},
			{text = 10, value = 10 * r},
			{text = 15, value = 15 * r},
			{text = 25, value = 25 * r},
			{text = 50, value = 50 * r},
			{text = 100, value = 100 * r},
			{text = 1000, value = 1000 * r},
			{text = 10000, value = 10000 * r},
		}
		if default_setting ~= UpgradedSetting then
			table.insert(item_list, 2, {text = Strings[302535920000890--[[Upgraded--]]] .. ": " .. (UpgradedSetting / r), value = UpgradedSetting})
		end

		if not ChoGGi.UserSettings.LaunchFuelPerRocket then
			ChoGGi.UserSettings.LaunchFuelPerRocket = default_setting
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			choice = choice[1]

			local value = choice.value
			if type(value) == "number" then
				if value == default_setting then
					ChoGGi.UserSettings.LaunchFuelPerRocket = nil
				else
					ChoGGi.UserSettings.LaunchFuelPerRocket = value
				end
				SetRocketFuelAmount(value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					ChoGGi.ComFuncs.SettingState(choice.text),
					Strings[302535920001317--[[Launch Fuel Per Rocket--]]]
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920001317--[[Launch Fuel Per Rocket--]]],
			hint = Strings[302535920000914--[[Current capacity--]]] .. ": " .. ChoGGi.UserSettings.LaunchFuelPerRocket,
			skip_sort = true,
		}
	end
end -- do
