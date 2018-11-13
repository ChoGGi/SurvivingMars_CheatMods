-- See LICENSE for terms

-- used to examine objects

local pairs,type,tostring,rawget = pairs,type,tostring,rawget

local StringFormat = string.format
local TableSort = table.sort
local TableInsert = table.insert
local TableClear = table.clear
local TableIClear = table.iclear

local CmpLower = CmpLower
local IsObjlist = IsObjlist
local GetStateName = GetStateName
local IsPoint = IsPoint
local IsValid = IsValid
local IsValidEntity = IsValidEntity

local getlocal
local getupvalue
local getinfo
local debug = rawget(_G,"debug")
if debug then
	getlocal = debug.getlocal
	getupvalue = debug.getupvalue
	getinfo = debug.getinfo
end

local HLEnd = "</h></color>"

local TableConcat
local PopupToggle
local RetName
local ShowMe
local DebugGetInfo
local RetThreadInfo
local DeleteObject
local DotNameToObject
local Trans
local InvalidPos
local S
local blacklist
local idLinks_hypertext

-- need to wait till Library mod is loaded
function OnMsg.ClassesGenerate()
	local ChoGGi = ChoGGi
	TableConcat = ChoGGi.ComFuncs.TableConcat
	PopupToggle = ChoGGi.ComFuncs.PopupToggle
	RetName = ChoGGi.ComFuncs.RetName
	ShowMe = ChoGGi.ComFuncs.ShowMe
	DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	DeleteObject = ChoGGi.ComFuncs.DeleteObject
	DotNameToObject = ChoGGi.ComFuncs.DotNameToObject
	RetThreadInfo = ChoGGi.ComFuncs.RetThreadInfo
	Trans = ChoGGi.ComFuncs.Translate
	InvalidPos = ChoGGi.Consts.InvalidPos
	S = ChoGGi.Strings
	blacklist = ChoGGi.blacklist

	-- used for updating text button rollover hints
	idLinks_hypertext = {
		["CommonAssets/UI/Menu/reload.tga"] = {
			title = S[1000220--[[Refresh--]]],
			text = S[302535920000092--[[Updates list with any changed values.--]]],
		},
		["CommonAssets/UI/Menu/CutSceneArea.tga"] = {
			title = S[302535920000865--[[Toggle Trans--]]],
			text = StringFormat("%s %s",S[302535920000069--[[Examine--]]],S[302535920000629--[[UI Transparency--]]]),
		},
		["CommonAssets/UI/Menu/DisableEyeSpec.tga"] = {
			title = S[302535920000057--[[Mark Object--]]],
			text = S[302535920000021--[[Mark object with green sphere and/or paint.--]]],
		},
		["CommonAssets/UI/Menu/delete_objects.tga"] = {
			title = S[697--[[Destroy--]]],
			text = S[302535920000414--[[Are you sure you wish to destroy it?--]]],
		},
		["CommonAssets/UI/Menu/UnlockCollection.tga"] = {
			title = S[3768--[[Destroy all?--]]],
			text = S[302535920000059--[[Destroy all objects in objlist!--]]],
		},
		["CommonAssets/UI/Menu/NoblePreview.tga"] = {
			title = S[594--[[Clear--]]],
			text = S[302535920000016--[[Remove any green spheres/reset green coloured objects.--]]],
		},
		["CommonAssets/UI/Menu/ExportImageSequence.tga"] = {
			title = S[302535920000058--[[Mark All Objects--]]],
			text = S[302535920000056--[[Mark all items in objlist with green spheres.--]]],
		},
		["CommonAssets/UI/Menu/CameraEditor.tga"] = {
			title = S[302535920000459--[[Anim Debug Toggle--]]],
			text = S[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
		},
		["CommonAssets/UI/Menu/ShowAll.tga"] = {
			title = S[302535920000449--[[Attach Spots Toggle--]]],
			text = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
		},
		["CommonAssets/UI/Menu/SelectByClass.tga"] = {
			title = S[931--[[Modified property--]]],
			text = S[302535920001384--[[Get properties different from base/parent object?--]]],
		},
		["CommonAssets/UI/Menu/AreaProperties.tga"] = {
			title = S[302535920001389--[[All Properties--]]],
			text = S[302535920001390--[[Get all properties.--]]],
		},
	}
end

DefineClass.Examine = {
	__parents = {"ChoGGi_Window"},

	-- stores all opened examine dialogs
	examine_dialogs = {},
	-- prefix some string to the title
	prefix = false,
	-- what we're examining
	obj = false,
	-- if we're examining a string we want to convert to an object
	str_object = false,
	-- we store the str_object > obj here
	obj_ref = false,
	-- used to store visibility of obj
	orig_vis_flash = false,
	-- if it's transparent or not
	transp_mode = false,
	-- get list of all values from metatables
	show_all_values = false,

	-- chinese goes slow as shit for some reason, so i added this to at least stop the game from freezing till obj is examined
	is_chinese = false,

	dialog_width = 666.0,
	dialog_height = 850.0,

	-- add some random numbers as ids so when you click a popup of the same name from another examine it'll close then open the new one
	idAttachesMenu = false,
	idParentsMenu = false,
	idToolsMenu = false,
	-- tables
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
	self.obj = context.obj

	-- workaround for ex_dia to examine something nil
	if type(context.obj) == "nil" then
		self.obj = "nil"
	end

	-- already examining, so focus and return
	local ex_dia = Examine.examine_dialogs
	if ex_dia[self.obj] then
		ex_dia[self.obj].idMoveControl:SetFocus()
		return
	end
	ex_dia[self.obj] = self

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

	-- if we're examining a string we want to convert to an object
	if type(self.obj) == "string" and type(context.parent) == "string" then
		self.str_object = context.parent == "str" and true
		context.parent = nil
	end

	self.title = context.title

	self.prefix = S[302535920000069--[[Examine--]]]

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
		Margins = box(4,0,0,0),
		-- same colour as background of icons (so they blend)
		Background = -9868951,
		-- (links,id)
		OnHyperLinkRollover = function(links)
			if links.hovered_hyperlink then
				local info = idLinks_hypertext[links.hovered_hyperlink.image]
				if info then
					links.RolloverText = info.text
					links.RolloverTitle = info.title
				end
				-- flash icon vis
				CreateRealTimeThread(function()
					-- if user is quick on the mouse then this won't be here
					if links.hovered_hyperlink then
						links.hovered_hyperlink.image = nil
					end
					Sleep(100)
					-- redraws "text"
					links:ParseText()
				end)
			end
		end,
		OnHyperLink = function(_, link, _, box, pos, button)
			-- this is what gets fired for any of my self:HyperLink(), also in Classes_UI.lua
			self.onclick_handles[tonumber(link)](box, pos, button, self)
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

	self.idShowAllValues = g_Classes.ChoGGi_CheckButton:new({
		Id = "idShowAllValues",
		Dock = "right",
		MinWidth = 0,
		Text = S[4493--[[All--]]],
		RolloverText = S[302535920001391--[[Show all values (metatable).--]]],
		OnChange = function()
			self.show_all_values = not self.show_all_values
			self:SetObj()
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
	self.transp_mode = ChoGGi.Temp.transp_mode
	self:SetTranspMode(self.transp_mode)

	-- no need to have it fire one than once per dialog
	self.is_chinese = GetLanguage():find("chinese")

	-- do the magic
	if self:SetObj(true) then
		-- returns if it's a class object or not
		if ChoGGi.UserSettings.FlashExamineObject and self.obj_ref:IsKindOf("XWindow") and self.obj_ref.class ~= "InGameInterface" then
			self:FlashWindow()
		end
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
				self:SetObj()
			else
				DeleteThread(self.autorefresh_thread)
				break
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
	local class = _G[obj_name] or {}
	local skip = true
	for key,_ in pairs(class) do
		if type(class[key]) == "function" then
			self.menu_list_items[StringFormat("%s%s.%s: ",prefix,obj_name,key)] = class[key]
			skip = false
		end
	end
	if not skip then
		self.menu_list_items[StringFormat("%s%s",prefix,obj_name)] = "\n\n\n"
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
			name = StringFormat("%s %s",S[302535920000004--[[Dump--]]],S[1000145--[[Text--]]]),
			hint = S[302535920000046--[[dumps text to %sDumpedExamine.lua--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags
				str = str:gsub("<[/%s%a%d]*>","")
				ChoGGi.ComFuncs.Dump(StringFormat("\n%s",str),nil,"DumpedExamine","lua")
			end,
		},
		{
			name = StringFormat("%s %s",S[302535920000004--[[Dump--]]],S[298035641454--[[Object--]]]),
			hint = S[302535920001027--[[dumps object to %sDumpedExamineObject.lua

This can take time on something like the "Building" metatable--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = ValueToLuaCode(self.obj_ref)
				ChoGGi.ComFuncs.Dump(StringFormat("\n%s",str),nil,"DumpedExamineObject","lua")
			end,
		},
		{
			name = StringFormat("%s %s",S[302535920000048--[[View--]]],S[1000145--[[Text--]]]),
			hint = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags
				str = str:gsub("<[/%s%a%d]*>","")
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					parent = self,
					checkbox = true,
					text = str,
					scrollto = self.idScrollArea.OffsetY,
					title = StringFormat("%s/%s %s",S[302535920000048--[[View--]]],S[302535920000004--[[Dump--]]],S[1000145--[[Text--]]]),
					hint_ok = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump(StringFormat("\n%s",str),overwrite,"DumpedExamine","lua")
						end
					end,
				}
			end,
		},
		{
			name = StringFormat("%s %s",S[302535920000048--[[View--]]],S[298035641454--[[Object--]]]),
			hint = S[302535920000049--[["View text, and optionally dumps object to %sDumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]]]:format(ConvertToOSPath("AppData/")),
			clicked = function()
				local str = ValueToLuaCode(self.obj_ref)
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					parent = self,
					checkbox = true,
					text = str,
					title = StringFormat("%s/%s %s",S[302535920000048--[[View--]]],S[302535920000004--[[Dump--]]],S[298035641454--[[Object--]]]),
					hint_ok = 302535920000049--[["View text, and optionally dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]],
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump(StringFormat("\n%s",str),overwrite,"DumpedExamineObject","lua")
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
					TableClear(self.menu_added)
					TableClear(self.menu_list_items)

					if #self.parents > 0 then
						self:ProcessList(self.parents,StringFormat(" %s: ",S[302535920000520--[[Parents--]]]))
					end
					if #self.ancestors > 0 then
						self:ProcessList(self.ancestors,StringFormat("%s: ",S[302535920000525--[[Ancestors--]]]))
					end
					-- add examiner object with some spaces so it's at the top
					self:BuildFuncList(self.obj.class,"	")
					-- if Object hasn't been added, then add CObject (O has a few more funcs than CO)
					if not self.menu_added.Object and self.menu_added.CObject then
						self:BuildFuncList("CObject",self.menu_added.CObject)
					end

					ChoGGi.ComFuncs.OpenInExamineDlg(self.menu_list_items,self,StringFormat("%s: %s",S[302535920001239--[[Functions--]]],RetName(self.obj))
					)
				else
					-- close enough
					print(S[9763--[[No objects matching current filters.--]]])
				end
			end,
		},
		{
			name = StringFormat("%s %s",S[327465361219--[[Edit--]]],S[298035641454--[[Object--]]]),
			hint = S[302535920000050--[[Opens object in Object Manipulator.--]]],
			clicked = function()
				ChoGGi.ComFuncs.OpenInObjectManipulatorDlg(self.obj_ref,self)
			end,
		},
		{
			name = S[302535920001305--[[Find Within--]]],
			hint = S[302535920001303--[[Search for text within %s.--]]]:format(RetName(self.obj)),
			clicked = function()
				ChoGGi.ComFuncs.OpenInFindValueDlg(self.obj_ref,self)
			end,
		},
		{
			name = S[302535920000323--[[Exec Code--]]],
			hint = S[302535920000052--[["Execute code (using console for output). ChoGGi.CurObj is whatever object is opened in examiner.
Which you can then mess around with some more in the console."--]]],
			clicked = function()
				ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj_ref,self)
			end,
		},
		{name = "	 ---- "},
		{
			name = S[302535920001369--[[Ged Editor--]]],
			hint = S[302535920000482--[["Shows some info about the object, and so on. Some buttons may make camera wonky (use Game>Camera>Reset)."--]]],
			clicked = function()
				GedObjectEditor = false
				OpenGedGameObjectEditor{self.obj_ref}
			end,
		},
		{
			name = S[302535920000067--[[Ged Inspect--]]],
			hint = S[302535920001075--[[Open this object in the Ged inspector.--]]],
			clicked = function()
				Inspect(self.obj_ref)
			end,
		},
		{name = "	 ---- "},
		{
			name = S[302535920001321--[[UI Click To Select--]]],
			hint = S[302535920001322--[["Examine UI controls by clicking them.
This dialog will freeze till you click something."--]]],
			clicked = function()
				ChoGGi.ComFuncs.TerminalRolloverMode(true,self)
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
	local drawBuffer = self.idText.draw_cache or {}
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

	function Examine:FlashWindow()
		-- doesn't lead to good stuff
		if not self.obj.desktop then
			return
		end

		-- don't want to end up with something invis when it shouldn't be
		if not self.orig_vis_flash then
			self.orig_vis_flash = self.obj:GetVisible()
		end

		-- always kill off old thread first
		DeleteThread(flashing_thread)

		flashing_thread = CreateRealTimeThread(function()

			local vis
			for _ = 1, 5 do
				if self.obj.window_state == "destroying" then
					break
				end
				self.obj:SetVisible(vis)
				Sleep(100)
				vis = not vis
			end

			if self.obj.window_state ~= "destroying" then
				self.obj:SetVisible(self.orig_vis_flash)
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
	ChoGGi.Temp.transp_mode = toggle
end
--

function Examine:valuetotextex(obj)
	local obj_type = type(obj)

	local function ShowMe_local()
		ShowMe(obj)
	end
	local function Examine_local(_,_,button)
		if button == "L" then
			ChoGGi.ComFuncs.OpenInExamineDlg(obj,self)
		else
			ShowMe(obj)
		end
	end

	if obj_type == "function" then
		return StringFormat("%s%s%s",
			self:HyperLink(Examine_local),
			DebugGetInfo(obj),
			HLEnd
		)
	end

	if obj_type == "thread" then
		return StringFormat("%s%s%s",
			self:HyperLink(Examine_local),
			tostring(obj),
			HLEnd
		)
	end

	if obj_type == "string" then
		-- some translated stuff has <color in it, so we make sure they don't bother the rest
		return StringFormat("'%s</color></color>'",obj)
	end

	if obj_type == "userdata" then

		if IsPoint(obj) then
			-- InvalidPos()
			if obj == InvalidPos then
				return S[302535920000066--[[<color 203 120 30>Off-Map Pos</color>--]]]
			else
				return StringFormat("%s%s(%s,%s,%s)%s",
					self:HyperLink(ShowMe_local),
					S[302535920001396--[[point--]]],
					obj:x(),
					obj:y(),
					obj:z() or 0,
					HLEnd
				)
			end
		else
			-- show translated text if possible and return a clickable link
			local trans = Trans(obj)
			-- stripped = pre-gagarin
			if trans == "stripped" or trans:find("Missing text") then
				trans = tostring(obj)
			end
			-- the </color> is to make sure it doesn't bleed into other text
			return StringFormat("%s</color></color>%s < %s%s",
				trans,
				self:HyperLink(Examine_local),
				getmetatable(obj).__name or tostring(obj),
				HLEnd
			)
		end
	end

	if obj_type == "table" then

		if IsValid(obj) then
			return StringFormat("%s%s%s@%s",
				self:HyperLink(Examine_local),
				obj.class,
				HLEnd,
				self:valuetotextex(obj:GetPos())
			)

		else
			local len = #obj
			local obj_metatable = getmetatable(obj)

			-- if it's an objlist then we just return a list of the objects
			if obj_metatable and IsObjlist(obj_metatable) then
				local res = {
					self:HyperLink(Examine_local),
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

				-- not sure how to check if it's an index non-ass table
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

				return StringFormat("%s%s%s",
					self:HyperLink(Examine_local),
					name,
					HLEnd
				)
			end
		end
	end

	return tostring(obj)
end

function Examine:HyperLink(f, custom_color)
	self.onclick_handles[#self.onclick_handles+1] = f
	return StringFormat("%s<h %s 230 195 50>",
		custom_color or "<color 150 170 250>",
		#self.onclick_handles
	)
end

---------------------------------------------------------------------------------------------------------------------
local function ExamineThreadLevel_totextex(level,info,obj,self)
	local ExamineThreadLevel_data
	if blacklist then
		ExamineThreadLevel_data = RetThreadInfo(obj)
	else
		ExamineThreadLevel_data = {}
		local l = 1
		local name, val
		repeat
			name, val = getlocal(obj, level, l)
			if name then
				ExamineThreadLevel_data[name] = val
				l = l + 1
			else
				break
			end
		until not name

		for i = 1, info.nups do
			local name, val = getupvalue(info.func, i)
			if name ~= nil and val ~= nil then
				ExamineThreadLevel_data[StringFormat("%s (up)",name)] = val
			end
		end
	end

	ChoGGi.ComFuncs.OpenInExamineDlg(ExamineThreadLevel_data,self,StringFormat("%s: %s",S[302535920001353--[[Thread info--]]],RetName(obj))
	)
end

local totextex_res = {}
local totextex_sort = {}
local totextex_dupes = {}
function Examine:totextex(obj,obj_type)
	TableIClear(totextex_res)
	TableClear(totextex_sort)
	TableClear(totextex_dupes)
	local obj_metatable = getmetatable(obj)
	local c = 0

	if obj_type == "nil" then
		return obj_type
	elseif obj_type == "boolean" or obj_type == "number" then
		return tostring(obj)
	elseif obj_type == "string" then
		return obj
	end

	if obj_type == "table" then


		local name
		for k, v in pairs(obj) do

			-- sorely needed delay for chinese
			if self.is_chinese then
				Sleep(1)
			end

			name = self:valuetotextex(k)
			-- gotta store all the names if we're doing all props (no dupes thanks)
			totextex_dupes[name] = true
			c = c + 1
			totextex_res[c] = StringFormat("%s = %s<left>",
				name,
				self:valuetotextex(v)
			)
			if type(k) == "number" then
				totextex_sort[totextex_res[c]] = k
			end
		end

		-- keep looping through metatables till we run out
		if obj_metatable and self.show_all_values then
			local meta_temp = obj_metatable
			while meta_temp do
				for k in pairs(meta_temp) do

					name = self:valuetotextex(k)
					if not totextex_dupes[name] then
						totextex_dupes[name] = true
						c = c + 1
						totextex_res[c] = StringFormat("%s = %s<left>",
							name,
							self:valuetotextex(obj[k])
						)
					end

				end
				meta_temp = getmetatable(meta_temp)
			end
		end

	elseif obj_type == "thread" then

		if blacklist then
			c = c + 1
			totextex_res[c] = RetThreadInfo(obj)
		else
			local level, info = 0
			repeat
				info = getinfo(obj, level, "Slfun")
				if info then
					local l_level, l_info = level, info
					c = c + 1
					totextex_res[c] = StringFormat("%s%s(%s) %s: %s%s",
						self:HyperLink(function()
							ExamineThreadLevel_totextex(l_level,l_info,obj,self)
						end),
						info.short_src or info.source,
						info.currentline,
						S[1000110--[[Type--]]],
						info.name ~= "" and info.name or info.name_what ~= "" and info.name_what or info.what ~= "" and info.what or S[302535920000723--[[Lua--]]],
						HLEnd
					)
				else
					break
				end
				level = level + 1
			until not info
		end

	elseif obj_type == "function" then
		if blacklist then
			c = c + 1
			totextex_res[c] = self:valuetotextex(tostring(obj))
			c = c + 1
			totextex_res[c] = self:valuetotextex(DebugGetInfo(obj))
		else
			c = c + 1
			totextex_res[c] = self:valuetotextex(tostring(obj))
			local level = 1
			local k, v = true
			while k do
				k, v = getupvalue(obj, level)
				if k then
					c = c + 1
					totextex_res[c] = StringFormat("%s = %s < %s: %s",
						self:valuetotextex(k),
						self:valuetotextex(v),
						S[302535920001358--[[debug.upvalue() level--]]],
						level
					)
				else
					c = c + 1
					totextex_res[c] = self:valuetotextex(obj)
					break
				end
				level = level + 1
			end
		end

	end

	TableSort(totextex_res, function(a, b)
		if totextex_sort[a] and totextex_sort[b] then
			return totextex_sort[a] < totextex_sort[b]
		end
		if totextex_sort[a] or totextex_sort[b] then
			return totextex_sort[a] and true
		end
		return CmpLower(a, b)
	end)

	if IsValid(obj) and obj:IsKindOf("CObject") then

		TableInsert(totextex_res,1,StringFormat(--[[<center>----]]"\t\t\t\t--%s%s%s@%s--"--[[--<vspace 6><left>--]],
			self:HyperLink(function()
				ChoGGi.ComFuncs.OpenInExamineDlg(getmetatable(obj),self)
			end),
			obj.class,
			HLEnd,
			self:valuetotextex(obj:GetPos())
		))

		if obj:IsValidPos() and IsValidEntity(obj.entity) and 0 < obj:GetAnimDuration() then
			local pos = obj:GetVisualPos() + obj:GetStepVector() * obj:TimeToAnimEnd() / obj:GetAnimDuration()
			TableInsert(totextex_res, 2, StringFormat("%s, step:%s%s%s",
				GetStateName(obj:GetState()),
				self:HyperLink(function()
					ShowMe(pos)
				end),
				tostring(obj:GetStepVector(obj:GetState(),0)),
				HLEnd
			))
		end

	elseif obj_type == "table" and obj_metatable then
			TableInsert(totextex_res, 1, StringFormat(--[[<center>----]]"\t\t\t\t--%s: metatable--"--[[: metatable--<vspace 6><left>--]],
				self:valuetotextex(obj_metatable)
			))
	end

		-- add strings/numbers to the body
	if obj_type == "number" or obj_type == "string" or obj_type == "boolean" then
		c = c + 1
		totextex_res[c] = tostring(obj)

	elseif obj_type == "userdata" then
		local trans = Trans(obj)
		-- might as well just return userdata instead of these
		-- stripped = pre-gagarin
		if trans == "stripped" or trans:find("Missing text") then
			trans = tostring(obj)
		else
			trans = StringFormat("%s < %s</color></color>",obj,trans)
		end
		c = c + 1
		totextex_res[c] = trans

		-- add any functions from getmeta to the (scant) list
		if obj_metatable then
			local data_meta = {}
			local c2 = 0
			for k, v in pairs(obj_metatable) do
				c2 = c2 + 1
				data_meta[c2] = StringFormat("%s = %s",
					self:valuetotextex(k),
					self:valuetotextex(v)
				)
			end
			TableSort(data_meta, function(a, b)
				return CmpLower(a, b)
			end)

			-- add some info for HGE. stuff
			local name = obj_metatable.__name
			if name == "HGE.TaskRequest" then
				TableInsert(data_meta,1,StringFormat("\nGetBuilding(): %s",self:valuetotextex(obj:GetBuilding())))
				TableInsert(data_meta,2,StringFormat("GetWorkingUnits(): %s",self:valuetotextex(obj:GetWorkingUnits())))
				TableInsert(data_meta,3,StringFormat("GetActualAmount(): %s",self:valuetotextex(obj:GetActualAmount())))
				TableInsert(data_meta,4,StringFormat("GetDesiredAmount(): %s",self:valuetotextex(obj:GetDesiredAmount())))
				TableInsert(data_meta,5,StringFormat("GetTargetAmount(): %s",self:valuetotextex(obj:GetTargetAmount())))
				TableInsert(data_meta,6,StringFormat("GetFillIndex(): %s",self:valuetotextex(obj:GetFillIndex())))
				TableInsert(data_meta,7,StringFormat("GetFreeUnitSlots(): %s",self:valuetotextex(obj:GetFreeUnitSlots())))
				TableInsert(data_meta,8,StringFormat("GetLastServiced(): %s",self:valuetotextex(obj:GetLastServiced())))
				TableInsert(data_meta,9,StringFormat("GetReciprocalRequest(): %s",self:valuetotextex(obj:GetReciprocalRequest())))
				TableInsert(data_meta,10,StringFormat("GetFlags(): %s",self:valuetotextex(obj:GetFlags())))
				TableInsert(data_meta,11,StringFormat("IsAnyFlagSet(): %s",self:valuetotextex(obj:IsAnyFlagSet())))
				TableInsert(data_meta,12,StringFormat("Unpack(): %s",self:valuetotextex(obj:Unpack())))
				TableInsert(data_meta,13,"\ngetmetatable():")
			elseif name == "HGE.Grid" then
				TableInsert(data_meta,1,StringFormat("\nsize(): %s",self:valuetotextex(obj:size())))
				TableInsert(data_meta,2,StringFormat("max_value(): %s",self:valuetotextex(obj:max_value())))
				TableInsert(data_meta,3,StringFormat("get_default(): %s",self:valuetotextex(obj:get_default())))
				TableInsert(data_meta,4,"\ngetmetatable():")
			elseif name == "HGE.XMGrid" then
				TableInsert(data_meta,1,StringFormat("\nCenterOfMass(): %s",self:valuetotextex(obj:CenterOfMass())))
				TableInsert(data_meta,2,StringFormat("EnumZones(): %s",self:valuetotextex(obj:EnumZones())))
				TableInsert(data_meta,3,StringFormat("GetBilinear(): %s",self:valuetotextex(obj:GetBilinear())))
				TableInsert(data_meta,4,StringFormat("GetPositiveCells(): %s",self:valuetotextex(obj:GetPositiveCells())))
				TableInsert(data_meta,5,StringFormat("levels(): %s",self:valuetotextex(obj:levels())))
				TableInsert(data_meta,6,"\ngetmetatable():")
				local minmax = {obj:minmax()}
				if minmax[1] then
					TableInsert(data_meta,6,StringFormat("minmax(): %s %s",minmax[1],minmax[2]))
				end
			elseif name == "HGE.Box" then
				TableInsert(data_meta,1,StringFormat("\nIsValid(): %s",self:valuetotextex(obj:IsValid())))
				TableInsert(data_meta,2,StringFormat("IsValidZ(): %s",self:valuetotextex(obj:IsValidZ())))
				TableInsert(data_meta,3,StringFormat("size(): %s",self:valuetotextex(obj:size())))
				local Radius = self:valuetotextex(obj:Radius())
				TableInsert(data_meta,4,StringFormat("Radius(): %s",Radius))
				TableInsert(data_meta,5,StringFormat("ToPoints2D(): %s",self:valuetotextex(obj:ToPoints2D())))
				TableInsert(data_meta,6,StringFormat("IsEmpty(): %s",self:valuetotextex(obj:IsEmpty())))
				TableInsert(data_meta,7,StringFormat("Center(): %s",self:valuetotextex(obj:Center())))
				TableInsert(data_meta,8,StringFormat("GetBSphere(): %s",self:valuetotextex(obj:GetBSphere())))
				TableInsert(data_meta,9,StringFormat("max(): %s",self:valuetotextex(obj:max())))
				TableInsert(data_meta,10,StringFormat("min(): %s",self:valuetotextex(obj:min())))
				TableInsert(data_meta,11,"\ngetmetatable():")
				local Radius2D = self:valuetotextex(obj:Radius2D())
				if Radius ~= Radius2D then
					TableInsert(data_meta,5,StringFormat("Radius2D(): %s",Radius2D))
				end
			elseif name == "HGE.Point" then
				TableInsert(data_meta,1,StringFormat("\nIsValid(): %s",self:valuetotextex(obj:IsValid())))
				TableInsert(data_meta,2,StringFormat("IsValidZ(): %s",self:valuetotextex(obj:IsValidZ())))
				TableInsert(data_meta,3,StringFormat("x(): %s",self:valuetotextex(obj:x())))
				TableInsert(data_meta,4,StringFormat("y(): %s",self:valuetotextex(obj:y())))
				TableInsert(data_meta,5,StringFormat("z(): %s",self:valuetotextex(obj:z())))
				TableInsert(data_meta,6,StringFormat("__unm(): %s",self:valuetotextex(obj:__unm())))
				TableInsert(data_meta,7,"\ngetmetatable():")
			elseif name == "HGE.RandState" then
				TableInsert(data_meta,1,StringFormat("\nCount(): %s",self:valuetotextex(obj:Count())))
				TableInsert(data_meta,2,StringFormat("Get(): %s",self:valuetotextex(obj:Get())))
				TableInsert(data_meta,3,StringFormat("GetStable(): %s",self:valuetotextex(obj:GetStable())))
				TableInsert(data_meta,4,StringFormat("Last(): %s",self:valuetotextex(obj:Last())))
				TableInsert(data_meta,5,"\ngetmetatable():")
			elseif name == "HGE.Quaternion" then
				TableInsert(data_meta,1,StringFormat("\nGetAxisAngle(): %s",self:valuetotextex(obj:GetAxisAngle())))
				TableInsert(data_meta,2,StringFormat("GetRollPitchYaw(): %s",self:valuetotextex(obj:GetRollPitchYaw())))
				TableInsert(data_meta,3,StringFormat("Inv(): %s",self:valuetotextex(obj:Inv())))
				TableInsert(data_meta,4,StringFormat("Norm(): %s",self:valuetotextex(obj:Norm())))
				TableInsert(data_meta,5,"\ngetmetatable():")
			elseif name == "LuaPStr" then
				TableInsert(data_meta,1,StringFormat("\nsize(): %s",self:valuetotextex(obj:size())))
				TableInsert(data_meta,2,StringFormat("getInt(): %s",self:valuetotextex(obj:getInt())))
				TableInsert(data_meta,3,StringFormat("parseTuples(): %s",self:valuetotextex(obj:parseTuples())))
				TableInsert(data_meta,4,StringFormat("str(): %s",self:valuetotextex(obj:str())))
				TableInsert(data_meta,5,StringFormat("hash(): %s",self:valuetotextex(obj:hash())))
				TableInsert(data_meta,6,"\ngetmetatable():")
			else
				TableInsert(data_meta,1,"\ngetmetatable():")
			end

			c = c + 1
			totextex_res[c] = TableConcat(data_meta,"\n")
		end

	-- add some extra info for funcs
	elseif obj_type == "function" then
		local dbg_value
		if blacklist then
			dbg_value = StringFormat("\ndebug.getinfo(): %s",DebugGetInfo(obj))
		else
			dbg_value = "\ndebug.getinfo(): "
			for key,value in pairs(getinfo(obj) or {}) do
				dbg_value = StringFormat("%s\n%s: %s",dbg_value,key,self:valuetotextex(value))
			end
		end
		c = c + 1
		totextex_res[c] = dbg_value

	elseif obj_type == "thread" then
		c = c + 1
		totextex_res[c] = StringFormat([[

<color 255 255 255>%s:
IsValidThread(): %s
GetThreadStatus(): %s
IsGameTimeThread(): %s
IsRealTimeThread(): %s
ThreadHasFlags(): %s</color>]],
			S[302535920001353--[[Thread info--]]],
			IsValidThread(obj),
			GetThreadStatus(obj),
			IsGameTimeThread(obj),
			IsRealTimeThread(obj),
			ThreadHasFlags(obj)
		)

	end

	return TableConcat(totextex_res,"\n")
end
---------------------------------------------------------------------------------------------------------------------
--menu
local function DeleteAll_menu(_,_,_,self)
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000059--[[Destroy all objects in objlist!--]]],
		function(answer)
			if answer then
				for _, v in pairs(self.obj) do
					if IsValid(v) then
						DeleteObject(v)
					end
				end
				-- force a refresh on the list, so people can see something as well
				self:SetObj()
			end
		end,
		S[697--[[Destroy--]]]
	)
end
local function MarkAll_menu(_,_,_,self)
	for _, v in pairs(self.obj) do
		if IsPoint(v) or IsValid(v) then
			ShowMe(v, nil, nil, "single")
		end
	end
end
local function MarkObject_menu(_,_,_,self)
	if IsValid(self.obj) then
		ShowMe(self.obj)
	else
		for k, v in pairs(self.obj) do
			ShowMe(k)
			ShowMe(v)
		end
	end
end

local function Destroy_menu(_,_,_,self)
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000414--[[Are you sure you wish to destroy it?--]]],
		function(answer)
			if answer then
				DoneObject(self.obj)
			end
		end,
		S[697--[[Destroy--]]]
	)
end

local function Refresh_menu(_,_,_,self)
	self:SetObj()
	if IsKindOf(self.obj,"XWindow") and self.obj.class ~= "InGameInterface" then
		self:FlashWindow()
	end
end
local function SetTransp_menu(_,_,_,self)
	self.transp_mode = not self.transp_mode
	self:SetTranspMode(self.transp_mode)
end
local function ShowDiffProps_menu(_,_,_,self)
	ChoGGi.ComFuncs.OpenInExamineDlg(GetModifiedProperties(self.obj_ref),self,StringFormat("%s: %s",S[931--[[Modified property--]]],RetName(self.obj)))
end
local function ShowAllProps_menu(_,_,_,self)
	-- give em some hints
	local props_list = {
		___readme = S[302535920001397--[["These can be used as obj:GetNAME() / obj:SetNAME().
You can access a default value with obj:GetDefaultPropertyValue(""NAME"")
Check the actual object/g_Classes.object for the correct value to use (Entity > entity).
--]]]
	}
	local props = self.obj_ref:GetProperties()
	for i = 1, #props do
		props_list[props[i].id] = self.obj_ref:GetProperty(props[i].id)
	end
	ChoGGi.ComFuncs.OpenInExamineDlg(props_list,self,StringFormat("%s: %s",S[302535920001389--[[All Properties--]]],RetName(self.obj)))
end
local function ShowAnimDebug_menu(_,_,_,self)
	ChoGGi.ComFuncs.ShowAnimDebug_Toggle(self.obj_ref)
end
local function ShowAttachSpots_menu(_,_,_,self)
	ChoGGi.ComFuncs.AttachSpots_Toggle(self.obj_ref)
end

function Examine:menu(obj)
	local obj_type = type(obj)
	local res = {
		self:HyperLink(Refresh_menu),
		" <image CommonAssets/UI/Menu/reload.tga 2000> ",
		HLEnd,
		self:HyperLink(SetTransp_menu),
		" <image CommonAssets/UI/Menu/CutSceneArea.tga 2000> ",
		HLEnd,
		self:HyperLink(ChoGGi.ComFuncs.ClearShowMe),
		" <image CommonAssets/UI/Menu/NoblePreview.tga 2000> ",
		HLEnd,
	}

	if obj_type == "table" then
		local c = #res
		if IsValid(obj) then
			-- show
			c = c + 1
			res[c] = self:HyperLink(MarkObject_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/DisableEyeSpec.tga 2000> "
			c = c + 1
			res[c] = HLEnd
			-- show anim info
			c = c + 1
			res[c] = self:HyperLink(ShowAnimDebug_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/CameraEditor.tga 2000> "
			c = c + 1
			res[c] = HLEnd
			-- attach spots
			c = c + 1
			res[c] = self:HyperLink(ShowAttachSpots_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/ShowAll.tga 2000> "
			c = c + 1
			res[c] = HLEnd
		end

		if obj.class then
			-- show diff props
			c = c + 1
			res[c] = self:HyperLink(ShowDiffProps_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/SelectByClass.tga 2000> "
			c = c + 1
			res[c] = HLEnd
			-- show props
			c = c + 1
			res[c] = self:HyperLink(ShowAllProps_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/AreaProperties.tga 2000> "
			c = c + 1
			res[c] = HLEnd
			-- delete
			c = c + 1
			res[c] = self:HyperLink(Destroy_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/delete_objects.tga 2000> "
			c = c + 1
			res[c] = HLEnd
		end

		if IsObjlist(obj) then
			-- mark all
			c = c + 1
			res[c] = self:HyperLink(MarkAll_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/ExportImageSequence.tga 2000> "
			c = c + 1
			res[c] = HLEnd
			-- delete all
			c = c + 1
			res[c] = self:HyperLink(DeleteAll_menu)
			c = c + 1
			res[c] = " <image CommonAssets/UI/Menu/UnlockCollection.tga 2000> "
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
			name = StringFormat("	 ---- %s",title),
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

function Examine:SetObj(startup)
	local obj = self.obj

	self.onclick_handles = {}

	if self.str_object then
		-- check if obj string is a ref to an actual object
		local obj_ref = DotNameToObject(obj)
		-- if it is then we use that as the obj to examine
		if obj_ref then
			obj = obj_ref
		end
	end
	-- so we can access the obj elsewhere
	self.obj_ref = obj

	local obj_type = type(obj)
	local obj_class

	self.idLinks:SetText(self:menu(obj))

	local name = RetName(obj)
	self.idText:SetText(StringFormat("%s: %s",name,S[67--[[Loading resources--]]]))

	if obj_type == "table" then
		obj_class = g_Classes[obj.class]
		if getmetatable(obj) then
			self.idShowAllValues:SetVisible(true)
		else
			self.idShowAllValues:SetVisible(false)
		end

		-- add object name to title
		if obj_class and obj.handle and #obj > 0 then
			name = StringFormat("%s: %s (%s)",name,obj.handle,#obj)
		elseif obj_class and obj.handle then
			name = StringFormat("%s (%s)",name,obj.handle)
		elseif #obj > 0 then
			name = StringFormat("%s (%s)",name,#obj)
		end

		-- build parents/ancestors menu
		if obj_class then
			self.parents_menu_popup = {}
			self.pmenu_skip_dupes = {}
			-- build menu list
			self:BuildParents(obj.__parents,"parents",S[302535920000520--[[Parents--]]])
			self:BuildParents(obj.__ancestors,"ancestors",S[302535920000525--[[Ancestors--]]],true)
			-- if anything was added to the list then add to the menu
			if #self.parents_menu_popup > 0 then
				self.idParents:SetVisible(true)
			end
		end

		-- attaches button/menu
		if IsValid(obj) and obj.ForEachAttach then
			TableIClear(self.attaches_menu_popup)
			local attach_amount = 0

			obj:ForEachAttach(function(a)
				attach_amount = attach_amount + 1
				local pos = a.GetVisualPos and a:GetVisualPos()

				self.attaches_menu_popup[attach_amount] = {
					name = RetName(a),
					hint = StringFormat("%s\n%s: %s\npos: %s",
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
				TableSort(self.attaches_menu_popup, function(a, b)
					return CmpLower(a.name, b.name)
				end)

				self.idAttaches:SetVisible(true)
				self.idAttaches.RolloverText = S[302535920000070--[["Shows list of attachments. This %s has %s.
Use %s to hide green markers."--]]]:format(name,attach_amount,"<image CommonAssets/UI/Menu/NoblePreview.tga 2500>")
			else
				self.idAttaches:SetVisible()
			end
		end

	end -- istable

	-- limit caption length so we don't cover up close button
	self.idCaption:SetTitle(self,self.title or utf8.sub(name,1,45))

	-- we add a slight delay, so the rest of the dialog shows up; for bigger lists like _G or MapGet(true)
	if startup then
		CreateRealTimeThread(function()
			Sleep(5)
			self.idText:SetText(self:totextex(obj,obj_type))
		end)
	else
		self.idText:SetText(self:totextex(obj,obj_type))
	end

	return obj_class

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
	Examine.examine_dialogs[self.obj] = nil
	ChoGGi_Window.Done(self,result)
end
