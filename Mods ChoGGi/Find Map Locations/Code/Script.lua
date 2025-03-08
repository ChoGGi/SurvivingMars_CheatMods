-- See LICENSE for terms

if ChoGGi.testing then
	-- Add a slight delay to show up in main menu
	CreateRealTimeThread(function()
		print("VLI")
	end)
end

local pairs, tostring, type, table, tonumber = pairs, tostring, type, table, tonumber
-- every litte bit helps
local table_concat = table.concat
local table_remove = table.remove

local Translate = ChoGGi_Funcs.Common.Translate
local IsValidXWin = ChoGGi_Funcs.Common.IsValidXWin
local IsShiftPressed = ChoGGi_Funcs.Common.IsShiftPressed

local mod_BreakthroughCount

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_BreakthroughCount = CurrentModOptions:GetProperty("BreakthroughCount")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/"

local dlg_locations
local map_data
local map_data_prev_results
local landsiteobj

local function ShowDialogs()
--~ ChoGGi_Funcs.Common.TickStart("Tick.1")

	-- we only need to build once, not as if it'll change anytime soon (save as csv?, see if it's shorter to load.... nope)
	if not map_data then

		-- Bump count for paradox
		local count = mod_BreakthroughCount
		if g_CurrentMissionParams.idMissionSponsor == "paradox" then
			count = count + 2
		end

		map_data = ChoGGi_Funcs.Common.ExportMapDataToCSV(XAction:new{
			setting_breakthroughs = true,
			setting_limit_count = count,
			setting_skip_csv = true,
		})

		local map_info = ChoGGi_VLI_MapInfoDlg.RetMapLocation
		for i = 1, #map_data do
			local data = map_data[i]

			-- change all strings to lowercase here instead of while searching
			data.coordinates = map_info(nil, data, true):lower()

			for j = 1, #data do
				data[j] = data[j]:lower()
			end

			-- only these three have case
			if data.landing_spot then
				data.landing_spot = data.landing_spot:lower()
			end
			data.map_name = data.map_name:lower()
			data.topography = data.topography:lower()
		end

	end
--~ ChoGGi_Funcs.Common.TickEnd("Tick.1")
	if ChoGGi.testing then
		vli = ShowDialogs
		local testing_ex = OpenExamineReturn(map_data, {
			has_params = true,
			title = "tester list",
		})
		CreateRealTimeThread(function()
			Sleep(10)
			testing_ex:SetPos(
				testing_ex:GetPos() + point(-50, 150)
			)
		end)

	end

	-- check if we already created finder, and make one if not
	if not IsValidXWin(dlg_locations) then
		dlg_locations = ChoGGi_VLI_MapInfoDlg:new({}, terminal.desktop, {})
	end
end

if ChoGGi.testing then
	vli = ShowDialogs
end

-- kill off image dialogs
function OnMsg.ChangeMapDone()
-- keep dialog opened after
--~ 	do return end

	local dlgs = terminal.desktop
	for i = #dlgs, 1, -1 do
		local dlg = dlgs[i]
		if dlg:IsKindOf("ChoGGi_VLI_MapInfoDlg")
			or dlg.dialog_marker == "ChoGGi_VLI_MapInfoDlg_Examine"
		then
			dlg:Close()
		end
	end
end

local GetParentOfKind = ChoGGi_Funcs.Common.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_VLI_MapInfoDlg")
end
DefineClass.ChoGGi_VLI_MapInfoDlg = {
	__parents = {"ChoGGi_XWindow"},
--~ 	obj = false,
	obj_name = false,
	dialog_width = 780.0,
	dialog_height = 140.0,

	-- actual amount of boxes
	input_box_count_add = 0,
	input_box_count_rem = 0,
	-- ones with text
	input_box_count_add2 = 0,
	input_box_count_rem2 = 0,
	-- boxes with text
	input_boxs_add = false,
	input_boxs_rem = false,
	found_objs = false,
	-- store dlg to set title
	current_examine_dlg = false,
}

