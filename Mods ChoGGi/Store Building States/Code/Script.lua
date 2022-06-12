-- See LICENSE for terms

-- local some globals
local table = table
local pairs, tonumber = pairs, tonumber
local IsValid = IsValid

local Translate = ChoGGi.ComFuncs.Translate
local RetName = ChoGGi.ComFuncs.RetName

-- store list of profiles in saved game
GlobalVar("g_ChoGGi_BuildingStates",{})
--[[
g_ChoGGi_BuildingStates = {
	[1] = {
		name = "profile1",
		[1] = {
			obj = some_obj,
			handle = obj.handle,
		},
		[2] = {
			obj = some_obj,
			handle = obj.handle,
		},
	},
	[2] = {
		name = "blah zor dfdsf",
	},
}
]]

local function ToggleShift(obj, set_value, shift)
	if type(set_value) == "boolean" then
		if set_value then
			obj:OpenShift(shift)
		else
			obj:CloseShift(shift)
		end
	end
end

local function ActivateProfile(profile)
	for i = #profile, 1, -1 do
		local state = profile[i]
		local obj = state.obj
		-- obj was deleted or something, so remove it from profile
		if not IsValid(obj) then
			table.remove(profile, i)
		else
			-- update obj with saved state
			for setting,set_value in pairs(state) do
				if setting == "priority" then
					local p = tonumber(set_value)
					if p == 1 or p == 2 or p == 3 then
						obj:SetPriority(p)
					end
				elseif setting == "working" then
					if type(set_value) == "boolean" then
						obj:SetUIWorking(set_value)
					end
				elseif setting == "shift1" then
					ToggleShift(obj,set_value,1)
				elseif setting == "shift2" then
					ToggleShift(obj,set_value,2)
				elseif setting == "shift3" then
					ToggleShift(obj,set_value,3)
				elseif setting == "specialist_enforce_mode" then
					obj:SetSpecialistEnforce(set_value)
				end

			end
		end
	end
end

-- temp table used to show popup menu of profiles
local popup = {}

function HUD.idBuildingStatesOnPress(dlg)
	table.iclear(popup)
	local c = 0

	local hint_str = T(302535920011304, [[<left_click> Activate this profile.
<right_click> Delete this profile.]])

	local BuildingStates = g_ChoGGi_BuildingStates
	for i = #BuildingStates, 1, -1 do
		local profile = BuildingStates[i]
		-- remove any empty profiles since we're here
		if #profile == 0 then
			table.remove(BuildingStates, i)
		else
			c = c + 1
			popup[c] = {
				name = profile.name,
				hint_title = T{302535920011305, "Profile: <name>", name = profile.name},
				hint = hint_str,
				mouseup = function(_, _, _, button)
					if button == "R" then
						table.remove(BuildingStates, i)
						ChoGGi.ComFuncs.MsgPopup(
							T{302535920011306, "Deleted Profile: <name>", name = profile.name},
							T(302535920011307, "Building States")
						)
					else
						ActivateProfile(profile)
						ChoGGi.ComFuncs.MsgPopup(
							T{302535920011308, "Activated Profile: <name>", name = profile.name},
							T(302535920011307, "Building States")
						)
					end
				end,
			}
		end
	end

	-- don't show menu if empty
	if c > 0 then
		ChoGGi.ComFuncs.PopupToggle(dlg,"idBuildingStatesMenuPopup_HUD",popup,"top")
	end
end

local function RemoveAllOfClass(profile, class)
	if profile and #profile > 0 then
		for i = #profile, 1, -1 do
			local state = profile[i]
			if state.obj.class == class then
				table.remove(profile, i)
			end
		end
	end
end

