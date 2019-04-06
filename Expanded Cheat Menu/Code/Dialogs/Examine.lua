-- See LICENSE for terms

-- used to examine objects

-- to add a clickable link use:
--[[
XXXXX = {
	ChoGGi_AddHyperLink = true,
	name = "do something",
	func = function(self, button, obj, argument, hyperlink_box, pos) end,
}
--]]

local pairs,type,tostring,tonumber,rawget = pairs,type,tostring,tonumber,rawget

-- store opened examine dialogs
if not rawget(_G,"g_ExamineDlgs") then
	g_ExamineDlgs = objlist:new()
end

-- local some global funcs
local table_clear = table.clear
local table_iclear = table.iclear
local table_insert = table.insert
local table_sort = table.sort
local CmpLower = CmpLower
local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local EnumVars = EnumVars
local GetStateName = GetStateName
local IsKindOf = IsKindOf
local IsPoint = IsPoint
local IsT = IsT
local IsValid = IsValid
local IsValidEntity = IsValidEntity
local IsValidThread = IsValidThread
local PropObjGetProperty = PropObjGetProperty
local Sleep = Sleep
local XCreateRolloverWindow = XCreateRolloverWindow
local XDestroyRolloverWindow = XDestroyRolloverWindow

local hyperlink_end = "</h></color>"

--~ local any funcs used a lot
local IsControlPressed = ChoGGi.ComFuncs.IsControlPressed
local RetName = ChoGGi.ComFuncs.RetName
local TableConcat = ChoGGi.ComFuncs.TableConcat
local Translate = ChoGGi.ComFuncs.Translate
local IsObjlist = ChoGGi.ComFuncs.IsObjlist
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind

local InvalidPos = ChoGGi.Consts.InvalidPos
local Strings = ChoGGi.Strings
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

local debug_getinfo,debug_getupvalue,debug_getlocal
local debug = blacklist and false or debug
if debug then
	debug_getupvalue = debug.getupvalue
	debug_getinfo = debug.getinfo
	debug_getlocal = debug.getlocal
end

local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"Examine")
end
DefineClass.Examine = {
	__parents = {"ChoGGi_Window"},

	-- what we're examining
	obj = false,
	-- whatever RetName is
	name = false,
	-- if we're examining a string we want to convert to an object
	str_object = false,
	-- we store the str_object > obj here
	obj_ref = false,
	-- used to store visibility of obj
	orig_vis_flash = false,
	flashing_thread = false,
	-- if it's transparent or not
	transp_mode = false,
	-- get list of all values from metatables
	show_all_values = false,
	-- list values from EnumVars()
	show_enum_values = false,
	-- stores enummed list
	enum_vars = false,
	-- going in through the backdoor
	sort_dir = false,
	-- if TaskRequest then store flags here
	obj_flags = false,
	-- delay between updating for autoref
	autorefresh_delay = 1000,
	-- any objs from this examine that were marked with a sphere/colour
	marked_objects = false,

	-- only chinese goes slow as shit for some reason, so i added this to at least stop the game from freezing till obj is examined
	is_chinese = false,

	dialog_width = 666.0,
	dialog_height = 850.0,

	-- add some random numbers as ids so when you click a popup of the same name from another examine it'll close then open the new one
	idAttachesMenu = false,
	idParentsMenu = false,
	idToolsMenu = false,
	idObjectsMenu = false,
	-- tables
	parents_menu_popup = false,
	attaches_menu_popup = false,
	tools_menu_popup = false,
	objects_menu_popup = false,

	pmenu_skip_dupes = false,
	parents = false,
	ancestors = false,
	menu_added = false,
	menu_list_items = false,
	-- clickable purple text
	onclick_funcs = false,
	onclick_name = false,
	onclick_objs = false,
	onclick_count = false,
	hex_shape_tables = false,

	idAutoRefresh_update_str = false,
}

function Examine:Init(parent, context)
	local g_Classes = g_Classes

	self.obj = context.obj

	-- already examining list
	g_ExamineDlgs[self.obj] = self

	self.ChoGGi = ChoGGi
	local const = const

	-- my popup func checks for ids and "refreshs" a popup with the same id, so random it is
	self.idAttachesMenu = self.ChoGGi.ComFuncs.Random()
	self.idParentsMenu = self.ChoGGi.ComFuncs.Random()
	self.idToolsMenu = self.ChoGGi.ComFuncs.Random()
	self.idObjectsMenu = self.ChoGGi.ComFuncs.Random()

	self.attaches_menu_popup = {}
	self.parents_menu_popup = {}
	self.pmenu_skip_dupes = {}
	self.parents = {}
	self.ancestors = {}
	self.menu_added = {}
	self.menu_list_items = {}
	self.onclick_funcs = {}
	self.onclick_name = {}
	self.onclick_objs = {}
	self.onclick_count = 0
	self.marked_objects = objlist:new()

	-- if we're examining a string we want to convert to an object
	if type(self.obj) == "string" then
		if context.parent == "str" then
			self.str_object = context.parent == "str" and true
			context.parent = nil
		elseif not blacklist then
			local err, files = AsyncListFiles(self.obj)
			if not err and #files > 0 then
				self.obj = files
			end
		end
	end

	self.name = RetName(self.str_object and self.ChoGGi.ComFuncs.DotNameToObject(self.obj) or self.obj)

	self.title = context.title

	self.prefix = Strings[302535920000069--[[Examine--]]]

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	do -- toolbar area
		-- everything grouped gets a window to go in
		self.idToolbarArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idToolbarArea",
			Dock = "top",
			DrawOnTop = true,
		}, self.idDialog)

		self.idToolbarButtons = g_Classes.ChoGGi_DialogSection:new({
			Id = "idToolbarButtons",
			Dock = "left",
			LayoutMethod = "HList",
			DrawOnTop = true,
		}, self.idToolbarArea)

		self.idToolbarButtons:AddInterpolation{
			type = const.intAlpha,
			startValue = 255,
			flags = const.intfIgnoreParent
		}

		-- add all the toolbar buttons than toggle vis when we set the menu
		self.idButRefresh = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButRefresh",
			Image = "CommonAssets/UI/Menu/reload.tga",
			RolloverTitle = Translate(1000220--[[Refresh--]]),
			RolloverText = Strings[302535920000092--[[Updates list with any changed values.--]]],
			OnPress = self.idButRefreshOnPress,
		}, self.idToolbarButtons)
		--
		self.idButSetTransp = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButSetTransp",
			Image = "CommonAssets/UI/Menu/CutSceneArea.tga",
			RolloverTitle = Strings[302535920000865--[[Translate--]]],
			RolloverText = Strings[302535920001367--[[Toggles--]]] .. " " .. Strings[302535920000629--[[UI Transparency--]]],
			OnPress = self.idButSetTranspOnPress,
		}, self.idToolbarButtons)
		--
		self.idButClear = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButClear",
			Image = "CommonAssets/UI/Menu/NoblePreview.tga",
			RolloverTitle = Translate(594--[[Clear--]]),
			RolloverText = Strings[302535920000016--[["Remove any green spheres/reset green coloured objects
Press once to clear this examine, again to clear all."--]]],
			OnPress = self.idButClearOnPress,
		}, self.idToolbarButtons)
		--
		self.idButMarkObject = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButMarkObject",
			Image = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
			RolloverTitle = Strings[302535920000057--[[Mark Object--]]],
			RolloverText = Strings[302535920000021--[[Mark object with green sphere and/or paint.--]]],
			OnPress = self.idButMarkObjectOnPress,
		}, self.idToolbarButtons)
		--
		self.idButDeleteObj = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButDeleteObj",
			Image = "CommonAssets/UI/Menu/delete_objects.tga",
			RolloverTitle = Translate(502364928914--[[Delete--]]),
			RolloverText = Strings[302535920000414--[[Are you sure you wish to delete it?--]]]:format(self.name),
			OnPress = self.idButDeleteObjOnPress,
		}, self.idToolbarButtons)
		--
		self.idButSetObjlist = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButSetObjlist",
			Image = "CommonAssets/UI/Menu/toggle_post.tga",
			RolloverTitle = Strings[302535920001558--[[Toggle Objlist--]]],
			RolloverText = Strings[302535920001559--[[Toggle setting the metatable for this table to an objlist (for using mark/delete all).--]]],
			OnPress = self.idButToggleObjlistOnPress,
		}, self.idToolbarButtons)
		--
		self.idButMarkAll = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButMarkAll",
			Image = "CommonAssets/UI/Menu/ExportImageSequence.tga",
			RolloverTitle = Strings[302535920000058--[[Mark All Objects--]]],
			RolloverText = Strings[302535920000056--[[Mark all items in objlist with green spheres.--]]],
			OnPress = self.idButMarkAllOnPress,
		}, self.idToolbarButtons)
		--
		self.idButMarkAllLine = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButMarkAllLine",
			Image = "CommonAssets/UI/Menu/ShowOcclusion.tga",
			RolloverTitle = Strings[302535920001512--[[Mark All Objects (Line)--]]],
			RolloverText = Strings[302535920001513--[[Add a line connecting all items in list.--]]],
			OnPress = self.idButMarkAllLineOnPress,
		}, self.idToolbarButtons)
		--
		self.idButDeleteAll = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButDeleteAll",
			Image = "CommonAssets/UI/Menu/UnlockCollection.tga",
			RolloverTitle = Translate(3768--[[Destroy all?--]]),
			RolloverText = Strings[302535920000059--[[Destroy all objects in objlist!--]]],
			OnPress = self.idButDeleteAllOnPress,
		}, self.idToolbarButtons)

		-- far right side
		self.idToolbarButtonsRightRefresh = g_Classes.ChoGGi_DialogSection:new({
			Id = "idToolbarButtonsRightRefresh",
			Dock = "right",
			LayoutMethod = "HList",
			DrawOnTop = true,
		}, self.idToolbarArea)

		self.idAutoRefresh_update_str = Strings[302535920001257--[[Auto-refresh list every second.--]]]
			.. "\n" .. Strings[302535920001422--[[Right-click to change refresh delay.--]]]
			.. "\n" .. Strings[302535920000106--[[Current--]]] .. ": <color 100 255 100>%s</color>"
		self.idAutoRefresh = g_Classes.ChoGGi_CheckButton:new({
			Id = "idAutoRefresh",
			Dock = "right",
			Text = Strings[302535920000084--[[Auto-Refresh--]]],
			RolloverText = self.idAutoRefresh_update_str:format(self.autorefresh_delay),
			RolloverHint = Strings[302535920001425--[["<left_click> Toggle, <right_click> Set Delay"--]]],
			OnChange = self.idAutoRefreshOnChange,
			OnMouseButtonDown = self.idAutoRefreshOnMouseButtonDown,
			Init = self.CheckButtonInit,
		}, self.idToolbarButtonsRightRefresh)

		self.idAutoRefreshDelay = g_Classes.ChoGGi_TextInput:new({
			Id = "idAutoRefreshDelay",
			Dock = "left",
			MinWidth = 50,
			Margins = box(0,0,6,0),
			FoldWhenHidden = true,
			RolloverText = Strings[302535920000967--[[Delay in ms between updating text.--]]],
			OnTextChanged = self.idAutoRefreshDelayOnTextChanged,
		}, self.idToolbarButtonsRightRefresh)
		-- vis is toggled when rightclicking autorefresh checkbox
		self.idAutoRefreshDelay:SetVisible(false)
		self.idAutoRefreshDelay:SetText(tostring(self.autorefresh_delay))

		-- mid right
		self.idToolbarButtonsRight = g_Classes.ChoGGi_DialogSection:new({
			Id = "idToolbarButtonsRight",
			Dock = "right",
			LayoutMethod = "HList",
			DrawOnTop = true,
		}, self.idToolbarArea)

		--
		self.idViewEnum = g_Classes.ChoGGi_CheckButton:new({
			Id = "idViewEnum",
			MinWidth = 0,
			Text = Strings[302535920001442--[[Enum--]]],
			RolloverText = Strings[302535920001443--[[Show values from EnumVars(obj).--]]],
			OnChange = self.idViewEnumOnChange,
		}, self.idToolbarButtonsRight)
		--
		self.idShowAllValues = g_Classes.ChoGGi_CheckButton:new({
			Id = "idShowAllValues",
			MinWidth = 0,
			Text = Translate(4493--[[All--]]),
			RolloverText = Strings[302535920001391--[[Show all values: getmetatable(obj).--]]],
			OnChange = self.idShowAllValuesOnChange,
			Init = self.CheckButtonInit,
		}, self.idToolbarButtonsRight)
		--
		self.idSortDir = g_Classes.ChoGGi_CheckButton:new({
			Id = "idSortDir",
			Text = Translate(10124--[[Sort--]]),
			RolloverText = Strings[302535920001248--[[Sort normally or backwards.--]]],
			OnChange = self.idSortDirOnChange,
			Init = self.CheckButtonInit,
		}, self.idToolbarButtonsRight)
		--
	end -- toolbar area

	do -- search area
		self.idSearchArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idSearchArea",
			Dock = "top",
		}, self.idDialog)
		--
		self.idSearchText = g_Classes.ChoGGi_TextInput:new({
			Id = "idSearchText",
			RolloverText = Strings[302535920000043--[["Press <color 0 200 0>Enter</color> to scroll to next found text, <color 0 200 0>Ctrl-Enter</color> to scroll to previous found text, <color 0 200 0>Arrow Keys</color> to scroll to each end."--]]],
			Hint = Strings[302535920000044--[[Go To Text--]]],
			OnKbdKeyDown = self.idSearchTextOnKbdKeyDown,
		}, self.idSearchArea)
		--
		self.idSearch = g_Classes.ChoGGi_Button:new({
			Id = "idSearch",
			Text = Translate(10123--[[Search--]]),
			Dock = "right",
			RolloverAnchor = "right",
			RolloverHint = Strings[302535920001424--[["<left_click> Next, <right_click> Previous, <middle_click> Top"--]]],
			RolloverText = Strings[302535920000045--[["Scrolls down one line or scrolls between text in ""Go to text"".
Right-click <right_click> to go up, middle-click <middle_click> to scroll to the top."--]]],
			OnMouseButtonDown = self.idSearchOnMouseButtonDown,
		}, self.idSearchArea)
	end

	do -- tools area
		self.idMenuArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idMenuArea",
			Dock = "top",
		}, self.idDialog)
		--
		self.tools_menu_popup = self:BuildToolsMenuPopup()
		self.idTools = g_Classes.ChoGGi_ComboButton:new({
			Id = "idTools",
			Text = Strings[302535920000239--[[Tools--]]],
			RolloverText = Strings[302535920001426--[[Various tools to use.--]]],
			OnMouseButtonDown = self.idToolsOnMouseButtonDown,
			Dock = "left",
		}, self.idMenuArea)
		--
		self.objects_menu_popup = self:BuildObjectMenuPopup()
		self.idObjects = g_Classes.ChoGGi_ComboButton:new({
			Id = "idObjects",
			Text = Translate(298035641454--[[Object--]]),
			RolloverText = Strings[302535920001530--[[Various object tools to use.--]]],
			OnMouseButtonDown = self.idObjectsOnMouseButtonDown,
			Dock = "left",
			FoldWhenHidden = true,
		}, self.idMenuArea)
		self.idObjects:SetVisible(false)
		--
		self.idParents = g_Classes.ChoGGi_ComboButton:new({
			Id = "idParents",
			Text = Strings[302535920000520--[[Parents--]]],
			RolloverText = Strings[302535920000553--[[Examine parent and ancestor objects.--]]],
			OnMouseButtonDown = self.idParentsOnMouseButtonDown,
			Dock = "left",
			FoldWhenHidden = true,
		}, self.idMenuArea)
		self.idParents:SetVisible(false)
		--
		self.idAttaches = g_Classes.ChoGGi_ComboButton:new({
			Id = "idAttaches",
			Text = Strings[302535920000053--[[Attaches--]]],
			RolloverText = Strings[302535920000054--[[Any objects attached to this object.--]]],
			OnMouseButtonDown = self.idAttachesOnMouseButtonDown,
			Dock = "left",
			FoldWhenHidden = true,
		}, self.idMenuArea)
		self.idAttaches:SetVisible(false)
		--
		self.idToggleExecCode = g_Classes.ChoGGi_CheckButton:new({
			Id = "idToggleExecCode",
			Dock = "right",
			Text = Strings[302535920000040--[[Exec Code--]]],
			RolloverText = Strings[302535920001514--[[Toggle visibility of an input box for executing code.--]]]
				.. "\n" .. Strings[302535920001517--[["Use ""o"" as a reference to the examined object."--]]],
			OnChange = self.idToggleExecCodeOnChange,
			Init = self.CheckButtonInit,
		}, self.idMenuArea)
		--
	end -- tools area
	do -- exec code area
		self.idExecCodeArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idExecCodeArea",
			Dock = "top",
		}, self.idDialog)
		self.idExecCodeArea:SetVisible(false)
		--
		self.idExecCode = g_Classes.ChoGGi_TextInput:new({
			Id = "idExecCode",
			RolloverText = Strings[302535920001515--[[Press enter to execute code.--]]]
				.. "\n" .. Strings[302535920001517--[["Use ""o"" as a reference to the examined object."--]]],
			Hint = Strings[302535920001516--[[o = examined object--]]],
			OnKbdKeyDown = self.idExecCodeOnKbdKeyDown,
		}, self.idExecCodeArea)
		-- could change the bg for this...
		-- self.idExecCode:SetPlugins({"ChoGGi_CodeEditorPlugin"})
		--
	end -- exec code area

	-- text box with obj info in it
	self:AddScrollText()

	self.idText.OnHyperLink = self.idTextOnHyperLink
	self.idText.OnHyperLinkRollover = self.idTextOnHyperLinkRollover

	-- look at them sexy internals
	self.transp_mode = self.ChoGGi.Temp.transp_mode
	self:SetTranspMode(self.transp_mode)

	-- no need to have it fire one than once per dialog
	self.is_chinese = GetLanguage():find("chinese")

	-- do the magic
	if self:SetObj(true) then
		-- returns if it's a class object or not
		if self.ChoGGi.UserSettings.FlashExamineObject and IsKindOf(self.obj_ref,"XWindow") and self.obj_ref.class ~= "InGameInterface" then
			self:FlashWindow()
		end
	end

	self:PostInit(context.parent)
