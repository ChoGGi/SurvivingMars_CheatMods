-- See LICENSE for terms

local S = ChoGGi.Strings
local testing = ChoGGi.testing
-- Init.lua
local TableConcat = ChoGGi.ComFuncs.TableConcat
-- Strings.lua
local Trans = ChoGGi.ComFuncs.Translate

local pairs,tonumber,type = pairs,tonumber,type
local getmetatable,tostring = getmetatable,tostring
local PropObjGetProperty = PropObjGetProperty
local AsyncRand = AsyncRand
local IsValid = IsValid
local IsKindOf = IsKindOf
local GetTerrainCursor = GetTerrainCursor
local MapFilter = MapFilter
local MapGet = MapGet
local FindNearestObject = FindNearestObject
local StringFormat = string.format
local TableRemove = table.remove
local TableFind = table.find
local TableClear = table.clear

-- backup orginal function for later use (checks if we already have a backup, or else problems)
function ChoGGi.ComFuncs.SaveOrigFunc(class_or_func,func_name)
	local ChoGGi = ChoGGi
	if func_name then
		local newname = StringFormat("%s_%s",class_or_func,func_name)
		if not ChoGGi.OrigFuncs[newname] then
			ChoGGi.OrigFuncs[newname] = _G[class_or_func][func_name]
		end
	else
		if not ChoGGi.OrigFuncs[class_or_func] then
			ChoGGi.OrigFuncs[class_or_func] = _G[class_or_func]
		end
	end
end
local SaveOrigFunc = ChoGGi.ComFuncs.SaveOrigFunc

do -- AddMsgToFunc
	local Msg = Msg
	-- changes a function to also post a Msg for use with OnMsg
	function ChoGGi.ComFuncs.AddMsgToFunc(class_name,func_name,msg_str,...)
		-- anything i want to pass onto the msg
		local varargs = ...
		-- save orig
		SaveOrigFunc(class_name,func_name)
		-- we want to local this after SaveOrigFunc just in case
		local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
		-- redefine it
		_G[class_name][func_name] = function(obj,...)
			-- send obj along with any extra args i added
			Msg(msg_str,obj,varargs)

--~ 			-- use to debug if getting an error
--~ 			local params = pack_params(...)
--~ 			-- pass on args to orig func
--~ 			if not pcall(function()
--~ 				return ChoGGi_OrigFuncs[StringFormat("%s_%s",class_name,func_name)](table.unpack(params))
--~ 			end) then
--~ 				print("Function Error: ",StringFormat("%s_%s",class_name,func_name))
--~ 				ChoGGi.ComFuncs.OpenInExamineDlg{params}
--~ 			end

			return ChoGGi_OrigFuncs[StringFormat("%s_%s",class_name,func_name)](obj,...)
		end
	end
end -- do

-- check if text is already translated or needs to be, and return the text
function ChoGGi.ComFuncs.CheckText(text,fallback)
	local ret
	-- no sense in translating a string
	if type(text) == "string" then
		return text
	else
		ret = S[text]
	end
	-- could be getting called from another mod, or it just isn't included in Strings
	if not ret or type(ret) ~= "string" then
		ret = Trans(text)
	end

	-- Trans will always return a string
	if #ret > 15 and ret:sub(-15) == "*bad string id?" then
		ret = tostring(fallback or text)
	end
	-- have at it
	return ret
end
local CheckText = ChoGGi.ComFuncs.CheckText

do -- RetName
	local tostring = tostring
	local empty_func = empty_func
	local IsObjlist = IsObjlist
	local DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo

	-- we use this table to display names of (some) tables for RetName
	local lookup_table = {}

	local function AfterLoad()
		local g = ChoGGi.Temp._G
		lookup_table[g.terminal.desktop] = "terminal.desktop"

		-- any tables in _G
		for key in pairs(g) do
			-- no need to add tables already added, and we don't care about stuff that isn't a table
			if not lookup_table[g[key]] and type(g[key]) == "table" then
				lookup_table[g[key]] = key
			end
		end

	end

	-- so they work in the main menu
	AfterLoad()

	-- called from onmsgs for citystart/loadgame
	function ChoGGi.ComFuncs.RetName_Update()
		AfterLoad()
	end
	function ChoGGi.ComFuncs.RetName_Table()
		return lookup_table
	end

	-- try to return a decent name for the obj, failing that return a string
	function ChoGGi.ComFuncs.RetName(obj)
		-- bool and nils are easy enough
		if not obj then
			return obj == false and "false" or "nil"
		elseif obj == true then
			return "true"
		end
		-- any of the _G tables
		local lookuped = lookup_table[obj]
		if lookuped then
			return lookuped
		end

		local name
		local obj_type = type(obj)

		if obj_type == "string" then
			return obj
		elseif obj_type == "number" then
			return tostring(obj)

		-- we need to use PropObjGetProperty to check (seems more consistent then rawget), as some stuff like mod.env has it's own __index and causes the game to log a warning
		elseif obj_type == "table" then

			-- we check in order of less generic "names"
			local name_type = PropObjGetProperty(obj,"name") and type(obj.name)
			-- custom name from user (probably)
			if name_type == "string" and obj.name ~= "" then
				name = obj.name
			-- colonist names
			elseif name_type == "table" then
				name = Trans(obj.name)

			-- translated name
			elseif PropObjGetProperty(obj,"display_name") and obj.display_name ~= "" then
				name = Trans(obj.display_name)
			-- encyclopedia_id
			elseif PropObjGetProperty(obj,"encyclopedia_id") and obj.encyclopedia_id ~= "" then
				name = obj.encyclopedia_id
			-- plain old id
			elseif PropObjGetProperty(obj,"id") and obj.id ~= "" then
				name = obj.id
			elseif PropObjGetProperty(obj,"Id") and obj.Id ~= "" then
				name = obj.Id
			-- class template name
			elseif PropObjGetProperty(obj,"template_name") and obj.template_name ~= "" then
				name = obj.template_name
			elseif PropObjGetProperty(obj,"template_class") and obj.template_class ~= "" then
				name = obj.template_class
			-- entity
			elseif PropObjGetProperty(obj,"entity") then
				name = obj.entity
			-- class
			elseif PropObjGetProperty(obj,"class") and obj.class ~= "" then
				name = obj.class

			-- added this here as doing tostring lags the crap outta kansas if this is a large objlist
			elseif IsObjlist(obj) then
				name = "objlist"
			end

		elseif obj_type == "userdata" then
			local trans = Trans(obj)
			if trans:sub(-15) == "*bad string id?" then
				return tostring(obj)
			end
			return trans

		elseif obj_type == "function" then
			return DebugGetInfo(obj)

		end

		-- falling back baby
		return name or tostring(obj)
	end
end -- do
local RetName = ChoGGi.ComFuncs.RetName

