-- See LICENSE for terms

-- BuildingTemplates, ClassTemplates.Building

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local RetName = ChoGGi.ComFuncs.RetName
local Translate = ChoGGi.ComFuncs.Translate
local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass
local Strings = ChoGGi.Strings

function ChoGGi.MenuFuncs.UnlockCrops()
	local item_list = {}
	local c = 0

	local CropPresets = CropPresets
	for id, crop in pairs(CropPresets) do
		if crop.Locked then
			c = c + 1
			item_list[c] = {
				text = Translate(crop.DisplayName),
				value = id,
				hint = Translate(crop.Desc),
				icon = crop.icon,
			}
		end
	end
	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if CropPresets[value] then
			UnlockCrop(value)
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(value),
				Strings[302535920000423--[[Unlock Crops]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000423--[[Unlock Crops]]],
	}
end

function ChoGGi.MenuFuncs.RotateDuringPlacement_Toggle()
	local buildings = ClassTemplates.Building

	if ChoGGi.UserSettings.RotateDuringPlacement then
		-- used when starting/loading a game
		ChoGGi.UserSettings.RotateDuringPlacement = nil

		for _, bld in pairs(buildings) do
			if bld.can_rotate_during_placement_ChoGGi_orig then
				bld.can_rotate_during_placement = false
				bld.can_rotate_during_placement_ChoGGi_orig = nil
			end
		end

	else
		-- used when starting/loading a game
		ChoGGi.UserSettings.RotateDuringPlacement = true

		for _, bld in pairs(buildings) do
			if bld.can_rotate_during_placement == false then
				bld.can_rotate_during_placement_ChoGGi_orig = true
				bld.can_rotate_during_placement = true
			end
		end
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RotateDuringPlacement),
		Strings[302535920001407--[[Rotate During Placement]]]
	)
end

function ChoGGi.MenuFuncs.SponsorBuildingLimits_Toggle()
	local BuildingTechRequirements = BuildingTechRequirements
	local BuildingTemplates = BuildingTemplates
	local table_remove = table.remove
	local table_find = table.find

	if ChoGGi.UserSettings.SponsorBuildingLimits then
		-- used when starting/loading a game
		ChoGGi.UserSettings.SponsorBuildingLimits = nil

		for _, bld in pairs(BuildingTemplates) do
			-- set each status to false if it isn't
			for i = 1, 3 do
				local str = "sponsor_status" .. i .. "_ChoGGi_orig"
				if bld[str] then
					bld["sponsor_status" .. i] = bld[str]
					bld[str] = nil
				end
			end
		end

	else
		-- used when starting/loading a game
		ChoGGi.UserSettings.SponsorBuildingLimits = true

		for id, bld in pairs(BuildingTemplates) do
			-- set each status to false if it isn't
			for i = 1, 3 do
				local str = "sponsor_status" .. i
				local status = bld[str]
				if status ~= false then
					bld["sponsor_status" .. i .. "_ChoGGi_orig"] = status
					bld[str] = false
				end
			end

			-- and this bugger screws me over on GetBuildingTechsStatus
			local name = id
			if name:sub(1, 2) == "RC" and name:sub(-8) == "Building" then
				name = name:gsub("Building", "")
			end
			local idx = table_find(BuildingTechRequirements[id], "check_supply", name)
			if idx then
				table_remove(BuildingTechRequirements[id], idx)
			end

		end
	end

	ChoGGi.SettingFuncs.WriteSettings()
	ChoGGi.ComFuncs.UpdateBuildMenu()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SponsorBuildingLimits),
		Strings[302535920001398--[[Remove Sponsor Limits]]]
	)
end

function ChoGGi.MenuFuncs.BuildOnGeysers_Toggle()
	ChoGGi.UserSettings.BuildOnGeysers = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.BuildOnGeysers)
	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.BuildOnGeysers),
		Strings[302535920000064--[[Build On Geysers]]]
	)
end

