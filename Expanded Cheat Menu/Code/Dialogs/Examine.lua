-- See LICENSE for terms

-- used to examine objects

local pairs,type,tostring,tonumber,rawget = pairs,type,tostring,tonumber,rawget

local StringFormat = string.format
local TableSort = table.sort
local TableInsert = table.insert
local TableClear = table.clear
local TableIClear = table.iclear

local CmpLower = CmpLower
local IsObjlist = IsObjlist
local GetStateName = GetStateName
local IsPoint = IsPoint
local IsKindOf = IsKindOf
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
local ShowObj
local ColourObj
local DebugGetInfo
local RetThreadInfo
local DeleteObject
local DotNameToObject
local Trans
local GetParentOfKind
local IsControlPressed
local Random
local InvalidPos
local S
local blacklist

-- need to wait till Library mod is loaded
function OnMsg.ClassesGenerate()
	local ChoGGi = ChoGGi
	TableConcat = ChoGGi.ComFuncs.TableConcat
	PopupToggle = ChoGGi.ComFuncs.PopupToggle
	RetName = ChoGGi.ComFuncs.RetName
	ShowObj = ChoGGi.ComFuncs.ShowObj
	ColourObj = ChoGGi.ComFuncs.ColourObj
	DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	DeleteObject = ChoGGi.ComFuncs.DeleteObject
	DotNameToObject = ChoGGi.ComFuncs.DotNameToObject
	RetThreadInfo = ChoGGi.ComFuncs.RetThreadInfo
	Trans = ChoGGi.ComFuncs.Translate
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
	IsControlPressed = ChoGGi.ComFuncs.IsControlPressed
	Random = ChoGGi.ComFuncs.Random
	InvalidPos = ChoGGi.Consts.InvalidPos
	S = ChoGGi.Strings
	blacklist = ChoGGi.blacklist
end

local GetRootDialog = function(obj)
	return GetParentOfKind(obj,"Examine")
