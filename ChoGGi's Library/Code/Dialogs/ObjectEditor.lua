-- See LICENSE for terms

-- Used to do minimal editing of objects (or all of same type)

local ChoGGi_Funcs = ChoGGi_Funcs
local tostring, type, table = tostring, type, table

local IsPoint = IsPoint
local CmpLower = CmpLower

local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local RetName = ChoGGi_Funcs.Common.RetName
local DebugGetInfo = ChoGGi_Funcs.Common.DebugGetInfo
local RetProperType = ChoGGi_Funcs.Common.RetProperType
local RetParamsParents = ChoGGi_Funcs.Common.RetParamsParents

local GetParentOfKind = ChoGGi_Funcs.Common.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_DlgObjectEditor")
end
DefineClass.ChoGGi_DlgObjectEditor = {
	__parents = {"ChoGGi_XWindow"},
	choices = {},
	obj = false,
	obj_name = false,
	sel = false,

	dialog_width = 750.0,
	dialog_height = 650.0,
}

function ChoGGi_DlgObjectEditor:Init(parent, context)
	local g_Classes = g_Classes

	self.obj_name = RetName(context.obj)

	self.obj = context.obj
	self.title = context.title or T(302535920001707--[[Edit]]) .. " " .. T(302535920001685--[[Object]]) .. ": " .. self.obj_name

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	-- checkboxes (ok checkbox, maybe do some more stuff here)
	self.idCheckboxArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idCheckboxArea",
		Dock = "top",
	}, self.idDialog)

	self.idAutoRefresh = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idAutoRefresh",
		Text = T(302535920000084--[[Auto-Refresh]]),
		RolloverText = T(302535920001257--[[Auto-refresh list every second.]]),
		Dock = "left",
		Margins = box(4, 0, 0, 0),
		OnChange = self.idAutoRefresh_OnChange,
	}, self.idCheckboxArea)

	self.idButtonArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idButtonArea",
		Dock = "top",
	}, self.idDialog)

	self.idRefresh = g_Classes.ChoGGi_XButton:new({
		Id = "idRefresh",
		Text = T(302535920001687--[[Refresh]]),
		Dock = "left",
		MinWidth = 80,
		RolloverText = T(302535920000092--[[Updates list with any changed values.]]),
		OnPress = self.UpdateListContent,
	}, self.idButtonArea)

	self.idGoto = g_Classes.ChoGGi_XButton:new({
		Id = "idGoto",
		Text = T(302535920000093--[[Goto Obj]]),
		Dock = "left",
		MinWidth = 90,
		RolloverText = T(302535920000094--[[View/select object on map.]]),
		OnPress = self.idGoto_OnPress,
	}, self.idButtonArea)

	self.idAddNew = g_Classes.ChoGGi_XButton:new({
		Id = "idAddNew",
		Text = T(302535920001356--[[New]]),
		Dock = "left",
		RolloverText = T{302535920000041--[["Add new entry to <color ChoGGi_green><str></color> (Defaults to name/value of selected item)."]],
			str = self.obj_name,
		},
		OnPress = self.idAddNew_OnPress,
	}, self.idButtonArea)

	self.idApplyAll = g_Classes.ChoGGi_XButton:new({
		Id = "idApplyAll",
		Text = T(302535920000099--[[Apply To All]]),
		Dock = "left",
		MinWidth = 100,
		RolloverText = T(302535920000100--[[Apply selected value to all objects of the same type.]]),
		OnPress = self.idApplyAll_OnPress,
	}, self.idButtonArea)

	self:AddScrollList()

	self.idList.OnMouseButtonDown = self.idList_OnMouseButtonDown
	self.idList.OnMouseButtonDoubleClick = self.idList_OnMouseButtonDoubleClick

	self.idEditArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idEditArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idEditValue = g_Classes.ChoGGi_XTextInput:new({
		Id = "idEditValue",
		RolloverText = T(302535920000102--[[Use to change values of selected list item.]]),
		Hint = Translate(302535920000103--[[Edit Value]]),
		OnTextChanged = self.idEditValue_OnTextChanged,
	}, self.idEditArea)

	-- update item list
	self:UpdateListContent()

	self:PostInit(context.parent)
end

function ChoGGi_DlgObjectEditor:idGoto_OnPress()
	ViewAndSelectObject(GetRootDialog(self).obj)
end

function ChoGGi_DlgObjectEditor:idList_OnMouseButtonDoubleClick()
	self = GetRootDialog(self)
	if self.idList.focused_item and type(self.sel.object) == "table" then
		ChoGGi_Funcs.Common.OpenInObjectEditorDlg(self.sel.object, self)
	end