function ChoGGi_VLI_MapInfoDlg:Init(parent, context)
	local g_Classes = g_Classes

	self.title = T(0000, "Find Map Locations")
	self.title_image = "CommonAssets/UI/Menu/EV_OpenFirst.tga"
	self.title_image_single = true

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idTopArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idTopArea",
		Dock = "top",
		Margins = box(0, 8, 0, 8),
	}, self.idDialog)

	self.idSearch = g_Classes.ChoGGi_XButton:new({
		Id = "idSearch",
		Dock = "left",
		Text = T(10123--[[Search]]),
		Background = g_Classes.ChoGGi_XButton.bg_green,
		RolloverText = T{302535920001303--[["Search for text within <color ChoGGi_green><str></color>."]],
			str = Translate(self.title),
		} .. T(0000, "\nLeave blank to skip search box."),
		Margins = box(6, 0, 0, 0),
		OnPress = self.FindText,
	}, self.idTopArea)

	self.idShowInfo = g_Classes.ChoGGi_XButton:new({
		Id = "idShowInfo",
		Dock = "left",
		Text = T(126095410863--[[Info]]),
		RolloverText = T(302535920011927, "Show a list of breakthroughs/map names/etc to use."),
		Margins = box(6, 0, 0, 0),
		OnPress = self.ShowInfoDialog,
	}, self.idTopArea)

	self.idAndOr = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idAndOr",
		Dock = "left",
		Margins = box(10, 0, 0, 0),
		Text = T(302535920011920, "And / Or"),
		RolloverText = T(302535920011921, "If you don't know what this means, then leave it checked (And)."),
	}, self.idTopArea)
	self.idAndOr:SetCheckBox(true)

	self.idSameDialog = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idSameDialog",
		Dock = "left",
		Margins = box(10, 0, 0, 0),
		Text = T(302535920011922, "Reuse Dialog"),
		RolloverText = T(302535920011923, "Open all results in the same dialog."),
	}, self.idTopArea)
	self.idSameDialog:SetCheckBox(true)

	self.idReuseResults = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idReuseResults",
		Dock = "right",
		Margins = box(10, 0, 0, 0),
		Text = T(0000, "Reuse Results"),
		RolloverText = T(0000, "Use previous search results instead of full map data."),
	}, self.idTopArea)
	self.idReuseResults:SetCheckBox(true)

	self.idClearSaved = g_Classes.ChoGGi_XButton:new({
		Id = "idClearSaved",
		Dock = "right",
		Text = T(0000, "Clear Saved"),
		Background = g_Classes.ChoGGi_XButton.bg_red,
		RolloverText = T(0000, "If you want to start a new search instead of searching previous results."),
		Margins = box(6, 0, 0, 0),
		OnPress = function()
			map_data_prev_results = nil
		end,
	}, self.idTopArea)

	-- inputs and ignores
	self.idSearchArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idSearchArea",
	}, self.idDialog)

	-- inputs
	self.idInputButtonArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idInputButtonArea",
		Dock = "top",
	}, self.idSearchArea)

	self.idInputArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idInputArea",
		Dock = "top",
	}, self.idSearchArea)

	self.idAddOne = g_Classes.ChoGGi_XButton:new({
		Id = "idAddOne",
		Dock = "left",
		Text = T(302535920011918, "+ Input"),
		RolloverText = T(302535920011919, "Add another text input field to use (leave input blank to ignore)."),
		Margins = box(6, 0, 0, 0),
		OnPress = function()
			self:AddSearchBox("add")
		end,
	}, self.idInputButtonArea)

	self.idAddTextArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idAddTextArea",
		Dock = "bottom",
		LayoutMethod = "VList",
		Margins = box(10, 0, 0, 0),
	}, self.idInputArea)

	-- ignores
	self.idIgnoreButtonArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idIgnoreButtonArea",
		Dock = "top",
		Margins = box(0, 4, 0, 0),
	}, self.idSearchArea)

	self.idIgnoreArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idIgnoreArea",
		Dock = "top",
	}, self.idSearchArea)

	self.idRemOne = g_Classes.ChoGGi_XButton:new({
		Id = "idRemOne",
		Dock = "left",
		Text = T(302535920011928, "+ Ignore"),
		RolloverText = T(302535920011929, "Add another text input field to use to ignore text (leave input blank to ignore)."),
		Margins = box(6, 0, 0, 0),
		OnPress = function()
			self:AddSearchBox("rem")
		end,
	}, self.idIgnoreButtonArea)

	self.idRemTextArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idRemTextArea",
		Dock = "bottom",
		LayoutMethod = "VList",
		Margins = box(8, 0, 0, 8),
	}, self.idIgnoreArea)

	-- add one search box by default
	self.input_boxs_add = {}
	self.input_boxs_rem	= {}
	self:AddSearchBox("add")
	self:AddSearchBox("rem")

	self.idSearch1:SetFocus()

	self:PostInit()
