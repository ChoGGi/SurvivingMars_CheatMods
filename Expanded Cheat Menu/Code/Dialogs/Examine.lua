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
local TableClear = table.clear
local TableIClear = table.iclear
local TableInsert = table.insert
local TableSort = table.sort
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

local getinfo,getupvalue,getlocal
local debug = PropObjGetProperty(_G,"debug")
if debug then
	getupvalue = debug.getupvalue
	getinfo = debug.getinfo
	getlocal = debug.getlocal
end

local HLEnd = "</h></color>"

local DebugGetInfo
local DeleteObject
local DotNameToObject
local GetParentOfKind
local IsControlPressed
local OpenInExamineDlg
local PopupToggle
local Random
local RetName
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
	DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	DeleteObject = ChoGGi.ComFuncs.DeleteObject
	DotNameToObject = ChoGGi.ComFuncs.DotNameToObject
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
	IsControlPressed = ChoGGi.ComFuncs.IsControlPressed
	OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
	PopupToggle = ChoGGi.ComFuncs.PopupToggle
	Random = ChoGGi.ComFuncs.Random
	RetName = ChoGGi.ComFuncs.RetName
	RetThreadInfo = ChoGGi.ComFuncs.RetThreadInfo
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
	sort = false,
	-- if TaskRequest then store flags here
	obj_flags = false,
	-- delay between updating for autoref
	autorefresh_delay = 1000,

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
	onclick_objs = false,
	onclick_count = false,

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
	self.onclick_objs = {}
	self.onclick_count = 0

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
			RolloverTitle = S[1000220--[[Refresh--]]],
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
			RolloverTitle = S[594--[[Clear--]]],
			RolloverText = S[302535920000016--[[Remove any green spheres/reset green coloured objects.--]]],
			OnPress = ChoGGi.ComFuncs.ClearShowObj,
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
			RolloverTitle = S[697--[[Destroy--]]],
			RolloverText = S[302535920000414--[[Are you sure you wish to delete it?--]]],
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
			RolloverTitle = S[3768--[[Destroy all?--]]],
			RolloverText = S[302535920000059--[[Destroy all objects in objlist!--]]],
			OnPress = self.idButDeleteAllOnPress,
		}, self.idToolbarButtons)
		--
		self.idButViewSource = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButViewSource",
			Image = "CommonAssets/UI/Menu/SelectByClass.tga",
			RolloverTitle = S[302535920001519--[[View Source--]]],
			RolloverText = S[302535920001520--[["Opens source code (if it exists):
Mod source works fine, as well as HG github code. HG code needs to be placed at ""%sSource""
Example: ""Source/Lua/_const.lua""

Decompiled code won't scroll correctly as the line numbers are different.
Needs HelperMod enabled."--]]]:format(ConvertToOSPath("AppData/")),
			OnPress = self.idButViewSourceOnPress,
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
			Text = S[10124--[[Sort--]]],
			RolloverText = S[302535920001248--[[Sort normally or backwards.--]]],
			OnChange = self.idSortDirOnChange,
			Init = self.CheckButtonInit,
		}, self.idToolbarArea)
		--
		self.idShowAllValues = g_Classes.ChoGGi_CheckButton:new({
			Id = "idShowAllValues",
			Dock = "right",
			MinWidth = 0,
			Text = S[4493--[[All--]]],
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
			Text = S[10123--[[Search--]]],
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
			Text = S[298035641454--[[Object--]]],
			RolloverText = S[302535920001530--[[Various object tools to use.--]]],
			OnMouseButtonDown = self.idObjectsOnMouseButtonDown,
			Dock = "left",
		}, self.idMenuArea)
		--
		self.idParents = g_Classes.ChoGGi_ComboButton:new({
			Id = "idParents",
			Text = S[302535920000520--[[Parents--]]],
			RolloverText = S[302535920000553--[[Examine parent and ancestor objects.--]]],
			OnMouseButtonDown = self.idParentsOnMouseButtonDown,
			Dock = "left",
		}, self.idMenuArea)
		self.idParents:SetVisible(false)
		--
		self.idAttaches = g_Classes.ChoGGi_ComboButton:new({
			Id = "idAttaches",
			Text = S[302535920000053--[[Attaches--]]],
			RolloverText = S[302535920000054--[[Any objects attached to this object.--]]],
			OnMouseButtonDown = self.idAttachesOnMouseButtonDown,
			Dock = "left",
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

--~ function Examine:idTextOnHyperLinkRollover(link, hyperlink_box, pos)
function Examine:idTextOnHyperLinkRollover(link)
	if not ChoGGi.UserSettings.EnableToolTips then
		return
	end
	if not link then
		-- close opened tooltip
		if RolloverWin then
			XDestroyRolloverWindow()
		end
		return
	end
	self = GetRootDialog(self)

	link = tonumber(link)
	local obj = self.onclick_objs[link]
	if not obj then
		return
	end

	XCreateRolloverWindow(self.idDialog, RolloverGamepad, true, {
		RolloverTitle = S[302535920000069--[[Examine--]]],
		RolloverText = RetName(obj),
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
function Examine:HyperLink(obj, func)
	local c = self.onclick_count
	c = c + 1

	self.onclick_count = c
	self.onclick_objs[c] = obj
	self.onclick_funcs[c] = func

	return "<color 150 170 250><h " .. c .. " 230 195 50>"
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

function Examine:idToggleExecCodeOnChange()
--~ 	-- if it's called directly we set the check if needed
--~ 	local checked = self:GetCheck()

	self = GetRootDialog(self)
	local vis = self.idExecCodeArea:GetVisible()
	self.idExecCodeArea:SetVisible(not vis)
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

function Examine:idButMarkObjectOnPress()
	self = GetRootDialog(self)
	if IsValid(self.obj_ref) then
		ShowObj(self.obj_ref)
	else
		for k, v in pairs(self.obj_ref) do
			ShowObj(k)
			ShowObj(v)
		end
	end
end

function Examine:idButDeleteObjOnPress()
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000414--[[Are you sure you wish to delete it?--]]],
		function(answer)
			if answer then
				self = GetRootDialog(self)

				-- map objects
				if IsValidThread(self.obj_ref) then
					DeleteThread(self.obj_ref)
				elseif IsValid(self.obj_ref) then
					DeleteObject(self.obj_ref)
				-- xwindows
				elseif self.obj_ref.Close then
					self.obj_ref:Close()
				-- whatever
				else
					self.obj_ref:delete()
				end

			end
		end,
		S[697--[[Destroy--]]]
	)
end

function Examine:idButViewSourceOnPress()
	self = GetRootDialog(self)
	-- add link to view lua source
	local info = getinfo(self.obj_ref,"S")
	-- =[C] is 4 chars
	local str,path = ChoGGi.ComFuncs.RetSourceFile(info.source)
	if not str then
		ChoGGi.ComFuncs.MsgPopup(
			302535920001521--[[Lua source file not found.--]] .. ": " .. ConvertToOSPath(path),
			302535920001519--[[View Source--]]
		)
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

function Examine:idButDeleteAllOnPress()
	self = GetRootDialog(self)
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000059--[[Destroy all objects in objlist!--]]],
		function(answer)
			if answer then
				SuspendPassEdits("DestroyAllInObjlist")
				for _,obj in pairs(self.obj_ref) do
					if IsValid(obj) then
						DeleteObject(obj)
					elseif obj.delete then
						obj:delete()
					end
				end
				ResumePassEdits("DestroyAllInObjlist")
				-- force a refresh on the list, so people can see something as well
				self:SetObj()
			end
		end,
		S[697--[[Destroy--]]]
	)
end
function Examine:idViewEnumOnChange()
	self = GetRootDialog(self)
	self.show_enum_values = not self.show_enum_values
	self:SetObj()
end

function Examine:idButMarkAllOnPress()
	self = GetRootDialog(self)
	for _, v in pairs(self.obj_ref) do
		if IsPoint(v) or IsValid(v) then
			ShowObj(v, nil, nil, true)
		end
	end
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
	self.sort = not self.sort
	self:SetObj()
end

function Examine:idShowAllValuesOnChange()
	self = GetRootDialog(self)
	self.show_all_values = not self.show_all_values
	self:SetObj()
end

--~ function Examine:idSearchTextOnTextChanged()
--~ 	GetRootDialog(self):FindNext()
--~ end

local function CallMenu(self,popup_id,items,pt,button,...)
	ChoGGi_ComboButton.OnMouseButtonDown(self,pt,button,...)
	if button == "L" then
		local dlg = GetRootDialog(self)
		-- same colour as bg of icons :)
		dlg[items].Background = -9868951
		dlg[items].FocusedBackground = -9868951
		dlg[items].PressedBackground = -12500671
		dlg[items].TextStyle = "ChoGGi_CheckButtonMenuOpp"
		PopupToggle(self,dlg[popup_id],dlg[items],"bottom")
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

