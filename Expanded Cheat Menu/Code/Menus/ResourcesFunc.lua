-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local type = type
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local RetName = ChoGGi_Funcs.Common.RetName

function ChoGGi_Funcs.Menus.SetFundingPerRareMetalExport()
	local default_setting = ChoGGi.Consts.ExportPricePreciousMetals
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 10000, value = 10000},
	}

	local hint = default_setting
	local ExportPricePreciousMetals = ChoGGi.UserSettings.ExportPricePreciousMetals
	if ExportPricePreciousMetals then
		hint = ExportPricePreciousMetals
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local value = value
			ChoGGi_Funcs.Common.SetConsts("ExportPricePreciousMetals", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("ExportPricePreciousMetals")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				choice[1].text,
				T(4604, "Rare Metals Price (M)")
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(4604, "Rare Metals Price (M)"),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.AddOrbitalProbes()
	local item_list = {
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 200, value = 200},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end

		local value = choice[1].value
		local MainMapID = MainMapID
		local PlaceObjectIn = PlaceObjectIn
		if type(value) == "number" then
			local cls = "OrbitalProbe"
			if choice[1].check1 then
				cls = "AdvancedOrbitalProbe"
			end
			for _ = 1, value do
				PlaceObjectIn(cls, MainMapID)
			end
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920001187--[[Add Probes]]),
		skip_sort = true,
		checkboxes = {
			{
				title = T(10087--[[Advanced Orbital Probe]]),
				hint = T(302535920000266--[[Spawn]]) .. " " .. T(10087--[[Advanced Orbital Probe]]),
				checked = GetMissionSponsor().id == "NASA"
			},
		},
	}
end

function ChoGGi_Funcs.Menus.SetFoodPerRocketPassenger()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.FoodPerRocketPassenger / r
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 10000, value = 10000},
	}

	local hint = default_setting
	local FoodPerRocketPassenger = ChoGGi.UserSettings.FoodPerRocketPassenger
	if FoodPerRocketPassenger then
		hint = FoodPerRocketPassenger / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local value = value * r
			ChoGGi_Funcs.Common.SetConsts("FoodPerRocketPassenger", value)
			ChoGGi_Funcs.Common.SetSavedConstSetting("FoodPerRocketPassenger")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				Translate(302535920001188--[[%s: om nom nom nom nom]]):format(choice[1].text),
				T(4616, "Food Per Rocket Passenger")
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920001190--[[Set Food Per Rocket Passenger]]),
		hint = T(302535920000106--[[Current]]) .. ": " .. hint,
		skip_sort = true,
	}
end

do -- AddPrefabs
	local skip_prefabs = {
		BlackCubeDumpSite = true,
		ElectricitySwitch = true,
		LifesupportSwitch = true,
		StorageConcrete = true,
		StorageElectronics = true,
		StorageFood = true,
		StorageFuel = true,
		StorageMachineParts = true,
		StorageMetals = true,
		StorageMysteryResource = true,
		StoragePolymers = true,
		StorageRareMetals = true,
		Passage = true,
		PassageRamp = true,
	}

	function ChoGGi_Funcs.Menus.AddPrefabBuildings()
		local UICity = UICity

		local drone_str = Translate(Drone.display_name)
		local item_list = {
			{
				text = drone_str,
				value = 10,
				hint = T(302535920000106--[[Current]]) .. ": " .. UICity.drone_prefabs,
				icon = Drone.display_icon,
			},
		}
		local c = #item_list

		local show_hidden = ChoGGi.UserSettings.Building_hide_from_build_menu
		local BuildingTemplates = BuildingTemplates
		for id, cargo in pairs(BuildingTemplates) do
			-- baclcube is instant, instant doesn't need prefabs, and hidden normally don't show up
			if not skip_prefabs[id] and not cargo.instant_build and (cargo.group ~= "Hidden" or cargo.group == "Hidden" and show_hidden) then
				c = c + 1
				item_list[c] = {
					text = Translate(cargo.display_name),
					value = 10,
					hint = T(302535920000106--[[Current]]) .. ": " .. UICity:GetPrefabs(id),
					icon = cargo.display_icon,
					id = id,
				}
			end
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			for i = 1, #choice do
				local value = choice[i].value
				local text = choice[i].text

				if type(value) == "number" then
					if text == drone_str then
						UICity.drone_prefabs = UICity.drone_prefabs + value
					else
						UICity:AddPrefabs(choice[i].id, value, false)
					end
				end
			end
			MsgPopup(
				Translate(302535920001191--[[Added prefabs to %s buildings.]]):format(#choice),
				T(1110--[[Prefab Buildings]])
			)
			-- If the build menu is opened and they add some prefabs it won't use them till it's toggled, so we do this instead
			ChoGGi_Funcs.Common.UpdateBuildMenu()
		end

		ChoGGi_Funcs.Common.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = T(1110--[[Prefab Buildings]]),
			hint = T(302535920001194--[[Use edit box to enter amount of prefabs to add.]]),
			custom_type = 3,
			multisel = true,
		}
	end
end -- do

function ChoGGi_Funcs.Menus.SetFunding()
	local default_setting = T(302535920001195--[[Reset to 500 M]])
	local hint = Translate(302535920001196--[[If your funds are a negative value, then you added too much.

Fix with: %s]]):format(default_setting)
	local item_list = {
		{text = default_setting, value = 500},
		{text = "100 M", value = 100, hint = hint},
		{text = "1 000 M", value = 1000, hint = hint},
		{text = "10 000 M", value = 10000, hint = hint},
		{text = "100 000 M", value = 100000, hint = hint},
		{text = "1 000 000 000 M", value = 1000000000, hint = hint},
		{text = "10 000 000 000 M", value = 10000000000, hint = hint},
		{text = "Maxed Out", value = 92233720368, hint = hint},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			if value == 500 or value == 92233720368 then
				-- reset money back to 0
				UIColony.funds.funding = 0
			end
			-- and add the new amount
			ChangeFunding(value)

			MsgPopup(
				choice[1].text,
				T(3613--[[Funding]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(3613--[[Funding]]),
		hint = hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.FillResource()
	local obj = ChoGGi_Funcs.Common.SelObject()
	local is_valid = IsValid(obj)
	if not is_valid or is_valid and not obj.CheatFill and not obj.CheatRefill and not obj.CheatFillDepot then
		MsgPopup(
			T(302535920001526--[[Not a valid object]]),
			T(302535920000727--[[Fill Selected Resource]])
		)
		return
	end

	if obj.CheatFill then
		obj:CheatFill()
	end
	if obj.CheatRefill then
		obj:CheatRefill()
	end
	if obj.CheatFillDepot then
		obj:CheatFillDepot()
	end

	MsgPopup(
		RetName(obj),
		T(302535920000727--[[Fill Selected Resource]])
	)
end
