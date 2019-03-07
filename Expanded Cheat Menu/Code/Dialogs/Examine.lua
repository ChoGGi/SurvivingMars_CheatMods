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

local pairs,type,tostring,tonumber = pairs,type,tostring,tonumber
local PropObjGetProperty = PropObjGetProperty

-- store opened examine dialogs
if not PropObjGetProperty(_G,"g_ExamineDlgs") then
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
local IsObjlist = IsObjlist
local IsPoint = IsPoint
local IsT = IsT
local IsValid = IsValid
local IsValidEntity = IsValidEntity
local IsValidThread = IsValidThread
local Sleep = Sleep
local XCreateRolloverWindow = XCreateRolloverWindow
local XDestroyRolloverWindow = XDestroyRolloverWindow

local debug_getinfo,debug_getupvalue,debug_getlocal
local debug = PropObjGetProperty(_G,"debug")
if debug then
	debug_getupvalue = debug.getupvalue
	debug_getinfo = debug.getinfo
	debug_getlocal = debug.getlocal
end

local HLEnd = "</h></color>"

local ClearShowObj
local DebugGetInfo
local DeleteObject
local DotNameToObject
local GetAllAttaches
local GetParentOfKind
local IsControlPressed
local OpenInExamineDlg
local Random
local RandomColour
local ImageExts
local RetName
local RetProperType
local RetSortTextAssTable
local RetThreadInfo
local ShowObj
local TableConcat
local Trans

local InvalidPos
local S
local blacklist
local testing