function ChoGGi.MenuFuncs.SetTrainingPoints()
	local obj = ChoGGi.ComFuncs.SelObject()
	if not obj or not IsKindOf(obj, "TrainingBuilding") then
		MsgPopup(
			Strings[302535920001116--[[Select a %s.]]]:format(Translate(5443--[[Training Buildings]])),
			T(5443, "Training Buildings")
		)
		return
	end
	local id = RetTemplateOrClass(obj)
	local name = RetName(obj)
	local default_setting = obj:GetClassValue("evaluation_points")
	local UserSettings = ChoGGi.UserSettings

	local item_list = {
		{text = Translate(1000121--[[Default]]), value = default_setting},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 20, value = 20},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
	}

	if not UserSettings.BuildingSettings[id] then
		UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = UserSettings.BuildingSettings[id]
	if setting and setting.evaluation_points then
		hint = setting.evaluation_points
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value

		if type(value) == "number" then
			local objs = ChoGGi.ComFuncs.RetAllOfClass(obj.class)

			if value == default_setting then
				setting.evaluation_points = nil
				for i = 1, #objs do
					objs[i].evaluation_points = default_setting
				end
			else
				setting.evaluation_points = value
				for i = 1, #objs do
					objs[i].evaluation_points = value
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(value, name),
				Strings[302535920001344--[[Points To Train]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = name .. ": " .. Strings[302535920001344--[[Points To Train]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetServiceBuildingStats()

	local obj = ChoGGi.ComFuncs.SelObject()
	if not obj or not IsKindOf(obj, "StatsChange") then
		MsgPopup(
			Strings[302535920001116--[[Select a %s.]]]:format(Translate(5439--[[Service Buildings]])),
			T(4810, "Service")
		)
		return
	end
	local r = const.ResourceScale
	local id = RetTemplateOrClass(obj)
	local ServiceInterestsList = table.concat(ServiceInterestsList, ", ")
	local name = RetName(obj)
	local is_service = obj:IsKindOf("Service")

	local ReturnEditorType = ChoGGi.ComFuncs.ReturnEditorType
	local hint_type = Strings[302535920000138--[[Value needs to be a %s.]]]
	local item_list = {
		{text = Translate(728--[[Health change on visit]]), value = obj:GetClassValue("health_change") / r, setting = "health_change", hint = hint_type:format(ReturnEditorType(obj.properties, "id", "health_change"))},
		{text = Translate(729--[[Sanity change on visit]]), value = obj:GetClassValue("sanity_change") / r, setting = "sanity_change", hint = hint_type:format(ReturnEditorType(obj.properties, "id", "sanity_change"))},
		{text = Translate(730--[[Service Comfort]]), value = obj:GetClassValue("service_comfort") / r, setting = "service_comfort", hint = hint_type:format(ReturnEditorType(obj.properties, "id", "service_comfort"))},
		{text = Translate(731--[[Comfort increase on visit]]), value = obj:GetClassValue("comfort_increase") / r, setting = "comfort_increase", hint = hint_type:format(ReturnEditorType(obj.properties, "id", "comfort_increase"))},
	}
	local c = #item_list
	if is_service then
		c = c + 1
		item_list[c] = {text = Translate(734--[[Visit duration]]), value = obj:GetClassValue("visit_duration"), setting = "visit_duration", hint = hint_type:format(ReturnEditorType(obj.properties, "id", "visit_duration"))}
		-- bool
		c = c + 1
		item_list[c] = {text = Translate(735--[[Usable by children]]), value = obj:GetClassValue("usable_by_children"), setting = "usable_by_children", hint = hint_type:format(ReturnEditorType(obj.properties, "id", "usable_by_children"))}
		c = c + 1
		item_list[c] = {text = Translate(736--[[Children Only]]), value = obj:GetClassValue("children_only"), setting = "children_only", hint = hint_type:format(ReturnEditorType(obj.properties, "id", "children_only"))}

		for i = 1, 11 do
			local name = "interest" .. i
			c = c + 1
			item_list[c] = {
				text = Translate(732--[[Service interest]]) .. " " .. i,
				value = obj[name],
				setting = name,
				hint = hint_type:format(ReturnEditorType(obj.properties, "id", name)) .. "\n\n" .. ServiceInterestsList,
			}
		end
	end

	local BuildingSettings = ChoGGi.UserSettings.BuildingSettings
	if not BuildingSettings[id] then
		BuildingSettings[id] = {}
	end

	local bs_setting = BuildingSettings[id]
	if not bs_setting.service_stats then
		bs_setting.service_stats = {}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local set = Strings[302535920000129--[[Set]]]

		if choice[1].check1 then
			set = Translate(1000121--[[Default]])

			bs_setting.service_stats = nil
			-- get defaults
			local temp = {
				health_change = obj:GetClassValue("health_change"),
				sanity_change = obj:GetClassValue("sanity_change"),
				service_comfort = obj:GetClassValue("service_comfort"),
				comfort_increase = obj:GetClassValue("comfort_increase"),
			}
			if is_service then
				temp.visit_duration = obj:GetClassValue("visit_duration")
				temp.usable_by_children = obj:GetClassValue("usable_by_children")
				temp.children_only = obj:GetClassValue("children_only")
				for i = 1, 11 do
					local name = "interest" .. i
					temp[name] = obj:GetClassValue(name)
				end
			end

			-- reset existing to defaults
			local objs = ChoGGi.ComFuncs.RetAllOfClass(id)
			for i = 1, #objs do
				local obj = objs[i]
				obj:SetBase("health_change", temp.health_change)
				obj:SetBase("sanity_change", temp.sanity_change)
				obj:SetBase("service_comfort", temp.service_comfort)
				obj:SetBase("comfort_increase", temp.comfort_increase)
				if is_service then
				obj:SetBase("visit_duration", temp.visit_duration)
				obj:SetBase("usable_by_children", temp.usable_by_children)
				obj:SetBase("children_only", temp.children_only)
					for j = 1, 11 do
						local name = "interest" .. j
						obj:SetBase("name", temp[name])
					end
				end
			end
		else
			-- build setting to save
			for i = 1, #choice do
				local setting = choice[i].setting
				local value, value_type = ChoGGi.ComFuncs.RetProperType(choice[i].value)
				-- check user added correct
				local editor_type = ReturnEditorType(obj.properties, "id", setting)
				if value_type == editor_type then
					if editor_type == "number" then
						bs_setting.service_stats[setting] = value * r
					elseif value == "" then
						bs_setting.service_stats[setting] = nil
					else
						bs_setting.service_stats[setting] = value
					end
				end
			end
			-- update existing buildings
			local objs = ChoGGi.ComFuncs.RetAllOfClass(id)
			local UpdateServiceComfortBld = ChoGGi.ComFuncs.UpdateServiceComfortBld
			for i = 1, #objs do
				UpdateServiceComfortBld(objs[i], bs_setting.service_stats)
			end
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(set),
			Strings[302535920001114--[[Service Building Stats]]]
		)
	end

	local custom_settings = false
	if next(bs_setting.service_stats) then
		custom_settings = true
	end
	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000129--[[Set]]] .. " " .. name .. " " .. Strings[302535920001114--[[Service Building Stats]]],
		hint = Strings[302535920001339--[[Are settings custom: %s]]]:format(custom_settings),
		hint = Strings[302535920001340--[[Invalid settings will be skipped.]]] .. "\n\n" .. Strings[302535920001339--[[Are settings custom: %s]]]:format(custom_settings),
		custom_type = 4,
		skip_sort = true,
		checkboxes = {
			{
				title = Translate(1000121--[[Default]]),
				hint = Strings[302535920001338--[[Reset to default.]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.SetExportWhenThisAmount()
	local default_setting = Translate(1000121--[[Default]])
	local UserSettings = ChoGGi.UserSettings
	local id = "SpaceElevator"
	local item_list = {
		{text = default_setting, value = default_setting},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 20, value = 20},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
	}

	if not UserSettings.BuildingSettings[id] then
		UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = UserSettings.BuildingSettings[id]
	if setting and setting.export_when_this_amount then
		hint = setting.export_when_this_amount
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value

		if value == default_setting then
			setting.export_when_this_amount = nil
		else
			setting.export_when_this_amount = value * const.ResourceScale
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(choice.value),
			Strings[302535920001336--[[Export When This Amount]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001336--[[Export When This Amount]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetSpaceElevatorTransferAmount(action)
	local setting_name = action.setting_name
	local title = action.setting_msg

	local r = const.ResourceScale
	local default_setting = SpaceElevator[setting_name] / r
	local UserSettings = ChoGGi.UserSettings
	local id = "SpaceElevator"
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 20, value = 20},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
	}

	if not UserSettings.BuildingSettings[id] then
		UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = UserSettings.BuildingSettings[id]
	if setting and setting[setting_name] then
		hint = setting[setting_name]
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			value = value * r

			if value == default_setting * r then
				setting[setting_name] = nil
			else
				setting[setting_name] = value
			end

			local objs = UICity.labels.SpaceElevator or ""
			for i = 1, #objs do
				ChoGGi.ComFuncs.SetTaskReqAmount(objs[i], value, "export_request", setting_name)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				title
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[title],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SpaceElevatorExport_Toggle()
	ChoGGi.UserSettings.SpaceElevatorToggleInstantExport = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.SpaceElevatorToggleInstantExport)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SpaceElevatorToggleInstantExport),
		Strings[302535920001330--[[Instant Export On Toggle]]]
	)
end

function ChoGGi.MenuFuncs.SetStorageAmountOfDinerGrocery()
	local default_setting = 5
	local UserSettings = ChoGGi.UserSettings
	local r = const.ResourceScale
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 20, value = 20},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
	}

	-- other hint type
	local hint = default_setting
	if UserSettings.ServiceWorkplaceFoodStorage then
		hint = UserSettings.ServiceWorkplaceFoodStorage
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			value = value * r

			if value == default_setting * r then
				UserSettings.ServiceWorkplaceFoodStorage = nil
			else
				UserSettings.ServiceWorkplaceFoodStorage = value
			end

			local function SetStor(cls)
				local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
				for i = 1, #objs do
					local o = objs[i]
					o.consumption_stored_resources = value
					o.consumption_max_storage = value
				end
			end
			SetStor("Diner")
			SetStor("Grocery")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				Strings[302535920000164--[[Storage Amount Of Diner & Grocery]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000105--[[Set Food Storage]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.AlwaysDustyBuildings_Toggle()
	if ChoGGi.UserSettings.AlwaysDustyBuildings then
		ChoGGi.UserSettings.AlwaysDustyBuildings = nil
		-- dust clean up
		local objs = UICity.labels.Building or ""
		for i = 1, #objs do
			objs[i].ChoGGi_AlwaysDust = nil
		end
	else
		ChoGGi.UserSettings.AlwaysDustyBuildings = true
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000107--[[%s: I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration.
I will face my fear. I will permit it to pass over me and through me,
and when it has gone past I will turn the inner eye to see its path.
Where the fear has gone there will be nothing. Only I will remain.]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.AlwaysDustyBuildings)),
		Strings[302535920000174--[[Always Dusty]]],
		{size = true}
	)
end

local function DustCleanUp(label)
	for i = 1, #label do
		ApplyToObjAndAttaches(label[i], SetObjDust, 0)
	end
end
function ChoGGi.MenuFuncs.AlwaysCleanBuildings_Toggle()
	if ChoGGi.UserSettings.AlwaysCleanBuildings then
		ChoGGi.UserSettings.AlwaysCleanBuildings = nil
	else
		ChoGGi.UserSettings.AlwaysCleanBuildings = true
		local labels = UICity.labels
		DustCleanUp(labels.Building or "")
		DustCleanUp(labels.GridElements or "")
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.AlwaysCleanBuildings),
		Strings[302535920000037--[[Always Clean]]]
	)