function ChoGGi.ComFuncs.RetIcon(obj)
	-- most icons
	if obj.display_icon and obj.display_icon ~= "" then
		return obj.display_icon

	elseif obj.pin_icon and obj.pin_icon ~= "" then
		-- colonist
		return obj.pin_icon

	else
		-- generic icon (and scale as it isn't same size as the usual icons)
		return "UI/Icons/console_encyclopedia.tga",150
	end
end

function ChoGGi.ComFuncs.RetHint(obj)
	if type(obj.description) == "userdata" then
		return obj.description

	elseif obj.GetDescription then
		return obj:GetDescription()

	else
		-- eh
		return S[3718--[[NONE--]]]
	end
end

-- "some.some.some.etc" = returns etc as object
-- use .number for index based tables ("terminal.desktop.1")
function ChoGGi.ComFuncs.DotNameToObject(str,root,create)

	-- lazy is best
	if type(str) ~= "string" then
		return str
	end
	-- there's always one
	if str == "_G" then
		return ChoGGi.Temp._G
	end

	-- obj always starts out as "root"
	local obj = root or ChoGGi.Temp._G

	-- https://www.lua.org/pil/14.1.html
	-- %w is [A-Za-z0-9], [] () + ? . act pretty much like regexp
	for name,match in str:gmatch("([%w_]+)(.?)") do
		-- if str included .number we need to make it a number or [name] won't work
		local num = tonumber(name)
		if num then
			name = num
		end
		-- . means we're not at the end yet
		if match == "." then
			-- create is for adding new settings in non-existent tables
			if not obj[name] and not create then
				-- our treasure hunt is cut short, so return nadda
				return
			end
			-- change the parent to the child (create table if absent, this'll only fire when create)
			obj = obj[name] or {}
		else
			-- no more . so we return as conquering heroes with the obj
			return obj[name]
		end
	end
end
local DotNameToObject = ChoGGi.ComFuncs.DotNameToObject

-- shows a popup msg with the rest of the notifications
-- objects can be a single obj, or {obj1,obj2,etc}
function ChoGGi.ComFuncs.MsgPopup(text,title,icon,size,objects)
	-- notifications only show up in-game
	if not GameState.gameplay then
		return
	end

	local ChoGGi = ChoGGi
	if not ChoGGi.Temp.MsgPopups then
		ChoGGi.Temp.MsgPopups = {}
	end

	-- how many ms it stays open for
	local timeout = 10000
	if size then
		timeout = 25000
	end
	local params = {
		expiration = timeout,
--~ 		 {expiration = max_int},
--~		 dismissable = false,
	}
	-- if there's no interface then we probably shouldn't open the popup
	local dlg = Dialogs.OnScreenNotificationsDlg
	if not dlg then
		local igi = Dialogs.InGameInterface
		if not igi then
			return
		end
		dlg = OpenDialog("OnScreenNotificationsDlg", igi)
	end
	-- build the popup
	local data = {
		id = AsyncRand(),
		title = CheckText(title),
		text = CheckText(text,S[3718--[[NONE--]]]),
		image = type(tostring(icon):find(".tga")) == "number" and icon or StringFormat("%sUI/TheIncal.png",ChoGGi.library_path)
	}
	table.set_defaults(data, params)
	table.set_defaults(data, OnScreenNotificationPreset)
	if objects then
		if type(objects) ~= "table" then
			objects = {objects}
		end
		params.cycle_objs = objects
	end

	-- needed in Sagan update
	local aosn = g_ActiveOnScreenNotifications
	local idx = table.find(aosn, 1, data.id) or #aosn + 1
	aosn[idx] = {data.id}

	-- and show the popup
	CreateRealTimeThread(function()
		local popup = OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, params.cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
		ChoGGi.Temp.MsgPopups[#ChoGGi.Temp.MsgPopups+1] = popup

		-- large amount of text option (four long lines o' text)
		if size then
			local frame = ChoGGi.ComFuncs.GetParentOfKind(popup.idText, "XFrame")
			if frame then
				frame:SetMaxWidth(1000)
			end
			popup.idText:SetMaxHeight(250)
		end
	end)
end
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

do -- ShowObj
	local IsPoint = IsPoint
	local IsValid = IsValid
	local green = green
	local guic = guic
	local ViewObjectMars = ViewObjectMars
	local InvalidPos = ChoGGi.Consts.InvalidPos
	local xyz_str = "%s%s%s"
	local xy0_str = "%s%s0"

	local markers = {}
	function ChoGGi.ComFuncs.ExamineMarkers()
		ex(markers)
	end

	local function ClearMarker(k,v)
		v = v or markers[k]
		if IsValid(k) then
			if k.ChoGGi_ShowObjColour then
				k:SetColorModifier(k.ChoGGi_ShowObjColour)
				k.ChoGGi_ShowObjColour = nil
			elseif v == "vector" or k:IsKindOf("ChoGGi_Sphere") then
				k:delete()
			end
		end
		if IsValid(v) and v:IsKindOf("ChoGGi_Sphere") then
			v:delete()
		end

		markers[k] = nil
	end
	function ChoGGi.ComFuncs.ClearShowObj(obj)
		SuspendPassEdits("ClearShowObj")
		-- try and clean up just asked for, and if not then all
		if IsValid(obj) and (markers[obj] or obj.ChoGGi_ShowObjColour) then
			ClearMarker(obj)
			ClearMarker(xyz_str:format(obj:GetVisualPos():xyz()))
		-- any markers in the list
		elseif next(markers) then
			for k, v in pairs(markers) do
				ClearMarker(k,v)
			end
			TableClear(markers)
		-- could be from a saved game so remove any objects on the map
		else
			MapDelete(true, "ChoGGi_Vector","ChoGGi_Sphere")
		end
		ResumePassEdits("ClearShowObj")
	end
	local ClearShowObj = ChoGGi.ComFuncs.ClearShowObj

	function ChoGGi.ComFuncs.ColourObj(obj, color)
		if not IsValid(obj) then
			return
		end
		if not obj:IsKindOf("ColorizableObject") then
			return
		end

		obj.ChoGGi_ShowObjColour = obj.ChoGGi_ShowObjColour or obj:GetColorModifier()
		markers[obj] = obj.ChoGGi_ShowObjColour
		obj:SetColorModifier(color or green)
	end

	local function AddSphere(pt,color)
		if not pt:z() then
			xyz_str = xy0_str
		end
		local xyz = xyz_str:format(pt:xyz())
		if not markers[xyz] then
			local sphere = ChoGGi_Sphere:new()
			sphere:SetPos(pt)
			sphere:SetRadius(50 * guic)
			sphere:SetColor(color)
			markers[xyz] = sphere
		end
	end

	function ChoGGi.ComFuncs.ShowPoint(obj, color)
		color = color or green
		-- single pt
		if IsPoint(obj) and InvalidPos ~= obj then
			AddSphere(obj,color)
			return
		end
		-- obj pt
		if IsValid(obj) then
			local pt = obj:GetVisualPos()
			if IsValid(obj) and InvalidPos ~= pt then
				AddSphere(pt,color)
				return
			end
		end
		-- two points
		if type(obj) ~= "table" then
			return
		end
		if IsPoint(obj[1]) and IsPoint(obj[2]) and InvalidPos ~= obj[1] and InvalidPos ~= obj[2] then
			local vector = ChoGGi_Vector:new()
			vector:Set(obj[1], obj[2], color)
			markers[vector] = "vector"
		end
	end

	function ChoGGi.ComFuncs.ShowObj(obj, color, skip_view, skip_colour)
		if markers[obj] then
			return
		end
		local is_valid = IsValid(obj)
		local is_point = IsPoint(obj)
		if not (is_valid or is_point) then
			return ClearShowObj()
		end
		color = color or green
		local vis_pos = is_valid and obj:GetVisualPos()

		local pt = is_point and obj or vis_pos
		if pt and pt ~= InvalidPos and not markers[pt] then
			AddSphere(pt,color)
		end

		if is_valid and not skip_colour then
			obj.ChoGGi_ShowObjColour = obj.ChoGGi_ShowObjColour or obj:GetColorModifier()
			markers[obj] = obj.ChoGGi_ShowObjColour
			obj:SetColorModifier(color)
		end

		pt = pt or vis_pos
		if not skip_view and pt ~= InvalidPos then
			ViewObjectMars(pt)
		end
	end
end -- do
local ShowObj = ChoGGi.ComFuncs.ShowObj
local ColourObj = ChoGGi.ComFuncs.ColourObj
local ClearShowObj = ChoGGi.ComFuncs.ClearShowObj

function ChoGGi.ComFuncs.PopupBuildMenu(items,popup)
	local g_Classes = g_Classes
	local ViewObjectMars = ViewObjectMars
	local IsPoint = IsPoint

	for i = 1, #items do
		local item = items[i]
		-- "ChoGGi_CheckButtonMenu"
		local cls = g_Classes[item.class or "ChoGGi_ButtonMenu"]

		local button = cls:new({
			TextColor = -16777216,
			RolloverTitle = item.hint_title and CheckText(item.hint_title,item.obj and RetName(item.obj) or S[126095410863--[[Info--]]]),
			RolloverText = CheckText(item.hint,""),
			RolloverHint = CheckText(item.hint_bottom,S[302535920000083--[[<left_click> Activate--]]]),
			Text = CheckText(item.name),
			Background = items.Background or cls.Background,
			PressedBackground = items.PressedBackground or cls.PressedBackground,
			TextStyle = items.TextStyle or cls.TextStyle,
		}, popup.idContainer)

		if item.image then
			button.idIcon:SetImage(item.image)
			if item.image_scale then
				button.idIcon:SetImageScale(IsPoint(item.image_scale) and item.image_scale or point(item.image_scale,item.image_scale))
			end
		end

		if item.clicked then
			function button.OnPress(...)
				cls.OnPress(...)
				item.clicked(...)
				popup:Close()
			end
		else
			function button.OnPress(...)
				cls.OnPress(...)
				popup:Close()
			end
		end

		if item.mousedown then
			function button.OnMouseButtonDown(...)
				cls.OnMouseButtonDown(...)
				item.mousedown(...)
				popup:Close()
			end
		end

		-- checkboxes (with a value (naturally))
		if item.value then

			local is_vis
			local value = DotNameToObject(item.value)

			-- dlgConsole.visible i think? damn me and my lazy commenting
			if type(value) == "table" then
				if value.visible then
					is_vis = true
				end
			else
				if value then
					is_vis = true
				end
			end

			-- oh yeah, you toggle that check
			if is_vis then
				button:SetCheck(true)
			else
				button:SetCheck(false)
			end
		end

		local showobj_func
		if item.showobj then
			showobj_func = function()
				ClearShowObj()
				ShowObj(item.showobj, nil, true)
			end
		end

		local colourobj_func
		if item.colourobj then
			colourobj_func = function()
				ClearShowObj()
				ColourObj(item.colourobj)
			end
		end

		local pos_func
		if item.pos then
			pos_func = function()
				ViewObjectMars(item.pos)
			end
		end

		-- my ugly submenu hack
		local submenu_func
		if item.submenu then
			local name = StringFormat("ChoGGi_submenu_%s",item.name)
			submenu_func = function(self)
				if popup[name] then
					popup[name]:Close()
				end
				popup[name] = g_Classes.ChoGGi_PopupList:new({
					Opened = true,
					Id = "ChoGGi_submenu_popup",
					popup_parent = popup,
					AnchorType = "smart",
					Anchor = self.box,
				}, terminal.desktop)
				ChoGGi.ComFuncs.PopupBuildMenu(item.submenu,popup[name])
				popup[name]:Open()
			end
		end

		-- add our mouseenter funcs
		if item.mouseover or showobj_func or colourobj_func or pos_func or submenu_func then
			function button:OnMouseEnter(pt, child,...)
				cls.OnMouseEnter(self, pt, child,...)
				if showobj_func then
					showobj_func()
				end
				if colourobj_func then
					colourobj_func()
				end
				if pos_func then
					pos_func()
				end
				if item.mouseover then
					item.mouseover(self, pt, child,...)
				end
				if submenu_func then
					submenu_func(self, pt, child,...)
				end
			end
		end
	end
end

function ChoGGi.ComFuncs.PopupToggle(parent,popup_id,items,anchor,reopen,submenu)
	local popup = PropObjGetProperty(terminal.desktop,popup_id)
	if popup then
		popup:Close()
		submenu = submenu or PropObjGetProperty(terminal.desktop,"ChoGGi_submenu_popup")
		if submenu then
			submenu:Close()
		end
	end

	if not parent then
		return
	end

	if not popup or reopen then

		popup = ChoGGi_PopupList:new({
			Opened = true,
			Id = popup_id,
			-- "top" for the console, default "none"
			AnchorType = anchor or "top",
			-- "none","smart","left","right","top","center-top","bottom","mouse"
			Anchor = parent.box,

		}, terminal.desktop)
		popup.items = items

		ChoGGi.ComFuncs.PopupBuildMenu(items,popup)

		-- hide popup when parent closes
		CreateRealTimeThread(function()
			while popup.window_state ~= "destroying" and parent.window_state ~= "destroying" do
				Sleep(500)
			end
			popup:Close()
		end)

		popup:Open()

	end

	-- if we need to fiddle with it
	return popup
end

-- show a circle for time and delete it
function ChoGGi.ComFuncs.Circle(pos, radius, color, time)
	local c = Circle:new()
	c:SetPos(pos and pos:SetTerrainZ(10 * guic) or GetTerrainCursor())
	c:SetRadius(radius or 1000)
	c:SetColor(color or white)
	DelayedCall(time or 50000, function()
		if IsValid(c) then
			c:delete()
		end
	end)
end

-- this is a question box without a question (WaitPopupNotification only works in-game, not main menu)
function ChoGGi.ComFuncs.MsgWait(text,title,image,ok_text,context,parent)
	CreateRealTimeThread(function()
		local dlg = CreateMarsQuestionBox(
			CheckText(title,S[1000016--[[Title--]]]),
			CheckText(text,S[3718--[[NONE--]]]),
			CheckText(ok_text,S[6878--[[OK--]]]),
			"",
			parent,
			image,
			context
		)
		-- hide cancel button since we don't care about it, and we ignore them anyways...
		dlg.idList[2]:delete()
	end)
end

-- well that's the question isn't it?
function ChoGGi.ComFuncs.QuestionBox(text,func,title,ok_msg,cancel_msg,image,context,parent)
	-- thread needed for WaitMarsQuestion
	CreateRealTimeThread(function()
		if WaitMarsQuestion(
			parent,
			CheckText(title,S[1000016--[[Title--]]]),
			CheckText(text,S[3718--[[NONE--]]]),
			CheckText(ok_msg,S[6878--[[OK--]]]),
			CheckText(cancel_msg,S[6879--[[Cancel--]]]),
			image or StringFormat("%sUI/message_picture_01.png",ChoGGi.library_path),
			context
		) == "ok" then
			if func then
				func(true)
			end
			return "ok"
		else
			-- user canceled / closed it
			if func then
				func()
			end
			return "cancel"
		end
	end)
end

-- positive or 1 return TrueVar || negative or 0 return FalseVar
-- ChoGGi.Consts.X = ChoGGi.ComFuncs.NumRetBool(ChoGGi.Consts.X,0,ChoGGi.Consts.X)
function ChoGGi.ComFuncs.NumRetBool(num,true_var,false_var)
	if type(num) ~= "number" then
		return
	end
	local bool = true
	if num < 1 then
		bool = false
	end
	return bool and true_var or false_var
end

-- return opposite value or first value if neither
function ChoGGi.ComFuncs.ValueRetOpp(setting,value1,value2)
	if setting == value1 then
		return value2
	elseif setting == value2 then
		return value1
	end
	--just in case
	return value1
end

-- return as num
function ChoGGi.ComFuncs.BoolRetNum(bool)
	if bool == true then
		return 1
	end
	return 0
end

-- toggle 0/1
function ChoGGi.ComFuncs.ToggleBoolNum(n)
	if n == 0 then
		return 1
	end
	return 0
end

-- toggle true/nil (so it doesn't add setting to file as = false
function ChoGGi.ComFuncs.ToggleValue(value)
	if value then
		return
	end
	return true
end

-- return equal or higher amount
function ChoGGi.ComFuncs.CompareAmounts(a,b)
	--if ones missing then just return the other
	if not a then
		return b
	elseif not b then
		return a
	--else return equal or higher amount
	elseif a >= b then
		return a
	elseif b >= a then
		return b
	end
end

-- compares two values, if types are different then makes them both strings
--[[
		if sort[a] and sort[b] then
			return sort[a] < sort[b]
		end
		if sort[a] or sort[b] then
			return sort[a] and true
		end
		return CmpLower(a, b)
--]]

--[[
	table.sort(Items,function(a,b)
		return ChoGGi.ComFuncs.CompareTableValue(a,b,"text")
	end)
--]]
function ChoGGi.ComFuncs.CompareTableValue(a,b,name)
	if not a and not b then
		return
	end
--~ 	if type(a[name]) == type(b[name]) then
--~ 		return a[name] < b[name]
--~ 	else
		return tostring(a[name]) < tostring(b[name])
--~ 	end
end

--[[
table.sort(s.command_centers, function(a,b)
	return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",s)
end)
--]]
function ChoGGi.ComFuncs.CompareTableFuncs(a,b,func,obj)
	if not a and not b then
		return
	end
	if obj then
		return obj[func](obj,a) < obj[func](obj,b)
	else
		return a[func](a,b) < b[func](b,a)
	end
end

-- ChoGGi.ComFuncs.PrintIds(Object)
function ChoGGi.ComFuncs.PrintIds(list)
	if type(list) ~= "table" then
		return
	end
	local text = ""

	for i = 1, #list do
		text = StringFormat("%s----------------- %s: %s%s",text,list[i].id,i,ChoGGi.newline)
		for j = 1, #list[i] do
			text = StringFormat("%s%s: %s%s",text,list[i][j].id,j,ChoGGi.newline)
		end
	end

	ChoGGi.ComFuncs.Dump(text)
end

-- check for and remove broken objects from UICity.labels
function ChoGGi.ComFuncs.RemoveMissingLabelObjects(label)
	local UICity = UICity
	local list = UICity.labels[label] or ""
	for i = #list, 1, -1 do
		if not IsValid(list[i]) then
			TableRemove(UICity.labels[label],i)
		end
	end
end

function ChoGGi.ComFuncs.RemoveMissingTableObjects(list,obj)
	if obj then
		for i = #list, 1, -1 do
			if #list[i][list] == 0 then
				TableRemove(list,i)
			end
		end
	else
		for i = #list, 1, -1 do
			if not IsValid(list[i]) then
				TableRemove(list,i)
			end
		end
	end
	return list
end

function ChoGGi.ComFuncs.RemoveFromLabel(label,obj)
	local UICity = UICity
	local list = UICity.labels[label] or ""
	for i = 1, #list do
		if list[i] and list[i].handle and list[i] == obj.handle then
			TableRemove(UICity.labels[label],i)
		end
	end
end

function toboolean(str)
	if str == "true" then
		return true
	elseif str == "false" then
		return false
	end
--~ 	return 0/0
end

-- tries to convert "65" to 65, "boolean" to boolean, "nil" to nil, or just returns "str" as "str"
function ChoGGi.ComFuncs.RetProperType(value)
	-- number?
	local num = tonumber(value)
	if num then
		return num,"number"
	end
	-- stringy boolean
	if value == "true" or value == true then
		return true,"boolean"
	elseif value == "false" or value == false then
		return false,"boolean"
	end
	-- nadda
	if value == "nil" then
		return nil,"nil"
	end
	-- then it's a string (probably)
	return value,"string"
end

do -- RetType
	-- used to check for some SM objects (Points/Boxes)
	local IsBox = IsBox
	local IsPoint = IsPoint
	function ChoGGi.ComFuncs.RetType(obj)
		if getmetatable(obj) then
			if IsPoint(obj) then
				return "Point"
			end
			if IsBox(obj) then
				return "Box"
			end
		end
	end
end -- do

-- takes "example1 example2" and returns {[1] = "example1",[2] = "example2"}
function ChoGGi.ComFuncs.StringToTable(str)
	local temp = {}
	for i in str:gmatch("%S+") do
		temp[i] = i
	end
	return temp
end

--[[
ChoGGi.ComFuncs.ReturnTechAmount(Tech,Prop)
returns number from Object (so you know how much it changes)
see: Data/Object.lua, or ex(Object)

ChoGGi.ComFuncs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
^returns 10
ChoGGi.ComFuncs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
^ returns 0.7

it returns percentages in decimal for ease of mathing (SM has no math. funcs)
ie: SupportiveCommunity is -70 this returns it as 0.7
it also returns negative amounts as positive (I prefer num - Amt, not num + NegAmt)
--]]
function ChoGGi.ComFuncs.ReturnTechAmount(tech,prop)
	local techdef = TechDef[tech]
	local idx = table.find(techdef,"Prop",prop)
	if idx then
		tech = techdef[idx]
		local number

		-- With enemies you know where they stand but with Neutrals, who knows?
		-- defaults for the objects have both percent/amount, so whoever isn't 0 means something
		if tech.Percent == 0 then
			if tech.Amount < 0 then
				number = tech.Amount * -1 -- always gotta be positive
			else
				number = tech.Amount
			end
		-- probably just have an else here instead...
		elseif tech.Amount == 0 then
			if tech.Percent < 0 then
				tech.Percent = tech.Percent * -1 -- -50 > 50
			end
			number = (tech.Percent + 0.0) / 100 -- (50 > 50.0) > 0.50
		end

		return number
	end
end

-- value is ChoGGi.UserSettings.name
function ChoGGi.ComFuncs.SetConstsG(name,value)
	-- we only want to change it if user set value
	if value then
		-- some mods check Consts or g_Consts, so we'll just do both to be sure
		Consts[name] = value
		g_Consts[name] = value
	end
end

-- if value is the same as stored then make it false instead of default value, so it doesn't apply next time
function ChoGGi.ComFuncs.SetSavedSetting(setting,value)
	local ChoGGi = ChoGGi
	--if setting is the same as the default then remove it
	if ChoGGi.Consts[setting] == value then
		ChoGGi.UserSettings[setting] = nil
	else
		ChoGGi.UserSettings[setting] = value
	end
end

function ChoGGi.ComFuncs.RetTableNoDupes(list)
	if type(list) ~= "table" then
		return {}
	end
	local c = 0
	local temp_t = {}
	local dupe_t = {}

	for i = 1, #list do
		if not dupe_t[list[i]] then
			c = c + 1
			temp_t[c] = list[i]
			dupe_t[list[i]] = true
		end
	end

	return temp_t
end
local RetTableNoDupes = ChoGGi.ComFuncs.RetTableNoDupes

function ChoGGi.ComFuncs.RetTableNoClassDupes(list)
	if type(list) ~= "table" then
		return empty_table
	end
	local CompareTableValue = ChoGGi.ComFuncs.CompareTableValue
	table.sort(list,function(a,b)
		return CompareTableValue(a,b,"class")
	end)
	local tempt = {}
	local dupe = {}
	local c = 0

	for i = 1, #list do
		if not dupe[list[i].class] then
			c = c + 1
			tempt[c] = list[i]
			dupe[list[i].class] = true
		end
	end
	return tempt
end

-- ChoGGi.ComFuncs.RemoveFromTable(sometable,"class","SelectionArrow")
function ChoGGi.ComFuncs.RemoveFromTable(list,cls,text)
	if type(list) ~= "table" then
		return empty_table
	end
	local tempt = {}
	local c = 0

	list = list or ""
	for i = 1, #list do
		if list[i][cls] ~= text then
			c = c + 1
			tempt[c] = list[i]
		end
	end
	return tempt
end

-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Building,{ParSystem = true,ResourceStockpile = true},nil,"class")
-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Unit,nil,nil,"working")
function ChoGGi.ComFuncs.FilterFromTable(list,exclude_list,include_list,name)
	if type(list) ~= "table" then
		return empty_table
	end
	return MapFilter(list,function(o)
		if exclude_list or include_list then
			if exclude_list and include_list then
				if not exclude_list[o[name]] then
					return true
				elseif include_list[o[name]] then
					return true
				end
			elseif exclude_list then
				if not exclude_list[o[name]] then
					return true
				end
			elseif include_list then
				if include_list[o[name]] then
					return true
				end
			end
		else
			if o[name] then
				return true
			end
		end
	end)
end

-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Building,"IsKindOf","Residence")
-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Unit,"IsValid",nil,true)
function ChoGGi.ComFuncs.FilterFromTableFunc(list,func,value,is_bool)
	if type(list) ~= "table" then
		return {}
	end
	return MapFilter(list,function(o)
		if is_bool then
			if _G[func](o) then
				return true
			end
		elseif o[func](o,value) then
			return true
		end
	end)
end

function ChoGGi.ComFuncs.OpenInMultiLineTextDlg(context)
	if not context then
		return
	end

	return ChoGGi_MultiLineTextDlg:new({}, terminal.desktop,context)
end

function ChoGGi.ComFuncs.OpenInListChoice(list)
	-- if list isn't a table or it has zero items or it doesn't have items/callback func
	local list_table = type(list) == "table"
	local items_table = type(list_table and list.items) == "table"
	if not list_table or list_table and not items_table or items_table and #list.items < 1 then
		print(S[302535920001324--[[ECM: OpenInListChoice(list) is blank... This shouldn't happen.--]]],"\n",list,"\n",list and ObjPropertyListToLuaCode(list))
		return
	end

	return ChoGGi_ListChoiceDlg:new({}, terminal.desktop,{
		list = list,
	})
end

-- i keep forgetting this so, i'm adding it here
function ChoGGi.ComFuncs.HandleToObject(h)
	return HandleToObject[h]
end

-- return a string setting/text for menus
function ChoGGi.ComFuncs.SettingState(setting,text)

	if type(setting) == "string" and setting:find("%.") then
		-- some of the menu items passed are "table.table.exists?.setting"
		local obj = ChoGGi.ComFuncs.DotNameToObject(setting)
		if obj then
			setting = obj
		else
			setting = false
		end
	end

	-- have it return false instead of nil
	if type(setting) == "nil" then
		setting = false
	end

	if text then
		return StringFormat("%s: %s",setting,CheckText(S[text],text))
	else
		return tostring(setting)
	end
end

-- Copyright L. H. de Figueiredo, W. Celes, R. Ierusalimschy: Lua Programming Gems
function ChoGGi.ComFuncs.VarDump(value, depth, key)
	local ChoGGi = ChoGGi
	local linePrefix = ""
	local spaces = ""
	local v_type = type(value)
	if key ~= nil then
		linePrefix = "["..key.."] = "
	end
	if depth == nil then
		depth = 0
	else
		depth = depth + 1
		for _ = 1, depth do
			spaces = StringFormat("%s ",spaces)
		end
	end
	if v_type == "table" then
		local mTable = getmetatable(value)
		if mTable == nil then
			print(spaces,linePrefix,"(table) ")
		else
			print(spaces,"(metatable) ")
			value = mTable
		end
		for tableKey, tableValue in pairs(value) do
			ChoGGi.ComFuncs.VarDump(tableValue, depth, tableKey)
		end
	elseif v_type == "function"
		or v_type == "thread"
		or v_type == "userdata"
		or value == nil
		then
			print(spaces,tostring(value))
	else
		print(spaces,linePrefix,"(",v_type,") ",tostring(value))
	end
end


function ChoGGi.ComFuncs.RetBuildingPermissions(traits,settings)
	settings.restricttraits = settings.restricttraits or {}
	settings.blocktraits = settings.blocktraits or {}
	traits = traits or {}
	local block,restrict

	local rtotal = 0
	for _,_ in pairs(settings.restricttraits) do
		rtotal = rtotal + 1
	end

	local rcount = 0
	for trait,_ in pairs(traits) do
		if settings.restricttraits[trait] then
			rcount = rcount + 1
		end
		if settings.blocktraits[trait] then
			block = true
		end
	end

	-- restrict is empty so allow all or since we're restricting then they need to be the same
	if not next(settings.restricttraits) or rcount == rtotal then
		restrict = true
	end

	return block,restrict
end

-- get all objects, then filter for ones within *radius*, returned sorted by dist, or *sort* for name
-- ChoGGi.ComFuncs.OpenInExamineDlg(ReturnAllNearby(1000,"class"))
function ChoGGi.ComFuncs.ReturnAllNearby(radius,sort,pt)
	radius = radius or 5000
	pt = pt or GetTerrainCursor()

	-- get all objects within radius
	local list = MapGet(pt,radius)

	-- sort list custom
	if sort then
		table.sort(list,function(a,b)
			return a[sort] < b[sort]
		end)
	else
		-- sort nearest
		table.sort(list,function(a,b)
			return a:GetDist2D(pt) < b:GetDist2D(pt)
		end)
	end

	return list
end

do -- RetObjectAtPos/RetObjectsAtPos
	local WorldToHex = WorldToHex
	local HexGridGetObject = HexGridGetObject
	local HexGridGetObjects = HexGridGetObjects

	-- q can be pt or q
	function ChoGGi.ComFuncs.RetObjectAtPos(q,r)
		if not r then
			q, r = WorldToHex(q)
		end
		return HexGridGetObject(ObjectGrid, q, r)
	end

	function ChoGGi.ComFuncs.RetObjectsAtPos(q,r)
		if not r then
			q, r = WorldToHex(q)
		end
		return HexGridGetObjects(ObjectGrid, q, r)
	end
end -- do

function ChoGGi.ComFuncs.RetSortTextAssTable(list,for_type)
	local temp_table = {}
	local c = 0
	list = list or empty_table

	-- add
	if for_type then
		for k,_ in pairs(list) do
			c = c + 1
			temp_table[c] = k
		end
	else
		for _,v in pairs(list) do
			c = c + 1
			temp_table[c] = v
		end
	end

	-- and send back sorted
	table.sort(temp_table)
	return temp_table
end

do -- Ticks
	local times = {}
	local GetPreciseTicks = GetPreciseTicks

	function ChoGGi.ComFuncs.TickStart(id)
		times[id] = GetPreciseTicks()
	end
	function ChoGGi.ComFuncs.TickEnd(id,name)
		print(id,":",GetPreciseTicks() - times[id],name)
		times[id] = nil
	end
end -- do

function ChoGGi.ComFuncs.UpdateDataTablesCargo()
	local Tables = ChoGGi.Tables

	-- update cargo resupply
	Tables.Cargo = {}
	local ResupplyItemDefinitions = ResupplyItemDefinitions
	for i = 1, #ResupplyItemDefinitions do
		local def = ResupplyItemDefinitions[i]
		Tables.Cargo[i] = def
		Tables.Cargo[def.id] = def
	end

	local settings = ChoGGi.UserSettings.CargoSettings or {}
	for id,cargo in pairs(settings) do
		if Tables.Cargo[id] then
			if cargo.pack then
				Tables.Cargo[id].pack = cargo.pack
			end
			if cargo.kg then
				Tables.Cargo[id].kg = cargo.kg
			end
			if cargo.price then
				Tables.Cargo[id].price = cargo.price
			end
			if type(cargo.locked) == "boolean" then
				Tables.Cargo[id].locked = cargo.locked
			end
		end
	end
end
do -- UpdateDataTables
	-- I should look around for a way
	local mystery_images = {
		MarsgateMystery = "UI/Messages/marsgate_mystery_01.tga",
		BlackCubeMystery = "UI/Messages/power_of_three_mystery_01.tga",
		LightsMystery = "UI/Messages/elmos_fire_mystery_01.tga",
		AIUprisingMystery = "UI/Messages/artificial_intelligence_mystery_01.tga",
		UnitedEarthMystery = "UI/Messages/beyond_earth_mystery_01.tga",
		TheMarsBug = "UI/Messages/wildfire_mystery_01.tga",
		WorldWar3 = "UI/Messages/the_last_war_mystery_01.tga",
		MetatronMystery = "UI/Messages/metatron_mystery_01.tga",
		DiggersMystery = "UI/Messages/dredgers_mystery_01.tga",
		DreamMystery = "UI/Messages/inner_light_mystery_01.tga",
		CrystalsMystery = "UI/Messages/phylosophers_stone_mystery_01.tga",
		MirrorSphereMystery = "UI/Messages/sphere_mystery_01.tga",
	}

	function ChoGGi.ComFuncs.UpdateDataTables()
		local Tables = ChoGGi.Tables
		local c = 0

		Tables.Mystery = {}
		Tables.NegativeTraits = {}
		Tables.PositiveTraits = {}
		Tables.OtherTraits = {}
		Tables.ColonistAges = {}
		Tables.ColonistGenders = {}
		Tables.ColonistSpecializations = {}
		Tables.ColonistBirthplaces = {}
		Tables.Resources = {}
		Tables.SchoolTraits = const.SchoolTraits
		Tables.SanatoriumTraits = const.SanatoriumTraits

------------- mysteries
		c = 0
		-- build mysteries list (sometimes we need to reference Mystery_1, sometimes BlackCubeMystery
		local g_Classes = g_Classes
		ClassDescendantsList("MysteryBase",function(class)
			local scenario_name = g_Classes[class].scenario_name or S[302535920000009--[[Missing Scenario Name--]]]
			local display_name = Trans(g_Classes[class].display_name) or S[302535920000010--[[Missing Name--]]]
			local description = Trans(g_Classes[class].rollover_text) or S[302535920000011--[[Missing Description--]]]

			local temptable = {
				class = class,
				number = scenario_name,
				name = display_name,
				description = description,
				image = mystery_images[class],
			}
			-- we want to be able to access by for loop, Mystery 7, and WorldWar3
			Tables.Mystery[scenario_name] = temptable
			Tables.Mystery[class] = temptable
			c = c + 1
			Tables.Mystery[c] = temptable
		end)

----------- colonists
		--add as index and associative tables for ease of filtering
		local c1,c2,c3,c4,c5,c6 = 0,0,0,0,0,0
		local TraitPresets = TraitPresets
		for id,t in pairs(TraitPresets) do
			if t.group == "Positive" then
				c1 = c1 + 1
				Tables.PositiveTraits[c1] = id
				Tables.PositiveTraits[id] = true
			elseif t.group == "Negative" then
				c2 = c2 + 1
				Tables.NegativeTraits[c2] = id
				Tables.NegativeTraits[id] = true
			elseif t.group == "other" then
				c3 = c3 + 1
				Tables.OtherTraits[c3] = id
				Tables.OtherTraits[id] = true
			elseif t.group == "Age Group" then
				c4 = c4 + 1
				Tables.ColonistAges[c4] = id
				Tables.ColonistAges[id] = true
			elseif t.group == "Gender" then
				c5 = c5 + 1
				Tables.ColonistGenders[c5] = id
				Tables.ColonistGenders[id] = true
			elseif t.group == "Specialization" and id ~= "none" then
				c6 = c6 + 1
				Tables.ColonistSpecializations[c6] = id
				Tables.ColonistSpecializations[id] = true
			end
		end

		local Nations = Nations
		for i = 1, #Nations do
			local temptable = {
				flag = Nations[i].flag,
				text = Nations[i].text,
				value = Nations[i].value,
			}
			if Nations[i].value == "Mars" then
				-- eh, close enough
				temptable.flag = "UI/Flags/flag_northkorea.tga"
			end
			Tables.ColonistBirthplaces[i] = temptable
			Tables.ColonistBirthplaces[Nations[i].value] = temptable
		end

------------- cargo

		-- used to check defaults for cargo
		Tables.CargoPresets = {}
		c = 0
		local CargoPreset = CargoPreset
		for cargo_id,cargo in pairs(CargoPreset) do
			c = c + 1
			Tables.CargoPresets[c] = cargo
			Tables.CargoPresets[cargo_id] = cargo
		end

-------------- resources
		local AllResourcesList = AllResourcesList
		for i = 1, #AllResourcesList do
			Tables.Resources[i] = AllResourcesList[i]
			Tables.Resources[AllResourcesList[i]] = true
		end
	end
end -- do

function ChoGGi.ComFuncs.Random(m, n)
	if n then
		-- m = min, n = max
		return AsyncRand(n - m + 1) + m
	else
		-- m = max, min = 0 OR number between 0 and max_int
		return m and AsyncRand(m) or AsyncRand()
	end
end
local Random = ChoGGi.ComFuncs.Random

--~ function ChoGGi.ComFuncs.OpenKeyPresserDlg()
--~ 	ChoGGi_KeyPresserDlg:new({}, terminal.desktop,{})
--~ end

function ChoGGi.ComFuncs.CreateSetting(str,setting_type)
	local setting = ChoGGi.ComFuncs.DotNameToObject(str,nil,true)
	if type(setting) == setting_type then
		return true
	end
end

-- returns whatever is selected > moused over > nearest object to cursor
function ChoGGi.ComFuncs.SelObject(radius)
	-- just in case it's called from main menu
	if not UICity then
		return
	end
	local obj = SelectedObj or SelectionMouseObj()
	if not obj then
		local pt = GetTerrainCursor()
		obj = MapFindNearest(pt,pt,radius or 1500)
	end
	return obj
end

do -- Rebuildshortcuts
	-- we want to only remove certain actions from the actual game, not ones added by modders, so list building time...
	local remove_lookup = {
		ChangeMapEmpty = true,
		ChangeMapPocMapAlt1 = true,
		ChangeMapPocMapAlt2 = true,
		ChangeMapPocMapAlt3 = true,
		ChangeMapPocMapAlt4 = true,
		Cheats = true,

		["Cheats.StoryBits"] = true,
		CheatSpawnPlanetaryAnomalies = true,

		["Cheats.Change Map"] = true,
		["Cheats.Map Exploration"] = true,
		["Cheats.Research"] = true,
		["Cheats.Spawn Colonist"] = true,
		["Cheats.Start Mystery"] = true,
		["Cheats.Trigger Disaster"] = true,
		["Cheats.Trigger Disaster Cold Wave"] = true,
		["Cheats.Trigger Disaster Dust Devil"] = true,
		["Cheats.Trigger Disaster Dust Devil Major"] = true,
		["Cheats.Trigger Disaster Dust Storm"] = true,
		["Cheats.Trigger Disaster Dust Storm Electrostatic"] = true,
		["Cheats.Trigger Disaster Dust Storm Great"] = true,
		["Cheats.Trigger Disaster Meteor"] = true,
		["Cheats.Trigger Disaster Meteor Multi Spawn"] = true,
		["Cheats.Trigger Disaster Meteor Storm"] = true,
		["Cheats.Workplaces"] = true,
		-- debug stuff that doesn't work
		DbgToggleBuildableGrid = true,
		MapSettingsEditor = true,
		DE_HexBuildGridToggle = true,
		DE_ToggleTerrainDepositGrid = true,
		actionPOCMapAlt0 = true,
		actionPOCMapAlt1 = true,
		actionPOCMapAlt2 = true,
		actionPOCMapAlt3 = true,
		actionPOCMapAlt4 = true,
		actionPOCMapAlt5 = true,
		-- added in kuiper modders beta (uses tilde to toggle menu instead of f2)
		DE_Menu = true,
		-- i need to override so i can reset zoom and other settings.
		FreeCamera = true,
		-- we def don't want this
		G_CompleteConstructions = true,
		-- I got my own bindable version
		G_ToggleInGameInterface = true,
		G_ToggleSigns = true,
		-- not cheats
--~ 		G_ToggleOnScreenHints = true,
--~ 		G_UnpinAll = true,
		G_AddFunding = true,
		G_CheatClearForcedWorkplaces = true,
		G_CheatUpdateAllWorkplaces = true,
		G_CompleteWiresPipes = true,
		G_ModsEditor = true,
		-- maybe this is used somewhere, hard to call it a cheat...
		G_OpenPregameMenu = true,
		G_ResearchAll = true,
		G_ResearchCurrent = true,
		G_ResetOnScreenHints = true,
		G_ToggleAllShifts = true,
		G_ToggleInfopanelCheats = true,
		G_UnlockAllBuildings = true,
		["G_UnlockАllТech"] = true,
		MapExplorationDeepScan = true,
		MapExplorationScan = true,
		SpawnColonist1 = true,
		SpawnColonist10 = true,
		SpawnColonist100 = true,
		StartMysteryAIUprisingMystery = true,
		StartMysteryBlackCubeMystery = true,
		StartMysteryCrystalsMystery = true,
		StartMysteryDiggersMystery = true,
		StartMysteryDreamMystery = true,
		StartMysteryLightsMystery = true,
		StartMysteryMarsgateMystery = true,
		StartMysteryMetatronMystery = true,
		StartMysteryMirrorSphereMystery = true,
		StartMysteryTheMarsBug = true,
		StartMysteryUnitedEarthMystery = true,
		StartMysteryWorldWar3 = true,
		TriggerDisasterColdWave = true,
		TriggerDisasterDustDevil = true,
		TriggerDisasterDustDevilMajor = true,
		TriggerDisasterDustStormElectrostatic = true,
		TriggerDisasterDustStormGreat = true,
		TriggerDisasterDustStormNormal = true,
		TriggerDisasterMeteorsMultiSpawn = true,
		TriggerDisasterMeteorsSingle = true,
		TriggerDisasterMeteorsStorm = true,
		TriggerDisasterStop = true,
		UnlockAllBreakthroughs = true,
		UpsampledScreenshot = true,
		DE_ToggleScreenshotInterface = true,
		-- EditorShortcuts.lua
		EditOpsHistory = true,
		["Editors.Random Map"] = true,
		DE_SaveDefaultMapEntityList = true,
		E_TurnSelectionToTemplates = true,
		DE_SaveDefaultMap = true,
		Editors = true,
		-- CommonShortcuts.lua
		DE_Console = true,
		DisableUIL = true,
		DE_UpsampledScreenshot = true,
		DE_Screenshot = true,
		DE_BugReport = true,
		Tools = true,
		["Tools.Extras"] = true,
	}
	local removekey_lookup = {
		E_FlagsEditor = true,
		E_AttachEditor = true,
		CheckGameRevision = true,
		E_ResetZRelative = true,
		E_SmoothBrush = true,
		E_PlaceObjectsAdd = true,
		E_DeleteObjects = true,
		E_MoveGizmo = true,
	}

	-- auto-add all the TriggerDisaster ones (ok some)
	local DataInstances = DataInstances
	local function AddItems(name,suffix)
		local list = DataInstances[name]
		for i = 1, #list do
			remove_lookup[string.format("TriggerDisaster%s%s",list[i].name,suffix or "")] = true
		end
	end
	AddItems("MapSettings_DustDevils")
	AddItems("MapSettings_DustDevils","Major")
	AddItems("MapSettings_DustStorm")
	AddItems("MapSettings_DustStorm","Great")
	AddItems("MapSettings_DustStorm","Electrostatic")
	AddItems("MapSettings_ColdWave")
	AddItems("MapSettings_Meteor")
	AddItems("MapSettings_Meteor","MultiSpawn")
	AddItems("MapSettings_Meteor","Storm")

	function ChoGGi.ComFuncs.Rebuildshortcuts()
		local XShortcutsTarget = XShortcutsTarget

		-- remove unwanted actions
		for i = #XShortcutsTarget.actions, 1, -1 do
			local a = XShortcutsTarget.actions[i]
			if a.ChoGGi_ECM or remove_lookup[a.ActionId] then
				a:delete()
				TableRemove(XShortcutsTarget.actions,i)
--~ 			else
--~ 				-- hide any menuitems added from devs
--~ 				a.ActionMenubar = nil
--~ 				print(a.ActionId)
			elseif removekey_lookup[a.ActionId] then
				a.ActionShortcut = nil
				a.ActionShortcut2 = nil
			end
		end

		-- goddamn annoying key
		if testing then
			local idx = table.find(XShortcutsTarget.actions,"ActionId","actionToggleFullscreen")
			if idx then
				XShortcutsTarget.actions[idx]:delete()
				TableRemove(XShortcutsTarget.actions,idx)
			end
		end

		-- and add mine
		local XAction = XAction
		local Actions = ChoGGi.Temp.Actions

--~ 		Actions = {}
--~ 		Actions[#Actions+1] = {
--~ 			ActionId = "ChoGGi_ShowConsole",
--~ 			OnAction = function()
--~ 				local dlgConsole = dlgConsole
--~ 				if dlgConsole then
--~ 					ShowConsole(not dlgConsole:GetVisible())
--~ 				end
--~ 			end,
--~ 			ActionShortcut = "~",
--~ 			ActionShortcut2 = "Enter",
--~ 		}

		local DisableECM = ChoGGi.UserSettings.DisableECM
		for i = 1, #Actions do
			local a = Actions[i]
			-- added by ECM
			if a.ChoGGi_ECM then
				-- can we enable ECM actions?
				if not DisableECM then
					-- and add to the actual actions
					XShortcutsTarget:AddAction(XAction:new(a))
				end
			else
				XShortcutsTarget:AddAction(XAction:new(a))
			end
		end

		if DisableECM then
		-- add a key binding to options to re-enable ECM
			local name = StringFormat("%s %s",S[302535920001079--[[Enable--]]],S[302535920000887--[[ECM--]]])
			XShortcutsTarget:AddAction(XAction:new{
				ActionName = name,
				ActionId = name,
				OnAction = function()
					ChoGGi.UserSettings.DisableECM = false
					ChoGGi.SettingFuncs.WriteSettings()
					print(name,S[302535920001070--[[Restart to take effect.--]]])
					MsgPopup(
						302535920001070--[[Restart to take effect.--]],
						name
					)
				end,
				ActionShortcut = "Ctrl-Shift-0",
				ActionBindable = true,
			})
			print(S[302535920001411--[[ECM has been disabled. Change DisableECM to false in settings file.--]]])
		end

		-- add rightclick action to menuitems
		XShortcutsTarget:UpdateToolbar()
		-- got me
		XShortcutsThread = false

		if DisableECM == false then
			-- i forget why i'm toggling this...
			local dlgConsole = dlgConsole
			if dlgConsole then
				ShowConsole(not dlgConsole:GetVisible())
				ShowConsole(not dlgConsole:GetVisible())
			end
		end
	end
end -- do

do -- RetThreadInfo/FindThreadFunc
	local GedInspectorFormatObject = GedInspectorFormatObject
	local IsValidThread = IsValidThread
	-- returns some info if blacklist enabled
	function ChoGGi.ComFuncs.RetThreadInfo(thread)
		if not IsValidThread then
			return
		end
		-- needs an empty table to work it's magic
		GedInspectedObjects[thread] = {}
		-- returns a table of the funcs in the thread
		local threads = GedInspectorFormatObject(thread).members
		-- build a list of func name / level
		local funcs = {}
		local c = 0
		for i = 1, #threads do
			c = c + 1
			funcs[c] = {level = false,func = false}

			for key,value in pairs(threads[i]) do
				if key == "key" then
					funcs[c].level = value
				elseif key == "value" then
					funcs[c].func = value
				end
			end
		end
		-- and last we merge it all into a string to return
		local str = ""
		for i = 1, #funcs do
			str = StringFormat("%s\n%s < debug.getinfo(%s)",str,funcs[i].func,funcs[i].level)
		end
		return str:sub(2)
	end

	-- find/return func if str in func name
	function ChoGGi.ComFuncs.FindThreadFunc(thread,str)
		-- needs an empty table to work it's magic
		GedInspectedObjects[thread] = {}
		-- returns a table of the funcs in the thread
		local threads = GedInspectorFormatObject(thread).members
		for i = 1, #threads do
			for key,value in pairs(threads[i]) do
				if key == "value" and value:find_lower(str,1,true) then
					return value
				end
			end
		end
	end

end -- do

do -- GetResearchedTechValue
	-- we check if tech is researched before we return value
	local funcs_table = {
		SpeedDrone = function()
			local move_speed = ChoGGi.Consts.SpeedDrone

			if UICity:IsTechResearched("LowGDrive") then
				local p = ChoGGi.ComFuncs.ReturnTechAmount("LowGDrive","move_speed")
				move_speed = move_speed + (move_speed * p)
			end
			if UICity:IsTechResearched("AdvancedDroneDrive") then
				local p = ChoGGi.ComFuncs.ReturnTechAmount("AdvancedDroneDrive","move_speed")
				move_speed = move_speed + (move_speed * p)
			end

			return move_speed
		end,
		--
		MaxColonistsPerRocket = function()
			local per_rocket = ChoGGi.Consts.MaxColonistsPerRocket
			if UICity:IsTechResearched("CompactPassengerModule") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket")
				per_rocket = per_rocket + a
			end
			if UICity:IsTechResearched("CryoSleep") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
				per_rocket = per_rocket + a
			end
			return per_rocket
		end,
		--
		FuelRocket = function()
			if UICity:IsTechResearched("AdvancedMartianEngines") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("AdvancedMartianEngines","launch_fuel")
				return ChoGGi.Consts.LaunchFuelPerRocket - (a * ChoGGi.Consts.ResourceScale)
			end
			return ChoGGi.Consts.LaunchFuelPerRocket
		end,
		--
		SpeedRC = function()
			if UICity:IsTechResearched("LowGDrive") then
				local p = ChoGGi.ComFuncs.ReturnTechAmount("LowGDrive","move_speed")
				return ChoGGi.Consts.SpeedRC + ChoGGi.Consts.SpeedRC * p
			end
			return ChoGGi.Consts.SpeedRC
		end,
		--
		CargoCapacity = function()
			if UICity:IsTechResearched("FuelCompression") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("FuelCompression","CargoCapacity")
				return ChoGGi.Consts.CargoCapacity + a
			end
			return ChoGGi.Consts.CargoCapacity
		end,
		--
		CommandCenterMaxDrones = function()
			if UICity:IsTechResearched("DroneSwarm") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones")
				return ChoGGi.Consts.CommandCenterMaxDrones + a
			end
			return ChoGGi.Consts.CommandCenterMaxDrones
		end,
		--
		DroneResourceCarryAmount = function()
			if UICity:IsTechResearched("ArtificialMuscles") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount")
				return ChoGGi.Consts.DroneResourceCarryAmount + a
			end
			return ChoGGi.Consts.DroneResourceCarryAmount
		end,
		--
		LowSanityNegativeTraitChance = function()
			if UICity:IsTechResearched("SupportiveCommunity") then
				local p = ChoGGi.ComFuncs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
				--[[
				LowSanityNegativeTraitChance = 30%
				SupportiveCommunity = -70%
				--]]
				local LowSan = ChoGGi.Consts.LowSanityNegativeTraitChance + 0.0 --SM has no math.funcs so + 0.0
				return p*LowSan/100*100
			end
			return ChoGGi.Consts.LowSanityNegativeTraitChance
		end,
		--
		NonSpecialistPerformancePenalty = function()
			if UICity:IsTechResearched("GeneralTraining") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
				return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
			end
			return ChoGGi.Consts.NonSpecialistPerformancePenalty
		end,
		--
		RCRoverMaxDrones = function()
			if UICity:IsTechResearched("RoverCommandAI") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones")
				return ChoGGi.Consts.RCRoverMaxDrones + a
			end
			return ChoGGi.Consts.RCRoverMaxDrones
		end,
		--
		RCTransportGatherResourceWorkTime = function()
			if UICity:IsTechResearched("TransportOptimization") then
				local p = ChoGGi.ComFuncs.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime")
				return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
			end
			return ChoGGi.Consts.RCTransportGatherResourceWorkTime
		end,
		--
		RCTransportStorageCapacity = function(cls)
			local amount = cls == "RCConstructor" and ChoGGi.Consts.RCConstructorStorageCapacity or ChoGGi.Consts.RCTransportStorageCapacity

			if UICity:IsTechResearched("TransportOptimization") then
				local a = ChoGGi.ComFuncs.ReturnTechAmount("TransportOptimization","max_shared_storage")
				return amount + (a * ChoGGi.Consts.ResourceScale)
			end
			return amount
		end,
		--
		TravelTimeEarthMars = function()
			if UICity:IsTechResearched("PlasmaRocket") then
				local p = ChoGGi.ComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars")
				return ChoGGi.Consts.TravelTimeEarthMars * p
			end
			return ChoGGi.Consts.TravelTimeEarthMars
		end,
		--
		TravelTimeMarsEarth = function()
			if UICity:IsTechResearched("PlasmaRocket") then
				local p = ChoGGi.ComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth")
				return ChoGGi.Consts.TravelTimeMarsEarth * p
			end
			return ChoGGi.Consts.TravelTimeMarsEarth
		end,
	}

	function ChoGGi.ComFuncs.GetResearchedTechValue(name,value)
		return funcs_table[name](value)
	end
end -- do

-- if building requires a dome and that dome is borked then assign it to nearest dome
function ChoGGi.ComFuncs.AttachToNearestDome(obj)
	local workingdomes = MapFilter(UICity.labels.Dome,function(o)
		if not o.destroyed and o.air then
			return true
		end
	end)

	-- check for dome and ignore outdoor buildings *and* if there aren't any domes on map
	if not obj.parent_dome and obj:GetDefaultPropertyValue("dome_required") and #workingdomes > 0 then
		-- find the nearest dome
		local dome = FindNearestObject(workingdomes,obj)
		if dome and dome.labels then
			obj.parent_dome = dome
			-- add to dome labels
			dome:AddToLabel("InsideBuildings", obj)

			-- work/res
			if obj:IsKindOf("Workplace") then
				dome:AddToLabel("Workplace", obj)
			elseif obj:IsKindOf("Residence") then
				dome:AddToLabel("Residence", obj)
			end

			-- spires
			if obj:IsKindOf("WaterReclamationSpire") then
				obj:SetDome(dome)
			elseif obj:IsKindOf("NetworkNode") then
				obj.parent_dome:SetLabelModifier("BaseResearchLab", "NetworkNode", obj.modifier)
			end

		end
	end
end

--toggle working status
function ChoGGi.ComFuncs.ToggleWorking(obj)
	if IsValid(obj) then
		CreateRealTimeThread(function()
			obj:ToggleWorking()
			Sleep(5)
			obj:ToggleWorking()
		end)
	end
end

do -- SetCameraSettings
	local SetZoomLimits = cameraRTS.SetZoomLimits
	local SetFovY = camera.SetFovY
	local SetFovX = camera.SetFovX
	local SetProperties = cameraRTS.SetProperties
	local GetScreenSize = UIL.GetScreenSize
	function ChoGGi.ComFuncs.SetCameraSettings()
		local ChoGGi = ChoGGi
		--cameraRTS.GetProperties(1)

		-- size of activation area for border scrolling
		if ChoGGi.UserSettings.BorderScrollingArea then
			SetProperties(1,{ScrollBorder = ChoGGi.UserSettings.BorderScrollingArea})
		else
			-- default
			SetProperties(1,{ScrollBorder = ChoGGi.Consts.CameraScrollBorder})
		end

		if ChoGGi.UserSettings.CameraLookatDist then
			SetProperties(1,{LookatDist = ChoGGi.UserSettings.CameraLookatDist})
		else
			-- default
			SetProperties(1,{LookatDist = ChoGGi.Consts.CameraLookatDist})
		end

		--zoom
		--camera.GetFovY()
		--camera.GetFovX()
		if ChoGGi.UserSettings.CameraZoomToggle then
			if type(ChoGGi.UserSettings.CameraZoomToggle) == "number" then
				SetZoomLimits(0,ChoGGi.UserSettings.CameraZoomToggle)
			else
				SetZoomLimits(0,24000)
			end

			-- 5760x1080 doesn't get the correct zoom size till after zooming out
			if GetScreenSize():x() == 5760 then
				SetFovY(2580)
				SetFovX(7745)
			end
		else
			-- default
			SetZoomLimits(ChoGGi.Consts.CameraMinZoom,ChoGGi.Consts.CameraMaxZoom)
		end

		if ChoGGi.UserSettings.MapEdgeLimit then
			hr.CameraRTSBorderAtMinZoom = 0
			hr.CameraRTSBorderAtMaxZoom = 0
		else
			hr.CameraRTSBorderAtMinZoom = 1000
			hr.CameraRTSBorderAtMaxZoom = 1000
		end

		--SetProperties(1,{HeightInertia = 0})
	end
end -- do

function ChoGGi.ComFuncs.ColonistUpdateAge(c,age)
	-- probably some mod that doesn't know how to clean up colonists they removed...
	if not IsValid(c) then
		return
	end

	local ages = ChoGGi.Tables.ColonistAges
	if age == S[3490--[[Random--]]] then
		age = ages[Random(1,6)]
	end
	-- remove all age traits
	for i = 1, #ages do
		if c.traits[ages[i]] then
			c:RemoveTrait(ages[i])
		end
	end
	-- add new age trait
	c:AddTrait(age,true)

	-- needed for comparison
	local orig_age = c.age_trait
	-- needed for updating entity
	c.age_trait = age

	if age == "Retiree" then
		c.age = 65 -- why isn't there a base_MinAge_Retiree...
	else
		c.age = c[StringFormat("base_MinAge_%s",age)]
	end

	if age == "Child" then
		-- there aren't any child specialist entities
		c.specialist = "none"
		-- children live in nurseries
		if orig_age ~= "Child" then
			c:SetResidence(false)
		end
	end
	-- children live in nurseries
	if orig_age == "Child" and age ~= "Child" then
		c:SetResidence(false)
	end
	-- now we can set the new entity
	c:ChooseEntity()
	-- and (hopefully) prod them into finding a new residence
	c:UpdateWorkplace()
	c:UpdateResidence()
end

function ChoGGi.ComFuncs.ColonistUpdateGender(c,gender)
	-- probably some mod that doesn't know how to clean up colonists they removed...
	if not IsValid(c) then
		return
	end

	local ChoGGi = ChoGGi
	local genders = ChoGGi.Tables.ColonistGenders

	if gender == S[3490--[[Random--]]] then
		gender = genders[Random(1,3)]
	elseif gender == S[302535920000800--[[MaleOrFemale--]]] then
		gender = genders[Random(1,2)]
	end
	-- remove all gender traits
	for i = 1, #genders do
		c:RemoveTrait(genders[i])
	end
	-- add new gender trait
	c:AddTrait(gender,true)
	-- needed for updating entity
	c.gender = gender
	-- set entity gender
	c.entity_gender = gender
	-- now we can set the new entity
	c:ChooseEntity()
end

function ChoGGi.ComFuncs.ColonistUpdateSpecialization(c,spec)
	-- probably some mod that doesn't know how to clean up colonists they removed...
	if not IsValid(c) then
		return
	end

	-- children don't have spec models so they get black cubed
	if c.age_trait ~= "Child" then
		if spec == S[3490--[[Random--]]] then
			spec = ChoGGi.Tables.ColonistSpecializations[Random(1,6)]
		end
		c:SetSpecialization(spec)
		c:UpdateWorkplace()
		--randomly fails on colonists from rockets
		--c:TryToEmigrate()
	end
end

function ChoGGi.ComFuncs.ColonistUpdateTraits(c,bool,traits)
	-- probably some mod that doesn't know how to clean up colonists they removed...
	if not IsValid(c) then
		return
	end

	local func
	if bool == true then
		func = "AddTrait"
	else
		func = "RemoveTrait"
	end
	for i = 1, #traits do
		c[func](c,traits[i],true)
	end
end

function ChoGGi.ComFuncs.ColonistUpdateRace(c,race)
	-- probably some mod that doesn't know how to clean up colonists they removed...
	if not IsValid(c) then
		return
	end

	if race == S[3490--[[Random--]]] then
		race = Random(1,5)
	end
	c.race = race
	c:ChooseEntity()
end

do -- FuckingDrones (took quite a while to figure this fun one out)
	-- force drones to pickup from pile even if they have a carry cap larger then the amount stored
	local ResourceScale = ChoGGi.Consts.ResourceScale
	function ChoGGi.ComFuncs.FuckingDrones(obj)
		if not IsValid(obj) then
			return
		end

		-- Come on, Bender. Grab a jack. I told these guys you were cool.
		-- Well, if jacking on will make strangers think I'm cool, I'll do it.

		local stored
		local parent
		local request
		local resource
		-- mines/farms/factories
		if obj:IsKindOf("SingleResourceProducer") then
			parent = obj.parent
			stored = obj:GetAmountStored()
			request = obj.stockpiles[obj:GetNextStockpileIndex()].supply_request
			resource = obj.resource_produced
	--~ 	elseif obj:IsKindOf("BlackCubeStockpile") then
		else
			parent = obj
			stored = obj:GetStoredAmount()
			request = obj.supply_request
			resource = obj.resource
		end

		-- only fire if more then one resource
		if stored > 1000 then
			local drone = ChoGGi.ComFuncs.GetNearestIdleDrone(parent)
			if not drone then
				return
			end

			local carry = g_Consts.DroneResourceCarryAmount * ResourceScale
			-- round to nearest 1000 (don't want uneven stacks)
			stored = (stored - stored % 1000) / 1000 * 1000
			-- if carry is smaller then stored then they may not pickup (depends on storage)
			if carry < stored or
				-- no picking up more then they can carry
				stored > carry then
					stored = carry
			end
			-- pretend it's the user doing it (for more priority?)
			drone:SetCommandUserInteraction(
				"PickUp",
				request,
				false,
				resource,
				stored
			)
		end
	end
end -- do

function ChoGGi.ComFuncs.GetNearestIdleDrone(bld)
	if not bld or (bld and not bld.command_centers) then
		return
	end

	local cc = FindNearestObject(bld.command_centers,bld)
	-- check if nearest cc has idle drones
	if cc and cc:GetIdleDronesCount() > 0 then
		cc = cc.drones
	else
		-- sort command_centers by nearest, then loop through each of them till we find an idle drone
		table.sort(bld.command_centers,function(a,b)
			if IsValid(a) and IsValid(b) then
				return bld:GetDist2D(a) < bld:GetDist2D(b)
			end
		end)
		-- get command_center with idle drones
		for i = 1, #bld.command_centers do
			if bld.command_centers[i]:GetIdleDronesCount() > 0 then
				cc = bld.command_centers[i].drones
				break
			end
		end
	end

	-- it happens
	if not cc then
		return
	end

	-- get an idle drone
	local idle_idx = TableFind(cc,"command","Idle")
	if idle_idx then
		return cc[idle_idx]
	end
	idle_idx = TableFind(cc,"command","WaitCommand")
	if idle_idx then
		return cc[idle_idx]
	end

--~ 	for i = 1, #cc do
--~ 		local c = cc[i].command
--~ 		if c == "Idle" or c == "WaitCommand" then
--~ 			return cc[i]
--~ 		end
--~ 	end

end

function ChoGGi.ComFuncs.SetMechanizedDepotTempAmount(obj,amount)
	amount = amount or 10
	local resource = obj.resource
	local io_stockpile = obj.stockpiles[obj:GetNextStockpileIndex()]
	local io_supply_req = io_stockpile.supply[resource]
	local io_demand_req = io_stockpile.demand[resource]

	io_stockpile.max_z = amount
	amount = (amount * 10) * ChoGGi.Consts.ResourceScale
	io_supply_req:SetAmount(amount)
	io_demand_req:SetAmount(amount)
end

do -- COLOUR FUNCTIONS
	function ChoGGi.ComFuncs.SaveOldPalette(obj)
		if not IsValid(obj) then
			return
		end
		if not obj.ChoGGi_origcolors and obj:IsKindOf("ColorizableObject") then
			obj.ChoGGi_origcolors = {
				{obj:GetColorizationMaterial(1)},
				{obj:GetColorizationMaterial(2)},
				{obj:GetColorizationMaterial(3)},
				{obj:GetColorizationMaterial(4)},
			}
			obj.ChoGGi_origcolors[-1] = obj:GetColorModifier()
		end
	end
	local SaveOldPalette = ChoGGi.ComFuncs.SaveOldPalette

	function ChoGGi.ComFuncs.RestoreOldPalette(obj)
		if not IsValid(obj) then
			return
		end
		if obj.ChoGGi_origcolors then
			local c = obj.ChoGGi_origcolors
			obj:SetColorModifier(c[-1])
			obj:SetColorizationMaterial(1, c[1][1], c[1][2], c[1][3])
			obj:SetColorizationMaterial(2, c[2][1], c[2][2], c[2][3])
			obj:SetColorizationMaterial(3, c[3][1], c[3][2], c[3][3])
			obj:SetColorizationMaterial(4, c[4][1], c[4][2], c[4][3])
			obj.ChoGGi_origcolors = nil
		end
	end
	local RestoreOldPalette = ChoGGi.ComFuncs.RestoreOldPalette

	function ChoGGi.ComFuncs.GetPalette(obj)
		if not IsValid(obj) then
			return
		end
		local pal = {}
		pal.Color1, pal.Roughness1, pal.Metallic1 = obj:GetColorizationMaterial(1)
		pal.Color2, pal.Roughness2, pal.Metallic2 = obj:GetColorizationMaterial(2)
		pal.Color3, pal.Roughness3, pal.Metallic3 = obj:GetColorizationMaterial(3)
		pal.Color4, pal.Roughness4, pal.Metallic4 = obj:GetColorizationMaterial(4)
		return pal
	end

	function ChoGGi.ComFuncs.RandomColour(amount)
		if amount and type(amount) == "number" then
			-- somewhere to store the colours
			local colour_list = {}
			-- populate list with amount we want
			for i = 1, amount do
				-- 16777216: https://en.wikipedia.org/wiki/Color_depth#True_color_(24-bit)
				-- kinda, we skip the alpha values
--~ 				colour_list[i] = AsyncRand(33554433) -16777216
				colour_list[i] = AsyncRand(16777217) + -16777216
			end

			-- now remove all dupes and add more till we hit amount
			local c
			-- we use repeat instead of while, as this checks at the end instead of beginning (ie: after we've removed dupes once)
			repeat
				c = #colour_list
				-- loop missing amount
				for _ = 1, amount - #colour_list do
					c = c + 1
					colour_list[c] = AsyncRand(16777217) + -16777216
				end
				-- remove dupes (it's quicker to do this then check the table for each newly added colour)
				colour_list = RetTableNoDupes(colour_list)
			-- once we're at parity then off we go
			until #colour_list == amount

			return colour_list
		end

		-- return a single colour
		return AsyncRand(16777217) + -16777216
	end
	local RandomColour = ChoGGi.ComFuncs.RandomColour

	function ChoGGi.ComFuncs.ObjectColourRandom(obj)
		if not IsValid(obj) or obj and not obj:IsKindOf("ColorizableObject") then
			return
		end
		local ChoGGi = ChoGGi
		local attaches = {}
		local c = 0

		local a_list = ChoGGi.ComFuncs.GetAllAttaches(obj)
		for i = 1, #a_list do
			if a_list[i]:IsKindOf("ColorizableObject") then
				c = c + 1
				attaches[c] = {obj = a_list[i],c = {}}
			end
		end

		-- random is random after all, so lets try for at least slightly different colours
		-- you can do a max of 4 colours on each object
		local colours = RandomColour((c * 4) + 4)
		-- attach obj to list
		c = c + 1
		attaches[c] = {obj = obj,c = {}}

		-- add colours to each colour table attached to each obj
		local obj_count = 0
		local att_count = 1
		for i = 1, #colours do
			-- add 1 to colour count
			obj_count = obj_count + 1
			-- add colour to attach colours
			attaches[att_count].c[obj_count] = colours[i]

			if obj_count == 4 then
				-- when we get to four increment attach colours num, and reset colour count
				obj_count = 0
				att_count = att_count + 1
			end
		end

		-- now we loop through all the objects and apply the colours
		for i = 1, c do
			obj = attaches[i].obj
			local c = attaches[i].c

			SaveOldPalette(obj)

			-- can only change basecolour
			if obj:GetMaxColorizationMaterials() == 0 then
				obj:SetColorModifier(c[1])
			else
				-- object, 1-4 ,Color, Roughness, Metallic
				obj:SetColorizationMaterial(1, c[1], Random(-128,127), Random(-128,127))
				obj:SetColorizationMaterial(2, c[2], Random(-128,127), Random(-128,127))
				obj:SetColorizationMaterial(3, c[3], Random(-128,127), Random(-128,127))
				obj:SetColorizationMaterial(4, c[4], Random(-128,127), Random(-128,127))
			end
		end

	end

	function ChoGGi.ComFuncs.ObjectColourDefault(obj)
		obj = obj or ChoGGi.ComFuncs.SelObject()
		if not obj then
			return
		end

		if IsValid(obj) and obj:IsKindOf("ColorizableObject") then
			RestoreOldPalette(obj)
		end

		local attaches = ChoGGi.ComFuncs.GetAllAttaches(obj)
		for i = 1, #attaches do
			RestoreOldPalette(attaches[i])
		end

	end

	local colour_funcs = {
		SetColours = function(obj,choice)
			ChoGGi.ComFuncs.SaveOldPalette(obj)
			for i = 1, 4 do
				obj:SetColorizationMaterial(i,
					choice[i].value,
					choice[i+8].value,
					choice[i+4].value
				)
			end
			obj:SetColorModifier(choice[13].value)
		end,
		RestoreOldPalette = RestoreOldPalette,
	}

	-- make sure we're in the same grid
	local function CheckGrid(fake_parent,func,obj,obj_bld,choice)
		-- used to check for grid connections
		local check_air = choice[1].checkair
		local check_water = choice[1].checkwater
		local check_elec = choice[1].checkelec

		-- this is ugly, i should clean it up
		if not check_air and not check_water and not check_elec then
			colour_funcs[func](obj,choice)
		else
			if check_air and obj_bld.air and fake_parent.air and obj_bld.air.grid.elements[1].building == fake_parent.air.grid.elements[1].building then
				colour_funcs[func](obj,choice)
			end
			if check_water and obj_bld.water and fake_parent.water and obj_bld.water.grid.elements[1].building == fake_parent.water.grid.elements[1].building then
				colour_funcs[func](obj,choice)
			end
			if check_elec and obj_bld.electricity and fake_parent.electricity and obj_bld.electricity.grid.elements[1].building == fake_parent.electricity.grid.elements[1].building then
				colour_funcs[func](obj,choice)
			end
		end
	end

	function ChoGGi.ComFuncs.ChangeObjectColour(obj,parent,dialog)
		local ChoGGi = ChoGGi
		local GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches
		local CompareTableValue = ChoGGi.ComFuncs.CompareTableValue
		if not obj or obj and not obj:IsKindOf("ColorizableObject") then
			MsgPopup(
				S[302535920000015--[[Can't colour %s.--]]]:format(RetName(obj)),
				3595--[[Color--]]
			)
			return
		end
		local pal = ChoGGi.ComFuncs.GetPalette(obj)

		local ItemList = {}
		local c = 0
		for i = 1, 4 do
			local text = StringFormat("Color%s",i)
			c = c + 1
			ItemList[c] = {
				text = text,
				value = pal[text],
				hint = 302535920000017--[[Use the colour picker (dbl right-click for instant change).--]],
			}
			text = StringFormat("Roughness%s",i)
			c = c + 1
			ItemList[c] = {
				text = text,
				value = pal[text],
				hint = 302535920000018--[[Don't use the colour picker: Numbers range from -255 to 255.--]],
			}
			text = StringFormat("Metallic%s",i)
			c = c + 1
			ItemList[c] = {
				text = text,
				value = pal[text],
				hint = 302535920000018--[[Don't use the colour picker: Numbers range from -255 to 255.--]],
			}
		end
		c = c + 1
		ItemList[c] = {
			text = "X_BaseColor",
			value = 6579300,
			obj = obj,
			hint = 302535920000019--[["Single colour for object (this colour will interact with the other colours).
	If you want to change the colour of an object you can't with 1-4."--]],
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			if #choice == 13 then

				-- needed to set attachment colours
				local label = obj.class
				local fake_parent
				if parent then
					label = parent.class
					fake_parent = parent
				else
					fake_parent = choice[1].parentobj
				end
				if not fake_parent then
					fake_parent = obj
				end

				-- sort table so it's the same as was displayed
				table.sort(choice,function(a,b)
					return CompareTableValue(a,b,"text")
				end)
				local colour_func = "SetColours"
				if choice[1].check2 then
					colour_func = "RestoreOldPalette"
				end

				-- all of type checkbox
				if choice[1].check1 then
					local labels = ChoGGi.ComFuncs.RetAllOfClass(label)
					for i = 1, #labels do
						local lab_obj = labels[i]
						if parent then
							local attaches = GetAllAttaches(lab_obj)
							for j = 1, #attaches do
								CheckGrid(fake_parent,colour_func,attaches[j],lab_obj,choice)
							end
						else
							CheckGrid(fake_parent,colour_func,lab_obj,lab_obj,choice)
						end
					end

				-- single building change
				else
					CheckGrid(fake_parent,colour_func,obj,obj,choice)
				end

				MsgPopup(
					S[302535920000020--[[Colour is set on %s--]]]:format(RetName(obj)),
					3595--[[Color--]],
					nil,
					nil,
					obj
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = StringFormat("%s: %s",S[174--[[Color Modifier--]]],RetName(obj)),
			hint = 302535920000022--[["If number is 8421504 then you probably can't change that colour.

You can copy and paste numbers if you want."--]],
			parent = dialog,
			custom_type = 2,
			check = {
				{
					title = 302535920000023--[[All of type--]],
					hint = 302535920000024--[[Change all objects of the same type.--]],
				},
				{
					title = 302535920000025--[[Default Colour--]],
					hint = 302535920000026--[[if they're there; resets to default colours.--]],
				},
			},
		}
	end
end -- do

function ChoGGi.ComFuncs.BuildMenu_Toggle()
	local dlg = Dialogs.XBuildMenu
	if not dlg then
		return
	end

	CreateRealTimeThread(function()
		CloseXBuildMenu()
		Sleep(250)
		OpenXBuildMenu()
	end)
end

-- sticks small depot in front of mech depot and moves all resources to it (max of 20 000)
function ChoGGi.ComFuncs.EmptyMechDepot(oldobj)
	oldobj = IsKindOf(oldobj,"MechanizedDepot") and oldobj or ChoGGi.ComFuncs.SelObject()

	if not oldobj or not IsKindOf(oldobj,"MechanizedDepot") then
		return
	end

	local res = oldobj.resource
	local amount = oldobj[StringFormat("GetStored_%s",res)](oldobj)
	-- not good to be larger then this when game is saved (height limit of map objects seems to be 65536)
	if amount > 20000000 then
		amount = amount
	end
	local stock = oldobj.stockpiles[oldobj:GetNextStockpileIndex()]
	local angle = oldobj:GetAngle()
	-- new pos based on angle of old depot (so it's in front not inside)
	local newx = 0
	local newy = 0
	if angle == 0 then
		newx = 500
		newy = 0
	elseif angle == 3600 then
		newx = 500
		newy = 500
	elseif angle == 7200 then
		newx = 0
		newy = 500
	elseif angle == 10800 then
		newx = -600
		newy = 0
	elseif angle == 14400 then
		newx = 0
		newy = -500
	elseif angle == 18000 then
		newx = 500
		newy = -500
	end

	-- yeah guys. lets have two names for a resource and use them interchangeably, it'll be fine...
	local res2 = res
	if res == "PreciousMetals" then
		res2 = "RareMetals"
	end

	local x,y,z = stock:GetVisualPosXYZ()
	-- so it doesn't look weird make sure it's on a hex point

	-- create new depot, and set max amount to stored amount of old depot
	local newobj = PlaceObj("UniversalStorageDepot", {
		"template_name", StringFormat("Storage%s",res2),
		"storable_resources", {res},
		"max_storage_per_resource", amount,
		-- so it doesn't look weird make sure it's on a hex point
		"Pos", HexGetNearestCenter(point(x + newx,y + newy,z)),
	})

	-- make it align with the depot
	newobj:SetAngle(angle)
	-- give it a bit before filling
	local Sleep = Sleep
	CreateRealTimeThread(function()
		local time = 0
		repeat
			Sleep(250)
			time = time + 25
		until type(newobj.requester_id) == "number" or time > 5000
		-- since we set new depot max amount to old amount we can just CheatFill it
		newobj:CheatFill()
		-- clean out old depot
		oldobj:CheatEmpty()

		Sleep(250)
		ChoGGi.ComFuncs.DeleteObject(oldobj)
	end)

end

--returns the near hex grid for object placement
function ChoGGi.ComFuncs.CursorNearestHex(pt)
	return HexGetNearestCenter(pt or GetTerrainCursor())
end

function ChoGGi.ComFuncs.DeleteAllAttaches(obj)
	if obj.DestroyAttaches then
		obj:DestroyAttaches()
	end
end

function ChoGGi.ComFuncs.FindNearestResource(obj)
	obj = obj or ChoGGi.ComFuncs.SelObject()
	if not obj then
		MsgPopup(
			302535920000027--[[Nothing selected--]],
			302535920000028--[[Find Resource--]]
		)
		return
	end

	-- build list of resources
	local ItemList = {}
	local ResourceDescription = ResourceDescription
	local res = ChoGGi.Tables.Resources
	local TagLookupTable = const.TagLookupTable
	for i = 1, #res do
		local item = ResourceDescription[TableFind(ResourceDescription, "name", res[i])]
		ItemList[i] = {
			text = Trans(item.display_name),
			value = item.name,
			icon = TagLookupTable[StringFormat("icon_%s",item.name)],
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if type(value) == "string" then

			-- get nearest stockpiles to object
			local labels = UICity.labels

			local stockpiles = {}
			table.append(stockpiles,labels[StringFormat("MechanizedDepot%s",value)])
			if value == "BlackCube" then
				table.append(stockpiles,labels.BlackCubeDumpSite)
			elseif value == "MysteryResource" then
				table.append(stockpiles,labels.MysteryDepot)
			elseif value == "WasteRock" then
				table.append(stockpiles,labels.WasteRockDumpSite)
			else
				table.append(stockpiles,labels.UniversalStorageDepot)
			end

			-- filter out empty/diff res stockpiles
			local GetStored = StringFormat("GetStored_%s",value)
			stockpiles = MapFilter(stockpiles,function(o)
				if o[GetStored] and o[GetStored](o) > 999 then
					return true
				end
			end)

			-- attached stockpiles/stockpiles left from removed objects
			table.append(stockpiles,
				MapGet("map",{"ResourceStockpile","ResourceStockpileLR"}, function(o)
					if o.resource == value and o:GetStoredAmount() > 999 then
						return true
					end
				end)
			)

			local nearest = FindNearestObject(stockpiles,obj)
			-- if there's no resource then there's no "nearest"
			if nearest then
				-- the power of god
				ViewObjectMars(nearest)
				ChoGGi.ComFuncs.AddBlinkyToObj(nearest)
			else
				MsgPopup(
					S[302535920000029--[[Error: Cannot find any %s.--]]]:format(choice[1].text),
					15--[[Resource--]]
				)
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = ItemList,
		title = StringFormat("%s %s",S[302535920000031--[[Find Nearest Resource--]]],RetName(obj)),
		hint = 302535920000032--[[Select a resource to find--]],
		skip_sort = true,
		custom_type = 7,
		custom_func = CallBackFunc,
	}
end

do -- DeleteObject
	local IsValid = IsValid
	local DoneObject = DoneObject
	local DeleteThread = DeleteThread
	local DestroyBuildingImmediate = DestroyBuildingImmediate
	local UpdateFlightGrid

	local function ExecFunc(obj,funcname,param)
		if obj[funcname] then
			obj[funcname](obj,param)
		end
	end

	function ChoGGi.ComFuncs.DeleteObject(obj,editor_delete)
		local ChoGGi = ChoGGi
		if not UpdateFlightGrid then
			UpdateFlightGrid = ChoGGi.ComFuncs.UpdateFlightGrid
		end

		if not editor_delete then
			-- multiple selection from editor mode
			local objs = editor:GetSel() or ""
			if #objs > 0 then
				for i = 1, #objs do
					if objs[i].class ~= "MapSector" then
						ChoGGi.ComFuncs.DeleteObject(objs[i],true)
					end
				end
			elseif not obj then
				obj = ChoGGi.ComFuncs.SelObject()
			end
		end

		if not IsValid(obj) then
			return
		end

		-- hopefully i can remove all log spam one of these days
		local name = RetName(obj)
		if name then
			printC("DeleteObject",name,"DeleteObject")
		end

		if Flight_MarkedObjs[obj] then
			Flight_MarkedObjs[obj] = nil
		end

		-- deleting domes will freeze game if they have anything in them.
		if obj:IsKindOf("Dome") and #(obj.labels.Buildings or "") > 0 then
			MsgPopup(
				S[302535920001354--[[%s is a Dome with buildings (likely crash if deleted).--]]]:format(RetName(obj)),
				302535920000489--[[Delete Object(s)--]]
			)
			return
		end

		-- actually delete the whole passage
		if obj:IsKindOf("Passage") then
			for i = #obj.elements_under_construction, 1, -1 do
				ChoGGi.ComFuncs.DeleteObject(obj.elements_under_construction[i])
			end
		end

		-- figured it's quicker using a local function now
		local waterspire = obj:IsKindOf("WaterReclamationSpire") and not IsValid(obj.parent_dome)
		local rctransport = obj:IsKindOf("RCTransport")
		local holy_stuff = obj:IsKindOfClasses("MoholeMine","ShuttleHub","MetalsExtractor","JumperShuttleHub")

		if not waterspire then
			-- some stuff will leave holes in the world if they're still working
			ExecFunc(obj,"SetWorking")
		end

		-- stop any threads (reduce log spam)
		for _,value in pairs(obj) do
			if type(value) == "thread" then
				DeleteThread(value)
			end
		end

		if obj:IsKindOf("Deposit") and obj.group then
			for i = #obj.group, 1, -1 do
				obj.group[i]:delete()
				obj.group[i] = nil
			end
		end

		-- demo to the rescue
		obj.can_demolish = true
		obj.indestructible = false
		if obj.DoDemolish then
			DestroyBuildingImmediate(obj)
		end

		ExecFunc(obj,"Destroy")
		ExecFunc(obj,"SetDome",false)
		ExecFunc(obj,"RemoveFromLabels")

		-- causes log spam, transport still drops items carried so...
		if not waterspire and not rctransport then
			ExecFunc(obj,"Done")
		end

		ExecFunc(obj,"Gossip","done")
		ExecFunc(obj,"SetHolder",false)

		-- only fire for stuff with holes in the ground (takes too long otherwise)
		if holy_stuff then
			ExecFunc(obj,"DestroyAttaches")
		end

		-- I did ask nicely
		if IsValid(obj) then
			DoneObject(obj)
		end

		UpdateFlightGrid()
	end
end -- do

do -- BuildingConsumption
	local function AddConsumption(obj,name)
		local tempname = StringFormat("ChoGGi_mod_%s",name)
		-- if this is here we know it has what we need so no need to check for mod/consump
		if obj[tempname] then
			local mod = obj.modifications[name]
			if mod[1] then
				mod = mod[1]
			end
			local orig = obj[tempname]
			if mod:IsKindOf("ObjectModifier") then
				mod:Change(orig.amount,orig.percent)
			else
				mod.amount = orig.amount
				mod.percent = orig.percent
			end
			obj[tempname] = nil
		end
		local amount = BuildingTemplates[obj.template_name][name]
		obj:SetBase(name, amount)
	end
	local function RemoveConsumption(obj,name)
		local mods = obj.modifications
		if mods and mods[name] then
			local mod = obj.modifications[name]
			if mod[1] then
				mod = mod[1]
			end
			local tempname = StringFormat("ChoGGi_mod_%s",name)
			if not obj[tempname] then
				obj[tempname] = {
					amount = mod.amount,
					percent = mod.percent
				}
			end
			if mod:IsKindOf("ObjectModifier") then
				mod:Change(0,0)
			end
		end
		obj:SetBase(name, 0)
	end

	function ChoGGi.ComFuncs.RemoveBuildingWaterConsump(obj)
		RemoveConsumption(obj,"water_consumption")
	end
	function ChoGGi.ComFuncs.AddBuildingWaterConsump(obj)
		AddConsumption(obj,"water_consumption")
	end
	function ChoGGi.ComFuncs.RemoveBuildingElecConsump(obj)
		RemoveConsumption(obj,"electricity_consumption")
	end
	function ChoGGi.ComFuncs.AddBuildingElecConsump(obj)
		AddConsumption(obj,"electricity_consumption")
	end
	function ChoGGi.ComFuncs.RemoveBuildingAirConsump(obj)
		RemoveConsumption(obj,"air_consumption")
	end
	function ChoGGi.ComFuncs.AddBuildingAirConsump(obj)
		AddConsumption(obj,"air_consumption")
	end
end -- do

do -- DisplayMonitorList
	local function AddGrid(city,name,info)
		local c = #info.tables
		for i = 1, #city[name] do
			c = c + 1
			info.tables[c] = city[name][i]
		end
	end

	function ChoGGi.ComFuncs.DisplayMonitorList(value,parent)
		if value == "New" then
			local ChoGGi = ChoGGi
			ChoGGi.ComFuncs.MsgWait(
				S[302535920000033--[[Post a request on Nexus or Github or send an email to: %s--]]]:format(ChoGGi.email),
				S[302535920000034--[[Request--]]]
			)
			return
		end

		local UICity = UICity
		local info
		--0=value,1=#table,2=list table values
		local info_grid = {
			tables = {},
			values = {
				{name="connectors",kind=1},
				{name="consumers",kind=1},
				{name="producers",kind=1},
				{name="storages",kind=1},
				{name="all_consumers_supplied",kind=0},
				{name="charge",kind=0},
				{name="discharge",kind=0},
				{name="current_consumption",kind=0},
				{name="current_production",kind=0},
				{name="current_reserve",kind=0},
				{name="current_storage",kind=0},
				{name="current_storage_change",kind=0},
				{name="current_throttled_production",kind=0},
				{name="current_waste",kind=0},
			}
		}
		if value == "Grids" then
			info = info_grid
			info_grid.title = S[302535920000035--[[Grids--]]]
			AddGrid(UICity,"air",info)
			AddGrid(UICity,"electricity",info)
			AddGrid(UICity,"water",info)
		elseif value == "Air" then
			info = info_grid
			info_grid.title = S[891--[[Air--]]]
			AddGrid(UICity,"air",info)
		elseif value == "Power" then
			info = info_grid
			info_grid.title = S[79--[[Power--]]]
			AddGrid(UICity,"electricity",info)
		elseif value == "Water" then
			info = info_grid
			info_grid.title = S[681--[[Water--]]]
			AddGrid(UICity,"water",info)
		elseif value == "Research" then
			info = {
				title = S[311--[[Research--]]],
				listtype = "all",
				tables = {UICity.tech_status},
				values = {
					researched = true
				}
			}
		elseif value == "Colonists" then
			info = {
				title = S[547--[[Colonists--]]],
				tables = UICity.labels.Colonist or "",
				values = {
					{name="handle",kind=0},
					{name="command",kind=0},
					{name="goto_target",kind=0},
					{name="age",kind=0},
					{name="age_trait",kind=0},
					{name="death_age",kind=0},
					{name="race",kind=0},
					{name="gender",kind=0},
					{name="birthplace",kind=0},
					{name="specialist",kind=0},
					{name="sols",kind=0},
					--{name="workplace",kind=0},
					{name="workplace_shift",kind=0},
					--{name="residence",kind=0},
					--{name="current_dome",kind=0},
					{name="daily_interest",kind=0},
					{name="daily_interest_fail",kind=0},
					{name="dome_enter_fails",kind=0},
					{name="traits",kind=2},
				}
			}
		elseif value == "Rockets" then
			info = {
				title = S[5238--[[Rockets--]]],
				tables = UICity.labels.AllRockets,
				values = {
					{name="name",kind=0},
					{name="handle",kind=0},
					{name="command",kind=0},
					{name="status",kind=0},
					{name="priority",kind=0},
					{name="working",kind=0},
					{name="charging_progress",kind=0},
					{name="charging_time_left",kind=0},
					{name="landed",kind=0},
					{name="drones",kind=1},
					--{name="units",kind=1},
					{name="unreachable_buildings",kind=0},
				}
			}
		elseif value == "City" then
			info = {
				title = S[302535920000042--[[City--]]],
				tables = {UICity},
				values = {
					{name="rand_state",kind=0},
					{name="day",kind=0},
					{name="hour",kind=0},
					{name="minute",kind=0},
					{name="total_export",kind=0},
					{name="total_export_funding",kind=0},
					{name="funding",kind=0},
					{name="research_queue",kind=1},
					{name="consumption_resources_consumed_today",kind=2},
					{name="maintenance_resources_consumed_today",kind=2},
					{name="gathered_resources_today",kind=2},
					{name="consumption_resources_consumed_yesterday",kind=2},
					{name="maintenance_resources_consumed_yesterday",kind=2},
					{name="gathered_resources_yesterday",kind=2},
					 --{name="unlocked_upgrades",kind=2},
				}
			}
		end
		if info then
			ChoGGi.ComFuncs.OpenInMonitorInfoDlg(info,parent)
		end
	end
end -- do

function ChoGGi.ComFuncs.ResetHumanCentipedes()
	local objs = UICity.labels.Colonist or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- only need to do people walking outside (pathing issue), and if they don't have a path (not moving or walking into an invis wall)
		if obj:IsValidPos() and not obj:GetPath() then
			-- too close and they keep doing the human centipede
			obj:SetCommand("Goto", GetPassablePointNearby(obj:GetVisualPos()+point(Random(-1000,1000),Random(-1000,1000))))
		end
	end
end

function ChoGGi.ComFuncs.CollisionsObject_Toggle(obj,skip_msg)
	obj = obj or ChoGGi.ComFuncs.SelObject()
	if not obj then
		if not skip_msg then
			MsgPopup(
				302535920000027--[[Nothing selected--]],
				302535920000968--[[Collisions--]]
			)
		end
		return
	end
	local coll = const.efCollision + const.efApplyToGrids

	local which
	-- re-enable col on obj and any attaches
	if obj.ChoGGi_CollisionsDisabled then
		obj:SetEnumFlags(coll)
		if obj.ForEachAttach then
			obj:ForEachAttach(function(a)
				a:SetEnumFlags(coll)
			end)
		end
		obj.ChoGGi_CollisionsDisabled = nil
		which = S[460479110814--[[Enabled--]]]
	else
		obj:ClearEnumFlags(coll)
		if obj.ForEachAttach then
			obj:ForEachAttach(function(a)
				a:ClearEnumFlags(coll)
			end)
		end
		obj.ChoGGi_CollisionsDisabled = true
		which = S[847439380056--[[Disabled--]]]
	end

	if not skip_msg then
		MsgPopup(
			S[302535920000969--[[Collisions %s on %s--]]]:format(which,RetName(obj)),
			302535920000968--[[Collisions--]],
			nil,
			nil,
			obj
		)
	end
end

function ChoGGi.ComFuncs.CheckForBorkedTransportPath(obj)
	CreateRealTimeThread(function()
		-- let it sleep for awhile
		Sleep(1000)
		-- 0 means it's stopped, so anything above that and without a path means it's borked (probably)
		if obj:GetAnim() > 0 and obj:GetPathLen() == 0 then
			obj:InterruptCommand()
			MsgPopup(
				S[302535920001267--[[%s at position: %s was stopped.--]]]:format(RetName(obj),obj:GetVisualPos()),
				302535920001266--[[Borked Transport Pathing--]],
				"UI/Icons/IPButtons/transport_route.tga",
				nil,
				obj
			)
		end
	end)
end

function ChoGGi.ComFuncs.RetHardwareInfo()
	local mem = {}
	local cm = 0

	local memory_info = GetMemoryInfo()
	for key,value in pairs(memory_info) do
		cm = cm + 1
		mem[cm] = StringFormat("%s: %s\n",key,value)
	end

	local hw = {}
	local chw = 0
	local hardware_info = GetHardwareInfo(0)
	for key,value in pairs(hardware_info) do
		if key == "gpu" then
			chw = chw + 1
			hw[chw] = StringFormat("%s: %s\n",key,GetGpuDescription())
		else
			chw = chw + 1
			hw[chw] = StringFormat("%s: %s\n",key,value)
		end
	end
	table.sort(hw)
	chw = chw + 1
	hw[chw] = "\n"

	return StringFormat([[%s:
GetHardwareInfo(0): %s

GetMemoryInfo(): %s
AdapterMode(0): %s
GetMachineID(): %s
GetSupportedMSAAModes(): %s
GetSupportedShaderModel(): %s
GetMaxStrIDMemoryStats(): %s

GameObjectStats(): %s

GetCWD(): %s
GetExecDirectory(): %s
GetExecName(): %s
GetDate(): %s
GetOSName(): %s
GetOSVersion(): %s
GetUsername(): %s
GetSystemDPI(): %s
GetComputerName(): %s


]],
		S[5568--[[Stats--]]],
		TableConcat(hw),
		TableConcat(mem),
		TableConcat({GetAdapterMode(0)}," "),
		GetMachineID(),
		TableConcat(GetSupportedMSAAModes()," "):gsub("HR::",""),
		GetSupportedShaderModel(),
		GetMaxStrIDMemoryStats(),
		GameObjectStats(),
		GetCWD(),
		GetExecDirectory(),
		GetExecName(),
		GetDate(),
		GetOSName(),
		GetOSVersion(),
		GetUsername(),
		GetSystemDPI(),
		GetComputerName()
	)
end

do --
	local function RemoveTableItem(list,name,value)
		local idx = TableFind(list, name, value)
		if idx then
			list[idx]:delete()
			TableRemove(list,idx)
		end
	end
	ChoGGi.ComFuncs.RemoveTableItem = RemoveTableItem

	-- check for and remove old object (XTemplates are created on new game/new dlc ?)
	function ChoGGi.ComFuncs.RemoveXTemplateSections(list,name,value)
		RemoveTableItem(list,name,value or true)
	end
end -- do

local AddXTemplateNew = function(xt,name,pos,list)
	if not xt or not name or not list then
		local f = ObjPropertyListToLuaCode
		print(S[302535920001383--[[AddXTemplate borked template name: %s template: %s list: %s--]]]:format(name and f(name),template and f(template),list and f(list)))
		return
	end
	local stored_name = StringFormat("ChoGGi_Template_%s",name)

	ChoGGi.ComFuncs.RemoveXTemplateSections(xt,stored_name)

	table.insert(xt,pos or #xt,PlaceObj("XTemplateTemplate", {
		stored_name, true,
		"__condition", list.__condition or function()
			return true
		end,
		"__context_of_kind", list.__context_of_kind or "",
		"__template", list.__template or "InfopanelActiveSection",
		"Title", list.Title or S[1000016--[[Title--]]],
		"Icon", list.Icon or "UI/Icons/gpmc_system_shine.tga",
		"RolloverTitle", list.RolloverTitle or S[126095410863--[[Info--]]],
		"RolloverText", list.RolloverText or S[126095410863--[[Info--]]],
		"RolloverHint", list.RolloverHint or "",
		"OnContextUpdate", list.OnContextUpdate or empty_func,
	}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(self)
					return self.parent
				end,
			"func", list.func or empty_func,
		})
	}))
end

--~ AddXTemplateNew(XTemplates.ipColonist[1],"LockworkplaceColonist",nil,{
--~ AddXTemplate("SolariaTelepresence_sectionWorkplace1","sectionWorkplace",{
--~ function ChoGGi.ComFuncs.AddXTemplate(name,template,list,toplevel)

function ChoGGi.ComFuncs.AddXTemplate(xt,name,pos,list)
	-- old: name,template,list,toplevel
	-- new  xt,		name,		pos,	list
	if type(xt) == "string" then
		if list then
			AddXTemplateNew(XTemplates[name],xt,nil,pos)
		else
			AddXTemplateNew(XTemplates[name][1],xt,nil,pos)
		end
	else
		AddXTemplateNew(xt,name,pos,list)
	end
end

function ChoGGi.ComFuncs.SetCommanderBonuses(name)
	local comm = table.find_value(MissionParams.idCommanderProfile.items,"id",g_CurrentMissionParams.idCommanderProfile)
	if not comm then
		return
	end

	local list = Presets.CommanderProfilePreset.Default[name] or ""
	local c = #comm
	for i = 1, #list do
		-- i forgot why i had this in a thread...
		CreateRealTimeThread(function()
			c = c + 1
			comm[c] = list[i]
		end)
	end
end

function ChoGGi.ComFuncs.SetSponsorBonuses(name)
	local ChoGGi = ChoGGi

	local sponsor = table.find_value(MissionParams.idMissionSponsor.items,"id",g_CurrentMissionParams.idMissionSponsor)
	if not sponsor then
		return
	end

	local bonus = Presets.MissionSponsorPreset.Default[name]
	-- bonuses multiple sponsors have (CompareAmounts returns equal or larger amount)
	if sponsor.cargo then
		sponsor.cargo = ChoGGi.ComFuncs.CompareAmounts(sponsor.cargo,bonus.cargo)
	end
	if sponsor.additional_research_points then
		sponsor.additional_research_points = ChoGGi.ComFuncs.CompareAmounts(sponsor.additional_research_points,bonus.additional_research_points)
	end

	local c = #sponsor
	if name == "IMM" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","FoodPerRocketPassenger",
			"Amount",9000
		})
	elseif name == "NASA" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","SponsorFundingPerInterval",
			"Amount",500
		})
	elseif name == "BlueSun" then
		sponsor.rocket_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.rocket_price,bonus.rocket_price)
		sponsor.applicants_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_price,bonus.applicants_price)
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_GrantTech",{
			"Field","Physics",
			"Research","DeepMetalExtraction"
		})
	elseif name == "CNSA" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","ApplicantGenerationInterval",
			"Percent",-50
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","MaxColonistsPerRocket",
			"Amount",10
		})
	elseif name == "ISRO" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_GrantTech",{
			"Field","Engineering",
			"Research","LowGEngineering"
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","Concrete_cost_modifier",
			"Percent",-20
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","Electronics_cost_modifier",
			"Percent",-20
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","MachineParts_cost_modifier",
			"Percent",-20
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","ApplicantsPoolStartingSize",
			"Percent",50
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","Metals_cost_modifier",
			"Percent",-20
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","Polymers_cost_modifier",
			"Percent",-20
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","PreciousMetals_cost_modifier",
			"Percent",-20
		})
	elseif name == "ESA" then
		sponsor.funding_per_tech = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_tech,bonus.funding_per_tech)
		sponsor.funding_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_breakthrough,bonus.funding_per_breakthrough)
	elseif name == "SpaceY" then
		sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
		sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
		sponsor.modifier_name2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name2,bonus.bonusmodifier_name2)
		sponsor.modifier_value2 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value2,bonus.modifier_value2)
		sponsor.modifier_name3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name3,bonus.modifier_name3)
		sponsor.modifier_value3 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value3,bonus.modifier_value3)
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","CommandCenterMaxDrones",
			"Percent",20
		})
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","starting_drones",
			"Percent",4
		})
	elseif name == "NewArk" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","BirthThreshold",
			"Percent",-50
		})
	elseif name == "Roscosmos" then
		sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
		sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_GrantTech",{
			"Field","Robotics",
			"Research","FueledExtractors"
		})
	elseif name == "Paradox" then
		sponsor.applicants_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_per_breakthrough,bonus.applicants_per_breakthrough)
		sponsor.anomaly_bonus_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.anomaly_bonus_breakthrough,bonus.anomaly_bonus_breakthrough)
	end
