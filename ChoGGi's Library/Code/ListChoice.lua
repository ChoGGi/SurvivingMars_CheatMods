-- See LICENSE for terms

-- all purpose items list

--[[
-- build an update items list func for use with ChoGGi.MenuFuncs.TerrainTextureRemap()


get around to merging some of these types into funcs?

> 1 = updates selected item with custom value type
custom_type = 1 : hides ok/cancel buttons, dblclick fires custom_func with {self.sel}
custom_type = 2 : colour selector
custom_type = 3 : sends back selected item.
custom_type = 4 : sends back all items. (shows ok/cancel)
custom_type = 5 :
custom_type = 6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)
custom_type = 7 : dblclick fires custom_func with {self.sel} (wrapped in a table, so we can use CallBackFunc for either)
custom_type = 8 : same as 7, but dbl rightclick fires custom_func, and dbl click fires ok as normally
custom_type = 9 : same as 4, but hides filter and doesn't close

ChoGGi.ComFuncs.OpenInListChoice{
	callback = CallBackFunc,
	items = item_list,
	title = "Title",
	hint = "Current: " .. hint,
	multisel = true,
	custom_type = custom_type,
	custom_func = CustomFunc, -- falls back to CallBackFunc
	close_func = function() end,
	height = 800.0,
	width = 100.0,
	skip_sort = true,
	skip_icons = true,
	sortby = "text",
	checkboxes = {
		only_one = true,
		at_least_one = true,
		{
			title = "Check1",
			hint = "Check1Hint",
			checked = false,
			func = function(dlg, check) end,
		},
		{
			title = "Check2",
			hint = "Check2Hint",
			checked = true,
			-- defaults to true
			visible = false,
		},
	},
}
--]]

--~ local TableConcat = ChoGGi.ComFuncs.TableConcat
local RetProperType = ChoGGi.ComFuncs.RetProperType
local Translate = ChoGGi.ComFuncs.Translate
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local DotNameToObject = ChoGGi.ComFuncs.DotNameToObject
local ValidateImage = ChoGGi.ComFuncs.ValidateImage
local Strings = ChoGGi.Strings

local type, tostring = type, tostring
local table_sort = table.sort
local point = point
local MeasureImage = UIL.MeasureImage

local function GetRootDialog(dlg)
	return GetParentOfKind(dlg, "ChoGGi_DlgListChoice")