end

function ChoGGi.MenuFuncs.SetProtectionRadius()
	local obj = ChoGGi.ComFuncs.SelObject()
	if not obj or not obj.protect_range then
		MsgPopup(
			Strings[302535920000108--[[Select something with a protect_range (MDSLaser/DefenceTower).]]],
			Strings[302535920000178--[[Protection Radius]]]
		)
		return
	end
	local id = RetTemplateOrClass(obj)
	local cls_obj = g_Classes[id]
	local default_setting = cls_obj.protect_range or cls_obj:GetClassValue("protect_range")
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 40, value = 40},
		{text = 80, value = 80},
		{text = 160, value = 160},
		{text = 320, value = 320, hint = Strings[302535920000111--[[Cover the entire map from the centre.]]]},
		{text = 640, value = 640, hint = Strings[302535920000112--[[Cover the entire map from a corner.]]]},
	}

	if not ChoGGi.UserSettings.BuildingSettings[id] then
		ChoGGi.UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = ChoGGi.UserSettings.BuildingSettings[id]
	if setting and setting.protect_range then
		hint = tostring(setting.protect_range)
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			local objs = ChoGGi.ComFuncs.RetAllOfClass(id)
			for i = 1, #objs do
				local obj = objs[i]
				obj.protect_range = value
				obj.shoot_range = value * guim
			end

			if value == default_setting then
				ChoGGi.UserSettings.BuildingSettings[id].protect_range = nil
			else
				ChoGGi.UserSettings.BuildingSettings[id].protect_range = value
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000113--[[%s range is now %s.]]]:format(RetName(obj), choice[1].text),
				Strings[302535920000178--[[Protection Radius]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000114--[[Set Protection Radius]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint .. "\n\n" ..Strings[302535920000115--[[Toggle selection to update visible hex grid.]]],
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.UnlockLockedBuildings()
	local everything = Strings[302535920000306--[[Everything]]]
	local item_list = {
		{
		text = " " .. everything,
		value = everything,
		},
	}
	local c = #item_list

	local BuildingTemplates = BuildingTemplates
	local GetBuildingTechsStatus = GetBuildingTechsStatus
	for id, bld in pairs(BuildingTemplates) do
		if not GetBuildingTechsStatus(id) then
			c = c + 1
			item_list[c] = {
				text = Translate(bld.display_name),
				value = id,
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local UnlockBuilding = UnlockBuilding
		-- if everything then ignore the choices and just use the itemlist
		if table.find(choice, "value", everything) then
			choice = item_list
		end

		for i = 1, #choice do
			UnlockBuilding(choice[i].value)
		end
		ChoGGi.ComFuncs.UpdateBuildMenu()
		MsgPopup(
			Strings[302535920000116--[[%s: Buildings unlocked.]]]:format(#choice),
			Strings[302535920000180--[[Unlock Locked Buildings]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000117--[[Unlock Buildings]]],
		hint = Strings[302535920000118--[[Pick the buildings you want to unlock (use Ctrl/Shift for multiple).]]],
		multisel = true,
	}
end

function ChoGGi.MenuFuncs.PipesPillarsSpacing_Toggle()
	ChoGGi.ComFuncs.SetConstsG("PipesPillarSpacing", ChoGGi.ComFuncs.ValueRetOpp(Consts.PipesPillarSpacing, 1000, ChoGGi.Consts.PipesPillarSpacing))
	ChoGGi.ComFuncs.SetSavedConstSetting("PipesPillarSpacing")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000119--[[%s: Is that a rocket in your pocket?]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.PipesPillarSpacing)),
		T(4713, "Pipes pillar spacing")
	)
end

function ChoGGi.MenuFuncs.UnlimitedConnectionLength_Toggle()
	if ChoGGi.UserSettings.UnlimitedConnectionLength then
		ChoGGi.UserSettings.UnlimitedConnectionLength = nil
		GridConstructionController.max_hex_distance_to_allow_build = 20
		const.PassageConstructionGroupMaxSize = 20
	else
		ChoGGi.UserSettings.UnlimitedConnectionLength = true
		GridConstructionController.max_hex_distance_to_allow_build = 1000
		const.PassageConstructionGroupMaxSize = 1000
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000119--[[%s: Is that a rocket in your pocket?]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.UnlimitedConnectionLength)),
		Strings[302535920000184--[[Unlimited Connection Length]]]
	)
end

local function BuildingConsumption_Toggle(type1, str1, type2, func1, func2, str2)
	local obj = SelectedObj
	if not obj or not obj[type1] then
		MsgPopup(
			str1,
			T(3980, "Buildings")
		)
		return
	end
	local id = RetTemplateOrClass(obj)
	local UserSettings = ChoGGi.UserSettings

	if not UserSettings.BuildingSettings[id] then
		UserSettings.BuildingSettings[id] = {}
	end

	local setting = UserSettings.BuildingSettings[id]
	local which
	if setting[type2] then
		setting[type2] = nil
		which = func1
	else
		setting[type2] = true
		which = func2
	end

	local ComFuncs = ChoGGi.ComFuncs
	local blds = ComFuncs.RetAllOfClass(id)
	for i = 1, #blds do
		ComFuncs[which](blds[i])
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		RetName(obj) .. " " .. str2,
		which
	)
end

function ChoGGi.MenuFuncs.BuildingPower_Toggle()
	BuildingConsumption_Toggle(
		"electricity_consumption",
		Strings[302535920000120--[[You need to select a building that uses electricity.]]],
		"nopower",
		"AddBuildingElecConsump",
		"RemoveBuildingElecConsump",
		Translate(683--[[Power Consumption]])
	)
end

function ChoGGi.MenuFuncs.BuildingWater_Toggle()
	BuildingConsumption_Toggle(
		"water_consumption",
		Strings[302535920000121--[[You need to select a building that uses water.]]],
		"nowater",
		"AddBuildingWaterConsump",
		"RemoveBuildingWaterConsump",
		Translate(656--[[Water consumption]])
	)
end

function ChoGGi.MenuFuncs.BuildingAir_Toggle()
	BuildingConsumption_Toggle(
		"air_consumption",
		Strings[302535920001250--[[You need to select a building that uses oxygen.]]],
		"noair",
		"AddBuildingAirConsump",
		"RemoveBuildingAirConsump",
		Translate(657--[[Oxygen Consumption]])
	)
end

function ChoGGi.MenuFuncs.SetMaxChangeOrDischarge()
	local obj = SelectedObj
	if not obj or obj and not obj:IsKindOfClasses{"ElectricityStorage", "AirStorage", "WaterStorage"} then
		MsgPopup(
			Strings[302535920000122--[[You need to select something that has capacity (air/water/elec).]]],
			Strings[302535920000188--[[Set Charge & Discharge Rates]]]
		)
		return
	end
	local id = RetTemplateOrClass(obj)
	local name = Translate(obj.display_name)
	local r = const.ResourceScale

	-- get type of capacity
	local cap_type, charge, discharge
	if obj:IsKindOf("ElectricityStorage") then
		cap_type, charge, discharge = "electricity", "max_electricity_charge", "max_electricity_discharge"
	elseif obj:IsKindOf("AirStorage") then
		cap_type, charge, discharge = "air", "max_air_charge", "max_air_discharge"
	elseif obj:IsKindOf("WaterStorage") then
		cap_type, charge, discharge = "water", "max_water_charge", "max_water_discharge"
	end
	if not cap_type then
		return
	end

	-- get default amount
	local template = BuildingTemplates[id]
	local default_settingC = template[charge] / r
	local default_settingD = template[discharge] / r

	local item_list = {
		{text = Translate(1000121--[[Default]]), value = Translate(1000121--[[Default]]), hint = Strings[302535920000124--[[Charge]]]
			.. ": " .. default_settingC .. " / " .. Strings[302535920000125--[[Discharge]]]
			.. ": " .. default_settingD},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
	}

	--check if there's an entry for building
	if not ChoGGi.UserSettings.BuildingSettings[id] then
		ChoGGi.UserSettings.BuildingSettings[id] = {}
	end

	local hint = Strings[302535920000124--[[Charge]]] .. ": " .. default_settingC .. " / " .. Strings[302535920000125--[[Discharge]]] .. ": " .. default_settingD
	local setting = ChoGGi.UserSettings.BuildingSettings[id]
	if setting then
		if setting.charge and setting.discharge then
			hint = Strings[302535920000124--[[Charge]]] .. ": " .. (setting.charge / r) .. " / " .. Strings[302535920000125--[[Discharge]]] .. ": " .. (setting.discharge / r)
		elseif setting.charge then
			hint = setting.charge / r
		elseif setting.discharge then
			hint = setting.discharge / r
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		local check1 = choice[1].check1
		local check2 = choice[1].check2

		if type(value) == "number" then
			local numberC = value * r
			local numberD = value * r

			if value == Translate(1000121--[[Default]]) then
				if check1 then
					setting.charge = nil
					numberC = default_settingC * r
				end
				if check2 then
					setting.discharge = nil
					numberD = default_settingD * r
				end
			else
				if check1 then
					setting.charge = numberC
				end
				if check2 then
					setting.discharge = numberD
				end
			end

			-- updating time
			if cap_type == "electricity" then
				local objs = UICity.labels.Power or ""
				for i = 1, #objs do
					local o = objs[i]
					if RetTemplateOrClass(o) == id then
						if check1 then
							o[cap_type].max_charge = numberC
							o[charge] = numberC
						end
						if check2 then
							o[cap_type].max_discharge = numberD
							o[discharge] = numberD
						end
						ChoGGi.ComFuncs.ToggleWorking(o)
					end
				end
			else -- water and air
				local objs = UICity.labels["Life-Support"] or ""
				for i = 1, #objs do
					local o = objs[i]
					if RetTemplateOrClass(o) == id then
						if check1 then
							o[cap_type].max_charge = numberC
							o[charge] = numberC
						end
						if check2 then
							o[cap_type].max_discharge = numberD
							o[discharge] = numberD
						end
						ChoGGi.ComFuncs.ToggleWorking(o)
					end
				end
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				Strings[302535920000128--[[%s rate is now: %s]]]:format(RetName(obj), choice[1].text),
				Strings[302535920000188--[[Set Charge & Discharge Rates]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000129--[[Set]]] .. " " .. name .. " " .. Strings[302535920000130--[[Dis/Charge Rates]]],
		hint = Strings[302535920000131--[[Current rate]]] .. ": " .. hint,
		skip_sort = true,
		checkboxes = {
			at_least_one = true,
			{
				title = Strings[302535920000124--[[Charge]]],
				hint = Strings[302535920000132--[[Change charge rate]]],
				checked = true,
			},
			{
				title = Strings[302535920000125--[[Discharge]]],
				hint = Strings[302535920000133--[[Change discharge rate]]],
			},
		},
	}
end

function ChoGGi.MenuFuncs.FarmShiftsAllOn()
	local labels = UICity.labels
	local objs = labels.BaseFarm or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.closed_shifts[1] = false
		obj.closed_shifts[2] = false
		obj.closed_shifts[3] = false
	end
	--BaseFarm doesn't include FungalFarm...
	objs = labels.FungalFarm or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.closed_shifts[1] = false
		obj.closed_shifts[2] = false
		obj.closed_shifts[3] = false
	end

	MsgPopup(
		Strings[302535920000135--[[Well, I been working in a coal mine
Going down, down
Working in a coal mine
Whew, about to slip down]]],
		Strings[302535920000192--[[Farm Shifts All On]]],
		{size = true}
	)
end

function ChoGGi.MenuFuncs.SetProductionAmount()
	local obj = SelectedObj
	if not obj or obj and not obj:IsKindOfClasses{"WaterProducer", "AirProducer", "ElectricityProducer", "ResourceProducer"} then
		MsgPopup(
			Strings[302535920000136--[[Select something that produces (air, water, electricity, other).]]],
			Strings[302535920000194--[[Production Amount Set]]]
		)
		return
	end
	local id = RetTemplateOrClass(obj)
	local name = Translate(obj.display_name)

	local r = const.ResourceScale
	-- get type of producer/base amount
	local prod_type, default_setting
	if obj:IsKindOf("WaterProducer") then
		prod_type, default_setting = "water", obj:GetClassValue("water_production") / r
	elseif obj:IsKindOf("AirProducer") then
		prod_type, default_setting = "air", obj:GetClassValue("air_production") / r
	elseif obj:IsKindOf("ElectricityProducer") then
		prod_type, default_setting = "electricity", obj:GetClassValue("electricity_production") / r
	elseif obj:IsKindOf("ResourceProducer") then
		prod_type, default_setting = "other", obj:GetClassValue("production_per_day1") / r
	end

	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
	}

	-- check if there's an entry for building
	if not ChoGGi.UserSettings.BuildingSettings[id] then
		ChoGGi.UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	local setting = ChoGGi.UserSettings.BuildingSettings[id]
	if setting and setting.production then
		hint = tostring(setting.production / r)
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then
			local amount = value * r

			-- setting we use to actually update prod
			if value == default_setting then
				-- remove setting as we reset building type to default (we don't want to call it when we place a new building if nothing is going to be changed)
				ChoGGi.UserSettings.BuildingSettings[id].production = nil
			else
				-- update/create saved setting
				ChoGGi.UserSettings.BuildingSettings[id].production = amount
			end

			-- all this just to update the displayed amount :)
			local function SetProd(label)
				local objs = ChoGGi.ComFuncs.RetAllOfClass(label)
				for i = 1, #objs do
					local o = objs[i]
					if RetTemplateOrClass(o) == id then
						o[prod_type]:SetProduction(amount)
					end
				end
			end

			if prod_type == "electricity" then
				-- electricity
				SetProd("Power")
			elseif prod_type == "water" or prod_type == "air" then
				-- water/air
				SetProd("Life-Support")
			else -- other prod

				local function SetProdOther(label)
					local objs = ChoGGi.ComFuncs.RetAllOfClass(label)
					for i = 1, #objs do
						local o = objs[i]
						if RetTemplateOrClass(o) == id then
							o:GetProducerObj().production_per_day = amount
							o:GetProducerObj():Produce(amount)
						end
					end
				end

				-- extractors/factories
				SetProdOther("Production")
				-- moholemine/theexvacator
				SetProdOther("Wonders")
				-- farms
				if id:find("Farm") then
					SetProdOther("BaseFarm")
					SetProdOther("FungalFarm")
				end
			end

		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			Strings[302535920000137--[[%s production is now: %s]]]:format(RetName(obj), choice[1].text),
			Strings[302535920000194--[[Production Amount Set]]]
		)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000129--[[Set]]] .. " " .. name .. " " .. Strings[302535920000139--[[Production Amount]]],
		hint = Strings[302535920000140--[[Current production]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetFullyAutomatedBuildings()
	local obj = SelectedObj
	if not obj or not IsKindOf(obj, "Workplace") then
		MsgPopup(
			Strings[302535920000141--[[Select a building with workers.]]],
			Strings[302535920000196--[[Fully Automated Building]]]
		)
		return
	end
	local id = RetTemplateOrClass(obj)

	local item_list = {
		{text = Translate(251103844022--[[Disable]]), value = "Disable"},
		{text = 100, value = 100},
		{text = 150, value = 150},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2500, value = 2500},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
		{text = 50000, value = 50000},
		{text = 100000, value = 100000},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value

		if value == "Disable" then
			value = nil
			if choice[1].check then
				obj.max_workers = obj:GetClassValue("max_workers")
				obj.automation = obj:GetClassValue("automation")
				obj.auto_performance = obj:GetClassValue("auto_performance")
				ChoGGi.ComFuncs.ToggleWorking(obj)
			else
				local blds = ChoGGi.ComFuncs.RetAllOfClass(obj.class)
				if #blds > 0 then
					-- GetClassValue gets the metatable for the obj, so just grab the first one and use those values
					local max_workers = blds[1]:GetClassValue("max_workers")
					local automation = blds[1]:GetClassValue("automation")
					local auto_performance = blds[1]:GetClassValue("auto_performance")
					for i = 1, #blds do
						local bld = blds[i]
						bld.max_workers = max_workers
						bld.automation = automation
						bld.auto_performance = auto_performance
						ChoGGi.ComFuncs.ToggleWorking(bld)
					end
				end
			end
		elseif type(value) == "number" then
			if choice[1].check then
				obj.max_workers = 0
				obj.automation = 1
				obj.auto_performance = value
				ChoGGi.ComFuncs.ToggleWorking(obj)
			else
				local blds = ChoGGi.ComFuncs.RetAllOfClass(obj.class)
				for i = 1, #blds do
					local bld = blds[i]
					bld.max_workers = 0
					bld.automation = 1
					bld.auto_performance = value
					ChoGGi.ComFuncs.ToggleWorking(bld)
				end
			end
		end

		ChoGGi.UserSettings.BuildingSettings[id].auto_performance = value
		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			Strings[302535920000143--[["%s
I presume the PM's in favour of the scheme because it'll reduce unemployment."]]]:format(choice[1].text),
			Strings[302535920000196--[[Fully Automated Building]]],
			{size = true}
		)
	end

	-- check if there's an entry for building
	if not ChoGGi.UserSettings.BuildingSettings[id] then
		ChoGGi.UserSettings.BuildingSettings[id] = {}
	end

	local hint = "none"
	local setting = ChoGGi.UserSettings.BuildingSettings[id]
	if setting and setting.performance then
		hint = tostring(setting.performance)
	end

	local name = RetName(obj)
	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = name .. ": " .. Strings[302535920000144--[[Automated Performance]]],
		hint = Strings[302535920000145--[[Sets performance of all automated buildings of this type]]] .. "\n" .. Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
		checkboxes = {
			{
				title = Strings[302535920000769--[[Selected]]],
				hint = Strings[302535920000147--[[Only apply to selected object instead of all %s.]]]:format(name),
			},
		},
	}
end

do -- SchoolTrainAll_Toggle/SanatoriumCureAll_Toggle
	-- used to add or remove traits from schools/sanitariums
	local function BuildingsSetAll_Traits(cls, traits, bool)
		local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
		for i = 1, #objs do
			local obj = objs[i]
			for j = 1, #traits do
				if bool == true then
					obj:SetTrait(j, nil)
				else
					obj:SetTrait(j, traits[j])
				end
			end
		end
	end

	function ChoGGi.MenuFuncs.SchoolTrainAll_Toggle()
		if ChoGGi.UserSettings.SchoolTrainAll then
			ChoGGi.UserSettings.SchoolTrainAll = nil
			BuildingsSetAll_Traits("School", ChoGGi.Tables.PositiveTraits, true)
		else
			ChoGGi.UserSettings.SchoolTrainAll = true
			BuildingsSetAll_Traits("School", ChoGGi.Tables.PositiveTraits)
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			Strings[302535920000148--[["%s:
You keep your work station so clean, Jerome.
It's next to godliness. Isn't that what they say?"]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SchoolTrainAll)),
			Strings[302535920000200--[[Train All]]],
			{size = true}
		)
	end

	function ChoGGi.MenuFuncs.SanatoriumCureAll_Toggle()
		if ChoGGi.UserSettings.SanatoriumCureAll then
			ChoGGi.UserSettings.SanatoriumCureAll = nil
			BuildingsSetAll_Traits("Sanatorium", ChoGGi.Tables.NegativeTraits, true)
		else
			ChoGGi.UserSettings.SanatoriumCureAll = true
			BuildingsSetAll_Traits("Sanatorium", ChoGGi.Tables.NegativeTraits)
		end

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			Strings[302535920000149--[[%s:
There's more vodka in this piss than there is piss.]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SanatoriumCureAll)),
			Strings[302535920000198--[[Cure All]]],
			{size = true}
		)
	end
end -- do

function ChoGGi.MenuFuncs.ShowAllTraits_Toggle()
	if ChoGGi.UserSettings.SanatoriumSchoolShowAllTraits then
		ChoGGi.UserSettings.SanatoriumSchoolShowAllTraits = nil
		g_SchoolTraits = table.copy(const.SchoolTraits)
		g_SanatoriumTraits = table.copy(const.SanatoriumTraits)
	else
		ChoGGi.UserSettings.SanatoriumSchoolShowAllTraits = true
		g_SchoolTraits = ChoGGi.Tables.PositiveTraits
		g_SanatoriumTraits = ChoGGi.Tables.NegativeTraits
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000150--[[%s: Good for what ails you]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SanatoriumSchoolShowAllTraits)),
		Strings[302535920000202--[[Show All Traits]]]
	)
end

function ChoGGi.MenuFuncs.SanatoriumSchoolShowAll()
	ChoGGi.UserSettings.SanatoriumSchoolShowAll = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.SanatoriumSchoolShowAll)

	Sanatorium.max_traits = ChoGGi.ComFuncs.ValueRetOpp(Sanatorium.max_traits, 3, #ChoGGi.Tables.NegativeTraits)
	School.max_traits = ChoGGi.ComFuncs.ValueRetOpp(School.max_traits, 3, #ChoGGi.Tables.PositiveTraits)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000150--[[%s: Good for what ails you]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SanatoriumSchoolShowAll)),
		Strings[302535920000204--[[Show Full List]]]
	)
end

function ChoGGi.MenuFuncs.MaintenanceFreeBuildingsInside_Toggle()
	ChoGGi.UserSettings.InsideBuildingsNoMaintenance = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.InsideBuildingsNoMaintenance)

	local inside_main = ChoGGi.UserSettings.InsideBuildingsNoMaintenance

	local objs = UICity.labels.InsideBuildings or ""
	for i = 1, #objs do
		local obj = objs[i]
		if obj:IsKindOf("RequiresMaintenance") then
			if inside_main then
				obj.ChoGGi_InsideBuildingsNoMaintenance = true
				obj.maintenance_build_up_per_hr = -10000
			else
				if not obj.ChoGGi_RemoveMaintenanceBuildUp then
					obj.maintenance_build_up_per_hr = nil
				end
				obj.ChoGGi_InsideBuildingsNoMaintenance = nil
			end
		end

	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000151--[[%s: The spice must flow!]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.InsideBuildingsNoMaintenance)),
		Strings[302535920000206--[[Maintenance Free Inside]]]
	)
end

function ChoGGi.MenuFuncs.MaintenanceFreeBuildings_Toggle()
	ChoGGi.UserSettings.RemoveMaintenanceBuildUp = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.RemoveMaintenanceBuildUp)

	local remove_build = ChoGGi.UserSettings.RemoveMaintenanceBuildUp
	local objs = UICity.labels.Building or ""
	for i = 1, #objs do
		local obj = objs[i]
		if obj:IsKindOf("RequiresMaintenance") then
			if remove_build then
				obj.ChoGGi_RemoveMaintenanceBuildUp = true
				obj.maintenance_build_up_per_hr = -10000
			elseif not obj.ChoGGi_InsideBuildingsNoMaintenance then
				obj.ChoGGi_RemoveMaintenanceBuildUp = nil
				obj.maintenance_build_up_per_hr = nil
			end
		end
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000151--[[%s: The spice must flow!]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RemoveMaintenanceBuildUp)),
		Strings[302535920000208--[[Maintenance Free]]]
	)