end

function ChoGGi_VLI_MapInfoDlg:ShowInfoDialog()
	local text = {}
	local temp_data = {}
	local c = 0

	-- Add breakthroughs
	local breaks = Presets.TechPreset.Breakthroughs
	for i = 1, #breaks do
		temp_data[i] = Translate(breaks[i].display_name)
	end
	c = #breaks
	table.sort(temp_data)
	c = c + 1
	temp_data[c] = "\n"
	table.iappend(text, temp_data)

	-- Map names
	temp_data = {}
	c = 0
	local MapDataPresets = MapDataPresets
	for id, data in pairs(MapDataPresets) do
		if data.IsRandomMap then
			c = c + 1
			temp_data[c] = id
		end
	end
	table.sort(temp_data)
	c = c + 1
	temp_data[c] = "\n"
	table.iappend(text, temp_data)

	-- Named locations
	temp_data = {}
	c = 0
	local MarsLocales = MarsLocales
	for _, location in pairs(MarsLocales) do
		c = c + 1
		temp_data[c] = Translate(location)
	end
	table.sort(temp_data)
	table.iappend(text, temp_data)

	ChoGGi_Funcs.Common.OpenInMultiLineTextDlg(table_concat(text, "\n"), {
		has_params = true,
		title = T(302535920011926, "Show Info"),
	})
end

function ChoGGi_VLI_MapInfoDlg:AddSearchBox(input_type)
	self = GetRootDialog(self)

	local area, count, id, str_roll, str_hint
	if input_type == "add" then
		area = "idAddTextArea"
		count = "input_box_count_add"
		id = "idSearch"
		str_roll = T(302535920011932, [[Search for text in map data.
Leave blank to skip search box.]])
		str_hint = TranslationTable[302535920001306--[[Enter text to find]]]
	elseif input_type == "rem" then
		area = "idRemTextArea"
		count = "input_box_count_rem"
		id = "idSearchRem"
		str_roll = T(302535920011930, [[Search for text to remove from the results (overrides search text).
Leave blank to skip search box.]])
		str_hint = Translate(302535920011931, [[Enter text to ignore]])
	end

	-- add hint if random rule active
	local tech, chaos = IsGameRuleActive("TechVariety"), IsGameRuleActive("ChaosTheory")
	if tech or chaos then
		str_hint = str_hint .. "    " .. Translate(T{[[<rule> detected! Invalid breakthrough list!]],
			rule = tech and T(607602869305--[[Tech Variety]]) or T(621834127153--[[Chaos Theory]]),
		})
	end

	self[count] = self[count] + 1
	id = id .. self[count]

	self[id] = ChoGGi_XTextInput:new({
		Id = id,
--~ 		MinWidth = 600,
		RolloverText = str_roll,
		Hint = str_hint,
		OnKbdKeyDown = function(self_input, vk, ...)
			self.idSearchInput_OnKbdKeyDown(self_input, vk, input_type, ...)
		end,
	}, self[area])

	self:SetHeight(self:GetHeight() + 21)
end

