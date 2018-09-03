-- See LICENSE for terms

local TableConcat = ChoGGi.ComFuncs.TableConcat
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName
local ShowMe = ChoGGi.ComFuncs.ShowMe
local DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
local Trans = ChoGGi.ComFuncs.Translate
local S = ChoGGi.Strings
local blacklist = ChoGGi.blacklist

local pairs,type,tostring,tonumber,rawget,table,debug = pairs,type,tostring,tonumber,rawget,table,debug

local CmpLower = CmpLower
local GetStateName = GetStateName
local IsPoint = IsPoint
local IsValid = IsValid
local IsValidEntity = IsValidEntity
local getlocal = debug.getlocal
local getupvalue = debug.getupvalue

transp_mode = rawget(_G, "transp_mode") or false
local HLEnd = "</h></color>"
--~ Transparency

local white = white
local black = black

-- used for updating text button rollover hints
local idLinks_hypertext = {
	[string.format("[%s]",S[1000220--[[Refresh--]]])] = S[302535920000092--[[Updates list with any changed values.--]]],
	[S[302535920000059--[[[Clear Markers]--]]]] = S[302535920000016--[[Remove any green spheres/reset green coloured objects.--]]],
	[S[302535920000064--[[[Transp]--]]]] = string.format("%s %s",S[302535920000069--[[Examine--]]],S[302535920000629--[[UI Transparency--]]]),
	[S[302535920000058--[[[Show It]--]]]] = S[302535920000021--[[Mark object with green sphere and/or paint.--]]],
	[S[302535920000060--[[[Destroy It!]--]]]] = S[302535920000414--[[Are you sure you wish to destroy it?--]]],
}

DefineClass.Examine = {
	__parents = {"ChoGGi_Window"},
	-- what we're examining
	obj = false,
	-- used to store visibility of obj
	orig_vis_flash = false,

	dialog_width = 650.0,
	dialog_height = 750.0,

	-- add some random numbers as ids so when you click a popup of the same name from another examine it'll close then open the new one
	idAttachesMenu = false,
	idParentsMenu = false,
	idToolsMenu = false,
	-- any tables
	parents_menu_popup = false,
	attaches_menu_popup = false,
	pmenu_skip_dupes = false,
	parents = false,
	ancestors = false,
	menu_added = false,
	menu_list_items = false,
	-- clickable purple text
	onclick_handles = false,
}

function Examine:Init(parent, context)
	local ChoGGi = ChoGGi
	local g_Classes = g_Classes
	local const = const

	self.idAttachesMenu = ChoGGi.ComFuncs.Random()
	self.idParentsMenu = ChoGGi.ComFuncs.Random()
	self.idToolsMenu = ChoGGi.ComFuncs.Random()

	self.attaches_menu_popup = {}
	self.parents = {}
	self.ancestors = {}
	self.menu_added = {}
	self.menu_list_items = {}
	-- clickable purple text
	self.onclick_handles = {}

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
		OnHyperLinkRollover = function(links)
			if links.hovered_hyperlink then
				links.RolloverText = idLinks_hypertext[links.hovered_hyperlink.text]
			end
		end,
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
				PopupToggle(obj,self.idToolsMenu,tools_menu_popup,"bottom")
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
				PopupToggle(obj,self.idParentsMenu,self.parents_menu_popup,"bottom")
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
				PopupToggle(obj,self.idAttachesMenu,self.attaches_menu_popup,"bottom")
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
	local is_obj = self:SetObj(self.obj)

	if is_obj then
		self.parents_menu_popup = {}
		self.pmenu_skip_dupes = {}
		-- build menu list
		self:BuildParents(self.obj.__parents,"parents",S[302535920000520--[[Parents--]]])
		self:BuildParents(self.obj.__ancestors,"ancestors",S[302535920000525--[[Ancestors--]]],true)
		-- if anything was added to the list then add to the menu
		if #self.parents_menu_popup > 0 then
			self.idParents:SetVisible(true)
		end
	end

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