end

do -- flightgrids
	local Flight_DbgLines = {}
	local Flight_DbgLines_c = 0
	local type_tile = terrain.TypeTileSize()
	local work_step = 16 * type_tile
	local dbg_step = work_step / 4 -- 400
	local PlacePolyline = PlacePolyline
	local MulDivRound = MulDivRound
	local InterpolateRGB = InterpolateRGB
	local Clamp = Clamp
	local AveragePoint2D = AveragePoint2D
	local terrain_GetHeight = terrain.GetHeight

	local function Flight_DbgRasterLine(pos1, pos0, zoffset)
		pos1 = pos1 or GetTerrainCursor()
		pos0 = pos0 or FindPassable(GetTerrainCursor())
		zoffset = zoffset or 0
		if not pos0 or not Flight_Height then
			return
		end
		local diff = pos1 - pos0
		local dist = diff:Len2D()
		local steps = 1 + (dist + dbg_step - 1) / dbg_step
		local points,colors,pointsc,colorsc = {},{},0,0
		local max_diff = 10 * guim
		for i = 1,steps do
			local pos = pos0 + MulDivRound(pos1 - pos0, i - 1, steps - 1)
			local height = Flight_Height:GetBilinear(pos, work_step, 0, 1) + zoffset
			pointsc = pointsc + 1
			colorsc = colorsc + 1
			points[pointsc] = pos:SetZ(height)
			colors[colorsc] = InterpolateRGB(
				-1, -- white
				-16711936, -- green
				Clamp(height - zoffset - terrain_GetHeight(pos), 0, max_diff),
				max_diff
			)
		end
		local line = PlacePolyline(points, colors)
		line:SetPos(AveragePoint2D(points))
		Flight_DbgLines_c = Flight_DbgLines_c + 1
		Flight_DbgLines[Flight_DbgLines_c] = line
	end

	local function Flight_DbgClear()
		SuspendPassEdits("ChoGGi_Flight_DbgClear")
		for i = 1, #Flight_DbgLines do
			Flight_DbgLines[i]:delete()
		end
		ResumePassEdits("ChoGGi_Flight_DbgClear")
		table.iclear(Flight_DbgLines)
		Flight_DbgLines_c = 0
	end

	local grid_thread
	function ChoGGi.ComFuncs.FlightGrid_Update(size,zoffset)
		if grid_thread then
			DeleteThread(grid_thread)
			grid_thread = nil
			Flight_DbgClear()
		end
		ChoGGi.ComFuncs.FlightGrid_Toggle(size,zoffset)
	end
	function ChoGGi.ComFuncs.FlightGrid_Toggle(size,zoffset)
		if grid_thread then
			DeleteThread(grid_thread)
			grid_thread = nil
			Flight_DbgClear()
			return
		end
		grid_thread = CreateMapRealTimeThread(function()
			local Sleep = Sleep
			local orig_size = size or 256 * guim
			local pos_c,pos_t,pos
			while true do
				pos_t = GetTerrainCursor()
				if pos_c ~= pos_t then
					pos_c = pos_t
					pos = pos_t
					Flight_DbgClear()
					-- Flight_DbgRasterArea
					size = orig_size
					local steps = 1 + (size + dbg_step - 1) / dbg_step
					size = steps * dbg_step
					pos = pos - point(size, size) / 2
					for y = 0,steps do
						Flight_DbgRasterLine(pos + point(0, y*dbg_step), pos + point(size, y*dbg_step), zoffset)
					end
					for x = 0,steps do
						Flight_DbgRasterLine(pos + point(x*dbg_step, 0), pos + point(x*dbg_step, size), zoffset)
					end

					Sleep(10)
				end
				Sleep(50)
			end
		end)
	end
