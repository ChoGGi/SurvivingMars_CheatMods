-- See LICENSE for terms

-- used to do minimal editing of objects (or all of same type)

local S
local TableConcat
local RetName
local DebugGetInfo
local Trans
local GetParentOfKind
local RetProperType

local tostring,type,table = tostring,type,table
local StringFormat = string.format

local IsPoint = IsPoint
local Min = Min
local CmpLower = CmpLower

function OnMsg.ClassesGenerate()
	S = ChoGGi.Strings
	TableConcat = ChoGGi.ComFuncs.TableConcat
	RetName = ChoGGi.ComFuncs.RetName
	DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	Trans = ChoGGi.ComFuncs.Translate
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
	RetProperType = ChoGGi.ComFuncs.RetProperType
end

local GetRootDialog = function(obj)
	return GetParentOfKind(obj,"ChoGGi_ObjectManipulatorDlg")
end
DefineClass.ChoGGi_ObjectManipulatorDlg = {
	__parents = {"ChoGGi_Window"},
	choices = {},
	obj = false,
	obj_name = false,
	sel = false,

	dialog_width = 750.0,
	dialog_height = 650.0,
}

function ChoGGi_ObjectManipulatorDlg:Init(parent, context)
	local g_Classes = g_Classes

	self.obj_name = RetName(context.obj)
	self.obj = context.obj
	self.title = StringFormat("%s: %s",S[302535920000471--[[Object Manipulator--]]],self.obj_name)

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	-- checkboxes (ok checkbox, maybe do some more shit here)
	self.idCheckboxArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idCheckboxArea",
		Dock = "top",
	}, self.idDialog)

	self.idAutoRefresh = g_Classes.ChoGGi_CheckButton:new({
		Id = "idAutoRefresh",
		Text = S[302535920000084--[[Auto-Refresh--]]],
		RolloverText = S[302535920001257--[[Auto-refresh list every second.--]]],
		Dock = "left",
		RolloverAnchor = "top",
		Margins = box(4,0,0,0),
		OnChange = self.idAutoRefreshToggle,
	}, self.idCheckboxArea)

	self.idButtonArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonArea",
		Dock = "top",
	}, self.idDialog)

	self.idRefresh = g_Classes.ChoGGi_Button:new({
		Id = "idRefresh",
		Text = S[1000220--[[Refresh--]]],
		Dock = "left",
		MinWidth = 80,
		RolloverText = S[302535920000092--[[Updates list with any changed values.--]]],
		RolloverAnchor = "top",
		OnPress = self.UpdateListContent,
	}, self.idButtonArea)

	self.idGoto = g_Classes.ChoGGi_Button:new({
		Id = "idGoto",
		Text = S[302535920000093--[[Goto Obj--]]],
		Dock = "left",
		MinWidth = 90,
		RolloverText = S[302535920000094--[[View/select object on map.--]]],
		RolloverAnchor = "top",
		OnPress = self.idGotoOnPress,
	}, self.idButtonArea)

	self.idAddNew = g_Classes.ChoGGi_Button:new({
		Id = "idAddNew",
		Text = S[302535920001356--[[New--]]],
		Dock = "left",
		RolloverText = S[302535920000041--[[Add new entry to %s (Defaults to name/value of selected item).--]]]:format(self.obj_name),
		RolloverAnchor = "top",
		OnPress = self.idAddNewOnPress,
	}, self.idButtonArea)

	self.idApplyAll = g_Classes.ChoGGi_Button:new({
		Id = "idApplyAll",
		Text = S[302535920000099--[[Apply To All--]]],
		Dock = "left",
		MinWidth = 100,
		RolloverText = S[302535920000100--[[Apply selected value to all objects of the same type.--]]],
		RolloverAnchor = "top",
		OnPress = self.idApplyAllOnPress,
	}, self.idButtonArea)

	self:AddScrollList()

	self.idList.OnMouseButtonDown = self.idListOnMouseButtonDown
	self.idList.OnMouseButtonDoubleClick = self.idListOnMouseButtonDoubleClick

	self.idEditArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idEditArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idEditValue = g_Classes.ChoGGi_TextInput:new({
		Id = "idEditValue",
		RolloverText = S[302535920000102--[[Use to change values of selected list item.--]]],
		Hint = S[302535920000103--[[Edit Value--]]],
		OnTextChanged = self.idEditValueOnTextChanged,
		RolloverAnchor = "bottom",
	}, self.idEditArea)

	self:SetInitPos(context.parent)

	-- update item list
	self:UpdateListContent()