end
DefineClass.Examine = {
	__parents = {"ChoGGi_Window"},

	-- stores all opened examine dialogs
	examine_dialogs = {},
	-- prefix some string to the title
	prefix = false,
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
	-- if it's transparent or not
	transp_mode = false,
	-- get list of all values from metatables
	show_all_values = false,
	-- going in through the backdoor
	sort = false,

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
	tools_menu_popup = false,

	pmenu_skip_dupes = false,
	parents = false,
	ancestors = false,
	menu_added = false,
	menu_list_items = false,
	-- clickable purple text
	onclick_handles = false,

	idAutoRefresh_update_str = false,
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

	self.idAttachesMenu = Random()
	self.idParentsMenu = Random()
	self.idToolsMenu = Random()

	self.attaches_menu_popup = {}
	self.parents = {}
	self.ancestors = {}
	self.menu_added = {}
	self.menu_list_items = {}
	self.onclick_handles = {}

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
			RolloverTitle = S[302535920000865--[[Toggle Trans--]]],
			RolloverText = S[302535920000629--[[UI Transparency--]]],
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
		self.idButModProps = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButModProps",
			Image = "CommonAssets/UI/Menu/SelectByClass.tga",
			RolloverTitle = S[931--[[Modified property--]]],
			RolloverText = S[302535920001384--[[Get properties different from base/parent object?--]]],
			OnPress = self.idButModPropsOnPress,
		}, self.idToolbarButtons)
		--
		self.idButAllProps = g_Classes.ChoGGi_ToolbarButton:new({
			Id = "idButAllProps",
			Image = "CommonAssets/UI/Menu/AreaProperties.tga",
			RolloverTitle = S[302535920001389--[[All Properties--]]],
			RolloverText = S[302535920001390--[[Get all properties.--]]],
			OnPress = self.idButAllPropsOnPress,
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
		-- right side

		self.idAutoRefresh_update_str = StringFormat("%s\n%s\n%s: %s",S[302535920001257--[[Auto-refresh list every second.--]]],S[302535920001422--[[Right-click to change refresh delay.--]]],S[302535920000106--[[Current--]]],"%s")
		self.idAutoRefresh = g_Classes.ChoGGi_CheckButton:new({
			Id = "idAutoRefresh",
			Dock = "right",
			Text = S[302535920000084--[[Auto-Refresh--]]],
			RolloverText = self.idAutoRefresh_update_str:format(ChoGGi.UserSettings.ExamineRefreshTime),
			RolloverHint = S[302535920001425--[["<left_click> Toggle, <right_click> Set Delay"--]]],
			OnChange = self.idAutoRefreshToggle,
			OnMouseButtonDown = self.idAutoRefreshOnMouseButtonDown,
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
		self.idAutoRefreshDelay:SetVisible()
		self.idAutoRefreshDelay:SetText(tostring(ChoGGi.UserSettings.ExamineRefreshTime))
		--
		self.idSortDir = g_Classes.ChoGGi_CheckButton:new({
			Id = "idSortDir",
			Dock = "right",
			Text = S[10124--[[Sort--]]],
			RolloverText = S[302535920001248--[[Sort normally or backwards.--]]],
			OnChange = self.idSortDirOnChange,
		}, self.idToolbarArea)
		--
		self.idShowAllValues = g_Classes.ChoGGi_CheckButton:new({
			Id = "idShowAllValues",
			Dock = "right",
			MinWidth = 0,
			Text = S[4493--[[All--]]],
			RolloverText = S[302535920001391--[[Show all values (metatable).--]]],
			OnChange = self.idShowAllValuesOnChange,
		}, self.idToolbarArea)
	end -- toolbar area

	do -- go to text area
		self.idGotoArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idGotoArea",
			Dock = "top",
		}, self.idDialog)

		self.idGoto = g_Classes.ChoGGi_TextInput:new({
			Id = "idGoto",
			RolloverText = S[302535920000043--[["Press Enter to scroll to next found text, Ctrl-Enter to scroll back, Arrows to scroll to each end."--]]],
			Hint = S[302535920000044--[[Go To Text--]]],
--~ 			OnTextChanged = self.idGotoOnTextChanged,
			OnKbdKeyDown = self.idGotoOnKbdKeyDown,
		}, self.idGotoArea)
	end

	do -- tools area
		self.idMenuArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idMenuArea",
			Dock = "top",
		}, self.idDialog)

		self.tools_menu_popup = self:BuildToolsMenuPopup()
		self.idTools = g_Classes.ChoGGi_ComboButton:new({
			Id = "idTools",
			Text = S[302535920000239--[[Tools--]]],
			RolloverText = S[302535920001426--[[Various tools to use.--]]],
			OnMouseButtonDown = self.idToolsOnMouseButtonDown,
			Dock = "left",
		}, self.idMenuArea)

		self.idParents = g_Classes.ChoGGi_ComboButton:new({
			Id = "idParents",
			Text = S[302535920000520--[[Parents--]]],
			RolloverText = S[302535920000553--[[Examine parent and ancestor objects.--]]],
			OnMouseButtonDown = self.idParentsOnMouseButtonDown,
			Dock = "left",
		}, self.idMenuArea)
		self.idParents:SetVisible(false)

		self.idAttaches = g_Classes.ChoGGi_ComboButton:new({
			Id = "idAttaches",
			Text = S[302535920000053--[[Attaches--]]],
			RolloverText = S[302535920000054--[[Any objects attached to this object.--]]],
			OnMouseButtonDown = self.idAttachesOnMouseButtonDown,
			Dock = "left",
		}, self.idMenuArea)
		self.idAttaches:SetVisible(false)

		self.idNext = g_Classes.ChoGGi_Button:new({
			Id = "idNext",
			Text = S[1000232--[[Next--]]],
			Dock = "right",
			RolloverAnchor = "right",
			RolloverHint = S[302535920001424--[["<left_click> Next, <right_click> Previous, <middle_click> Top"--]]],
			RolloverText = S[302535920000045--[["Scrolls down one line or scrolls between text in ""Go to text"".
Right-click to go up, middle-click to scroll to the top."--]]],
			OnMouseButtonDown = self.idNextOnMouseButtonDown,
		}, self.idMenuArea)
	end -- tools area

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
		if ChoGGi.UserSettings.FlashExamineObject and IsKindOf(self.obj_ref,"XWindow") and self.obj_ref.class ~= "InGameInterface" then
			self:FlashWindow()
		end
	end

	self:SetInitPos(context.parent)
end

function Examine:idButRefreshOnPress()
	self = GetRootDialog(self)
	self:SetObj()
	if IsKindOf(self.obj_ref,"XWindow") and self.obj_ref.class ~= "InGameInterface" then
		self:FlashWindow()
	end
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

function Examine:idButModPropsOnPress()
	self = GetRootDialog(self)
	ChoGGi.ComFuncs.OpenInExamineDlg(
		GetModifiedProperties(self.obj_ref),
		self,
		StringFormat("%s: %s",S[931--[[Modified property--]]],self.name)
	)
end

function Examine:idButAllPropsOnPress()
	self = GetRootDialog(self)
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
	ChoGGi.ComFuncs.OpenInExamineDlg(props_list,self,StringFormat("%s: %s",S[302535920001389--[[All Properties--]]],self.name))
end

function Examine:idButDeleteObjOnPress()
	self = GetRootDialog(self)
	ChoGGi.ComFuncs.QuestionBox(
		S[302535920000414--[[Are you sure you wish to delete it?--]]],
		function(answer)
			if answer then
				if IsValid(self.obj_ref) then
					DeleteObject(self.obj_ref)
				elseif obj.delete then
					self.obj_ref:delete()
				end
			end
		end,
		S[697--[[Destroy--]]]
	)
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

function Examine:idButMarkAllOnPress()
	self = GetRootDialog(self)
	for _, v in pairs(self.obj_ref) do
		if IsPoint(v) or IsValid(v) then
			ShowObj(v, nil, nil, true)
		end
	end
end

function Examine:idAutoRefreshToggle()
	self = GetRootDialog(self)
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
		local UserSettings = ChoGGi.UserSettings
		while true do
			if self.obj_ref then
				self:SetObj()
			else
				DeleteThread(self.autorefresh_thread)
				break
			end
			Sleep(UserSettings.ExamineRefreshTime)
		end
	end)
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
	if num then
		self = GetRootDialog(self)
		if num < 1 then
			num = 1
		end
		ChoGGi.UserSettings.ExamineRefreshTime = num
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

--~ function Examine:idGotoOnTextChanged()
--~ 	GetRootDialog(self):FindNext()
--~ end

function Examine:idToolsOnMouseButtonDown(pt,button,...)
	ChoGGi_ComboButton.OnMouseButtonDown(self,pt,button,...)
	if button == "L" then
		local dlg = GetRootDialog(self)
		PopupToggle(self,dlg.idToolsMenu,dlg.tools_menu_popup,"bottom")
	end
end

function Examine:idParentsOnMouseButtonDown(pt,button,...)
	ChoGGi_ComboButton.OnMouseButtonDown(self,pt,button,...)
	if button == "L" then
		local dlg = GetRootDialog(self)
		PopupToggle(self,dlg.idParentsMenu,dlg.parents_menu_popup,"bottom")
	end
end

function Examine:idAttachesOnMouseButtonDown(pt,button,...)
	ChoGGi_ComboButton.OnMouseButtonDown(self,pt,button,...)
	if button == "L" then
		local dlg = GetRootDialog(self)
		PopupToggle(self,dlg.idAttachesMenu,dlg.attaches_menu_popup,"bottom")
	end
end

function Examine:idNextOnMouseButtonDown(pt,button,...)
	ChoGGi_Button.OnMouseButtonDown(self,pt,button,...)
	self = GetRootDialog(self)
	if button == "L" then
		self:FindNext()
	elseif button == "R" then
		self:FindPrevious()
	else
		self.idScrollArea:ScrollTo(0,0)
	end
end

function Examine:idGotoOnKbdKeyDown(vk,...)
	self = GetRootDialog(self)
	if vk == const.vkEnter then
		if IsControlPressed() then
			self:FindPrevious()
		else
			self:FindNext()
		end
		return "break"
	elseif vk == const.vkUp then
		self.idScrollArea:ScrollTo(nil,0)
		return "break"
	elseif vk == const.vkDown then
		local v = self.idScrollV
		self.idScrollArea:ScrollTo(nil,v.Max - (v.FullPageAtEnd and v.PageSize or 0))
		return "break"
	elseif vk == const.vkRight then
		local h = self.idScrollH
		self.idScrollArea:ScrollTo(h.Max - (h.FullPageAtEnd and h.PageSize or 0))
	elseif vk == const.vkLeft then
		self.idScrollArea:ScrollTo(0)
	elseif vk == const.vkEsc then
		self.idCloseX:OnPress()
		return "break"
	else
		return ChoGGi_TextInput.OnKbdKeyDown(self.idGoto,vk,...)
	end
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
					self:BuildFuncList(self.obj_ref.class,"	")
					-- if Object hasn't been added, then add CObject (O has a few more funcs than CO)
					if not self.menu_added.Object and self.menu_added.CObject then
						self:BuildFuncList("CObject",self.menu_added.CObject)
					end

					ChoGGi.ComFuncs.OpenInExamineDlg(self.menu_list_items,self,StringFormat("%s: %s",S[302535920001239--[[Functions--]]],self.name)
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
			hint = S[302535920001303--[[Search for text within %s.--]]]:format(self.name),
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
			name = S[174--[[Color Modifier--]]],
			hint = S[302535920000693--[[Select/mouse over an object to change the colours
Use Shift- or Ctrl- for random colours/reset colours.--]]],
			clicked = function()
				ChoGGi.ComFuncs.ChangeObjectColour(self.obj_ref)
			end,
		},
		{
			name = StringFormat("%s %s",S[302535920000129--[[Set--]]],S[302535920001184--[[Particles--]]]),
			hint = S[302535920001421--[[Shows a list of particles you can use on the selected obj.--]]],
			image = "CommonAssets/UI/Menu/place_particles.tga",
			clicked = function()
				ChoGGi.ComFuncs.SetParticles(self.obj_ref)
			end,
		},
		{
			name = S[302535920000449--[[Attach Spots Toggle--]]],
			hint = S[302535920000450--[[Toggle showing attachment spots on selected object.--]]],
			image = "CommonAssets/UI/Menu/ShowAll.tga",
			clicked = function()
				ChoGGi.ComFuncs.AttachSpots_Toggle(self.obj_ref)
			end,
		},
		{
			name = S[302535920000459--[[Anim Debug Toggle--]]],
			hint = S[302535920000460--[[Attaches text to each object showing animation info (or just to selected object).--]]],
			image = "CommonAssets/UI/Menu/CameraEditor.tga",
			clicked = function()
				ChoGGi.ComFuncs.ShowAnimDebug_Toggle(self.obj_ref)
			end,
		},
		{
			name = S[302535920000457--[[Anim State Set--]]],
			hint = S[302535920000458--[[Make object dance on command.--]]],
			image = "CommonAssets/UI/Menu/UnlockCamera.tga",
			clicked = function()
				ChoGGi.ComFuncs.SetAnimState(self.obj_ref)
			end,
		},
		{
			name = S[302535920000682--[[Change Entity--]]],
			hint = S[S[302535920001151--[[Set Entity For %s--]]]:format(self.name)],
			image = "CommonAssets/UI/Menu/SetCamPos&Loockat.tga",
			clicked = function()
				ChoGGi.ComFuncs.ObjectSpawner(self.obj_ref,true,7)
			end,
		},
		--
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

function Examine:FindPrevious(text)
	text = text or self.idGoto:GetText()
	local current_y = self.idScrollArea.OffsetY
	local min_match, closest_match = false, false

	for y, list_draw_info in pairs(self.idText.draw_cache or {}) do
		for i = 1, #list_draw_info do
			local draw_info = list_draw_info[i]
			if draw_info.text and draw_info.text:find_lower(text) or text == "" then
				if not min_match or y < min_match then
					min_match = y
				end
				if y < current_y and (not closest_match or y > closest_match) then
					closest_match = y
				end
			end
		end
	end

	if closest_match or min_match then
		self.idScrollArea:ScrollTo(nil,closest_match or min_match)
	end
end

function Examine:FindNext(text)
	text = text or self.idGoto:GetText()
	local current_y = self.idScrollArea.OffsetY
	local min_match, closest_match = false, false

	for y, list_draw_info in pairs(self.idText.draw_cache or {}) do
		for i = 1, #list_draw_info do
			local draw_info = list_draw_info[i]
			if draw_info.text and draw_info.text:find_lower(text) or text == "" then
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
		self.idScrollArea:ScrollTo(nil,closest_match or min_match)
	end
end

do -- FlashWindow
	local flashing_thread
	local Sleep = Sleep
	local DeleteThread = DeleteThread
	local CreateRealTimeThread = CreateRealTimeThread

	function Examine:FlashWindow()
		-- doesn't lead to good stuff
		if not self.obj_ref.desktop then
			return
		end

		-- don't want to end up with something invis when it shouldn't be
		if not self.orig_vis_flash then
			self.orig_vis_flash = self.obj_ref:GetVisible()
		end

		-- always kill off old thread first
		DeleteThread(flashing_thread)

		flashing_thread = CreateRealTimeThread(function()

			local vis
			for _ = 1, 5 do
				if self.obj_ref.window_state == "destroying" then
					break
				end
				self.obj_ref:SetVisible(vis)
				Sleep(100)
				vis = not vis
			end

			if self.obj_ref.window_state ~= "destroying" then
				self.obj_ref:SetVisible(self.orig_vis_flash)
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

function Examine:valuetotextex(obj)
	local obj_type = type(obj)

	local function ShowMe_local()
		ShowObj(obj)
	end
	local function Examine_local(_,_,button)
		if button == "L" then
			ChoGGi.ComFuncs.OpenInExamineDlg(obj,self)
		else
			ShowObj(obj)
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
				return S[302535920000066--[[<color 203 120 30>Off-Map</color>--]]]
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
			if trans:find("Missing text") then
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
				self:valuetotextex(obj:GetVisualPos())
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
				local is_next = type(next(obj)) ~= "nil"

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

function Examine:idTextOnHyperLink(link, _, box, pos, button)
	self = GetRootDialog(self)
	self.onclick_handles[tonumber(link)](box, pos, button, self)
end
function Examine:HyperLink(f, custom_color)
	self.onclick_handles[#self.onclick_handles+1] = f
	return StringFormat("%s<h %s 230 195 50>",
		custom_color or "<color 150 170 250>",
		#self.onclick_handles
	)
end

---------------------------------------------------------------------------------------------------------------------
local ExamineThreadLevel_str1 = "%s < debug.getlocal(%s,%s)"
local ExamineThreadLevel_str2 = "debug.getupvalue(%s,%s)"
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
				ExamineThreadLevel_data[ExamineThreadLevel_str1:format(name,level,l)] = val
				l = l + 1
			else
				break
			end
		until not name

		for i = 1, info.nups do
			local name, val = getupvalue(info.func, i)
			if name ~= nil and val ~= nil then
				ExamineThreadLevel_data[ExamineThreadLevel_str2:format(name or S[302535920000723--[[Lua--]]],i)] = val
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
					totextex_res[c] = StringFormat([[%s%s(%s) %s: %s%s < debug.getinfo(%s,"Slfun")]],
						self:HyperLink(function()
							ExamineThreadLevel_totextex(l_level,l_info,obj,self)
						end),
						info.short_src or info.source,
						info.currentline,
						S[1000110--[[Type--]]],
						info.name ~= "" and info.name or info.name_what ~= "" and info.name_what or info.what ~= "" and info.what or S[302535920000723--[[Lua--]]],
						HLEnd,
						l_level
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
					totextex_res[c] = StringFormat("%s = %s < debug.getupvalue(%s)",
						self:valuetotextex(k),
						self:valuetotextex(v),
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

	if IsValid(obj) and obj:IsKindOf("CObject") then

		TableInsert(totextex_res,1,StringFormat(--[[<center>----]]"\t\t\t\t--%s%s%s@%s--"--[[--<vspace 6><left>--]],
			self:HyperLink(function()
				ChoGGi.ComFuncs.OpenInExamineDlg(getmetatable(obj),self)
			end),
			obj.class,
			HLEnd,
			self:valuetotextex(obj:GetVisualPos())
		))

		if obj:IsValidPos() and IsValidEntity(obj.entity) and 0 < obj:GetAnimDuration() then
			local pos = obj:GetVisualPos() + obj:GetStepVector() * obj:TimeToAnimEnd() / obj:GetAnimDuration()
			TableInsert(totextex_res, 2, StringFormat("%s, step:%s%s%s",
				GetStateName(obj:GetState()),
				self:HyperLink(function()
					ShowObj(pos)
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
		if trans:find("Missing text") then
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
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,StringFormat("Unpack(): %s%s%s",
					self:HyperLink(function()
						ChoGGi.ComFuncs.OpenInExamineDlg({obj:Unpack()},self)
					end),
					"table",
					HLEnd
				))
				TableInsert(data_meta,1,StringFormat("IsAnyFlagSet(): %s",self:valuetotextex(obj:IsAnyFlagSet())))
				TableInsert(data_meta,1,StringFormat("GetFlags(): %s",self:valuetotextex(obj:GetFlags())))
				TableInsert(data_meta,1,StringFormat("GetReciprocalRequest(): %s",self:valuetotextex(obj:GetReciprocalRequest())))
				TableInsert(data_meta,1,StringFormat("GetLastServiced(): %s",self:valuetotextex(obj:GetLastServiced())))
				TableInsert(data_meta,1,StringFormat("GetFreeUnitSlots(): %s",self:valuetotextex(obj:GetFreeUnitSlots())))
				TableInsert(data_meta,1,StringFormat("GetFillIndex(): %s",self:valuetotextex(obj:GetFillIndex())))
				TableInsert(data_meta,1,StringFormat("GetTargetAmount(): %s",self:valuetotextex(obj:GetTargetAmount())))
				TableInsert(data_meta,1,StringFormat("GetDesiredAmount(): %s",self:valuetotextex(obj:GetDesiredAmount())))
				TableInsert(data_meta,1,StringFormat("GetActualAmount(): %s",self:valuetotextex(obj:GetActualAmount())))
				TableInsert(data_meta,1,StringFormat("GetWorkingUnits(): %s",self:valuetotextex(obj:GetWorkingUnits())))
				TableInsert(data_meta,1,StringFormat("GetResource(): %s",self:valuetotextex(obj:GetResource())))
				TableInsert(data_meta,1,StringFormat("\nGetBuilding(): %s",self:valuetotextex(obj:GetBuilding())))
			elseif name == "HGE.Grid" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,StringFormat("get_default(): %s",self:valuetotextex(obj:get_default())))
				TableInsert(data_meta,1,StringFormat("max_value(): %s",self:valuetotextex(obj:max_value())))
				TableInsert(data_meta,1,StringFormat("\nsize(): %s",self:valuetotextex(obj:size())))
			elseif name == "HGE.XMGrid" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				local minmax = {obj:minmax()}
				if minmax[1] then
					TableInsert(data_meta,1,StringFormat("minmax(): %s %s",minmax[1],minmax[2]))
				end
				TableInsert(data_meta,1,StringFormat("levels(): %s",self:valuetotextex(obj:levels())))
				TableInsert(data_meta,1,StringFormat("GetPositiveCells(): %s",self:valuetotextex(obj:GetPositiveCells())))
				TableInsert(data_meta,1,StringFormat("GetBilinear(): %s",self:valuetotextex(obj:GetBilinear())))
				TableInsert(data_meta,1,StringFormat("EnumZones(): %s",self:valuetotextex(obj:EnumZones())))
				TableInsert(data_meta,1,StringFormat("\nCenterOfMass(): %s",self:valuetotextex(obj:CenterOfMass())))
			elseif name == "HGE.Box" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,StringFormat("min(): %s",self:valuetotextex(obj:min())))
				TableInsert(data_meta,1,StringFormat("max(): %s",self:valuetotextex(obj:max())))
				TableInsert(data_meta,1,StringFormat("GetBSphere(): %s",self:valuetotextex(obj:GetBSphere())))
				TableInsert(data_meta,1,StringFormat("Center(): %s",self:valuetotextex(obj:Center())))
				TableInsert(data_meta,1,StringFormat("IsEmpty(): %s",self:valuetotextex(obj:IsEmpty())))
				TableInsert(data_meta,1,StringFormat("ToPoints2D(): %s",self:valuetotextex(obj:ToPoints2D())))
				local Radius = self:valuetotextex(obj:Radius())
				local Radius2D = self:valuetotextex(obj:Radius2D())
				TableInsert(data_meta,1,StringFormat("Radius(): %s",Radius))
				if Radius ~= Radius2D then
					TableInsert(data_meta,1,StringFormat("Radius2D(): %s",Radius2D))
				end
				TableInsert(data_meta,1,StringFormat("size(): %s",self:valuetotextex(obj:size())))
				TableInsert(data_meta,1,StringFormat("IsValidZ(): %s",self:valuetotextex(obj:IsValidZ())))
				TableInsert(data_meta,1,StringFormat("\nIsValid(): %s",self:valuetotextex(obj:IsValid())))
			elseif name == "HGE.Point" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,StringFormat("__unm(): %s",self:valuetotextex(obj:__unm())))
				TableInsert(data_meta,1,StringFormat("z(): %s",self:valuetotextex(obj:z())))
				TableInsert(data_meta,1,StringFormat("y(): %s",self:valuetotextex(obj:y())))
				TableInsert(data_meta,1,StringFormat("x(): %s",self:valuetotextex(obj:x())))
				TableInsert(data_meta,1,StringFormat("IsValidZ(): %s",self:valuetotextex(obj:IsValidZ())))
				TableInsert(data_meta,1,StringFormat("\nIsValid(): %s",self:valuetotextex(obj:IsValid())))
			elseif name == "HGE.RandState" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,StringFormat("Last(): %s",self:valuetotextex(obj:Last())))
				TableInsert(data_meta,1,StringFormat("GetStable(): %s",self:valuetotextex(obj:GetStable())))
				TableInsert(data_meta,1,StringFormat("Get(): %s",self:valuetotextex(obj:Get())))
				TableInsert(data_meta,1,StringFormat("\nCount(): %s",self:valuetotextex(obj:Count())))
			elseif name == "HGE.Quaternion" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,StringFormat("Norm(): %s",self:valuetotextex(obj:Norm())))
				TableInsert(data_meta,1,StringFormat("Inv(): %s",self:valuetotextex(obj:Inv())))
				TableInsert(data_meta,1,StringFormat("GetRollPitchYaw(): %s",self:valuetotextex(obj:GetRollPitchYaw())))
				TableInsert(data_meta,1,StringFormat("\nGetAxisAngle(): %s",self:valuetotextex(obj:GetAxisAngle())))
			elseif name == "LuaPStr" then
				TableInsert(data_meta,1,"\ngetmetatable():")
				TableInsert(data_meta,1,StringFormat("hash(): %s",self:valuetotextex(obj:hash())))
				TableInsert(data_meta,1,StringFormat("str(): %s",self:valuetotextex(obj:str())))
				TableInsert(data_meta,1,StringFormat("parseTuples(): %s",self:valuetotextex(obj:parseTuples())))
				TableInsert(data_meta,1,StringFormat("getInt(): %s",self:valuetotextex(obj:getInt())))
				TableInsert(data_meta,1,StringFormat("\nsize(): %s",self:valuetotextex(obj:size())))
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
function Examine:SetToolbarVis(obj)
	if type(obj) == "table" then

		if IsValid(obj) then
			self.idButMarkObject:SetVisible(true)
		else
			self.idButMarkObject:SetVisible()
		end

		if obj.class and obj.class ~= "" then
			self.idButModProps:SetVisible(true)
			self.idButAllProps:SetVisible(true)
			self.idButDeleteObj:SetVisible(true)
		else
			self.idButModProps:SetVisible()
			self.idButAllProps:SetVisible()
			self.idButDeleteObj:SetVisible()
		end

		if IsObjlist(obj) then
			self.idButMarkAll:SetVisible(true)
			self.idButDeleteAll:SetVisible(true)
		else
			self.idButMarkAll:SetVisible()
			self.idButDeleteAll:SetVisible()
		end

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

--~ 	self.onclick_handles = {}
	TableClear(self.onclick_handles)

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

	self:SetToolbarVis(obj)

	local name = RetName(obj)
	self.name = name
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
		TableIClear(self.attaches_menu_popup)
		local attaches = ChoGGi.ComFuncs.GetAllAttaches(obj)
		local attach_amount = #attaches

		local hint_str = "%s\n%s: %s\npos: %s"
		local name_str = "%s: %s"
		for i = 1, attach_amount do
			local a = attaches[i]
			local pos = a.GetVisualPos and a:GetVisualPos()

			local name = RetName(a)
			if name ~= a.class then
				name = name_str:format(name,a.class)
			end
			self.attaches_menu_popup[i] = {
				name = name,
				hint = hint_str:format(
					a.class,
					S[302535920000955--[[Handle--]]],
					a.handle or S[6761--[[None--]]],
					pos
				),
				showme = a,
				clicked = function()
					ChoGGi.ComFuncs.ClearShowObj(a)
					ChoGGi.ComFuncs.OpenInExamineDlg(a,self)
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
	Examine.examine_dialogs[self.obj_ref] = nil
	ChoGGi_Window.Done(self,result)
end
