-- See LICENSE for terms

local default_icon = "UI/Icons/Sections/storage.tga"
local default_icon2 = "UI/Icons/Upgrades/home_collective_04.tga"

local type,tostring = type,tostring
local StringFormat = string.format

function OnMsg.ClassesGenerate()
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup
	local RetName = ChoGGi.ComFuncs.RetName
	local S = ChoGGi.Strings
	--~ local Trans = ChoGGi.ComFuncs.Translate

	function ChoGGi.MenuFuncs.StorageMechanizedDepotsTemp_Toggle()
		local ChoGGi = ChoGGi
		ChoGGi.UserSettings.StorageMechanizedDepotsTemp = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.StorageMechanizedDepotsTemp)

		local amount
		if not ChoGGi.UserSettings.StorageMechanizedDepotsTemp then
			amount = 5
		end
		local tab = UICity.labels.MechanizedDepots or ""
		for i = 1, #tab do
			ChoGGi.ComFuncs.SetMechanizedDepotTempAmount(tab[i],amount)
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.StorageMechanizedDepotsTemp,302535920000565--[[Storage Mechanized Depots Temp--]]),
			519--[[Storage--]],
			default_icon
		)
	end

	function ChoGGi.MenuFuncs.SetWorkerCapacity()
		local sel = SelectedObj
		if not sel or not sel.base_max_workers then
			MsgPopup(
				302535920000954--[[You need to select a building that has workers.--]],
				302535920000567--[[Worker Capacity--]],
				default_icon
			)
			return
		end
		local ChoGGi = ChoGGi
		local DefaultSetting = sel.base_max_workers
		local hint_toolarge = StringFormat("%s %s",S[6779--[[Warning--]]],S[302535920000956--[[for colonist capacity: Above a thousand is laggy (above 60K may crash).--]]])

		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000,hint = hint_toolarge},
			{text = 2000,value = 2000,hint = hint_toolarge},
			{text = 3000,value = 3000,hint = hint_toolarge},
			{text = 4000,value = 4000,hint = hint_toolarge},
			{text = 5000,value = 5000,hint = hint_toolarge},
			{text = 10000,value = 10000,hint = hint_toolarge},
			{text = 25000,value = 25000,hint = hint_toolarge},
		}

		-- check if there's an entry for building
		if not ChoGGi.UserSettings.BuildingSettings[sel.template_name] then
			ChoGGi.UserSettings.BuildingSettings[sel.template_name] = {}
		end

		local hint = DefaultSetting
		local setting = ChoGGi.UserSettings.BuildingSettings[sel.template_name]
		if setting and setting.workers then
			hint = tostring(setting.workers)
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				local tab = UICity.labels.Workplace or ""
				for i = 1, #tab do
					if tab[i].template_name == sel.template_name then
						tab[i].max_workers = value
					end
				end

				if value == DefaultSetting then
					ChoGGi.UserSettings.BuildingSettings[sel.template_name].workers = nil
				else
					ChoGGi.UserSettings.BuildingSettings[sel.template_name].workers = value
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000957--[[%s capacity is now %s.--]]]:format(RetName(sel),choice[1].text),
					302535920000567--[[Worker Capacity--]],
					default_icon
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s %s",S[302535920000129--[[Set--]]],RetName(sel),S[302535920000567--[[Worker Capacity--]]]),
			hint = StringFormat("%s: %s\n\n%s",S[302535920000914--[[Current capacity--]]],hint,hint_toolarge),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetBuildingCapacity()
		local sel = SelectedObj
		if not sel or (type(sel.GetStoredWater) == "nil" and type(sel.GetStoredAir) == "nil" and type(sel.GetStoredPower) == "nil" and type(sel.GetUIResidentsCount) == "nil") then
			MsgPopup(
				302535920000958--[[You need to select a building that has capacity.--]],
				3980--[[Buildings--]],
				default_icon
			)
			return
		end
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local hint_toolarge = StringFormat("%s %s",S[6779--[[Warning--]]],S[302535920000956--[[for colonist capacity: Above a thousand is laggy (above 60K may crash).--]]])

		--get type of capacity
		local CapType
		if type(sel.GetStoredAir) == "function" then
			CapType = "air"
		elseif type(sel.GetStoredWater) == "function" then
			CapType = "water"
		elseif type(sel.GetStoredPower) == "function" then
			CapType = "electricity"
		elseif type(sel.GetUIResidentsCount) == "function" then
			CapType = "colonist"
		end

		--get default amount
		local DefaultSetting
		if CapType == "electricity" or CapType == "colonist" then
			DefaultSetting = sel.base_capacity
		else
			DefaultSetting = sel[StringFormat("base_%s_capacity",CapType)]
		end

		if CapType ~= "colonist" then
			DefaultSetting = DefaultSetting / r
		end

		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000,hint = hint_toolarge},
			{text = 2000,value = 2000,hint = hint_toolarge},
			{text = 3000,value = 3000,hint = hint_toolarge},
			{text = 4000,value = 4000,hint = hint_toolarge},
			{text = 5000,value = 5000,hint = hint_toolarge},
			{text = 10000,value = 10000,hint = hint_toolarge},
			{text = 25000,value = 25000,hint = hint_toolarge},
			{text = 50000,value = 50000,hint = hint_toolarge},
			{text = 100000,value = 100000,hint = hint_toolarge},
		}

		--check if there's an entry for building
		if not ChoGGi.UserSettings.BuildingSettings[sel.template_name] then
			ChoGGi.UserSettings.BuildingSettings[sel.template_name] = {}
		end

		local hint = DefaultSetting
		local setting = ChoGGi.UserSettings.BuildingSettings[sel.template_name]
		if setting and setting.capacity then
			if CapType ~= "colonist" then
				hint = tostring(setting.capacity / r)
			else
				hint = tostring(setting.capacity)
			end
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				--colonist cap doesn't use res scale
				local amount
				if CapType == "colonist" then
					amount = value
				else
					amount = value * r
				end

				local function StoredAmount(prod,current)
					if prod:GetStoragePercent() == 0 then
						return "empty"
					elseif prod:GetStoragePercent() == 100 then
						return "full"
					elseif current == "discharging" then
						return "discharging"
					else
						return "charging"
					end
				end
				--updating time
				if CapType == "electricity" then
					local tab = UICity.labels.Power or ""
					for i = 1, #tab do
						if tab[i].template_name == sel.template_name then
							tab[i].capacity = amount
							tab[i][CapType].storage_capacity = amount
							tab[i][CapType].storage_mode = StoredAmount(tab[i][CapType],tab[i][CapType].storage_mode)
							ChoGGi.ComFuncs.ToggleWorking(tab[i])
						end
					end

				elseif CapType == "colonist" then
					local tab = UICity.labels.Residence or ""
					for i = 1, #tab do
						if tab[i].template_name == sel.template_name then
							tab[i].capacity = amount
						end
					end

				else --water and air
					local tab = UICity.labels["Life-Support"] or ""
					for i = 1, #tab do
						if tab[i].template_name == sel.template_name then
							tab[i][StringFormat("%s_capacity",CapType)] = amount
							tab[i][CapType].storage_capacity = amount
							tab[i][CapType].storage_mode = StoredAmount(tab[i][CapType],tab[i][CapType].storage_mode)
							ChoGGi.ComFuncs.ToggleWorking(tab[i])
						end
					end
				end

				if value == DefaultSetting then
					setting.capacity = nil
				else
					setting.capacity = amount
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000957--[[%s capacity is now %s.--]]]:format(RetName(sel),choice[1].text),
					3980--[[Buildings--]],
					default_icon
				)
			end

		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s %s",S[302535920000129--[[Set--]]],RetName(sel),S[109035890389--[[Capacity--]]]),
			hint = StringFormat("%s: %s\n\n%s",S[302535920000914--[[Current capacity--]]],hint,hint_toolarge),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetVisitorCapacity()
		local sel = SelectedObj
		if not sel or (sel and not sel.base_max_visitors) then
			MsgPopup(
				302535920000959--[[You need to select something that has space for visitors.--]],
				3980--[[Buildings--]],
				default_icon2
			)
			return
		end
		local ChoGGi = ChoGGi
		local DefaultSetting = sel.base_max_visitors
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 10,value = 10},
			{text = 25,value = 25},
			{text = 50,value = 50},
			{text = 75,value = 75},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
		}

		--check if there's an entry for building
		if not ChoGGi.UserSettings.BuildingSettings[sel.template_name] then
			ChoGGi.UserSettings.BuildingSettings[sel.template_name] = {}
		end

		local hint = DefaultSetting
		local setting = ChoGGi.UserSettings.BuildingSettings[sel.template_name]
		if setting and setting.visitors then
			hint = tostring(setting.visitors)
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then
				local tab = UICity.labels.BuildingNoDomes or ""
				for i = 1, #tab do
					if tab[i].template_name == sel.template_name then
						tab[i].max_visitors = value
					end
				end

				if value == DefaultSetting then
					ChoGGi.UserSettings.BuildingSettings[sel.template_name].visitors = nil
				else
					ChoGGi.UserSettings.BuildingSettings[sel.template_name].visitors = value
				end

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					S[302535920000960--[[%s visitor capacity is now %s.--]]]:format(RetName(sel),choice[1].text),
					3980--[[Buildings--]],
					default_icon2
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s %s %s",S[302535920000129--[[Set--]]],RetName(sel),S[302535920000961--[[Visitor Capacity--]]]),
			hint = StringFormat("%s: %s",S[302535920000914--[[Current capacity--]]],hint),
			skip_sort = true,
		}
	end

	function ChoGGi.MenuFuncs.SetStorageDepotSize(sType)
		local ChoGGi = ChoGGi
		local r = ChoGGi.Consts.ResourceScale
		local DefaultSetting = ChoGGi.Consts[sType] / r
		local hint_max = S[302535920000962--[[Max capacity limited to:
	Universal: 2,500
	Other: 20,000
	Waste: 1,000,000
	Mechanized: 1,000,000--]]]
		local ItemList = {
			{text = StringFormat("%s: %s",S[1000121--[[Default--]]],DefaultSetting),value = DefaultSetting},
			{text = 50,value = 50},
			{text = 100,value = 100},
			{text = 250,value = 250},
			{text = 500,value = 500},
			{text = 1000,value = 1000},
			{text = 2500,value = 2500,hint = hint_max},
			{text = 5000,value = 5000,hint = hint_max},
			{text = 10000,value = 10000,hint = hint_max},
			{text = 20000,value = 20000,hint = hint_max},
			{text = 100000,value = 100000,hint = hint_max},
			{text = 1000000,value = 1000000,hint = hint_max},
		}

		local hint = DefaultSetting
		if ChoGGi.UserSettings[sType] then
			hint = ChoGGi.UserSettings[sType] / r
		end

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value
			if type(value) == "number" then

				local value = value * r
				if sType == "StorageWasteDepot" then
					--limit amounts so saving with a full load doesn't delete your game
					if value > 1000000000 then
						value = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
					end
					--loop through and change all existing

					local tab = UICity.labels.WasteRockDumpSite or ""
					for i = 1, #tab do
						tab[i].max_amount_WasteRock = value
						if tab[i]:GetStoredAmount() < 0 then
							tab[i]:CheatEmpty()
							tab[i]:CheatFill()
						end
					end
				elseif sType == "StorageOtherDepot" then
					if value > 20000000 then
						value = 20000000
					end
					local tab = UICity.labels.UniversalStorageDepot or ""
					for i = 1, #tab do
						if tab[i].entity ~= "StorageDepot" then
							tab[i].max_storage_per_resource = value
						end
					end
					local function OtherDepot(label,res)
						local tab = ChoGGi.ComFuncs.RetAllOfClass(label)
						for i = 1, #tab do
							tab[i][res] = value
						end
					end
					OtherDepot("MysteryResource","max_storage_per_resource")
					OtherDepot("BlackCubeDumpSite","max_amount_BlackCube")
				elseif sType == "StorageUniversalDepot" then
					if value > 2500000 then
						value = 2500000 --can go to 2900, but I got a crash; which may have been something else, but it's only 400
					end
					local tab = UICity.labels.UniversalStorageDepot or ""
					for i = 1, #tab do
						if tab[i].entity == "StorageDepot" then
							tab[i].max_storage_per_resource = value
						end
					end
				elseif sType == "StorageMechanizedDepot" then
					if value > 1000000000 then
						value = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
					end
					local tab = UICity.labels.MechanizedDepots or ""
					for i = 1, #tab do
						tab[i].max_storage_per_resource = value
					end
				end
				--for new buildings
				ChoGGi.ComFuncs.SetSavedSetting(sType,value)

				ChoGGi.SettingFuncs.WriteSettings()
				MsgPopup(
					StringFormat("%s: %s",choice[1].text,sType),
					519--[[Storage--]],
					"UI/Icons/Sections/basic.tga"
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s: %s %s",S[302535920000129--[[Set--]]],sType,S[302535920000963--[[Size--]]]),
			hint = StringFormat("%s: %s\n\n%s",S[302535920000914--[[Current capacity--]]],hint,hint_max),
			skip_sort = true,
		}
	end

end