end

function ChoGGi.MenuFuncs.MoistureVaporatorPenalty_Toggle()
	const.MoistureVaporatorRange = ChoGGi.ComFuncs.NumRetBool(const.MoistureVaporatorRange, 0, ChoGGi.Consts.MoistureVaporatorRange)
	const.MoistureVaporatorPenaltyPercent = ChoGGi.ComFuncs.NumRetBool(const.MoistureVaporatorPenaltyPercent, 0, ChoGGi.Consts.MoistureVaporatorPenaltyPercent)
	ChoGGi.ComFuncs.SetSavedConstSetting("MoistureVaporatorRange")
	ChoGGi.ComFuncs.SetSavedConstSetting("MoistureVaporatorRange")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000152--[["%s: Pussy, pussy, pussy! Come on in Pussy lovers! Here at the Titty Twister we’re slashing pussy in half! Give us an offer on our vast selection of pussy! This is a pussy blow out!
Alright, we got white pussy, black pussy, spanish pussy, yellow pussy. We got hot pussy, cold pussy. We got wet pussy. We got smelly pussy. We got hairy pussy, bloody pussy. We got snapping pussy. We got silk pussy, velvet pussy, naugahyde pussy. We even got horse pussy, dog pussy, chicken pussy.
C'mon, you want pussy, come on in Pussy Lovers! If we don’t got it, you don't want it! Come on in Pussy lovers! Attention pussy shoppers!
Take advantage of our penny pussy sale! If you buy one piece of pussy at the regular price, you get another piece of pussy of equal or lesser value for only a penny!
Try and beat pussy for a penny! If you can find cheaper pussy anywhere, fuck it!"]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.MoistureVaporatorRange)),
		Strings[302535920000210--[[Moisture Vaporator Penalty]]],
		{expiration = 60}
	)
end

function ChoGGi.MenuFuncs.CropFailThreshold_Toggle()
	Consts.CropFailThreshold = ChoGGi.ComFuncs.NumRetBool(Consts.CropFailThreshold, 0, ChoGGi.Consts.CropFailThreshold)
	ChoGGi.ComFuncs.SetSavedConstSetting("CropFailThreshold")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000153--[["%s:
So, er, we the crew of the Eagle 5, if we do encounter, make first contact with alien beings,
it is a friendship greeting from the children of our small but great planet of Potatoho."]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CropFailThreshold)),
		T(4711, "Crop Fail Threshold"),
		{size = true}
	)
end

function ChoGGi.MenuFuncs.CheapConstruction_Toggle()
	local list = {
		"Metals_cost_modifier",
		"Metals_dome_cost_modifier",
		"PreciousMetals_cost_modifier",
		"PreciousMetals_dome_cost_modifier",
		"Concrete_cost_modifier",
		"Concrete_dome_cost_modifier",
		"Polymers_dome_cost_modifier",
		"Polymers_cost_modifier",
		"Electronics_cost_modifier",
		"Electronics_dome_cost_modifier",
		"MachineParts_cost_modifier",
		"MachineParts_dome_cost_modifier",
		"rebuild_cost_modifier",
	}

	local Consts = Consts
	local cConsts = ChoGGi.Consts
	local SetConstsG = ChoGGi.ComFuncs.SetConstsG
	local ValueRetOpp = ChoGGi.ComFuncs.ValueRetOpp
	local SetSavedConstSetting = ChoGGi.ComFuncs.SetSavedConstSetting
	for i = 1, #list do
		local name = list[i]
		SetConstsG(name, ValueRetOpp(Consts[name], -100, cConsts[name]))
		SetSavedConstSetting(name, Consts[name])
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000154--[[%s:
Your home will not be a hut on some swampy outback planet your home will be the entire universe.]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Metals_cost_modifier)),
		Strings[302535920000214--[[Cheap Construction]]]
	)