-- need to wait till Library mod is loaded
function OnMsg.ClassesGenerate()
	local ChoGGi = ChoGGi
	ClearShowObj = ChoGGi.ComFuncs.ClearShowObj
	DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	DeleteObject = ChoGGi.ComFuncs.DeleteObject
	DotNameToObject = ChoGGi.ComFuncs.DotNameToObject
	GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
	IsControlPressed = ChoGGi.ComFuncs.IsControlPressed
	OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
	Random = ChoGGi.ComFuncs.Random
	RandomColour = ChoGGi.ComFuncs.RandomColour
	ImageExts = ChoGGi.ComFuncs.ImageExts
	RetName = ChoGGi.ComFuncs.RetName
	RetProperType = ChoGGi.ComFuncs.RetProperType
	RetThreadInfo = ChoGGi.ComFuncs.RetThreadInfo
	RetSortTextAssTable = ChoGGi.ComFuncs.RetSortTextAssTable
	ShowObj = ChoGGi.ComFuncs.ShowObj
	TableConcat = ChoGGi.ComFuncs.TableConcat
	Trans = ChoGGi.ComFuncs.Translate

	InvalidPos = ChoGGi.Consts.InvalidPos
	S = ChoGGi.Strings
	blacklist = ChoGGi.blacklist
	testing = ChoGGi.testing
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

	local ChoGGi = ChoGGi
	local const = const

	-- my popup func checks for ids and "refreshs" a popup with the same id, so random it is
	self.idAttachesMenu = Random()
	self.idParentsMenu = Random()
	self.idToolsMenu = Random()
	self.idObjectsMenu = Random()

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
	if type(self.obj) == "string" and type(context.parent) == "string" then
		self.str_object = context.parent == "str" and true
		context.parent = nil
	end
	self.name = RetName(self.str_object and DotNameToObject(self.obj) or self.obj)

	self.title = context.title

	self.prefix = S[302535920000069--[[Examine--]]]

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
			RolloverTitle = Trans(1000220--[[Refresh--]]),
			RolloverText = S[302535920000092--[[Updates list with any changed values.--]]],
			OnPress = self.idButRefreshOnPress,
		}, self.idToolbarButtons)
		--
		self.idButSetTransp = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButSetTransp",
			Image = "CommonAssets/UI/Menu/CutSceneArea.tga",
			RolloverTitle = S[302535920000865--[[Trans--]]],
			RolloverText = S[302535920001367--[[Toggles--]]] .. " " .. S[302535920000629--[[UI Transparency--]]],
			OnPress = self.idButSetTranspOnPress,
		}, self.idToolbarButtons)
		--
		self.idButClear = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButClear",
			Image = "CommonAssets/UI/Menu/NoblePreview.tga",
			RolloverTitle = Trans(594--[[Clear--]]),
			RolloverText = S[302535920000016--[["Remove any green spheres/reset green coloured objects
Press once to clear this examine, again to clear all."--]]],
			OnPress = self.idButClearOnPress,
		}, self.idToolbarButtons)
		--
		self.idButMarkObject = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButMarkObject",
			Image = "CommonAssets/UI/Menu/DisableEyeSpec.tga",
			RolloverTitle = S[302535920000057--[[Mark Object--]]],
			RolloverText = S[302535920000021--[[Mark object with green sphere and/or paint.--]]],
			OnPress = self.idButMarkObjectOnPress,
		}, self.idToolbarButtons)
		--
		self.idButDeleteObj = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButDeleteObj",
			Image = "CommonAssets/UI/Menu/delete_objects.tga",
			RolloverTitle = Trans(502364928914--[[Delete--]]),
			RolloverText = S[302535920000414--[[Are you sure you wish to delete it?--]]]:format(self.name),
			OnPress = self.idButDeleteObjOnPress,
		}, self.idToolbarButtons)
		--
		self.idButMarkAll = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButMarkAll",
			Image = "CommonAssets/UI/Menu/ExportImageSequence.tga",
			RolloverTitle = S[302535920000058--[[Mark All Objects--]]],
			RolloverText = S[302535920000056--[[Mark all items in objlist with green spheres.--]]],
			OnPress = self.idButMarkAllOnPress,
		}, self.idToolbarButtons)
		--
		self.idButDeleteAll = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButDeleteAll",
			Image = "CommonAssets/UI/Menu/UnlockCollection.tga",
			RolloverTitle = Trans(3768--[[Destroy all?--]]),
			RolloverText = S[302535920000059--[[Destroy all objects in objlist!--]]],
			OnPress = self.idButDeleteAllOnPress,
		}, self.idToolbarButtons)
		-- right side

		self.idAutoRefresh_update_str = S[302535920001257--[[Auto-refresh list every second.--]]]
			.. "\n" .. S[302535920001422--[[Right-click to change refresh delay.--]]]
			.. "\n" .. S[302535920000106--[[Current--]]] .. ": %s"
		self.idAutoRefresh = g_Classes.ChoGGi_CheckButton:new({
			Id = "idAutoRefresh",
			Dock = "right",
			Text = S[302535920000084--[[Auto-Refresh--]]],
			RolloverText = self.idAutoRefresh_update_str:format(self.autorefresh_delay),
			RolloverHint = S[302535920001425--[["<left_click> Toggle, <right_click> Set Delay"--]]],
			OnChange = self.idAutoRefreshOnChange,
			OnMouseButtonDown = self.idAutoRefreshOnMouseButtonDown,
			Init = self.CheckButtonInit,
		}, self.idToolbarArea)

		self.idAutoRefreshDelay = g_Classes.ChoGGi_TextInput:new({
			Id = "idAutoRefreshDelay",
			Dock = "right",
			MinWidth = 50,
			Margins = box(0,0,6,0),
			FoldWhenHidden = true,
			RolloverText = S[302535920000967--[[Delay in ms between updating text.--]]],
			OnTextChanged = self.idAutoRefreshDelayOnTextChanged,
		}, self.idToolbarArea)
		-- vis is toggled when rightclicking autorefresh checkbox
		self.idAutoRefreshDelay:SetVisible(false)
		self.idAutoRefreshDelay:SetText(tostring(self.autorefresh_delay))
		--
		self.idSortDir = g_Classes.ChoGGi_CheckButton:new({
			Id = "idSortDir",
			Dock = "right",
			Text = Trans(10124--[[Sort--]]),
			RolloverText = S[302535920001248--[[Sort normally or backwards.--]]],
			OnChange = self.idSortDirOnChange,
			Init = self.CheckButtonInit,
		}, self.idToolbarArea)
		--
		self.idShowAllValues = g_Classes.ChoGGi_CheckButton:new({
			Id = "idShowAllValues",
			Dock = "right",
			MinWidth = 0,
			Text = Trans(4493--[[All--]]),
			RolloverText = S[302535920001391--[[Show all values: getmetatable(obj).--]]],
			OnChange = self.idShowAllValuesOnChange,
			Init = self.CheckButtonInit,
		}, self.idToolbarArea)
		--
		self.idViewEnum = g_Classes.ChoGGi_CheckButton:new({
			Id = "idViewEnum",
			Dock = "right",
			MinWidth = 0,
			Text = S[302535920001442--[[Enum--]]],
			RolloverText = S[302535920001443--[[Show values from EnumVars(obj).--]]],
			OnChange = self.idViewEnumOnChange,
		}, self.idToolbarArea)
	end -- toolbar area

	do -- search area
		self.idSearchArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idSearchArea",
			Dock = "top",
		}, self.idDialog)
		--
		self.idSearchText = g_Classes.ChoGGi_TextInput:new({
			Id = "idSearchText",
			RolloverText = S[302535920000043--[["Press <color 0 200 0>Enter</color> to scroll to next found text, <color 0 200 0>Ctrl-Enter</color> to scroll to previous found text, <color 0 200 0>Arrow Keys</color> to scroll to each end."--]]],
			Hint = S[302535920000044--[[Go To Text--]]],
			OnKbdKeyDown = self.idSearchTextOnKbdKeyDown,
		}, self.idSearchArea)
		--
		self.idSearch = g_Classes.ChoGGi_Button:new({
			Id = "idSearch",
			Text = Trans(10123--[[Search--]]),
			Dock = "right",
			RolloverAnchor = "right",
			RolloverHint = S[302535920001424--[["<left_click> Next, <right_click> Previous, <middle_click> Top"--]]],
			RolloverText = S[302535920000045--[["Scrolls down one line or scrolls between text in ""Go to text"".
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
			Text = S[302535920000239--[[Tools--]]],
			RolloverText = S[302535920001426--[[Various tools to use.--]]],
			OnMouseButtonDown = self.idToolsOnMouseButtonDown,
			Dock = "left",
		}, self.idMenuArea)
		--
		self.objects_menu_popup = self:BuildObjectMenuPopup()
		self.idObjects = g_Classes.ChoGGi_ComboButton:new({
			Id = "idObjects",
			Text = Trans(298035641454--[[Object--]]),
			RolloverText = S[302535920001530--[[Various object tools to use.--]]],
			OnMouseButtonDown = self.idObjectsOnMouseButtonDown,
			Dock = "left",
			FoldWhenHidden = true,
		}, self.idMenuArea)
		self.idObjects:SetVisible(false)
		--
		self.idParents = g_Classes.ChoGGi_ComboButton:new({
			Id = "idParents",
			Text = S[302535920000520--[[Parents--]]],
			RolloverText = S[302535920000553--[[Examine parent and ancestor objects.--]]],
			OnMouseButtonDown = self.idParentsOnMouseButtonDown,
			Dock = "left",
			FoldWhenHidden = true,
		}, self.idMenuArea)
		self.idParents:SetVisible(false)
		--
		self.idAttaches = g_Classes.ChoGGi_ComboButton:new({
			Id = "idAttaches",
			Text = S[302535920000053--[[Attaches--]]],
			RolloverText = S[302535920000054--[[Any objects attached to this object.--]]],
			OnMouseButtonDown = self.idAttachesOnMouseButtonDown,
			Dock = "left",
			FoldWhenHidden = true,
		}, self.idMenuArea)
		self.idAttaches:SetVisible(false)
		--
		self.idToggleExecCode = g_Classes.ChoGGi_CheckButton:new({
			Id = "idToggleExecCode",
			Dock = "right",
			Text = S[302535920000040--[[Exec Code--]]],
			RolloverText = S[302535920001514--[[Toggle visibility of an input box for executing code.--]]]
				.. "\n" .. S[302535920001517--[["Use ""o"" as a reference to the examined object."--]]],
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
			RolloverText = S[302535920001515--[[Press enter to execute code.--]]]
				.. "\n" .. S[302535920001517--[["Use ""o"" as a reference to the examined object."--]]],
			Hint = S[302535920001516--[[o = examined object--]]],
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
	self.transp_mode = ChoGGi.Temp.transp_mode
	self:SetTranspMode(self.transp_mode)

	-- no need to have it fire one than once per dialog
	self.is_chinese = GetLanguage():find("chinese")

	-- do the magic
	if self:SetObj(true) then
		-- returns if it's a class object or not
		if ChoGGi.UserSettings.FlashExamineObject and IsKindOf(self.obj_ref,"XWindow") and self.obj_ref.class ~= "InGameInterface" then
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
	local str,path = ChoGGi.ComFuncs.RetSourceFile(info.source)
	if not str then
		local msg = S[302535920001521--[[Lua source file not found.--]]] .. ": " .. ConvertToOSPath(path)
		ChoGGi.ComFuncs.MsgPopup(
			msg,
			S[302535920001519--[[View Source--]]]
		)
		print(msg)
	end
	ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
		parent = self,
		checkbox = true,
		text = str,
		code = true,
		scrollto = info.linedefined,
		title = S[302535920001519--[[View Source--]]] .. ": " .. info.source,
		hint_ok = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
		custom_func = function(answer,overwrite)
			if answer then
				ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedSource","lua")
			end
		end,
	}
end

-- (link, hyperlink_box, pos)
function Examine:idTextOnHyperLinkRollover(link)
	if not ChoGGi.UserSettings.EnableToolTips then
		return
	end
	if not link then
		-- close opened tooltip
		if RolloverWin then
			XDestroyRolloverWindow()
		end
		SetUIMouseCursor(const.DefaultMouseCursor)
		return
	end
	self = GetRootDialog(self)

  SetUIMouseCursor("CommonAssets/UI/HandCursor.tga")

	link = tonumber(link)
	local obj = self.onclick_objs[link]
	if not obj then
		return
	end

	local title = S[302535920000069--[[Examine--]]]
	local name = RetName(obj)

	if self.onclick_funcs[link] == self.OpenListMenu then
		title = name .. " " .. Trans(1000162--[[Menu--]])
		name = S[302535920001540--[[Show context menu for %s.--]]]:format(name)

--~ 		-- stick value in search box
--~ 		obj = self.obj_ref[obj]
--~ 		self.idSearchText:SetText(type(obj) == "userdata" and IsT(obj) and Trans(obj) or tostring(obj))
	end

	XCreateRolloverWindow(self.idDialog, RolloverGamepad, true, {
		RolloverTitle = title,
		RolloverText = self.onclick_name[link] or name,
		RolloverHint = S[302535920001079--[[<left_click> Default Action <right_click> Examine--]]],
	})
end

-- clicked
function Examine:idTextOnHyperLink(link, argument, hyperlink_box, pos, button)
	self = GetRootDialog(self)

	link = tonumber(link)
	local obj = self.onclick_objs[link]

	-- we always examine on right-click
	if button == "R" then
		ChoGGi.ComFuncs.OpenInExamineDlg(obj,self)
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
			ClearShowObj(self.marked_objects[i])
		end
	else
		-- clear all spheres
		ClearShowObj(true)
		-- if this has a custom colour
		ClearShowObj(self.obj_ref)
	end
	self.marked_objects:Clear()
end

function Examine:idButMarkObjectOnPress()
	self = GetRootDialog(self)
	if IsValid(self.obj_ref) then
		-- i don't use AddSphere since that won't add the ColourObj
		local c = #self.marked_objects
		local sphere = ChoGGi.ComFuncs.ShowPoint(self.obj_ref)
		if IsValid(sphere) then
			c = c + 1
			self.marked_objects[c] = sphere
		end
		local obj = ChoGGi.ComFuncs.ColourObj(self.obj_ref)
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
	ChoGGi.ComFuncs.DeleteObjectQuestion(GetRootDialog(self).obj_ref)
end

function Examine:idButDeleteAllOnPress()
	self = GetRootDialog(self)
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000059--[[Destroy all objects in objlist!--]]],
		function(answer)
			if answer then
				SuspendPassEdits("Examine:idButDeleteAllOnPress")
				for _,obj in pairs(self.obj_ref) do
					if IsValid(obj) then
						DeleteObject(obj)
					elseif obj.delete then
						DoneObject(obj)
					end
				end
				ResumePassEdits("Examine:idButDeleteAllOnPress")
				-- force a refresh on the list, so people can see something as well
				self:SetObj()
			end
		end,
		Trans(697--[[Destroy--]])
	)
end
function Examine:idViewEnumOnChange()
	self = GetRootDialog(self)
	self.show_enum_values = not self.show_enum_values
	self:SetObj()
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
end

function Examine:AddSphere(obj,c,colour,skip_view,skip_colour)
	local sphere = ShowObj(obj, colour,skip_view,skip_colour)
	if IsValid(sphere) then
		c = (c and c + 1) or (#self.marked_objects + 1)
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
			ChoGGi.UserSettings.ExamineRefreshTime = num
			ChoGGi.SettingFuncs.WriteSettings()
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
		{name = S[302535920000457--[[Anim State Set--]]],
			hint = S[302535920000458--[[Make object dance on command.--]]],
			image = "CommonAssets/UI/Menu/UnlockCamera.tga",
			clicked = function()
				ChoGGi.ComFuncs.SetAnimState(self.obj_ref)
			end,
		},
		{name = S[302535920000459--[[Anim Debug Toggle--]]],
			hint = S[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
			image = "CommonAssets/UI/Menu/CameraEditor.tga",
			clicked = function()
				ChoGGi.ComFuncs.ShowAnimDebug_Toggle(self.obj_ref)
			end,
		},
		{name = S[302535920000682--[[Change Entity--]]],
			hint = S[302535920001151--[[Set Entity For %s--]]]:format(self.name),
			image = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
			clicked = function()
				ChoGGi.ComFuncs.EntitySpawner(self.obj_ref,true,7)
			end,
		},
		{name = S[302535920000129--[[Set--]]] .. " " .. S[302535920001184--[[Particles--]]],
			hint = S[302535920001421--[[Shows a list of particles you can use on the selected obj.--]]],
			image = "CommonAssets/UI/Menu/place_particles.tga",
			clicked = function()
				ChoGGi.ComFuncs.SetParticles(self.obj_ref)
			end,
		},
		{is_spacer = true},
		{name = S[302535920001472--[[BBox Toggle--]]],
			hint = S[302535920001473--[[Toggle showing object's bbox (changes depending on movement).--]]],
			image = "CommonAssets/UI/Menu/SelectionEditor.tga",
			clicked = function()
				self:ShowBBoxList()
			end,
		},
		{name = S[302535920001522--[[Hex Shape Toggle--]]],
			hint = S[302535920001523--[[Toggle showing shapes for the object.--]]],
			image = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
			clicked = function()
				self:ShowHexShapeList()
			end,
		},
		{name = S[302535920000449--[[Attach Spots Toggle--]]],
			hint = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
			image = "CommonAssets/UI/Menu/ShowAll.tga",
			clicked = function()
				self:ShowAttachSpotsList()
			end,
		},
		{name = S[302535920000235--[[Attach Spots List--]]],
			hint = S[302535920001445--[[Shows list of attaches for use with .ent files.--]]],
			image = "CommonAssets/UI/Menu/ListCollections.tga",
			clicked = function()
				ChoGGi.ComFuncs.ExamineEntSpots(self.obj_ref,self)
			end,
		},
		{name = S[302535920001458--[[Material Properties--]]],
			hint = S[302535920001459--[[Shows list of material settings/.dds files for use with .mtl files.--]]],
			image = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
			clicked = function()
				ChoGGi.ComFuncs.GetMaterialProperties(self.obj_ref:GetEntity(),self)
			end,
		},
		{name = S[302535920001476--[[Flags--]]],
			hint = S[302535920001447--[[Shows list of flags set for selected object.--]]],
			image = "CommonAssets/UI/Menu/JoinGame.tga",
			clicked = function()
				-- task requests have flags too, ones that aren't listed in the Flags table... (just const.rf*)
				if self.obj_flags then
					ChoGGi.ComFuncs.ObjFlagsList_TR(self.obj_ref,self)
				else
					ChoGGi.ComFuncs.ObjFlagsList(self.obj_ref,self)
				end
			end,
		},
		{name = S[302535920001524--[[Entity Surfaces--]]],
			hint = S[302535920001525--[[Shows list of surfaces for the object entity.--]]],
			image = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
			clicked = function()
				OpenInExamineDlg(
					ChoGGi.ComFuncs.RetSurfaceMasks(self.obj_ref),self,
					S[302535920001524--[[Entity Surfaces--]]] .. ": " .. self.name
				)
			end,
		},

		{name = S[302535920001551--[[Surfaces Toggle--]]],
			hint = S[302535920001552--[[Show a list of surfaces and draw lines over them (GetRelativeSurfaces).--]]],
			image = "CommonAssets/UI/Menu/ToggleCollisions.tga",
			clicked = function()
				self:ShowSurfacesList()
			end,
		},
	}
end

function Examine:BuildToolsMenuPopup()
	local list = {
		{name = S[302535920001467--[[Append Dump--]]],
			hint = S[302535920001468--[["Append text to same file, or create a new file each time."--]]],
			clicked = function()
				ChoGGi.UserSettings.ExamineAppendDump = not ChoGGi.UserSettings.ExamineAppendDump
				ChoGGi.SettingFuncs.WriteSettings()
			end,
			value = "ChoGGi.UserSettings.ExamineAppendDump",
			class = "ChoGGi_CheckButtonMenu",
		},
		{name = S[302535920000004--[[Dump--]]] .. " " .. Trans(1000145--[[Text--]]),
			hint = S[302535920000046--[[dumps text to %slogs\DumpedExamine.lua--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_down.tga",
			clicked = function()
				local str = self:GetCleanText()
				-- i just compare, so append doesn't really work
				if ChoGGi.UserSettings.ExamineAppendDump then
					ChoGGi.ComFuncs.Dump("\n" .. str,nil,"DumpedExamine","lua")
				else
					ChoGGi.ComFuncs.Dump(str,"w","DumpedExamine","lua",nil,true)
				end
			end,
		},
		{name = S[302535920000004--[[Dump--]]] .. " " .. Trans(298035641454--[[Object--]]),
			hint = S[302535920001027--[[dumps object to %slogs\DumpedExamineObject.lua

This can take time on something like the "Building" metatable--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_down.tga",
			clicked = function()
				local str
				pcall(function()
					str = ValueToLuaCode(self.obj_ref)
				end)
				if str then
					if ChoGGi.UserSettings.ExamineAppendDump then
						ChoGGi.ComFuncs.Dump("\n" .. str,nil,"DumpedExamineObject","lua")
					else
						ChoGGi.ComFuncs.Dump(str,"w","DumpedExamineObject","lua",nil,true)
					end
				end
			end,
		},
		{name = S[302535920000048--[[View--]]] .. " " .. Trans(1000145--[[Text--]]),
			hint = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_up.tga",
			clicked = function()
				local str,scrolled_text = self:GetCleanText(true)

				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					parent = self,
					checkbox = true,
					text = str,
					scrollto = scrolled_text,
					title = S[302535920000048--[[View--]]] .. "/" .. S[302535920000004--[[Dump--]]] .. Trans(1000145--[[Text--]]),
					hint_ok = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedExamine","lua")
						end
					end,
				}
			end,
		},
		{name = S[302535920000048--[[View--]]] .. " " .. Trans(298035641454--[[Object--]]),
			hint = S[302535920000049--[["View text, and optionally dumps object to %sDumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_up.tga",
			clicked = function()
				local str
				pcall(function()
					str = ValueToLuaCode(self.obj_ref)
				end)
				if str then
					ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
						parent = self,
						checkbox = true,
						text = str,
						title = S[302535920000048--[[View--]]] .. "/" .. S[302535920000004--[[Dump--]]] .. Trans(298035641454--[[Object--]]),
						hint_ok = S[302535920000049--[["View text, and optionally dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]]],
						custom_func = function(answer,overwrite)
							if answer then
								ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedExamineObject","lua")
							end
						end,
					}
				end
			end,
		},
		{is_spacer = true},
		{name = S[302535920001239--[[Functions--]]],
			hint = S[302535920001240--[[Show all functions of this object and parents/ancestors.--]]],
			image = "CommonAssets/UI/Menu/gear.tga",
			clicked = function()
				if #self.parents > 0 or #self.ancestors > 0 then
					table_clear(self.menu_added)
					table_clear(self.menu_list_items)

					if #self.parents > 0 then
						self:ProcessList(self.parents," " .. S[302535920000520--[[Parents--]]] .. ": ")
					end
					if #self.ancestors > 0 then
						self:ProcessList(self.ancestors," " .. S[302535920000525--[[Ancestors--]]] .. ": ")
					end
					-- add examiner object with some spaces so it's at the top
					self:BuildFuncList(self.obj_ref.class,"	")
					-- if Object hasn't been added, then add CObject (O has a few more funcs than CO)
					if not self.menu_added.Object and self.menu_added.CObject then
						self:BuildFuncList("CObject",self.menu_added.CObject)
					end

					OpenInExamineDlg(
						self.menu_list_items,self,
						S[302535920001239--[[Functions--]]] .. ": " .. self.name
					)
				else
					-- make me a MsgPopup
					print(Trans(9763--[[No objects matching current filters.--]]))
				end
			end,
		},
		{name = Trans(327465361219--[[Edit--]]) .. " " .. Trans(298035641454--[[Object--]]),
			hint = S[302535920000050--[[Opens object in Object Manipulator.--]]],
			image = "CommonAssets/UI/Menu/AreaProperties.tga",
			clicked = function()
				ChoGGi.ComFuncs.OpenInObjectEditorDlg(self.obj_ref,self)
			end,
		},
		{name = Trans(174--[[Color Modifier--]]),
			hint = S[302535920000693--[[Select/mouse over an object to change the colours
Use Shift- or Ctrl- for random colours/reset colours.--]]],
			image = "CommonAssets/UI/Menu/toggle_dtm_slots.tga",
			clicked = function()
				ChoGGi.ComFuncs.ChangeObjectColour(self.obj_ref)
			end,
		},
		{name = S[302535920001469--[[Image Viewer--]]],
			hint = S[302535920001470--[["Open a dialog with a list of images from object (.dds, .tga, .png)."--]]],
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
				if not ChoGGi.ComFuncs.DisplayObjectImages(self.obj_ref,self,images_table) then
					ChoGGi.ComFuncs.MsgPopup(
						S[302535920001471--[[No images found.--]]],
						S[302535920001469--[[Image Viewer--]]]
					)
				end
			end,
		},
		{name = S[302535920001305--[[Find Within--]]],
			hint = S[302535920001303--[[Search for text within %s.--]]]:format(self.name),
			image = "CommonAssets/UI/Menu/EV_OpenFirst.tga",
			clicked = function()
				ChoGGi.ComFuncs.OpenInFindValueDlg(self.obj_ref,self)
			end,
		},
		{name = S[302535920000040--[[Exec Code--]]],
			hint = S[302535920000052--[["Execute code (using console for output). o is whatever object is opened in examiner.
Which you can then mess around with some more in the console."--]]],
			image = "CommonAssets/UI/Menu/AlignSel.tga",
			clicked = function()
				ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj_ref,self)
			end,
		},
		{is_spacer = true},
		{name = Trans(931--[[Modified property--]]),
			hint = S[302535920001384--[[Get properties different from base/parent object?--]]],
			image = "CommonAssets/UI/Menu/SelectByClass.tga",
			clicked = function()
				if self.obj_ref.IsKindOf and self.obj_ref:IsKindOf("PropertyObject") then
					OpenInExamineDlg(
						GetModifiedProperties(self.obj_ref),
						self,
						Trans(931--[[Modified property--]]) .. ": " .. self.name
					)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920001389--[[All Properties--]]],
			hint = S[302535920001390--[[Get all properties.--]]],
			image = "CommonAssets/UI/Menu/CollectionsEditor.tga",
			clicked = function()
				-- give em some hints
				if self.obj_ref.IsKindOf and self.obj_ref:IsKindOf("PropertyObject") then
					local props = self.obj_ref:GetProperties()
					local props_list = {
						___readme = S[302535920001397--[["Not the actual properties (see object.properties for those).

Use obj:GetProperty(""NAME"") and obj:SetProperty(""NAME"",value)
You can access a default value with obj:GetDefaultPropertyValue(""NAME"")
"--]]]
					}
					for i = 1, #props do
						props_list[props[i].id] = self.obj_ref:GetProperty(props[i].id)
					end
					OpenInExamineDlg(
						props_list,self,
						S[302535920001389--[[All Properties--]]] .. ": " .. self.name
					)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920001369--[[Ged Editor--]]],
			hint = S[302535920000482--[["Shows some info about the object, and so on. Some buttons may make camera wonky (use Game>Camera>Reset)."--]]],
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
		{name = S[302535920000067--[[Ged Inspect--]]],
			hint = S[302535920001075--[[Open this object in the Ged inspector.--]]],
			image = "CommonAssets/UI/Menu/EV_OpenFromInputBox.tga",
			clicked = function()
				Inspect(self.obj_ref)
			end,
		},
		{is_spacer = true},
		{name = S[302535920001321--[[UI Click To Examine--]]],
			hint = S[302535920001322--[[Examine UI controls by clicking them.--]]],
			image = "CommonAssets/UI/Menu/select_objects.tga",
			clicked = function()
				ChoGGi.ComFuncs.TerminalRolloverMode(true,self)
			end,
		},
		{name = S[302535920000970--[[UI Flash--]]],
			hint = S[302535920000972--[[Flash visibility of the UI object being examined.--]]],
			clicked = function()
				ChoGGi.UserSettings.FlashExamineObject = not ChoGGi.UserSettings.FlashExamineObject
				ChoGGi.SettingFuncs.WriteSettings()
			end,
			value = "ChoGGi.UserSettings.FlashExamineObject",
			class = "ChoGGi_CheckButtonMenu",
		},
	}
	if testing then
		local name = Trans(327465361219--[[Edit--]]) .. " " .. Trans(298035641454--[[Object--]]) .. " " .. S[302535920001432--[[3D--]]]
		table.insert(list,9,{name = name,
			hint = S[302535920001433--[[Fiddle with object angle/axis/pos and so forth.--]]],
			image = "CommonAssets/UI/Menu/Axis.tga",
			clicked = function()
				ChoGGi.ComFuncs.OpenIn3DManipulatorDlg(self.obj_ref,self)
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
		local dlg = GetRootDialog(self)
		-- same colour as bg of icons :)
		dlg[items].Background = -9868951
		dlg[items].FocusedBackground = -9868951
		dlg[items].PressedBackground = -12500671
		dlg[items].TextStyle = "ChoGGi_CheckButtonMenuOpp"
		ChoGGi.ComFuncs.PopupToggle(self,dlg[popup_id],dlg[items],"bottom")
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
		if type(value) == "function" then
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
		msg or S[302535920001526--[[Not a valid object--]]],
		title or S[302535920000069--[[Examine--]]]
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
		return self:InvalidMsgPopup(nil,Trans(155--[[Entity--]]))
	end

	ChoGGi.ComFuncs.ObjHexShape_Clear(obj)

	self.hex_shape_tables = self.hex_shape_tables or {
		"HexBuildShapes",
		"HexBuildShapesInversed",
		"HexCombinedShapes",
		"HexInteriorShapes",
		"HexOutlineShapes",
		"HexPeripheralShapes",
	}

	local item_list = {{
		text = " " .. Trans(594--[[Clear--]]),
		value = "Clear",
	}}
	local c = 1

	local g = _G
	for i = 1, #self.hex_shape_tables do
		local shape_list = self.hex_shape_tables[i]
		local shape = g[shape_list][entity]
		if shape then
			c = c + 1
			item_list[c] = {
				text = shape_list,
				shape = shape,
			}
		end
	end

	local surfs = ChoGGi.ComFuncs.RetHexSurfaces(entity,true,true)
	for i = 1, #surfs do
		local s = surfs[i]
		c = c + 1
		item_list[c] = {
			text = "GetSurfaceHexShapes(), " .. s.name .. ", mask: " .. s.id
				.. " (" .. s.mask .. ") state:" .. s.state,
			value = "GetSurfaceHexShapes_out",
			shape = s.shape,
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]
		if choice.value == "Clear" then
			ChoGGi.ComFuncs.ObjHexShape_Clear(obj)
		elseif type(choice.shape) == "table" then
			ChoGGi.ComFuncs.ObjHexShape_Toggle(obj,{
				shape = choice.shape,
				func = choice.func,
				skip_return = true,
				depth_test = choice.check1,
				hex_pos = choice.check2,
			})
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = S[302535920001522--[[Hex Shape Toggle--]]] .. ": " .. self.name,
		skip_sort = true,
		custom_type = 7,
		checkboxes = {
			{
				title = S[302535920001553--[[Depth Test--]]],
				hint = S[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
				checked = false,
			},
			{
				title = S[302535920001069--[[Show Positions--]]],
				hint = S[302535920001076--[[Shows the hex position of the spot: (-1,5).--]]],
				checked = true,
			},
		},
	}
end

function Examine:ShowBBoxList()
	local obj = self.obj_ref
	if not IsValidEntity(obj:GetEntity()) then
		return self:InvalidMsgPopup(nil,Trans(155--[[Entity--]]))
	end

-- might be useful?
--~ ToBBox(pos, prefab.size, angle)

	ChoGGi.ComFuncs.BBoxLines_Clear(obj)

	local item_list = {
		{text = " " .. Trans(594--[[Clear--]]),value = "Clear"},
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
			ChoGGi.ComFuncs.BBoxLines_Clear(obj)
		else
			ChoGGi.ComFuncs.BBoxLines_Toggle(obj,{
				func = choice.value,
				args = choice.args,
				skip_return = true,
				depth_test = choice.check1,
			})
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = S[302535920001472--[[BBox Toggle--]]] .. ": " .. self.name,
		hint = S[302535920000264--[["Defaults to ObjectHierarchyBBox(obj,const.efCollision) if it can't find a func."--]]],
		skip_sort = true,
		custom_type = 7,
		checkboxes = {
			{
				title = S[302535920001553--[[Depth Test--]]],
				hint = S[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
				checked = false,
			},
		},
	}
end

function Examine:ShowAttachSpotsList()
	local obj = self.obj_ref

	ChoGGi.ComFuncs.AttachSpots_Clear(obj)

	if not IsValidEntity(obj:GetEntity()) then
		return self:InvalidMsgPopup(nil,Trans(155--[[Entity--]]))
	end

	local item_list = {
		{text = " " .. Trans(4493--[[All--]]),value = "All"},
		{text = " " .. Trans(594--[[Clear--]]),value = "Clear"},
	}
	local c = #item_list

	local dupes = {}
	local id_start, id_end = obj:GetAllSpots(obj:GetState())
	for i = id_start, id_end do
		local spot_name = GetSpotNameByType(obj:GetSpotsType(i))
		local spot_annot = obj:GetSpotAnnotation(i) or ""

		local count = spot_annot:find("[,:;]")
		local spot_annot_n
		if count then
			spot_annot_n = spot_annot:sub(1,count-1)
		end
		local name = spot_name .. (spot_annot_n and ";" .. spot_annot_n or "")

		if not dupes[name] then
			dupes[name] = true
			c = c + 1
			item_list[c] = {
				text = name,
				name = spot_name,
				value = spot_annot_n,
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
			ChoGGi.ComFuncs.AttachSpots_Toggle(obj)
		elseif choice.value == "Clear" then
			ChoGGi.ComFuncs.AttachSpots_Clear(obj)
		else
			ChoGGi.ComFuncs.AttachSpots_Toggle(obj,{
				spot_type = choice.name,
				annotation = choice.value,
				skip_return = true,
				depth_test = choice.check1,
				pos = choice.check2,
			})
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = S[302535920000449--[[Attach Spots Toggle--]]] .. ": " .. self.name,
		hint = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
		custom_type = 7,
		skip_icons = true,
		checkboxes = {
			{
				title = S[302535920001553--[[Depth Test--]]],
				hint = S[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
				checked = false,
			},
			{
				title = S[302535920000461--[[Position--]]],
				hint = S[302535920000463--[[Add spot pos to the name.--]]],
				checked = false,
			},
		},
	}
end

function Examine:ShowSurfacesList()
	local obj = self.obj_ref

	ChoGGi.ComFuncs.SurfaceLines_Clear(obj)

	local entity = obj:GetEntity()
	if not IsValidEntity(entity) then
		return self:InvalidMsgPopup(nil,Trans(155--[[Entity--]]))
	end

	local item_list = {
		{text = " " .. Trans(594--[[Clear--]]),value = "Clear"},
		{
			text = "0",
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
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if choice.value == "Clear" then
			ChoGGi.ComFuncs.SurfaceLines_Clear(obj)
		else
			ChoGGi.ComFuncs.SurfaceLines_Toggle(obj,{
				surface_mask = choice.value,
				skip_return = true,
				surfs = choice.surfs,
				depth_test = choice.check1,
			})
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = S[302535920001551--[[Surfaces Toggle--]]] .. ": " .. self.name,
		hint = S[302535920001552--[[Show a list of surfaces and draw lines over them (GetRelativeSurfaces).--]]],
		custom_type = 7,
		checkboxes = {
			{
				title = S[302535920001553--[[Depth Test--]]],
				hint = S[302535920001554--[[If enabled lines will hide behind occluding walls (not glass).--]]],
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
	ChoGGi.Temp.transp_mode = toggle
end
--
local function Show_ConvertValueToInfo(self,button,obj)
	-- not ingame = no sense in using ShowObj
	if button == "L" and GameState.gameplay and (IsValid(obj) or IsPoint(obj)) then
		self:AddSphere(obj)
	else
		OpenInExamineDlg(obj,self)
	end
end
local function Examine_ConvertValueToInfo(self,button,obj)
	-- not ingame = no sense in using ShowObj
	if button == "L" then
		OpenInExamineDlg(obj,self)
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
	self.list_menu_table = self.list_menu_table or {}
	-- id for PopupToggle
	self.opened_list_menu = Random()

	-- they're sent as strings, but I need to know if it's a number or string and so on
	local obj_key,obj_type = RetProperType(obj_name)

	local obj_value = self.obj_ref[obj_key]
	local obj_value_str = tostring(obj_value)

	local list = {
		{name = obj_name,
			hint = S[302535920001538--[[Close this menu.--]]],
			image = "CommonAssets/UI/Menu/default.tga",
			clicked = function()
				local popup = PropObjGetProperty(terminal.desktop,self.opened_list_menu)
				if popup then
					popup:Close()
				end
			end,
		},
		{is_spacer = true},
		{name = Trans(833734167742--[[Delete Item--]]),
			hint = S[302535920001536--[["Remove the ""%s"" key from %s."--]]]:format(obj_name,self.name),
			image = "CommonAssets/UI/Menu/DeleteArea.tga",
			clicked = function()
				if obj_type == "string" then
					self:ShowExecCodeWithCode("o." .. obj_name .. " = nil")
				else
					self:ShowExecCodeWithCode("table.remove(o" .. "," .. obj_name .. ")")
				end
			end,
		},
		{name = S[302535920001535--[[Set Value--]]],
			hint = S[302535920001539--[[Change the value of %s.--]]]:format(obj_name),
			image = "CommonAssets/UI/Menu/SelectByClassName.tga",
			clicked = function()
				self:ShowExecCodeWithCode("o." .. obj_name .. " = " .. obj_value_str)
			end,
		},
	}

	-- if it's an image path then we add an image viewer
	if ImageExts()[obj_value_str:sub(-3):lower()] then
		c = c + 1
		list[c] = {name = S[302535920001469--[[Image Viewer--]]],
			hint = S[302535920001470--[["Open a dialog with a list of images from object (.dds, .tga, .png)."--]]],
			image = "CommonAssets/UI/Menu/light_model.tga",
			clicked = function()
				ChoGGi.ComFuncs.OpenInImageViewerDlg(obj_value_str,self)
			end,
		}
	end

	-- add print for funcs
	if type(obj_value) == "function" then
		local c = #list
		c = c + 1
		list[c] = {is_spacer = true}
		c = c + 1
		list[c] = {name = S[302535920000524--[[Print Func--]]],
			hint = S[302535920000906--[[Print func name when this func is called.--]]],
			image = "CommonAssets/UI/Menu/Action.tga",
			clicked = function()
				ChoGGi.ComFuncs.PrintToFunc_Add(
					obj_value, -- func to print
					obj_key, -- func name
					self.obj_ref, -- parent
					self.name .. "." .. obj_key -- printed name
				)
			end,
		}
		c = c + 1
		list[c] = {name = S[302535920000745--[[Print Func Params--]]],
			hint = S[302535920000906] .. "\n" .. S[302535920000984--[[Also prints params.--]]],
			image = "CommonAssets/UI/Menu/ApplyWaterMarkers.tga",
			clicked = function()
				ChoGGi.ComFuncs.PrintToFunc_Add(obj_value,obj_key,self.obj_ref,self.name .. "." .. obj_key,true)
			end,
		}
		c = c + 1
		list[c] = {name = S[302535920000900--[[Print Reset--]]],
			hint = S[302535920001067--[[Remove print from func.--]]],
			image = "CommonAssets/UI/Menu/reload.tga",
			clicked = function()
				ChoGGi.ComFuncs.PrintToFunc_Remove(obj_value,obj_key,self.obj_ref)
			end,
		}
	end

	-- style it like the other examine menus
	list.Background = -9868951
	list.FocusedBackground = -9868951
	list.PressedBackground = -12500671
	list.TextStyle = "ChoGGi_CheckButtonMenuOpp"
	-- make a fake anchor for PopupToggle to use (
	self.list_menu_table.ChoGGi_self = self
	self.list_menu_table.box = hyperlink_box
	ChoGGi.ComFuncs.PopupToggle(self.list_menu_table,self.opened_list_menu,list,"left")
end

function Examine:ConvertValueToInfo(obj)
	local obj_type = type(obj)

	if obj_type == "string" then
		-- some translated stuff has <color in it, so we make sure they don't colour the rest
		local _,colour_cnt = obj:gsub("<color ","")
		for _ = 1, colour_cnt do
			obj = obj .. "</color>"
		end
		return "'<color " .. ChoGGi.UserSettings.ExamineColourStr .. ">" .. obj .. "</color>'"
	end
	--
	if obj_type == "number" then
		return "<color " .. ChoGGi.UserSettings.ExamineColourNum .. ">" .. obj .. "</color>"
	end
	--
	if obj_type == "boolean" then
		return "<color " .. ChoGGi.UserSettings.ExamineColourBool .. ">" .. tostring(obj) .. "</color>"
	end
	--
	if obj_type == "table" then

		if IsValid(obj) then
			return self:HyperLink(obj,Examine_ConvertValueToInfo)
				.. obj.class .. HLEnd .. "@"
				.. self:ConvertValueToInfo(obj:GetVisualPos())
		else
			local len = #obj
			local obj_metatable = getmetatable(obj)

			-- if it's an objlist then we just return a list of the objects
			if obj_metatable and IsObjlist(obj_metatable) then
				local res = {
					self:HyperLink(obj,Examine_ConvertValueToInfo),
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
					res[c] = self:ConvertValueToInfo(obj[i])
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

			elseif PropObjGetProperty(obj,"ChoGGi_AddHyperLink") and obj.ChoGGi_AddHyperLink then
				return self:HyperLink(obj,obj.func) .. obj.name .. HLEnd

			else
				-- regular table
				local table_data
				local is_next = type(next(obj)) ~= "nil"

				-- not sure how to check if it's an index non-ass table
				if len > 0 and is_next then
					-- next works for both
					table_data = len .. " / " .. S[302535920001057--[[Data--]]]
				elseif is_next then
					-- ass based
					table_data = S[302535920001057--[[Data--]]]
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

				return self:HyperLink(obj,Examine_ConvertValueToInfo) .. name .. HLEnd
			end
		end
	end
	--
	if obj_type == "userdata" then

		if IsPoint(obj) then
			-- InvalidPos()
			if obj == InvalidPos then
				return S[302535920000066--[[<color 203 120 30>Off-Map</color>--]]]
			else
				local x,y,z = obj:xyz()
				return self:HyperLink(obj,Show_ConvertValueToInfo)
					.. S[302535920001396--[[point--]]]
					.. "(" .. x .. "," .. y .. (z and "," .. z or "") .. ")"
					.. HLEnd
			end
		else
			-- show translated text if possible and return a clickable link
			local trans_str = Trans(obj)
			if trans_str == "Missing text" or #trans_str > 16 and trans_str:sub(-16) == " *bad string id?" then
				trans_str = tostring(obj)
			end
			local meta = getmetatable(obj)

			-- the </color> is to make sure it doesn't bleed into other text
			local _,colour_cnt = trans_str:gsub("<color ","")
			for _ = 1, colour_cnt do
				trans_str = trans_str .. "</color>"
			end

			trans_str = trans_str .. self:HyperLink(obj,Examine_ConvertValueToInfo) .. " *"

			-- if meta name then add it
			if meta and meta.__name then
				trans_str = trans_str .. "userdata (" .. meta.__name .. ")"
			else
				trans_str = trans_str .. tostring(obj)
			end

			return trans_str .. HLEnd
		end
	end
	--
	if obj_type == "function" then
		return self:HyperLink(obj,Examine_ConvertValueToInfo)
			.. RetName(obj) .. HLEnd
	end
	--
	if obj_type == "thread" then
		return self:HyperLink(obj,Examine_ConvertValueToInfo)
			.. tostring(obj) .. HLEnd
	end
	--
	if obj_type == "nil" then
		return "<color " .. ChoGGi.UserSettings.ExamineColourNil .. ">nil</color>"
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
			name = name ~= "" and name or S[302535920000723--[[Lua--]]]

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
	else
		return "params: ()"
	end
end

function Examine:ToggleBBox(_,bbox)
	if self.spawned_bbox then
		-- the clear func expect it this way
		self.spawned_bbox.ChoGGi_bboxobj = self.spawned_bbox
		ChoGGi.ComFuncs.BBoxLines_Clear(self.spawned_bbox)
		self.spawned_bbox = false
	else
		self.spawned_bbox = ChoGGi.ComFuncs.BBoxLines_Toggle(bbox)
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
	local is_valid_obj
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
			name = self:HyperLink(k,self.OpenListMenu) .. "* " .. HLEnd .. name
--~ 			local hyper_c = self.onclick_count

			-- store the names if we're doing all props
			if show_all_values then
				skip_dupes[sort] = true
			end
			c = c + 1
			local str_tmp = name .. " = " .. self:ConvertValueToInfo(v) .. "<left>"
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
					name = self:HyperLink(k,self.OpenListMenu) .. "* " .. HLEnd .. name

					if not skip_dupes[sort] then
						skip_dupes[sort] = true
						c = c + 1
						local str_tmp = name .. " = " .. self:ConvertValueToInfo(obj[k] or v) .. "<left>"
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
				name = self:HyperLink(k,self.OpenListMenu) .. "* " .. HLEnd .. name

				if not skip_dupes[sort] then
					skip_dupes[sort] = true
					c = c + 1
					local str_tmp = name .. " = " .. self:ConvertValueToInfo(v) .. "<left>"
					list_obj_str[c] = str_tmp
					list_sort_obj[str_tmp] = sort
				end
			end
		end

		-- the regular getmetatable will use __metatable if it exists, so we check this as well
		if testing and not blacklist then
			local dbg_metatable = debug.getmetatable(obj)
			if obj_metatable ~= dbg_metatable then
				print("ECM Sezs DIFFERENT METATABLE",self.name)
			end
		end

	elseif obj_type == "function" then
		c = c + 1
		list_obj_str[c] = self:ConvertValueToInfo(tostring(obj))

		local name = DebugGetInfo(obj)
		if name == "[C](-1)" then
			name = RetName(obj)
		end
		c = c + 1
		list_obj_str[c] = self:HyperLink(obj,function()
			OpenInExamineDlg(obj,self)
		end) .. name .. HLEnd
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
	if IsValid(obj) and obj:IsKindOf("CObject") then
		is_valid_obj = true
		local valid_ent = IsValidEntity(obj:GetEntity())

		table_insert(list_obj_str,1,"\t--"
			.. self:HyperLink(obj,function()
				OpenInExamineDlg(getmetatable(obj),self)
			end)
			.. obj.class
			.. HLEnd
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
			else
				path = going_to
			end

			local state = obj:GetState()
			table_insert(list_obj_str, 2, Trans(3722--[[State--]]) .. ": "
				.. GetStateName(state) .. ", step: "
				.. self:HyperLink(obj,function()
					self:AddSphere(obj)
				end)
				.. self:ConvertValueToInfo(obj:GetStepVector(state,0))
				.. HLEnd .. "\n"

				.. (current_pos ~= going_to
						and S[302535920001545--[[Going to %s--]]]:format(self:ConvertValueToInfo(path)) .. "\n"
						or "")
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
			-- some entity details as well
			table_insert(list_obj_str, 2, "GetNumTris(): " .. self:ConvertValueToInfo(obj:GetNumTris())
				.. ", GetNumVertices(): " .. self:ConvertValueToInfo(obj:GetNumVertices()) .. ((parent or state_added) and "" or "\n"))
		end

	end

	-- add strings/numbers to the body
	if obj_type == "number" or obj_type == "boolean" then
		c = c + 1
		list_obj_str[c] = tostring(obj)
	elseif obj_type == "string" then
		if obj == "nil" then
			c = c + 1
			list_obj_str[c] = obj
		else
			c = c + 1
			list_obj_str[c] = "'" .. obj .. "'"
		end

	elseif obj_type == "userdata" then
		local trans_str = Trans(obj)
		-- might as well just return userdata instead of these
		if trans_str == "Missing text" or #trans_str > 16 and trans_str:sub(-16) == " *bad string id?" then
			trans_str = self:ConvertValueToInfo(obj)
			str_not_translated = true
		else
			-- the </color> is to make sure it doesn't bleed into other text
			local _,colour_cnt = trans_str:gsub("<color ","")
			for _ = 1, colour_cnt do
				trans_str = trans_str .. "</color>"
			end
			trans_str = self:ConvertValueToInfo(obj) .. " = '" .. trans_str .. "'"
		end
		c = c + 1
		list_obj_str[c] = trans_str

		-- add any functions from getmeta to the (scant) list
		if obj_metatable then
			self.ConvertObjToInfo_data_meta = self.ConvertObjToInfo_data_meta or {}
			local data_meta = self.ConvertObjToInfo_data_meta
			table_iclear(data_meta)

			local c2 = 0
			for k, v in pairs(obj_metatable) do
				c2 = c2 + 1
				data_meta[c2] = self:ConvertValueToInfo(k) .. " = " .. self:ConvertValueToInfo(v)
			end
			table_sort(data_meta,CmpLower)

			-- add some info for HGE. stuff
			local name = obj_metatable.__name
			if name == "HGE.TaskRequest" then
				table_insert(data_meta,1,"\ngetmetatable():")
				table_insert(data_meta,1,"Unpack(): "
					.. self:HyperLink(obj,function()
						OpenInExamineDlg({obj:Unpack()},self,S[302535920000885--[[Unpacked--]]])
					end)
					.. "table" .. HLEnd
				)
				-- we use this with Object>Flags
				self.obj_flags = obj:GetFlags()
				table_insert(data_meta,1,"GetFlags(): " .. self:ConvertValueToInfo(self.obj_flags))
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
				local minmax = {obj:minmax()}
				if minmax[1] then
					table_insert(data_meta,1,"minmax(): " .. self:ConvertValueToInfo(minmax[1]) .. " "
						.. self:ConvertValueToInfo(minmax[2]))
				end
				table_insert(data_meta,1,"levels(): " .. self:ConvertValueToInfo(obj:levels()))
				table_insert(data_meta,1,"GetPositiveCells(): " .. self:ConvertValueToInfo(obj:GetPositiveCells()))
				table_insert(data_meta,1,"GetBilinear(): " .. self:ConvertValueToInfo(obj:GetBilinear()))
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
				table_insert(data_meta,1,"min(): " .. self:ConvertValueToInfo(obj:min()))
				table_insert(data_meta,1,"max(): " .. self:ConvertValueToInfo(obj:max()))
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
				table_insert(data_meta,1,"size(): " .. self:ConvertValueToInfo(obj:size()))
				table_insert(data_meta,1,"IsValidZ(): " .. self:ConvertValueToInfo(obj:IsValidZ()))
				table_insert(data_meta,1,"\nIsValid(): " .. self:ConvertValueToInfo(obj:IsValid()))
				if center:InBox2D(ChoGGi.ComFuncs.ConstructableArea()) then
					table_insert(data_meta,1,self:HyperLink(obj,self.ToggleBBox,S[302535920001550--[[Toggle viewing BBox.--]]]) .. S[302535920001549--[[View BBox--]]] .. HLEnd)
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
						table_insert(data_meta,1,S[302535920001500--[[userdata object probably needs UICity to translate.--]]])
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
			list_obj_str[c] = "\ngetinfo(): " .. DebugGetInfo(obj)
		else
			c = c + 1
			list_obj_str[c] = "\n"

			local info = debug_getinfo(obj,"Su")

			-- link to source code
			if info.what == "Lua" then
				c = c + 1
				list_obj_str[c] = self:HyperLink(obj,self.ViewSourceCode,S[302535920001520--[["Opens source code (if it exists):
Mod code works, as well as HG github code. HG code needs to be placed at ""%sSource""
Example: ""Source/Lua/_const.lua""

Decompiled code won't scroll correctly as the line numbers are different."--]]]:format(ConvertToOSPath("AppData/")))
					.. S[302535920001519--[[View Source--]]] .. HLEnd
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
			.. S[302535920001353--[[Thread info--]]]
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

		local info_list = RetThreadInfo(obj)
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
				OpenInExamineDlg(self.enum_vars,self,S[302535920001442--[[Enum--]]])
			end)
			.. " enum"
			.. HLEnd
		end

	end

	return TableConcat(list_obj_str,"\n")
end
---------------------------------------------------------------------------------------------------------------------
function Examine:SetToolbarVis(obj)
	-- always hide all
	self.idButMarkObject:SetVisible()
	self.idButMarkAll:SetVisible()
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
			if PropObjGetProperty(obj,"delete") and obj.delete then
				self.idButDeleteObj:SetVisible(true)
			end

			if IsValid(obj) then
				self.idObjects:SetVisible(true)
				-- can't mark if it isn't an object, and no sense in marking something off the map
				if obj:GetPos() ~= InvalidPos then
					self.idButMarkObject:SetVisible(true)
				end
			end

			-- objlist objects let us do some easy for each
			if IsObjlist(obj) then
				self.idButMarkAll:SetVisible(true)
				self.idButDeleteAll:SetVisible(true)
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

function Examine:BuildParents(list,list_type,title,sort_type)
	if list and next(list) then
		list = RetSortTextAssTable(list,sort_type)
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
					hint = S[302535920000069--[[Examine--]]] .. " " .. Trans(3696--[[Class--]]) .. " " .. Trans(298035641454--[[Object--]]) .. ": " .. item,
					clicked = function()
						OpenInExamineDlg(g_Classes[item],self)
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
		local obj_ref = DotNameToObject(obj)
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

	self:SetToolbarVis(obj)

	self.idText:SetText(Trans(67--[[Loading resources--]]))

	if obj_type == "table" then
		obj_class = g_Classes[obj.class]
		if getmetatable(obj) then
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
			self:BuildParents(obj.__parents,"parents",S[302535920000520--[[Parents--]]])
			self:BuildParents(obj.__ancestors,"ancestors",S[302535920000525--[[Ancestors--]]],true)
			-- if anything was added to the list then add to the menu
			if #self.parents_menu_popup > 0 then
				self.idParents:SetVisible(true)
			end
		end

		-- attaches button/menu
		table_iclear(self.attaches_menu_popup)
		local attaches = GetAllAttaches(obj,true)
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
				hint = Trans(3746--[[Class name--]]) .. ": " .. a.class
					.. (a_to and "\n" .. S[302535920001544--[[Attached to: %s--]]]:format(a_to) or "")
					.. "\n".. S[302535920000955--[[Handle--]]] .. ": " .. (a.handle or Trans(6761--[[None--]]))
					.. "\n" .. S[302535920001237--[[Position--]]] .. ": " .. tostring(pos),
				showobj = a,
				clicked = function()
					ClearShowObj(a)
					OpenInExamineDlg(a,self)
				end,
			}

		end

		if attach_amount > 0 then
			table_sort(self.attaches_menu_popup, function(a, b)
				return CmpLower(a.name, b.name)
			end)

			self.idAttaches:SetVisible(true)
			self.idAttaches.RolloverText = S[302535920000070--[["Shows list of attachments. This %s has %s.
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

	-- for bigger lists like _G or MapGet(true): we add a slight delay, so the dialog shows up (progress is happening user)
		if startup or self.is_chinese then
			CreateRealTimeThread(function()
--~ ChoGGi.ComFuncs.TickStart("Examine")
				WaitMsg("OnRender")
				self.idText:SetText(self:ConvertObjToInfo(obj,obj_type))
--~ ChoGGi.ComFuncs.TickEnd("Examine",self.name)
			end)
		else
			-- we normally don't want it in a thread with OnRender else it'll mess up my scroll pos (and stuff)
			self.idText:SetText(self:ConvertObjToInfo(obj,obj_type))
		end

	-- comments are good for stuff like this
	return obj_class
end
-- for external use
Examine.UpdateObj = Examine.SetObj

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
	if IsValid(obj) then
		ChoGGi.ComFuncs.BBoxLines_Clear(obj)
		ChoGGi.ComFuncs.ObjHexShape_Clear(obj)
		ChoGGi.ComFuncs.AttachSpots_Clear(obj)
		ChoGGi.ComFuncs.SurfaceLines_Clear(obj)
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
