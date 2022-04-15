-- See LICENSE for terms

-- Search through tables for values and display them in an examine dialog

local pairs, type = pairs, type

local TranslationTable = TranslationTable
local RetName = ChoGGi.ComFuncs.RetName
local FindThreadFunc = ChoGGi.ComFuncs.FindThreadFunc
local RetParamsParents = ChoGGi.ComFuncs.RetParamsParents

local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_DlgFindValue")
end
DefineClass.ChoGGi_DlgFindValue = {
	__parents = {"ChoGGi_XWindow"},
	obj = false,
	obj_name = false,
	dialog_width = 700.0,
	dialog_height = 110.0,

	found_objs = false,
	dupe_objs = {},
}

function ChoGGi_DlgFindValue:Init(parent, context)
	local g_Classes = g_Classes

	self.obj = context.obj
	self.obj_name = RetName(self.obj)
	self.title = TranslationTable[302535920001305--[[Find Within]]] .. ": " .. self.obj_name
	self.title_image = "CommonAssets/UI/Menu/EV_OpenFirst.tga"
	self.title_image_single = true

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idTextArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idTextArea",
		Dock = "top",
	}, self.idDialog)

	self.idEdit = g_Classes.ChoGGi_XTextInput:new({
		Id = "idEdit",
		Dock = "left",
		MinWidth = 550,
		RolloverText = TranslationTable[302535920001303--[[Search for text within %s.]]]:format(self.obj_name),
		Hint = TranslationTable[302535920001306--[[Enter text to find]]],
		OnKbdKeyDown = self.Input_OnKbdKeyDown,
	}, self.idTextArea)

	self.idLimit = g_Classes.ChoGGi_XTextInput:new({
		Id = "idLimit",
		Dock = "right",
		MinWidth = 50,
		RolloverText = T(302535920001304--[[Set how many levels within this table we search. <color ChoGGi_red>Warning</color>: O(n).]]),
		OnKbdKeyDown = self.Input_OnKbdKeyDown,
	}, self.idTextArea)
	self.idLimit:SetText("1")

	self.idButtonContainer = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idButtonContainer",
		Dock = "bottom",
		Margins = box(0, 0, 0, 4),
	}, self.idDialog)

	self.idSearch = g_Classes.ChoGGi_XButton:new({
		Id = "idSearch",
		Dock = "left",
		Text = TranslationTable[10123--[[Search]]],
		Background = g_Classes.ChoGGi_XButton.bg_green,
		RolloverText = TranslationTable[302535920001303--[[Search for text within %s.]]]:format(self.obj_name),
		Margins = box(10, 0, 0, 0),
		OnPress = self.FindText,
	}, self.idButtonContainer)

	self.idCaseSen = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idCaseSen",
		Dock = "left",
		Margins = box(15, 0, 0, 0),
		Text = TranslationTable[302535920000501--[[Case-sensitive]]],
		RolloverText = TranslationTable[302535920000502--[[Treat uppercase and lowercase as distinct.]]],
	}, self.idButtonContainer)

	self.idThreads = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idThreads",
		Dock = "left",
		Margins = box(4, 0, 0, 0),
		Text = TranslationTable[302535920001360--[[Threads]]],
		RolloverText = TranslationTable[302535920001361--[[Will also search thread func names for value (case is ignored for this).]]],
	}, self.idButtonContainer)

	self.idCancel = g_Classes.ChoGGi_XButton:new({
		Id = "idCancel",
		Dock = "right",
		MinWidth = 80,
		Text = TranslationTable[6879--[[Cancel]]],
		Background = g_Classes.ChoGGi_XButton.bg_red,
		RolloverText = TranslationTable[302535920000074--[[Cancel without changing anything.]]],
		Margins = box(0, 0, 10, 0),
		OnPress = self.idCloseX.OnPress,
	}, self.idButtonContainer)

	-- new table for each find dialog, so examine only opens once
	self.found_objs = {}

	self.idEdit:SetFocus()

	self:PostInit(context.parent)