end

function ChoGGi.MenuFuncs.BuildingDamageCrime_Toggle()
	ChoGGi.ComFuncs.SetConstsG("CrimeEventSabotageBuildingsCount", ChoGGi.ComFuncs.ToggleBoolNum(Consts.CrimeEventSabotageBuildingsCount))
	ChoGGi.ComFuncs.SetConstsG("CrimeEventDestroyedBuildingsCount", ChoGGi.ComFuncs.ToggleBoolNum(Consts.CrimeEventDestroyedBuildingsCount))
	ChoGGi.ComFuncs.SetSavedConstSetting("CrimeEventSabotageBuildingsCount")
	ChoGGi.ComFuncs.SetSavedConstSetting("CrimeEventDestroyedBuildingsCount")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000155--[[%s:
We were all feeling a bit shagged and fagged and fashed,
it having been an evening of some small energy expenditure, O my brothers.
So we got rid of the auto and stopped off at the Korova for a nightcap.]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CrimeEventSabotageBuildingsCount)),
		Strings[302535920000216--[[Building Damage Crime]]],
		{size = true}
	)
end

function ChoGGi.MenuFuncs.CablesAndPipesNoBreak_Toggle()
	ChoGGi.UserSettings.CablesAndPipesNoBreak = not ChoGGi.UserSettings.CablesAndPipesNoBreak

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000156--[[%s: Aliens? We gotta deal with aliens too?]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.CablesAndPipesNoBreak)),
		Strings[302535920000218--[[No Chance Of Break]]]
	)