end

function ChoGGi_DlgObjectEditor:idApplyAll_OnPress()
	self = GetRootDialog(self)
	if self.sel and self.sel.value then
		GetRealm(self):MapForEach(true, self.obj.class, function(o)
			o[self.sel.text] = RetProperType(self.sel.value)
		end)
	end
end

-- update edit text box with selected value
function ChoGGi_DlgObjectEditor:idList_OnMouseButtonDown(pt, button, ...)
	g_Classes.ChoGGi_XList.OnMouseButtonDown(self, pt, button)
	self = GetRootDialog(self)
	if not self.idList.focused_item then
		return
	end
	self.sel = self.idList[self.idList.focused_item].item
	-- update the edit value box
	self.idEditValue:SetText(self.sel.value)
	self.idEditValue:SetFocus()
end

function ChoGGi_DlgObjectEditor:idAddNew_OnPress()
	self = GetRootDialog(self)
	local sel_name
	local sel_value
	if self.sel then
		sel_name = self.sel.text
		sel_value = self.sel.value
	else
		sel_name = T(302535920001727--[[NONE]])
		sel_value = false
	end
	local item_list = {
		{text = T(302535920000095--[[New Entry]]), value = sel_name, hint = T(302535920000096--[[Enter the name of the new entry to be added.]])},
		{text = T(302535920000097--[[New Value]]), value = sel_value, hint = T(302535920000098--[[Set the value of the new entry to be added.]])},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
--~ 		ex(choice)

--~ 		-- add it to the actual object
--~ 		print(self.obj[tostring(value)])
--~ 		print(choice[2].value, type(choice[2].value))
--~ 		print(RetProperType(choice[2].value))

		self.obj[tostring(value)] = RetProperType(choice[2].value)
		-- refresh list
		self:UpdateListContent()
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000095--[[New Entry]]),
		custom_type = 4,
	}
end

function ChoGGi_DlgObjectEditor:idEditValue_OnTextChanged()
	self = GetRootDialog(self)

	if not self.idList.focused_item then
		return
	end
	local sel_idx = self.idList.focused_item
	--
	local edit_text = self.idEditValue:GetText()
	local edit_value, edit_type = RetProperType(edit_text)
	local obj_value = self.obj[self.idList[sel_idx].item.text]
	local obj_type = type(obj_value)
	-- only update strings/numbers/boolean/nil
	if obj_type == "table" or obj_type == "userdata" or obj_type == "function" or obj_type == "thread" then
		return
	end

	-- If types match then we're fine, or nil if we're removing something
	if obj_type == edit_type or edit_type == "nil" or
			--false bools can be made a string or num
			(obj_value == false and edit_type == "string" or edit_type == "number") or
			--strings can be numbers or bools
			(obj_type == "string" and edit_type == "number" or edit_type == "boolean") or
			--numbers can be false
			(obj_type ~= "number" and edit_type ~= "boolean") then
		-- list item
		self.idList[sel_idx].item.value = edit_text
		self.idList[sel_idx][1]:SetText(self.idList[sel_idx].item.text .. " = " .. edit_text)
		-- stored obj
		self.items[sel_idx].value = edit_text
		-- actual object
		local value = self.obj[self.idList[sel_idx].item.text]
		if value == false or value then
			self.obj[self.idList[sel_idx].item.text] = edit_value
		end
	end
end

function ChoGGi_DlgObjectEditor:idAutoRefresh_OnChange()
	self = GetRootDialog(self)
	-- If already running then stop and return
	if IsValidThread(self.autorefresh_thread) then
		DeleteThread(self.autorefresh_thread)
		return
	end
	-- otherwise fire it up
	self.autorefresh_thread = CreateRealTimeThread(function()
		local Sleep = Sleep
		while true do
			if self.obj then
				self:UpdateListContent()
			else
				Halt()
			end
			Sleep(1000)
		end
	end)
end

function ChoGGi_DlgObjectEditor:OnKbdKeyDown(_, vk)
	local const = const
	if vk == const.vkEsc then
		self.idCloseX:Press()
		return "break"
	elseif vk == const.vkEnter then
		local origsel = self.idList.last_selected
		self:UpdateListContent()
		self.idList:SetSelection(origsel, true)
		return "break"
	end
	return "continue"
end

function ChoGGi_DlgObjectEditor:BuildList()
--~ 		self.idList:Clear()
	table.iclear(self.idList)
	for i = 1, #self.items do
		local item = self.items[i]
		if item then
			local listitem = self.idList:CreateTextItem(item.text .. " = " .. item.value)
			listitem.item = item
		end
	end
