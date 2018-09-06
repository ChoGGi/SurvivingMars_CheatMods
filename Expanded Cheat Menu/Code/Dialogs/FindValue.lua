-- See LICENSE for terms

-- search through tables for values and display them in an examine dialog

-- nope not hacky at all
local is_loaded
function OnMsg.ChoGGi_Library_Loaded()
	if is_loaded then
		return
	end
	is_loaded = true
	-- nope nope nope

	local S = ChoGGi.Strings
	local RetName = ChoGGi.ComFuncs.RetName

	DefineClass.ChoGGi_FindValueDlg = {
		__parents = {"ChoGGi_Window"},
		obj = false,
		obj_name = false,
		dialog_width = 700.0,
		dialog_height = 110.0,

		found_objs = false,
	}

	function ChoGGi_FindValueDlg:Init(parent, context)
		local g_Classes = g_Classes

		self.obj = context.obj
		self.obj_name = RetName(self.obj)
		self.title = string.format("%s: %s",S[302535920001305--[[Find Within--]]],self.obj_name)

		-- By the Power of Grayskull!
		self:AddElements(parent, context)

		self.idTextArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idTextArea",
			Dock = "top",
		}, self.idDialog)

		self.idEdit = g_Classes.ChoGGi_TextInput:new({
			Id = "idEdit",
			Dock = "left",
			MinWidth = 550,
			RolloverText = S[302535920001303--[[Search for text within %s.--]]]:format(self.obj_name),
			Hint = S[302535920001306--[[Enter text to find--]]],
			OnKbdKeyDown = function(obj, vk)
				return self:idEditOnKbdKeyDown(obj, vk)
			end,
		}, self.idTextArea)
		-- focus on textbox
		self.idEdit:SetFocus()

		self.idLimit = g_Classes.ChoGGi_TextInput:new({
			Id = "idLimit",
			Dock = "right",
			MinWidth = 50,
			RolloverText = S[302535920001304--[[Set how many levels within this table we check into (careful making it too large).--]]],
		}, self.idTextArea)
		self.idLimit:SetText("1")

		self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
			Id = "idButtonContainer",
			Dock = "bottom",
		}, self.idDialog)

		self.idFind = g_Classes.ChoGGi_Button:new({
			Id = "idFind",
			Dock = "left",
			Text = S[302535920001302--[[Find--]]],
			RolloverText = S[302535920001303--[[Search for text within %s.--]]]:format(self.obj_name),
			Margins = box(10, 0, 0, 0),
			OnPress = function()
				self:FindText()
			end,
		}, self.idButtonContainer)

		self.idCaseSen = g_Classes.ChoGGi_CheckButton:new({
			Id = "idCaseSen",
			Dock = "left",
			RolloverAnchor = "bottom",
			Margins = box(15, 0, 0, 0),
			Text = S[302535920000501--[[Case-sensitive--]]],
			RolloverText = S[302535920000502--[[Treat uppercase and lowercase as distinct.--]]],
		}, self.idButtonContainer)

		self.idCancel = g_Classes.ChoGGi_Button:new({
			Id = "idCancel",
			Dock = "right",
			MinWidth = 80,
			Text = S[6879--[[Cancel--]]],
			RolloverText = S[302535920000074--[[Cancel without changing anything.--]]],
			Margins = box(0, 0, 10, 0),
			OnPress = self.idCloseX.OnPress,
		}, self.idButtonContainer)

		self:SetInitPos(context.parent)
	end

	function ChoGGi_FindValueDlg:FindText()
		local str = self.idEdit:GetText()
		-- no sense in finding nothing
		if str == "" then
			return
		end

		local case = self.idCaseSen:GetCheck()

		if not case then
			str = str:lower()
		end

		-- always start off empty
		self.found_objs = {}

		-- build our list of objs
		self:RetObjects(
			self.obj,
			str,
			case,
			tonumber(self.idLimit:GetText()) or 1
		)

		-- and fire off a new dialog
		ChoGGi.ComFuncs.OpenInExamineDlg(self.found_objs):SetPos(self:GetPos()+point(0,self.header))
	end

	local function ReturnStr(obj,case)
		local obj_type = type(obj)
		if obj_type == "string" then
			return case and obj or obj:lower(), obj_type
	--~ 		if case then
	--~ 			return obj, obj_type
	--~ 		else
	--~ 			return obj:lower(), obj_type
	--~ 		end
		else
			return case and tostring(obj) or tostring(obj):lower(), obj_type
	--~ 		if case then
	--~ 			return tostring(obj), obj_type
	--~ 		else
	--~ 			return tostring(obj):lower(), obj_type
	--~ 		end
		end
	end

	function ChoGGi_FindValueDlg:RetObjects(obj,str,case,limit,level)
		if not level then
			level = 0
		end
		if level > limit then
			return
		end

		if type(obj) == "table" then
			local name1 = RetName(obj)
			local name2 = tostring(obj)
			local obj_string
			if name1 == name2 then
				obj_string = string.format("%s: %s",S[302535920001307--[[L%s--]]]:format(level),name1)
			else
				obj_string = string.format("%s: %s (%s)",S[302535920001307--[[L%s--]]]:format(level),name1,name2)
			end
			for key,value in pairs(obj) do
				local key_str,key_type = ReturnStr(key,case)
				local value_str,value_type = ReturnStr(value,case)

				if key_str:find(str,1,true) or value_str:find(str,1,true) then
	--~ 			if key_str:find_lower(str) or value_str:find_lower(str) then
					-- makes dupes
					-- self.found_objs[#self.found_objs+1] = obj
					-- should be decent enough?
					if not self.found_objs[obj_string] then
						self.found_objs[obj_string] = obj
					end
				else
					if key_type == "table" then
						self:RetObjects(key,str,case,limit,level+1)
					elseif value_type == "table" then
						self:RetObjects(value,str,case,limit,level+1)
					end
				end

			end
		end

	end --RetObjects

	function ChoGGi_FindValueDlg:idEditOnKbdKeyDown(obj,vk)
		if vk == const.vkEnter then
			self:FindText()
			return "break"
		elseif vk == const.vkEsc then
			self.idCloseX:Press()
			return "break"
		end
		return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
	end

end