end
DefineClass.ChoGGi_DlgListChoice = {
	__parents = {"ChoGGi_XWindow"},
	choices = false,
	colorpicker = false,
	-- we don't want OnColorChanged to fire till after user does something in the dialog
	skip_color_change = true,
	-- do different stuff for different numbers
	custom_type = 0,
	-- some different stuff fires off a func
	custom_func = false,
	callback_func = false,
	-- if listitem has .obj and this is true we "flash" it
	select_flash = false,
	-- last value entered in idEditValue
	old_edit_value = false,

	sel = false,
	obj = false,
}

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()
function ChoGGi_DlgListChoice:Init(parent, context)
	local g_Classes = g_Classes

	self.list = context.list
	self.items = self.list.items

	self.obj = context.obj or self.items[1].obj
	self.custom_func = self.list.custom_func or self.list.callback
	self.callback_func = self.list.callback
	self.custom_type = self.list.custom_type
	self.close_func = self.list.close_func
	self.title = self.list.title
	self.select_flash = self.list.select_flash
	self.skip_icons = self.list.skip_icons

	self.dialog_width = self.list.width or 500.0
	self.dialog_height = self.list.height or 625.0

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	-- setup checkboxes
	if self.list.checkboxes and #self.list.checkboxes > 0 then
		self.idCheckboxArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idCheckboxArea",
			Dock = "top",
			Margins = box(8, 4, 0, 4),
		}, self.idDialog)
		self.idCheckboxArea2 = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idCheckboxArea2",
			Dock = "top",
			Margins = box(8, 4, 0, 14),
			FoldWhenHidden = true,
		}, self.idDialog)

		local checkboxes = self.list.checkboxes
		for i = 1, #checkboxes do
			local list_check = checkboxes[i]
			local name = "idCheckBox" .. i

			local area_id = "idCheckboxArea"
			if list_check.level then
				area_id = area_id .. list_check.level
			end

			self[name] = g_Classes.ChoGGi_XCheckButton:new({
				Id = name,
				Dock = "left",
				Text = Translate(588--[[Empty--]]),
			}, self[area_id])
			local check = self[name]

			-- fiddle with checkboxes on toggled
			if checkboxes.only_one and checkboxes.at_least_one then
				check.OnChange = function(...)
					self.idCheckBoxAtLeastOne(...)
					self.idCheckBoxOnlyOne(...)
				end
			elseif checkboxes.only_one then
				check.OnChange = self.idCheckBoxOnlyOne
			elseif checkboxes.at_least_one then
				check.OnChange = self.idCheckBoxAtLeastOne
			end

			-- anything to add to it?
			if list_check.title then
				check:SetText(list_check.title)
			end
			if list_check.hint then
				check.RolloverText = list_check.hint
			end
			if list_check.func then
				check.OnPress = function()
					-- update check so user sees something
					local new_check = not check:GetCheck()
					check:SetCheck(new_check)
					-- send dlg, check back with func
					list_check.func(self, new_check)
				end
			end
			if list_check.checked then
				check:SetCheck(true)
			end
			if list_check.visible == false then
				check:SetVisible()
			end
		end

		-- no checkboxes so we hide it
		if #self.idCheckboxArea2 == 0 then
			self.idCheckboxArea2:SetVisible()
		end
	end

	self:AddScrollList()

	self.idList.OnMouseButtonDown = self.idList_OnMouseButtonDown
	self.idList.OnKbdKeyUp = self.idList_OnKbdKeyUp
	self.idList.OnMouseButtonDoubleClick = self.BuildReturnList
	self.idList.OnKbdKeyDown = self.idList_OnKbdKeyDown

	if self.custom_type ~= 9 then
		self.idFilterArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idFilterArea",
			Dock = "bottom",
		}, self.idDialog)

		self.idFilter = g_Classes.ChoGGi_XTextInput:new({
			Id = "idFilter",
			RolloverText = Strings[302535920000806--[["Only show items containing this text.

	Press Enter to show all items."--]]],
			Hint = Strings[302535920000068--[[Filter Items--]]],
			OnTextChanged = self.FilterText,
			OnKbdKeyDown = self.idFilter_OnKbdKeyDown
		}, self.idFilterArea)
	end

	if self.custom_type ~= 7 then

		self.idEditArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idEditArea",
			Dock = "bottom",
			Margins = box(0, 8, 4, 4),
		}, self.idDialog)

		self.idEditValue = g_Classes.ChoGGi_XTextInput:new({
			Id = "idEditValue",
			RolloverText = Strings[302535920000077--[["Enter a custom value to be applied.
The listitem <color 0 200 0>must</color> be selected for this to take effect (it's the last listitem).
It won't be visible unless the ""%s"" checkbox is enabled.

Warning: Entering the wrong value may crash the game or otherwise cause issues."--]]]:format(Strings[302535920000078--[[Custom Value--]]]),
			Hint = Strings[302535920000078--[[Custom Value--]]],
			OnKbdKeyDown = self.idEditValue_OnKbdKeyDown
		}, self.idEditArea)

		self.idShowCustomVal = g_Classes.ChoGGi_XCheckButton:new({
			Id = "idShowCustomVal",
			Dock = "left",
			Margins = box(4, 0, 0, 0),
			Text = Strings[302535920000078--[[Custom Value--]]],
			RolloverText = Strings[302535920000077]:format(Strings[302535920000078]),
			OnChange = self.idShowCustomVal_OnChange,
		}, self.idEditArea)

		-- toggle vis and checkmark depending on which list
		if self.custom_type == 0 then
			self.idEditValue:SetVisible(false)
		else
			self.idShowCustomVal:SetCheck(true)
			-- also check the toggle so people don't remove what they shouldn't
			self.idShowCustomVal:SetVisible(false)
			-- and add some padding to keep the look
			self.idEditValue:SetMargins(box(4, 0, 0, 0))
		end
	end

	self.idButtonContainer = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idButtonContainer",
		Dock = "bottom",
	}, self.idDialog)

	self.idOK = g_Classes.ChoGGi_XButton:new({
		Id = "idOK",
		Dock = "left",
		MinWidth = 50,
		Text = Translate(6878--[[OK--]]),
		Background = g_Classes.ChoGGi_XButton.bg_green,
		RolloverText = Strings[302535920000080--[["Press OK to apply and close dialog (Arrow keys and Enter/Esc can also be used, and probably double left-clicking <left_click>).
This will always send back all items (not selection)."--]]],
		OnPress = self.BuildReturnList
	}, self.idButtonContainer)

	self.idCancel = g_Classes.ChoGGi_XButton:new({
		Id = "idCancel",
		Dock = "right",
		MinWidth = 70,
		Text = Translate(6879--[[Cancel--]]),
		Background = g_Classes.ChoGGi_XButton.bg_red,
		RolloverText = Strings[302535920000074--[[Cancel without changing anything.--]]],
		OnPress = self.idCloseX.OnPress,
	}, self.idButtonContainer)

	-- are we sorting the list?
	if not self.list.skip_sort then
		local sortby = self.list.sortby
		if sortby then
			table_sort(self.list.items, function(a, b)
				a = a[sortby]
				b = b[sortby]
				if type(a) == "number" and type(b) == "number" then
					return a > b
				end
				return CmpLower(a, b)
			end)
		else
			-- default to display text
			table_sort(self.list.items, function(a, b)
				return CmpLower(a.text, b.text)
			end)
		end
	end

	-- append blank item for adding custom value
	if self.custom_type == 0 then
		self.list.items[#self.list.items+1] = {text = "", hint = "", value = false}
	end

	-- we need to build this before the colourpicker stuff, or do another check for the colourpicker
	self:BuildList()

	-- add the colour picker
	if self.custom_type == 2 then
		-- keep all colour elements in here for easier... UIy stuff
		self.idColourContainer = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idColourContainer",
			MinWidth = 550,
			Margins = box(0, 10, 10, 0),
			Dock = "right",
		}, self.idDialog)
		self.idColourContainer:SetVisible(false)

		self.idColorPickerArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idColorPickerArea",
			Dock = "top",
		}, self.idColourContainer)

		self.idColorPicker = g_Classes.XColorPicker:new({
			OnColorChanged = self.idColorPicker_OnColorChanged,
			AdditionalComponent = "alpha"
--~ 		 AdditionalComponent = "intensity"
--~ 		 AdditionalComponent = "none"
		}, self.idColorPickerArea)
		-- block it from closing on dbl click
		self.idColorPicker.idColorSquare.OnColorChanged_Orig = self.idColorPicker.idColorSquare.OnColorChanged
		self.idColorPicker.idColorSquare.OnColorChanged = self.idColorSquare_OnColorChanged

		self.idColorCheckArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idColorCheckArea",
			Dock = "top",
			HAlign = "center",
		}, self.idColourContainer)

		self.idColorCheckElec = g_Classes.ChoGGi_XCheckButton:new({
			Id = "idColorCheckElec",
			Text = Translate(79--[[Power--]]),
			RolloverText = Strings[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
			Dock = "left",
		}, self.idColorCheckArea)

		self.idColorCheckAir = g_Classes.ChoGGi_XCheckButton:new({
			Id = "idColorCheckAir",
			Text = Translate(891--[[Air--]]),
			RolloverText = Strings[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
			Dock = "left",
		}, self.idColorCheckArea)

		self.idColorCheckWater = g_Classes.ChoGGi_XCheckButton:new({
			Id = "idColorCheckWater",
			Text = Translate(681--[[Water--]]),
			RolloverText = Strings[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
			Dock = "left",
		}, self.idColorCheckArea)
		--

		self.idList:SetInitialSelection(true)

		self.sel = self.idList[self.idList.focused_item].item
		self.idEditValue:SetText(tostring(self.sel.value))
		self:UpdateColourPicker(self.sel.text)

		if self.custom_type == 2 then
			self:SetWidth(800)
			self.idColourContainer:SetVisible(true)
		end
	end -- end of colour picker if

	-- we don't add this till now so if we're adding colours it won't update till user actually changes it
	if self.custom_type ~= 7 then
		self.idEditValue.OnTextChanged = self.idEditValueOnTextChanged
	end

	if self.list.multisel then
		-- if it's a multiselect then add a hint
		if self.list.hint then
			self.list.hint = self.list.hint .. "\n\n" .. Strings[302535920001167--[[Use Ctrl/Shift for multiple selection.--]]]
		else
			self.list.hint = Strings[302535920001167]
		end

		self.idList.MultipleSelection = true
		if type(self.list.multisel) == "number" then
			-- select all of number
			for i = 1, self.list.multisel do
				self.idList:SetSelection(i, true)
			end
		end
	end

	if self.custom_type == 7 or self.custom_type == 9 then
		if self.list.hint then
			self.list.hint = self.list.hint .. "\n\n" .. Strings[302535920001341--[[Double-click to apply without closing list.--]]]
		else
			self.list.hint = Strings[302535920001341]
		end
	elseif self.custom_type == 8 then
		if self.list.hint then
			self.list.hint = self.list.hint .. "\n\n" .. Strings[302535920001371--[["Double-click to apply and close list, double right-click to apply without closing list."--]]]
		else
			self.list.hint = Strings[302535920001371]
		end
	end

	-- are we showing a hint?
	local hint = self.list.hint
	if hint then
		self.idMoveControl.RolloverText = hint
		self.idOK.RolloverText = hint .. "\n\n\n" .. self.idOK:GetRolloverText()
	end

	-- hide ok/cancel buttons as they don't do jack
	if self.custom_type == 1 then
		self.idButtonContainer:SetVisible(false)
	end

	-- select the first list item, so there's no errors when typing in the input box
	if self.custom_type ~= 0 then
		self.idList:SetInitialSelection(true)
		-- update custom value text
		self:idList_OnSelect("L")
	end

	-- we don't want OnColorChanged to fire till after user does something in the dialog
	self.skip_color_change = false

	-- dialog positioning after it's been sized
	self:PostInit(self.list.parent)
end

function ChoGGi_DlgListChoice:idShowCustomVal_OnChange(check)
	self = GetRootDialog(self)
	local item = self.idList[#self.idList]
	item:SetVisible(check)
	if check then
		item:SetSelected(true)
		item:SetFocused(true)

		self.idList:ScrollIntoView(item)
		self.idShowCustomVal:SetText(Strings[302535920000104--[[Show--]]])
		self.idEditValue:SetVisible(true)
	else
		self.idShowCustomVal:SetText(Strings[302535920000078--[[Custom Value--]]])
		self.idEditValue:SetVisible(false)
	end
end

-- uncheck all the other checks
function ChoGGi_DlgListChoice:idCheckBoxOnlyOne()
	local checks = self.parent
	if self:GetCheck() then
		for i = 1, #checks do
			local check = checks[i]
			if check ~= self then
				check:SetCheck(false)
			end
		end
	end
end
-- make sure at least one is checked
function ChoGGi_DlgListChoice:idCheckBoxAtLeastOne()
	local checks = self.parent
	if not self:GetCheck() then
		local current_idx
		local other_idx
		local any_checked
		for i = 1, #checks do
			local check = checks[i]
			if check == self then
				current_idx = i
			else
				other_idx = i
				if check:GetCheck() then
					any_checked = true
					break
				end
			end
		end
		if not any_checked then
			if #checks > 1 then
				checks[other_idx or 1]:SetCheck(true)
			else
				checks[1]:SetCheck(true)
			end
		end
	end
end

function ChoGGi_DlgListChoice:idColorSquare_OnColorChanged(colour)
	self:OnColorChanged_Orig(colour)
end

function ChoGGi_DlgListChoice:idList_OnKbdKeyDown(vk)
	self = GetRootDialog(self)
	if vk == const.vkEnter then
		self:BuildReturnList(nil, "L")
		return "break"
	elseif vk == const.vkEsc then
		self.idCloseX:Press()
		return "break"
	end
	return "continue"
end

function ChoGGi_DlgListChoice:idList_OnMouseButtonDown(pt, button, ...)
	g_Classes.ChoGGi_XList.OnMouseButtonDown(self, pt, button)
	GetRootDialog(self):idList_OnSelect(button)
end

function ChoGGi_DlgListChoice:idList_OnKbdKeyUp(...)
	g_Classes.ChoGGi_XList.OnKbdKeyUp(...)
	GetRootDialog(self):idList_OnSelect("L")
end

function ChoGGi_DlgListChoice:idEditValue_OnKbdKeyDown(vk, ...)
	self = GetRootDialog(self)
	if vk == const.vkEnter then
		self:BuildReturnList(_, "L")
		return "break"
	end
	return g_Classes.ChoGGi_XTextInput.OnKbdKeyDown(self.idEditValue, vk, ...)
end

function ChoGGi_DlgListChoice:idEditValueOnTextChanged()
	local text = self:GetText()
	self = GetRootDialog(self)
	if text == self.old_edit_value then
		return
	end
	self.old_edit_value = text

	local value, value_type
	local name_str = text

	-- if user pastes an rgb or rgba func string translate to colour: RGBA(233, 123, 32, 100)
	if text:sub(1, 3) == "RGB" then
		-- remove any spaces/newlines etc
		text = text:gsub("[%s%c]", "")
		-- get us (0, 0, 0), and func name
		text = text:sub(4)
		local func = "RGB"
		local count = 3
		if text:sub(1, 1) == "A" then
			text = text:sub(2)
			func = "RGBA"
			count = 4
		end
		text = text:gsub("%(", ""):gsub("%)", "")
		-- grab the values
		local values = {}
		local c = 0

		-- loop through all the numbers
		for d in text:gmatch("%d+") do
			c = c + 1
			values[c] = tonumber(d)
		end

		if #values == 3 then
			value, value_type = RetProperType(_G[func](values[1], values[2], values[3]))
		else
			value, value_type = RetProperType(_G[func](values[1], values[2], values[3], values[4]))
		end
		name_str = value

	else
		value = tonumber(name_str)
		if type(value) == "number" then
			value_type = "number"
		else
			value = DotNameToObject(name_str)
			if type(value) == "number" then
				value_type = "number"
			else
				value, value_type = RetProperType(name_str)
			end
		end
	end

--~ 	printC(text, value, value_type)
	if self.custom_type == 0 then
		-- last item is a blank item for custom value
		if self.idShowCustomVal:GetCheck() then
			local item = self.items[#self.items]
			item.text = name_str
			item.value = value
			item.hint = Strings[302535920000079--[[* Use this custom value--]]]
			local listitem = self.idList[#self.idList]
			listitem.RolloverText = Strings[302535920000079]
			listitem.RolloverTitle = item.text
			listitem.idText:SetText(item.text)
			listitem.item = item
			-- special little guy
			listitem.FocusedBorderColor = -14113793 -- rollover_blue
		end
	elseif self.idList.focused_item then
		-- update the item's value
		self.idList[self.idList.focused_item].item.value = value
		-- if colour editor
		if self.idColourContainer and value_type == "number" then
			-- update obj colours
			if self.custom_type == 2 then
				self:UpdateColour()
			end
			self.idColorPicker:SetColor(value)
		end
	end
end

local item_icon_table = {"Resources", "BuildingTemplates", "g_Classes"}
function ChoGGi_DlgListChoice:AddItemIcon(g, item)
	for i = 1, 3 do
		local list = g[item_icon_table[i]]

		-- try .value and .text
		local item_temp = list[item.value]
		if not item_temp then
			item_temp = list[item.text]
		end

		if item_temp then
			local x = MeasureImage(item_temp.display_icon or "")
			if x > 0 then
				return item_temp.display_icon
			end
		end

	end
end

function ChoGGi_DlgListChoice:BuildList(save_pos)
	local g = _G
	local g_Classes = g.g_Classes

	if save_pos then
		save_pos = {
			self.idList.PendingOffsetY or 0,
			self.idScrollV:GetScroll(),
		}
	end
	self.idList:Clear()
	local list_count = #self.items
	for i = 1, list_count do
		local item = self.items[i]

		-- is there an icon to add
		local text, display_icon
		if item.icon then
			if item.icon:find("<image ") then
				display_icon = item.icon
				text = item.icon .. " " .. item.text
			else
				local icon = ValidateImage(item.icon)
				if icon then
					display_icon = icon
					text = item.text
				end
			end
		else
			display_icon = not self.skip_icons and self:AddItemIcon(g, item)
			text = item.text
		end

		--
		local listitem = self.idList:CreateTextItem(text)

		-- make sure last item isn't taking up space if it's not visible
		if list_count == i and self.custom_type == 0 and not self.idShowCustomVal:GetCheck() then
			listitem:SetVisible(false)
		end

		if item.hint_bottom then
			listitem.RolloverHint = item.hint_bottom
		end

		if self.custom_type > 4 and self.custom_type ~= 5 then
			listitem.RolloverHint = Strings[302535920001444--[["<left_click> Activate, <right_click> Alt Activate"--]]]
		end

		-- easier access
		listitem.item = item

		-- add rollover text
		local title = item.text
		if type(item.value) ~= nil and item.value ~= item.text then
			local value_str
			if type(item.value) == "userdata" then
				value_str = Translate(item.value)
			else
				value_str = item.value
			end
			title = item.text .. ": <color 200 255 200>" .. tostring(value_str) .. "</color>"
		end
		listitem.RolloverTitle = title

		if item.hint then
			if type(item.hint) == "userdata" then
				listitem.RolloverText = Translate(item.hint)
			else
				listitem.RolloverText = item.hint
			end
		end

		if display_icon and not self.skip_icons then
			listitem.idImage = g_Classes.ChoGGi_XImage:new({
				Id = "idImage",
				Dock = "left",
				VAlign = "center",
			}, listitem)
			listitem.idImage:SetImage(display_icon)
			if item.icon_scale then
				listitem.idImage:SetImageScale(point(item.icon_scale, item.icon_scale))
			end
		end

	end

	-- restore scroll pos
	if save_pos then
		self.idList:ScrollTo(nil, save_pos[1])
		self.idScrollV:SetScroll(save_pos[2])
	end
end

function ChoGGi_DlgListChoice:idFilter_OnKbdKeyDown(vk)
	self = GetRootDialog(self)
	if vk == const.vkEnter then
		self:FilterText(true)
		self.idFilter:SelectAll()
		return "break"
	elseif vk == const.vkEsc then
		self.idCloseX:Press()
		return "break"
	end
	return g_Classes.ChoGGi_XTextInput.OnKbdKeyDown(self.idFilter, vk)
end

function ChoGGi_DlgListChoice:FilterText(txt)
	self = GetRootDialog(self)
	-- rebuild list
	self:BuildList()

	-- enter was pressed
	if txt == true then
		return
	end

	-- otherwise get text from filter input
	txt = self.idFilter:GetText()
	-- blank so no need to filter
	if txt == "" then
		return
	end

	-- loop through all the list items and remove any we can't find
	local count = #self.idList
	local custom_type = self.custom_type == 0
	for i = count, 1, -1 do
		local li = self.idList[i]
		-- stick all the strings into one for quicker searching? (i use a \t (tab char) so the strings are separate)
		local str = (li.idText.text or "") .. "\t" .. (li.RolloverText or "") .. "\t" .. (li.RolloverTitle or "")
		-- never filter out the "custom value"
		if not (str:find_lower(txt) or custom_type and i == count) then
			self.idList[i]:delete()
		end
	end
	self.idList.focused_item = false
end

function ChoGGi_DlgListChoice:UpdateColour()
	if not self.obj then
		-- grab the object from the last list item
		self.obj = self.idList[#self.idList].item.obj
	end
	-- checks/backs up old colours
	ChoGGi.ComFuncs.SaveOldPalette(self.obj)

	-- can only change basecolour
	if self.obj:GetMaxColorizationMaterials() > 0 then
		local items = self.idList
		for i = 1, 4 do
			self.obj:SetColorizationMaterial(i,
				-- color
				items[i].item.value,
				-- roughness
				items[i+4].item.value,
				-- metallic
				items[i+8].item.value
			)
		end
	end

	self.obj:SetColorModifier(self.idList[#self.idList].item.value)
	if self.obj.SetColor then
		self.obj:SetColor(self.idList[#self.idList].item.value)
	end
end

function ChoGGi_DlgListChoice:idColorPicker_OnColorChanged(colour)
	self = GetRootDialog(self)
	local sel_idx = self.idList.focused_item
	-- no list item selected, so just return
	if not sel_idx then
		return
	end
	local item = self.idList[sel_idx].item
	-- if it's colourpicker mode and we selected Metallic or Roughness then skip updating
	if self.custom_type == 2 and not item.text:find("Color") then
		return
	end
	-- custom value box
	self.idEditValue:SetText(tostring(colour))
	-- update item value (probably useless now that it's automagical)
	item.value = colour

	if self.skip_color_change then
		return
	end

	-- colour selector
	if self.custom_type == 2 then
		self:UpdateColour()
	end
end

function ChoGGi_DlgListChoice:idList_OnSelect(button)
	if not self.idList.focused_item then
		return
	end

	-- update my selection
	self.sel = self.idList[self.idList.focused_item].item

	-- update the custom value box
	if self.idEditValue then
		self.idEditValue:SetText(tostring(self.sel.value))
	end

	if self.sel.voiced then
		g_Voice:Play(self.sel.voiced)
	end

	-- blick world obj
	if self.select_flash and self.sel.obj then
		ChoGGi.ComFuncs.AddBlinkyToObj(self.sel.obj, 8000)
	end

	if button ~= "L" then
		return
	end

	-- 2 = showing the colour picker
	if self.custom_type == 2 then
		-- move the colour picker circle
		self:UpdateColourPicker(self.sel.text)
	end
end

--~ function ChoGGi_DlgListChoice:idList_OnMouseButtonDoubleClick(_, button)
function ChoGGi_DlgListChoice:CallbackSelectedList()
	-- build self.choices
	if self.sel and not self.list.multisel then
		self.sel.list_selected = true
		self.choices = {self.sel}
		self:UpdateReturnedItem(self.choices)
	else
		self:GetListItems("skip")
	end
	-- send selection back
	if self.custom_type == 6 and self.callback_func then
		self.callback_func(self.choices, self)
	elseif self.custom_func then
		self.custom_func(self.choices, self)
	end
end

function ChoGGi_DlgListChoice:BuildReturnList(_, button)
	-- select all items (ok button)
	if self.class == "ChoGGi_XButton" then
		button = "L"
	end
	self = GetRootDialog(self)

	if button == "L" then
		-- fire custom_func with sel
		if self.custom_type == 1 or self.custom_type == 7 then
			self:CallbackSelectedList()
		elseif self.custom_type == 9 then
			-- build self.choices
			self:GetListItems()
			-- send selection back
			if self.custom_func then
				self.custom_func(self.choices, self)
			end
		elseif self.custom_type == 2 then
			-- build self.choices
			self:GetListItems("all")
			-- send selection back
			if self.custom_func then
				self.custom_func(self.choices, self)
			end
		else
			-- build self.choices
			self:CallbackSelectedList()
			self:Close("ok")
		end
	elseif self.sel and button == "R" then
		-- do stuff without closing list
		if self.custom_type == 6 then
			if self.custom_func then
				self.custom_func(self.sel.func or self.sel.value, self)
			end
		elseif self.custom_type == 8 then
			self:CallbackSelectedList()
		elseif self.idEditValue then
			self.idEditValue:SetText(self.sel.text)
		end
	end
end

-- update colour
function ChoGGi_DlgListChoice:UpdateColourPicker(text)
	-- if it's colourpicker mode and we selected Metallic or Roughness then skip updating
	if self.custom_type == 2 and not text:find("Color") then
		return
	end
	local num = tonumber(self.idEditValue:GetText())
	if num then
		self.idColorPicker:SetColor(num)
	end
end

function ChoGGi_DlgListChoice:UpdateReturnedItem(choices)
	choices = choices or {[1] = {}}
	local choice1 = choices[1]

	-- always return the custom value (and try to convert it to correct type)
	if self.idEditValue then
		choice1.list_editvalue = RetProperType(self.idEditValue:GetText())
	end

	-- add checkbox statuses
	if self.list.checkboxes and #self.list.checkboxes > 0 then
		for i = 1, #self.list.checkboxes do
			choice1["check" .. i] = self["idCheckBox" .. i]:GetCheck()
		end
	end
	-- and if it's a colourpicker list send that back as well
	if self.idColourContainer then
		choice1.list_checkair = self.idColorCheckAir:GetCheck()
		choice1.list_checkwater = self.idColorCheckWater:GetCheck()
		choice1.list_checkelec = self.idColorCheckElec:GetCheck()
	end
	return choices
end

function ChoGGi_DlgListChoice:GetListItems(which)
	local items = {}

	-- get sel item(s)
	if not which or self.custom_type == 0 or self.custom_type == 3 or self.custom_type == 6 then
		-- loop through and add all selected items to the list
		for i = 1, #self.idList.selection do
			items[i] = self.idList[self.idList.selection[i]].item
		end
	elseif which == "all" then
		for i = 1, #self.idList do
			items[i] = self.idList[i].item
		end
	else
		local sel = self.idList.selection and self.idList.selection[1]
		-- get all (visible) items
		for i = 1, #self.idList do
			items[i] = self.idList[i].item
			if sel and i == sel then
				items[i].list_selected = true
			else
				items[i].list_selected = nil
			end
		end
	end

	-- always start with blank choices
	self.choices = {}

	-- attach other stuff to first item
	local c = #self.choices
	for i = 1, #items do
		c = c + 1
		self.choices[c] = items[i]
	end

	-- nothing selected
	if c == 0 then
		-- fake entry we can check later on
		self.choices.nothing_selected = true
		-- we send back checkmarks no matter what
		self.choices[1] = {}
	end

	self:UpdateReturnedItem(self.choices)
end