local function BuildRemoveFromList(dlg, obj)
	-- close tooltip
	if RolloverWin then
		XDestroyRolloverWindow()
	end

	table.iclear(popup)
	local c = 0

	-- build list of profiles
	local BuildingStates = g_ChoGGi_BuildingStates
	for i = #BuildingStates, 1, -1 do
		local profile = BuildingStates[i]
		-- remove any empty profiles since we're here
		if #profile == 0 then
			table.remove(BuildingStates, i)
		else
			local idx = table.find(profile,"handle",obj.handle)
			if idx then
				local class = profile[idx].obj.class
				c = c + 1
				popup[c] = {
					name = profile.name,
					hint_title = T{302535920011310, "Remove From: <name>", name = profile.name},
					hint = T{302535920011309, [[<left_click> Remove <name> from this profile.
<right_click> Remove all <class> from this profile.]], name = RetName(obj), class = class},
					mouseup = function(_, _, _, button)
						if button == "R" then
							RemoveAllOfClass(profile,class)
						else
							table.remove(profile, idx)
						end
					end,
				}
			end
		end
	end

	-- don't show menu if empty
	if c > 0 then
		ChoGGi.ComFuncs.PopupToggle(dlg, "idBuildingStatesMenuPopup_Remove", popup, "left")
	end
end