end

function Examine:ViewSourceCode()
	self = GetRootDialog(self)
	-- add link to view lua source
	local info = debug_getinfo(self.obj_ref,"S")
	-- =[C] is 4 chars
	local str,path = self.ChoGGi.ComFuncs.RetSourceFile(info.source)
	if not str then
		local msg = Strings[302535920001521--[[Lua source file not found.--]]] .. ": " .. ConvertToOSPath(path)
		self.ChoGGi.ComFuncs.MsgPopup(
			msg,
			Strings[302535920001519--[[View Source--]]]
		)
		print(msg)
		return
	end
	self.ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
		parent = self,
		checkbox = true,
		text = str,
		code = true,
		scrollto = info.linedefined,
		title = Strings[302535920001519--[[View Source--]]] .. ": " .. info.source,
		hint_ok = Strings[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
		custom_func = function(answer,overwrite)
			if answer then
				self.ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedSource","lua")
			end
		end,
	}
end

-- (link, hyperlink_box, pos)
function Examine:idTextOnHyperLinkRollover(link)
	self = GetRootDialog(self)

	if not self.ChoGGi.UserSettings.EnableToolTips then
		return
	end
	if not link then
		-- close opened tooltip
		if RolloverWin then
			XDestroyRolloverWindow()
		end
		return
	end

	link = tonumber(link)
	local obj = self.onclick_objs[link]
	if not obj then
		return
	end

	local title,obj_str,obj_type,obj_value
	if self.obj_type == "table" then
		-- "undefined global" bulldiddy workaround
		if self.name == "_G" then
			obj_value = PropObjGetProperty(self.obj_ref,obj)
		else
			obj_value = self.obj_ref[obj]
		end
		if type(obj_value) ~= "nil" then
			obj_str,obj_type = self.ChoGGi.ComFuncs.ValueToStr(obj_value)
		else
			obj_str,obj_type = self.ChoGGi.ComFuncs.ValueToStr(obj)
		end
		title = Strings[302535920000069--[[Examine--]]] .. " (" .. obj_type .. ")"
	else
		-- for anything that isn't a table
		title = Strings[302535920000069--[[Examine--]]]
	end

	local roll_text = RetName(obj)

	if self.onclick_funcs[link] == self.OpenListMenu then
		title = roll_text .. " " .. Translate(1000162--[[Menu--]]) .. " (" .. obj_type .. ")"

		roll_text = Strings[302535920001540--[[Show context menu for %s.--]]]:format(roll_text)

		-- add the value to the key tooltip
		roll_text = roll_text .. "\n\n\n" .. obj_str
		-- if it's an image then add 'er to the text
		if self.ChoGGi.ComFuncs.ImageExts()[obj_str:sub(-3):lower()] then
			roll_text = roll_text .. "\n\n<image " .. obj_str .. ">"
		end
--~ 		-- stick value in search box
--~ 		obj = self.obj_ref[obj]
--~ 		self.idSearchText:SetText(type(obj) == "userdata" and IsT(obj) and Translate(obj) or tostring(obj))
	end

	XCreateRolloverWindow(self.idDialog, RolloverGamepad, true, {
		RolloverTitle = title,
		RolloverText = (self.onclick_name[link] or roll_text),
		RolloverHint = Strings[302535920001079--[[<left_click> Default Action <right_click> Examine--]]],
	})
end

-- clicked
function Examine:idTextOnHyperLink(link, argument, hyperlink_box, pos, button)
	self = GetRootDialog(self)

	link = tonumber(link)
	local obj = self.onclick_objs[link]

	-- we always examine on right-click
	if button == "R" then
		self.ChoGGi.ComFuncs.OpenInExamineDlg(obj,self)
	else
		local func = self.onclick_funcs[link]
		if func then
			func(self, button, obj, argument, hyperlink_box, pos)
		end
	end

end
-- created
function Examine:HyperLink(obj, func, name)
	local c = self.onclick_count
	c = c + 1

	self.onclick_count = c
	self.onclick_objs[c] = obj
	self.onclick_funcs[c] = func
	if name then
		self.onclick_name[c] = name
	end

	return "<color 150 170 250><h " .. c .. " 230 195 50>",c
end

function Examine:idExecCodeOnKbdKeyDown(vk,...)
	if vk == const.vkEnter then
		if dlgConsole then
			o = GetRootDialog(self).obj_ref
			dlgConsole:Exec(self:GetText())
		end

		return "break"
	end

	return ChoGGi_TextInput.OnKbdKeyDown(self,vk,...)
end

function Examine:idToggleExecCodeOnChange(visible)
--~ 	-- if it's called directly we set the check if needed
--~ 	local checked = self:GetCheck()

	self = GetRootDialog(self)
	local vis = self.idExecCodeArea:GetVisible()
	if vis ~= visible then
		self.idExecCodeArea:SetVisible(not vis)
		self.idToggleExecCode:SetCheck(not vis)
	end
end

function Examine:idButRefreshOnPress()
	self = GetRootDialog(self)
	self:SetObj()
	if IsKindOf(self.obj_ref,"XWindow") and self.obj_ref.class ~= "InGameInterface" then
		self:FlashWindow()
	end
end
function Examine:RefreshExamine()
	self:idButRefreshOnPress()
end

function Examine:idButSetTranspOnPress()
	self = GetRootDialog(self)
	self.transp_mode = not self.transp_mode
	self:SetTranspMode(self.transp_mode)
end

function Examine:idButClearOnPress()
	self = GetRootDialog(self)
	-- clear marked objs for this examine
	local count = #self.marked_objects
	if count > 0 then
		for i = 1, count do
			self.ChoGGi.ComFuncs.ClearShowObj(self.marked_objects[i])
		end
	else
		-- clear all spheres
		self.ChoGGi.ComFuncs.ClearShowObj(true)
		-- if this has a custom colour
		self.ChoGGi.ComFuncs.ClearShowObj(self.obj_ref)
	end
	self.marked_objects:Clear()

	if IsObjlist(self.obj_ref) then
		self.ChoGGi.ComFuncs.ObjListLines_Clear(self.obj_ref)
	end
end

function Examine:idButMarkObjectOnPress()
	self = GetRootDialog(self)
	if IsValid(self.obj_ref) then
		-- i don't use AddSphere since that won't add the ColourObj
		local c = #self.marked_objects
		local sphere = self.ChoGGi.ComFuncs.ShowPoint(self.obj_ref)
		if IsValid(sphere) then
			c = c + 1
			self.marked_objects[c] = sphere
		end
		local obj = self.ChoGGi.ComFuncs.ColourObj(self.obj_ref)
		if IsValid(obj) then
			c = c + 1
			self.marked_objects[c] = obj
		end
	else
		local c = #self.marked_objects
		for _, v in pairs(self.obj_ref) do
			if IsPoint(v) or IsValid(v) then
				c = self:AddSphere(v,c)
			end
		end
	end
end

function Examine:idButDeleteObjOnPress()
	self = GetRootDialog(self)
	self.ChoGGi.ComFuncs.DeleteObjectQuestion(self.obj_ref)
end

function Examine:idButDeleteAllOnPress()
	self = GetRootDialog(self)
	self.ChoGGi.ComFuncs.QuestionBox(
		Strings[302535920000059--[[Destroy all objects in objlist!--]]],
		function(answer)
			if answer then
				SuspendPassEdits("Examine:idButDeleteAllOnPress")
				for _,obj in pairs(self.obj_ref) do
					if IsValid(obj) then
						self.ChoGGi.ComFuncs.DeleteObject(obj)
					elseif obj.delete then
						DoneObject(obj)
					end
				end
				ResumePassEdits("Examine:idButDeleteAllOnPress")
				-- force a refresh on the list, so people can see something as well
				self:SetObj()
			end
		end,
		Translate(697--[[Destroy--]])
	)
end
function Examine:idViewEnumOnChange()
	self = GetRootDialog(self)
	self.show_enum_values = not self.show_enum_values
	self:SetObj()
end

function Examine:idButMarkAllLineOnPress()
	self = GetRootDialog(self)
	self.ChoGGi.ComFuncs.ObjListLines_Toggle(self.obj_ref)
end

function Examine:idButMarkAllOnPress()
	self = GetRootDialog(self)
	local c = #self.marked_objects
	-- suspending makes it faster to add objects
	SuspendPassEdits("Examine:idButMarkAllOnPress")
	for _,v in pairs(self.obj_ref) do
		if IsValid(v) or IsPoint(v) then
			c = self:AddSphere(v,c,nil,true,true)
		end
	end
	ResumePassEdits("Examine:idButMarkAllOnPress")
	self.ChoGGi.ComFuncs.TableCleanDupes(self.marked_objects)

end
function Examine:idButToggleObjlistOnPress()
	self = GetRootDialog(self)

	local meta = getmetatable(self.obj_ref)
	if meta == objlist then
		setmetatable(self.obj_ref, nil)
	elseif not meta then
		setmetatable(self.obj_ref, objlist)
	end
	-- update view
	self:SetObj()
end

function Examine:AddSphere(obj,c,colour,skip_view,skip_colour)
	local sphere = self.ChoGGi.ComFuncs.ShowObj(obj, colour,skip_view,skip_colour)
	if IsValid(sphere) then
		c = (c or #self.marked_objects) + 1
		self.marked_objects[c] = sphere
	end
	return c
end

function Examine:idAutoRefreshOnChange()
	-- if it's called directly we set the check if needed
	local checked = self:GetCheck()

	self = GetRootDialog(self)

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
		while true do
			if self.obj_ref then
				self:SetObj()
			else
				DeleteThread(self.autorefresh_thread)
				break
			end
			Sleep(self.autorefresh_delay)
		end
	end)
end
-- for external use
function Examine:EnableAutoRefresh()
	self.idAutoRefreshOnChange(self.idAutoRefresh)
end

function Examine:idAutoRefreshOnMouseButtonDown(pt,button,...)
	g_Classes.ChoGGi_CheckButton.OnMouseButtonDown(self,pt,button,...)
	if button == "R" then

		self = GetRootDialog(self)
		local visible = self.idAutoRefreshDelay:GetVisible()
		self.idAutoRefreshDelay:SetVisible(not visible)
		if visible then
			self.idMoveControl:SetFocus()
		end
		local num = tonumber(self.idAutoRefreshDelay:GetText())
		if num then
			self.ChoGGi.UserSettings.ExamineRefreshTime = num
			self.ChoGGi.SettingFuncs.WriteSettings()
		end

	end
