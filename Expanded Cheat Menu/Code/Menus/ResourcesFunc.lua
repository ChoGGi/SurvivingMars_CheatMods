-- See LICENSE for terms

function OnMsg.ClassesGenerate()

	--~ local Trans = ChoGGi.ComFuncs.Translate
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local S = ChoGGi.Strings

	local default_icon = "UI/Icons/Sections/storage.tga"
	local default_icon2 = "UI/Icons/IPButtons/rare_metals.tga"

	local type = type
	local StringFormat = string.format

	function ChoGGi.MenuFuncs.AddOrbitalProbes()
		local ItemList = {
			{text = 5,value = 5},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 100,value = 100},
			{text = 200,value = 200},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end

			local value = choice[1].value
			local UICity = UICity
			if type(value) == "number" then
				for _ = 1, value do
					PlaceObject("OrbitalProbe",{city = UICity})
				end
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001187--[[Add Probes--]],
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetFoodPerRocketPassenger()
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts.FoodPerRocketPassenger / r
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 10000,value = 10000},
		}

		local hint = DefaultSetting
		local FoodPerRocketPassenger = ChoGGi.UserSettings.FoodPerRocketPassenger
		if FoodPerRocketPassenger then
			hint = FoodPerRocketPassenger / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local value = value * r
				ChoGGi.ComFuncs.SetConstsG("FoodPerRocketPassenger",value)
				ChoGGi.ComFuncs.SetSavedSetting("FoodPerRocketPassenger",value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920001188--[[%s: om nom nom nom nom--]]]:format(choice[1].text),
					302535920001189--[[Passengers--]],
					"UI/Icons/Sections/Food_4.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001190--[[Set Food Per Rocket Passenger--]],
			hint = StringFormat("%s: %s",S[302535920000106--[[Current--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.AddPrefabs()
		local ItemList = {
			{text = "Drone",value = 10},
			{text = "DroneHub",value = 10},
			{text = "ElectronicsFactory",value = 10},
			{text = "FuelFactory",value = 10},
			{text = "MachinePartsFactory",value = 10},
			{text = "MoistureVaporator",value = 10},
			{text = "PolymerPlant",value = 10},
			{text = "StirlingGenerator",value = 10},
			{text = "WaterReclamationSystem",value = 10},
	--~ 		{text = "Arcology",value = 10},
	--~ 		{text = "Sanatorium",value = 10},
	--~ 		{text = "NetworkNode",value = 10},
	--~ 		{text = "MedicalCenter",value = 10},
	--~ 		{text = "HangingGardens",value = 10},
	--~ 		{text = "CloningVat",value = 10},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			local text = choice[1].text

			if type(value) == "number" then
				if text == "Drone" then
					UICity.drone_prefabs = UICity.drone_prefabs + value
				else
					UICity:AddPrefabs(text,value)
				end
				RefreshXBuildMenu()
				MsgPopup(
					S[302535920001191--[[%s %s prefabs have been added.--]]]:format(value,text),
					1110--[[Prefab Buildings--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 1110--[[Prefab Buildings--]],
			hint = 302535920001194--[[Use edit box to enter amount of prefabs to add.--]],
			custom_type = 3,
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetFunding()
		local DefaultSetting = S[302535920001195--[[Reset to 500 M--]]]
		local hint = S[302535920001196--[[If your funds are a negative value, then you added too much.

	Fix with: %s--]]]:format(DefaultSetting)
		local ItemList = {
			{text = DefaultSetting,value = 500},
			{text = "100 M",value = 100,hint = hint},
			{text = "1 000 M",value = 1000,hint = hint},
			{text = "10 000 M",value = 10000,hint = hint},
			{text = "100 000 M",value = 100000,hint = hint},
			{text = "1 000 000 000 M",value = 1000000000,hint = hint},
			{text = "90 000 000 000 M",value = 90000000000,hint = hint},
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				if value == 500 then
					-- reset money back to 0
					UICity.funding = 0
				end
				-- and add the new amount
				ChangeFunding(value)

				MsgPopup(
					choice[1].text,
					3613--[[Funding--]],
					default_icon2
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 3613--[[Funding--]],
			hint = hint,
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.FillResource()
		local sel = ChoGGi.ComFuncs.SelObject()
		if not sel then
			return
		end

		if type(sel.CheatFill) == "function" then
			sel:CheatFill()
		end
		if type(sel.CheatRefill) == "function" then
			sel:CheatRefill()
		end

		MsgPopup(
			302535920001198--[[Resource Filled--]],
			15--[[Resource--]],
			default_icon2
		)
	end

end