end -- do

function ChoGGi.ComFuncs.DraggableCheatsMenu(which)
	local XShortcutsTarget = XShortcutsTarget

	if which then
		-- add a bit of spacing above menu
		XShortcutsTarget.idMenuBar:SetPadding(box(0, 6, 0, 0))

		-- add move control to menu
		XShortcutsTarget.idMoveControl = g_Classes.XMoveControl:new({
			Id = "idMoveControl",
			MinHeight = 6,
			VAlign = "top",
		}, XShortcutsTarget)

		-- move the move control to the padding space we created above
		DelayedCall(1, function()
			-- needs a delay (cause we added the control?)
			local height = XShortcutsTarget.idToolbar.box:maxy() * -1
			XShortcutsTarget.idMoveControl:SetMargins(box(0,height,0,0))
		end)
	elseif XShortcutsTarget.idMoveControl then
		-- remove my control and padding
		XShortcutsTarget.idMoveControl:delete()
		XShortcutsTarget.idMenuBar:SetPadding(box(0, 0, 0, 0))
		-- restore to original pos by toggling menu vis
		if ChoGGi.UserSettings.ShowCheatsMenu then
			ChoGGi.ComFuncs.CheatsMenu_Toggle()
			ChoGGi.ComFuncs.CheatsMenu_Toggle()
		end
	end
