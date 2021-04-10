
-- See LICENSE for terms

local tostring, type, table, tonumber = tostring, type, table, tonumber
local table_find = table.find

local RetMapSettings = ChoGGi.ComFuncs.RetMapSettings
local RetMapBreakthroughs = ChoGGi.ComFuncs.RetMapBreakthroughs
local Translate = ChoGGi.ComFuncs.Translate
local ValidateImage = ChoGGi.ComFuncs.ValidateImage
local RetName = ChoGGi.ComFuncs.RetName
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin
local TableConcat = ChoGGi.ComFuncs.TableConcat
local IsShiftPressed = ChoGGi.ComFuncs.IsShiftPressed

local Strings = ChoGGi.Strings

local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/"

local dlg_locations
local map_data
local landsiteobj

local function ShowDialogs()
	-- we only need to build once, not as if it'll change anytime soon (save as csv?, see if it's shorter to load)
	if not map_data then
		map_data = ChoGGi.ComFuncs.ExportMapDataToCSV(XAction:new{setting_breakthroughs = true, setting_skip_csv = true})
	end
--~ 	map_data = {}

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

local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_VLI_MapInfoDlg")
end
DefineClass.ChoGGi_VLI_MapInfoDlg = {
	__parents = {"ChoGGi_XWindow"},
--~ 	obj = false,
	obj_name = false,
	dialog_width = 700.0,
	dialog_height = 89.0,

	-- actual amount of boxes
	input_box_count = 0,
	-- boxes with text
	input_box_count2 = 0,
	input_boxs = false,
	found_objs = false,
	-- use it to set titles
	current_examine_dlg = false,
}

function ChoGGi_VLI_MapInfoDlg:Init(parent, context)
	local g_Classes = g_Classes

	self.title = T(7396, "Location")
	self.title_image = "CommonAssets/UI/Menu/EV_OpenFirst.tga"
	self.title_image_single = true

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idButtonContainer = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idButtonContainer",
		Dock = "top",
		Margins = box(0, 8, 0, 0),
	}, self.idDialog)

	self.idSearch = g_Classes.ChoGGi_XButton:new({
		Id = "idSearch",
		Dock = "left",
		Text = T(10123, "Search"),
		Background = g_Classes.ChoGGi_XButton.bg_green,
		RolloverText = Strings[302535920001303--[[Search for text within %s.
Leave blank to skip search box.]]]:format(Translate(self.title)),
		Margins = box(6, 0, 0, 0),
		OnPress = self.FindText,
	}, self.idButtonContainer)

	self.idAddOne = g_Classes.ChoGGi_XButton:new({
		Id = "idAddOne",
		Dock = "left",
		Text = T(302535920011918, "Add Input"),
		RolloverText = T(302535920011919, "Add another text input field to use (leave input blank to ignore)."),
		Margins = box(6, 0, 0, 0),
		OnPress = self.AddSearchBox,
	}, self.idButtonContainer)

	self.idAndOr = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idAndOr",
		Dock = "left",
		Margins = box(15, 0, 0, 0),
		Text = T(302535920011920, "And / Or"),
		RolloverText = T(302535920011921, "If you don't know what this means, then leave it checked (And)."),
	}, self.idButtonContainer)
	self.idAndOr:SetCheckBox(true)

	self.idReuseResults = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idReuseResults",
		Dock = "left",
		Margins = box(15, 0, 0, 0),
		Text = T(302535920011922, "Reuse Results"),
		RolloverText = T(302535920011923, "Open all results in the same dialog."),
	}, self.idButtonContainer)
	self.idReuseResults:SetCheckBox(true)

	self.idCancel = g_Classes.ChoGGi_XButton:new({
		Id = "idCancel",
		Dock = "right",
		MinWidth = 80,
		Text = Translate(6879--[[Cancel]]),
		Background = g_Classes.ChoGGi_XButton.bg_red,
		RolloverText = Strings[302535920000074--[[Cancel without changing anything.]]],
		Margins = box(0, 0, 10, 0),
		OnPress = self.idCloseX.OnPress,
	}, self.idButtonContainer)

	self.idTextArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idTextArea",
		Dock = "bottom",
		LayoutMethod = "VList",
	}, self.idDialog)

	-- add one search box by default
	self.input_boxs = {}
	self:AddSearchBox()

	self.idSearch1:SetFocus()

	self:PostInit()
end

function ChoGGi_VLI_MapInfoDlg:AddSearchBox()
	self = GetRootDialog(self)

	self.input_box_count = self.input_box_count + 1
	local id = "idSearch" .. self.input_box_count

	self[id] = ChoGGi_XTextInput:new({
		Id = id,
		MinWidth = 600,
		RolloverText = Strings[302535920001303--[[Search for text within %s.
Leave blank to skip search box.]]]:format(Translate(self.title)),
		Hint = Strings[302535920001306--[[Enter text to find]]],
		OnKbdKeyDown = self.Input_OnKbdKeyDown,
	}, self.idTextArea)

	self:SetHeight(self:GetHeight() + 21)
end


