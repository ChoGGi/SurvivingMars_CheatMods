-- See LICENSE for terms

local S = ChoGGi.Strings
local testing = ChoGGi.testing
-- Init.lua
local TableConcat = ChoGGi.ComFuncs.TableConcat
-- Strings.lua
local Trans = ChoGGi.ComFuncs.Translate

local pairs,tonumber,type,rawget = pairs,tonumber,type,rawget
local getmetatable,tostring = getmetatable,tostring
local PropObjGetProperty = PropObjGetProperty
local AsyncRand = AsyncRand
local IsValid = IsValid
local IsKindOf = IsKindOf
local GetTerrainCursor = GetTerrainCursor
local MapFilter = MapFilter
local MapGet = MapGet
local FindNearestObject = FindNearestObject
local table_remove = table.remove
local table_find = table.find
local table_clear = table.clear

-- backup orginal function for later use (checks if we already have a backup, or else problems)
local function SaveOrigFunc(class_or_func,func_name)
	local OrigFuncs = ChoGGi.OrigFuncs

	if func_name then
		local newname = class_or_func .. "_" .. func_name
		if not OrigFuncs[newname] then
			OrigFuncs[newname] = _G[class_or_func][func_name]
		end
	else
		if not OrigFuncs[class_or_func] then
			OrigFuncs[class_or_func] = _G[class_or_func]
		end
	end
end
ChoGGi.ComFuncs.SaveOrigFunc = SaveOrigFunc

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
		local newname = class_name .. "_" .. func_name
		_G[class_name][func_name] = function(obj,...)
			-- send obj along with any extra args i added
			Msg(msg_str,obj,varargs)

--~ 			-- use to debug if getting an error
--~ 			local params = {...}
--~ 			-- pass on args to orig func
--~ 			if not pcall(function()
--~ 				return ChoGGi_OrigFuncs[class_name .. func_name](table.unpack(params))
--~ 			end) then
--~ 				print("Function Error: ",class_name .. func_name)
--~ 				ChoGGi.ComFuncs.OpenInExamineDlg{params}
--~ 			end

			return ChoGGi_OrigFuncs[newname](obj,...)
		end
	end
end -- do

do -- RetName
	local IsObjlist = IsObjlist
	local DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	local Trans = ChoGGi.ComFuncs.Translate

	-- we use this table to display names of (some) tables for RetName
	local lookup_table = {}

	-- funcs don't change, so we only need to go once
	local funcs = g_CObjectFuncs
	for key,value in pairs(funcs) do
		lookup_table[value] = key .. " *C func"
	end
	local function AddFuncs(list,name)
		for key,value in pairs(list) do
			if not lookup_table[value] then
				lookup_table[value] = "ChoGGi." .. name .. "." .. key
			end
		end
	end

	local function AfterLoad()
		local g = ChoGGi.Temp._G

		-- ECM func names
		AddFuncs(g.ChoGGi.ComFuncs,"ComFuncs")
		AddFuncs(g.ChoGGi.ConsoleFuncs,"ConsoleFuncs")
		AddFuncs(g.ChoGGi.InfoFuncs,"InfoFuncs")
		AddFuncs(g.ChoGGi.MenuFuncs,"MenuFuncs")
		AddFuncs(g.ChoGGi.SettingFuncs,"SettingFuncs")
		AddFuncs(g.ChoGGi.OrigFuncs,"OrigFuncs")

		lookup_table[g.terminal.desktop] = "terminal.desktop"

		-- any tables/funcs in _G
		for key,value in pairs(g) do
			-- no need to add tables already added
			if not lookup_table[value] then
				local t = type(value)
				if t == "table" then
					lookup_table[value] = key
				elseif t == "function" then
					if DebugGetInfo(value) == "[C](-1)" then
						lookup_table[value] = key .. " *C func"
					else
						lookup_table[value] = key
					end
				end
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

	local values_lookup = {
		"encyclopedia_id",
		"id",
		"Id",
		"ActionName",
		"ActionId",
		"template_name",
		"template_class",
		"class",
		"__mtl",
	}

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
		elseif obj_type == "number" or obj_type == "boolean" then
			return tostring(obj)

		elseif obj_type == "table" then
			-- we need to use PropObjGetProperty to check (seems more consistent then rawget), as some stuff like mod.env has it's own __index and causes the game to log a warning
			local index = getmetatable(obj)
			index = index and index.__index

			-- we check in order of less generic "names"
			local name_type = PropObjGetProperty(obj,"name") and type(obj.name)

			-- custom name from user (probably)
			if name_type == "string" and obj.name ~= "" then
				name = obj.name
			-- colonist names
			elseif name_type == "table" then
				name = Trans(obj.name)

			-- display
			elseif PropObjGetProperty(obj,"display_name") and obj.display_name ~= "" then
				name = Trans(obj.display_name)
			-- entity
			elseif PropObjGetProperty(obj,"entity") and obj.entity ~= "" then
				name = obj.entity
			-- objlist
			elseif IsObjlist(obj) then
				return "objlist"

			else
				for i = 1, #values_lookup do
					local value_name = values_lookup[i]
					if index then
						if PropObjGetProperty(obj,value_name) and obj[value_name] ~= "" then
							name = obj[value_name]
							break
						end
					else
						local value = obj[value_name]
						if value and value ~= "" then
							name = value
							break
						end
					end
				end
				--
				if type(name) == "userdata" then
					name = Trans(name)
				end
			end -- if table

		elseif obj_type == "userdata" then
			local trans_str = Trans(obj)
			-- missing text is from internaltranslate, i check the str length before calling the func as it has to be at least 16 chars
			if trans_str == "Missing text" or #trans_str > 16 and trans_str:sub(-16) == " *bad string id?" then
				return tostring(obj)
			end
			return trans_str

		elseif obj_type == "function" then
			return DebugGetInfo(obj)

		end

		-- just in case...
		return type(name) == "string" and name or tostring(name or obj)
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
		return Trans(3718--[[NONE--]])
	end
end