end

function ChoGGi.ComFuncs.CheatsMenu_Toggle()
	local ChoGGi = ChoGGi
	if ChoGGi.UserSettings.ShowCheatsMenu then
		-- needs default
		ChoGGi.UserSettings.ShowCheatsMenu = false
		XShortcutsTarget:SetVisible()
	else
		ChoGGi.UserSettings.ShowCheatsMenu = true
		XShortcutsTarget:SetVisible(true)
	end
	ChoGGi.SettingFuncs.WriteSettings()
end

do -- UpdateConsoleMargins
	-- normally visible
	local margin_vis = box(10, 80, 10, 65)
	-- console hidden
	local margin_hidden = box(10, 80, 10, 10)

	local margin_vis_editor_log = box(10, 80, 10, 45)

	local margin_vis_con_log = box(10, 80, 10, 115)
	local IsEditorActive = IsEditorActive
	local con_margin_editor = box(0, 0, 0, 50)
	local con_margin_norm = box(0, 0, 0, 0)

	function ChoGGi.ComFuncs.UpdateConsoleMargins(console_vis)
		if dlgConsoleLog then
			-- move log text above the buttons i added and make sure log text stays below the cheat menu
			if console_vis then
				-- editor mode adds a toolbar to the bottom, so we go above it
				if IsEditorActive() then
					dlgConsole:SetMargins(con_margin_editor)
					dlgConsoleLog.idText:SetMargins(margin_vis_con_log)
				else
					dlgConsole:SetMargins(con_margin_norm)
					dlgConsoleLog.idText:SetMargins(margin_vis)
				end
			else
				if IsEditorActive() then
					dlgConsole:SetMargins(con_margin_editor)
					dlgConsoleLog.idText:SetMargins(margin_vis_editor_log)
				else
					dlgConsole:SetMargins(con_margin_norm)
					dlgConsoleLog.idText:SetMargins(margin_hidden)
				end
			end
		end
	end