end

function ChoGGi_ObjectManipulatorDlg:idGotoOnPress()
	ViewAndSelectObject(GetRootDialog(self).obj)
end

function ChoGGi_ObjectManipulatorDlg:idListOnMouseButtonDoubleClick()
	self = GetRootDialog(self)
	if self.idList.focused_item then
		ChoGGi.ComFuncs.OpenInObjectManipulatorDlg(self.sel.object,self)
	end
end

function ChoGGi_ObjectManipulatorDlg:idApplyAllOnPress()
	self = GetRootDialog(self)
	if self.sel and self.sel.value then
		MapForEach(true,self.obj.class,function(o)
			o[self.sel.text] = RetProperType(self.sel.value)
		end)
	end
end

-- update edit text box with selected value
function ChoGGi_ObjectManipulatorDlg:idListOnMouseButtonDown(pt,button,...)
	g_Classes.ChoGGi_List.OnMouseButtonDown(self,pt,button)
	self = GetRootDialog(self)
	if not self.idList.focused_item then
		return
	end
	self.sel = self.idList[self.idList.focused_item].item
	-- update the edit value box
	self.idEditValue:SetText(self.sel.value)
	self.idEditValue:SetFocus()
end

function ChoGGi_ObjectManipulatorDlg:idAddNewOnPress()
	self = GetRootDialog(self)
	local sel_name
	local sel_value
	if self.sel then
		sel_name = self.sel.text
		sel_value = self.sel.value
	else
		sel_name = S[3718--[[NONE--]]]
		sel_value = false
	end
	local ItemList = {
		{text = S[302535920000095--[[New Entry--]]],value = sel_name,hint = 302535920000096--[[Enter the name of the new entry to be added.--]]},
		{text = S[302535920000097--[[New Value--]]],value = sel_value,hint = 302535920000098--[[Set the value of the new entry to be added.--]]},
	}

	local function CallBackFunc(choice)
		if #choice < 1 then
			return
		end
		local value = choice[1].value

		-- add it to the actual object
		self.obj[tostring(value)] = RetProperType(choice[2].value)
		-- refresh list
		self:UpdateListContent()
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = ItemList,
		title = S[302535920000095--[[New Entry--]]],
		custom_type = 4,
	}
end

function ChoGGi_ObjectManipulatorDlg:idEditValueOnTextChanged()
	self = GetRootDialog(self)

	if not self.idList.focused_item then
		return
	end
	local sel_idx = self.idList.focused_item
	--
	local edit_text = self.idEditValue:GetText()
	local edit_value,edit_type = RetProperType(edit_text)
	local obj_value = self.obj[self.idList[sel_idx].item.text]
	local obj_type = type(obj_value)
	-- only update strings/numbers/boolean/nil
	if obj_type == "table" or obj_type == "userdata" or obj_type == "function" or obj_type == "thread" then
		return
	end

	-- if types match then we're fine, or nil if we're removing something
	if obj_type == edit_type or edit_type == "nil" or
			--false bools can be made a string or num
			(obj_value == false and edit_type == "string" or edit_type == "number") or
			--strings can be numbers or bools
			(obj_type == "string" and edit_type == "number" or edit_type == "boolean") or
			--numbers can be false
			(obj_type ~= "number" and edit_type ~= "boolean") then
		-- list item
		self.idList[sel_idx].item.value = edit_text
		self.idList[sel_idx][1]:SetText(StringFormat("%s = %s",self.idList[sel_idx].item.text,edit_text))
		-- stored obj
		self.items[sel_idx].value = edit_text
		-- actual object
		local value = self.obj[self.idList[sel_idx].item.text]
		if value == false or value then
			self.obj[self.idList[sel_idx].item.text] = edit_value
		end
	end