function Examine:BuildObjectMenuPopup()
	return {
		{name = S[302535920000457--[[Anim State Set--]]],
			hint = S[302535920000458--[[Make object dance on command.--]]],
			image = "CommonAssets/UI/Menu/UnlockCamera.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					ChoGGi.ComFuncs.SetAnimState(self.obj_ref)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920000682--[[Change Entity--]]],
			hint = S[302535920001151--[[Set Entity For %s--]]]:format(self.name),
			image = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					ChoGGi.ComFuncs.EntitySpawner(self.obj_ref,true,7)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920000129--[[Set--]]] .. " " .. S[302535920001184--[[Particles--]]],
			hint = S[302535920001421--[[Shows a list of particles you can use on the selected obj.--]]],
			image = "CommonAssets/UI/Menu/place_particles.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					ChoGGi.ComFuncs.SetParticles(self.obj_ref)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = "----",disable = true,centred = true},
		{name = S[302535920001472--[[BBox Toggle--]]],
			hint = S[302535920001473--[[Toggle showing object's bbox (changes depending on movement).--]]],
			image = "CommonAssets/UI/Menu/SelectionEditor.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					self:ShowBBoxList()
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920001522--[[Hex Shape Toggle--]]],
			hint = S[302535920001523--[[Toggle showing shapes for the object.--]]],
			image = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					self:ShowHexShapeList()
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920000449--[[Attach Spots Toggle--]]],
			hint = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
			image = "CommonAssets/UI/Menu/ShowAll.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					ChoGGi.ComFuncs.AttachSpots_Toggle(self.obj_ref)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920000235--[[Attach Spots List--]]],
			hint = S[302535920001445--[[Shows list of attaches for use with .ent files.--]]],
			image = "CommonAssets/UI/Menu/ListCollections.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					ChoGGi.ComFuncs.ExamineEntSpots(self.obj_ref,self)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920001458--[[Material Properties--]]],
			hint = S[302535920001459--[[Shows list of material settings/.dds files for use with .mtl files.--]]],
			image = "CommonAssets/UI/Menu/ConvertEnvironment.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					ChoGGi.ComFuncs.GetMaterialProperties(self.obj_ref:GetEntity(),self)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920001476--[[Flags--]]],
			hint = S[302535920001447--[[Shows list of flags set for selected object.--]]],
			image = "CommonAssets/UI/Menu/JoinGame.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					-- task requests have flags too, ones that aren't listed in the Flags table... (just const.rf*)
					if self.obj_flags then
						ChoGGi.ComFuncs.ObjFlagsList_TR(self.obj_ref,self)
					else
						ChoGGi.ComFuncs.ObjFlagsList(self.obj_ref,self)
					end
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920001524--[[Entity Surfaces--]]],
			hint = S[302535920001525--[[Shows list of surfaces for the object entity.--]]],
			image = "CommonAssets/UI/Menu/ToggleOcclusion.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					OpenInExamineDlg(
						ChoGGi.ComFuncs.RetSurfaceMasks(self.obj_ref),self,
						S[302535920001524--[[Entity Surfaces--]]] .. ": " .. self.name
					)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920000459--[[Anim Debug Toggle--]]],
			hint = S[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
			image = "CommonAssets/UI/Menu/CameraEditor.tga",
			clicked = function()
				if IsValid(self.obj_ref) then
					ChoGGi.ComFuncs.ShowAnimDebug_Toggle(self.obj_ref)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[931--[[Modified property--]]],
			hint = S[302535920001384--[[Get properties different from base/parent object?--]]],
			image = "CommonAssets/UI/Menu/SelectByClass.tga",
			clicked = function()
				if self.obj_ref.IsKindOf and self.obj_ref:IsKindOf("PropertyObject") then
					OpenInExamineDlg(
						GetModifiedProperties(self.obj_ref),
						self,
						S[931--[[Modified property--]]] .. ": " .. self.name
					)
				else
					self:InvalidMsgPopup()
				end
			end,
		},
		{name = S[302535920001389--[[All Properties--]]],
			hint = S[302535920001390--[[Get all properties.--]]],
			image = "CommonAssets/UI/Menu/AreaProperties.tga",
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
		{name = "----",disable = true,centred = true},
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
		{name = S[302535920000004--[[Dump--]]] .. " " .. S[1000145--[[Text--]]],
			hint = S[302535920000046--[[dumps text to %slogs\DumpedExamine.lua--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_down.tga",
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags (any </*> closing tags, <left>, <color *>, <h *>)
				str = str:gsub("</[%s%a%d]*>",""):gsub("<left>",""):gsub("<color [%s%a%d]*>",""):gsub("<h [%s%a%d]*>","")
				-- i just compare, so append doesn't really work
				if ChoGGi.UserSettings.ExamineAppendDump then
					ChoGGi.ComFuncs.Dump("\n" .. str,nil,"DumpedExamine","lua")
				else
					ChoGGi.ComFuncs.Dump(str,"w","DumpedExamine","lua",nil,true)
				end
			end,
		},
		{name = S[302535920000004--[[Dump--]]] .. " " .. S[298035641454--[[Object--]]],
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
		{name = S[302535920000048--[[View--]]] .. " " .. S[1000145--[[Text--]]],
			hint = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
			image = "CommonAssets/UI/Menu/change_height_up.tga",
			clicked = function()
				local str = self.idText:GetText()
				-- remove html tags (any </*> closing tags, <left>, <color *>, <h *>)
				str = str:gsub("</[%s%a%d]*>",""):gsub("<left>",""):gsub("<color [%s%a%d]*>",""):gsub("<h [%s%a%d]*>","")
				ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
					parent = self,
					checkbox = true,
					text = str,
					scrollto = self:GetScrolledText(),
					title = S[302535920000048--[[View--]]] .. "/" .. S[302535920000004--[[Dump--]]] .. S[1000145--[[Text--]]],
					hint_ok = S[302535920000047--[["View text, and optionally dumps text to %sDumpedExamine.lua (don't use this option on large text)."--]]]:format(ConvertToOSPath("AppData/")),
					custom_func = function(answer,overwrite)
						if answer then
							ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedExamine","lua")
						end
					end,
				}
			end,
		},
		{name = S[302535920000048--[[View--]]] .. " " .. S[298035641454--[[Object--]]],
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
						title = S[302535920000048--[[View--]]] .. "/" .. S[302535920000004--[[Dump--]]] .. S[298035641454--[[Object--]]],
						hint_ok = 302535920000049--[["View text, and optionally dumps object to AppData/DumpedExamineObject.lua

This can take time on something like the ""Building"" metatable (don't use this option on large text)"--]],
						custom_func = function(answer,overwrite)
							if answer then
								ChoGGi.ComFuncs.Dump("\n" .. str,overwrite,"DumpedExamineObject","lua")
							end
						end,
					}
				end
			end,
		},
		{name = "----",disable = true,centred = true},
		{name = S[302535920001239--[[Functions--]]],
			hint = S[302535920001240--[[Show all functions of this object and parents/ancestors.--]]],
			image = "CommonAssets/UI/Menu/gear.tga",
			clicked = function()
				if #self.parents > 0 or #self.ancestors > 0 then
					TableClear(self.menu_added)
					TableClear(self.menu_list_items)

					if #self.parents > 0 then
						self:ProcessList(self.parents," " .. S[302535920000520--[[Parents--]]] .. ": ")
					end
					if #self.ancestors > 0 then
						self:ProcessList(self.parents," " .. S[302535920000525--[[Ancestors--]]] .. ": ")
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
					-- close enough
					print(S[9763--[[No objects matching current filters.--]]])
				end
			end,
		},
		{name = S[327465361219--[[Edit--]]] .. " " .. S[298035641454--[[Object--]]],
			hint = S[302535920000050--[[Opens object in Object Manipulator.--]]],
			image = "CommonAssets/UI/Menu/AreaProperties.tga",
			clicked = function()
				ChoGGi.ComFuncs.OpenInObjectEditorDlg(self.obj_ref,self)
			end,
		},
		{name = S[174--[[Color Modifier--]]],
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
						302535920001471--[[No images found.--]],
						302535920001469--[[Image Viewer--]]
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
			hint = S[302535920000052--[["Execute code (using console for output). ChoGGi.CurObj is whatever object is opened in examiner.
Which you can then mess around with some more in the console."--]]],
			image = "CommonAssets/UI/Menu/AlignSel.tga",
			clicked = function()
				ChoGGi.ComFuncs.OpenInExecCodeDlg(self.obj_ref,self)
			end,
		},
		{name = "----",disable = true,centred = true},
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
		local name = S[327465361219--[[Edit--]]] .. " " .. S[298035641454--[[Object--]]] .. " " .. S[302535920001432--[[3D--]]]
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

function Examine:InvalidMsgPopup(msg,title)
	ChoGGi.ComFuncs.MsgPopup(
		msg or 302535920001526--[[Not a valid object--]],
		title or 302535920000069--[[Examine--]]
	)
end

function Examine:GetScrolledText()
	-- all text is cached here
	local cache = self.idText.draw_cache or {}
	local list_draw_info = cache[self.idScrollArea.PendingOffsetY or 0]

	-- we need to be at an exact line (draw_cache expects it)
	if not list_draw_info then
		-- send "" or it'll try to get the search text
		self:FindNext("")
		list_draw_info = cache[self.idScrollArea.PendingOffsetY or 0]
	end

	local text = {}
	local c = 0
	if list_draw_info then
		for i = 1, #list_draw_info do
			local temp = list_draw_info[i].text
			if temp then
				c = c + 1
				text[c] = temp
			end
		end
	end
	return TableConcat(text)
end

function Examine:FindNext(text,previous)
	text = text or self.idSearchText:GetText():lower()
	local current_y = self.idScrollArea.OffsetY
	local min_match, closest_match = false, false

	local cache = self.idText.draw_cache or {}
	for y, list_draw_info in pairs(cache) do
		for i = 1, #list_draw_info do
			local draw_info = list_draw_info[i]
			if draw_info.text and draw_info.text:find_lower(text) or text == "" then
				if not min_match or y < min_match then
					min_match = y
				end

				if previous then
					if y < current_y and (not closest_match or y > closest_match) then
						closest_match = y
					end
				else
					if y > current_y and (not closest_match or y < closest_match) then
						closest_match = y
					end
				end

			end
		end
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
	self.hex_shape_funcs = self.hex_shape_funcs or {
		"GetEntityBuildShape",
		"GetEntityCombinedShape",
		"GetEntityInteriorShape",
		"GetEntityInverseBuildShape",
		"GetEntityOutlineShape",
		"GetEntityPeripheralHexShape",
	}

	ChoGGi.ComFuncs.ObjHexShape_Clear(self.obj_ref)

	local ItemList = {{
		text = S[594--[[Clear--]]],
		value = "Clear",
	}}
	local c = 1

	local g = _G
	local fall = g.FallbackOutline
	local entity = self.obj_ref:GetEntity()

	for i = 1, #self.hex_shape_funcs do
		local func = self.hex_shape_funcs[i]
		local shape = g[func](entity)
		if shape ~= fall and #shape > 2 then
			c = c + 1
			ItemList[c] = {
				text = func:sub(10),
				shape = shape,
			}
		end
	end

	local all_states = g.GetStates(entity)
	for i = 1, #all_states do
		local state_idx = g.GetStateIdx(all_states[i])

		local EntitySurfaces = g.EntitySurfaces
		for key,value in pairs(EntitySurfaces) do
			local shape = g.GetSurfaceHexShapes(entity, state_idx, value) or ""
			if shape ~= fall and #shape > 2 then
				c = c + 1
				ItemList[c] = {
					text = "GetSurfaceHexShapes(), mask: " .. key .. " state_idx:" .. state_idx,
					value = "GetSurfaceHexShapes",
					shape = shape,
				}
			end
		end
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]
		if choice.value == "Clear" then
			ChoGGi.ComFuncs.ObjHexShape_Clear(self.obj_ref)
		else
			ChoGGi.ComFuncs.ObjHexShape_Toggle(self.obj_ref,{
				shape = choice.shape,
				func = choice.func,
				skip_return = true,
			})
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = ItemList,
		title = S[302535920001522--[[Hex Shape Toggle--]]] .. ": " .. RetName(self.obj_ref),
		skip_sort = true,
		custom_type = 7,
	}
end

function Examine:ShowBBoxList()
-- might be useful?
--~ ToBBox(pos, prefab.size, angle)

	ChoGGi.ComFuncs.BBoxLines_Clear(self.obj_ref)

	local ItemList = {
		{text = S[594--[[Clear--]]],value = "Clear"},
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
			ChoGGi.ComFuncs.BBoxLines_Clear(self.obj_ref)
		else
			ChoGGi.ComFuncs.BBoxLines_Toggle(self.obj_ref,{
				func = choice.value,
				args = choice.args,
				skip_return = true,
			})
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = ItemList,
		title = S[302535920001472--[[BBox Toggle--]]] .. ": " .. RetName(self.obj_ref),
		hint = 302535920000264--[[Defaults to :GetObjectBBox() if it can't find a func.--]],
		skip_sort = true,
		custom_type = 7,
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
		ShowObj(obj)
	else
		OpenInExamineDlg(obj,self)
	end
end
local function Examine_ConvertValueToInfo(self,button,obj)
	-- not ingame = no sense in using ShowObj
	if button == "L" then
		OpenInExamineDlg(obj,self)
	else
		ShowObj(obj)
	end
end

function Examine:ConvertValueToInfo(obj,left)
	local obj_type = type(obj)

	if obj_type == "string" then
		-- some translated stuff has <color in it, so we make sure they don't colour the rest
		local _,colour_cnt = obj:gsub("<color ","")
		for _ = 1, colour_cnt do
			obj = obj .. "</color>"
		end
		return "'<color " .. ChoGGi.UserSettings.ExamineColourStr .. ">" .. obj .. "</color>'"
	end
	if obj_type == "number" then
		-- for some reason i don't want the indexed table numbers to be coloured.
		if left then
			return obj .. ""
		else
			return "<color " .. ChoGGi.UserSettings.ExamineColourNum .. ">" .. obj .. "</color>"
		end
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
			local ret_str = trans_str .. self:HyperLink(obj,Examine_ConvertValueToInfo) .. " *"

			-- if meta name then add it
			if meta and meta.__name then
				ret_str = ret_str .. "userdata (" .. meta.__name .. ")"
			else
				ret_str = ret_str .. tostring(obj)
			end

			return ret_str .. HLEnd
		end
	end
	--
	if obj_type == "function" then
		return self:HyperLink(obj,Examine_ConvertValueToInfo)
			.. DebugGetInfo(obj) .. HLEnd
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
		local name, value = getupvalue(obj, i)
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
	local info = getinfo(obj,"Slfunt")
	for key,value in pairs(info) do
		c = c + 1
		temp[c] = key .. ": " .. self:ConvertValueToInfo(value)
	end
	-- since pairs doesn't have an order we need a sort
	TableSort(temp)

	TableInsert(temp,1,"\ngetinfo(): ")
	return TableConcat(temp,"\n")
end
function Examine:RetFuncParams(obj)
	self.RetDebugInfo_table = self.RetDebugInfo_table or objlist:new()
	local temp = self.RetDebugInfo_table
	temp:Destroy()

	local info = getinfo(obj,"u")
	if info.nparams > 0 then
		for i = 1, info.nparams do
			temp[i] = getlocal(obj, i)
		end

		TableInsert(temp,1,"\nparams: ")
		local args = TableConcat(temp,", ")

		-- remove extra , from concat and add ... if it has a vararg
		return args:gsub(": , ",": (") .. (info.isvararg and ", ...)" or ")")
	end
end

function Examine:ConvertObjToInfo(obj,obj_type)
	-- i like reusing tables
	self.ConvertObjToInfo_totextex_res = self.ConvertObjToInfo_totextex_res or {}
	self.ConvertObjToInfo_totextex_sort = self.ConvertObjToInfo_totextex_sort or {}
	self.ConvertObjToInfo_totextex_dupes = self.ConvertObjToInfo_totextex_dupes or {}
	local totextex_res = self.ConvertObjToInfo_totextex_res
	local totextex_sort = self.ConvertObjToInfo_totextex_sort
	local totextex_dupes = self.ConvertObjToInfo_totextex_dupes
	TableIClear(totextex_res)
	TableClear(totextex_sort)
	TableClear(totextex_dupes)

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

		for k,v in pairs(obj) do
			-- sorely needed delay for chinese (or it "freezes" the game when loading something like _G)
			if self.is_chinese then
				Sleep(1)
			end

			local name = self:ConvertValueToInfo(k,true)
			-- gotta store all the names if we're doing all props (no dupes thanks)
			totextex_dupes[name] = true
			c = c + 1
			totextex_res[c] = name .. " = " .. self:ConvertValueToInfo(v) .. "<left>"
			if type(k) == "number" then
				totextex_sort[totextex_res[c]] = k
			end
		end

		-- pretty rare occurrence
		if self.show_enum_values and self.enum_vars then
			for k,v in pairs(self.enum_vars) do
				-- remove the . at the start
				local name = self:ConvertValueToInfo(k:sub(2),true)
				if not totextex_dupes[name] then
					totextex_dupes[name] = true
					c = c + 1
					totextex_res[c] = name .. " = " .. self:ConvertValueToInfo(v) .. "<left>"
				end
			end
		end

		-- keep looping through metatables till we run out
		if obj_metatable and self.show_all_values then
			local meta_temp = obj_metatable
			while meta_temp do
				for k,v in pairs(meta_temp) do
					local name = self:ConvertValueToInfo(k,true)
					if not totextex_dupes[name] then
						totextex_dupes[name] = true
						c = c + 1
						totextex_res[c] = name .. " = " .. self:ConvertValueToInfo(obj[k] or v) .. "<left>"
					end

				end
				meta_temp = getmetatable(meta_temp)
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
		totextex_res[c] = self:ConvertValueToInfo(tostring(obj))
		c = c + 1
		totextex_res[c] = self:ConvertValueToInfo(obj)
	end

	-- sort backwards
	if self.sort then
		TableSort(totextex_res, function(a, b)
			if totextex_sort[a] and totextex_sort[b] then
				return totextex_sort[a] > totextex_sort[b]
			end
			if totextex_sort[a] or totextex_sort[b] then
				return totextex_sort[b] and true
			end
			return CmpLower(b, a)
		end)
	-- sort normally
	else
		TableSort(totextex_res, function(a, b)
			if totextex_sort[a] and totextex_sort[b] then
				return totextex_sort[a] < totextex_sort[b]
			end
			if totextex_sort[a] or totextex_sort[b] then
				return totextex_sort[a] and true
			end
			return CmpLower(a, b)
		end)
	end

	-- cobjects, not property objs? (IsKindOf)
	if IsValid(obj) and obj:IsKindOf("CObject") then
		is_valid_obj = true

		TableInsert(totextex_res,1,"\t--"
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
				TableInsert(totextex_res,2,"obj:GetParticlesName(): '" .. par_name .. "'\n")
			end
		end

		if obj:IsValidPos() and IsValidEntity(obj:GetEntity()) and 0 < obj:GetAnimDuration() then
			local pos = obj:GetVisualPos() + obj:GetStepVector() * obj:TimeToAnimEnd() / obj:GetAnimDuration()
			TableInsert(totextex_res, 2,
				GetStateName(obj:GetState())
				.. ", step: "
				.. self:HyperLink(obj,function()
					ShowObj(pos)
				end)
				.. self:ConvertValueToInfo(obj:GetStepVector(obj:GetState(),0))
				.. HLEnd
			)
		end
	end

	-- add strings/numbers to the body
	if obj_type == "number" or obj_type == "boolean" then
		c = c + 1
		totextex_res[c] = tostring(obj)
	elseif obj_type == "string" then
		if obj == "nil" then
			c = c + 1
			totextex_res[c] = obj
		else
			c = c + 1
			totextex_res[c] = "'" .. obj .. "'"
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
		totextex_res[c] = trans_str

		-- add any functions from getmeta to the (scant) list
		if obj_metatable then
			self.ConvertObjToInfo_data_meta = self.ConvertObjToInfo_data_meta or {}
			local data_meta = self.ConvertObjToInfo_data_meta
			TableIClear(data_meta)

			local c2 = 0
			for k, v in pairs(obj_metatable) do
				c2 = c2 + 1
				data_meta[c2] = self:ConvertValueToInfo(k) .. " = " .. self:ConvertValueToInfo(v)
			end
			TableSort(data_meta, function(a, b)
				return CmpLower(a, b)
			end)

			-- add some info for HGE. stuff
			local name = obj_metatable.__name
			if name == "HGE.TaskRequest" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,"Unpack(): "
					.. self:HyperLink(obj,function()
						OpenInExamineDlg({obj:Unpack()},self)
					end)
					.. "table" .. HLEnd
				)
				-- we use this with Object>Flags
				self.obj_flags = obj:GetFlags()
				TableInsert(data_meta,1,"GetFlags(): " .. self:ConvertValueToInfo(self.obj_flags))
				TableInsert(data_meta,1,"GetReciprocalRequest(): " .. self:ConvertValueToInfo(obj:GetReciprocalRequest()))
				TableInsert(data_meta,1,"GetLastServiced(): " .. self:ConvertValueToInfo(obj:GetLastServiced()))
				TableInsert(data_meta,1,"GetFreeUnitSlots(): " .. self:ConvertValueToInfo(obj:GetFreeUnitSlots()))
				TableInsert(data_meta,1,"GetFillIndex(): " .. self:ConvertValueToInfo(obj:GetFillIndex()))
				TableInsert(data_meta,1,"GetTargetAmount(): " .. self:ConvertValueToInfo(obj:GetTargetAmount()))
				TableInsert(data_meta,1,"GetDesiredAmount(): " .. self:ConvertValueToInfo(obj:GetDesiredAmount()))
				TableInsert(data_meta,1,"GetActualAmount(): " .. self:ConvertValueToInfo(obj:GetActualAmount()))
				TableInsert(data_meta,1,"GetWorkingUnits(): " .. self:ConvertValueToInfo(obj:GetWorkingUnits()))
				TableInsert(data_meta,1,"GetResource(): " .. self:ConvertValueToInfo(obj:GetResource()))
				TableInsert(data_meta,1,"\nGetBuilding(): " .. self:ConvertValueToInfo(obj:GetBuilding()))
			elseif name == "HGE.Grid" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,"get_default(): " .. self:ConvertValueToInfo(obj:get_default()))
				TableInsert(data_meta,1,"max_value(): " .. self:ConvertValueToInfo(obj:max_value()))
				local size = {obj:size()}
				if size[1] then
					TableInsert(data_meta,1,"\nsize(): " .. self:ConvertValueToInfo(size[1])
						.. " " .. self:ConvertValueToInfo(size[2]))
				end
			elseif name == "HGE.XMGrid" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				local minmax = {obj:minmax()}
				if minmax[1] then
					TableInsert(data_meta,1,"minmax(): " .. self:ConvertValueToInfo(minmax[1]) .. " "
						.. self:ConvertValueToInfo(minmax[2]))
				end
				TableInsert(data_meta,1,"levels(): " .. self:ConvertValueToInfo(obj:levels()))
				TableInsert(data_meta,1,"GetPositiveCells(): " .. self:ConvertValueToInfo(obj:GetPositiveCells()))
				TableInsert(data_meta,1,"GetBilinear(): " .. self:ConvertValueToInfo(obj:GetBilinear()))
				TableInsert(data_meta,1,"EnumZones(): " .. self:ConvertValueToInfo(obj:EnumZones()))
				TableInsert(data_meta,1,"size(): " .. self:ConvertValueToInfo(obj:size()))
				TableInsert(data_meta,1,"packing(): " .. self:ConvertValueToInfo(obj:packing()))
				-- crashing tendencies
--~ 				TableInsert(data_meta,1,"histogram(): " .. self:ConvertValueToInfo({obj:histogram()}))
				-- freeze screen with render error in log ex(Flight_Height:GetBinData())
				TableInsert(data_meta,1,"\nCenterOfMass(): " .. self:ConvertValueToInfo(obj:CenterOfMass()))
			elseif name == "HGE.Box" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				local points2d = {obj:ToPoints2D()}
				if points2d[1] then
					TableInsert(data_meta,1,"ToPoints2D(): " .. self:ConvertValueToInfo(points2d[1])
						.. " " .. self:ConvertValueToInfo(points2d[2])
						.. "\n" .. self:ConvertValueToInfo(points2d[3])
						.. " " .. self:ConvertValueToInfo(points2d[4])
					)
				end
				TableInsert(data_meta,1,"min(): " .. self:ConvertValueToInfo(obj:min()))
				TableInsert(data_meta,1,"max(): " .. self:ConvertValueToInfo(obj:max()))
				local bsphere = {obj:GetBSphere()}
				if bsphere[1] then
					TableInsert(data_meta,1,"GetBSphere(): "
						.. self:ConvertValueToInfo(bsphere[1]) .. " "
						.. self:ConvertValueToInfo(bsphere[2]))
				end
				TableInsert(data_meta,1,"Center(): " .. self:ConvertValueToInfo(obj:Center()))
				TableInsert(data_meta,1,"IsEmpty(): " .. self:ConvertValueToInfo(obj:IsEmpty()))
				local Radius = obj:Radius()
				local Radius2D = obj:Radius2D()
				TableInsert(data_meta,1,"Radius(): " .. self:ConvertValueToInfo(Radius))
				if Radius ~= Radius2D then
					TableInsert(data_meta,1,"Radius2D(): " .. self:ConvertValueToInfo(Radius2D))
				end
				TableInsert(data_meta,1,"size(): " .. self:ConvertValueToInfo(obj:size()))
				TableInsert(data_meta,1,"IsValidZ(): " .. self:ConvertValueToInfo(obj:IsValidZ()))
				TableInsert(data_meta,1,"\nIsValid(): " .. self:ConvertValueToInfo(obj:IsValid()))
			elseif name == "HGE.Point" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,"__unm(): " .. self:ConvertValueToInfo(obj:__unm()))
				local x,y,z = obj:xyz()
				local xyz = "x: " .. self:ConvertValueToInfo(x)
					.. ", y: " .. self:ConvertValueToInfo(y)
				if z then
					xyz = xyz .. ", z: " .. self:ConvertValueToInfo(z)
				end
				TableInsert(data_meta,1,xyz)
				TableInsert(data_meta,1,"IsValidZ(): " .. self:ConvertValueToInfo(obj:IsValidZ()))
				TableInsert(data_meta,1,"\nIsValid(): " .. self:ConvertValueToInfo(obj:IsValid()))
			elseif name == "HGE.RandState" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,"Last(): " .. self:ConvertValueToInfo(obj:Last()))
				TableInsert(data_meta,1,"GetStable(): " .. self:ConvertValueToInfo(obj:GetStable()))
				TableInsert(data_meta,1,"Get(): " .. self:ConvertValueToInfo(obj:Get()))
				TableInsert(data_meta,1,"\nCount(): " .. self:ConvertValueToInfo(obj:Count()))
			elseif name == "HGE.Quaternion" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,"Norm(): " .. self:ConvertValueToInfo(obj:Norm()))
				TableInsert(data_meta,1,"Inv(): " .. self:ConvertValueToInfo(obj:Inv()))
				local roll,pitch,yaw = obj:GetRollPitchYaw()
				TableInsert(data_meta,1,"GetRollPitchYaw(): "
					.. self:ConvertValueToInfo(roll)
					.. " " .. self:ConvertValueToInfo(pitch)
					.. " " .. self:ConvertValueToInfo(yaw))
				TableInsert(data_meta,1,"\nGetAxisAngle(): " .. self:ConvertValueToInfo(obj:GetAxisAngle()))
			elseif name == "LuaPStr" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,"hash(): " .. self:ConvertValueToInfo(obj:hash()))
				TableInsert(data_meta,1,"str(): " .. self:ConvertValueToInfo(obj:str()))
				TableInsert(data_meta,1,"parseTuples(): " .. self:ConvertValueToInfo(obj:parseTuples()))
				TableInsert(data_meta,1,"getInt(): " .. self:ConvertValueToInfo(obj:getInt()))
				TableInsert(data_meta,1,"\nsize(): " .. self:ConvertValueToInfo(obj:size()))
--~ 			elseif name == "HGE.File" then
--~ 			elseif name == "HGE.ForEachReachable" then
--~ 			elseif name == "RSAKey" then
--~ 			elseif name == "lpeg-pattern" then
			else
				TableInsert(data_meta,1,"\ngetmetatable():")
				local is_t = IsT(obj)
				if is_t then
					TableInsert(data_meta,1,"THasArgs(): " .. self:ConvertValueToInfo(THasArgs(obj)))
					-- IsT returns the string id, but we'll just call it TGetID() to make it more obvious for people
					TableInsert(data_meta,1,"\nTGetID(): " .. self:ConvertValueToInfo(is_t))
					if str_not_translated and not UICity then
						TableInsert(data_meta,1,S[302535920001500--[[userdata object probably needs UICity to translate.--]]])
					end
				end
			end

			c = c + 1
			totextex_res[c] = TableConcat(data_meta,"\n")
		end

	-- add some extra info for funcs
	elseif obj_type == "function" then
		local dbg_value

		if blacklist then
			dbg_value = "\ngetinfo(): " .. DebugGetInfo(obj)
		else
			c = c + 1
			totextex_res[c] = "\n"
			local nups = getinfo(obj, "u").nups
			if nups > 0 then
				c = self:RetDebugUpValue(obj,totextex_res,c,nups)
			end
			dbg_value = self:RetDebugGetInfo(obj)
			-- any args
			local args = self:RetFuncParams(obj)
			if args then
				c = c + 1
				totextex_res[c] = args
			end
		end
		if dbg_value then
			c = c + 1
			totextex_res[c] = dbg_value
		end

	elseif obj_type == "thread" then

		c = c + 1
		totextex_res[c] = "<color 255 255 255>"
			.. S[302535920001353--[[Thread info--]]]
			.. ":\nIsValidThread(): "
		local is_valid = IsValidThread(obj)
		if is_valid then
			totextex_res[c] = totextex_res[c]
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
			totextex_res[c] = totextex_res[c]
				.. self:ConvertValueToInfo(is_valid or nil)
				.. "\n"
		end

		local info_list = RetThreadInfo(obj)
		-- needed for the table that's returned if blacklist is enabled (it starts at 1, getinfo starts at 0)
		local starter = info_list[0] and 0 or 1

		for i = starter, #info_list do
			local info = info_list[i]
			c = c + 1
			totextex_res[c] = "\ngetinfo(level " .. info.level .. "): "

			c = c + 1
			totextex_res[c] = "func: " .. info.name .. ", "
				.. self:ConvertValueToInfo(info.func)

			if info.getlocal then
				for j = 1, #info.getlocal do
					local v = info.getlocal[j]
					c = c + 1
					totextex_res[c] = "getlocal(" .. v.level .. "," .. j .. "): " .. v.name .. ", "
						.. self:ConvertValueToInfo(v.value)
				end
			end

			if info.getupvalue then
				for j = 1, #info.getupvalue do
					local v = info.getupvalue[j]
					c = c + 1
					totextex_res[c] = "getupvalue(" .. j .. "): " .. v.name .. ", "
						.. self:ConvertValueToInfo(v.value)
				end
			end
		end
		if info_list.gethook then
			c = c + 1
			totextex_res[c] = self:ConvertValueToInfo(info_list.gethook)
		end

	end

	if not (obj == "nil" or is_valid_obj or obj_type == "userdata") and obj_metatable then
		TableInsert(totextex_res, 1,"\t-- metatable: " .. self:ConvertValueToInfo(obj_metatable) .. " --")
		if self.enum_vars and next(self.enum_vars) then
			totextex_res[1] = totextex_res[1] .. self:HyperLink(obj,function()
				OpenInExamineDlg(self.enum_vars,self)
			end)
			.. " enum"
			.. HLEnd
		end

	end

	return TableConcat(totextex_res,"\n")
end
---------------------------------------------------------------------------------------------------------------------
function Examine:SetToolbarVis(obj)
	-- always hide all
	self.idButMarkObject:SetVisible()
	self.idButMarkAll:SetVisible()
	self.idButDeleteAll:SetVisible()
	self.idViewEnum:SetVisible()
	self.idButDeleteObj:SetVisible()
	self.idButViewSource:SetVisible()

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

			-- can't mark if it isn't an object, and no sense in marking something off the map
			if IsValid(obj) and obj:GetPos() ~= InvalidPos then
				self.idButMarkObject:SetVisible(true)
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

	elseif self.obj_type == "function" then
		if getinfo(obj,"S").what == "Lua" then
			self.idButViewSource:SetVisible(true)
		end

	elseif self.obj_type == "thread" then
		self.idButDeleteObj:SetVisible(true)
	end


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
			name = "-- " .. title .. " --",
			hint = title,
			disable = true,
			centred = true,
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
						OpenInExamineDlg(g_Classes[list[i]],self)
					end,
				}
			end
		end
	end
end

function Examine:SetObj(startup)
	local obj = self.obj

	-- reset the hyperlinks
	TableIClear(self.onclick_funcs)
	TableIClear(self.onclick_objs)
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

	self.idText:SetText(S[67--[[Loading resources--]]])

	if obj_type == "table" then
		obj_class = g_Classes[obj.class]
		if getmetatable(obj) then
			self.idShowAllValues:SetVisible(true)
		else
			self.idShowAllValues:SetVisible(false)
		end

		-- add object name to title
		if obj_class and obj.handle and #obj > 0 then
			name = name .. ": " .. obj.handle .. " (" .. #obj .. ")"
		elseif obj_class and obj.handle then
			name = name .. " " .. " (" .. obj.handle .. ")"
		elseif #obj > 0 then
			name = name .. " " .. " (" .. #obj .. ")"
		end

		-- build parents/ancestors menu
		if obj_class then
			TableIClear(self.parents_menu_popup)
			TableClear(self.pmenu_skip_dupes)
			-- build menu list
			self:BuildParents(obj.__parents,"parents",S[302535920000520--[[Parents--]]])
			self:BuildParents(obj.__ancestors,"ancestors",S[302535920000525--[[Ancestors--]]],true)
			-- if anything was added to the list then add to the menu
			if #self.parents_menu_popup > 0 then
				self.idParents:SetVisible(true)
			end
		end

		-- attaches button/menu
		TableIClear(self.attaches_menu_popup)
		local attaches = ChoGGi.ComFuncs.GetAllAttaches(obj)
		local attach_amount = #attaches

		for i = 1, attach_amount do
			local a = attaches[i]
			local pos = a.GetVisualPos and a:GetVisualPos()

			local name = RetName(a)
			if name ~= a.class then
				name = name .. ": " .. a.class
			end
			self.attaches_menu_popup[i] = {
				name = name,
				hint = a.class .. "\n" .. S[302535920000955--[[Handle--]]] .. ": "
					.. (a.handle or S[6761--[[None--]]]) .. "\npos: " .. tostring(pos),
				showobj = a,
				clicked = function()
					ChoGGi.ComFuncs.ClearShowObj(a)
					OpenInExamineDlg(a,self)
				end,
			}

		end

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

	end -- istable

	if obj == "nil" then
		self.idCaption:SetTitle(self,obj)
	else
		local name_type = obj_type .. ": "
		local title = self.title or name or obj
		self.idCaption:SetTitle(self,name_type .. title:gsub(name_type,""))
	end

	-- for bigger lists like _G or MapGet(true): we add a slight delay, so the dialog shows up (progress is happening user)
	if startup then
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
--~ ChoGGi.ComFuncs.TickStart("Examine")
			self.idText:SetText(self:ConvertObjToInfo(obj,obj_type))
--~ ChoGGi.ComFuncs.TickEnd("Examine",self.name)
		end)
	else
		self.idText:SetText(self:ConvertObjToInfo(obj,obj_type))
	end

	return obj_class
end

local function PopupClose(name)
	local popup = PropObjGetProperty(terminal.desktop,name)
	if popup then
		popup:Close()
	end
end

function Examine:Done(result,...)
	local obj = self.obj_ref
	-- stop refreshing
	if IsValidThread(self.autorefresh_thread) then
		DeleteThread(self.autorefresh_thread)
	end
	-- close any opened popup menus
	PopupClose(self.idAttachesMenu)
	PopupClose(self.idParentsMenu)
	PopupClose(self.idToolsMenu)
	-- hide bbox
	if self.obj_type == "table" then
		if obj.ChoGGi_bboxobj then
			obj.ChoGGi_bboxobj:Destroy()
			obj.ChoGGi_bboxobj = nil
		end
		-- attach spot names
		if obj.ChoGGi_ShowAttachSpots then
			obj:HideSpots()
			obj.ChoGGi_ShowAttachSpots = nil
		end
		-- hex shape
		if obj.ChoGGi_shape_obj then
			obj.ChoGGi_shape_obj:Destroy()
			obj.ChoGGi_shape_obj = nil
		end
	end
	-- remove this dialog from list of examine dialogs
	local g_ExamineDlgs = g_ExamineDlgs or empty_table
	g_ExamineDlgs[self.obj] = nil
	g_ExamineDlgs[obj] = nil

	ChoGGi_Window.Done(self,result,...)
end