end

function Examine:idAutoRefreshDelayOnTextChanged()
	local num = tonumber(self:GetText())
	-- someone always enters a non-number...
	if num then
		-- probably best to keep it above this (just in case it's a large table)
		if num < 10 then
			num = 10
		end
		self = GetRootDialog(self)
		self.autorefresh_delay = num
		self.idAutoRefresh:SetRolloverText(self.idAutoRefresh_update_str:format(num))
	end
end

function Examine:idSortDirOnChange()
	self = GetRootDialog(self)
	self.sort_dir = not self.sort_dir
	self:SetObj()
end

function Examine:idShowAllValuesOnChange()
	self = GetRootDialog(self)
	self.show_all_values = not self.show_all_values
	self:SetObj()
end

--~ function Examine:CleanTextForView(str)
--~ 	-- remove html tags (any </*> closing tags, <left>, <color *>, <h *>, and * added by the context menus)
--~ 	return str:gsub("</[%s%a%d]*>",""):gsub("<left>",""):gsub("<color [%s%a%d]*>",""):gsub("<h [%s%a%d]*>",""):gsub("%* '","'")
--~ end

function Examine:BuildObjectMenuPopup()
	return {
		{name = Strings[302535920000457--[[Anim State Set--]]],
			hint = Strings[302535920000458--[[Make object dance on command.--]]],
			image = "CommonAssets/UI/Menu/UnlockCamera.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.SetAnimState(self.obj_ref)
			end,
		},
		{name = Strings[302535920000682--[[Change Entity--]]],
			hint = Strings[302535920001151--[[Set Entity For %s--]]]:format(self.name),
			image = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.EntitySpawner(self.obj_ref,true,7)
			end,
		},
		{name = Strings[302535920000129--[[Set--]]] .. " " .. Strings[302535920001184--[[Particles--]]],
			hint = Strings[302535920001421--[[Shows a list of particles you can use on the selected obj.--]]],
			image = "CommonAssets/UI/Menu/place_particles.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.SetParticles(self.obj_ref)
			end,
		},
		{name = Strings[302535920001476--[[Edit Flags--]]],
			hint = Strings[302535920001447--[[Show and toggle the list of flags for selected object.--]]],
			image = "CommonAssets/UI/Menu/JoinGame.tga",
			clicked = function()
				-- task requests have flags too, ones that aren't listed in the Flags table... (just const.rf*)
				if self.obj_flags then
					self.ChoGGi.ComFuncs.ObjFlagsList_TR(self.obj_ref,self)
				else
					self.ChoGGi.ComFuncs.ObjFlagsList(self.obj_ref,self)
				end
			end,
		},
		{is_spacer = true},
		{name = Strings[302535920001472--[[BBox Toggle--]]],
			hint = Strings[302535920001473--[[Toggle showing object's bbox (changes depending on movement).--]]],
			image = "CommonAssets/UI/Menu/SelectionEditor.tga",
			clicked = function()
				self:ShowBBoxList()
			end,
		},
		{name = Strings[302535920001522--[[Hex Shape Toggle--]]],
			hint = Strings[302535920001523--[[Toggle showing shapes for the object.--]]],
			image = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
			clicked = function()
				self:ShowHexShapeList()
			end,
		},
		{name = Strings[302535920000449--[[Entity Spots Toggle--]]],
			hint = Strings[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
			image = "CommonAssets/UI/Menu/ShowAll.tga",
			clicked = function()
				self:ShowEntitySpotsList()
			end,
		},
		{name = Strings[302535920000459--[[Anim Debug Toggle--]]],
			hint = Strings[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
			image = "CommonAssets/UI/Menu/CameraEditor.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.ShowAnimDebug_Toggle(self.obj_ref)
			end,
		},
		{name = Strings[302535920001551--[[Surfaces Toggle--]]],
			hint = Strings[302535920001552--[[Show a list of surfaces and draw lines over them (GetRelativeSurfaces).--]]],
			image = "CommonAssets/UI/Menu/ToggleCollisions.tga",
			clicked = function()
				self:ShowSurfacesList()
			end,
		},
		{is_spacer = true},
		{name = Strings[302535920000235--[[Entity Spots--]]],
			hint = Strings[302535920001445--[[Shows list of attaches for use with .ent files.--]]],
			image = "CommonAssets/UI/Menu/ListCollections.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.ExamineEntSpots(self.obj_ref,self)
			end,
		},
		{name = Strings[302535920001458--[[Material Properties--]]],
			hint = Strings[302535920001459--[[Shows list of material settings/.dds files for use with .mtl files.--]]],
			image = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.GetMaterialProperties(self.obj_ref:GetEntity(),self)
			end,
		},
		{name = Strings[302535920001524--[[Entity Surfaces--]]],
			hint = Strings[302535920001525--[[Shows list of surfaces for the object entity.--]]],
			image = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.OpenInExamineDlg(
					self.ChoGGi.ComFuncs.RetSurfaceMasks(self.obj_ref),self,
					Strings[302535920001524--[[Entity Surfaces--]]] .. ": " .. self.name
				)
			end,
		},
	}
end

function Examine:BuildToolsMenuPopup()
	local list = {
		{name = Strings[302535920001467--[[Append Dump--]]],
			hint = Strings[302535920001468--[["Append text to same file, or create a new file each time."--]]],
			clicked = function()
				self.ChoGGi.UserSettings.ExamineAppendDump = not self.ChoGGi.UserSettings.ExamineAppendDump
				self.ChoGGi.SettingFuncs.WriteSettings()
			end,
			value = "ChoGGi.UserSettings.ExamineAppendDump",
			class = "ChoGGi_CheckButtonMenu",
		},
		{name = Strings[302535920000004--[[Dump--]]] .. " " .. Translate(1000145--[[Text--]]),
			hint = Strings[302535920000046--[[dumps text to %slogs\DumpedExamine.lua--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_down.tga",
			clicked = function()
				local str = self:GetCleanText()
				-- i just compare, so append doesn't really work
				if self.ChoGGi.UserSettings.ExamineAppendDump then
					self.ChoGGi.ComFuncs.Dump("\n" .. str,nil,"DumpedExamine","lua")
				else
					self.ChoGGi.ComFuncs.Dump(str,"w","DumpedExamine","lua",nil,true)
				end
			end,
		},
		{name = Strings[302535920000004--[[Dump--]]] .. " " .. Translate(298035641454--[[Object--]]),
			hint = Strings[302535920001027--[[dumps object to %slogs\DumpedExamineObject.lua

This can take time on something like the "Building" metatable--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_down.tga",
			clicked = function()
				local str
				pcall(function()
					str = ValueToLuaCode(self.obj_ref)
				end)
				if str then
					if self.ChoGGi.UserSettings.ExamineAppendDump then
						self.ChoGGi.ComFuncs.Dump("\n" .. str,nil,"DumpedExamineObject","lua")
					else
						self.ChoGGi.ComFuncs.Dump(str,"w","DumpedExamineObject","lua",nil,true)
					end
				end
			end,
		},
		{name = Strings[302535920000048--[[View--]]] .. " " .. Translate(1000145--[[Text--]]),
			hint = Strings[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_up.tga",
			clicked = function()
				local str,scrolled_text = self:GetCleanText(true)
				-- pure text string
--~ 				local str = self.idText:GetText()

				self.ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					parent = self,
					checkbox = true,
					text = str,
					scrollto = scrolled_text,
					title = Strings[302535920000048--[[View--]]] .. "/" .. Strings[302535920000004--[[Dump--]]] .. " " .. Translate(1000145--[[Text--]]),
					hint_ok = Strings[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
					custom_func = function(answer,overwrite)
						if answer then
							self.ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedExamine","lua")
						end
					end,
				}
			end,
		},
		{name = Strings[302535920000048--[[View--]]] .. " " .. Translate(298035641454--[[Object--]]),
			hint = Strings[302535920000049--[["View text, and optionally dumps object to %sDumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_up.tga",
			clicked = function()
				local str
				pcall(function()
					str = ValueToLuaCode(self.obj_ref)
				end)
				if str then
					self.ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
						parent = self,
						checkbox = true,
						text = str,
						title = Strings[302535920000048--[[View--]]] .. "/" .. Strings[302535920000004--[[Dump--]]] .. " " .. Translate(298035641454--[[Object--]]),
						hint_ok = Strings[302535920000049--[["View text, and optionally dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]]],
						custom_func = function(answer,overwrite)
							if answer then
								self.ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedExamineObject","lua")
							end
						end,
					}
				end
			end,
		},
		{is_spacer = true},
		{name = Strings[302535920001239--[[Functions--]]],
			hint = Strings[302535920001240--[[Show all functions of this object and parents/ancestors.--]]],
			image = "CommonAssets/UI/Menu/gear.tga",
			clicked = function()
				if #self.parents > 0 or #self.ancestors > 0 then
					table_clear(self.menu_added)
					table_clear(self.menu_list_items)

					if #self.parents > 0 then
						self:ProcessList(self.parents," " .. Strings[302535920000520--[[Parents--]]] .. ": ")
					end
					if #self.ancestors > 0 then
						self:ProcessList(self.ancestors," " .. Strings[302535920000525--[[Ancestors--]]] .. ": ")
					end
					-- add examiner object with some spaces so it's at the top
					self:BuildFuncList(self.obj_ref.class,"	")
					-- if Object hasn't been added, then add CObject (O has a few more funcs than CO)
					if not self.menu_added.Object and self.menu_added.CObject then
						self:BuildFuncList("CObject",self.menu_added.CObject)
					end

					self.ChoGGi.ComFuncs.OpenInExamineDlg(
						self.menu_list_items,self,
						Strings[302535920001239--[[Functions--]]] .. ": " .. self.name
					)
				else
					-- make me a MsgPopup
					print(Translate(9763--[[No objects matching current filters.--]]))
				end
			end,
		},
		{name = Translate(327465361219--[[Edit--]]) .. " " .. Translate(298035641454--[[Object--]]),
			hint = Strings[302535920000050--[[Opens object in Object Manipulator.--]]],
			image = "CommonAssets/UI/Menu/AreaProperties.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.OpenInObjectEditorDlg(self.obj_ref,self)
			end,
		},
		{name = Translate(174--[[Color Modifier--]]),
			hint = Strings[302535920000693--[[Select/mouse over an object to change the colours
Use Shift- or Ctrl- for random colours/reset colours.--]]],
			image = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.ChangeObjectColour(self.obj_ref)
			end,
		},
		{name = Strings[302535920001469--[[Image Viewer--]]],
			hint = Strings[302535920001470--[["Open a dialog with a list of images from object (.dds, .tga, .png)."--]]],
			image = "CommonAssets/UI/Menu/light_model.tga",
			clicked = function()
				-- check for loaded entity textures
				local textures = self.obj_ref.UsedTextures and self.obj_ref:UsedTextures() or ""
				local images_table = {
					dupes = {},
				}
				for i = 1, #textures do
					images_table[i] = {
						name = textures[i] .. " *obj:UsedTextures()",
						path = DTM.TexName(textures[i]),
					}
					images_table.dupes[images_table[i].name .. images_table[i].path] = true
				end
				-- checks for image in obj and metatable
				if not self.ChoGGi.ComFuncs.DisplayObjectImages(self.obj_ref,self,images_table) then
					self.ChoGGi.ComFuncs.MsgPopup(
						Strings[302535920001471--[[No images found.--]]],
						Strings[302535920001469--[[Image Viewer--]]]
					)
				end
			end,
		},
		{name = Strings[302535920001305--[[Find Within--]]],
			hint = Strings[302535920001303--[[Search for text within %s.--]]]:format(self.name),
			image = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.OpenInFindValueDlg(self.obj_ref,self)
			end,
		},
		{name = Strings[302535920000040--[[Exec Code--]]],
			hint = Strings[302535920000052--[["Execute code (using console for output). o is whatever object is opened in examiner.
Which you can then mess around with some more in the console."--]]],
			image = "CommonAssets/UI/Menu/AlignSel.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj_ref,self)
			end,
		},
		{is_spacer = true},
		{name = Translate(931--[[Modified property--]]),
			hint = Strings[302535920001384--[[Get properties different from base/parent object?--]]],
			image = "CommonAssets/UI/Menu/SelectByClass.tga",
			clicked = function()
				if self.obj_ref.IsKindOf and self.obj_ref:IsKindOf("PropertyObject") then
					self.ChoGGi.ComFuncs.OpenInExamineDlg(
						GetModifiedProperties(self.obj_ref),
						self,
						Translate(931--[[Modified property--]]) .. ": " .. self.name
					)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = Strings[302535920001389--[[All Properties--]]],
			hint = Strings[302535920001390--[[Get all properties.--]]],
			image = "CommonAssets/UI/Menu/CollectionsEditor.tga",
			clicked = function()
				-- give em some hints
				if self.obj_ref.IsKindOf and self.obj_ref:IsKindOf("PropertyObject") then
					local props = self.obj_ref:GetProperties()
					local props_list = {
						___readme = Strings[302535920001397--[["Not the actual properties (see object.properties for those).

Use obj:GetProperty(""NAME"") and obj:SetProperty(""NAME"",value)
You can access a default value with obj:GetDefaultPropertyValue(""NAME"")
"--]]]
					}
					for i = 1, #props do
						props_list[props[i].id] = self.obj_ref:GetProperty(props[i].id)
					end
					self.ChoGGi.ComFuncs.OpenInExamineDlg(
						props_list,self,
						Strings[302535920001389--[[All Properties--]]] .. ": " .. self.name
					)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = Strings[302535920001369--[[Ged Editor--]]],
			hint = Strings[302535920000482--[["Shows some info about the object, and so on. Some buttons may make camera wonky (use Game>Camera>Reset)."--]]],
			image = "CommonAssets/UI/Menu/UIDesigner.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					GedObjectEditor = false
					OpenGedGameObjectEditor{self.obj_ref}
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = Strings[302535920000067--[[Ged Inspect--]]],
			hint = Strings[302535920001075--[[Open this object in the Ged inspector.--]]],
			image = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
			clicked = function()
				Inspect(self.obj_ref)
			end,
		},
		{is_spacer = true},
		{name = Strings[302535920001321--[[UI Click To Examine--]]],
			hint = Strings[302535920001322--[[Examine UI controls by clicking them.--]]],
			image = "CommonAssets/UI/Menu/select_objects.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.TerminalRolloverMode(true,self)
			end,
		},
		{name = Strings[302535920000970--[[UI Flash--]]],
			hint = Strings[302535920000972--[[Flash visibility of the UI object being examined.--]]],
			clicked = function()
				self.ChoGGi.UserSettings.FlashExamineObject = not self.ChoGGi.UserSettings.FlashExamineObject
				self.ChoGGi.SettingFuncs.WriteSettings()
			end,
			value = "ChoGGi.UserSettings.FlashExamineObject",
			class = "ChoGGi_CheckButtonMenu",
		},
	}
	if testing then
		-- maybe i'll finish this one day :)
		local name = Translate(327465361219--[[Edit--]]) .. " " .. Translate(298035641454--[[Object--]]) .. " " .. Strings[302535920001432--[[3D--]]]
		table.insert(list,9,{name = name,
			hint = Strings[302535920001433--[[Fiddle with object angle/axis/pos and so forth.--]]],
			image = "CommonAssets/UI/Menu/Axis.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.OpenIn3DManipulatorDlg(self.obj_ref,self)
			end,
		})
		-- view text with tags visible
		table.insert(list,4,{name = Strings[302535920000048--[[View--]]] .. " " .. Translate(1000145--[[Text--]]) .. " Tags",
			hint = Strings[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_up.tga",
			clicked = function()
				-- pure text string
				local str = self.idText:GetText()

				self.ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					parent = self,
					checkbox = true,
					text = str,
					title = Strings[302535920000048--[[View--]]] .. "/" .. Strings[302535920000004--[[Dump--]]] .. " " .. Translate(1000145--[[Text--]]),
					hint_ok = Strings[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
					custom_func = function(answer,overwrite)
						if answer then
							self.ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedExamine","lua")
						end
					end,
				}
			end,
		})

	end
	return list
end

local function CallMenu(self,popup_id,items,pt,button,...)
	if pt then
		ChoGGi_ComboButton.OnMouseButtonDown(self,pt,button,...)
	end
	if button == "L" then
		local dlg = self
		self = GetRootDialog(self)
		-- same colour as bg of icons :)
		self[items].Background = -9868951
		self[items].FocusedBackground = -9868951
		self[items].PressedBackground = -12500671
		self[items].TextStyle = "ChoGGi_CheckButtonMenuOpp"
		self.ChoGGi.ComFuncs.PopupToggle(dlg,self[popup_id],self[items],"bottom")
	end
end

function Examine:idToolsOnMouseButtonDown(pt,button,...)
	CallMenu(self,"idToolsMenu","tools_menu_popup",pt,button,...)
end
function Examine:idObjectsOnMouseButtonDown(pt,button,...)
	CallMenu(self,"idObjectsMenu","objects_menu_popup",pt,button,...)
end

function Examine:idParentsOnMouseButtonDown(pt,button,...)
	CallMenu(self,"idParentsMenu","parents_menu_popup",pt,button,...)
end

function Examine:idAttachesOnMouseButtonDown(pt,button,...)
	CallMenu(self,"idAttachesMenu","attaches_menu_popup",pt,button,...)
end

function Examine:idSearchOnMouseButtonDown(pt,button,...)
	ChoGGi_Button.OnMouseButtonDown(self,pt,button,...)
	self = GetRootDialog(self)
	if button == "L" then
		self:FindNext()
	elseif button == "R" then
		self:FindNext(nil,true)
	else
		self.idScrollArea:ScrollTo(0,0)
	end
end

function Examine:idSearchTextOnKbdKeyDown(vk,...)
	self = GetRootDialog(self)

	local c = const
	if vk == c.vkEnter then
		if IsControlPressed() then
			self:FindNext(nil,true)
		else
			self:FindNext()
		end
		return "break"
	elseif vk == c.vkUp then
		self.idScrollArea:ScrollTo(nil,0)
		return "break"
	elseif vk == c.vkDown then
		local v = self.idScrollV
		if v:IsVisible() then
			self.idScrollArea:ScrollTo(nil,v.Max - (v.FullPageAtEnd and v.PageSize or 0))
		end
		return "break"
	elseif vk == c.vkRight then
		local h = self.idScrollH
		if h:IsVisible() then
			self.idScrollArea:ScrollTo(h.Max - (h.FullPageAtEnd and h.PageSize or 0))
		end
		-- break doesn't work for left/right
	elseif vk == c.vkLeft then
		self.idScrollArea:ScrollTo(0)
		-- break doesn't work for left/right
	elseif vk == c.vkEsc then
		self.idCloseX:OnPress()
		return "break"
	elseif vk == c.vkV then
		if IsControlPressed() then
			CreateRealTimeThread(function()
				WaitMsg("OnRender")
				self:FindNext()
			end)
		end
	end

	return ChoGGi_TextInput.OnKbdKeyDown(self.idSearchText,vk,...)
end

-- adds class name then list of functions below
function Examine:BuildFuncList(obj_name,prefix)
	prefix = prefix or ""
	local class = _G[obj_name] or {}
	local skip = true
	for key,value in pairs(class) do
		if type(value) == "function" and type(key) == "string" then
			self.menu_list_items[prefix .. obj_name .. "." .. key .. ": "] = value
			skip = false
		end
	end
	if not skip then
		self.menu_list_items[prefix .. obj_name] = "\n\n\n"
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

function Examine:InvalidMsgPopup(msg,title)
	ChoGGi.ComFuncs.MsgPopup(
		msg or Strings[302535920001526--[[Not a valid object--]]],
		title or Strings[302535920000069--[[Examine--]]]
	)
end

-- scrolled_text is modified from a boolean to the scrolled text and sent back
-- skip_ast = i added an * to use for the context menu marker (defaults to true)
function Examine:GetCleanText(scrolled_text,skip_ast)
	if skip_ast ~= false then
		skip_ast = true
	end
	local cache = self.idText.draw_cache or {}

	-- get the cache number of scrolled text
	if scrolled_text then
		-- PendingOffsetY == scrolled number in cached text table
		if cache[self.idScrollArea.PendingOffsetY or 0] then
			scrolled_text = self.idScrollArea.PendingOffsetY or 0
		else
			-- if it's nil we're between lines
			-- we send "" or it'll try to use the search text
			self:FindNext("")
			-- no need to test if it's in the cache
			scrolled_text = self.idScrollArea.PendingOffsetY or 0
		end
	end

	-- first get a list of cached text (unordered) and merge the text chunks into one line
	local cache_temp = {}
	local c = 0

	local text_temp = {}
	for line,list in pairs(cache) do
		-- we stick all the text chunks into a table to concat after
		table_iclear(text_temp)
		for i = 1, #list do
			if i == 1 and skip_ast and list[i].text == "* " then
				text_temp[i] = ""
			else
				text_temp[i] = list[i].text or ""
			end
		end

		c = c + 1
		cache_temp[c] = {
			line = line,
			text = TableConcat(text_temp),
		}
	end

	-- sort by line group
	table_sort(cache_temp,function(a,b)
		return a.line < b.line
	end)

	-- change line/text to just line, and grab scroll text if it's around
	for i = 1, #cache_temp do
		local item = cache_temp[i]
		if item.line == scrolled_text then
			scrolled_text = item.text
		end
		cache_temp[i] = item.text
	end

	return TableConcat(cache_temp,"\n"),scrolled_text
end

function Examine:FindNext(text,previous)
	text = text or self.idSearchText:GetText()
	local current_y = self.idScrollArea.OffsetY
	local min_match, closest_match = false, false

	local text_table = {}
	local cache = self.idText.draw_cache or {}
	-- see about getting previous working better
--~ 	local prev_y = 0
	for y, list_draw_info in pairs(cache) do
		table_iclear(text_table)
		for i = 1, #list_draw_info do
			text_table[i] = list_draw_info[i].text or ""
		end

		if TableConcat(text_table):find_lower(text) or text == "" then
			if not min_match or y < min_match then
				min_match = y
			end

			if previous then
--~ 				print(prev_y,y,current_y)
				if y < current_y and (not closest_match or y > closest_match) then
					closest_match = y
				end
			else
				if y > current_y and (not closest_match or y < closest_match) then
					closest_match = y
				end
			end
		end
--~ 		prev_y = y
	end

	local match = closest_match or min_match
	if match then
		self.idScrollArea:ScrollTo(nil,match)
	end
end

function Examine:FlashWindow()
	-- doesn't lead to good stuff
	if not self.obj_ref.desktop then
		return
	end

	-- always kill off old thread first
	DeleteThread(self.flashing_thread)

	-- don't want to end up with something invis when it shouldn't be
	if self.orig_vis_flash then
		self.obj_ref:SetVisible(self.orig_vis_flash)
	else
		self.orig_vis_flash = self.obj_ref:GetVisible()
	end

	self.flashing_thread = CreateRealTimeThread(function()

		local vis
		for _ = 1, 5 do
			if self.obj_ref.window_state == "destroying" then
				break
			end
			self.obj_ref:SetVisible(vis)
			Sleep(175)
			vis = not vis
		end

		if self.obj_ref.window_state ~= "destroying" then
			self.obj_ref:SetVisible(self.orig_vis_flash)
		end

	end)
end

function Examine:ShowHexShapeList()
	local obj = self.obj_ref
	local entity = obj:GetEntity()
	if not IsValidEntity(entity) then
		return self:InvalidMsgPopup(nil,Translate(155--[[Entity--]]))
	end

	self.ChoGGi.ComFuncs.ObjHexShape_Clear(obj)

	self.hex_shape_tables = self.hex_shape_tables or {
		"HexBuildShapes",
		"HexBuildShapesInversed",
		"HexCombinedShapes",
		"HexInteriorShapes",
		"HexOutlineShapes",
		"HexPeripheralShapes",
	}
	self.hex_shape_funcs = self.hex_shape_funcs or {
		"GetExtractionShape",
		"GetExtractionShapeExtended",
		"GetShapePoints",
		"GetRotatedShapePoints",
	}

	local item_list = {
		{
			text = " " .. Translate(594--[[Clear--]]),
			value = "Clear",
		},
		{
			text = "HexNeighbours (" .. Strings[302535920001570--[[Fallback--]]] .. ")",
			value = HexNeighbours,
		},
		{
			text = "HexSurroundingsCheckShape (" .. Strings[302535920001570--[[Fallback--]]] .. ")",
			value = HexSurroundingsCheckShape,
		},
		{
			text = "FallbackOutline (" .. Strings[302535920001570--[[Fallback--]]] .. ")",
			value = FallbackOutline,
		},
	}
	local c = #item_list

	if type(obj.splat_shape) == "table" and #obj.splat_shape > 0 then
		c = c + 1
		item_list[c] = {
			text = "splat_shape",
			value = obj.splat_shape,
		}
	end
	if type(obj.periphery_shape) == "table" and #obj.periphery_shape > 0 then
		c = c + 1
		item_list[c] = {
			text = "periphery_shape",
			value = obj.periphery_shape,
		}
	end

	for i = 1, #self.hex_shape_funcs do
		local shape_list = self.hex_shape_funcs[i]
		local shape = obj[shape_list] and obj[shape_list](obj)

		if shape and #shape > 0 then
			c = c + 1
			item_list[c] = {
				text = shape_list,
				value = shape,
			}
		end
	end

	local g = _G
	for i = 1, #self.hex_shape_tables do
		local shape_list = self.hex_shape_tables[i]
		local shape = g[shape_list][entity]
		if shape and #shape > 0 then
			c = c + 1
			item_list[c] = {
				text = shape_list,
				value = shape,
			}
		end
	end

	local surfs = self.ChoGGi.ComFuncs.RetHexSurfaces(entity,true,true)
	for i = 1, #surfs do
		local s = surfs[i]
		c = c + 1
		item_list[c] = {
			text = "GetSurfaceHexShapes(), " .. s.name .. ", mask: " .. s.id
				.. " (" .. s.mask .. ") state:" .. s.state,
			value = s.shape,
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]
		if choice.value == "Clear" then
			self.ChoGGi.ComFuncs.ObjHexShape_Clear(obj)
		elseif type(choice.value) == "table" then
			self.ChoGGi.ComFuncs.ObjHexShape_Toggle(obj,{
				shape = choice.value,
				skip_return = true,
				depth_test = choice.check1,
				hex_pos = choice.check2,
				skip_clear = choice.check3,
			})
		end
	end

	self.ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001522--[[Hex Shape Toggle--]]] .. ": " .. self.name,
		skip_sort = true,
		custom_type = 7,
		checkboxes = {
			{
				title = Strings[302535920001553--[[Depth Test--]]],
				hint = Strings[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
				checked = false,
			},
			{
				title = Strings[302535920000461--[[Position--]]],
				hint = Strings[302535920001076--[[Shows the hex position of the spot: (-1,5).--]]],
				checked = true,
			},
			{
				title = Strings[302535920001560--[[Skip Clear--]]],
				hint = Strings[302535920001561--[[Info objects will stay instead of being removed when activating a different option.--]]],
				checked = false,
			},
		},
	}
end

function Examine:ShowBBoxList()
	local obj = self.obj_ref
	if not IsValidEntity(obj:GetEntity()) then
		return self:InvalidMsgPopup(nil,Translate(155--[[Entity--]]))
	end

-- might be useful?
--~ ToBBox(pos, prefab.size, angle)

	self.ChoGGi.ComFuncs.BBoxLines_Clear(obj)

	local item_list = {
		{text = " " .. Translate(594--[[Clear--]]),value = "Clear"},
		{text = "GetObjectBBox",value = "GetObjectBBox"},
		{text = "GetEntityBBox",value = "GetEntityBBox"},
		{text = "ObjectHierarchyBBox",value = "ObjectHierarchyBBox"},
		{text = "ObjectHierarchyBBox + efCollision",value = "ObjectHierarchyBBox",args = const.efCollision},
		{text = "GetSurfacesBBox",value = "GetSurfacesBBox"},
		-- relative nums
--~ 		{text = "GetEntitySurfacesBBox",value = "GetEntitySurfacesBBox"},
		-- needs entity string as 2 arg
--~ 		{text = "GetEntityBoundingBox",value = "GetEntityBoundingBox",args = "use_entity"},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if choice.value == "Clear" then
			self.ChoGGi.ComFuncs.BBoxLines_Clear(obj)
		else
			self.ChoGGi.ComFuncs.BBoxLines_Toggle(obj,{
				func = choice.value,
				args = choice.args,
				skip_return = true,
				depth_test = choice.check1,
			})
		end
	end

	self.ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001472--[[BBox Toggle--]]] .. ": " .. self.name,
		hint = Strings[302535920000264--[["Defaults to ObjectHierarchyBBox(obj,const.efCollision) if it can't find a func."--]]],
		skip_sort = true,
		custom_type = 7,
		checkboxes = {
			{
				title = Strings[302535920001553--[[Depth Test--]]],
				hint = Strings[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
				checked = false,
			},
		},
	}
end

function Examine:ShowEntitySpotsList()
	local obj = self.obj_ref

	self.ChoGGi.ComFuncs.EntitySpots_Clear(obj)

	if not IsValidEntity(obj:GetEntity()) then
		return self:InvalidMsgPopup(nil,Translate(155--[[Entity--]]))
	end

	local item_list = {
		{text = " " .. Translate(4493--[[All--]]),value = "All"},
		{text = " " .. Translate(594--[[Clear--]]),value = "Clear"},
	}
	local c = #item_list

	local dupes = {}
	local id_start, id_end = obj:GetAllSpots(obj:GetState())
	for i = id_start, id_end do
		local spot_name = GetSpotNameByType(obj:GetSpotsType(i))
		local spot_annot = obj:GetSpotAnnotation(i) or ""

		-- remove waypoints from chain points so they count as one
		if spot_annot:find("chain") then
			spot_annot = spot_annot:gsub(",waypoint=%d","")
		end

		local name = spot_name .. (spot_annot ~= "" and ";" .. spot_annot or "")
		if not dupes[name] then
			dupes[name] = true
			c = c + 1
			item_list[c] = {
				text = name .. " (" .. Strings[302535920001573--[[Spot Id--]]] .. ": " .. i .. ")",
				name = spot_name,
				value = spot_annot,
				hint = spot_annot,
			}
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if choice.value == "All" then
			self.ChoGGi.ComFuncs.EntitySpots_Toggle(obj,{
				skip_return = true,
				depth_test = choice.check1,
				show_pos = choice.check2,
				skip_clear = choice.check3,
			})
		elseif choice.value == "Clear" then
			self.ChoGGi.ComFuncs.EntitySpots_Clear(obj)
		else
			self.ChoGGi.ComFuncs.EntitySpots_Toggle(obj,{
				spot_type = choice.name,
				annotation = choice.value,
				skip_return = true,
				depth_test = choice.check1,
				show_pos = choice.check2,
				skip_clear = choice.check3,
			})
		end
	end

	self.ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000449--[[Entity Spots Toggle--]]] .. ": " .. self.name,
		hint = Strings[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
		custom_type = 7,
		skip_icons = true,
		checkboxes = {
			{
				title = Strings[302535920001553--[[Depth Test--]]],
				hint = Strings[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
				checked = false,
			},
			{
				title = Strings[302535920000461--[[Position--]]],
				hint = Strings[302535920000463--[[Add spot offset pos from Origin.--]]],
				checked = false,
			},
			{
				title = Strings[302535920001560--[[Skip Clear--]]],
				hint = Strings[302535920001561--[[Info objects will stay instead of being removed when activating a different option.--]]],
				checked = false,
			},
		},
	}
end

function Examine:ShowSurfacesList()
	local obj = self.obj_ref

	self.ChoGGi.ComFuncs.SurfaceLines_Clear(obj)

	local entity = obj:GetEntity()
	if not IsValidEntity(entity) then
		return self:InvalidMsgPopup(nil,Translate(155--[[Entity--]]))
	end

	local item_list = {
		{text = " " .. Translate(594--[[Clear--]]),value = "Clear"},
		{
			text = "0: " .. Strings[302535920000968--[[Collisions--]]],
			value = 0,
			hint = "Relative Surface index: 0",
		},
	}
	local c = #item_list

	local GetRelativeSurfaces = GetRelativeSurfaces
	-- yep, no idea what GetRelativeSurfaces uses, so 1024 it'll be (from what i've seen nothing above 10, but...)
	for i = 1, 1024 do
		local surfs = GetRelativeSurfaces(obj,i)
		if #surfs > 0 then
			c = c + 1
			item_list[c] = {
				text = i .. "",
				value = i,
				surfs = surfs,
				hint = "Relative Surface index: " .. i,
			}
			if i == 7 then
				item_list[c].text = item_list[c].text .. ": " .. Strings[302535920001562--[[Selection Area--]]]
			end
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if choice.value == "Clear" then
			self.ChoGGi.ComFuncs.SurfaceLines_Clear(obj)
		else
			self.ChoGGi.ComFuncs.SurfaceLines_Toggle(obj,{
				surface_mask = choice.value,
				skip_return = true,
				surfs = choice.surfs,
				depth_test = choice.check1,
				skip_clear = choice.check2,
			})
		end
	end

	self.ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920001551--[[Surfaces Toggle--]]] .. ": " .. self.name,
		hint = Strings[302535920001552--[[Show a list of surfaces and draw lines over them (GetRelativeSurfaces).--]]],
		custom_type = 7,
		checkboxes = {
			{
				title = Strings[302535920001553--[[Depth Test--]]],
				hint = Strings[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
				checked = false,
			},
			{
				title = Strings[302535920001560--[[Skip Clear--]]],
				hint = Strings[302535920001561--[[Info objects will stay instead of being removed when activating a different option.--]]],
				checked = false,
			},
		},
	}
end

function Examine:SetTranspMode(toggle)
	self:ClearModifiers()
	if toggle then
		self:AddInterpolation{
			type = const.intAlpha,
			startValue = 32
		}
		self.idToolbarButtons:AddInterpolation{
			type = const.intAlpha,
			startValue = 200,
			flags = const.intfIgnoreParent
		}
	end
	-- update global value (for new windows)
	self.ChoGGi.Temp.transp_mode = toggle
end
--
local function Show_ConvertValueToInfo(self,button,obj)
	-- not ingame = no sense in using ShowObj
	if button == "L" and GameState.gameplay and (IsValid(obj) or IsPoint(obj)) then
		self:AddSphere(obj)
	else
		self.ChoGGi.ComFuncs.OpenInExamineDlg(obj,self)
	end
end
local function Examine_ConvertValueToInfo(self,button,obj)
	-- not ingame = no sense in using ShowObj
	if button == "L" then
		self.ChoGGi.ComFuncs.OpenInExamineDlg(obj,self)
	else
		self:AddSphere(obj)
	end
end

function Examine:ShowExecCodeWithCode(code)
	-- open exec code and paste "o.obj_name = value"
	self:idToggleExecCodeOnChange(true)
	self.idExecCode:SetText(code)
	-- set focus and cursor to end of text
	self.idExecCode:SetFocus()
	self.idExecCode:SetCursor(1,#self.idExecCode:GetText())
end

function Examine:OpenListMenu(_,obj_name,_,hyperlink_box)
	-- id for PopupToggle
	self.opened_list_menu_id = self.opened_list_menu_id or self.ChoGGi.ComFuncs.Random()

	-- they're sent as strings, but I need to know if it's a number or string and so on
	local obj_key,obj_type = self.ChoGGi.ComFuncs.RetProperType(obj_name)

	local obj_value = self.obj_ref[obj_key]
	local obj_value_str = tostring(obj_value)
	local obj_value_type = type(obj_value)

	local list = {
		{name = obj_name,
			hint = Strings[302535920001538--[[Close this menu.--]]],
			image = "CommonAssets/UI/Menu/default.tga",
			clicked = function()
				local popup = terminal.desktop[self.opened_list_menu_id]
				if popup then
					popup:Close()
				end
			end,
		},
		{is_spacer = true},
		{name = Translate(833734167742--[[Delete Item--]]),
			hint = Strings[302535920001536--[["Remove the ""%s"" key from %s."--]]]:format(obj_name,self.name),
			image = "CommonAssets/UI/Menu/DeleteArea.tga",
			clicked = function()
				if obj_type == "string" then
					self:ShowExecCodeWithCode([[o["]] .. obj_name .. [["] = nil]])
				else
					self:ShowExecCodeWithCode("table.remove(o" .. "," .. obj_name .. ")")
				end
			end,
		},
		{name = Strings[302535920001535--[[Set Value--]]],
			hint = Strings[302535920001539--[[Change the value of %s.--]]]:format(obj_name),
			image = "CommonAssets/UI/Menu/SelectByClassName.tga",
			clicked = function()
				if obj_value_type == "string" then
					self:ShowExecCodeWithCode([[o["]] .. obj_name .. [["] = "]] .. obj_value_str .. [["]])
				else
					self:ShowExecCodeWithCode([[o["]] .. obj_name .. [["] = ]] .. obj_value_str)
				end
			end,
		},
		{name = Strings[302535920000664--[[Clipboard--]]],
			hint = Strings[302535920001566--[[Copy ValueToLuaCode(value) to clipboard.--]]],
			image = "CommonAssets/UI/Menu/Mirror.tga",
			clicked = function()
				CopyToClipboard(ValueToLuaCode(obj_value))
			end,
		},
	}
	local c_orig = #list
	local c = c_orig

	-- if it's an image path then we add an image viewer
	if self.ChoGGi.ComFuncs.ImageExts()[obj_value_str:sub(-3):lower()] then
		c = c + 1
		list[c] = {name = Strings[302535920001469--[[Image Viewer--]]],
			hint = Strings[302535920001470--[["Open a dialog with a list of images from object (.dds, .tga, .png)."--]]],
			image = "CommonAssets/UI/Menu/light_model.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.OpenInImageViewerDlg(obj_value_str,self)
			end,
		}
	end

	-- add a mat props list
	if obj_value_str:sub(-3):lower() == "mtl" then
		c = c + 1
		list[c] = {name = Strings[302535920001458--[[Material Properties--]]],
			hint = Strings[302535920001459--[[Shows list of material settings/.dds files for use with .mtl files.--]]],
			image = "CommonAssets/UI/Menu/AreaProperties.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.OpenInExamineDlg(
					GetMaterialProperties(obj_value_str),
					self,
					Strings[302535920001458--[[Material Properties--]]]
				)
			end,
		}
	end

	if obj_value_type == "number" then
		c = c + 1
		list[c] = {name = Strings[302535920001564--[[Double Number--]]],
			hint = Strings[302535920001563--[[Set amount to <color 100 255 100>%s</color>.--]]]:format(obj_value * 2),
			image = "CommonAssets/UI/Menu/change_height_up.tga",
			clicked = function()
				self:ShowExecCodeWithCode("o." .. obj_name .. " = " .. (obj_value * 2))
			end,
		}
		c = c + 1
		list[c] = {name = Strings[302535920001565--[[Halve Number--]]],
			hint = Strings[302535920001563--[[Set amount to <color 100 255 100>%s</color>.--]]]:format(obj_value / 2),
			image = "CommonAssets/UI/Menu/change_height_down.tga",
			clicked = function()
				self:ShowExecCodeWithCode("o." .. obj_name .. " = " .. (obj_value / 2))
			end,
		}

	elseif obj_value_type == "boolean" then
		c = c + 1
		list[c] = {name = Strings[302535920001069--[[Toggle Boolean--]]],
			hint = Strings[302535920001567--[[false to true and true to false.--]]],
			image = "CommonAssets/UI/Menu/ToggleSelectionOcclusion.tga",
			clicked = function()
				self:ShowExecCodeWithCode("o." .. obj_name .. " = " .. tostring(not obj_value))
			end,
		}
		c = c + 1
		list[c] = {name = Strings[302535920001568--[[Boolean To Table--]]],
			hint = Strings[302535920001569--[[Set the value to a new table: {}.--]]],
			image = "CommonAssets/UI/Menu/SelectionFilter.tga",
			clicked = function()
				self:ShowExecCodeWithCode("o." .. obj_name .. " = {}")
			end,
		}

	-- add print for funcs
	elseif obj_value_type == "function" then
		c = c + 1
		list[c] = {is_spacer = true}
		c = c + 1
		list[c] = {name = Strings[302535920000524--[[Print Func--]]],
			hint = Strings[302535920000906--[[Print func name when this func is called.--]]],
			image = "CommonAssets/UI/Menu/Action.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.PrintToFunc_Add(
					obj_value, -- func to print
					obj_key, -- func name
					self.obj_ref, -- parent
					self.name .. "." .. obj_key -- printed name
				)
			end,
		}
		c = c + 1
		list[c] = {name = Strings[302535920000745--[[Print Func Params--]]],
			hint = Strings[302535920000906] .. "\n\n" .. Strings[302535920000984--[[Also prints params (if this func is attached to a class obj then the first arg will only return the name).--]]],
			image = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.PrintToFunc_Add(obj_value,obj_key,self.obj_ref,self.name .. "." .. obj_key,true)
			end,
		}
		c = c + 1
		list[c] = {name = Strings[302535920000900--[[Print Reset--]]],
			hint = Strings[302535920001067--[[Remove print from func.--]]],
			image = "CommonAssets/UI/Menu/reload.tga",
			clicked = function()
				self.ChoGGi.ComFuncs.PrintToFunc_Remove(obj_key,self.obj_ref)
			end,
		}
	end

	if c ~= c_orig and not list[6].is_spacer then
		table_insert(list,6,{is_spacer = true})
	end

	-- style it like the other examine menus
	list.Background = -9868951
	list.FocusedBackground = -9868951
	list.PressedBackground = -12500671
	list.TextStyle = "ChoGGi_CheckButtonMenuOpp"
	-- make a fake anchor for PopupToggle to use (
	self.list_menu_table = self.list_menu_table or {}
	self.list_menu_table.ChoGGi_self = self
	self.list_menu_table.box = hyperlink_box
	self.ChoGGi.ComFuncs.PopupToggle(
		self.list_menu_table,self.opened_list_menu_id,list,"left"
	)
end

function Examine:ConvertValueToInfo(obj)
	local obj_type = type(obj)

	if obj_type == "string" then
		if obj == "" then
			-- tags off doesn't like ""
			return "''"
		else
			return "'<color " .. self.ChoGGi.UserSettings.ExamineColourStr .. "><tags off>" .. obj .. "<tags on></color>'"
		end
	end
	--
	if obj_type == "number" then
		return "<color " .. self.ChoGGi.UserSettings.ExamineColourNum .. ">" .. obj .. "</color>"
	end
	--
	if obj_type == "boolean" then
		if obj then
			return "<color " .. self.ChoGGi.UserSettings.ExamineColourBool .. ">" .. tostring(obj) .. "</color>"
		else
			return "<color " .. self.ChoGGi.UserSettings.ExamineColourBoolFalse .. ">" .. tostring(obj) .. "</color>"
		end
	end
	--
	if obj_type == "table" then

		-- acts weird with main menu movie xlayer, so we check for GetVisualPos
		if IsValid(obj) and obj.GetVisualPos then
			return self:HyperLink(obj,Examine_ConvertValueToInfo)
				.. obj.class .. hyperlink_end .. "@"
				.. self:ConvertValueToInfo(obj:GetVisualPos())
		else
			local len = #obj
			local obj_metatable = getmetatable(obj)

--~ 			-- if it's an objlist then we return a list of the objects
--~ 			if obj_metatable and IsObjlist(obj_metatable) then
--~ 				local res = {
--~ 					self:HyperLink(obj,Examine_ConvertValueToInfo),
--~ 					"objlist",
--~ 					hyperlink_end,
--~ 					"{",
--~ 				}
--~ 				local c = #res
--~ 				for i = 1, Min(len, 3) do
--~ 					c = c + 1
--~ 					res[c] = i
--~ 					c = c + 1
--~ 					res[c] = "="
--~ 					c = c + 1
--~ 					res[c] = self:ConvertValueToInfo(obj[i])
--~ 					c = c + 1
--~ 					res[c] = ","
--~ 				end
--~ 				if len > 3 then
--~ 					c = c + 1
--~ 					res[c] = "..."
--~ 				end
--~ 				c = c + 1
--~ 				res[c] = "}"
--~ 				-- remove last ,
--~ 				return TableConcat(res):gsub(",}","}")

--~ 			elseif rawget(obj,"ChoGGi_AddHyperLink") and obj.ChoGGi_AddHyperLink then
			if rawget(obj,"ChoGGi_AddHyperLink") and obj.ChoGGi_AddHyperLink then
				if obj.colour then
					return "<color " .. obj.colour .. ">" .. (obj.name or "") .. "</color> "
						.. self:HyperLink(obj,obj.func,obj.hint) .. "@" .. hyperlink_end
				else
					return (obj.name or "") .. "</color> "
						.. self:HyperLink(obj,obj.func,obj.hint) .. "@" .. hyperlink_end
				end

			else
				-- regular table
				local table_data
				local is_next = type(next(obj)) ~= "nil"

				-- not sure how to check if it's an index non-ass table
				if len > 0 and is_next then
					-- next works for both
					table_data = len .. " / " .. Strings[302535920001057--[[Data--]]]
				elseif is_next then
					-- ass based
					table_data = Strings[302535920001057--[[Data--]]]
				else
					-- blank table
					table_data = 0
				end

				local name_cln = RetName(obj)
				local name = "<tags off>" .. name_cln .. "<tags on>"
				if obj.class and name_cln ~= obj.class then
					name = obj.class .. " (len: " .. table_data .. ", " .. name .. ")"
				else
					name = name .. " (len: " .. table_data .. ")"
				end

				return self:HyperLink(obj,Examine_ConvertValueToInfo) .. name .. hyperlink_end
			end
		end
	end
	--
	if obj_type == "userdata" then

		if IsPoint(obj) then
			-- InvalidPos()
			if obj == InvalidPos then
				return Strings[302535920000066--[[<color 203 120 30>Off-Map</color>--]]]
			else
				return self:HyperLink(obj,Show_ConvertValueToInfo)
					.. "point" .. tostring(obj) .. hyperlink_end
			end
		else

			-- show translated text if possible and return a clickable link
			local trans_str
			if IsT(obj) then
				trans_str = Translate(obj)
				if trans_str == "Missing text" or #trans_str > 16 and trans_str:sub(-16) == " *bad string id?" then
					trans_str = tostring(obj)
				end
			else
				trans_str = tostring(obj)
			end

			local meta = getmetatable(obj)

			-- tags off doesn't like ""
			if trans_str == "" then
				trans_str = trans_str .. self:HyperLink(obj,Examine_ConvertValueToInfo) .. " *"
			else
				trans_str = "<tags off>" .. trans_str .. "<tags on>" .. self:HyperLink(obj,Examine_ConvertValueToInfo) .. " *"
			end

			-- if meta name then add it
			if meta and meta.__name then
				trans_str = trans_str .. "(" .. meta.__name .. ")"
			else
				trans_str = trans_str .. tostring(obj)
			end

			return trans_str .. hyperlink_end
		end
	end
	--
	if obj_type == "function" then
		return self:HyperLink(obj,Examine_ConvertValueToInfo)
			.. RetName(obj) .. hyperlink_end
	end
	--
	if obj_type == "thread" then
		return self:HyperLink(obj,Examine_ConvertValueToInfo)
			.. tostring(obj) .. hyperlink_end
	end
	--
	if obj_type == "nil" then
		return "<color " .. self.ChoGGi.UserSettings.ExamineColourNil .. ">nil</color>"
	end

	-- just in case
	return tostring(obj)
end

---------------------------------------------------------------------------------------------------------------------
function Examine:RetDebugUpValue(obj,list,c,nups)
	for i = 1, nups do
		local name, value = debug_getupvalue(obj, i)
		if name then
			c = c + 1
			name = name ~= "" and name or Strings[302535920000723--[[Lua--]]]

			list[c] = "getupvalue(" .. i .. "): " .. name .. " = "
				.. self:ConvertValueToInfo(value)
		end
	end
	return c
end

function Examine:RetDebugGetInfo(obj)
	self.RetDebugInfo_table = self.RetDebugInfo_table or objlist:new()
	local temp = self.RetDebugInfo_table
	temp:Destroy()

	local c = 0
	local info = debug_getinfo(obj,"Slfunt")
	for key,value in pairs(info) do
		c = c + 1
		temp[c] = key .. ": " .. self:ConvertValueToInfo(value)
	end
	-- since pairs doesn't have an order we need a sort
	table_sort(temp)

	table_insert(temp,1,"\ngetinfo(): ")
	return TableConcat(temp,"\n")
end
function Examine:RetFuncArgs(obj)
	self.RetDebugInfo_table = self.RetDebugInfo_table or objlist:new()
	local temp = self.RetDebugInfo_table
	temp:Destroy()

	local info = debug_getinfo(obj,"u")
	if info.nparams > 0 then
		for i = 1, info.nparams do
			temp[i] = debug_getlocal(obj, i)
		end

		table_insert(temp,1,"params: ")
		local args = TableConcat(temp,", ")

		-- remove extra , from concat and add ... if it has a vararg
		return args:gsub(": , ",": (") .. (info.isvararg and ", ...)" or ")")
	elseif info.isvararg then
		return "params: (...)"
	else
		return "params: ()"
	end
end

function Examine:ToggleBBox(_,bbox)
	if self.spawned_bbox then
		-- the clear func expects it this way
		self.spawned_bbox.ChoGGi_bboxobj = self.spawned_bbox
		self.ChoGGi.ComFuncs.BBoxLines_Clear(self.spawned_bbox)
		self.spawned_bbox = false
	else
		self.spawned_bbox = self.ChoGGi.ComFuncs.BBoxLines_Toggle(bbox)
	end
end

function Examine:ConvertObjToInfo(obj,obj_type)
	-- i like reusing tables... these are for sorting, and dupe skipping
	self.ConvertObjToInfo_list_obj_str = self.ConvertObjToInfo_list_obj_str or {}
	self.ConvertObjToInfo_list_sort_num = self.ConvertObjToInfo_list_sort_num or {}
	self.ConvertObjToInfo_list_sort_obj = self.ConvertObjToInfo_list_sort_obj or {}
	self.ConvertObjToInfo_skip_dupes = self.ConvertObjToInfo_skip_dupes or {}
	local list_obj_str = self.ConvertObjToInfo_list_obj_str
	local list_sort_obj = self.ConvertObjToInfo_list_sort_obj
	local list_sort_num = self.ConvertObjToInfo_list_sort_num
	local skip_dupes = self.ConvertObjToInfo_skip_dupes
	-- the list we return with concat
	table_iclear(list_obj_str)
	-- list of strs to sort with
	table_clear(list_sort_num)
	-- list of nums to sort with
	table_clear(list_sort_obj)
	-- dupe list for the "All" checkbox
	table_clear(skip_dupes)

	local obj_metatable = getmetatable(obj)
	local c = 0
	local str_not_translated

	if obj_type == "nil" then
		return obj_type
	elseif obj_type == "boolean" or obj_type == "number" then
		return tostring(obj)
	end

	if obj_type == "table" then

		local is_chinese = self.is_chinese
		local show_all_values = self.show_all_values
		for k,v in pairs(obj) do
			-- sorely needed delay for chinese (or it "freezes" the game when loading something like _G)
			-- i assume text rendering is slower for the chars, 'cause examine is really slow with them.
			if is_chinese then
				Sleep(1)
			end

			local name = self:ConvertValueToInfo(k)
			local sort = name
			-- append context menu link
			name = self:HyperLink(k,self.OpenListMenu,nil,true) .. "* " .. hyperlink_end .. name
--~ 			local hyper_c = self.onclick_count

			-- store the names if we're doing all props
			if show_all_values then
				skip_dupes[sort] = true
			end
			c = c + 1
			local str_tmp = name .. " = " .. self:ConvertValueToInfo(v)
			list_obj_str[c] = str_tmp
--~ 			-- so we can copy the actual line of text
--~ 			self.onclick_linetext[hyper_c] = str_tmp

			if type(k) == "number" then
				list_sort_num[str_tmp] = k
			else
				list_sort_obj[str_tmp] = sort
			end
		end

		-- keep looping through metatables till we run out
		if obj_metatable and show_all_values then
			local meta_temp = obj_metatable
			while meta_temp do
				for k,v in pairs(meta_temp) do
					local name = self:ConvertValueToInfo(k)
					local sort = name
					name = self:HyperLink(k,self.OpenListMenu,nil,true) .. "* " .. hyperlink_end .. name

					if not skip_dupes[sort] then
						skip_dupes[sort] = true
						c = c + 1
						local str_tmp = name .. " = " .. self:ConvertValueToInfo(obj[k] or v)
						list_obj_str[c] = str_tmp
						list_sort_obj[str_tmp] = sort
					end

				end
				meta_temp = getmetatable(meta_temp)
			end
		end

		-- pretty rare occurrence
		if self.show_enum_values and self.enum_vars then
			for k,v in pairs(self.enum_vars) do
				-- remove the . at the start
				k = k:sub(2)
				local name = self:ConvertValueToInfo(k)
				local sort = name
				name = self:HyperLink(k,self.OpenListMenu,nil,true) .. "* " .. hyperlink_end .. name

				if not skip_dupes[sort] then
					skip_dupes[sort] = true
					c = c + 1
					local str_tmp = name .. " = " .. self:ConvertValueToInfo(v)
					list_obj_str[c] = str_tmp
					list_sort_obj[str_tmp] = sort
				end
			end
		end

		-- the regular getmetatable will use __metatable if it exists, so we check this as well
		if testing and not blacklist then
			local dbg_metatable = debug.getmetatable(obj)
			if dbg_metatable and dbg_metatable ~= obj_metatable then
				print("ECM Sez DIFFERENT METATABLE",self.name,"\nmeta:",obj_metatable,"\ndbg:",dbg_metatable,"")
			end
		end

	elseif obj_type == "function" then
		c = c + 1
		list_obj_str[c] = self:ConvertValueToInfo(tostring(obj))

		local name = self.ChoGGi.ComFuncs.DebugGetInfo(obj)
		if name == "[C](-1)" then
			name = RetName(obj)
		end
		c = c + 1
		list_obj_str[c] = self:HyperLink(obj,function()
			self.ChoGGi.ComFuncs.OpenInExamineDlg(obj,self)
		end) .. name .. hyperlink_end
	end

	if self.sort_dir then
		-- sort backwards
		table_sort(list_obj_str,function(a, b)
			-- strings
			local c,d = list_sort_obj[a], list_sort_obj[b]
			if c and d then
				return CmpLower(d, c)
			end
			-- numbers
			c,d = list_sort_num[a], list_sort_num[b]
			if c and d then
				return c > d
			end
			if c or d then
				return d and true
			end
			-- just in case
			return CmpLower(b, a)
		end)
	else
		-- sort normally
		table_sort(list_obj_str,function(a, b)
			-- strings
			local c,d = list_sort_obj[a], list_sort_obj[b]
			if c and d then
				return CmpLower(c, d)
			end
			-- numbers
			c,d = list_sort_num[a], list_sort_num[b]
			if c and d then
				return c < d
			end
			if c or d then
				return c and true
			end
			-- just in case
			return CmpLower(a, b)
		end)
	end

	-- cobjects, not property objs? (IsKindOf)
	local is_valid_obj = IsValid(obj)
	if is_valid_obj and obj:IsKindOf("CObject") then
		local entity
		if obj:IsKindOf("Colonist") then
			entity = GetSpecialistEntity(obj.specialist, obj.entity_gender, obj.race, obj.age_trait, obj.traits)
		else
			entity = obj:GetEntity()
		end

		local valid_ent = IsValidEntity(entity)

		table_insert(list_obj_str,1,"\t--"
			.. self:HyperLink(obj,function()
				self.ChoGGi.ComFuncs.OpenInExamineDlg(getmetatable(obj),self)
			end)
			.. obj.class
			.. hyperlink_end
			.. "@"
			.. self:ConvertValueToInfo(obj:GetVisualPos())
			.. "--"
		)
		-- add the particle name
		if obj:IsKindOf("ParSystem") then
			local par_name = obj:GetParticlesName()
			if par_name ~= "" then
				table_insert(list_obj_str,2,"GetParticlesName(): " .. self:ConvertValueToInfo(par_name) .. "\n")
			end
		end

		-- stuff that changes anim state?
		local state_added
		if obj:IsValidPos() and valid_ent and 0 < obj:GetAnimDuration() then
			state_added = true
			-- add pathing table
			local current_pos = obj:GetVisualPos()
			local going_to = current_pos + obj:GetStepVector() * obj:TimeToAnimEnd() / obj:GetAnimDuration()
			local path = obj.GetPath and obj:GetPath()
			if path then
				local path_c = #path
				for i = 1, path_c do
					path[i] = path[i]:SetTerrainZ()
				end
				path[path_c+1] = going_to
				-- make it an objlist, so mark all works
				setmetatable(path, objlist)
			else
				path = going_to
			end

			-- step vector
			local state = obj:GetState()
			local step_vector = obj:GetStepVector(state,0)
			if tostring(step_vector) == "(0, 0, 0)" then
				step_vector = ""
			else
				step_vector =  ", step: " .. self:ConvertValueToInfo(step_vector) .. "\n"
			end
			-- pathing
			if current_pos ~= going_to then
				path = Strings[302535920001545--[[Going to %s--]]]:format(self:ConvertValueToInfo(path)) .. "\n"
			else
				path = ""
			end
			-- if neither then add a newline
			if path == "" and step_vector == "" then
				path = "\n"
			end

			table_insert(list_obj_str, 2, Translate(3722--[[State--]]) .. ": "
				.. GetStateName(state) .. step_vector .. path
			)

		end

		-- parent object of attached obj
		local parent = obj:GetParent()
		if IsValid(parent) then
			table_insert(list_obj_str, 2, "GetParent(): " .. self:ConvertValueToInfo(parent)
				.. "\nGetAttachOffset(): " .. self:ConvertValueToInfo(obj:GetAttachOffset())
				.. "\nGetAttachAxis(): " .. self:ConvertValueToInfo(obj:GetAttachAxis())
				.. "\nGetAttachAngle(): " .. self:ConvertValueToInfo(obj:GetAttachAngle())
				.. "\nGetAttachSpot(): " .. self:ConvertValueToInfo(obj:GetAttachSpot())
				.. "\nAttachSpotName: " .. self:ConvertValueToInfo(parent:GetSpotName(obj:GetAttachSpot()))
				.. (state_added and "" or "\n")
			)
		end

		if valid_ent then
			if entity == "InvisibleObject" then
				-- calling GetNumTris/GetNumVertices on InvisibleObject == CTD
				table_insert(list_obj_str, 2,
					"GetEntity(): " .. self:ConvertValueToInfo(entity)
						.. ((parent or state_added) and "" or "\n"))
			else
				-- some entity details as well
				table_insert(list_obj_str, 2,
					"GetEntity(): " .. self:ConvertValueToInfo(entity)
						.. "\nGetNumTris(): " .. self:ConvertValueToInfo(obj:GetNumTris())
						.. ", GetNumVertices(): " .. self:ConvertValueToInfo(obj:GetNumVertices())
						.. ((parent or state_added) and "" or "\n"))
			end
		end

	end

	if obj_type == "number" or obj_type == "boolean" or obj_type == "string" then
		c = c + 1
		list_obj_str[c] = self:ConvertValueToInfo(obj)

	elseif obj_type == "userdata" then
		c = c + 1
		list_obj_str[c] = self:ConvertValueToInfo(obj)

		-- add any functions from getmetatable to the (scant) list
		if obj_metatable then
			-- what? it's all about the 3 Rs
			self.ConvertObjToInfo_data_meta = self.ConvertObjToInfo_data_meta or {}
			local data_meta = self.ConvertObjToInfo_data_meta
			table_iclear(data_meta)

			self.ConvertObjToInfo_data_meta_dupes = self.ConvertObjToInfo_data_meta_dupes or {}
			local dupes = self.ConvertObjToInfo_data_meta_dupes
			table_clear(dupes)

			local m_c = 0
			for k, v in pairs(obj_metatable) do
				if not dupes[k] then
					dupes[k] = true
					m_c = m_c + 1
					data_meta[m_c] = self:ConvertValueToInfo(k) .. " = " .. self:ConvertValueToInfo(v)
				end
			end
			-- any extras from __index (most show index in metatable, not all
			if type(obj_metatable.__index) == "table" then
				for k, v in pairs(obj_metatable.__index) do
					if not dupes[k] then
						dupes[k] = true
						m_c = m_c + 1
						data_meta[m_c] = self:ConvertValueToInfo(k) .. " = " .. self:ConvertValueToInfo(v)
					end
				end
			end

			table_sort(data_meta,CmpLower)

			-- add some info for HGE. stuff
			local name = obj_metatable.__name
			if name == "HGE.TaskRequest" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"Unpack(): "
					.. self:HyperLink(obj,function()
						self.ChoGGi.ComFuncs.OpenInExamineDlg({obj:Unpack()},self,Strings[302535920000885--[[Unpacked--]]])
					end)
					.. "table" .. hyperlink_end
				)
				-- we use this with Object>Flags
				self.obj_flags = obj:GetFlags()
				table_insert(data_meta,1,"GetFlags(): " .. self:ConvertValueToInfo(self.obj_flags)
					.. self:ConvertValueToInfo({
						ChoGGi_AddHyperLink = true,
						hint = Strings[302535920001447--[[Shows list of flags set for selected object.-]]],
						func = function(ex_dlg)
							ChoGGi.ComFuncs.ObjFlagsList_TR(obj,ex_dlg)
						end,
					})
				)
				table_insert(data_meta,1,"GetReciprocalRequest(): " .. self:ConvertValueToInfo(obj:GetReciprocalRequest()))
				table_insert(data_meta,1,"GetLastServiced(): " .. self:ConvertValueToInfo(obj:GetLastServiced()))
				table_insert(data_meta,1,"GetFreeUnitSlots(): " .. self:ConvertValueToInfo(obj:GetFreeUnitSlots()))
				table_insert(data_meta,1,"GetFillIndex(): " .. self:ConvertValueToInfo(obj:GetFillIndex()))
				table_insert(data_meta,1,"GetTargetAmount(): " .. self:ConvertValueToInfo(obj:GetTargetAmount()))
				table_insert(data_meta,1,"GetDesiredAmount(): " .. self:ConvertValueToInfo(obj:GetDesiredAmount()))
				table_insert(data_meta,1,"GetActualAmount(): " .. self:ConvertValueToInfo(obj:GetActualAmount()))
				table_insert(data_meta,1,"GetWorkingUnits(): " .. self:ConvertValueToInfo(obj:GetWorkingUnits()))
				table_insert(data_meta,1,"GetResource(): " .. self:ConvertValueToInfo(obj:GetResource()))
				table_insert(data_meta,1,"\nGetBuilding(): " .. self:ConvertValueToInfo(obj:GetBuilding()))

			elseif name == "HGE.Grid" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"get_default(): " .. self:ConvertValueToInfo(obj:get_default()))
				table_insert(data_meta,1,"max_value(): " .. self:ConvertValueToInfo(obj:max_value()))
				local size = {obj:size()}
				if size[1] then
					table_insert(data_meta,1,"\nsize(): " .. self:ConvertValueToInfo(size[1])
						.. " " .. self:ConvertValueToInfo(size[2]))
				end

			elseif name == "HGE.XMGrid" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"GridGetAllocSize(): " .. self:ConvertValueToInfo(GridGetAllocSize(obj) or 0))
				local minmax = {obj:minmax()}
				if minmax[1] then
					table_insert(data_meta,1,"minmax(): " .. self:ConvertValueToInfo(minmax[1]) .. " "
						.. self:ConvertValueToInfo(minmax[2]))
				end
				-- this takes a few seconds to load, so it's in a clickable link
				table_insert(data_meta,1,self:ConvertValueToInfo({
					ChoGGi_AddHyperLink = true,
					hint = Strings[302535920001124--[[Will take a few seconds to complete.--]]],
					name = "levels(true, 1):",
					func = function()
						self.ChoGGi.ComFuncs.OpenInExamineDlg({obj:levels(true, 1)})
					end,
				}))

				table_insert(data_meta,1,"GetPositiveCells(): " .. self:ConvertValueToInfo(obj:GetPositiveCells()))
				table_insert(data_meta,1,"EnumZones(): " .. self:ConvertValueToInfo(obj:EnumZones()))
				table_insert(data_meta,1,"size(): " .. self:ConvertValueToInfo(obj:size()))
				table_insert(data_meta,1,"packing(): " .. self:ConvertValueToInfo(obj:packing()))
				-- crashing tendencies
--~ 				table_insert(data_meta,1,"histogram(): " .. self:ConvertValueToInfo({obj:histogram()}))
				-- freeze screen with render error in log ex(Flight_Height:GetBinData())
				table_insert(data_meta,1,"\nCenterOfMass(): " .. self:ConvertValueToInfo(obj:CenterOfMass()))

			elseif name == "HGE.Box" then
				table_insert(data_meta,1,"\ngetmetatable():")
				local points2d = {obj:ToPoints2D()}
				if points2d[1] then
					table_insert(data_meta,1,"ToPoints2D(): " .. self:ConvertValueToInfo(points2d[1])
						.. " " .. self:ConvertValueToInfo(points2d[2])
						.. "\n" .. self:ConvertValueToInfo(points2d[3])
						.. " " .. self:ConvertValueToInfo(points2d[4])
					)
				end
				local bsphere = {obj:GetBSphere()}
				if bsphere[1] then
					table_insert(data_meta,1,"GetBSphere(): "
						.. self:ConvertValueToInfo(bsphere[1]) .. " "
						.. self:ConvertValueToInfo(bsphere[2]))
				end
				local center = obj:Center()
				table_insert(data_meta,1,"Center(): " .. self:ConvertValueToInfo(center))
				table_insert(data_meta,1,"IsEmpty(): " .. self:ConvertValueToInfo(obj:IsEmpty()))
				local Radius = obj:Radius()
				local Radius2D = obj:Radius2D()
				table_insert(data_meta,1,"Radius(): " .. self:ConvertValueToInfo(Radius))
				if Radius ~= Radius2D then
					table_insert(data_meta,1,"Radius2D(): " .. self:ConvertValueToInfo(Radius2D))
				end
				table_insert(data_meta,1,"IsValidZ(): " .. self:ConvertValueToInfo(obj:IsValidZ()))
				table_insert(data_meta,1,"IsValid(): " .. self:ConvertValueToInfo(obj:IsValid()))
				table_insert(data_meta,1,"max(): " .. self:ConvertValueToInfo(obj:max()))
				table_insert(data_meta,1,"min() x,y: " .. self:ConvertValueToInfo(obj:min()))
				table_insert(data_meta,1,"\nsize() w,h: " .. self:ConvertValueToInfo(obj:size()))
				if center:InBox2D(self.ChoGGi.ComFuncs.ConstructableArea()) then
					table_insert(data_meta,1,self:HyperLink(obj,self.ToggleBBox,Strings[302535920001550--[[Toggle viewing BBox.--]]]) .. Strings[302535920001549--[[View BBox--]]] .. hyperlink_end)
				end

			elseif name == "HGE.Point" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"__unm(): " .. self:ConvertValueToInfo(obj:__unm()))
				local x,y,z = obj:xyz()
				local xyz = "x: " .. self:ConvertValueToInfo(x)
					.. ", y: " .. self:ConvertValueToInfo(y)
				if z then
					xyz = xyz .. ", z: " .. self:ConvertValueToInfo(z)
				end
				table_insert(data_meta,1,xyz)
				table_insert(data_meta,1,"IsValidZ(): " .. self:ConvertValueToInfo(obj:IsValidZ()))
				table_insert(data_meta,1,"\nIsValid(): " .. self:ConvertValueToInfo(obj:IsValid()))

			elseif name == "HGE.RandState" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"Last(): " .. self:ConvertValueToInfo(obj:Last()))
				table_insert(data_meta,1,"GetStable(): " .. self:ConvertValueToInfo(obj:GetStable()))
				table_insert(data_meta,1,"Get(): " .. self:ConvertValueToInfo(obj:Get()))
				table_insert(data_meta,1,"\nCount(): " .. self:ConvertValueToInfo(obj:Count()))

			elseif name == "HGE.Quaternion" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"Norm(): " .. self:ConvertValueToInfo(obj:Norm()))
				table_insert(data_meta,1,"Inv(): " .. self:ConvertValueToInfo(obj:Inv()))
				local roll,pitch,yaw = obj:GetRollPitchYaw()
				table_insert(data_meta,1,"GetRollPitchYaw(): "
					.. self:ConvertValueToInfo(roll)
					.. " " .. self:ConvertValueToInfo(pitch)
					.. " " .. self:ConvertValueToInfo(yaw))
				table_insert(data_meta,1,"\nGetAxisAngle(): " .. self:ConvertValueToInfo(obj:GetAxisAngle()))

			elseif name == "LuaPStr" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"hash(): " .. self:ConvertValueToInfo(obj:hash()))
				table_insert(data_meta,1,"str(): " .. self:ConvertValueToInfo(obj:str()))
				table_insert(data_meta,1,"parseTuples(): " .. self:ConvertValueToInfo(obj:parseTuples()))
				table_insert(data_meta,1,"getInt(): " .. self:ConvertValueToInfo(obj:getInt()))
				table_insert(data_meta,1,"\nsize(): " .. self:ConvertValueToInfo(obj:size()))
--~ 			elseif name == "HGE.File" then
--~ 			elseif name == "HGE.ForEachReachable" then
--~ 			elseif name == "RSAKey" then
--~ 			elseif name == "lpeg-pattern" then

			else
				table_insert(data_meta,1,"\ngetmetatable():")

				local is_t = IsT(obj)
				if is_t then
					table_insert(data_meta,1,"THasArgs(): " .. self:ConvertValueToInfo(THasArgs(obj)))
					-- IsT returns the string id, but we'll just call it TGetID() to make it more obvious for people
					table_insert(data_meta,1,"\nTGetID(): " .. self:ConvertValueToInfo(is_t))
					if str_not_translated and not UICity then
						table_insert(data_meta,1,Strings[302535920001500--[[userdata object probably needs UICity to translate.--]]])
					end
				end
			end

			c = c + 1
			list_obj_str[c] = TableConcat(data_meta,"\n")
		end

	-- add some extra info for funcs
	elseif obj_type == "function" then
		if blacklist then
			c = c + 1
			list_obj_str[c] = "\ngetinfo(): " .. self.ChoGGi.ComFuncs.DebugGetInfo(obj)
		else
			c = c + 1
			list_obj_str[c] = "\n"

			local info = debug_getinfo(obj,"Su")

			-- link to source code
			if info.what == "Lua" then
				c = c + 1
				list_obj_str[c] = self:HyperLink(obj,self.ViewSourceCode,Strings[302535920001520--[["Opens source code (if it exists):
Mod code works, as well as HG github code. HG code needs to be placed at ""%sSource""
Example: ""Source/Lua/_const.lua""

Decompiled code won't scroll correctly as the line numbers are different."--]]]:format(ConvertToOSPath("AppData/")))
					.. Strings[302535920001519--[[View Source--]]] .. hyperlink_end
			end
			-- list args
			local args = self:RetFuncArgs(obj)
			if args then
				c = c + 1
				list_obj_str[c] = args
			end
			-- and upvalues
			local nups = info.nups
			if nups > 0 then
				c = self:RetDebugUpValue(obj,list_obj_str,c,nups)
			end
			-- lastly list anything from debug.getinfo()
			c = c + 1
			list_obj_str[c] = self:RetDebugGetInfo(obj)
		end

	elseif obj_type == "thread" then

		c = c + 1
		list_obj_str[c] = "<color 255 255 255>"
			.. Strings[302535920001353--[[Thread info--]]]
			.. ":\nIsValidThread(): "
		local is_valid = IsValidThread(obj)
		if is_valid then
			list_obj_str[c] = list_obj_str[c]
				.. self:ConvertValueToInfo(is_valid or nil)
				.. "\nGetThreadStatus(): "
				.. self:ConvertValueToInfo(GetThreadStatus(obj) or nil)
				.. "\nIsGameTimeThread(): "
				.. self:ConvertValueToInfo(IsGameTimeThread(obj))
				.. "\nIsRealTimeThread(): "
				.. self:ConvertValueToInfo(IsRealTimeThread(obj))
				.. "\nThreadHasFlags(), Persist: "
				.. self:ConvertValueToInfo(ThreadHasFlags(obj,1048576) or false)
				.. " OnMap: "
				.. self:ConvertValueToInfo(ThreadHasFlags(obj,2097152) or false)
				.. "\n"
		else
			list_obj_str[c] = list_obj_str[c]
				.. self:ConvertValueToInfo(is_valid or nil)
				.. "\n"
		end

		local info_list = self.ChoGGi.ComFuncs.RetThreadInfo(obj)
		-- needed for the table that's returned if blacklist is enabled (it starts at 1, getinfo starts at 0)
		local starter = info_list[0] and 0 or 1

		for i = starter, #info_list do
			local info = info_list[i]
			c = c + 1
			list_obj_str[c] = "\ngetinfo(level " .. info.level .. "): "

			c = c + 1
			list_obj_str[c] = "func: " .. info.name .. ", "
				.. self:ConvertValueToInfo(info.func)

			if info.getlocal then
				for j = 1, #info.getlocal do
					local v = info.getlocal[j]
					c = c + 1
					list_obj_str[c] = "getlocal(" .. v.level .. "," .. j .. "): " .. v.name .. ", "
						.. self:ConvertValueToInfo(v.value)
				end
			end

			if info.getupvalue then
				for j = 1, #info.getupvalue do
					local v = info.getupvalue[j]
					c = c + 1
					list_obj_str[c] = "getupvalue(" .. j .. "): " .. v.name .. ", "
						.. self:ConvertValueToInfo(v.value)
				end
			end
		end
		if info_list.gethook then
			c = c + 1
			list_obj_str[c] = self:ConvertValueToInfo(info_list.gethook)
		end

	end

	if not (obj == "nil" or is_valid_obj or obj_type == "userdata") and obj_metatable then
		table_insert(list_obj_str, 1,"\t-- metatable: " .. self:ConvertValueToInfo(obj_metatable) .. " --")

		if self.enum_vars and next(self.enum_vars) then
			list_obj_str[1] = list_obj_str[1] .. self:HyperLink(obj,function()
				self.ChoGGi.ComFuncs.OpenInExamineDlg(self.enum_vars,self,Strings[302535920001442--[[Enum--]]])
			end)
			.. " enum" .. hyperlink_end
		end

	end

	return TableConcat(list_obj_str,"\n")
end
---------------------------------------------------------------------------------------------------------------------
function Examine:SetToolbarVis(obj,obj_metatable)
	-- always hide all
	self.idButMarkObject:SetVisible()
	self.idButMarkAll:SetVisible()
	self.idButSetObjlist:SetVisible()
	self.idButMarkAllLine:SetVisible()
	self.idButDeleteAll:SetVisible()
	self.idViewEnum:SetVisible()
	self.idButDeleteObj:SetVisible()
	-- not a toolbar button, but since we're already calling IsValid then good enough
	self.idObjects:SetVisible()

	-- no sense in showing it in mainmenu/new game screens
	if GameState.gameplay then
		self.idButClear:SetVisible(true)
	else
		self.idButClear:SetVisible()
	end

	if self.obj_type == "table" then
		-- none of it works on _G, and i'll take any bit of speed for _G
		if self.name ~= "_G" then

			-- pretty much any class object
--~ 			if obj.delete then
			if PropObjGetProperty(obj,"delete") then
				self.idButDeleteObj:SetVisible(true)
			end

			if IsValid(obj) then
				-- can't mark if it isn't an object, and no sense in marking something off the map
				if obj:GetPos() ~= InvalidPos then
					self.idButMarkObject:SetVisible(true)
				end
			end

			if PropObjGetProperty(obj,"GetEntity") and IsValidEntity(obj:GetEntity()) then
				self.idObjects:SetVisible(true)
			end

			-- objlist objects let us do some easy for each
			if IsObjlist(obj) then
				self.idButMarkAll:SetVisible(true)
				self.idButMarkAllLine:SetVisible(true)
				self.idButDeleteAll:SetVisible(true)
				-- we only want to show it for objlist or non-metatables, because I don't want to save/restore them
				self.idButSetObjlist:SetVisible(true)
			elseif not obj_metatable then
				self.idButSetObjlist:SetVisible(true)
			end

			-- pretty rare occurrence
			self.enum_vars = EnumVars(self.name)
			if self.enum_vars and next(self.enum_vars) then
				self.idViewEnum:SetVisible(true)
			end
		end

	elseif self.obj_type == "thread" then
		self.idButDeleteObj:SetVisible(true)
	end


end

function Examine:BuildParentsMenu(list,list_type,title,sort_type)
	if list and next(list) then
		list = self.ChoGGi.ComFuncs.RetSortTextAssTable(list,sort_type)
		self[list_type] = list
		local c = #self.parents_menu_popup

		c = c + 1
		self.parents_menu_popup[c] = {
			name = "-- " .. title .. " --",
			disable = true,
			centred = true,
		}

		for i = 1, #list do
			local item = list[i]
			-- no sense in having an item in parents and ancestors
			if not self.pmenu_skip_dupes[item] then
				self.pmenu_skip_dupes[item] = true
				c = c + 1
				self.parents_menu_popup[c] = {
					name = item,
					hint = Strings[302535920000069--[[Examine--]]] .. " " .. Translate(3696--[[Class--]]) .. " " .. Translate(298035641454--[[Object--]]) .. ": <color 100 255 100>" .. item .. "</color>",
					clicked = function()
						self.ChoGGi.ComFuncs.OpenInExamineDlg(g_Classes[item],self)
					end,
				}
			end

		end
	end
end

function Examine:SetObj(startup)
	local obj = self.obj

	-- reset the hyperlinks
	table_iclear(self.onclick_funcs)
	table_iclear(self.onclick_objs)
	self.onclick_count = 0

	if self.str_object then
		-- check if obj string is a ref to an actual object
		local obj_ref = self.ChoGGi.ComFuncs.DotNameToObject(obj)
		-- if it is then we use that as the obj to examine
		if obj_ref then
			obj = obj_ref
		end
	end
	-- so we can access the obj elsewhere
	self.obj_ref = obj

	local obj_type = type(obj)
	self.obj_type = obj_type
	local obj_class

	local name = RetName(obj)
	self.name = name

	local obj_metatable = getmetatable(obj)

	self:SetToolbarVis(obj,obj_metatable)

	self.idText:SetText(Translate(67--[[Loading resources--]]))

	if obj_type == "table" then
		obj_class = g_Classes[obj.class]
		if obj_metatable then
			self.idShowAllValues:SetVisible(true)
		else
			self.idShowAllValues:SetVisible(false)
		end

		-- add table length to title
		if #obj > 0 then
			name = name .. " " .. " (" .. #obj .. ")"
		end

		-- build parents/ancestors menu
		if obj_class then
			table_iclear(self.parents_menu_popup)
			table_clear(self.pmenu_skip_dupes)
			-- build menu list
			self:BuildParentsMenu(obj.__parents,"parents",Strings[302535920000520--[[Parents--]]])
			self:BuildParentsMenu(obj.__ancestors,"ancestors",Strings[302535920000525--[[Ancestors--]]],true)
			-- if anything was added to the list then add to the menu
			if #self.parents_menu_popup > 0 then
				self.idParents:SetVisible(true)
			end
		end

		-- attaches button/menu
		table_iclear(self.attaches_menu_popup)
		local attaches = self.ChoGGi.ComFuncs.GetAllAttaches(obj,true)
		local attach_amount = #attaches

		for i = 1, attach_amount do
			local a = attaches[i]
			local pos = a.GetVisualPos and a:GetVisualPos()

			local name = RetName(a)
			if name ~= a.class then
				name = name .. ": " .. a.class
			end
			-- attached to name
			local a_to = a.ChoGGi_Marked_Attach or false
			a.ChoGGi_Marked_Attach = nil

			self.attaches_menu_popup[i] = {
				name = name,
				hint = Translate(3746--[[Class name--]]) .. ": " .. a.class
					.. (a_to and "\n" .. Strings[302535920001544--[[Attached to: %s--]]]:format(a_to) or "")
					.. "\n".. Strings[302535920000955--[[Handle--]]] .. ": " .. (a.handle or Translate(6761--[[None--]]))
					.. "\n" .. Strings[302535920000461--[[Position--]]] .. ": " .. tostring(pos),
				showobj = a,
				clicked = function()
					self.ChoGGi.ComFuncs.ClearShowObj(a)
					self.ChoGGi.ComFuncs.OpenInExamineDlg(a,self)
				end,
			}

		end

		if attach_amount > 0 then
			table_sort(self.attaches_menu_popup, function(a, b)
				return CmpLower(a.name, b.name)
			end)

			self.idAttaches:SetVisible(true)
			self.idAttaches.RolloverText = Strings[302535920000070--[["Shows list of attachments. This %s has %s.
Use %s to hide green markers."--]]]:format(name,attach_amount,"<image CommonAssets/UI/Menu/NoblePreview.tga 2500>")
		else
			self.idAttaches:SetVisible()
		end

	end -- istable

	if obj == "nil" then
		self.idCaption:SetTitle(self,obj)
	else
		local name_type = obj_type .. ": "
		local title = self.title or name or obj
		self.idCaption:SetTitle(self,name_type .. title:gsub(name_type,""))
	end

	-- we add a slight delay; useful for bigger lists like _G or MapGet(true)
	-- so the dialog shows up (progress is happening user)
		if startup or self.is_chinese then
			-- the chinese text render is slow as shit, so we have a Sleep in ConvertObjToInfo to keep ui stuff accessible
			CreateRealTimeThread(function()
--~ self.ChoGGi.ComFuncs.TickStart("Examine")
				WaitMsg("OnRender")
				self:SetTextSafety(self:ConvertObjToInfo(obj,obj_type))
--~ self.ChoGGi.ComFuncs.TickEnd("Examine",self.name)
			end)
		else
			-- we normally don't want it in a thread with OnRender else it'll mess up my scroll pos (and stuff)
			self:SetTextSafety(self:ConvertObjToInfo(obj,obj_type))
		end

	-- comments are good for stuff like this
	return obj_class
end
-- for external use
Examine.UpdateObj = Examine.SetObj

-- [LUA ERROR] CommonLua/X/XText.lua:191: pattern too complex
function Examine:SetTextSafety(text)
	self.idText:SetText(text)

	-- wait for it
	CreateRealTimeThread(function()
		WaitMsg("OnRender")
		if self:GetCleanText() == Translate(67--[[Loading resources--]]) then
			ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
				parent = self,
				text = text,
--~ 				text = self.idText:GetText(),
				title = Strings[302535920001461--[[XText:ParseText() just ralphed.--]]],
			}
		end
	end)
end

local function PopupClose(name)
	local popup = terminal.desktop[name]
	if popup then
		popup:Close()
	end
end

function Examine:Done(...)
	local obj = self.obj_ref
	-- stop refreshing
	if IsValidThread(self.autorefresh_thread) then
		DeleteThread(self.autorefresh_thread)
	end
	-- close any opened popup menus (they'll do it auto, but this looks quicker)
	PopupClose(self.idAttachesMenu)
	PopupClose(self.idParentsMenu)
	PopupClose(self.idToolsMenu)
	-- if it isn't valid then none of these will exist
	if self.name ~= "_G" and self.obj_type == "table" then
		if IsValid(obj) or PropObjGetProperty(obj,"GetEntity") and IsValidEntity(obj:GetEntity()) then
			self.ChoGGi.ComFuncs.BBoxLines_Clear(obj)
			self.ChoGGi.ComFuncs.ObjHexShape_Clear(obj)
			self.ChoGGi.ComFuncs.EntitySpots_Clear(obj)
			self.ChoGGi.ComFuncs.SurfaceLines_Clear(obj)
		elseif IsObjlist(obj) then
			self.ChoGGi.ComFuncs.ObjListLines_Clear(obj)
		end
	end
	-- clear any spheres/colour marked objs
	if #self.marked_objects > 0 then
		self:idButClearOnPress()
	end
	-- remove this dialog from list of examine dialogs
	local dlgs = g_ExamineDlgs or empty_table
	dlgs[self.obj] = nil
	dlgs[obj] = nil

	return ChoGGi_Window.Done(self,...)
end
