-- See LICENSE for terms

-- all purpose items list

--~ local TableConcat = ChoGGi.ComFuncs.TableConcat
local CheckText = ChoGGi.ComFuncs.CheckText
local CompareTableValue = ChoGGi.ComFuncs.CompareTableValue
local RetProperType = ChoGGi.ComFuncs.RetProperType
local Trans = ChoGGi.ComFuncs.Translate
local S = ChoGGi.Strings

local type,tostring = type,tostring
local StringFormat = string.format

DefineClass.ChoGGi_ListChoiceDlg = {
	__parents = {"ChoGGi_Window"},
	choices = false,
	colorpicker = false,
	-- we don't want OnColorChanged to fire till after window is loaded
	skip_color_change = true,
	-- do different stuff for different numbers
	custom_type = 0,
	-- some different stuff fires off a func
	custom_func = false,
	-- if listitem has .obj and this is true we "flash" it
	select_flash = false,

	sel = false,
	obj = false,
}

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()
function ChoGGi_ListChoiceDlg:Init(parent, context)
	local ChoGGi = ChoGGi
	local g_Classes = g_Classes

	self.list = context.list
	self.items = self.list.items

	self.obj = context.obj or self.items[1].obj
	self.custom_func = self.list.custom_func
	self.custom_type = self.list.custom_type
	self.close_func = self.list.close_func
	self.title = self.list.title
	self.select_flash = self.list.select_flash

	self.dialog_width = self.list.width or 500.0
	self.dialog_height = self.list.height or 615.0

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self:AddScrollList()

	function self.idList.OnMouseButtonDown(obj,pt,button)
		g_Classes.ChoGGi_List.OnMouseButtonDown(obj,pt,button)
		self:idListOnMouseButtonDown(button)
	end
	function self.idList.OnMouseButtonDoubleClick(_,_,button)
		self:idListOnMouseButtonDoubleClick(button)
	end

	self.idFilterArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idFilterArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idFilter = g_Classes.ChoGGi_TextInput:new({
		Id = "idFilter",
		RolloverText = S[302535920000806--[["Only show items containing this text.

Press Enter to show all items."--]]],
		Hint = S[302535920000068--[[Filter Items--]]],
		OnTextChanged = function()
			self:FilterText(self.idFilter:GetText())
		end,
		OnKbdKeyDown = function(obj, vk)
			return self:idFilterOnKbdKeyDown(obj, vk)
		end,
	}, self.idFilterArea)

	-- setup checkboxes
	if self.list.check and #self.list.check > 0 then
		self.idCheckboxArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idCheckboxArea",
			Dock = "bottom",
			HAlign = "center",
		}, self.idDialog)

		for i = 1, #self.list.check do
			local name1 = StringFormat("idCheckBox%s",i)
			self[name1] = g_Classes.ChoGGi_CheckButton:new({
				Id = name1,
				Text = S[588--[[Empty--]]],
				Dock = "left",
			}, self.idCheckboxArea)

			-- check table
			local obj = self.list.check[i]
			-- anything to add to it?
			if obj.title then
				self[name1]:SetText(CheckText(obj.title))
			end
			if obj.hint then
				self[name1].RolloverText = CheckText(obj.hint)
			end
--~ 			if obj.func then
--~ 				self[name1].Press = obj.func
--~ 			end
			if obj.checked then
				self[name1]:SetCheck(true)
			end

		end
	end

	-- make checkbox work like a button
	if self.custom_type == 5 then
		function self.idCheckBox2.OnChange()
			-- show lightmodel lists and lets you pick one to use in new window
			ChoGGi.MenuFuncs.ChangeLightmodel()
		end
	end

	if self.custom_type ~= 7 then
		self.idEditArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idEditArea",
			Dock = "bottom",
		}, self.idDialog)

		self.idEditValue = g_Classes.ChoGGi_TextInput:new({
			Id = "idEditValue",
			RolloverText = S[302535920000077--[["You can enter a custom value to be applied. The item needs to be selected for this to take effect (see last entry).

Warning: Entering the wrong value may crash the game or otherwise cause issues."--]]],
			Hint = S[302535920000078--[[Add Custom Value--]]],
			OnTextChanged = function()
				self:idEditValueOnTextChanged()
			end,
		}, self.idEditArea)
	end

	self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonContainer",
		Dock = "bottom",
	}, self.idDialog)

	self.idOK = g_Classes.ChoGGi_Button:new({
		Id = "idOK",
		Dock = "left",
		RolloverAnchor = "smart",
		Text = S[6878--[[OK--]]],
		RolloverText = S[302535920000080--[[Apply and close dialog (Arrow keys and Enter/Esc can also be used).--]]],
		OnPress = function()
			-- build self.choices
			self:GetAllItems()
			-- send selection back
			self.list.callback(self.choices)
--~			 self:delete()
			self:Close("cancel")
		end,
	}, self.idButtonContainer)

	self.idCancel = g_Classes.ChoGGi_Button:new({
		Id = "idCancel",
		Dock = "right",
		MinWidth = 80,
		RolloverAnchor = "smart",
		Text = S[6879--[[Cancel--]]],
		RolloverText = S[302535920000074--[[Cancel without changing anything.--]]],
		OnPress = self.idCloseX.OnPress,
	}, self.idButtonContainer)

	-- are we sorting the list?
	if not self.list.skip_sort then
		-- sort table by display text
		local sortby = self.list.sortby or "text"
		table.sort(self.list.items,
			function(a,b)
				return CompareTableValue(a,b,sortby)
			end
		)
	end
	-- append blank item for adding custom value
	if self.custom_type == 0 then
		self.list.items[#self.list.items+1] = {text = "",hint = "",value = false}
	end

	-- we need to build this before the colourpicker stuff, or do another check for the colourpicker
	self:BuildList()

	-- add the colour picker?
	if self.custom_type == 2 or self.custom_type == 5 then
		-- keep all colour elements in here for easier... UIy stuff
		self.idColourContainer = g_Classes.ChoGGi_DialogSection:new({
			Id = "idColourContainer",
			MinWidth = 550,
			Dock = "right",
		}, self.idDialog)
		self.idColourContainer:SetVisible(false)

		self.idColorPickerArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idColorPickerArea",
			Dock = "top",
		}, self.idColourContainer)

		self.idColorPicker = g_Classes.XColorPicker:new({
			OnColorChanged = function(_, colour)
				self:idColorPickerOnColorChanged(colour)
			end,
			AdditionalComponent = "alpha"
	--~		 AdditionalComponent = "intensity"
		}, self.idColorPickerArea)
		-- block it from closing on dbl click
		self.idColorPicker.idColorSquare.OnColorChanged = function(_, colour)
			self.idColorPicker:SetColorInternal(colour)
		end

		self.idColorCheckArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idColorCheckArea",
			Dock = "top",
			HAlign = "center",
		}, self.idColourContainer)

		self.idColorCheckElec = g_Classes.ChoGGi_CheckButton:new({
			Id = "idColorCheckElec",
			Text = S[79--[[Power--]]],
			RolloverText = S[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
			Dock = "left",
		}, self.idColorCheckArea)

		self.idColorCheckAir = g_Classes.ChoGGi_CheckButton:new({
			Id = "idColorCheckAir",
			Text = S[891--[[Air--]]],
			RolloverText = S[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
			Dock = "left",
		}, self.idColorCheckArea)

		self.idColorCheckWater = g_Classes.ChoGGi_CheckButton:new({
			Id = "idColorCheckWater",
			Text = S[681--[[Water--]]],
			RolloverText = S[302535920000082--[["Check this for ""All of type"" to only apply to connected grid."--]]],
			Dock = "left",
		}, self.idColorCheckArea)

		self.idList:SetSelection(1, true)
		self.sel = self.idList[self.idList.focused_item].item
		self.idEditValue:SetText(tostring(self.sel.value))
		self:UpdateColourPicker(self.sel.text)
		if self.custom_type == 2 then
			self:SetWidth(800)
			self.idColourContainer:SetVisible(true)
		end

		-- default alpha stripe to max, so the text is updated correctly (and maybe make it actually do something sometime)
		self.idColorPicker:UpdateComponent("ALPHA", 1000)
	end -- end of colour picker if

	if self.list.multisel then
		-- if it's a multiselect then add a hint
		if self.list.hint then
			self.list.hint = StringFormat("%s\n\n%s",CheckText(self.list.hint),S[302535920001167--[[Use Ctrl/Shift for multiple selection.--]]])
		else
			self.list.hint = S[302535920001167--[[Use Ctrl/Shift for multiple selection.--]]]
		end

		self.idList.MultipleSelection = true
		if type(self.list.multisel) == "number" then
			-- select all of number
			for i = 1, self.list.multisel do
				self.idList:SetSelection(i, true)
			end
		end
	end

	self.idList.OnKbdKeyDown = function(_, vk)
		if vk == const.vkEnter then
			self:idListOnMouseButtonDoubleClick("L")
			return "break"
		elseif vk == const.vkEsc then
			self.idCloseX:Press()
			return "break"
		end
		return "continue"
	end

	if self.custom_type == 7 then
		if self.list.hint then
			self.list.hint = StringFormat("%s\n\n%s",CheckText(self.list.hint),S[302535920001341--[[Double-click to apply without closing list.--]]])
		else
			self.list.hint = S[302535920001341--[[Double-click to apply without closing list.--]]]
		end
	elseif self.custom_type == 8 then
		if self.list.hint then
			self.list.hint = StringFormat("%s\n\n%s",CheckText(self.list.hint),S[302535920001371--[["Double-click to apply and close list, double right-click to apply without closing list."--]]])
		else
			self.list.hint = S[302535920001371--[["Double-click to apply and close list, double right-click to apply without closing list."--]]]
		end
	end

	-- are we showing a hint?
	local hint = CheckText(self.list.hint,"")
	if hint ~= "" then
		self.idMoveControl.RolloverText = hint
--~ 		self.idList.RolloverText = hint
		self.idOK.RolloverText = StringFormat("%s\n\n\n%s",self.idOK:GetRolloverText(),hint)
	end

	-- hide ok/cancel buttons as they don't do jack
	if self.custom_type == 1 then
		self.idButtonContainer:SetVisible(false)
	end

	self:SetInitPos(self.list.parent)

	self.skip_color_change = false
end

function ChoGGi_ListChoiceDlg:idEditValueOnTextChanged()
	local text = self.idEditValue:GetText()
	local value = RetProperType(text)
	if self.custom_type > 0 then
		if self.idList.focused_item then
			self.idList[self.idList.focused_item].item.value = value
			if self.idColourContainer then
				-- update obj colours
				self:UpdateColour()
				if type(value) == "number" then
					self.idColorPicker:SetColor(value)
				end
				self.idEditValue:SetCursor(1,#text)
			end
		end
	else
		-- last item is a blank item for custom value
		self.items[#self.items] = {
			text = text,
			value = value,
			hint = 302535920000079--[[< Use custom value--]],
		}
		local item = self.items[#self.items]
		local listitem = self.idList[#self.idList]
		listitem.RolloverText = S[302535920000079--[[< Use custom value--]]]
		listitem.RolloverTitle = item.text
		listitem.idText:SetText(item.text)
		listitem.item = item
	end
end

function ChoGGi_ListChoiceDlg:BuildList()
	local g_Classes = g_Classes
	local point = point

	self.idList:Clear()
	for i = 1, #self.items do
		local item = self.items[i]

		-- is there an icon to add
		local text
		local display_icon
		if item.icon then
			if item.icon:find("<image ",1,true) then
				text = StringFormat("%s %s",item.icon,item.text)
			else
				display_icon = true
				text = item.text
			end
		else
			text = item.text
		end
		--
		local listitem = self.idList:CreateTextItem(text)

		if item.hint_bottom then
			listitem.RolloverHint = item.hint_bottom
		end

		-- easier access
		listitem.item = item

		-- add rollover text
		local title = item.text
		if type(item.value) ~= nil and item.value ~= item.text then
			local value_str
			if type(item.value) == "userdata" then
				value_str = Trans(item.value)
			else
				value_str = item.value
			end
			title = StringFormat("%s: <color 200 255 200>%s</color>",item.text,value_str)
		end
		listitem.RolloverTitle = title

		if item.hint then
			if type(item.hint) == "userdata" then
				listitem.RolloverText = Trans(item.hint)
			else
				listitem.RolloverText = CheckText(item.hint)
			end
		end

		if display_icon then
			listitem.idImage = g_Classes.ChoGGi_Image:new({
				Id = "idImage",
				Dock = "left",
			}, listitem)
			listitem.idImage:SetImage(item.icon)
			if item.icon_scale then
				listitem.idImage:SetImageScale(point(item.icon_scale, item.icon_scale))
			end
		end

	end
end

function ChoGGi_ListChoiceDlg:idFilterOnKbdKeyDown(obj,vk)
	if vk == const.vkEnter then
		self:FilterText()
		self.idFilter:SelectAll()
		return "break"
	elseif vk == const.vkEsc then
		self.idCloseX:Press()
		return "break"
	end
	return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
end

function ChoGGi_ListChoiceDlg:FilterText(txt)
	self:BuildList()
	if not txt or txt == "" then
		return
	end
	-- loop through all the list items and remove any we can't find
	local count = #self.idList
	for i = count, 1, -1 do
		local li = self.idList[i]
		if not (li.idText.text:find_lower(txt) or li.RolloverText:find_lower(txt) or i == count) then
			table.remove(self.idList,i)
		end
	end
	self.idList.focused_item = false
end

function ChoGGi_ListChoiceDlg:UpdateColour()
	if not self.obj then
		-- grab the object from the last list item
		self.obj = self.idList[#self.idList].item.obj
	end
	-- checks/backs up old colours
	ChoGGi.ComFuncs.SaveOldPalette(self.obj)
	-- update object colour
	local items = self.idList
	for i = 1, 4 do
		local color = items[i].item.value
		local metallic = items[i+4].item.value
		local roughness = items[i+8].item.value
		self.obj:SetColorizationMaterial(i,color,roughness,metallic)
	end
	self.obj:SetColorModifier(self.idList[#self.idList].item.value)
end

function ChoGGi_ListChoiceDlg:idColorPickerOnColorChanged(colour)
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
	elseif self.custom_type == 5 then
		self:BuildAndApplyLightmodel()
	end
end

function ChoGGi_ListChoiceDlg:idListOnMouseButtonDown(button)
	if not self.idList.focused_item then
		return
	end

	-- update my selection
	self.sel = self.idList[self.idList.focused_item].item

	-- update the custom value box
	if self.idEditValue then
		self.idEditValue:SetText(tostring(self.sel.value))
	end

	if self.select_flash and self.sel.obj then
		ChoGGi.ComFuncs.AddBlinkyToObj(self.sel.obj,8000)
	end

	if button ~= "L" then
		return
	end

	if self.custom_type > 0 then
		-- 2 = showing the colour picker
		if self.custom_type == 2 then
			-- move the colour picker circle
			self:UpdateColourPicker(self.sel.text)
			-- default alpha stripe to max, so the text is updated correctly (and maybe make it actually do something sometime)
			self.idColorPicker:UpdateComponent("ALPHA", 1000)
		-- don't show picker unless it's a colour setting (browsing lightmodel)
		elseif self.custom_type == 5 then
			if self.sel.editor == "color" then
				self:SetWidth(800)
				self:UpdateColourPicker(self.sel.text)
				self.idColourContainer:SetVisible(true)
			else
				self:SetWidth(self.dialog_width)
				self.idColourContainer:SetVisible(false)
			end
		end
	end
end

function ChoGGi_ListChoiceDlg:idListOnMouseButtonDoubleClick(button)
	if not self.sel then
		return
	end
	if button == "L" then
		-- fire custom_func with sel
		if self.custom_func and (self.custom_type == 1 or self.custom_type == 7) then
			self.custom_func({self.sel},self)
		elseif self.custom_type ~= 5 and self.custom_type ~= 2 or self.custom_type == 8 then
			-- dblclick to close and ret item
			self.idOK.OnPress()
		end
	elseif button == "R" then
		-- does stuff without closing list
		if self.custom_type == 5 then
			self:BuildAndApplyLightmodel()
		elseif self.custom_type == 6 and self.custom_func then
			self.custom_func(self.sel.func,self)
		elseif self.custom_type == 8 and self.custom_func then
			self.custom_func({self.sel},self)
		elseif self.idEditValue then
			self.idEditValue:SetText(self.sel.text)
		end
	end
end

function ChoGGi_ListChoiceDlg:BuildAndApplyLightmodel()
	-- update list item settings table
	self:GetAllItems()
	-- remove defaults
	local model_table = {}
	for i = 1, #self.choices do
		if self.choices[i].value ~= self.choices[i].default then
			model_table[self.choices[i].sort] = self.choices[i].value
		end
	end
	-- rebuild it
	LightmodelPresets.ChoGGi_Custom = LightmodelPreset:new(model_table)
	-- and temp apply
	SetLightmodel(1,"ChoGGi_Custom")
end

-- update colour
function ChoGGi_ListChoiceDlg:UpdateColourPicker(text)
	-- if it's colourpicker mode and we selected Metallic or Roughness then skip updating
	if self.custom_type == 2 and not text:find("Color") then
		return
	end
	local num = tonumber(self.idEditValue:GetText())
	if num then
		self.idColorPicker:SetColor(num)
	end
end

function ChoGGi_ListChoiceDlg:GetAllItems()
	-- always start with blank choices
	self.choices = {}
	-- get sel item(s)
	local items = {}
	if self.custom_type == 0 or self.custom_type == 3 or self.custom_type == 6 then
		-- loop through and add all selected items to the list
		for i = 1, #self.idList.selection do
			items[i] = self.idList[self.idList.selection[i]].item
		end
	else
		-- get all (visible) items
		for i = 1, #self.idList do
			items[i] = self.idList[i].item
		end
	end
	-- attach other stuff to first item

	if #items > 0 then
		local c = #self.choices
		for i = 1, #items do
			if i == 1 and self.idEditValue then
				-- always return the custom value (and try to convert it to correct type)
				items[i].editvalue = RetProperType(self.idEditValue:GetText())
			end
			c = c + 1
			self.choices[c] = items[i]
		end
	end

	-- send back checkmarks no matter what
	self.choices[1] = self.choices[1] or {}
	-- add checkbox statuses
	if self.list.check and #self.list.check > 0 then
		for i = 1, #self.list.check do
			self.choices[1][StringFormat("check%s",i)] = self[StringFormat("idCheckBox%s",i)]:GetCheck()
		end
	end
	-- and if it's a colourpicker list send that back as well
	if self.idColourContainer then
		self.choices[1].checkair = self.idColorCheckAir:GetCheck()
		self.choices[1].checkwater = self.idColorCheckWater:GetCheck()
		self.choices[1].checkelec = self.idColorCheckElec:GetCheck()
	end
end

-- copied from GedPropEditors.lua. it's normally only called when GED is loaded, but we need it for the colour picker
function CreateNumberEditor(parent, id, up_pressed, down_pressed)
	local g_Classes = g_Classes
	local RGBA,RGB,box = RGBA,RGB,box
	local IconScale = point(500, 500)
	local IconColor = RGB(0, 0, 0)
	local RolloverBackground = RGB(204, 232, 255)
	local PressedBackground = RGB(121, 189, 241)
	local Background = RGBA(0, 0, 0, 0)
	local DisabledIconColor = RGBA(0, 0, 0, 128)

	local button_panel = g_Classes.XWindow:new({Dock = "right"}, parent)
	local top_btn = g_Classes.XTextButton:new({
		Dock = "top",
		OnPress = up_pressed,
		Padding = box(1, 2, 1, 1),
		Icon = "CommonAssets/UI/arrowup-40.tga",
		IconScale = IconScale,
		IconColor = IconColor,
		DisabledIconColor = DisabledIconColor,
		Background = Background,
		DisabledBackground = Background,
		RolloverBackground = RolloverBackground,
		PressedBackground = PressedBackground,
	}, button_panel, nil, nil, "NumberArrow")
	local bottom_btn = g_Classes.XTextButton:new({
		Dock = "bottom",
		OnPress = down_pressed,
		Padding = box(1, 1, 1, 2),
		Icon = "CommonAssets/UI/arrowdown-40.tga",
		IconScale = IconScale,
		IconColor = IconColor,
		DisabledIconColor = DisabledIconColor,
		Background = Background,
		DisabledBackground = Background,
		RolloverBackground = RolloverBackground,
		PressedBackground = PressedBackground,
	}, button_panel, nil, nil, "NumberArrow")
	local edit = g_Classes.XEdit:new({Id = id, Dock = "box"}, parent)
	return edit, top_btn, bottom_btn
end