end -- do

function ChoGGi.ComFuncs.Editor_Toggle()
	-- force editor to toggle once (makes status text work properly the "first" toggle instead of the second)
	local idx = TableFind(terminal.desktop,"class","EditorInterface")
	if not idx then
		EditorState(1,1)
		EditorDeactivate()
	end

	local Platform = Platform
	-- copy n paste from... somewhere?
	if IsEditorActive() then
		EditorDeactivate()
--~ 		EditorState(0)
--~ 		table.restore(hr, "Editor")
--~ 		editor.SavedDynRes = false
--~ 		XShortcutsSetMode("Game")
		Platform.editor = false
		Platform.developer = false
		-- restore cheats menu if enabled
		if ChoGGi.UserSettings.ShowCheatsMenu then
			ChoGGi.ComFuncs.CheatsMenu_Toggle()
			ChoGGi.ComFuncs.CheatsMenu_Toggle()
		end
	else
		Platform.editor = true
		Platform.developer = true
		table.change(hr, "Editor", {
			ResolutionPercent = 100,
			SceneWidth = 0,
			SceneHeight = 0,
			DynResTargetFps = 0,
			EnablePreciseSelection = 1,
			ObjectCounter = 1,
			VerticesCounter = 1,
			FarZ = 1500000
		})
		XShortcutsSetMode("Editor", function()
			EditorDeactivate()
		end)
		EditorState(1,1)
	end

	ChoGGi.ComFuncs.UpdateConsoleMargins()

	camera.Unlock(1)
	ChoGGi.ComFuncs.SetCameraSettings()