end

function ChoGGi.MenuFuncs.CablesAndPipesInstant_Toggle()
	ChoGGi.ComFuncs.SetConstsG("InstantCables", ChoGGi.ComFuncs.ToggleBoolNum(Consts.InstantCables))
	ChoGGi.ComFuncs.SetConstsG("InstantPipes", ChoGGi.ComFuncs.ToggleBoolNum(Consts.InstantPipes))
	ChoGGi.ComFuncs.SetSavedConstSetting("InstantCables")
	ChoGGi.ComFuncs.SetSavedConstSetting("InstantPipes")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000156--[[%s: Aliens? We gotta deal with aliens too?]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.InstantCables)),
		T(134, "Instant Build")
	)
end

function ChoGGi.MenuFuncs.RemoveBuildingLimits_Toggle()
	ChoGGi.UserSettings.RemoveBuildingLimits = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.RemoveBuildingLimits)
	ChoGGi.ComFuncs.SetBuildingLimits(ChoGGi.UserSettings.RemoveBuildingLimits)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RemoveBuildingLimits),
		Strings[302535920000230--[[Remove Building Limits]]]
	)
end

do -- Building_wonder_Toggle
	local function SetWonders(bool)
		local BuildingTemplates = BuildingTemplates
		for id, bld in pairs(BuildingTemplates) do
			if bld.group == "Wonders" then
				bld.wonder = bool
			-- a wonder, but not a wonder... how wonderful.
			elseif id == "OpenCity" then
				bld.wonder = bool
			end
		end
	end

	function ChoGGi.MenuFuncs.Building_wonder_Toggle()
		if ChoGGi.UserSettings.Building_wonder then
			ChoGGi.UserSettings.Building_wonder = nil
			SetWonders(true)
		else
			ChoGGi.UserSettings.Building_wonder = true
			SetWonders(false)
		end

		-- if the buildmenu is open
		ChoGGi.ComFuncs.UpdateBuildMenu()

		ChoGGi.SettingFuncs.WriteSettings()
		MsgPopup(
			ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_wonder),
			Strings[302535920000159--[[Unlimited Wonders]]]
		)
	end