function ChoGGi_VLI_MapInfoDlg:FindText()
	self = GetRootDialog(self)

	-- always start off empty
	self.found_objs = {}

	local reuse = self.idSameDialog:GetCheck()

	if not reuse or reuse and not IsValidXWin(self.current_examine_dlg) then

		self.current_examine_dlg = OpenExamineReturn(self.found_objs, {
			has_params = true,
			dialog_marker = "ChoGGi_VLI_MapInfoDlg_Examine",
			tooltip_info = function(obj)
				return image_str .. obj.map_name .. ".png"
			end,
			exec_tables = function(obj)
				-- When I open it from main menu for testing
				if not landsiteobj then
					return
				end
				local key_location = self:RetMapLocation(obj, true)
				local result, lat, long = landsiteobj:ConvertStrLocationToCoords(key_location)
				if result then
					landsiteobj:MoveToSelection(lat, long, nil, true)
					landsiteobj:CalcMarkersVisibility()
				else
					CreateMarsMessageBox(T(6885--[[Error]]), T(4093--[[Invalid coordinates.]]) .. ": " .. key_location, T(1000136--[[OK]]))
				end
			end,
		})
	end

	-- get strings from input box(s)
	self.input_box_count_add2 = 0
	for i = 1, self.input_box_count_add do
		local str = self["idSearch" .. i]:GetText()
		-- no need to search blank ones
		if str ~= "" and str ~= " " then
			self.input_box_count_add2 = self.input_box_count_add2 + 1
			self.input_boxs_add[self.input_box_count_add2] = str:lower()
		end
	end

	-- get strings from input box(s)
	self.input_box_count_rem2 = 0
	for i = 1, self.input_box_count_rem do
		local str = self["idSearchRem" .. i]:GetText()
		-- no need to search blank ones
		if str ~= "" and str ~= " " then
			self.input_box_count_rem2 = self.input_box_count_rem2 + 1
			self.input_boxs_rem[self.input_box_count_rem2] = str:lower()
		end
	end

	-- build our list of objs
	self:UpdateFoundObjects()

	-- should do this nicer, but whatever
	CreateRealTimeThread(function()
		Sleep(10)
		self.current_examine_dlg:SetPos(
			self:GetPos() + point(0, self.idDialog.box:sizey())
		)
		if reuse and IsValidXWin(self.current_examine_dlg) then
			self.current_examine_dlg.obj = self.found_objs
			self.current_examine_dlg:SetObj()
			self:SetExamineTitle()
		end
	end)

	-- if reuse is checked then flash it
	if self.idReuseResults.IconRow == 2 then
		XFlashWindow(self.idReuseResults)
	end
end