end

function ChoGGi.ComFuncs.TerrainEditor_Toggle()
	local ChoGGi = ChoGGi
	ChoGGi.ComFuncs.Editor_Toggle()
	local ToggleCollisions = ChoGGi.ComFuncs.ToggleCollisions
	if Platform.editor then
		editor.ClearSel()
		-- need to set it to something
		SetEditorBrush(const.ebtTerrainType)
	else
		-- disable collisions on pipes beforehand, so they don't get marked as uneven terrain
		ToggleCollisions()
		-- update uneven terrain checker thingy
		RecalcBuildableGrid()
		-- and back on when we're done
		ToggleCollisions()
		-- close dialog
		if Dialogs.TerrainBrushesDlg then
			Dialogs.TerrainBrushesDlg:delete()
		end
		-- update flight grid so shuttles don't fly into newly added mountains
		ChoGGi.ComFuncs.UpdateFlightGrid()
	end
end

function ChoGGi.ComFuncs.PlaceObjects_Toggle()
	ChoGGi.ComFuncs.Editor_Toggle()
	if Platform.editor then
		editor.ClearSel()
		-- place rocks/etc
		SetEditorBrush(const.ebtPlaceSingleObject)
	else
		-- close dialog
		if Dialogs.PlaceObjectDlg then
			Dialogs.PlaceObjectDlg:delete()
		end
	end
end

do -- AddGridHandles
	local function AddHandles(name)
		local UICity = UICity
		for i = 1, #UICity[name] do
			UICity[name][i].ChoGGi_GridHandle = i
		end
	end

	function ChoGGi.ComFuncs.UpdateGridHandles()
		AddHandles("air")
		AddHandles("electricity")
		AddHandles("water")
	end
end -- do

-- set task request to new amount (for some reason changing the "limit" will also boost the stored amount)
-- this will reset it back to whatever it was after changing it.
function ChoGGi.ComFuncs.SetTaskReqAmount(obj,value,task,setting)
	-- if it's in a table, it's almost always [1], i'm sure i'll have lots of crap to fix on any update anyways, so screw it
	if type(obj[task]) == "userdata" then
		task = obj[task]
	else
		task = obj[task][1]
	end

	-- get stored amount
	local amount = obj[setting] - task:GetActualAmount()
	-- set new amount
	obj[setting] = value
	-- and reset 'er
	task:ResetAmount(obj[setting])
	-- then add stored, but don't set to above new limit or it'll look weird (and could mess stuff up)
	if amount > obj[setting] then
		task:AddAmount(obj[setting] * -1)
	else
		task:AddAmount(amount * -1)
	end
end

function ChoGGi.ComFuncs.ReturnEditorType(list,key,value)
	local idx = TableFind(list, key, value)
	value = list[idx].editor
	-- I use it to compare to type() so
	if value == "bool" then
		return "boolean"
	elseif value == "text" or value == "combo" then
		return "string"
	else
		-- at least number is number, and i don't give a crap about the rest
		return value
	end
end

function ChoGGi.ComFuncs.UpdateServiceComfortBld(obj,service_stats)
	if not obj or not service_stats then
		return
	end

	-- check for type as some are boolean
	if type(service_stats.health_change) ~= "nil" then
		obj.base_health_change = service_stats.health_change
		obj.health_change = service_stats.health_change
	end
	if type(service_stats.sanity_change) ~= "nil" then
		obj.base_sanity_change = service_stats.sanity_change
		obj.sanity_change = service_stats.sanity_change
	end
	if type(service_stats.service_comfort) ~= "nil" then
		obj.base_service_comfort = service_stats.service_comfort
		obj.service_comfort = service_stats.service_comfort
	end
	if type(service_stats.comfort_increase) ~= "nil" then
		obj.base_comfort_increase = service_stats.comfort_increase
		obj.comfort_increase = service_stats.comfort_increase
	end

	if obj:IsKindOf("Service") then
		if type(service_stats.visit_duration) ~= "nil" then
			obj.base_visit_duration = service_stats.visit_duration
			obj.visit_duration = service_stats.visit_duration
		end
		if type(service_stats.usable_by_children) ~= "nil" then
			obj.usable_by_children = service_stats.usable_by_children
		end
		if type(service_stats.children_only) ~= "nil" then
			obj.children_only = service_stats.children_only
		end
		for i = 1, 11 do
			local name = StringFormat("interest%s",i)
			if service_stats[name] ~= "" and type(service_stats[name]) ~= "nil" then
				obj[name] = service_stats[name]
			end
		end
	end

end

do -- AddBlinkyToObj
	local DeleteThread = DeleteThread
	local IsValid = IsValid
	local blinky_obj
	local blinky_thread

	function ChoGGi.ComFuncs.AddBlinkyToObj(obj,timeout)
		if not IsValid(obj) then
			return
		end
		-- if it was attached to something deleted, or fresh start
		if not IsValid(blinky_obj) then
			blinky_obj = RotatyThing:new()
		end
		blinky_obj.ChoGGi_blinky = true
		-- stop any previous countdown
		DeleteThread(blinky_thread)
		-- make it visible incase it isn't
		blinky_obj:SetVisible(true)
		-- pick a spot to show it
		local spot
		local offset = 0
		if obj:HasSpot("Top") then
			spot = obj:GetSpotBeginIndex("Top")
		else
			spot = obj:GetSpotBeginIndex("Origin")
			offset = obj:GetEntityBBox():sizey()
			-- if it's larger then a dome, but isn't a BaseBuilding then we'll just ignore it (DomeGeoscapeWater)
			if offset > 10000 and not obj:IsKindOf("BaseBuilding") or offset < 250 then
				offset = 250
			end
		end
		-- attach blinky so it's noticeable
		obj:Attach(blinky_obj,spot)
		blinky_obj:SetAttachOffset(point(0,0,offset))
		-- hide blinky after we select something else or timeout, we don't delete since we move it from obj to obj
		blinky_thread = CreateRealTimeThread(function()
			WaitMsg("SelectedObjChange",timeout or 10000)
			blinky_obj:SetVisible()
		end)
	end
end -- do

function ChoGGi.ComFuncs.AttachSpots_Toggle(sel)
	sel = sel or ChoGGi.ComFuncs.SelObject()
	if not sel then
		return
	end
	if sel.ChoGGi_ShowAttachSpots then
		sel:HideSpots()
		sel.ChoGGi_ShowAttachSpots = nil
	else
		sel:ShowSpots()
		sel.ChoGGi_ShowAttachSpots = true
	end
end

do -- ShowAnimDebug_Toggle
	local RandomColour
	local function AnimDebug_Show(obj,colour)
		local text = PlaceObject("Text")
		text:SetColor(colour or RandomColour())
		text:SetFontId(UIL.GetFontID(StringFormat("%s, 14, bold, aa",ChoGGi.font)))
		text:SetCenter(true)
		local orient = Orientation:new()

		-- so we can delete them easy
		orient.ChoGGi_AnimDebug = true
		text.ChoGGi_AnimDebug = true
		obj:Attach(text, 0)
		obj:Attach(orient, 0)
		text:SetAttachOffset(point(0,0,obj:GetObjectBBox():sizez() + 100))
		CreateGameTimeThread(function()
			while IsValid(text) do
				local str = "%d. %s\n"
				text:SetText(str:format(1,obj:GetAnimDebug(1)))
				WaitNextFrame()
			end
		end)
	end

	local function AnimDebug_Hide(obj)
		obj:ForEachAttach(function(a)
			if a.ChoGGi_AnimDebug then
				a:delete()
			end
		end)
	end

	local function AnimDebug_ShowAll(cls)
		local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
		for i = 1, #objs do
			AnimDebug_Show(objs[i])
		end
	end

	local function AnimDebug_HideAll(cls)
		local objs = ChoGGi.ComFuncs.RetAllOfClass(cls)
		for i = 1, #objs do
			AnimDebug_Hide(objs[i])
		end
	end

	function ChoGGi.ComFuncs.ShowAnimDebug_Toggle(sel)
		RandomColour = RandomColour or ChoGGi.ComFuncs.RandomColour
		local sel = sel or SelectedObj
		if sel then
			if sel.ChoGGi_ShowAnimDebug then
				sel.ChoGGi_ShowAnimDebug = nil
				AnimDebug_Hide(sel)
			else
				sel.ChoGGi_ShowAnimDebug = true
				AnimDebug_Show(sel,white)
			end
		else
			local ChoGGi = ChoGGi
			ChoGGi.Temp.ShowAnimDebug = not ChoGGi.Temp.ShowAnimDebug
			if ChoGGi.Temp.ShowAnimDebug then
				AnimDebug_ShowAll("Building")
				AnimDebug_ShowAll("Unit")
				AnimDebug_ShowAll("CargoShuttle")
			else
				AnimDebug_HideAll("Building")
				AnimDebug_HideAll("Unit")
				AnimDebug_HideAll("CargoShuttle")
			end
		end
	end
end -- do

-- fixup name we get from Object
function ChoGGi.ComFuncs.ConstructionModeNameClean(itemname)
	--we want template_name or we have to guess from the placeobj name
	local tempname = itemname:match("^.+template_name%A+([A-Za-z_%s]+).+$")
	if not tempname then
		tempname = itemname:match("^PlaceObj%('(%a+).+$")
	end

	if tempname:find("Deposit") then
		local obj = PlaceObj(tempname, {
			"Pos", ChoGGi.ComFuncs.CursorNearestHex(),
			"revealed", true,
		})
		obj.max_amount = ChoGGi.ComFuncs.Random(1000 * ChoGGi.Consts.ResourceScale,100000 * ChoGGi.Consts.ResourceScale)
		obj:CheatRefill()
		obj.amount = obj.max_amount
	else
		ChoGGi.ComFuncs.ConstructionModeSet(tempname)
	end
end

-- place item under the mouse for construction
function ChoGGi.ComFuncs.ConstructionModeSet(itemname)
	-- make sure it's closed so we don't mess up selection
	if GetDialog("XBuildMenu") then
		CloseDialog("XBuildMenu")
	end
	-- fix up some names
	local fixed = ChoGGi.Tables.ConstructionNamesListFix[itemname]
	if fixed then
		itemname = fixed
	end
	-- n all the rest
	local igi = Dialogs.InGameInterface
	if not igi or not igi:GetVisible() then
		return
	end

	local bld_template = BuildingTemplates[itemname]
	if not bld_template then
		return
	end
	local _,_,can_build,action = UIGetBuildingPrerequisites(bld_template.build_category,bld_template,true)

	local dlg = Dialogs.XBuildMenu
	if action then
		action(dlg,{
			enabled = can_build,
			name = bld_template.id ~= "" and bld_template.id or bld_template.template_name,
			construction_mode = bld_template.construction_mode
		})
	else
		igi:SetMode("construction",{
			template = bld_template.template_name,
			selected_dome = dlg and dlg.context.selected_dome
		})
	end
	CloseXBuildMenu()