end

function ChoGGi_DlgObjectEditor:UpdateListContent()
	self = GetRootDialog(self)
	local obj = self.obj
	-- get scroll pos
	local scroll_x = self.idList.PendingOffsetX or 0
	local scroll_y = self.idList.PendingOffsetY or 0
	local scroll_bar = self.idScrollV.Scroll

	-- create prop list for list
	self.items = self:CreatePropList(obj)
	if self.items then
		-- populate it
		self:BuildList()
		-- and scroll to old pos
		self.idList:ScrollTo(scroll_x, scroll_y)
		self.idScrollV:SetScroll(scroll_bar)
	else
		-- let user know
		self.idList:Clear()
		local err = T{302535920000090--[["Error opening: <color ChoGGi_red><obj_name></color>"]],
			obj_name = self.obj_name,
		}
		local listitem = self.idList:CreateTextItem(err)
		listitem.RolloverText = err
	end
end

function ChoGGi_DlgObjectEditor:CreateProp(obj)
	local obj_type = type(obj)

	if obj_type == "function" then
		return DebugGetInfo(obj)
	end

	if IsValid(obj) then
		local x, y, z = obj:GetVisualPosXYZ()
		return obj.class .. " @ (" .. x .. ", " .. y .. ", " .. z .. ")"
	end

	if IsPoint(obj) then
		local x, y, z = obj:xyz()
		if z then
			return "(" .. x .. ", " .. y .. ", " .. z .. ")"
		else
			return "(" .. x .. ", " .. y .. ")"
		end
	end

	if obj_type == "thread" then
		return tostring(obj)
	end

	if obj_type == "string" then
		return obj
	end

	--local meta = getmetatable(obj)
	if obj_type == "table" then
--~ 		-- objlist ftw?
--~ 		if meta and meta == objlist then
--~ 			local res = {}
--~ 			for i = 1, Min(#obj, 3) do
--~ 				res[i] = self:CreateProp(obj[i])
--~ 			end
--~ 			if obj[4] then
--~ 				res[#res+1] = "..."
--~ 			end
--~ 			return "objlist{" .. table.concat(res, ", ") .. "}"
--~ 		end

		if IsT(obj) then
			return "T(\"" .. Translate(obj) .. "\")"
		else
			-- regular table
			local table_data
			local is_next = next(obj)
			local len = #obj

			if len > 0 and is_next then
				-- next works for both
				table_data = len .. " / " .. T(302535920001057--[[Data]])
			elseif is_next then
				-- ass based
				table_data = T(302535920001057--[[Data]])
			else
				-- blank table
				table_data = 0
			end

			local name = RetName(obj)
			if obj.class and name ~= obj.class then
				name = obj.class .. " (len: " .. table_data .. ", " .. name .. ")"
			else
				name = name .. " (len: " .. table_data .. ")"
			end

			return name
		end
	end

	return tostring(obj)
end

function ChoGGi_DlgObjectEditor:CreatePropList(obj)
	if type(obj) == "table" then
		local res = {}
		local sort = {}
		local c = 0
		for k, v in pairs(obj) do
			-- pretty colours (red for func, blue for tables)
			local sort_prop = self:CreateProp(k)
			local text
			local v_type = type(v)
			if v_type == "table" then
				text = "<color 150 170 250>" .. sort_prop .. "</color>"
			elseif v_type == "function" then
				text = "<color 255 150 150>" .. sort_prop .. "</color>"
			else
				text = sort_prop
			end

			c = c + 1
			res[c] = {
				sort = sort_prop,
				text = text,
				value = self:CreateProp(v),
				object = v
			}
			if type(k) == "number" then
				sort[res[c]] = k
			end
		end

		table.sort(res, function(a, b)
			if sort[a] and sort[b] then
				return sort[a] < sort[b]
			end
			if sort[a] or sort[b] then
				return sort[a] and true
			end
			return CmpLower(a.sort, b.sort)
		end)

		return res
	else
		return self:CreateProp(res)
	end
end

function ChoGGi_DlgObjectEditor:Done()
	DeleteThread(self.autorefresh_thread)
end

-- Use to open a dialog
function ChoGGi_Funcs.Common.OpenInObjectEditorDlg(obj, parent, title, ...)
	-- If fired from action menu
	if IsKindOf(obj, "XAction") then
		obj = ChoGGi_Funcs.Common.SelObject()
		parent = nil
		title = nil
	else
		obj = obj or ChoGGi_Funcs.Common.SelObject()
	end

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
	params.title = title

	return ChoGGi_DlgObjectEditor:new({}, terminal.desktop, params)
end

