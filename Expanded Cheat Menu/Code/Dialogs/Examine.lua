-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName
local ShowMe = ChoGGi.ComFuncs.ShowMe
local TableConcat = ChoGGi.ComFuncs.TableConcat
local T = ChoGGi.ComFuncs.Translate
local S = ChoGGi.Strings
local blacklist = ChoGGi.blacklist

local pairs,type,tostring,tonumber,rawget,table,debug = pairs,type,tostring,tonumber,rawget,table,debug

local CmpLower = CmpLower
local GetStateName = GetStateName
local IsPoint = IsPoint
local IsValid = IsValid
local IsValidEntity = IsValidEntity

transp_mode = rawget(_G, "transp_mode") or false
local HLEnd = "</h></color>"
--~ Transparency

local white = white
local black = black

DefineClass.Examine = {
	__parents = {"ChoGGi_Window"},
	-- clickable purple text
	onclick_handles = {},
	-- what we're examining
	obj = false,

	dialog_width = 650.0,
	dialog_height = 750.0,

	parents_menu_popup = false,
	attaches_menu_popup = false,
}

function Examine:Init(parent, context)
	local ChoGGi = ChoGGi
	local g_Classes = g_Classes
	local const = const

	-- any self. values from :new()
	self.obj = context.obj

	-- reset any marked objects
	if not self.obj then
		ChoGGi.ComFuncs.ClearShowMe()
	end

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	-- everything grouped gets a window to go in
	self.idLinkArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idLinkArea",
		Dock = "top",
	}, self.idDialog)

	self.idLinks = g_Classes.ChoGGi_Text:new({
		Id = "idLinks",
		Dock = "left",
		VAlign = "top",
		FontStyle = "Editor14",
		OnHyperLink = function(_, link, _, box, pos, button)
			self.onclick_handles[tonumber(link)](box, pos, button)
		end,
	}, self.idLinkArea)
	self.idLinks:AddInterpolation{
		type = const.intAlpha,
		startValue = 255,
		flags = const.intfIgnoreParent
	}

	self.idAutoRefresh = g_Classes.ChoGGi_CheckButton:new({
		Id = "idAutoRefresh",
		Dock = "right",
		Text = S[302535920000084--[[Auto-Refresh--]]],
		RolloverText = S[302535920001257--[[Auto-refresh list every second.--]]],
		OnChange = function()
			self:idAutoRefreshToggle()
		end,
	}, self.idLinkArea)

	self.idFilterArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idFilterArea",
		Dock = "top",
	}, self.idDialog)

	self.idFilter = g_Classes.ChoGGi_TextInput:new({
		Id = "idFilter",
		RolloverText = S[302535920000043--[["Scrolls to text entered (press Enter to scroll between found text, Up arrow to scroll to top)."--]]],
		Hint = S[302535920000044--[[Go To Text--]]],
		OnTextChanged = function()
			self:FindNext(self.idFilter:GetText())
		end,
		OnKbdKeyDown = function(obj, vk)
			return self:idFilterOnKbdKeyDown(obj, vk)
		end,
	}, self.idFilterArea)

	self.idMenuArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idMenuArea",
		Dock = "top",
	}, self.idDialog)

	local tools_menu_popup = self:BuildToolsMenuPopup()
	self.idTools = g_Classes.ChoGGi_ComboButton:new({
		Id = "idTools",
		Text = S[302535920000239--[[Tools--]]],
		RolloverText = S[302535920000045--[["Scrolls down one line or scrolls between text in ""Go to text"".

Right-click to scroll to top."--]]],
		OnMouseButtonDown = function(obj,pt,button,...)
			g_Classes.ChoGGi_ComboButton.OnMouseButtonDown(obj,pt,button,...)
			if button == "L" then
				PopupToggle(obj,"idToolsMenu",tools_menu_popup,"bottom")
			end
		end,
		Dock = "left",
	}, self.idMenuArea)

	self.idParents = g_Classes.ChoGGi_ComboButton:new({
		Id = "idParents",
		Text = S[302535920000520--[[Parents--]]],
		RolloverText = S[302535920000553--[[Examine parent and ancestor objects.--]]],
		OnMouseButtonDown = function(obj,pt,button,...)
			g_Classes.ChoGGi_ComboButton.OnMouseButtonDown(obj,pt,button,...)
			if button == "L" then
				PopupToggle(obj,"idParentsMenu",self.parents_menu_popup,"bottom")
			end
		end,
		Dock = "left",
	}, self.idMenuArea)
	self.idParents:SetVisible(false)

	self.idAttaches = g_Classes.ChoGGi_ComboButton:new({
		Id = "idAttaches",
		Text = S[302535920000053--[[Attaches--]]],
		RolloverText = S[302535920000054--[[Any objects attached to this object.--]]],
		OnMouseButtonDown = function(obj,pt,button,...)
			g_Classes.ChoGGi_ComboButton.OnMouseButtonDown(obj,pt,button,...)
			if button == "L" then
				PopupToggle(obj,"idAttachesMenu",self.attaches_menu_popup,"bottom")
			end
		end,
		Dock = "left",
	}, self.idMenuArea)
	self.idAttaches:SetVisible(false)

	self.idNext = g_Classes.ChoGGi_Button:new({
		Id = "idNext",
		Text = S[1000232--[[Next--]]],
		Dock = "right",
		RolloverAnchor = "right",
		RolloverText = S[302535920000045--[["Scrolls down one line or scrolls between text in ""Go to text"".

Right-click to scroll to top."--]]],
		OnMouseButtonDown = function(obj,pt,button,...)
			g_Classes.ChoGGi_Button.OnMouseButtonDown(obj,pt,button,...)
			if button == "L" then
				self:FindNext(self.idFilter:GetText())
			else
				self.idScrollArea:ScrollTo(0,0)
			end
		end,
	}, self.idMenuArea)

	-- text box with obj info in it
	self:AddScrollText()

	-- look at them sexy internals
	self.transp_mode = transp_mode
	self:SetTranspMode(self.transp_mode)

	-- load up obj in text display
	self:SetObj(self.obj)

	-- needs a bit of a delay since we delay in SetObj
	if ChoGGi.UserSettings.FlashExamineObject and IsKindOf(self.obj,"XWindow") and self.obj.class ~= "InGameInterface" then
		self:FlashWindow(self.obj)
	end

	self:SetInitPos(context.parent)

end

function Examine:idAutoRefreshToggle()
	-- if it's called directly we set the check if needed
	local checked = self.idAutoRefresh:GetCheck()

	-- if already running then stop and return
	if IsValidThread(self.autorefresh_thread) then

		if checked then
			self.idAutoRefresh:SetCheck(false)
		end
		DeleteThread(self.autorefresh_thread)
		return
	end
	-- otherwise fire it up
	self.autorefresh_thread = CreateRealTimeThread(function()
		if not checked then
			self.idAutoRefresh:SetCheck(true)
		end
		local Sleep = Sleep
		while true do
			if self.obj then
				self:SetObj(self.obj,true)
			else
				Halt()
			end
			Sleep(1000)
		end
	end)

end

function Examine:idFilterOnKbdKeyDown(obj,vk)
	if vk == const.vkEnter then
		self:FindNext(self.idFilter:GetText())
		return "break"
	elseif vk == const.vkUp then
		self.idScrollArea:ScrollTo(0,0)
		return "break"
	elseif vk == const.vkDown then
		local v = self.idScrollV
		self.idScrollArea:ScrollTo(0,v.Max - (v.FullPageAtEnd and v.PageSize or 0))
		return "break"
	elseif vk == const.vkEsc then
		self.idCloseX:OnPress()
		return "break"
	end
	return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
end

local menu_added
local menu_list_items
-- adds class name then list of functions below
--~ local function BuildFuncList(obj_name,prefix)
function Examine:BuildFuncList(obj_name,prefix)
	prefix = prefix or ""
	local class = _G[obj_name] or empty_table
	local skip = true
	for key,_ in pairs(class) do
		if type(class[key]) == "function" then
			menu_list_items[Concat(prefix,obj_name,".",key,": ")] = class[key]
			skip = false
		end
	end
	if not skip then
		menu_list_items[Concat(prefix,obj_name)] = "\n\n\n"
	end
end

--~ local function ProcessList(list,prefix)
function Examine:ProcessList(list,prefix)
	for i = 1, #list do
		if not menu_added[list[i]] then
			-- CObject and Object are pretty much the same (Object has a couple more funcs)
			if list[i] == "CObject" then
				-- keep it for later (for the rare objects that use CObject, but not Object)
				menu_added[list[i]] = prefix
			else
				menu_added[list[i]] = true
				self:BuildFuncList(list[i],prefix)
			end
		end
	end
end

function Examine:BuildToolsMenuPopup()
	return {
		{
			name = Concat(S[302535920000004--[[Dump--]]]," ",S[1000145--[[Text--]]]),
			hint = S[302535920000046--[[dumps text to %sDumpedExamine.lua--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags
				str = str:gsub("<[/%s%a%d]*>","")
				ChoGGi.ComFuncs.Dump(Concat("\n",str),nil,"DumpedExamine","lua")
			end,
		},
		{
			name = Concat(S[302535920000004--[[Dump--]]]," ",S[298035641454--[[Object--]]]),
			hint = S[302535920001027--[[dumps object to %sDumpedExamineObject.lua

This can take time on something like the "Building" metatable--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = ValueToLuaCode(self.obj)
				ChoGGi.ComFuncs.Dump(Concat("\n",str),nil,"DumpedExamineObject","lua")
			end,
		},
		{
			name = Concat(S[302535920000048--[[View--]]]," ",S[1000145--[[Text--]]]),
			hint = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags
				str = str:gsub("<[/%s%a%d]*>","")
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					checkbox = true,
					text = str,
					title = Concat(S[302535920000048--[[View--]]],"/",S[302535920000004--[[Dump--]]]," ",S[1000145--[[Text--]]]),
					hint_ok = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump(Concat("\n",str),overwrite,"DumpedExamine","lua")
						end
					end,
				}
			end,
		},
		{
			name = Concat(S[302535920000048--[[View--]]]," ",S[298035641454--[[Object--]]]),
			hint = S[302535920000049--[["View text, and optionally dumps object to %sDumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = ValueToLuaCode(self.obj)
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					checkbox = true,
					text = str,
					title = Concat(S[302535920000048--[[View--]]],"/",S[302535920000004--[[Dump--]]]," ",S[298035641454--[[Object--]]]),
					hint_ok = 302535920000049--[["View text, and optionally dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]],
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump(Concat("\n",str),overwrite,"DumpedExamineObject","lua")
						end
					end,
				}
			end,
		},
		{name = "	 ---- "},
		{
			name = S[302535920001239--[[Functions--]]],
			hint = S[302535920001240--[[Show all functions of this object and parents/ancestors.--]]],
			clicked = function()
				menu_added = {}
				menu_list_items = {}

				self:ProcessList(self.parents,Concat(" ",S[302535920000520--[[Parents--]]],": "))
				self:ProcessList(self.ancestors,Concat(S[302535920000525--[[Ancestors--]]],": "))
				-- add examiner object with some spaces so it's at the top
				self:BuildFuncList(self.obj.class,"	")
				-- if Object hasn't been added, then add CObject
				if not menu_added.Object and menu_added.CObject then
					self:BuildFuncList("CObject",menu_added.CObject)
				end

				ChoGGi.ComFuncs.OpenInExamineDlg(menu_list_items,self)
			end,
		},
		{
			name = Concat(S[327465361219--[[Edit--]]]," ",S[298035641454--[[Object--]]]),
			hint = S[302535920000050--[[Opens object in Object Manipulator.--]]],
			clicked = function()
				ChoGGi.ComFuncs.OpenInObjectManipulatorDlg(self.obj,self)
			end,
		},
		{
			name = S[302535920001305--[[Find Within--]]],
			hint = S[302535920001303--[[Search for text within %s.--]]]:format(RetName(self.obj)),
			clicked = function()
				ChoGGi.ComFuncs.OpenInFindValueDlg(self.obj,self)
			end,
		},
		{
			name = S[302535920000323--[[Exec Code--]]],
			hint = S[302535920000052--[["Execute code (using console for output). ChoGGi.CurObj is whatever object is opened in examiner.
Which you can then mess around with some more in the console."--]]],
			clicked = function()
				ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj,self)
			end,
		},
		{name = "	 ---- "},
		{
			name = S[302535920001321--[[UI Click To Select--]]],
			hint = S[302535920001322--[["Allows you to inspect UI controls by clicking them.
This dialog will freeze till you click something."--]]],
			clicked = function()
				ChoGGi_TerminalRolloverMode(true,self)
			end,
		},
		{
			name = S[302535920000970--[[UI Flash--]]],
			hint = S[302535920000972--[["Toggle flashing the UI object being examined.
This may temporarily add some extra values to objects (BorderWidth/BorderColor)."--]]],
			clicked = function()
				ChoGGi.UserSettings.FlashExamineObject = not ChoGGi.UserSettings.FlashExamineObject
				ChoGGi.SettingFuncs.WriteSettings()
			end,
			value = "ChoGGi.UserSettings.FlashExamineObject",
			class = "ChoGGi_CheckButtonMenu",
		},
	}
end

function Examine:FindNext(filter)
	local drawBuffer = self.idText.draw_cache or empty_table
	local current_y = self.idScrollArea.OffsetY
	local min_match, closest_match = false, false
	for y, list_draw_info in pairs(drawBuffer) do
		for i = 1, #list_draw_info do
			local draw_info = list_draw_info[i]
			if draw_info.text and draw_info.text:find_lower(filter) then
				if not min_match or y < min_match then
					min_match = y
				end
				if y > current_y and (not closest_match or y < closest_match) then
					closest_match = y
				end
			end
		end
	end
	if closest_match or min_match then
		self.idScrollArea:ScrollTo(0, (closest_match or min_match))
	end
end

do -- FlashWindow
	local flashing_table = {}
	local black,white = black,white
	local Sleep = Sleep
	local Invalidate = UIL.Invalidate

	function Examine:FlashWindow(obj)
		obj = obj or self.obj

		-- always kill off old thread and reset colours, else they may get stuck
		if flashing_table.thread then
			DeleteThread(flashing_table.thread)
			obj.BorderWidth = flashing_table.width
			obj.BorderColor = flashing_table.colour
		end

		flashing_table.thread = CreateRealTimeThread(function()
			flashing_table.width = obj.BorderWidth
			flashing_table.colour = obj.BorderColor

			obj.BorderWidth = 2
			local c = black
			for _ = 1, 6 do
				if obj.window_state == "destroying" then
					break
				end
				obj.BorderColor = c
				Invalidate()
				Sleep(100)
				c = c == black and white or black
			end
			if obj.window_state ~= "destroying" then
				obj.BorderWidth = flashing_table.width
				obj.BorderColor = flashing_table.colour
				table.clear(flashing_table)
				Invalidate()
			end
		end)
	end
end -- do

function Examine:SetTranspMode(toggle)
	self:ClearModifiers()
	if toggle then
		self:AddInterpolation{
			type = const.intAlpha,
			startValue = 32
		}
		self.idLinks:AddInterpolation{
			type = const.intAlpha,
			startValue = 200,
			flags = const.intfIgnoreParent
		}
	end
	-- update global value (for new windows)
	transp_mode = toggle
end
--

local function Examine_valuetotextex(_, _, button,obj,self)
	if button == "L" then
		ChoGGi.ComFuncs.OpenInExamineDlg(obj, self)
	elseif IsValid(obj) then
		ShowMe(obj)
	end
end

function Examine:valuetotextex(obj)
	local objlist = objlist
	local obj_type = type(obj)

	if obj_type == "function" then

		if blacklist then
			return Concat(
				self:HyperLink(function(_,_,button)
					Examine_valuetotextex(_,_,button,obj,self)
				end),
				ChoGGi.ComFuncs.DebugGetInfo(obj),
				HLEnd
			)
		else
			local debug_info = debug.getinfo(obj, "Sn")
			return Concat(
				self:HyperLink(function(_,_,button)
					Examine_valuetotextex(_,_,button,obj,self)
				end),
				tostring(debug_info.name or debug_info.name_what or S[302535920000063--[[unknown name--]]]),
				"@",
				debug_info.short_src,
				"(",
				debug_info.linedefined,
				")",
				HLEnd
			)
		end

	elseif obj_type == "thread" then
		return Concat(
			self:HyperLink(function(_,_,button)
				Examine_valuetotextex(_,_,button,obj,self)
			end),
			tostring(obj),
			HLEnd
		)

	elseif obj_type == "string" then
		return Concat(
			"'",
			obj,
			-- some translated stuff has <color in it, so we make sure they don't bother the rest
			"</color></color>'"
		)

	-- point() is userdata (keep before it)
	elseif IsPoint(obj) then
		return Concat(
			self:HyperLink(function()
				ShowMe(obj)
			end),
			"(",obj:x(),",",obj:y(),",",obj:z() or terrain.GetHeight(obj),")",
			HLEnd
		)

	elseif obj_type == "userdata" then
		local str = tostring(obj)
		local trans = T(obj)
		-- if it isn't translatable then return a clickable link (not that useful, but it's highlighted)
		if trans == "stripped" or trans:find("Missing locale string id") then
			return Concat(
				self:HyperLink(function(_,_,button)
					Examine_valuetotextex(_,_,button,obj,self)
				end),
				str,
				HLEnd
			)
		else
			return Concat(
				trans,
				"</color></color> < \"",
				obj_type,
				"\""
			)
		end

	elseif obj_type == "table" then

		if IsValid(obj) then
			return Concat(
				self:HyperLink(function(_,_,button)
					Examine_valuetotextex(_,_,button,obj,self)
				end),
				obj.class,
				HLEnd,
				"@",
				self:valuetotextex(obj:GetPos())
			)

		else
			local len = #obj
			local meta_type = getmetatable(obj)

			-- if it's an objlist then we just return a list of the objects
			if meta_type and meta_type == objlist then
				local res = {
					self:HyperLink(function(_,_,button)
						Examine_valuetotextex(_,_,button,obj,self)
					end),
					"objlist",
					HLEnd,
					"{",
				}
				local c = #res
				for i = 1, Min(len, 3) do
					c = c + 1
					res[c] = i
					c = c + 1
					res[c] = " = "
					c = c + 1
					res[c] = self:valuetotextex(obj[i])
				end
				if len > 3 then
					c = c + 1
					res[c] = "..."
				end
				c = c + 1
				res[c] = ", "
				c = c + 1
				res[c] = "}"
				return TableConcat(res)
			else
				-- regular table
				local table_data
				local is_next = next(obj)

				if len > 0 and is_next then
					-- next works for both
					table_data = Concat(len," / ",S[302535920001057--[[Data--]]])
	--~			 elseif len > 0 then
	--~				 -- index based
	--~				 table_data = len
				elseif is_next then
					-- ass based
					table_data = S[302535920001057--[[Data--]]]
				else
					-- blank table
					table_data = 0
				end

				local name = RetName(obj)
				if obj.class and name ~= obj.class then
					name = Concat(obj.class," (len: ",table_data,", ",name,")")
				else
					name = Concat(name," (len: ",table_data,")")
				end

				return Concat(
					self:HyperLink(function(_,_,button)
						Examine_valuetotextex(_,_,button,obj,self)
					end),
					name,
					HLEnd
				)
			end
		end
	end

	return obj
end

function Examine:HyperLink(f, custom_color)
	self.onclick_handles[#self.onclick_handles+1] = f
	return Concat(
		(custom_color or "<color 150 170 250>"),
		"<h ",
		#self.onclick_handles,
		" 230 195 50>"
	)
end

---------------------------------------------------------------------------------------------------------------------
local function ExamineThreadLevel_totextex(level, info, obj,self)
	local data = {}
	if blacklist
 then
		data = {ChoGGi.ComFuncs.DebugGetInfo(obj)}
	else
		data = {}
		local l = 1
		while true do
			local name, val = debug.getlocal(obj, level, l)
			if name then
				data[name] = val
				l = l + 1
			else
				break
			end
		end
		for i = 1, info.nups do
			local name, val = debug.getupvalue(info.func, i)
			if name ~= nil and val ~= nil then
				data[Concat(name,"(up)")] = val
			end
		end
	end

	return function()
		ChoGGi.ComFuncs.OpenInExamineDlg(data, self)
	end
end

local function Examine_totextex(obj,self)
	ChoGGi.ComFuncs.OpenInExamineDlg(obj, self)
end

function Examine:totextex(obj,ChoGGi)
	local res = {}
	local sort = {}
	local obj_metatable = getmetatable(obj)
	local obj_type = type(obj)
	local is_table = obj_type == "table"
	local c = 0

	if is_table then

		for k, v in pairs(obj) do
			c = c + 1
			res[c] = Concat(
				self:valuetotextex(k),
				" = ",
				self:valuetotextex(v),
				"<left>"
			)
			if type(k) == "number" then
				sort[res[c]] = k
			end
		end

	elseif obj_type == "thread" then

		if blacklist then
			c = c + 1
			res[c] = Concat(
				self:HyperLink(function(_, _)
					ExamineThreadLevel_totextex(nil, nil, obj, self)
				end),
				self:HyperLink(ExamineThreadLevel_totextex(nil, nil, obj, self)),
				ChoGGi.ComFuncs.DebugGetInfo(obj),
				HLEnd
			)
		else
			local info, level = true, 0
			while true do
				info = debug.getinfo(obj, level, "Slfun")
				if info then
					c = c + 1
					res[c] = Concat(
						self:HyperLink(function(level, info)
							ExamineThreadLevel_totextex(level, info, obj,self)
						end),
						self:HyperLink(ExamineThreadLevel_totextex(level, info, obj,self)),
						info.short_src,
						"(",
						info.currentline,
						") ",
						info.name or info.name_what or S[302535920000063--[[unknown name--]]],
						HLEnd
					)
				else
					break
				end
				level = level + 1
			end
		end

		c = c + 1
		res[c] = Concat("<color 255 255 255>\nThread info: ",
			"\nIsValidThread(): ",IsValidThread(obj),
			"\nGetThreadStatus(): ",GetThreadStatus(obj),
			"\nIsGameTimeThread(): ",IsGameTimeThread(obj),
			"\nIsRealTimeThread(): ",IsRealTimeThread(obj),
			"\nThreadHasFlags(): ",ThreadHasFlags(obj),
			"</color>"
		)

	elseif obj_type == "function" then
		if blacklist then
			c = c + 1
			res[c] = self:valuetotextex(ChoGGi.ComFuncs.DebugGetInfo(obj))
		else
			local i = 1
			while true do
				local k, v = debug.getupvalue(obj, i)
				if k then
					c = c + 1
					res[c] = Concat(
						self:valuetotextex(k),
						" = ",
						self:valuetotextex(v)
					)
				else
					c = c + 1
					res[c] = self:valuetotextex(obj)
					break
				end
				i = i + 1
			end
		end
	end

	table.sort(res, function(a, b)
		if sort[a] and sort[b] then
			return sort[a] < sort[b]
		end
		if sort[a] or sort[b] then
			return sort[a] and true
		end
		return CmpLower(a, b)
	end)

	if IsValid(obj) and obj:IsKindOf("CObject") then

		table.insert(res,1,Concat(
--~			 "<center>--",
			"\t\t\t\t--",
			self:HyperLink(function()
				Examine_totextex(obj_metatable,self)
			end),
			obj.class,
			HLEnd,
			"@",
			self:valuetotextex(obj:GetPos()),
			"--<vspace 6><left>"
		))

		if obj:IsValidPos() and IsValidEntity(obj.entity) and 0 < obj:GetAnimDuration() then
			local pos = obj:GetVisualPos() + obj:GetStepVector() * obj:TimeToAnimEnd() / obj:GetAnimDuration()
			table.insert(res, 2, Concat(
				GetStateName(obj:GetState()),
				", step:",
				self:HyperLink(function()
					ShowMe(pos)
				end),
				tostring(obj:GetStepVector(obj:GetState(),0)),
				HLEnd
			))
		end

	elseif is_table and obj_metatable then
			table.insert(res, 1, Concat(
--~				 "<center>--",
				"\t\t\t\t--",
				self:valuetotextex(obj_metatable),
				": metatable--<vspace 6><left>"
			))
	end

	-- add strings/numbers to the body
	if obj_type == "number" or obj_type == "string" or obj_type == "boolean" then
		c = c + 1
		res[c] = tostring(obj)
	elseif obj_type == "userdata" then
		local str = T(obj)
		-- might as well just return userdata instead of these
		if str == "stripped" or str:find("Missing locale string id") then
			str = obj
		end

		c = c + 1
		res[c] = tostring(str)
	-- add some extra info for funcs
	elseif obj_type == "function" then
		local dbg_value = "\ndebug.getinfo: "
		if blacklist
 then
			dbg_value = Concat(dbg_value,ChoGGi.ComFuncs.DebugGetInfo(obj))
		else
			local dbg_table = debug.getinfo(obj) or empty_table
			for key,value in pairs(dbg_table) do
				dbg_value = Concat(dbg_value,"\n",key,": ",value)
			end
		end
		c = c + 1
		res[c] = dbg_value
	end

	return TableConcat(res,"\n")
end
---------------------------------------------------------------------------------------------------------------------
--menu
local function Show_menu(obj)
	if IsValid(obj) then
		ShowMe(obj)
	else
		for k, v in pairs(obj) do
			if IsPoint(k) or IsValid(k) then
				ShowMe(k)
			end
			if IsPoint(v) or IsValid(v) then
				ShowMe(v)
			end
		end
	end
end
local function ClearShowMe_menu()
	ChoGGi.ComFuncs.ClearShowMe()
end

local function Destroy_menu(obj,self)
--~ 	local z = self.ZOrder
--~ 	self:SetZOrder(1)
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000414--[[Are you sure you wish to destroy it?--]]],
		function(answer)
--~ 			self:SetZOrder(z)
			if answer then
				ChoGGi.CodeFuncs.DeleteObject(obj)
			end
		end,
		S[697--[[Destroy--]]]
	)
end

local function Refresh_menu(self)
	if self.obj then
		self:SetObj(self.obj,true)
		if IsKindOf(self.obj,"XWindow") and self.obj.class ~= "InGameInterface" then
			self:FlashWindow(self.obj)
		end
	end
end
local function SetTransp_menu(self)
	self.transp_mode = not self.transp_mode
	self:SetTranspMode(self.transp_mode)
end

function Examine:menu(obj)
--~	 local obj_metatable = getmetatable(obj)
	local obj_type = type(obj)
	local res = {
		"	",
		self:HyperLink(function()
			Refresh_menu(self)
		end),
		"[",
		S[1000220--[[Refresh--]]],
		"]",
		HLEnd,
--~		 " ",
		self:HyperLink(ClearShowMe_menu),
		S[302535920000059--[[[Clear Markers]--]]],
		HLEnd,
--~		 " ",
		self:HyperLink(function()
			SetTransp_menu(self)
		end),
		S[302535920000064--[[[Transp]--]]],
		HLEnd,
--~		 " ",
	}
	local c = #res

	if IsValid(obj) and obj_type == "table" then
		c = c + 1
		res[c] = self:HyperLink(function()
			Show_menu(obj)
		end)
		c = c + 1
		res[c] = S[302535920000058--[[[ShowIt]--]]]
		c = c + 1
		res[c] = HLEnd
	end
	if IsValid(obj) then
		c = c + 1
		res[c] = self:HyperLink(function()
			Destroy_menu(obj,self)
		end)
		c = c + 1
		res[c] = S[302535920000060--[[[Destroy It!]--]]]
		c = c + 1
		res[c] = HLEnd
	end
	return TableConcat(res)
end

-- used to build parents/ancestors menu

local pmenu_skip_dupes
function Examine:BuildParents(list,list_type,title,sort_type)
--~ local function BuildParents(self,list,list_type,title,sort_type)
	local g_Classes = g_Classes
	if list and next(list) then
		list = ChoGGi.ComFuncs.RetSortTextAssTable(list,sort_type)
		self[list_type] = list
		local c = #self.parents_menu_popup
		c = c + 1
		self.parents_menu_popup[c] = {
			name = Concat("	 ---- ",title),
			hint = title,
		}
		for i = 1, #list do
			-- no sense in having an item in parents and ancestors
			if not pmenu_skip_dupes[list[i]] then
				pmenu_skip_dupes[list[i]] = true
				c = c + 1
				self.parents_menu_popup[c] = {
					name = list[i],
					hint = list[i],
					clicked = function()
						ChoGGi.ComFuncs.OpenInExamineDlg(g_Classes[list[i]],self)
					end,
				}
			end
		end
	end
end

function Examine:SetObj(obj,skip_thread)
	obj = obj or self.obj
	self.onclick_handles = {}

	self.idText:SetText(S[67--[[Loading resources--]]])
	self.idLinks:SetText(self:menu(obj))
	local is_table = type(obj) == "table"
	local name = RetName(obj)

	-- update attaches button with attaches amount
	local attaches = is_table and IsValid(obj) and obj:IsKindOf("ComponentAttach") and obj:GetAttaches()
	local attach_amount = attaches and #attaches
	self.idAttaches.RolloverText = S[302535920000070--[["Shows list of attachments. This %s has %s.

Use %s to hide markers."--]]]:format(name,attach_amount,S[302535920000059--[[[Clear Markers]--]]])

	if is_table then

		-- reset menu list
		self.parents_menu_popup = {}

		if obj.class then
			--add object name to title
			if type(obj.handle) == "number" then
				name = Concat(name," (",obj.handle,")")
			elseif #obj > 0 then
				name = Concat(name," (",#obj,")")
			end

			pmenu_skip_dupes = {}
			-- build menu list
			self:BuildParents(obj.__parents,"parents",S[302535920000520--[[Parents--]]])
			self:BuildParents(obj.__ancestors,"ancestors",S[302535920000525--[[Ancestors--]]],true)
			-- if anything was added to the list then add to the menu
			if #self.parents_menu_popup > 0 then
				self.idParents:SetVisible(true)
			end
			--attaches menu
			if attaches and attach_amount > 0 then
				self.attaches_menu_popup = {}

				for i = 1, #attaches do
					local pos = type(attaches[i].GetVisualPos) == "function" and attaches[i]:GetVisualPos()
					self.attaches_menu_popup[i] = {
						name = RetName(attaches[i]),
						hint = Concat(
							attaches[i].class,"\n",
							S[302535920000955--[[Handle--]]],": ",attaches[i].handle or S[6761--[[None--]]],"\n",
							pos and Concat("Pos: ",pos)
						),
						showme = attaches[i],
						clicked = function()
							ChoGGi.ComFuncs.OpenInExamineDlg(attaches[i],self)
						end,
					}
				end
				self.idAttaches:SetVisible(true)
			end
		end

	end

	-- limit caption length so we don't cover up close button
	self.idCaption:SetText(utf8.sub(Concat(S[302535920000069--[[Examine--]]],": ",name), 1, 45))

	-- don't create a new thread if we're already in one from auto-refresh
	if skip_thread then
		self.idText:SetText(self:totextex(obj,ChoGGi))
	else
		-- we add a slight delay, so the rest of the dialog loads, and we can let user see the loading msg
		DelayedCall(5, function()
			self.idText:SetText(self:totextex(obj,ChoGGi))
		end)
	end
end

local function PopupClose(name)
	local popup = rawget(terminal.desktop,name)
	if popup then
		popup:Close()
	end
end
function Examine:Done(result)
	DeleteThread(self.autorefresh_thread)
	PopupClose("idAttachesMenu")
	PopupClose("idParentsMenu")
	PopupClose("idToolsMenu")
	ChoGGi_Window.Done(self,result)
end