function ChoGGi_VLI_MapInfoDlg:FindObject(key_name, value_name, rem)
	local count = rem and self.input_box_count_rem2 or self.input_box_count_add2
	local input = rem and "input_boxs_rem" or "input_boxs_add"

	for i = 1, count do
		local str = self[input][i]
		if key_name .. value_name == str then
			return str
		-- :find(str, 1, true) (1, true means don't use lua patterns, just plain text)
		elseif key_name:find(str, 1, true) then
			return key_name
		elseif value_name:find(str, 1, true) then
			return value_name
		end
	end
end

local loc_key = {"","","","",""}
function ChoGGi_VLI_MapInfoDlg:RetMapLocation(map, merged)
	if merged then
		loc_key[1] = map.latitude_degree
		loc_key[2] = map.latitude
		loc_key[3] = map.longitude_degree
		loc_key[4] = map.longitude
		loc_key[5] = ""
	else
		loc_key[1] = map.latitude_degree
		loc_key[2] = map.latitude
		loc_key[3] = " "
		loc_key[4] = map.longitude_degree
		loc_key[5] = map.longitude
	end
	return table_concat(loc_key)
end

function ChoGGi_VLI_MapInfoDlg:SetExamineTitle()
	local title = T(3732--[[Count]]) .. " " .. table.count(self.found_objs) .. ": + "
		.. table_concat(self.input_boxs_add, " ") .. ", - " .. table_concat(self.input_boxs_rem, " ")

	self.current_examine_dlg.override_title = true
	self.current_examine_dlg.idCaption:SetTitle(self.current_examine_dlg, title)
end

function ChoGGi_VLI_MapInfoDlg:UpdateFoundObjects()

	local andor = self.idAndOr:GetCheck()
	local matches = {}

	local search_data = map_data
	-- Use saved search data
	if self.idReuseResults:GetCheck() then
		search_data = map_data_prev_results or map_data
	end

	local search_data_temp = {}
	local c = 0

	-- loopy time
	for i = 1, #search_data do
		local map = search_data[i]

		local remove_found
		table.clear(matches)
		local key_location = self:RetMapLocation(map)

		for key, value in pairs(map) do
			local key_name, value_name = tostring(key), tostring(value)

			-- always check for removes first
			if self:FindObject(key_name, value_name, true) then
				remove_found = true
			elseif not self.found_objs[key_location] then

				-- true is "and"
				if andor then
					local match = self:FindObject(key_name, value_name)
					if match then
						matches[match] = true
					end
				-- "or"
				else
					if self:FindObject(key_name, value_name) then
						self.found_objs[key_location] = map
						-- prev search data
						c = c + 1
						search_data_temp[c] = map
					end
				end
				--

			end
		end

		-- check if all strings were matched and add if so
		if remove_found then
			self.found_objs[key_location] = nil
		elseif andor then
			local found_count = 0
			for _ in pairs(matches) do
				found_count = found_count + 1
			end
			if found_count >= self.input_box_count_add2 or self.input_box_count_add2 == 1 and found_count > 0 then
				self.found_objs[key_location] = map
				-- prev search data
				c = c + 1
				search_data_temp[c] = map
			end
		end

	end

	-- Use for next search
	map_data_prev_results = search_data_temp

	-- done looping so set title
	self:SetExamineTitle()
end

function ChoGGi_VLI_MapInfoDlg:idSearchInput_OnKbdKeyDown(vk, input_type)
	local old_self = self
	self = GetRootDialog(self)

	local count, id, length
	if input_type == "add" then
		count = "input_box_count_add"
		id = "idSearch"
		length = 9
	elseif input_type == "rem" then
		count = "input_box_count_rem"
		id = "idSearchRem"
		length = 12
	end

	if vk == const.vkEnter then
		self:FindText()
		return "break"
	elseif vk == const.vkTab then
		if self[count] == 1 then
			return "break"
		end

		local current_idx = tonumber(old_self.Id:sub(length))

		local is_shift = IsShiftPressed()

		-- tab to go down, shift-tab to go up
		if not is_shift and current_idx >= self[count] then
			current_idx = 1
		elseif is_shift and current_idx == 1 then
			current_idx = self[count]
		elseif is_shift then
			current_idx = current_idx - 1
		else
			current_idx = current_idx + 1
		end

		self[id .. current_idx]:SetFocus()

		return "break"
	end

	return ChoGGi_XTextInput.OnKbdKeyDown(old_self, vk)
end

-- fired when we go to first new game section
local function AddProfilesButton(toolbar)
	if toolbar.idChoGGi_FindMaps then
		return
	end

	toolbar.idChoGGi_FindMaps = ChoGGi_Funcs.Common.RetToolbarButton{
		parent = toolbar,
		id = "idChoGGi_FindMaps",
		roll_title = T(126095410863--[[Info]]),
		text = T(302535920011924, "Find Maps"),
		roll_text = T(302535920011925, [[Find maps with specific breakthroughs etc.

<color ChoGGi_red>Warning!</color> This will take some time to load the map info (10-15 seconds).]]),
		onpress = function()
			ShowDialogs()
		end,
	}

end

-- add settings button
local ChoOrig_SetPlanetCamera = SetPlanetCamera
function SetPlanetCamera(planet, state, ...)
	-- fire only in mission setup menu
	if not state then
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			if Dialogs.PGMainMenu and Dialogs.PGMainMenu.idContent then
				local pgmission = Dialogs.PGMainMenu.idContent.PGMission
				if type(pgmission) == "table" then
					local items_dlg = pgmission[1][1]
					landsiteobj = items_dlg.context
					local toolbar = items_dlg.idToolBar
					if table.find(toolbar, "Id", "idrandom") then
						AddProfilesButton(toolbar)
					end
					-- hook into toolbar button area so we can keep adding the button
					local ChoOrig_RebuildActions = toolbar.RebuildActions
					toolbar.RebuildActions = function(self, context, ...)
						ChoOrig_RebuildActions(self, context, ...)
						if table.find(toolbar, "Id", "idrandom") then
							AddProfilesButton(toolbar)
						end
					end
				end
			end
		end)
	end
	return ChoOrig_SetPlanetCamera(planet, state, ...)
end