-- "table.table.table.etc" = returns etc as object
-- use .number for index based tables ("terminal.desktop.1.box")
-- root is where we start looking (defaults to _G).
-- create is a boolean to add a table if the dotname is absent.
local function DotNameToObject(str,root,create)

	-- lazy is best
	if type(str) ~= "string" then
		return str
	end

	local g = ChoGGi.Temp._G
	-- there's always one
	if str == "_G" then
		return g
	end
	if str == "_ENV" then
		return _ENV
	end

	-- parent always starts out as "root"
	local parent = root or g

	-- https://www.lua.org/pil/14.1.html
	-- %w is [A-Za-z0-9], [] () + ? . act like regexp (lua patterns)
	for name,match in str:gmatch("([%w_]+)(.?)") do
		-- if str included .number we need to make it a number or [name] won't work
		local num = tonumber(name)
		if num then
			name = num
		end

		local obj_child
		if parent == g then
			-- SM error spams console if you have the affront to try _G.NonExistingKey... (thanks autorun.lua)
			-- it works prefectly fine of course, but i like a clean log.
			-- in other words a workaround for "Attempt to use an undefined global '"
			obj_child = rawget(parent,name)
		else
			obj_child = parent[name]
		end

		-- . means we're not at the end yet
		if match == "." then
			-- create is for adding new settings in non-existent tables
			if not obj_child and not create then
				-- our treasure hunt is cut short, so return nadda
				return
			end
			-- change the parent to the child (create table if absent, this'll only fire when create)
			parent = obj_child or {}
		else
			-- no more . so we return as conquering heroes with the obj
			return obj_child
		end

	end
end
ChoGGi.ComFuncs.DotNameToObject = DotNameToObject

local function GetParentOfKind(win, cls)
	while win and not win:IsKindOf(cls) do
		win = win.parent
	end
	return win
end
ChoGGi.ComFuncs.GetParentOfKind = GetParentOfKind

do -- ValidateImage
	local MeasureImage = UIL.MeasureImage
	local default = ChoGGi.library_path .. "UI/TheIncal.png"

	function ChoGGi.ComFuncs.ValidateImage(image,fallback)
		-- if measure isn't sent a string it'll spam the log
		image = tostring(image)

		-- first we try the image path as is
		local m = MeasureImage(image)
		-- if x is 0 then it probably isn't a valid image (measure sends back x,y)
		if m == 0 then
			-- try with my lib path
			image = ChoGGi.library_path .. image
			m = MeasureImage(image)
			-- falling back
			if fallback and m == 0 then
				image = fallback
				m = MeasureImage(image)
				if m == 0 then
					image = ChoGGi.library_path .. fallback
					m = MeasureImage(image)
					-- falling way back
					if m == 0 then
						-- should always exist
						image = default
					end
				end
			end
		end

		return image
	end
end
local ValidateImage = ChoGGi.ComFuncs.ValidateImage

do -- MsgPopup
	local TableSet_defaults = table.set_defaults
	local OpenDialog = OpenDialog

	-- shows a popup msg with the rest of the notifications
	-- objects can be a single obj, or {obj1,obj2,etc}
	function ChoGGi.ComFuncs.MsgPopup(text,title,image,size,objects)
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
--~ 			{expiration = max_int},
--~ 			dismissable = false,
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
			title = title or "",
			text = text or Trans(3718--[[NONE--]]),
			image = ValidateImage(image,"UI/TheIncal.png"),
		}
		TableSet_defaults(data, params)
		TableSet_defaults(data, OnScreenNotificationPreset)
		if objects then
			if type(objects) ~= "table" then
				objects = {objects}
			end
			params.cycle_objs = objects
		end

		-- needed in Sagan update
		local aosn = g_ActiveOnScreenNotifications
		local idx = table_find(aosn, 1, data.id) or #aosn + 1
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
				local frame = GetParentOfKind(popup.idText, "XFrame")
				if frame then
					frame:SetMaxWidth(1000)
				end
				popup.idText:SetMaxHeight(250)
			end
		end)
	end
end -- do
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