end -- do

function ChoGGi.MenuFuncs.Building_dome_spot_Toggle()
	ChoGGi.UserSettings.Building_dome_spot = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.Building_dome_spot)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000160--[[%s: Freedom for spires!]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_dome_spot)),
		Strings[302535920000226--[[Remove Spire Point Limit]]]
	)
end

function ChoGGi.MenuFuncs.Building_instant_build_Toggle()
	ChoGGi.UserSettings.Building_instant_build = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.Building_instant_build)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		Strings[302535920000161--[[%s: Buildings Instant Build]]]:format(ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_instant_build)),
		Strings[302535920001241--[[Instant Build]]]
	)
end

function ChoGGi.MenuFuncs.Building_hide_from_build_menu_Toggle()
	local BuildingTemplates = BuildingTemplates

	local bc = BuildCategories
	if not table.find(bc, "id", "HiddenX") then
		bc[#bc+1] = {
			id = "HiddenX",
			name = Translate(1000155--[[Hidden]]),
			image = "UI/Icons/bmc_placeholder.tga",
			highlight = "UI/Icons/bmc_placeholder_shine.tga",
		}
	end

	if ChoGGi.UserSettings.Building_hide_from_build_menu then
		ChoGGi.UserSettings.Building_hide_from_build_menu = nil
		for _, bld in pairs(BuildingTemplates) do
			if type(bld.hide_from_build_menu_ChoGGi) ~= "nil" then
				bld.hide_from_build_menu = bld.hide_from_build_menu_ChoGGi
				bld.hide_from_build_menu_ChoGGi = nil
			end
			if bld.group == "Hidden" then
				bld.build_category = "Hidden"
			end
		end
	else
		ChoGGi.UserSettings.Building_hide_from_build_menu = true
		for _, value in pairs(BuildMenuPrerequisiteOverrides) do
			if value == "hide" then
				value = true
			end
		end
		BuildMenuPrerequisiteOverrides.StorageMysteryResource = true
		BuildMenuPrerequisiteOverrides.MechanizedDepotMysteryResource = true
		for _, bld in pairs(BuildingTemplates) do
			if bld.id ~= "LifesupportSwitch" and bld.id ~= "ElectricitySwitch" then
				bld.hide_from_build_menu_ChoGGi = bld.hide_from_build_menu
				bld.hide_from_build_menu = false
			end
			if bld.group == "Hidden" and bld.id ~= "RocketLandingSite" and bld.id ~= "ForeignTradeRocket" then
				bld.build_category = "HiddenX"
			end
		end
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.Building_hide_from_build_menu),
		Strings[302535920000224--[[Show Hidden Buildings]]]
	)