-- adds class name then list of functions below
function Examine:BuildFuncList(obj_name,prefix)
	prefix = prefix or ""
	local class = _G[obj_name] or empty_table
	local skip = true
	for key,_ in pairs(class) do
		if type(class[key]) == "function" then
			self.menu_list_items[string.format("%s%s.%s: ",prefix,obj_name,key)] = class[key]
			skip = false
		end
	end
	if not skip then
		self.menu_list_items[string.format("%s%s",prefix,obj_name)] = "\n\n\n"
	end
end

function Examine:ProcessList(list,prefix)
	for i = 1, #list do
		if not self.menu_added[list[i]] then
			-- CObject and Object are pretty much the same (Object has a couple more funcs)
			if list[i] == "CObject" then
				-- keep it for later (for the rare objects that use CObject, but not Object)
				self.menu_added[list[i]] = prefix
			else
				self.menu_added[list[i]] = true
				self:BuildFuncList(list[i],prefix)
			end
		end
	end
end

function Examine:BuildToolsMenuPopup()
	return {
		{
			name = string.format("%s %s",S[302535920000004--[[Dump--]]],S[1000145--[[Text--]]]),
			hint = S[302535920000046--[[dumps text to %sDumpedExamine.lua--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags
				str = str:gsub("<[/%s%a%d]*>","")
				ChoGGi.ComFuncs.Dump(string.format("\n%s",str),nil,"DumpedExamine","lua")
			end,
		},
		{
			name = string.format("%s %s",S[302535920000004--[[Dump--]]],S[298035641454--[[Object--]]]),
			hint = S[302535920001027--[[dumps object to %sDumpedExamineObject.lua

This can take time on something like the "Building" metatable--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = ValueToLuaCode(self.obj)
				ChoGGi.ComFuncs.Dump(string.format("\n%s",str),nil,"DumpedExamineObject","lua")
			end,
		},
		{
			name = string.format("%s %s",S[302535920000048--[[View--]]],S[1000145--[[Text--]]]),
			hint = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags
				str = str:gsub("<[/%s%a%d]*>","")
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					checkbox = true,
					text = str,
					title = string.format("%s/%s %s",S[302535920000048--[[View--]]],S[302535920000004--[[Dump--]]],S[1000145--[[Text--]]]),
					hint_ok = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump(string.format("\n%s",str),overwrite,"DumpedExamine","lua")
						end
					end,
				}
			end,
		},
		{
			name = string.format("%s %s",S[302535920000048--[[View--]]],S[298035641454--[[Object--]]]),
			hint = S[302535920000049--[["View text, and optionally dumps object to %sDumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = ValueToLuaCode(self.obj)
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					checkbox = true,
					text = str,
					title = string.format("%s/%s %s",S[302535920000048--[[View--]]],S[302535920000004--[[Dump--]]],S[298035641454--[[Object--]]]),
					hint_ok = 302535920000049--[["View text, and optionally dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]],
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump(string.format("\n%s",str),overwrite,"DumpedExamineObject","lua")
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
				if #self.parents > 0 or #self.ancestors > 0 then
					table.clear(self.menu_added)
					table.clear(self.menu_list_items)

					if #self.parents > 0 then
						self:ProcessList(self.parents,string.format(" %s: ",S[302535920000520--[[Parents--]]]))
					end
					if #self.ancestors > 0 then
						self:ProcessList(self.ancestors,string.format("%s: ",S[302535920000525--[[Ancestors--]]]))
					end
					-- add examiner object with some spaces so it's at the top
					self:BuildFuncList(self.obj.class,"	")
					-- if Object hasn't been added, then add CObject (O has a few more funcs than CO)
					if not self.menu_added.Object and self.menu_added.CObject then
						self:BuildFuncList("CObject",self.menu_added.CObject)
					end

					ChoGGi.ComFuncs.OpenInExamineDlg(self.menu_list_items,self)
				else
					-- close enough
					print(S[9763--[[No objects matching current filters.--]]])
				end
			end,
		},
		{
			name = S[302535920000449--[[Attach Spots Toggle--]]],
			hint = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
			clicked = function()
				ChoGGi.CodeFuncs.AttachSpots_Toggle(self.obj)
			end,
		},
		{
			name = S[302535920000459--[[Anim Debug Toggle--]]],
			hint = S[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
			clicked = function()
				ChoGGi.CodeFuncs.ShowAnimDebug_Toggle(self.obj)
			end,
		},
		{name = "	 ---- "},
		{
			name = string.format("%s %s",S[327465361219--[[Edit--]]],S[298035641454--[[Object--]]]),
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
			hint = S[302535920001322--[["Examine UI controls by clicking them.
This dialog will freeze till you click something."--]]],
			clicked = function()
				ChoGGi_TerminalRolloverMode(true,self)
			end,
		},
		{
			name = S[302535920000970--[[UI Flash--]]],
			hint = S[302535920000972--[[Flash visibility of the UI object being examined.--]]],
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
	local flashing_thread
	local Sleep = Sleep
	local DeleteThread = DeleteThread
	local CreateRealTimeThread = CreateRealTimeThread

	function Examine:FlashWindow(obj)
		obj = obj or self.obj

		-- doesn't lead to good stuff
		if not obj.desktop then
			return
		end

		-- don't want to end up with something invis when it shouldn't be
		if not self.orig_vis_flash then
			self.orig_vis_flash = obj:GetVisible()
		end

		-- always kill off old thread first
		DeleteThread(flashing_thread)

		flashing_thread = CreateRealTimeThread(function()

			local vis = nil
			for _ = 1, 5 do
				if obj.window_state == "destroying" then
					break
				end
				obj:SetVisible(vis)
				Sleep(100)
				vis = not vis
			end

			if obj.window_state ~= "destroying" then
				obj:SetVisible(self.orig_vis_flash)
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
		return string.format("%s%s%s",
			self:HyperLink(function(_,_,button)
				Examine_valuetotextex(_,_,button,obj,self)
			end),
			DebugGetInfo(obj),
			HLEnd
		)

	elseif obj_type == "thread" then
		return string.format("%s%s%s",
			self:HyperLink(function(_,_,button)
				Examine_valuetotextex(_,_,button,obj,self)
			end),
			tostring(obj),
			HLEnd
		)

	elseif obj_type == "string" then
		-- some translated stuff has <color in it, so we make sure they don't bother the rest
		return string.format("'%s</color></color>'",obj)

	-- point() is userdata (keep before it)
	elseif IsPoint(obj) then
		return string.format("%s(%s,%s)%s%s",
			self:HyperLink(function()
				ShowMe(obj)
			end),
			obj:x(),
			obj:y(),
			obj:z() or terrain.GetHeight(obj),
			HLEnd
		)

	elseif obj_type == "userdata" then
		local str = tostring(obj)
		local trans = Trans(obj)
		-- if it isn't translatable then return a clickable link (not that useful, but it's highlighted)
		if trans == "stripped" or trans:find("Missing locale string id") then
			return string.format("%s%s%s",
				self:HyperLink(function(_,_,button)
					Examine_valuetotextex(_,_,button,obj,self)
				end),
				str,
				HLEnd
			)
		else
			return string.format([[%s</color></color> < "%s"]],
				trans,
				obj_type
			)
		end

	elseif obj_type == "table" then

		if IsValid(obj) then
			return string.format("%s%s%s@%s",
				self:HyperLink(function(_,_,button)
					Examine_valuetotextex(_,_,button,obj,self)
				end),
				obj.class,
				HLEnd,
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
					res[c] = "="
					c = c + 1
					res[c] = self:valuetotextex(obj[i])
					c = c + 1
					res[c] = ","
				end
				if len > 3 then
					c = c + 1
					res[c] = "..."
				end
				c = c + 1
				res[c] = "}"
				-- remove last ,
				return TableConcat(res):gsub(",}","}")
			else
				-- regular table
				local table_data
				local is_next = next(obj)

				if len > 0 and is_next then
					-- next works for both
					table_data = string.format("%s / %s",len,S[302535920001057--[[Data--]]])
				elseif is_next then
					-- ass based
					table_data = S[302535920001057--[[Data--]]]
				else
					-- blank table
					table_data = 0
				end

				local name = RetName(obj)
				if obj.class and name ~= obj.class then
					name = string.format("%s (len: %s, %s)",obj.class,table_data,name)
				else
					name = string.format("%s (len: %s)",name,table_data)
				end

				return string.format("%s%s%s",
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
	return string.format("%s<h %s 230 195 50>",
		custom_color or "<color 150 170 250>",
		#self.onclick_handles
	)
end

---------------------------------------------------------------------------------------------------------------------
local ExamineThreadLevel_data = {}
local function ExamineThreadLevel_totextex(level, info, obj,self)
	if blacklist then
		table.clear(ExamineThreadLevel_data)
		ExamineThreadLevel_data = {DebugGetInfo(obj)}
	else
		table.clear(ExamineThreadLevel_data)
		local l = 1
		while true do
			local name, val = getlocal(obj, level, l)
			if name then
				ExamineThreadLevel_data[name] = val
				l = l + 1
			else
				break
			end
		end
		for i = 1, info.nups do
			local name, val = getupvalue(info.func, i)
			if name ~= nil and val ~= nil then
				ExamineThreadLevel_data[string.format("%s(up)",name)] = val
			end
		end
	end

	return function()
		ChoGGi.ComFuncs.OpenInExamineDlg(ExamineThreadLevel_data, self)
	end
end

local function Examine_totextex(obj,self)
	ChoGGi.ComFuncs.OpenInExamineDlg(obj, self)
end

local totextex_res = {}
local totextex_sort = {}
function Examine:totextex(obj)
	table.iclear(totextex_res)
	table.clear(totextex_sort)
	local obj_metatable = getmetatable(obj)
	local obj_type = type(obj)
	local c = 0

	if obj_type == "table" then

		for k, v in pairs(obj) do
			c = c + 1
			totextex_res[c] = string.format("%s = %s<left>",
				self:valuetotextex(k),
				self:valuetotextex(v)
			)
			if type(k) == "number" then
				totextex_sort[totextex_res[c]] = k
			end
		end

	elseif obj_type == "thread" then

		if blacklist then
			c = c + 1
			totextex_res[c] = string.format("%s%s%s%s",
				self:HyperLink(function(_, _)
					ExamineThreadLevel_totextex(nil, nil, obj, self)
				end),
				self:HyperLink(ExamineThreadLevel_totextex(nil, nil, obj, self)),
				DebugGetInfo(obj),
				HLEnd
			)
		else
			local info, level = true, 0
			while true do
				info = debug.getinfo(obj, level, "Slfun")
				if info then
					c = c + 1
					totextex_res[c] = string.format("%s%s%s(%s)%s%s",
						self:HyperLink(function(level, info)
							ExamineThreadLevel_totextex(level, info, obj,self)
						end),
						self:HyperLink(ExamineThreadLevel_totextex(level, info, obj,self)),
						info.short_src,
						info.currentline,
						info.name or info.name_what or S[302535920000723--[[Lua--]]],
						HLEnd
					)
				else
					break
				end
				level = level + 1
			end
		end

		c = c + 1
		totextex_res[c] = string.format([[
<color 200 200 200>Thread info:
IsValidThread(): %s
GetThreadStatus(): %s
IsGameTimeThread(): %s
IsRealTimeThread(): %s
ThreadHasFlags(): %s</color>]],
			IsValidThread(obj),
			GetThreadStatus(obj),
			IsGameTimeThread(obj),
			IsRealTimeThread(obj),
			ThreadHasFlags(obj)
		)

	elseif obj_type == "function" then
		if blacklist then
			c = c + 1
			totextex_res[c] = self:valuetotextex(DebugGetInfo(obj))
		else
			local i = 1
			while true do
				local k, v = getupvalue(obj, i)
				if k then
					c = c + 1
					totextex_res[c] = string.format("%s = %s",
						self:valuetotextex(k),
						self:valuetotextex(v)
					)
				else
					c = c + 1
					totextex_res[c] = self:valuetotextex(obj)
					break
				end
				i = i + 1
			end
		end
	end

	table.sort(totextex_res, function(a, b)
		if totextex_sort[a] and totextex_sort[b] then
			return totextex_sort[a] < totextex_sort[b]
		end
		if totextex_sort[a] or totextex_sort[b] then
			return totextex_sort[a] and true
		end
		return CmpLower(a, b)
	end)

	if IsValid(obj) and obj:IsKindOf("CObject") then

		table.insert(totextex_res,1,string.format(--[[<center>----]]"\t\t\t\t--%s%s%s@%s--"--[[--<vspace 6><left>--]],
			self:HyperLink(function()
				Examine_totextex(obj_metatable,self)
			end),
			obj.class,
			HLEnd,
			self:valuetotextex(obj:GetPos())
		))

		if obj:IsValidPos() and IsValidEntity(obj.entity) and 0 < obj:GetAnimDuration() then
			local pos = obj:GetVisualPos() + obj:GetStepVector() * obj:TimeToAnimEnd() / obj:GetAnimDuration()
			table.insert(totextex_res, 2, string.format("%s, step:%s%s%s",
				GetStateName(obj:GetState()),
				self:HyperLink(function()
					ShowMe(pos)
				end),
				tostring(obj:GetStepVector(obj:GetState(),0)),
				HLEnd
			))
		end

	elseif obj_type == "table" and obj_metatable then
			table.insert(totextex_res, 1, string.format(--[[<center>----]]"\t\t\t\t--%s: metatable--"--[[: metatable--<vspace 6><left>--]],
				self:valuetotextex(obj_metatable)
			))
	end

		-- add strings/numbers to the body
	if obj_type == "number" or obj_type == "string" or obj_type == "boolean" then
		c = c + 1
		totextex_res[c] = tostring(obj)

	elseif obj_type == "userdata" then
		local str = Trans(obj)
		-- might as well just return userdata instead of these
		if str == "stripped" or str:find("Missing locale string id") then
			str = obj
		end
		c = c + 1
		totextex_res[c] = tostring(str)

	-- add some extra info for funcs
	elseif obj_type == "function" then
		local dbg_value = "\ndebug.getinfo: "
		if blacklist then
			dbg_value = string.format("%s%s",dbg_value,DebugGetInfo(obj))
		else
			local dbg_table = debug.getinfo(obj) or empty_table
			for key,value in pairs(dbg_table) do
				dbg_value = string.format("%s\n%s: %s",dbg_value,key,value)
			end
		end
		c = c + 1
		totextex_res[c] = dbg_value
	end

	return TableConcat(totextex_res,"\n")
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
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000414--[[Are you sure you wish to destroy it?--]]],
		function(answer)
			if answer then
				DoneObject(obj)
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
--~ 		"	",
		self:HyperLink(function()
			Refresh_menu(self)
		end),
		"[",
		S[1000220--[[Refresh--]]],
		"]",
		HLEnd,
		" ",
		self:HyperLink(function()
			SetTransp_menu(self)
		end),
		S[302535920000064--[[[Transp]--]]],
		HLEnd,
		" ",
		self:HyperLink(ClearShowMe_menu),
		S[302535920000059--[[[Clear Markers]--]]],
		HLEnd,
		" ",
	}

	if obj_type == "table" then
		local c = #res
		if IsValid(obj) then
			c = c + 1
			res[c] = self:HyperLink(function()
				Show_menu(obj)
			end)
			c = c + 1
			res[c] = S[302535920000058--[[[Show It]--]]]
			c = c + 1
			res[c] = HLEnd
		end

		if obj.class then
			c = c + 1
			res[c] = " "
			c = c + 1
			res[c] = self:HyperLink(function()
				Destroy_menu(obj,self)
			end)
			c = c + 1
			res[c] = S[302535920000060--[[[Destroy It!]--]]]
			c = c + 1
			res[c] = HLEnd
		end
	end

	return TableConcat(res)
end

-- used to build parents/ancestors menu

function Examine:BuildParents(list,list_type,title,sort_type)
	local g_Classes = g_Classes
	if list and next(list) then
		list = ChoGGi.ComFuncs.RetSortTextAssTable(list,sort_type)
		self[list_type] = list
		local c = #self.parents_menu_popup
		c = c + 1
		self.parents_menu_popup[c] = {
			name = string.format("	 ---- %s",title),
			hint = title,
		}
		for i = 1, #list do
			-- no sense in having an item in parents and ancestors
			if not self.pmenu_skip_dupes[list[i]] then
				self.pmenu_skip_dupes[list[i]] = true
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

	self.onclick_handles = {}

	local obj_type = type(obj)
	if obj_type == "string" then
		-- check if obj string is a ref to an actual object
		local obj_ref  = ChoGGi.ComFuncs.DotNameToObject(obj)
		-- if it is then we use that as the obj to examine
		if obj_ref then
			obj = obj_ref
		end
	end

	self.idLinks:SetText(self:menu(obj))

	local name = RetName(obj)
	self.idText:SetText(name,": ",S[67--[[Loading resources--]]])

	if obj_type == "table" then
		-- add object name to title
		if type(obj.handle) == "number" then
			name = string.format("%s (%s)",name,obj.handle)
		elseif #obj > 0 then
			name = string.format("%s (%s)",name,#obj)
		end

		if obj.class then

			-- attaches button/menu
			if IsValid(obj) and obj:IsKindOf("ComponentAttach") then
				table.iclear(self.attaches_menu_popup)
				local attach_amount = 0
				obj:ForEachAttach("",function(a)
					attach_amount = attach_amount + 1
					local pos = a.GetVisualPos and a:GetVisualPos()

					self.attaches_menu_popup[attach_amount] = {
						name = RetName(a),
						hint = string.format("%s\n%s: %s\npos: %s",
							a.class,
							S[302535920000955--[[Handle--]]],
							a.handle or S[6761--[[None--]]],
							pos
						),
						showme = a,
						clicked = function()
							ChoGGi.ComFuncs.OpenInExamineDlg(a,self)
						end,
					}
				end)

				if attach_amount > 0 then
					table.sort(self.attaches_menu_popup, function(a, b)
						return CmpLower(a.name, b.name)
					end)

					self.idAttaches:SetVisible(true)
					self.idAttaches.RolloverText = S[302535920000070--[["Shows list of attachments. This %s has %s.
Use %s to hide green markers."--]]]:format(name,attach_amount,S[302535920000059--[[[Clear Markers]--]]])
				else
					self.idAttaches:SetVisible()
				end
			end
		end -- obj.class
	end -- istable

	-- limit caption length so we don't cover up close button
	self.idCaption:SetText(utf8.sub(string.format("%s: %s",S[302535920000069--[[Examine--]]],name), 1, 45))

	-- don't create a new thread if we're already in one from auto-refresh
	if skip_thread then
		self.idText:SetText(self:totextex(obj))
	else
		-- we add a slight delay, so the rest of the dialog loads, and we can let user see the loading msg
		DelayedCall(5, function()
			self.idText:SetText(self:totextex(obj))
		end)
	end

	return obj_type == "table" and obj.class
end

local function PopupClose(name)
	local popup = rawget(terminal.desktop,name)
	if popup then
		popup:Close()
	end
end
function Examine:Done(result)
	DeleteThread(self.autorefresh_thread)
	PopupClose(self.idAttachesMenu)
	PopupClose(self.idParentsMenu)
	PopupClose(self.idToolsMenu)
	ChoGGi_Window.Done(self,result)
end