local function AddNewState(profile, obj)
	local building_state
	local idx = table.find(profile, "handle", obj.handle)
	-- exists so clear the state
	if idx then
		building_state = profile[idx]
		table.clear(building_state)
		building_state.handle = obj.handle
		building_state.obj = obj
	else
		-- newly added building state
		building_state = {
			handle = obj.handle,
			obj = obj,
		}
		profile[#profile+1] = building_state
	end
	return building_state
end

local function ShowList_AddTo(obj, profile_name)
	local working_str = Translate(11230, "Working")
	local priority_str = Translate(172, "Priority")
	local shifts_str = Translate(217, "Work Shifts")
	local enforce_spec_str = Translate(8746, "Workforce: Enforce Specialists")
	local shifts1_str = shifts_str .. ": 1"
	local shifts2_str = shifts_str .. ": 2"
	local shifts3_str = shifts_str .. ": 3"

	local obj_name = RetName(obj)

	local profilename_str = T(302535920011311, "Profile Name")
	local item_list = {
		{
			text = profilename_str,
			hint = T(302535920011312, "Type in a profile name to store this building state in."),
--~ 			value = T{302535920011305, "Profile: <name>", name = profile_name or obj_name},
			value = profile_name or obj_name,
		},
		{
			text = working_str,
			hint = T(302535920011313, "Enter <ChoGGi_green>true</ChoGGi_green> or <ChoGGi_red>false</ChoGGi_red> to have it turned on or off."),
			value = obj.ui_working,
		},
	}

	local c = #item_list

	local is_task_obj = obj:IsKindOf("TaskRequester")
	if is_task_obj then
		c = c + 1
		item_list[c] = {
			text = priority_str,
			hint = T(302535920011314, "Enter <ChoGGi_green>1</ChoGGi_green>, <ChoGGi_green>2</ChoGGi_green>, or <ChoGGi_green>3</ChoGGi_green> for different priority levels."),
			value = obj.priority,
		}
	else
		-- needed for checkmark vis
		is_task_obj = false
	end

	local boolean_hint_str = T(302535920011315, "Enter <ChoGGi_green>true</ChoGGi_green> or <ChoGGi_red>false</ChoGGi_red> to have it turned on or off.")

	local is_workplace_obj = obj:IsKindOf("Workplace")
	if is_workplace_obj then
		c = c + 1
		item_list[c] = {
			text = enforce_spec_str,
			hint = boolean_hint_str,
			value = obj.specialist_enforce_mode,
		}
	else
		is_workplace_obj = false
	end

	local is_shift_obj = obj:IsKindOf("ShiftsBuilding")
	if is_shift_obj then
		c = c + 1
		item_list[c] = {
			text = shifts1_str,
			hint = boolean_hint_str,
			value = not obj:IsClosedShift(1),
		}
		c = c + 1
		item_list[c] = {
			text = shifts2_str,
			hint = boolean_hint_str,
			value = not obj:IsClosedShift(2),
		}
		c = c + 1
		item_list[c] = {
			text = shifts3_str,
			hint = boolean_hint_str,
			value = not obj:IsClosedShift(3),
		}
	else
		is_shift_obj = false
	end

	local function CallBackFunc(choices)
		if choices.nothing_selected then
			return
		end
		-- don't even think about it
		if choices[1].value == "" then
			ChoGGi.ComFuncs.MsgPopup(
				T(302535920011316, "Error: Blank profile name!"),
				T(302535920011307, "Building States")
			)
			return
		end

		local working_chk = choices[1].check1
		local priority_chk = choices[1].check2
		local shifts_chk = choices[1].check3
		local enforce_spec_chk = choices[1].check3

		local profile, building_state
		local BuildingStates = g_ChoGGi_BuildingStates
		local profile_name = choices[1]
		-- add the profile and a blank building state (or find existing)
		if profile_name.text == profilename_str then
			local idx = table.find(BuildingStates, "name", profile_name.value)
			-- existing profile
			if idx then
				profile = BuildingStates[idx]
			else
				profile = {name = profile_name.value}
				BuildingStates[#BuildingStates+1] = profile
			end

			building_state = AddNewState(profile,obj)
		else
			local msg = Translate(302535920011317, "Error: list choice 1 should be the profile name!")
			print(msg, obj_name, obj.handle)
			ChoGGi.ComFuncs.MsgPopup(msg, T(302535920011307, "Building States"))
			return
		end

		-- If all of type then we use these below
		local working, priority, shift1, shift2, shift3, specialist_enforce_mode

		for i = 2, #choices do

			local choice = choices[i]
			local value = choice.value
			local value_type = type(value)
			local text = choice.text

			if text == working_str and working_chk and value_type == "boolean" then
				building_state.working = value
				working = value
			elseif text == priority_str and priority_chk and value_type == "number" and (value == 1 or value == 2 or value == 3) then
				building_state.priority = value
				priority = value
			elseif text == shifts1_str and shifts_chk and value_type == "boolean" then
				building_state.shift1 = value
				shift1 = value
			elseif text == shifts2_str and shifts_chk and value_type == "boolean" then
				building_state.shift2 = value
				shift2 = value
			elseif text == shifts3_str and shifts_chk and value_type == "boolean" then
				building_state.shift3 = value
				shift3 = value
			elseif text == enforce_spec_str and enforce_spec_chk and value_type == "boolean" then
				building_state.specialist_enforce_mode = value
				specialist_enforce_mode = value
			end
		end

		-- all of type checkbox
		if choices[1].check4 then
			local objs = UIColony.city_labels.labels[obj.class] or ""
			for i = 1, #objs do
				building_state = AddNewState(profile, objs[i])
				-- add settings from above
				building_state.working = working
				building_state.priority = priority
				building_state.shift1 = shift1
				building_state.shift2 = shift2
				building_state.shift3 = shift3
				building_state.specialist_enforce_mode = specialist_enforce_mode
			end
		end

	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T{302535920011318, "Add <name> to building profile", name = obj_name},
		hint = T(302535920011319, "If this object already exists in the profile then the profile values will be reset before adding new values."),
		custom_type = 4,
		skip_sort = true,
		width = 600,
		checkboxes = {
			{
				title = Translate(11230, "Working"),
				hint = T(302535920011320, "Uncheck to exclude this setting from profile."),
				checked = true,
			},
			{
				title = Translate(172, "Priority"),
				hint = T(302535920011320, "Uncheck to exclude this setting from profile."),
				checked = is_task_obj,
				visible = is_task_obj,
			},
			{
				title = Translate(217, "Work Shifts"),
				hint = T(302535920011320, "Uncheck to exclude this setting from profile."),
				checked = is_shift_obj,
				visible = is_shift_obj,
			},
			{
				title = T(302535920011321, "Enforce Spec"),
				hint = T(302535920011320, "Uncheck to exclude this setting from profile."),
				checked = is_workplace_obj,
				visible = is_workplace_obj,
			},
			{
				title = T(302535920011322, "Add All"),
				hint = T{302535920011323,
					"Add all buildings of the same type (<class>) to this profile using these settings.",
					class = obj.class
				},
				level = 2,
			},
		},
	}
end

local function BuildAddToList(dlg, obj)
	-- close tooltip
	if RolloverWin then
		XDestroyRolloverWindow()
	end

	local obj_name = RetName(obj)

	-- build list of profiles
	table.iclear(popup)
	popup[1] = {
		name = T(302535920011325, "New Profile"),
		hint_title = T(302535920011325, "New Profile"),
		hint = T{302535920011324, "Add <name> to a new profile.", name = obj_name},
		clicked = function()
			ShowList_AddTo(obj)
		end,
	}
	local c = #popup

	-- build list of profiles
	local BuildingStates = g_ChoGGi_BuildingStates
	for i = #BuildingStates, 1, -1 do
		local profile = BuildingStates[i]
		-- remove any empty profiles since we're here
		if #profile == 0 then
			table.remove(BuildingStates, i)
		else
			c = c + 1
			popup[c] = {
				name = profile.name,
				hint_title = T{302535920011327, "Add To Profile: <name>", name = profile.name},
				hint = T{302535920011326,
					"Add <name> state to <profile> profile.",
					name = obj_name, profile = profile.name
				},
				clicked = function()
					ShowList_AddTo(obj, profile.name)
				end,
			}
		end
	end

	ChoGGi.ComFuncs.PopupToggle(dlg, "idBuildingStatesMenuPopup_Add", popup, "left")
end

local cls_skip = {"RocketBase", "ExplorableObject", "UniversalStorageDepot"}
function OnMsg.ClassesPostprocess()
	-- hud button
	local xt = ChoGGi.ComFuncs.RetHudButton("idRight")
	if xt then
		ChoGGi.ComFuncs.RemoveXTemplateSections(xt,"ChoGGi_Template_BuildingStates")
		table.insert(xt,#xt,PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_BuildingStates", true,
			"Id", "idMinimap",
			"__template", "HUDButtonTemplate",
			"RolloverText", T(302535920011328, [[Show list of building state profiles.]]),
			"RolloverTitle", T(302535920011307, "Building States"),
			"Image", CurrentModPath .. "UI/buildingstates.png",
			"FXPress", "MainMenuButtonClick",
			"OnPress", HUD.idBuildingStatesOnPress,
		}))
	end

	-- building menus
	xt = XTemplates.ipBuilding[1][1]
	-- check for and remove existing template
	local idx = table.find(xt, "ChoGGi_Template_BuildingStates", true)
	if idx then
		xt[idx]:delete()
		-- we need to remove for insert
		table.remove(xt, idx)
	else
		-- Insert above consumption
		idx = table.find(xt, "__template", "sectionConsumption")
	end

	if type(idx) ~= "number" then
		idx = #(xt or "")
	end

	table.insert(
		xt,
		idx,

		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_BuildingStates", true,
			"Id", "ChoGGi_BuildingStates",
			"__context_of_kind", "Building",
			"__condition", function(_, context)
				return not context:IsKindOfClasses(cls_skip)
			end,
			"__template", "InfopanelSection",
			"Icon", "UI/Icons/Sections/dome.tga",
		}, {

			-- add to profile
			PlaceObj('XTemplateTemplate', {
				"__template", "InfopanelActiveSection",
				"Icon", "UI/Icons/Sections/resource_accept.tga",
				"Title", T(302535920011329, [[Add to Profile]]),
				"RolloverText", T(302535920011330, [[<left_click> Add this building state to a profile.]]),
			}, {
				PlaceObj("XTemplateFunc", {
					"name", "OnActivate(self, context)",
					"parent", function(self)
						return self.parent
					end,
					"func", BuildAddToList,
				}),
			}),

			-- remove
			PlaceObj('XTemplateTemplate', {
				"__template", "InfopanelActiveSection",
				"Icon", "UI/Icons/Sections/resource_no_accept.tga",
				"Title", T(302535920011331, [[Remove from Profile]]),
				"RolloverText", T(302535920011332, [[<left_click> Remove this building from a profile.]]),
			}, {
				PlaceObj("XTemplateFunc", {
					"name", "OnActivate(self, context)",
					"parent", function(self)
						return self.parent
					end,
					"func", BuildRemoveFromList,
				}),
			}),

		})
	)

end