end


function ChoGGi.MenuFuncs.SetUIRangeBuildingRadius(action)
	local id = action.bld_id
	local msgpopup = action.bld_msg

	local default_setting = g_Classes[id]:GetDefaultPropertyValue("UIRange")
	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
	}
	local UserSettings = ChoGGi.UserSettings

	if not UserSettings.BuildingSettings[id] then
		UserSettings.BuildingSettings[id] = {}
	end

	local hint = default_setting
	if UserSettings.BuildingSettings[id].uirange then
		hint = UserSettings.BuildingSettings[id].uirange
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "number" then

			if value == default_setting then
				UserSettings.BuildingSettings[id].uirange = nil
			else
				UserSettings.BuildingSettings[id].uirange = value
			end

			-- find a better way to update radius...
			local obj = SelectedObj
			CreateRealTimeThread(function()
				local SelectObj = SelectObj
				local WaitMsg = WaitMsg
				local objs = ChoGGi.ComFuncs.RetAllOfClass(id)
				for i = 1, #objs do
					local o = objs[i]
					o:SetUIRange(value)
					SelectObj(o)
					WaitMsg("OnRender")
				end
				SelectObj(obj)
			end)

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				choice[1].text .. ":\n" .. msgpopup,
				id,
				{size = true}
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000129--[[Set]]] .. " " .. id .. " " .. Strings[302535920000163--[[Radius]]],
		hint = Strings[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end