end

--~ function ChoGGi_DlgFindValue:RetStringCase(value, case)
--~ 	local obj_type = type(value)
--~ 	if obj_type == "string" then
--~ 		return case and value or value:lower(), obj_type
--~ 	else
--~ 		return case and tostring(value) or tostring(value):lower(), obj_type
--~ 	end
--~ end

function ChoGGi_DlgFindValue:FindText()
	self = GetRootDialog(self)
	local str = self.idEdit:GetText()
	-- no sense in finding nothing
	if str == "" then
		return
	end

	-- If not case all strings are made lower
	local case = self.idCaseSen:GetCheck()
	if not case then
		str = str:lower()
	end

	-- always start off empty
	table.clear(self.found_objs)
	table.clear(self.dupe_objs)

	-- build our list of objs
	self:RetObjects(
		self.obj,
		self.obj,
		str,
		case,
		self.idThreads:GetCheck(),
		tonumber(self.idLimit:GetText()) or 1
	)

	-- and fire off a new dialog
	local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(self.found_objs, nil, TranslationTable[302535920000854--[[Results Found]]])
	-- should do this nicer, but whatever
	CreateRealTimeThread(function()
		Sleep(10)
		dlg:SetPos(self:GetPos()+point(0, self.idDialog.box:sizey()))
	end)
end

function ChoGGi_DlgFindValue:RetObjects(obj, parent, str, case, threads, limit, level)
	if not level then
		level = 0
	end

	if level > limit then
		return
	end

	-- should've commented this...

	if type(obj) == "table" then

		local location_str1 = "L" .. level .. " P: " .. RetName(obj) .. "; "
		local location_str2 = ", " .. RetName(parent)

		for key, value in pairs(obj) do
			local key_name, value_name = RetName(key), RetName(value)
			local key_str, key_type = case and key_name or key_name:lower(), type(key)
			local value_str, value_type = case and value_name or value_name:lower(), type(value)

			local key_location = location_str1 .. key_name .. location_str2

			-- :find(str, 1, true) (1, true means don't use lua patterns, just plain text)
			if not self.dupe_objs[obj] and not self.found_objs[key_location]
					and (key_str:find(str, 1, true) or value_str:find(str, 1, true)) then
				self.found_objs[key_location] = obj
				self.dupe_objs[obj] = obj

			elseif threads then
				local value_location = location_str1 .. value_name .. location_str2
				if key_type == "thread" and not self.dupe_objs[key]
						and not self.found_objs[key_location] and FindThreadFunc(key, str) then
					self.found_objs[key_location] = key
					self.dupe_objs[key] = key

				elseif value_type == "thread" and not self.dupe_objs[value]
						and not self.found_objs[value_location] and FindThreadFunc(value, str) then
					self.found_objs[value_location] = value
					self.dupe_objs[value] = value

				end
			end

			-- keep on searching
			if key_type == "table" then
				self:RetObjects(key, obj, str, case, threads, limit, level+1)
			end
			if value_type == "table" then
				self:RetObjects(value, obj, str, case, threads, limit, level+1)
			end

		end
	end

end

local const = const
function ChoGGi_DlgFindValue:Input_OnKbdKeyDown(vk)
	self = GetRootDialog(self)
	if vk == const.vkEnter then
		self:FindText()
		return "break"
	elseif vk == const.vkEsc then
		self.idCloseX:Press()
		return "break"
	end

	return g_Classes.ChoGGi_XTextInput.OnKbdKeyDown(self.idEdit, vk)
end

-- Use to open a dialog
function ChoGGi.ComFuncs.OpenInFindValueDlg(obj, parent, ...)
	if not obj then
		return
	end

	local params, parent_type
	params, parent, parent_type = RetParamsParents(parent, params, ...)

	if not IsKindOf(parent, "XWindow") then
		parent = nil
	end

	params.obj = obj
	params.parent = parent

	return ChoGGi_DlgFindValue:new({}, terminal.desktop, params)
end