function ChoGGi_VLI_MapInfoDlg:FindText()
	self = GetRootDialog(self)

	-- always start off empty
	self.found_objs = {}

	local reuse = self.idReuseResults:GetCheck()

	if not reuse or reuse and not IsValidXWin(self.current_examine_dlg) then

		self.current_examine_dlg = ChoGGi.ComFuncs.OpenInExamineDlg(self.found_objs, {
			has_params = true,
			dialog_marker = "ChoGGi_VLI_MapInfoDlg_Examine",
			tooltip_info = function(obj)
				return image_str .. obj.map_name .. ".png"
			end,
			exec_tables = function(obj)
				local key_location = self:RetMapLocation(obj, true)
				local result, lat, long = landsiteobj:ConvertStrLocationToCoords(key_location)
				if result then
					landsiteobj:MoveToSelection(lat, long, nil, true)
					landsiteobj:CalcMarkersVisibility()
				else
					CreateMarsMessageBox(T(6885, "Error"), T(4093, "Invalid coordinates.") .. ": " .. key_location, T(1000136, "OK"))
				end
			end,
		})
	end

	-- get strings from input box(s)
	self.input_box_count2 = 0
	for i = 1, self.input_box_count do
		local str = self["idSearch" .. i]:GetText()
		-- no need to search blank ones
		if str ~= "" and str ~= " " then
			self.input_box_count2 = self.input_box_count2 + 1
			self.input_boxs[self.input_box_count2] = str:lower()
		end
	end

	-- build our list of objs
	self:UpdateFoundObjects()

	-- should do this nicer, but whatever
	CreateRealTimeThread(function()
		Sleep(10)
		self.current_examine_dlg:SetPos(self:GetPos()+point(0, self.idDialog.box:sizey() + 25))
		if reuse and IsValidXWin(self.current_examine_dlg) then
			self.current_examine_dlg.obj = self.found_objs
			self.current_examine_dlg:SetObj()
			self:SetExamineTitle()
		end

	end)
end

local joined = {"", ""}
function ChoGGi_VLI_MapInfoDlg:FindObject(key_name, value_name)
	for i = 1, self.input_box_count2 do
		local str = self.input_boxs[i]
		-- :find(str, 1, true) (1, true means don't use lua patterns, just plain text)
		if key_name:find(str, 1, true) then
			return key_name
		elseif value_name:find(str, 1, true) then
			return value_name
		elseif key_name .. value_name == str then
			return str
--~ 		else
--~ 			joined[1] = key_name
--~ 			joined[2] = value_name
--~ 			if TableConcat(joined) == str then
--~ 				return str
--~ 			end
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
	return TableConcat(loc_key)
end

function ChoGGi_VLI_MapInfoDlg:SetExamineTitle()
	local title = "(" .. table.count(self.found_objs) .. ") " .. TableConcat(self.input_boxs, " ")
	self.current_examine_dlg.override_title = true
	self.current_examine_dlg.idCaption:SetTitle(self.current_examine_dlg, title)
end

function ChoGGi_VLI_MapInfoDlg:UpdateFoundObjects()

	local andor = self.idAndOr:GetCheck()
	local matches = {}
	-- loopy time
	for i = 1, #map_data do
		local map = map_data[i]

		table.clear(matches)
		local key_location = self:RetMapLocation(map)

		for key, value in pairs(map) do
			local key_name, value_name = tostring(key):lower(), tostring(value):lower()
			if not self.found_objs[key_location] then
				-- true is "and"
				if andor then
					local match = self:FindObject(key_name, value_name)
					if match then
						matches[match] = true
					end
				else
					if self:FindObject(key_name, value_name) then
						self.found_objs[key_location] = map
					end
				end
			end

		end
		-- check if all strings were matched and add if so
		if andor then
			local found_count = 0
			for str in pairs(matches) do
				found_count = found_count + 1
			end
			-- found is same as inputs with text
			if found_count == self.input_box_count2 then
				self.found_objs[key_location] = map
			end
		end

	end

	self:SetExamineTitle()
end

local const = const
function ChoGGi_VLI_MapInfoDlg:Input_OnKbdKeyDown(vk)
	local old_self = self
	self = GetRootDialog(self)
	if vk == const.vkEnter then
		self:FindText()
		return "break"
	elseif vk == const.vkTab then
		if self.input_box_count == 1 then
			return "break"
		end

		local current_idx = tonumber(old_self.Id:sub(9))

		local is_shift = IsShiftPressed()

		-- tab to go down, shift-tab to go up
		if not is_shift and current_idx >= self.input_box_count then
			current_idx = 1
		elseif is_shift and current_idx == 1 then
			current_idx = self.input_box_count
		elseif is_shift then
			current_idx = current_idx - 1
		else
			current_idx = current_idx + 1
		end

		self["idSearch" .. current_idx]:SetFocus()

		return "break"
	end

	return g_Classes.ChoGGi_XTextInput.OnKbdKeyDown(old_self, vk)
end


-- fired when we go to first new game section
local function AddProfilesButton(toolbar)
	if toolbar.idChoGGi_FindMaps then
		return
	end

	toolbar.idChoGGi_FindMaps = ChoGGi.ComFuncs.RetToolbarButton{
		parent = toolbar,
		id = "idChoGGi_FindMaps",
		roll_title = T(126095410863, "Info"),
		text = T(302535920011924, "Find Maps"),
		roll_text = T(302535920011925, [[Find maps with specific breakthroughs etc.

<color ChoGGi_red>Warning!</color> This will take some time to load the map info (10-15 seconds).]]),
		onpress = function()
			ShowDialogs()
		end,
	}

end

-- add settings button
local orig_SetPlanetCamera = SetPlanetCamera
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
					local orig_RebuildActions = toolbar.RebuildActions
					toolbar.RebuildActions = function(self, context, ...)
						orig_RebuildActions(self, context, ...)
						if table.find(toolbar, "Id", "idrandom") then
							AddProfilesButton(toolbar)
						end
					end
				end
			end
		end)
	end
	return orig_SetPlanetCamera(planet, state, ...)
end