do -- ShowObj
	local IsPoint = IsPoint
	local IsValid = IsValid
	local guic = guic
	local ViewObjectMars = ViewObjectMars
	local PlaceObject = PlaceObject
	local InvalidPos = ChoGGi.Consts.InvalidPos
	-- we just use a few noticeable colours for rand
	local rand_colours = {
		green,yellow,cyan,white,red,
		-4587265, -- purple
		-39680, -- slightly darker orange (don't want it blending in to the ground as much as -23296)
	}
	local rand_colours_c = #rand_colours
	local function rand_c()
		return rand_colours[AsyncRand(rand_colours_c)]
	end
	ChoGGi.ComFuncs.RandomColourLimited = rand_c

	local markers = {}
	function ChoGGi.ComFuncs.RetObjMarkers()
		return markers
	end

	local function ClearMarker(k,v)
		v = v or markers[k]
		if IsValid(k) then
			if k.ChoGGi_ShowObjColour then
				k:SetColorModifier(k.ChoGGi_ShowObjColour)
				k.ChoGGi_ShowObjColour = nil
			elseif v == "vector" or k:IsKindOf("ChoGGi_OSphere") then
				k:delete()
			end
		end

		if IsValid(v) and v:IsKindOf("ChoGGi_OSphere") then
			v:delete()
		end

		markers[k] = nil
	end

	function ChoGGi.ComFuncs.ClearShowObj(obj_or_bool)
		SuspendPassEdits("ChoGGi.ComFuncs.ClearShowObj")

		-- any markers in the list
		if obj_or_bool == true then
			for k,v in pairs(markers) do
				ClearMarker(k,v)
			end
			table_clear(markers)
			ResumePassEdits("ClearShowObj")
			return
		end

		-- try and clean up obj
		local is_valid = IsValid(obj_or_bool)
		local is_point = IsPoint(obj_or_bool)
		if is_valid or is_point then

			if is_valid then
				-- could be stored as obj ref or stringed pos ref
				local pos = is_valid and tostring(obj_or_bool:GetVisualPos())
				if markers[pos] or markers[obj_or_bool] or obj_or_bool.ChoGGi_ShowObjColour then
					ClearMarker(pos)
					ClearMarker(obj_or_bool)
				end
			elseif is_point then
				-- or just a point
				local pt_obj = is_point and tostring(obj_or_bool)
				if markers[pt_obj] then
					ClearMarker(pt_obj)
				end
			end
		end

--~ 		printC("overkill")
--~ 		-- overkill: could be from a saved game so remove any objects on the map (they shouldn't be left in a normal game)
--~ 		MapDelete(true, {"ChoGGi_OVector","ChoGGi_OSphere"})
		ResumePassEdits("ChoGGi.ComFuncs.ClearShowObj")
	end

	function ChoGGi.ComFuncs.ColourObj(obj, colour)
		local is_valid = IsValid(obj)
		if not is_valid or is_valid and not obj:IsKindOf("ColorizableObject") then
			return
		end

		obj.ChoGGi_ShowObjColour = obj.ChoGGi_ShowObjColour or obj:GetColorModifier()
		markers[obj] = obj.ChoGGi_ShowObjColour
		obj:SetColorModifier(colour or rand_c())
		return obj
	end

	local function AddSphere(pt,colour)
		local pos = tostring(pt)
		if not IsValid(markers[pos]) then
			markers[pos] = nil
		end

		if markers[pos] then
			-- update with new colour
			markers[pos]:SetColor(colour)
		else
			local sphere = PlaceObject("ChoGGi_OSphere")
			sphere:SetPos(pt)
			sphere:SetRadius(50 * guic)
			sphere:SetColor(colour)
			markers[pos] = sphere
		end
		return markers[pos]
	end

	function ChoGGi.ComFuncs.ShowPoint(obj, colour)
		colour = colour or rand_c()
		-- single pt
		if IsPoint(obj) and InvalidPos ~= obj then
			return AddSphere(obj,colour)
		end
		-- obj to pt
		if IsValid(obj) then
			local pt = obj:GetVisualPos()
			if IsValid(obj) and InvalidPos ~= pt then
				return AddSphere(pt,colour)
			end
		end

		-- two points
		if type(obj) ~= "table" then
			return
		end
		if IsPoint(obj[1]) and IsPoint(obj[2]) and InvalidPos ~= obj[1] and InvalidPos ~= obj[2] then
			local vector = PlaceObject("ChoGGi_OVector")
			vector:Set(obj[1], obj[2], colour or rand_c())
			markers[vector] = "vector"
			return vector
		end
	end

	-- marks pt of obj and optionally colours/moves camera
	function ChoGGi.ComFuncs.ShowObj(obj, colour, skip_view, skip_colour)
		if markers[obj] then
			return markers[obj]
		end
		local is_valid = IsValid(obj)
		local is_point = IsPoint(obj)
		if not (is_valid or is_point) then
			return
		end
		colour = colour or rand_c()
		local vis_pos = is_valid and obj:GetVisualPos()

		local pt = is_point and obj or vis_pos
		local sphere_obj
		if pt and pt ~= InvalidPos and not markers[pt] then
			sphere_obj = AddSphere(pt,colour)
		end

		if is_valid and not skip_colour then
			obj.ChoGGi_ShowObjColour = obj.ChoGGi_ShowObjColour or obj:GetColorModifier()
			markers[obj] = obj.ChoGGi_ShowObjColour
			obj:SetColorModifier(colour)
		end

		pt = pt or vis_pos
		if not skip_view and pt ~= InvalidPos then
			ViewObjectMars(pt)
		end

		return sphere_obj
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

		if item.is_spacer then
			item.name = "~~~"
			item.disable = true
			item.centred = true
		end

		-- "ChoGGi_CheckButtonMenu"
		local cls = g_Classes[item.class or "ChoGGi_ButtonMenu"]
		local button = cls:new({
			RolloverTitle = item.hint_title and item.hint_title or item.obj and RetName(item.obj) or Trans(126095410863--[[Info--]]),
			RolloverText = item.hint or "",
			RolloverHint = item.hint_bottom or S[302535920000083--[[<left_click> Activate--]]],
			Text = item.name,
			Background = items.Background,
			PressedBackground = items.PressedBackground,
			FocusedBackground = items.FocusedBackground,
			TextStyle = items.TextStyle or cls.TextStyle,
			HAlign = item.centred and "center" or "stretch",
		}, popup.idContainer)

		if item.disable then
			button.idLabel.RolloverTextColor = button.idLabel.TextColor
			button.RolloverBackground = items.Background
			button.PressedBackground = items.Background
			button.RolloverZoom = g_Classes.XWindow.RolloverZoom
			button.MouseCursor = "UI/Cursors/cursor.tga"
		end

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
		elseif not item.disable then
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
				ClearShowObj(true)
				ShowObj(item.showobj, nil, true)
			end
		end

		local colourobj_func
		if item.colourobj then
			colourobj_func = function()
				ClearShowObj(true)
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
			-- add the ...
			g_Classes.ChoGGi_Label:new({
				Dock = "right",
				text = "...",
				TextStyle = items.TextStyle or cls.TextStyle,
			}, button)

			local name = "ChoGGi_submenu_" .. item.name
			submenu_func = function(self)
				-- close if another is opened
				local submenu = popup[name]
				if submenu then
					submenu:Close()
				end
				-- build the new one/open it
				submenu = g_Classes.ChoGGi_PopupList:new({
					Opened = true,
					Id = "ChoGGi_submenu_popup",
					popup_parent = popup,
					AnchorType = "smart",
					Anchor = self.box,
				}, terminal.desktop)
				ChoGGi.ComFuncs.PopupBuildMenu(item.submenu,submenu)
				submenu:Open()
				-- add it to the popup
				popup[name] = submenu
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
		local cls = ChoGGi_PopupList

		items.Background = items.Background or cls.Background
		items.FocusedBackground = items.FocusedBackground or cls.FocusedBackground
		items.PressedBackground = items.PressedBackground or cls.PressedBackground

		popup = cls:new({
			Opened = true,
			Id = popup_id,
			-- "top" for the console, default "none"
			AnchorType = anchor or "top",
			-- "none","smart","left","right","top","center-top","bottom","mouse"
			Anchor = parent.box,
			Background = items.Background,
			FocusedBackground = items.FocusedBackground,
			PressedBackground = items.PressedBackground,
		}, terminal.desktop)

		popup.items = items

		ChoGGi.ComFuncs.PopupBuildMenu(items,popup)

		-- when i send parent as a table with self and box coords
		parent = parent.ChoGGi_self or parent

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
function ChoGGi.ComFuncs.Circle(pos, radius, colour, time)
	local circle = PlaceObject("ChoGGi_OCircle")
	circle:SetPos(pos and pos:SetTerrainZ(10 * guic) or GetTerrainCursor())
	circle:SetRadius(radius or 1000)
	circle:SetColor(colour or white)

	CreateRealTimeThread(function()
		Sleep(time or 50000)
		if IsValid(circle) then
			circle:delete()
		end
	end)
end

-- this is a question box without a question (WaitPopupNotification only works in-game, not main menu)
function ChoGGi.ComFuncs.MsgWait(text,title,image,ok_text,context,parent)
	-- thread needed for WaitMarsQuestion
	CreateRealTimeThread(function()
		local dlg = CreateMarsQuestionBox(
			title or Trans(1000016--[[Title--]]),
			text or Trans(3718--[[NONE--]]),
			ok_text or Trans(6878--[[OK--]]),
			"",
			parent,
			ValidateImage(image,"UI/message_picture_01.png"),
			context
		)
		-- hide cancel button since we don't care about it, and we ignore them anyways...
		dlg.idList[2]:delete()
	end)
end

-- well that's the question isn't it?
function ChoGGi.ComFuncs.QuestionBox(text,func,title,ok_msg,cancel_msg,image,context,parent)
	CreateRealTimeThread(function()
		if WaitMarsQuestion(
			parent,
			title or Trans(1000016--[[Title--]]),
			text or Trans(3718--[[NONE--]]),
			ok_msg or Trans(6878--[[OK--]]),
			cancel_msg or Trans(6879--[[Cancel--]]),
			ValidateImage(image,"UI/message_picture_01.png"),
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
--~ 	elseif setting == value2 then
--~ 		return value1
	end
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
	-- else return equal or higher amount
	elseif a >= b then
		return a
	elseif b >= a then
		return b
	end
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

-- check for and remove broken objects from UICity.labels
function ChoGGi.ComFuncs.RemoveMissingLabelObjects(label)
	local UICity = UICity
	local list = UICity.labels[label] or ""
	for i = #list, 1, -1 do
		if not IsValid(list[i]) then
			table_remove(UICity.labels[label],i)
		end
	end
end

function ChoGGi.ComFuncs.RemoveMissingTableObjects(list,obj)
	if obj then
		for i = #list, 1, -1 do
			if #list[i][list] == 0 then
				table_remove(list,i)
			end
		end
	else
		for i = #list, 1, -1 do
			if not IsValid(list[i]) then
				table_remove(list,i)
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
			table_remove(UICity.labels[label],i)
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
	-- boolean
	if value == "true" or value == true then
		return true, "boolean"
	elseif value == "false" or value == false then
		return false, "boolean"
	end
	-- nil
	if value == "nil" then
		return nil, "nil"
	end
	-- number
	local num = tonumber(value)
	if num then
		return num, "number"
	end
	-- then it's a string (probably)
	return value, "string"
end

do -- RetType
	-- used to check for some SM objects (Points/Boxes)
	local IsBox = IsBox
	local IsPoint = IsPoint
	local IsQuaternion = IsQuaternion
	local IsRandState = IsRandState
	local IsGrid = IsGrid
	local IsPStr = IsPStr

	function ChoGGi.ComFuncs.RetType(obj)
		if getmetatable(obj) then
			if IsPoint(obj) then
				return "Point"
			end
			if IsBox(obj) then
				return "Box"
			end
			if IsQuaternion(obj) then
				return "Quaternion"
			end
			if IsRandState(obj) then
				return "RandState"
			end
			if IsGrid(obj) then
				return "Grid"
			end
			if IsPStr(obj) then
				return "PStr"
			end
		end
		return type(obj)
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

do -- RetTableNoDupes
	local dupe_t = {}
	function ChoGGi.ComFuncs.RetTableNoDupes(list)
		local temp_t = {}
		local c = 0
		-- quicker to make a new list on large tables
		if #list > 10000 then
			dupe_t = {}
		else
			table_clear(dupe_t)
		end

		for i = 1, #list do
			local item = list[i]
			if not dupe_t[item] then
				c = c + 1
				temp_t[c] = item
				dupe_t[item] = true
			end
		end

		return temp_t
	end
end -- do
local RetTableNoDupes = ChoGGi.ComFuncs.RetTableNoDupes

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
		return {}
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
		print(
		S[302535920001324--[[ECM: OpenInListChoice(list) is blank... This shouldn't happen.--]]],"\n",list,"\n",
			list and ValueToLuaCode(list)
		)
		return
	end

	return ChoGGi_ListChoiceDlg:new({}, terminal.desktop,{
		list = list,
	})
end

-- return a string setting/text for menus
function ChoGGi.ComFuncs.SettingState(setting,text)
	if type(setting) == "string" and setting:find("%.") then
		-- some of the menu items passed are "table.table.exists?.setting"
		local obj = DotNameToObject(setting)
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
		return "<color 0 255 0>" .. tostring(setting) .. "</color>: " .. text
	end

	return tostring(setting)
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
		for k in pairs(list) do
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
	local max_int = max_int

	local function TickStart(id)
		times[id] = GetPreciseTicks()
	end
	local function TickEnd(id,name)
		print(id,":",GetPreciseTicks() - (times[id] or max_int),name)
		times[id] = nil
	end
	ChoGGi.ComFuncs.TickStart = TickStart
	ChoGGi.ComFuncs.TickEnd = TickEnd

	function ChoGGi.ComFuncs.PrintFuncTime(func,...)
		local id = "PrintFuncTime " .. AsyncRand()
		local varargs = ...
		pcall(function()
			TickStart(id)
			func(varargs)
			TickEnd(id)
		end)
	end
end -- do

function ChoGGi.ComFuncs.UpdateDataTablesCargo()
	local Tables = ChoGGi.Tables

	-- update cargo resupply
	table_clear(Tables.Cargo)
	local ResupplyItemDefinitions = ResupplyItemDefinitions or ""
	for i = 1, #ResupplyItemDefinitions do
		local def = ResupplyItemDefinitions[i]
		Tables.Cargo[i] = def
		Tables.Cargo[def.id] = def
	end

	local settings = ChoGGi.UserSettings.CargoSettings or empty_table
	for id,cargo in pairs(settings) do
		local cargo_table = Tables.Cargo[id]
		if cargo_table then
			if cargo.pack then
				cargo_table.pack = cargo.pack
			end
			if cargo.kg then
				cargo_table.kg = cargo.kg
			end
			if cargo.price then
				cargo_table.price = cargo.price
			end
			if type(cargo.locked) == "boolean" then
				cargo_table.locked = cargo.locked
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
		local c

		local Tables = ChoGGi.Tables
		table_clear(Tables.CargoPresets)
		table_clear(Tables.ColonistAges)
		table_clear(Tables.ColonistBirthplaces)
		table_clear(Tables.ColonistGenders)
		table_clear(Tables.ColonistSpecializations)
		table_clear(Tables.Mystery)
		table_clear(Tables.NegativeTraits)
		table_clear(Tables.OtherTraits)
		table_clear(Tables.PositiveTraits)
		table_clear(Tables.Resources)
		Tables.SchoolTraits = const.SchoolTraits
		Tables.SanatoriumTraits = const.SanatoriumTraits

------------- mysteries
		c = 0
		-- build mysteries list (sometimes we need to reference Mystery_1, sometimes BlackCubeMystery
		local g_Classes = g_Classes
		ClassDescendantsList("MysteryBase",function(class)
			local cls_obj = g_Classes[class]
			local scenario_name = cls_obj.scenario_name or S[302535920000009--[[Missing Scenario Name--]]]
			local display_name = Trans(cls_obj.display_name) or S[302535920000010--[[Missing Name--]]]
			local description = Trans(cls_obj.rollover_text) or S[302535920000011--[[Missing Description--]]]

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

local function Random(m, n)
	if n then
		-- m = min, n = max
		return AsyncRand(n - m + 1) + m
	else
		-- m = max, min = 0 OR number between 0 and max_int
		return m and AsyncRand(m) or AsyncRand()
	end
end
ChoGGi.ComFuncs.Random = Random

--~ function ChoGGi.ComFuncs.OpenKeyPresserDlg()
--~ 	ChoGGi_KeyPresserDlg:new({}, terminal.desktop,{})
--~ end

function ChoGGi.ComFuncs.CreateSetting(str,setting_type)
	local setting = DotNameToObject(str,nil,true)
	if type(setting) == setting_type then
		return true
	end
end

-- returns whatever is selected > moused over > nearest object to cursor
function ChoGGi.ComFuncs.SelObject(radius)
	-- just in case it's called from main menu
	if not GameState.gameplay then
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
--~ 	local trigg_str = "TriggerDisaster%s%s"
	local DataInstances = DataInstances
	local function AddItems(name,suffix)
		local list = DataInstances[name]
		for i = 1, #list do
			remove_lookup["TriggerDisaster" .. list[i].name .. (suffix or "")] = true
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

		if type(XShortcutsTarget.UpdateToolbar) ~= "function" then
			return
		end

		-- remove unwanted actions
		for i = #XShortcutsTarget.actions, 1, -1 do
			local a = XShortcutsTarget.actions[i]
			if a.ChoGGi_ECM or remove_lookup[a.ActionId] then
				a:delete()
				table_remove(XShortcutsTarget.actions,i)
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
				table_remove(XShortcutsTarget.actions,idx)
			end

--~ 			-- f1
--~ 			idx = table.find(XShortcutsTarget.actions,"ActionId","ShowHints")
--~ 			if idx then
--~ 				XShortcutsTarget.actions[idx]:delete()
--~ 				table_remove(XShortcutsTarget.actions,idx)
--~ 			end

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
			local name = Trans(754117323318--[[Enable--]]) .. " " ..S[302535920000887--[[ECM--]]]
			XShortcutsTarget:AddAction(XAction:new{
				ActionName = name,
				ActionId = name,
				OnAction = function()
					ChoGGi.UserSettings.DisableECM = false
					ChoGGi.SettingFuncs.WriteSettings()
					print(name,S[302535920001070--[[Restart to take effect.--]]])
					MsgPopup(
						S[302535920001070--[[Restart to take effect.--]]],
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
	if not IsValid(c) or type(age) ~= "string" then
		return
	end

	local ages = ChoGGi.Tables.ColonistAges
	if age == Trans(3490--[[Random--]]) then
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
		c.age = c["base_MinAge_" .. age]
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
	if not IsValid(c) or type(gender) ~= "string" then
		return
	end

	local genders = ChoGGi.Tables.ColonistGenders

	if gender == Trans(3490--[[Random--]]) then
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
	if not IsValid(c) or type(spec) ~= "string" then
		return
	end

	-- children don't have spec models so they get black cubed
	if c.age_trait ~= "Child" then
		if spec == Trans(3490--[[Random--]]) then
			spec = ChoGGi.Tables.ColonistSpecializations[Random(1,6)]
		end
		c:SetSpecialization(spec)
		c:UpdateWorkplace()
		--randomly fails on colonists from rockets
		--c:TryToEmigrate()
	end
end

function ChoGGi.ComFuncs.ColonistUpdateTraits(c,bool,traits)
	if not IsValid(c) or type(traits) ~= "table" then
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
	if not IsValid(c) or type(race) ~= "string" then
		return
	end

	if race == Trans(3490--[[Random--]]) then
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
	local idle_idx = table_find(cc,"command","Idle")
	if idle_idx then
		return cc[idle_idx]
	end
	idle_idx = table_find(cc,"command","WaitCommand")
	if idle_idx then
		return cc[idle_idx]
	end

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

do -- SaveOldPalette/RestoreOldPalette/GetPalette/RandomColour/ObjectColourRandom/ObjectColourDefault/ChangeObjectColour
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
		if amount and type(amount) == "number" and amount > 1 then
			-- somewhere to store the colours
			local colour_list = {}
			-- populate list with amount we want
			for i = 1, amount do
				-- 16777216: https://en.wikipedia.org/wiki/Color_depth#True_color_(24-bit)
				-- kinda, we skip the alpha values
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
		-- if fired from action menu
		if IsKindOf(obj,"XAction") then
			obj = ChoGGi.ComFuncs.SelObject()
		else
			obj = obj or ChoGGi.ComFuncs.SelObject()
		end

		if not IsValid(obj) or obj and not obj:IsKindOf("ColorizableObject") then
			return
		end
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
		-- if fired from action menu
		if IsKindOf(obj,"XAction") then
			obj = ChoGGi.ComFuncs.SelObject()
		else
			obj = obj or ChoGGi.ComFuncs.SelObject()
		end

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
		if not obj or obj and not obj:IsKindOf("ColorizableObject") then
			MsgPopup(
				S[302535920000015--[[Can't colour %s.--]]]:format(RetName(obj)),
				Trans(3595--[[Color--]])
			)
			return
		end
		local pal = ChoGGi.ComFuncs.GetPalette(obj)

		local ItemList = {}
		local c = 0
		for i = 1, 4 do
			local text = "Color" .. i
			c = c + 1
			ItemList[c] = {
				text = text,
				value = pal[text],
				hint = S[302535920000017--[[Use the colour picker (dbl right-click for instant change).--]]],
			}
			text = "Roughness" .. i
			c = c + 1
			ItemList[c] = {
				text = text,
				value = pal[text],
				hint = S[302535920000018--[[Don't use the colour picker: Numbers range from -128 to 127.--]]],
			}
			text = "Metallic" .. i
			c = c + 1
			ItemList[c] = {
				text = text,
				value = pal[text],
				hint = S[302535920000018--[[Don't use the colour picker: Numbers range from -128 to 127.--]]],
			}
		end
		c = c + 1
		ItemList[c] = {
			text = "X_BaseColor",
			value = 6579300,
			obj = obj,
			hint = S[302535920000019--[["Single colour for object (this colour will interact with the other colours).
	If you want to change the colour of an object you can't with 1-4."--]]],
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
					return a.text < b.text
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
					Trans(3595--[[Color--]]),
					nil,
					nil,
					obj
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = Trans(174--[[Color Modifier--]]) .. ": " .. RetName(obj),
			hint = S[302535920000022--[["If number is 8421504 then you probably can't change that colour.

You can copy and paste numbers if you want."--]]],
			parent = dialog,
			custom_type = 2,
			check = {
				{
					title = S[302535920000023--[[All of type--]]],
					hint = S[302535920000024--[[Change all objects of the same type.--]]],
				},
				{
					title = S[302535920000025--[[Default Colour--]]],
					hint = S[302535920000026--[[if they're there; resets to default colours.--]]],
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
function ChoGGi.ComFuncs.EmptyMechDepot(obj)
	-- if fired from action menu
	if IsKindOf(obj,"XAction") then
		obj = ChoGGi.ComFuncs.SelObject()
	else
		obj = IsKindOf(obj,"MechanizedDepot") and obj or ChoGGi.ComFuncs.SelObject()
	end

	if not obj or not IsKindOf(obj,"MechanizedDepot") then
		return
	end

	local res = obj.resource
	local amount = obj["GetStored_" .. res](obj)
	-- not good to be larger then this when game is saved (height limit of map objects seems to be 65536)
	if amount > 20000000 then
		amount = amount
	end
	local stock = obj.stockpiles[obj:GetNextStockpileIndex()]
	local angle = obj:GetAngle()
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
		"template_name", "Storage" .. res2,
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
		obj:CheatEmpty()

		Sleep(250)
		ChoGGi.ComFuncs.DeleteObject(obj)
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
	-- if fired from action menu
	if IsKindOf(obj,"XAction") then
		obj = ChoGGi.ComFuncs.SelObject()
	else
		obj = obj or ChoGGi.ComFuncs.SelObject()
	end

	if not IsValid(obj) then
		MsgPopup(
			S[302535920000027--[[Nothing selected--]]],
			S[302535920000028--[[Find Resource--]]]
		)
		return
	end

	-- build list of resources
	local ItemList = {}
	local ResourceDescription = ResourceDescription
	local res = ChoGGi.Tables.Resources
	local TagLookupTable = const.TagLookupTable
	for i = 1, #res do
		local item = ResourceDescription[table_find(ResourceDescription, "name", res[i])]
		ItemList[i] = {
			text = Trans(item.display_name),
			value = item.name,
			icon = TagLookupTable["icon_" .. item.name],
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
			table.append(stockpiles,labels["MechanizedDepot" .. value])
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
			local GetStored = "GetStored_" .. value
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
					Trans(15--[[Resource--]])
				)
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = ItemList,
		title = S[302535920000031--[[Find Nearest Resource--]]] .. ": " .. RetName(obj),
		hint = S[302535920000032--[[Select a resource to find--]]],
		skip_sort = true,
		custom_type = 7,
	}
end

do -- DeleteObject
	local IsKindOf = IsKindOf
	local IsValid = IsValid
	local DoneObject = DoneObject
	local DeleteThread = DeleteThread
	local CreateRealTimeThread = CreateRealTimeThread
	local DestroyBuildingImmediate = DestroyBuildingImmediate
	local FlattenTerrainInBuildShape = FlattenTerrainInBuildShape
	local HasAnySurfaces = HasAnySurfaces
	local HasRestoreHeight = terrain.HasRestoreHeight

	local UpdateFlightGrid
	local holiles = {"MoholeMine","ShuttleHub","MetalsExtractor","JumperShuttleHub"}

	local function ExecFunc(obj,funcname,param)
		if type(obj[funcname]) == "function" then
			obj[funcname](obj,param)
		end
	end

	local function DeleteFunc(obj,skip_demo)
		-- actually delete the whole passage
		if obj:IsKindOf("Passage") then
			for i = #obj.elements_under_construction, 1, -1 do
				ChoGGi.ComFuncs.DeleteObject(obj.elements_under_construction[i])
			end
		end

		-- figured it's quicker using a local function now
		local waterspire = obj:IsKindOf("WaterReclamationSpire") and not IsValid(obj.parent_dome)
		local rctransport = obj:IsKindOf("RCTransport")
		local holy_stuff = obj:IsKindOfClasses(holiles)

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
			end
		end

		-- demo to the rescue
		obj.can_demolish = true
		obj.indestructible = false
		if not skip_demo and obj.DoDemolish then
			DestroyBuildingImmediate(obj)
		end

		ExecFunc(obj,"RestoreTerrain")
		ExecFunc(obj,"Destroy")

		-- still gotta fix the geo dome
		if obj.GetFlattenShape and HasAnySurfaces(obj, EntitySurfaces.Height, true) and not HasRestoreHeight() then
			FlattenTerrainInBuildShape(obj:GetFlattenShape(), obj)
		end

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

		-- can't have shuttles avoiding empty space
		UpdateFlightGrid()
	end

	local DeleteObject
	function ChoGGi.ComFuncs.DeleteObject(obj,editor_delete,skip_demo)
		-- if fired from action menu
		if IsKindOf(obj,"XAction") then
			obj = ChoGGi.ComFuncs.SelObject()
			editor_delete = nil
			skip_demo = nil
		end

		local ChoGGi = ChoGGi
		if not UpdateFlightGrid then
			UpdateFlightGrid = ChoGGi.ComFuncs.UpdateFlightGrid
		end

		if not editor_delete then
			-- multiple selection from editor mode
			local objs = editor:GetSel() or ""
			if #objs > 0 then
				SuspendPassEdits("ChoGGi.ComFuncs.DeleteObject")
				DeleteObject = DeleteObject or ChoGGi.ComFuncs.DeleteObject
				for i = 1, #objs do
					if objs[i].class ~= "MapSector" then
						DeleteObject(objs[i],true)
					end
				end
				ResumePassEdits("ChoGGi.ComFuncs.DeleteObject")
			elseif not obj then
				obj = ChoGGi.ComFuncs.SelObject()
			end
		end

		if not IsValid(obj) then
			return
		end

		-- deleting domes will freeze game if they have anything in them.
		if obj:IsKindOf("Dome") and #(obj.labels.Buildings or "") > 0 then
			MsgPopup(
				S[302535920001354--[[%s is a Dome with buildings (likely crash if deleted).--]]]:format(RetName(obj)),
				S[302535920000489--[[Delete Object(s)--]]]
			)
			return
		end

		if Flight_MarkedObjs[obj] then
			Flight_MarkedObjs[obj] = nil
		end

--~ 		-- hopefully i can remove all log spam one of these days
--~ 		local name = RetName(obj)
--~ 		if name then
--~ 			printC("DeleteObject",name,"DeleteObject")
--~ 		end

		CreateRealTimeThread(DeleteFunc,obj,skip_demo)
	end
end -- do

do -- BuildingConsumption
	local function AddConsumption(obj,name)
		local tempname = "ChoGGi_mod_" .. name
		-- if this is here we know it has what we need so no need to check for mod/consump
		if obj[tempname] then
			local mod = obj.modifications[name]
			if mod[1] then
				mod = mod[1]
			end
			if mod.IsKindOf then
				local orig = obj[tempname]
				if mod:IsKindOf("ObjectModifier") then
					mod:Change(orig.amount,orig.percent)
				else
					mod.amount = orig.amount
					mod.percent = orig.percent
				end
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
			local tempname = "ChoGGi_mod_" .. name
			if not obj[tempname] then
				obj[tempname] = {
					amount = mod.amount,
					percent = mod.percent
				}
			end
			if mod.IsKindOf and mod:IsKindOf("ObjectModifier") then
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
			info_grid.title = Trans(891--[[Air--]])
			AddGrid(UICity,"air",info)
		elseif value == "Power" then
			info = info_grid
			info_grid.title = Trans(79--[[Power--]])
			AddGrid(UICity,"electricity",info)
		elseif value == "Water" then
			info = info_grid
			info_grid.title = Trans(681--[[Water--]])
			AddGrid(UICity,"water",info)
		elseif value == "Research" then
			info = {
				title = Trans(311--[[Research--]]),
				listtype = "all",
				tables = {UICity.tech_status},
				values = {
					researched = true
				}
			}
		elseif value == "Colonists" then
			info = {
				title = Trans(547--[[Colonists--]]),
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
				title = Trans(5238--[[Rockets--]]),
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
	-- if fired from action menu
	if IsKindOf(obj,"XAction") then
		obj = ChoGGi.ComFuncs.SelObject()
		skip_msg = nil
	else
		obj = obj or ChoGGi.ComFuncs.SelObject()
	end

	if not IsValid(obj) then
		if not skip_msg then
			MsgPopup(
				S[302535920000027--[[Nothing selected--]]],
				S[302535920000968--[[Collisions--]]]
			)
		end
		return
	end
	local coll = const.efCollision + const.efApplyToGrids

	local which
	-- hopefully give it a bit more speed
	SuspendPassEdits("ChoGGi.ComFuncs.CollisionsObject_Toggle")
	-- re-enable col on obj and any attaches
	if obj.ChoGGi_CollisionsDisabled then
		-- coll on object
		obj:SetEnumFlags(coll)
		-- and any attaches
		if obj.ForEachAttach then
			obj:ForEachAttach(function(a)
				a:SetEnumFlags(coll)
			end)
		end
		obj.ChoGGi_CollisionsDisabled = nil
		which = Trans(460479110814--[[Enabled--]])
	else
		obj:ClearEnumFlags(coll)
		if obj.ForEachAttach then
			obj:ForEachAttach(function(a)
				a:ClearEnumFlags(coll)
			end)
		end
		obj.ChoGGi_CollisionsDisabled = true
		which = Trans(847439380056--[[Disabled--]])
	end
	ResumePassEdits("ChoGGi.ComFuncs.CollisionsObject_Toggle")

	if not skip_msg then
		MsgPopup(
			S[302535920000969--[[Collisions %s on %s--]]]:format(which,RetName(obj)),
			Trans(302535920000968--[[Collisions--]]),
			nil,
			nil,
			obj
		)
	end
end

function ChoGGi.ComFuncs.ToggleCollisions(cls)
	-- pretty much the only thing I use it for, but just in case
	cls = cls or "LifeSupportGridElement"
	local CollisionsObject_Toggle = ChoGGi.ComFuncs.CollisionsObject_Toggle
	-- hopefully give it a bit more speed
	SuspendPassEdits("ChoGGi.ComFuncs.ToggleCollisions")
	MapForEach("map",cls,function(o)
		CollisionsObject_Toggle(o,true)
	end)
	ResumePassEdits("ChoGGi.ComFuncs.ToggleCollisions")
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
				S[302535920001266--[[Borked Transport Pathing--]]],
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
		mem[cm] = key .. ": " .. value .. "\n"
	end

	local hw = {}
	local chw = 0
	local hardware_info = GetHardwareInfo(0)
	for key,value in pairs(hardware_info) do
		if key == "gpu" then
			chw = chw + 1
			hw[chw] = key .. ": " .. GetGpuDescription() .. "\n"
		else
			chw = chw + 1
			hw[chw] = key .. ": " .. value .. "\n"
		end
	end
	table.sort(hw)
	chw = chw + 1
	hw[chw] = "\n"

	return string.format([[%s:
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
		Trans(5568--[[Stats--]]),
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

do -- RemoveXTemplateSections
	local function RemoveTableItem(list,name,value)
		local idx = table_find(list, name, value)
		if idx then
			list[idx]:delete()
			table_remove(list,idx)
		end
	end
	ChoGGi.ComFuncs.RemoveTableItem = RemoveTableItem

	-- check for and remove old object (XTemplates are created on new game/new dlc ?)
	function ChoGGi.ComFuncs.RemoveXTemplateSections(list,name,value)
		RemoveTableItem(list,name,value or true)
	end
end -- do
do -- AddXTemplate
	local function AddXTemplateNew(xt,name,pos,list)
		if not xt or not name or not list then
			local f = ObjPropertyListToLuaCode
			print(S[302535920001383--[[AddXTemplate borked template name: %s template: %s list: %s--]]]:format(name and f(name),template and f(template),list and f(list)))
			return
		end
		local stored_name = "ChoGGi_Template_" .. name

		ChoGGi.ComFuncs.RemoveXTemplateSections(xt,stored_name)

		table.insert(xt,pos or #xt,PlaceObj("XTemplateTemplate", {
			stored_name, true,
			"__condition", list.__condition or function()
				return true
			end,
			"__context_of_kind", list.__context_of_kind or "",
			"__template", list.__template or "InfopanelActiveSection",
			"Title", list.Title or Trans(1000016--[[Title--]]),
			"Icon", list.Icon or "UI/Icons/gpmc_system_shine.tga",
			"RolloverTitle", list.RolloverTitle or Trans(126095410863--[[Info--]]),
			"RolloverText", list.RolloverText or Trans(126095410863--[[Info--]]),
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
end -- do

local function CheatsMenu_Toggle()
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
ChoGGi.ComFuncs.CheatsMenu_Toggle = CheatsMenu_Toggle

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
	local idx = table_find(terminal.desktop,"class","EditorInterface")
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
			CheatsMenu_Toggle()
			CheatsMenu_Toggle()
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
	local idx = table_find(list, key, value)
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
			"grade", "Very High",
		})
		local r = ChoGGi.Consts.ResourceScale
		obj.max_amount = ChoGGi.ComFuncs.Random(1000 * r,100000 * r)
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
	-- ?
	else
		igi:SetMode("construction",{
			template = bld_template.template_name,
			selected_dome = dlg and dlg.context.selected_dome
		})
	end
	CloseDialog("XBuildMenu")
end

function ChoGGi.ComFuncs.DeleteLargeRocks()
	local function CallBackFunc(answer)
		if answer then
			SuspendPassEdits("ChoGGi.ComFuncs.DeleteLargeRocks")
			MapDelete(true, {"Deposition","WasteRockObstructorSmall","WasteRockObstructor"})
			ResumePassEdits("ChoGGi.ComFuncs.DeleteLargeRocks")
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		Trans(6779--[[Warning--]]) .. "!\n" .. S[302535920001238--[[Removes rocks for that smooth map feel.--]]],
		CallBackFunc,
		Trans(6779--[[Warning--]]) .. ": " .. S[302535920000855--[[Last chance before deletion!--]]]
	)
end

function ChoGGi.ComFuncs.DeleteSmallRocks()
	local function CallBackFunc(answer)
		if answer then
			SuspendPassEdits("ChoGGi.ComFuncs.DeleteSmallRocks")
			MapDelete(true, "StoneSmall")
			ResumePassEdits("ChoGGi.ComFuncs.DeleteSmallRocks")
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		Trans(6779--[[Warning--]]) .. "!\n" .. S[302535920001238--[[Removes rocks for that smooth map feel.--]]],
		CallBackFunc,
		Trans(6779--[[Warning--]]) .. ": " ..S[302535920000855--[[Last chance before deletion!--]]]
	)
end

-- build and show a list of attachments for changing their colours
function ChoGGi.ComFuncs.CreateObjectListAndAttaches(obj)
	-- if fired from action menu
	if IsKindOf(obj,"XAction") then
		obj = ChoGGi.ComFuncs.SelObject()
	else
		obj = obj or ChoGGi.ComFuncs.SelObject()
	end

	if not obj or obj and not obj:IsKindOf("ColorizableObject") then
		MsgPopup(
			S[302535920001105--[[Select/mouse over an object (buildings, vehicles, signs, rocky outcrops).--]]],
			Trans(3595--[[Color--]])
		)
		return
	end

	local ItemList = {}
	local c = 0

	-- has no Attaches so just open as is
	if obj.CountAttaches and obj:CountAttaches() == 0 then
		ChoGGi.ComFuncs.ChangeObjectColour(obj)
		return
	else
		c = c + 1
		ItemList[c] = {
			text = " " .. obj.class,
			value = obj.class,
			obj = obj,
			hint = S[302535920001106--[[Change main object colours.--]]],
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
					hint = S[302535920001107--[[Change colours of an attached object.--]]] .. "\n"
						.. S[302535920000955--[[Handle--]]] .. ": " .. (a.handle or ""),
				}
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		items = ItemList,
		title = Trans(174--[[Color Modifier--]]) .. ": " .. RetName(obj),
		hint = S[302535920001108--[[Double click to open object/attachment to edit (select to flash object).--]]],
		custom_type = 1,
		custom_func = function(sel,dialog)
			ChoGGi.ComFuncs.ChangeObjectColour(sel[1].obj,sel[1].parentobj,dialog)
		end,
		select_flash = true,
	}
end

function ChoGGi.ComFuncs.OpenGedApp(name)
	return OpenGedApp(name, terminal.desktop)
end

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
	local idx = table_find(tab,id,id_name)
	if idx then
		tab[idx][item] = value
		return tab[idx]
	end
end

do -- GetAllAttaches
	local objlist = objlist
	local attach_dupes = {}
	local attaches_list,attaches_count
	local obj_cls
--~ 	local skip = {"GridTile","GridTileWater","BuildingSign","ExplorableObject","TerrainDeposit","DroneBase","Dome"}
	local skip = {"ExplorableObject","TerrainDeposit","DroneBase","Dome"}

	local function AddAttaches(obj)
		for _,a in pairs(obj) do
			if not attach_dupes[a] and IsValid(a) and a.class ~= obj_cls and not a:IsKindOfClasses(skip) then
				attach_dupes[a] = true
				attaches_count = attaches_count + 1
				attaches_list[attaches_count] = a
			end
		end
	end

	local mark
	local function ForEach(a,parent_cls)
		if not attach_dupes[a] and IsValid(a) and a.class ~= obj_cls and not a:IsKindOfClasses(skip) then
			attach_dupes[a] = true
			attaches_count = attaches_count + 1
			attaches_list[attaches_count] = a
			if mark then
				a.ChoGGi_Marked_Attach = parent_cls
			end
			-- add level limit?
			if a.ForEachAttach then
				a:ForEachAttach(ForEach,a.class)
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

	function ChoGGi.ComFuncs.GetAllAttaches(obj,mark_attaches)
		mark = mark_attaches

		table_clear(attach_dupes)
		if not IsValid(obj) then
			-- I always use #attach_list so "" is fine by me
			return ""
		end

		-- we use objlist instead of {} for delete all button in examine
		attaches_list = objlist:new()
		attaches_count = 0
		obj_cls = obj.class

		-- add regular attachments
		if obj.ForEachAttach then
			obj:ForEachAttach(ForEach,obj.class)
		end
--~ 		local attaches = obj:GetClassFlags(const.cfComponentAttach) ~= 0

		-- add any non-attached attaches (stuff that's kinda attached, like the concrete arm thing)
		AddAttaches(obj)
		-- and the anim_obj added in gagarin
		if IsValid(obj.anim_obj) then
			AddAttaches(obj.anim_obj)
		end

		-- remove original obj if it's in the list
		local idx = table_find(attaches_list,obj)
		if idx then
			table_remove(attaches_list,idx)
		end

		return attaches_list
	end
end -- do

do -- PadNumWithZeros
	local pads = objlist:new()
	-- 100,00000 = "00100"
	function ChoGGi.ComFuncs.PadNumWithZeros(num,pad)
		if pad then
			pad = pad .. ""
		else
			pad = "00000"
		end
		num = num .. ""

		-- build a table of string 0
		pads:Clear()
		local diff = #pad - #num
		for i = 1, diff do
			pads[i] = "0"
		end
		pads[diff+1] = num
--~ 		-- mash a bunch of "0" onto the start
--~ 		while #num < #pad do
--~ 			num = "0" .. num
--~ 		end

		return TableConcat(pads)
	end
end -- do

do -- UpdateFlightGrid
	local GetMapSize = terrain.GetMapSize
	local IsHeightChanged = terrain.IsHeightChanged
	local GetHeightGrid = terrain.GetHeightGrid
	local Flight_MarkPathSpline = Flight_MarkPathSpline

	local mark_flags = const.efWalkable + const.efApplyToGrids + const.efCollision
	local type_tile = terrain.TypeTileSize()
	local work_step = 16 * type_tile
	local mark_step = 16 * type_tile
	local map_size
	local function Flight_NewGrid(step, packing)
		map_size = map_size or GetMapSize()
		local work_size = map_size / (step or work_step)
		return grid(work_size, packing or 32)
	end
	local function TrajectMark(spline)
		return spline and Flight_MarkPathSpline(Flight_Traject, spline, mark_step)
	end
	local function UpdateAttached(obj)
		Flight_ObjsToMark[obj] = true
	end
	local function UpdateTraject(obj)
		if obj.idle_mark_pos then
			Flight_Traject:AddCircle(1, obj.idle_mark_pos, mark_step, obj.collision_radius)
		end
		TrajectMark(obj.current_spline)
		TrajectMark(obj.next_spline)
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
			MapForEach("map", "attached", false, nil, mark_flags,UpdateAttached)
		end
		Flight_ObjToUnmark = {}
		Flight_MarkedObjs = {}
		MarkThreadProc()

		Flight_Traject = Flight_NewGrid(mark_step, 16)

		MapForEach("map", "FlyingObject", UpdateTraject)

		local objs = FlyingObjs or ""
		for i = 1, #objs do
			objs[i]:RegisterFlight()
		end
	end
end -- do

function ChoGGi.ComFuncs.RemoveObjs(cls,reason)
	-- if we don't send a reason then it'll skip suspend, if the reason is already sus then skip as well
	local not_sus = reason and not s_SuspendPassEditsReasons[reason]
	if not_sus then
		-- suspending pass edits makes deleting much faster
		SuspendPassEdits(reason)
	end
	-- if it isn't a valid class then Map* will return all objects :(
	if g_Classes[cls] then
		MapDelete(true, cls)
	end
	if not_sus then
		ResumePassEdits(reason)
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
			for trait_id in pairs(old_c.traits) do
				if trait_id and trait_id ~= "" then
					colonist.traits[trait_id] = true
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
	local objects = UICity.labels[cls] or {}
	if #objects == 0 then
		-- if it isn't in g_Classes then MapGet will return everything
		if not g_Classes[cls] then
			return {}
		end
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
	if not table_find(class_obj,parent_name) then
		class_obj.__parents[#class_obj.__parents+1] = parent_name
	end
end

function ChoGGi.ComFuncs.RetSpotPos(obj,building,spot)
	local nearest = building:GetNearestSpot("idle", spot or "Origin", obj)
	return building:GetSpotPos(nearest)
end

function ChoGGi.ComFuncs.RetSpotNames(obj)
  if not obj:HasEntity() then
    return
  end
	local names = {}
  local id_start, id_end = obj:GetAllSpots(obj:GetState())
  for i = id_start, id_end do
		local spot_annotation = obj:GetSpotAnnotation(i)
		local text_str = obj:GetSpotName(i) or "MISSING SPOT NAME"
		if spot_annotation then
			text_str = text_str .. ";" .. spot_annotation
		end
		names[i] = text_str
  end
	return names
end

do -- ConstructableArea
	local ConstructableArea
	function ChoGGi.ComFuncs.ConstructableArea()
		if not ConstructableArea then
			local sizex, sizey = terrain.GetMapSize()
			local border = 1000 or const.ConstructBorder
			ConstructableArea = box(border, border, (sizex or 0) - border, (sizey or 0) - border)
		end
		return ConstructableArea
	end
end -- do

function ChoGGi.ComFuncs.RetTemplateOrClass(obj)
	return obj.template_name or obj.class
end