end

function ChoGGi.ComFuncs.DeleteLargeRocks()
	local function CallBackFunc(answer)
		if answer then
			SuspendPassEdits("DeleteLargeRocks")
			MapDelete(true, {"Deposition","WasteRockObstructorSmall","WasteRockObstructor"})
			ResumePassEdits("DeleteLargeRocks")
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		StringFormat("%s!\n%s",S[6779--[[Warning--]]],S[302535920001238--[[Removes rocks for that smooth map feel.--]]]),
		CallBackFunc,
		StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000855--[[Last chance before deletion!--]]])
	)
end

function ChoGGi.ComFuncs.DeleteSmallRocks()
	local function CallBackFunc(answer)
		if answer then
			SuspendPassEdits("DeleteSmallRocks")
			MapDelete(true, "StoneSmall")
			ResumePassEdits("DeleteSmallRocks")
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		StringFormat("%s!\n%s",S[6779--[[Warning--]]],S[302535920001238--[[Removes rocks for that smooth map feel.--]]]),
		CallBackFunc,
		StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000855--[[Last chance before deletion!--]]])
	)
end

-- build and show a list of attachments for changing their colours
function ChoGGi.ComFuncs.CreateObjectListAndAttaches(obj)
	local ChoGGi = ChoGGi
	obj = obj or ChoGGi.ComFuncs.SelObject()
	if not obj or obj and not obj:IsKindOf("ColorizableObject") then
		MsgPopup(
			302535920001105--[[Select/mouse over an object (buildings, vehicles, signs, rocky outcrops).--]],
			3595--[[Color--]]
		)
		return
	end

	local ItemList = {}
	local c = 0

	-- has no Attaches so just open as is
	if obj.GetNumAttaches and obj:GetNumAttaches() == 0 then
		ChoGGi.ComFuncs.ChangeObjectColour(obj)
		return
	else
		c = c + 1
		ItemList[c] = {
			text = StringFormat(" %s",obj.class),
			value = obj.class,
			obj = obj,
			hint = 302535920001106--[[Change main object colours.--]],
		}
		local attaches = ChoGGi.ComFuncs.GetAllAttaches(obj)
		for i = 1, #attaches do
			local a = attaches[i]
			if a:IsKindOf("ColorizableObject") then
				c = c + 1
				ItemList[c] = {
					text = a.class,
					value = a.class,
					parentobj = obj,
					obj = a,
					hint = StringFormat("%s\n%s: %s",S[302535920001107--[[Change colours of an attached object.--]]],S[302535920000955--[[Handle--]]],a.handle),
				}
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		items = ItemList,
		title = StringFormat("%s: %s",S[174--[[Color Modifier--]]],RetName(obj)),
		hint = 302535920001108--[[Double click to open object/attachment to edit (select to flash object).--]],
		custom_type = 1,
		custom_func = function(sel,dialog)
			ChoGGi.ComFuncs.ChangeObjectColour(sel[1].obj,sel[1].parentobj,dialog)
		end,
		select_flash = true,
	}
end

function ChoGGi.ComFuncs.ToggleCollisions(cls)
	-- pretty much the only thing I use it for, but just in case
	cls = cls or "LifeSupportGridElement"
	local CollisionsObject_Toggle = ChoGGi.ComFuncs.CollisionsObject_Toggle
	-- hopefully give it a bit more speed
	SuspendPassEdits("ToggleCollisions")
	MapForEach("map",cls,function(o)
		CollisionsObject_Toggle(o,true)
	end)
	ResumePassEdits("ToggleCollisions")
end

function ChoGGi.ComFuncs.OpenGedApp(name)
	return OpenGedApp(name, terminal.desktop)
end

do -- ChangeSurfaceSignsToMaterials
	local function ChangeEntity(cls,entity,random)
		SuspendPassEdits("ChangeSurfaceSignsToMaterials")
		MapForEach("map",cls,function(o)
			if random then
				o:ChangeEntity(StringFormat("%s%s",entity,Random(1,random)))
			else
				o:ChangeEntity(entity)
			end
		end)
		ResumePassEdits("ChangeSurfaceSignsToMaterials")
	end
	local function ResetEntity(cls)
		SuspendPassEdits("ChangeSurfaceSignsToMaterials")
		local entity = g_Classes[cls]:GetDefaultPropertyValue("entity")
		MapForEach("map",cls,function(o)
			o:ChangeEntity(entity)
		end)
		ResumePassEdits("ChangeSurfaceSignsToMaterials")
	end

	function ChoGGi.ComFuncs.ChangeSurfaceSignsToMaterials()

		local ItemList = {
			{text = S[302535920001079--[[Enable--]]],value = true,hint = 302535920001081--[[Changes signs to materials.--]]},
			{text = S[302535920000142--[[Disable--]]],value = false,hint = 302535920001082--[[Changes materials to signs.--]]},
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			if choice[1].value then
				ChangeEntity("SubsurfaceDepositWater","DecSpider_01")
				ChangeEntity("SubsurfaceDepositMetals","DecDebris_01")
				ChangeEntity("SubsurfaceDepositPreciousMetals","DecSurfaceDepositConcrete_01")
				ChangeEntity("TerrainDepositConcrete","DecDustDevils_0",5)
				ChangeEntity("SubsurfaceAnomaly","DebrisConcrete")
				ChangeEntity("SubsurfaceAnomaly_unlock","DebrisMetal")
				ChangeEntity("SubsurfaceAnomaly_breakthrough","DebrisPolymer")
			else
--~ 				ResetEntity("SubsurfaceDepositWater","SignWaterDeposit")
--~ 				ResetEntity("SubsurfaceDepositMetals","SignMetalsDeposit")
--~ 				ResetEntity("SubsurfaceDepositPreciousMetals","SignPreciousMetalsDeposit")
--~ 				ResetEntity("TerrainDepositConcrete","SignConcreteDeposit")
--~ 				ResetEntity("SubsurfaceAnomaly","Anomaly_01")
--~ 				ResetEntity("SubsurfaceAnomaly_unlock","Anomaly_04")
--~ 				ResetEntity("SubsurfaceAnomaly_breakthrough","Anomaly_02")
--~ 				ResetEntity("SubsurfaceAnomaly_aliens","Anomaly_03")
--~ 				ResetEntity("SubsurfaceAnomaly_complete","Anomaly_05")
				ResetEntity("SubsurfaceDepositWater")
				ResetEntity("SubsurfaceDepositMetals")
				ResetEntity("SubsurfaceDepositPreciousMetals")
				ResetEntity("TerrainDepositConcrete")
				ResetEntity("SubsurfaceAnomaly")
				ResetEntity("SubsurfaceAnomaly_unlock")
				ResetEntity("SubsurfaceAnomaly_breakthrough")
				ResetEntity("SubsurfaceAnomaly_aliens")
				ResetEntity("SubsurfaceAnomaly_complete")
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920001083--[[Change Surface Signs--]],
		}
	end
end -- do

do -- MovePointAwayXY
	local CalcZForInterpolation = CalcZForInterpolation
	local SetLen = SetLen
	-- this is the same as MovePointAway, but uses Z from src
	function ChoGGi.ComFuncs.MovePointAwayXY(src, dest, dist)
		dest, src = CalcZForInterpolation(dest, src)

		local v = dest - src
		v = SetLen(v, dist)
		v = src - v
		return v:SetZ(src:z())
	end
	-- this is the same as MovePoint, but uses Z from src
	function ChoGGi.ComFuncs.MovePointXY(src, dest, dist)
		dest, src = CalcZForInterpolation(dest, src)
		local v = dest - src
		if dist < v:Len() then
			v = SetLen(v, dist)
		end
		v = src + v
		return v:SetZ(src:z())
	end
end -- do

-- updates buildmenu with un/locked buildings if it's opened
function ChoGGi.ComFuncs.UpdateBuildMenu()
	local dlg = GetDialog("XBuildMenu")
	-- can't update what isn't there
	if dlg then
		-- only update categories if we need to
		local cats = dlg:GetCategories()
		local old_cats = dlg.idCategoryList.idCategoriesList
		local old_cats_c = #old_cats
		-- - 1 for the hidden cat
		if (#cats - 1) ~= old_cats_c then
			-- clear out old categories
			for i = old_cats_c, 1, -1 do
				old_cats[i]:delete()
			end
			-- add all new stuffs
			dlg:CreateCategoryItems(cats)
		end

		-- update item list (RefreshXBuildMenu())
		dlg:SelectCategory(dlg.category)
	end
end

function ChoGGi.ComFuncs.SetTableValue(tab,id,id_name,item,value)
	local idx = TableFind(tab,id,id_name)
	if idx then
		tab[idx][item] = value
		return tab[idx]
	end
end

do -- GetAllAttaches
	local objlist = objlist
	local attaches = {}
	local attaches_idx
	local count = 0
	local obj_cls
	local skip = {"BuildingSign","ExplorableObject","TerrainDeposit","DroneBase","Dome"}

	local function AddAttaches(obj)
		for _,a in pairs(obj) do
			if not attaches[a] and IsValid(a) and a.class ~= obj_cls and not a:IsKindOfClasses(skip) then
				attaches[a] = true
				count = count + 1
				attaches_idx[count] = a
			end
		end
	end

	local function ForEach(a)
		if not attaches[a] and IsValid(a) and a.class ~= obj_cls and not a:IsKindOfClasses(skip) then
			attaches[a] = true
			count = count + 1
			attaches_idx[count] = a
			-- add level limit?
			if a.ForEachAttach then
				a:ForEachAttach(ForEach)
			end
			local state_attaches = a.auto_attach_state_attaches
			if state_attaches then
				for i = 1, #state_attaches do
					for j = 1, #state_attaches[i] do
						AddAttaches(state_attaches[i][j])
					end
				end
			end
		end
	end

	function ChoGGi.ComFuncs.GetAllAttaches(obj)
		TableClear(attaches)
		if not IsValid(obj) then
			return attaches
		end

		-- we use objlist instead of plain table for delete all in examine
		attaches_idx = objlist:new()
		count = 0
		obj_cls = obj.class

		-- add regular attachments
		if obj.ForEachAttach then
			obj:ForEachAttach(ForEach)
		end

		-- add any non-attached attaches
		AddAttaches(obj)
		-- and the anim_obj added in gagarin
		if IsValid(obj.anim_obj) then
			AddAttaches(obj.anim_obj)
		end

		-- remove obj if it's in the list
		local idx = TableFind(attaches_idx,obj)
		if idx then
			TableRemove(attaches_idx,idx)
		end

		return attaches_idx
	end
end -- do

do -- PadNumWithZeros
	local str = "%s%s"
	-- 100,00000 = "00100"
	function ChoGGi.ComFuncs.PadNumWithZeros(num,pad)
		if pad then
			pad = tostring(pad)
		else
			pad = "00000"
		end
		num = tostring(num)
		while #num < #pad do
			num = str:format("0",num)
		end
		return num
	end
end -- do

do -- UpdateFlightGrid
	local GetMapSize = terrain.GetMapSize
	local IsHeightChanged = terrain.IsHeightChanged
	local GetHeightGrid = terrain.GetHeightGrid
	local Flight_MarkPathSpline = Flight_MarkPathSpline

	local type_tile = terrain.TypeTileSize()
	local work_step = 16 * type_tile
	local mark_step = 16 * type_tile
	local function Flight_NewGrid(step, packing)
		local mw = GetMapSize()
		local work_size = mw / (step or work_step)
		return grid(work_size, packing or 32)
	end
	local function TrajectMark(spline)
		return spline and Flight_MarkPathSpline(Flight_Traject, spline, mark_step)
	end

	function ChoGGi.ComFuncs.UpdateFlightGrid()
		Flight_Free()

		Flight_OrigHeight = Flight_NewGrid()
		GetHeightGrid(Flight_OrigHeight, work_step, IsHeightChanged())

		if not Flight_OrigHeight then
			Flight_OrigHeight = Flight_NewGrid()
			GetHeightGrid(Flight_OrigHeight, work_step, IsHeightChanged())
		end

		Flight_Height = Flight_OrigHeight:clone()
		local Flight_MarkedObjs = Flight_MarkedObjs
		if Flight_MarkedObjs then
			for obj in pairs(Flight_MarkedObjs) do
				if not Flight_ObjToUnmark[obj] then
					Flight_ObjsToMark[obj] = true
				end
			end
		else
			Flight_ObjsToMark = {}
			MapForEach("map", "attached", false, nil, mark_flags,function(obj)
				Flight_ObjsToMark[obj] = true
			end)
		end
		Flight_ObjToUnmark = {}
		Flight_MarkedObjs = {}
		MarkThreadProc()

		Flight_Traject = Flight_NewGrid(mark_step, 16)
		MapForEach("map", "FlyingObject", function(obj)
			if obj.idle_mark_pos then
				Flight_Traject:AddCircle(1, obj.idle_mark_pos, mark_step, obj.collision_radius)
			end
			TrajectMark(obj.current_spline)
			TrajectMark(obj.next_spline)
		end)

		local objs = FlyingObjs or ""
		for i = 1, #objs do
			objs[i]:RegisterFlight()
		end
	end
end -- do

function ChoGGi.ComFuncs.RemoveObjs(cls)
	if PropObjGetProperty(_G,cls) then
		MapDelete(true, cls)
	end
end

do -- SpawnColonist
	local Msg = Msg
	local GenerateColonistData = GenerateColonistData
	local GetRandomPassablePoint = GetRandomPassablePoint

	function ChoGGi.ComFuncs.SpawnColonist(old_c,building,pos,city)
		city = city or UICity

		local colonist
		if old_c then
	--~		 colonist = GenerateColonistData(city, old_c.age_trait, false, old_c.gender, old_c.entity_gender, true)
			colonist = GenerateColonistData(city, old_c.age_trait, false, {gender=old_c.gender,entity_gender=old_c.entity_gender,no_traits = "no_traits",no_specialization=true})
			--we set all the set gen doesn't (it's more for random gen after all
			colonist.birthplace = old_c.birthplace
			colonist.death_age = old_c.death_age
			colonist.name = old_c.name
			colonist.race = old_c.race
			colonist.specialist = old_c.specialist
			for trait_id, _ in pairs(old_c.traits) do
				if trait_id and trait_id ~= "" then
					colonist.traits[trait_id] = true
					--colonist:AddTrait(trait_id,true)
				end
			end
		else
			--GenerateColonistData(city, age_trait, martianborn, gender, entity_gender, no_traits)
			colonist = GenerateColonistData(city)
		end

		Colonist:new(colonist)
		Msg("ColonistBorn", colonist)

		colonist:SetPos(pos or building and GetPassablePointNearby(building:GetPos()) or GetRandomPassablePoint())
		--dome:UpdateUI()
		--if spec is different then updates to new entity
		colonist:ChooseEntity()
		return colonist
	end
end -- do

function ChoGGi.ComFuncs.GetParentOfKind(win, cls)
	while win and not win:IsKindOf(cls) do
		win = win.parent
	end
	return win
end

do -- IsControlPressed/IsShiftPressed/IsAltPressed
	local IsKeyPressed = terminal.IsKeyPressed
	local vkControl = const.vkControl
	local vkShift = const.vkShift
	local vkAlt = const.vkAlt
	local vkLwin = const.vkLwin
	local osx = Platform.osx
	function ChoGGi.ComFuncs.IsControlPressed()
		return IsKeyPressed(vkControl) or osx and IsKeyPressed(vkLwin)
	end
	function ChoGGi.ComFuncs.IsShiftPressed()
		return IsKeyPressed(vkShift)
	end
	function ChoGGi.ComFuncs.IsAltPressed()
		return IsKeyPressed(vkAlt)
	end
end -- do

function ChoGGi.ComFuncs.RetAllOfClass(cls)
	-- if it isn't in g_Classes then MapGet will return everything
	if not g_Classes[cls] then
		return empty_table
	end
	local objects = UICity.labels[cls] or empty_table
	if #objects == 0 then
		return MapGet(true,cls)
	end
	return objects
end

-- associative tables only, otherwise table.is_iequal(t1,t1)
function ChoGGi.ComFuncs.TableIsEqual(t1,t2)
	-- see which one is longer, we use that as the looper
	local c1,c2 = 0,0
	for _ in pairs(t1) do
		c1 = c1 + 1
	end
	for _ in pairs(t2) do
		c1 = c1 + 1
	end

	local is_equal = true
	if c1 >= c2 then
		for key,value in pairs(t1) do
			if value ~= t2[key] then
				is_equal = false
				break
			end
		end
	else
		for key,value in pairs(t2) do
			if value ~= t1[key] then
				is_equal = false
				break
			end
		end
	end

	return is_equal
end

do -- LoadEntity
	-- no sense in making a new one for each entity
	local entity_templates = {
		decal = {
			category_Decors = true,
			entity = {
				fade_category = "Never",
				material_type = "Metal",
			},
		},
		building = {
			category_Buildings = true,
			entity = {
				class_parent = "BuildingEntityClass",
				fade_category = "Never",
				material_type = "Metal",
			},
		},
	}

	-- local instead of global is quicker
	local EntityData = EntityData
	local EntityLoadEntities = EntityLoadEntities
	local SetEntityFadeDistances = SetEntityFadeDistances

	function ChoGGi.ComFuncs.LoadEntity(name,path,mod,template)
		EntityData[name] = entity_templates[template or "decal"]

		EntityLoadEntities[#EntityLoadEntities + 1] = {
			mod,
			name,
			path
		}
		SetEntityFadeDistances(name, -1, -1)
	end
end -- do

function ChoGGi.ComFuncs.AddParentToClass(class_obj,parent_name)
	if not TableFind(class_obj,parent_name) then
		class_obj.__parents[#class_obj.__parents+1] = parent_name
	end
end