end

function ChoGGi_ObjectManipulatorDlg:idAutoRefreshToggle()
	self = GetRootDialog(self)
	-- if already running then stop and return
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

function ChoGGi_ObjectManipulatorDlg:OnKbdKeyDown(_, vk)
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

function ChoGGi_ObjectManipulatorDlg:BuildList()
	self.idList:Clear()
	for i = 1, #self.items do
		local listitem = self.idList:CreateTextItem(StringFormat("%s = %s",self.items[i].text,self.items[i].value))
		listitem.item = self.items[i]
	end
end

function ChoGGi_ObjectManipulatorDlg:UpdateListContent()
	self = GetRootDialog(self)
	local obj = self.obj
	-- get scroll pos
	local scroll_x = self.idScrollArea.OffsetX
	local scroll_y = self.idScrollArea.OffsetY

	-- create prop list for list
	self.items = self:CreatePropList(obj)
	if self.items then
		-- populate it
		self:BuildList()
		-- and scroll to old pos
		self.idScrollArea:ScrollTo(scroll_x,scroll_y)
	else
		-- let user know
		self.idList:Clear()
		local err = S[302535920000090--[[Error opening: %s--]]]:format(self.obj_name)
		local listitem = self.idList:CreateTextItem(err)
		listitem.RolloverText = err
	end
end

function ChoGGi_ObjectManipulatorDlg:CreateProp(obj)
	local objlist = objlist
	local obj_type = type(obj)

	if obj_type == "function" then
		return DebugGetInfo(obj)
	end

	if IsValid(obj) then
		local x,y,z = obj:GetVisualPosXYZ()
		return StringFormat("%s @ (%s,%s,%s)",obj.class,x,y,z)
	end

	if IsPoint(obj) then
		return StringFormat("(%s,%s,%s)",obj:x(),obj:y(),obj:z())
	end

	if obj_type == "thread" then
		return tostring(obj)
	end

	if obj_type == "string" then
		return obj
	end

	local meta = getmetatable(obj)
	if obj_type == "table" then
		-- objlist ftw?
		if meta and meta == objlist then
			local res = {}
			for i = 1, Min(#obj, 3) do
				res[i] = self:CreateProp(obj[i])
			end
			if #obj > 3 then
				res[#res+1] = "..."
			end
			return StringFormat("objlist{%s}","",TableConcat(res,", "))
		end

		if IsT(obj) then
			return StringFormat([[T{"%s"}]],Trans(obj))
		else
			-- regular table
			local table_data
			local is_next = next(obj)
			local len = #obj

			if len > 0 and is_next then
				-- next works for both
				table_data = StringFormat("%s / %s",len,S[302535920001057--[[Data--]]])
			elseif is_next then
				-- ass based
				table_data = S[302535920001057--[[Data--]]]
			else
				-- blank table
				table_data = 0
			end

			local name = RetName(obj)
			if obj.class and name ~= obj.class then
				name = StringFormat("%s (len: %s, %s)",obj.class,table_data,name)
			else
				name = StringFormat("%s (len: %s)",name,table_data)
			end

			return name
		end
	end

	return tostring(obj)
end

function ChoGGi_ObjectManipulatorDlg:CreatePropList(obj)
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
				text = StringFormat("<color 150 170 250>%s</color>",sort_prop)
			elseif v_type == "function" then
				text = StringFormat("<color 255 150 150>%s</color>",sort_prop)
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

function ChoGGi_ObjectManipulatorDlg:Done(result)
	DeleteThread(self.autorefresh_thread)
	ChoGGi_Window.Done(self,result)
end
