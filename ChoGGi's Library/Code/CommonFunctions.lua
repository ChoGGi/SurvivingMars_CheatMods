-- See LICENSE for terms

local Strings = ChoGGi.Strings
local testing = ChoGGi.testing
-- Init.lua
local TableConcat = ChoGGi.ComFuncs.TableConcat
-- Strings.lua
local Translate = ChoGGi.ComFuncs.Translate

local pairs, tonumber, type, tostring = pairs, tonumber, type, tostring
local AsyncRand = AsyncRand
local AveragePoint2D = AveragePoint2D
local FindNearestObject = FindNearestObject -- (list,obj) or (list,pos,filterfunc)
local GetTerrainCursor = GetTerrainCursor
local GetTerrainGamepadCursor = GetTerrainGamepadCursor
local GetUIStyleGamepad = GetUIStyleGamepad
local SelectionGamepadObj = SelectionGamepadObj
local SelectionMouseObj = SelectionMouseObj
local IsValid = IsValid
local IsKindOf = IsKindOf
local IsPoint = IsPoint
local MapFilter = MapFilter
local MapGet = MapGet
local PropObjGetProperty = PropObjGetProperty
local table = table
local table_remove = table.remove
local table_find = table.find
local table_clear = table.clear
local table_iclear = table.iclear
local table_icopy = table.icopy
local table_sort = table.sort
local table_copy = table.copy
local table_rand = table.rand
local table_set_defaults = table.set_defaults
local table_append = table.append
local table_ifilter = table.ifilter
local CreateRealTimeThread = CreateRealTimeThread
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local ClassDescendantsList = ClassDescendantsList
local WorldToHex = WorldToHex
local OpenDialog = OpenDialog
local ViewAndSelectObject = ViewAndSelectObject
local XDestroyRolloverWindow = XDestroyRolloverWindow
local Max = Max
local GameTime = GameTime
local guic = guic
local ViewObjectMars = ViewObjectMars
local RGB = RGB
local terrain_IsPassable = terrain.IsPassable
local HexGridGetObject = HexGridGetObject
local HexToWorld = HexToWorld
local point = point
local point20 = point20
local WaitMsg = WaitMsg
local Sleep = Sleep
local CreateGameTimeThread = CreateGameTimeThread
local terrain_GetHeight = terrain.GetHeight

local InvalidPos = ChoGGi.Consts.InvalidPos

local rawget, getmetatable = rawget, getmetatable
function OnMsg.ChoGGi_UpdateBlacklistFuncs(env)
	-- make sure we use the actual funcs if we can
	rawget = env.rawget
	getmetatable = env.getmetatable
end

-- backup orginal function for later use (checks if we already have a backup, or else inf problems)
local function SaveOrigFunc(class_or_func, func_name)
	local OrigFuncs = ChoGGi.OrigFuncs
	-- If it's a class func
	if func_name then
		local newname = class_or_func .. "_" .. func_name
		if not OrigFuncs[newname] then
			local class_obj = rawget(_G, class_or_func)
			if class_obj then
				OrigFuncs[newname] = rawget(class_obj, func_name)
			end
		end
	-- regular func
	else
		if not OrigFuncs[class_or_func] then
			OrigFuncs[class_or_func] = rawget(_G, class_or_func)
		end
	end
end
ChoGGi.ComFuncs.SaveOrigFunc = SaveOrigFunc

do -- AddMsgToFunc
	local Msg = Msg
	-- changes a function to also post a Msg for use with OnMsg
	function ChoGGi.ComFuncs.AddMsgToFunc(class_name, func_name, msg_str, thread, ...)
		-- anything i want to pass onto the msg
		local varargs = ...
		-- save orig
		SaveOrigFunc(class_name, func_name)
		-- we want to local this after SaveOrigFunc just in case
		local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
		-- redefine it
		local newname = class_name .. "_" .. func_name
		_G[class_name][func_name] = function(obj, ...)
			-- send obj along with any extra args i added
			if thread then
				-- calling it from a thread creates a slight delay
				CreateRealTimeThread(Msg, msg_str, obj, varargs)
			else
				Msg(msg_str, obj, varargs)
			end

--~ 			-- use to debug if getting an error
--~ 			local params = {...}
--~ 			-- pass on args to orig func
--~ 			if not pcall(function()
--~ 				return ChoGGi_OrigFuncs[class_name .. "_" .. func_name](table.unpack(params))
--~ 			end) then
--~ 				print("Function Error: ", class_name .. "_" .. func_name)
--~ 				ChoGGi.ComFuncs.OpenInExamineDlg({params}, nil, "AddMsgToFunc")
--~ 			end

			return ChoGGi_OrigFuncs[newname](obj, ...)
		end
	end
end -- do

local function IsObjlist(o)
	if type(o) == "table" then
		return getmetatable(o) == objlist
	end
end
ChoGGi.ComFuncs.IsObjlist = IsObjlist

-- "table.table.table.etc" = returns etc as object
-- use .number for index based tables ("terminal.desktop.1.box")
-- root is where we start looking (defaults to _G).
-- create is a boolean to add a table if the "name" is absent.
local function DotPathToObject(str, root, create)
	local _G = _G

	-- parent always starts out as "root"
	local parent = root or _G

	-- https://www.lua.org/pil/14.1.html
	-- [] () + ? . act like regexp ones
	-- % escape special chars
	-- ^ complement of the match (the "opposite" of the match)
	local matches = str:gmatch("([^%.]+)(.?)")
	for name, match in matches do
		-- If str included .number we need to make it a number or [name] won't work
		local num = tonumber(name)
		if num then
			name = num
		end

		local obj_child
		-- workaround for "Attempt to use an undefined global" msg the devs added
		if parent == _G then
			obj_child = rawget(parent, name)
		else
			obj_child = parent[name]
		end

		-- . means we're not at the end yet
		if match == "." then
			-- create is for adding new settings in non-existent tables
			if not obj_child and not create then
				-- our treasure hunt is cut short, so return nadda
				return false
			end
			-- change the parent to the child (create table if absent, this'll only fire when create)
			parent = obj_child or {}
		else
			-- no more . so we return as conquering heroes with the obj
			return obj_child
		end

	end
end
ChoGGi.ComFuncs.DotPathToObject = DotPathToObject

do -- RetName
	local DebugGetInfo = ChoGGi.ComFuncs.DebugGetInfo
	local IsT = IsT
	local missing_text = ChoGGi.Temp.missing_text
	local TMeta = TMeta
	local TConcatMeta = TConcatMeta

	-- we use this table to display names of objects for RetName
	local g = _G
	if not rawget(g, "ChoGGi_lookup_names") then
		g.ChoGGi_lookup_names = {[g.empty_func] = "empty_func"}
	end
	local lookup_table = g.ChoGGi_lookup_names

	local function AddFuncToList(key, value, name)
		if not lookup_table[value] then
			if type(value) == "function" then
				if DebugGetInfo(value) == "[C](-1)" then
					lookup_table[value] = name .. "." .. key .. " *C"
				else
					lookup_table[value] = name .. "." .. key
				end
			end
		end
	end

	do -- add stuff we can add now
		lookup_table = ChoGGi_lookup_names or {}
		local function AddFuncsUserData(meta, name)
			for key, value in pairs(meta) do
				AddFuncToList(key, value, name)
			end
		end
		-- some userdata funcs
		local userdata_tables = {
			range = __range_meta,
			TaskRequest = Request_GetMeta(),
			quaternion = getmetatable(quaternion(point20, 0)),
			set = getmetatable(set()),
			RandState = getmetatable(RandState()),
			pstr = getmetatable(pstr()),
			grid = getmetatable(NewGrid(0, 0, 1)),
			xmgrid = getmetatable(grid(0, 0)),
			point = getmetatable(point20),
			box = getmetatable(empty_box),
		}
		for name, meta in pairs(userdata_tables) do
			AddFuncsUserData(meta, name)
		end
	end -- do

	local function AddFuncs(name)
		local list
		if name:find("%.") then
			list = DotPathToObject(name)
		else
			list = g[name]
		end
		if not list then
			return
		end

		for key, value in pairs(list) do
			AddFuncToList(key, value, name)
		end
	end
	local func_tables = {
		"g_CObjectFuncs", "camera", "camera3p", "cameraMax", "cameraRTS", "objlist",
		"coroutine", "DTM", "lpeg", "pf", "srp", "string", "table", "UIL", "editor",
		"terrain", "terminal", "TFormat", "XInput",
	}
	for i = 1, #func_tables do
		AddFuncs(func_tables[i])
	end

	local values_lookup = {
		"title",
		"encyclopedia_id",
		"id",
		"Id",
		"ActionName",
		"ActionId",
		"template_name",
		"template_class",
		"__class",
		"__template",
		"template",
		"__mtl",
		"text",
		"value",
		"name",
		-- most stuff has a class
		"class",
	}

	do -- stuff we need to be in-game for
		local function AddFuncsChoGGi(name, skip)
			local list = g.ChoGGi[name]
			for key, value in pairs(list) do
				if not lookup_table[value] then
					if skip then
						lookup_table[value] = key
					else
						lookup_table[value] = "ChoGGi." .. name .. "." .. key
					end
				end
			end
		end

		local function BuildNameList(update_trans)
			lookup_table = ChoGGi_lookup_names or {}
			-- If env._G was updated from ECM HelperMod
			g = _G
			lookup_table[g.terminal.desktop] = "terminal.desktop"

			AddFuncs("lfs")
			AddFuncs("debug")
			AddFuncs("io")
			AddFuncs("os")
			AddFuncs("package")
			AddFuncs("package.searchers")
			if not ChoGGi.blacklist then
				local registry = g.debug.getregistry()
				local name = "debug.getregistry()"
				for key, value in pairs(registry) do
					local t = type(value)
					if t == "function" then
						AddFuncToList(key, value, name)
					elseif t == "table" then
						-- we get _G later
						if value ~= g then
							for key2, value2 in pairs(value) do
								AddFuncToList(key, value2, "dbg_reg()."..key2)
							end
						end
					end
				end
			end

			-- ECM func names (some are added by ecm, so we want to update list when it's called again)
			AddFuncsChoGGi("ComFuncs")
			AddFuncsChoGGi("ConsoleFuncs")
			AddFuncsChoGGi("InfoFuncs")
			AddFuncsChoGGi("MenuFuncs")
			AddFuncsChoGGi("SettingFuncs")
			AddFuncsChoGGi("OrigFuncs", true)

			for key, value in pairs(g.ChoGGi) do
				if not lookup_table[value] then
					if type(value) == "table" then
						lookup_table[value] = "ChoGGi." .. key
					end
				end
			end

			-- any tables/funcs in _G
			for key, value in pairs(g) do
				-- no need to add tables already added
				if not lookup_table[value] then
					local t = type(value)
					if t == "table" or t == "userdata" then
						lookup_table[value] = key
					elseif t == "function" then
						if DebugGetInfo(value) == "[C](-1)" then
							lookup_table[value] = key .. " *C"
						else
							lookup_table[value] = key
						end
					end
				end
			end

			local blacklist = g.ChoGGi.blacklist

			-- and any g_Classes funcs
			for id, class in pairs(g.g_Classes) do
				if blacklist then
					local g_value = rawget(g, id)
					if g_value then
						lookup_table[g_value] = id
					end
				end
				for key, value in pairs(class) do
					-- why it has a false is beyond me (something to do with that object[true] = userdata?)
					if key ~= false and not lookup_table[value] then
						if type(value) == "function" then
							local name = DebugGetInfo(value)
							if name == "[C](-1)" then
								lookup_table[value] = key .. " *C"
							else
								-- Unit.lua(75):MoveSleep
								-- need to reverse string so it finds the last /, since find looks ltr
								local slash = name:reverse():find("/")
								if slash then
									lookup_table[value] = name:sub((slash * -1) + 1) .. ":" .. key
								else
									-- the name'll be [string ""](8):
									lookup_table[value] = "string():" .. key
								end
							end
						end
					end
				end
			end

			g.ClassDescendantsList("Preset", function(_, cls)
				if cls.GlobalMap and cls.GlobalMap ~= "" then
					local g_value = rawget(g, cls.GlobalMap)
					if g_value then
						-- only needed for blacklist, but whatever it's quick
						lookup_table[g_value] = cls.GlobalMap

						for k, v in pairs(g_value) do
							if update_trans or not lookup_table[v] then
								if v.name and v.name ~= "" then
									lookup_table[v] = Translate(v.name)
								elseif v.display_name and v.display_name ~= "" then
									lookup_table[v] = Translate(v.display_name)
								else
									lookup_table[v] = k
								end
							end
						end
					end

				end
			end)

			-- grab what we can from gimped _G
			if blacklist then
				lookup_table[g.g_Classes] = "g_Classes"
				for i = 1, #g.GlobalVars do
					local var = g.GlobalVars[i]
					local obj = g[var]
					if not lookup_table[obj] then
						lookup_table[obj] = var
					end
				end
			end

		end

		-- so they work in the main menu
		BuildNameList()

		-- called from onmsgs for citystart/loadgame
		ChoGGi.ComFuncs.RetName_Update = BuildNameList
	end -- do

	-- try to return a decent name for the obj, failing that return a string
	function ChoGGi.ComFuncs.RetName(obj)
		-- booleans and nil are easy enough
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
			-- we check in order of less generic "names"
			local name_type = PropObjGetProperty(obj, "name") and type(obj.name)

			-- custom name from user (probably)
			if name_type == "string" and obj.name ~= "" then
				name = obj.name
			-- colonist names
			elseif name_type == "table" then
				name = Translate(obj.name)

			-- display
			elseif PropObjGetProperty(obj, "display_name") and obj.display_name ~= "" then
				if IsT(obj.display_name) == 9 --[[Anomaly]] then
					name = obj.class
				else
					name = Translate(obj.display_name)
				end
			-- entity
			elseif PropObjGetProperty(obj, "entity") and obj.entity ~= "" then
				name = obj.entity

			-- objlist
			elseif IsObjlist(obj) then
				return obj[1] and ChoGGi.ComFuncs.RetName(obj[1]) or "objlist"

			else
				-- we need to use PropObjGetProperty to check (seems more consistent then rawget), as some stuff like mod.env uses the metatable from _G.__index and causes sm to log an error msg
				local index = getmetatable(obj)
				index = index and index.__index

				for i = 1, #values_lookup do
					local value_name = values_lookup[i]
					if index and PropObjGetProperty(obj, value_name) or not index and obj[value_name] then
						local value = obj[value_name]
						if value ~= "" then
							name = value
							break
						end
					end
				end
				--
				local meta = getmetatable(name)
				if meta == TMeta or meta == TConcatMeta then
					name = Translate(name)
				elseif type(name) == "userdata" then
					name = Translate(name)
				end
				if not name and PropObjGetProperty(obj, "GetDisplayName") then
					name = Translate(obj:GetDisplayName())
				end

			end -- If

		elseif obj_type == "userdata" then
			if IsT(obj) then
				local trans_str = Translate(obj)
				-- missing text is from internaltranslate, i check the str length before calling the func as it has to be at least 16 chars
				if trans_str == missing_text then
					return tostring(obj)
				end
				return trans_str
			else
				return tostring(obj)
			end

		elseif obj_type == "function" then
			return DebugGetInfo(obj)

		end

		-- just in case...
		return type(name) == "string" and name or tostring(name or obj)
	end
end -- do
local RetName = ChoGGi.ComFuncs.RetName

local function IsValidXWin(win)
	win = win and win.window_state
	if win and win ~= "destroying" then
		return true
	end
end
ChoGGi.ComFuncs.IsValidXWin = IsValidXWin

function ChoGGi.ComFuncs.RetIcon(obj)
	-- most icons
	if obj.display_icon and obj.display_icon ~= "" then
		return obj.display_icon

	elseif obj.pin_icon and obj.pin_icon ~= "" then
		-- colonist
		return obj.pin_icon

	else
		-- generic icon (and scale as it isn't same size as the usual icons)
		return "UI/Icons/console_encyclopedia.tga", 150
	end
end

function ChoGGi.ComFuncs.RetHint(obj)
	if type(obj.description) == "userdata" then
		return obj.description

	elseif obj.GetDescription then
		return obj:GetDescription()

	else
		-- eh
		return Translate(3718--[[NONE]])
	end
end

local function GetParentOfKind(win, cls)
	while win and not win:IsKindOf(cls) do
		win = win.parent
	end
	return win
end
ChoGGi.ComFuncs.GetParentOfKind = GetParentOfKind

do -- ValidateImage
	local Measure = UIL.MeasureImage

	function ChoGGi.ComFuncs.ValidateImage(image)
		if not image then
			return
		end

		local x, y = Measure(image)
		if x > 0 and y > 0 then
			return image
		end
	end
end
local ValidateImage = ChoGGi.ComFuncs.ValidateImage

do -- MsgPopup
	local temp_params = {}

	-- shows a popup msg with the rest of the notifications
	-- params:
	-- params.objects can be a single obj, or {obj1, obj2, ...}
	-- expiration in ms or -1
	-- size = true = long width
	-- cycle_objs indexed table of in-game objs
	-- callback func to call when left clicked (fires with args: c_obj,cycle_obj,dlg)

	function ChoGGi.ComFuncs.MsgPopup(text, title, params)
		-- notifications only show up in-game (UI stuff is missing)
		if not UICity then
			return
		end

		local ChoGGi = ChoGGi
		if not ChoGGi.Temp.MsgPopups then
			ChoGGi.Temp.MsgPopups = {}
		end

		if not params then
			table_clear(temp_params)
			params = temp_params
		end

		-- how many ms it stays open for
		if not params.expiration then
--~ 			params.expiration = -1,
--~ 			params.dismissable = false,
			params.expiration = 10
			if params.size then
				params.expiration = 25
			end
		end
		-- change to ticks (seconds)
		if params.expiration > -1 then
			params.expiration = params.expiration * 1000
		end

		-- close on left click
--~ 		params.close_on_read = true

		-- If there's no interface then we probably shouldn't open the popup
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
			title = type(title) == "number" and tostring(title) or title or "",
			text = type(text) == "number" and tostring(text) or text or T(3718, "NONE"),
			image = params.image and ValidateImage(params.image) or ChoGGi.library_path .. "UI/TheIncal.png",
		}

		table_set_defaults(data, params)
		table_set_defaults(data, OnScreenNotificationPreset)

		-- click icon to view obj
		if params.objects then
			-- If it's a single obj
			if IsValid(params.objects) then
				params.cycle_objs = {params.objects}
			else
				params.cycle_objs = params.objects
			end
		end

		-- needed in Sagan update
		local aosn = g_ActiveOnScreenNotifications
		local idx = table_find(aosn, 1, data.id) or #aosn + 1
		aosn[idx] = {data.id}

		-- and show the popup
		CreateRealTimeThread(function()
			local popup = OnScreenNotification:new({}, dlg.idNotifications)
			popup:FillData(data, params.callback, params, params.cycle_objs)
			popup:Open()
			dlg:ResolveRelativeFocusOrder()
			ChoGGi.Temp.MsgPopups[#ChoGGi.Temp.MsgPopups+1] = popup

			-- large amount of text option
			if params.size then
				local frame = GetParentOfKind(popup.idText, "XFrame")
				if frame then
					frame:SetMaxWidth(params.max_width or 1000)
				end
				-- popup.idText:SetMaxHeight(params.max_height or 250)
			end

		end)
		-- If we need the popup notification_id
		return data.id
	end
end -- do
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

do -- ShowObj
	local OVector, OSphere

	-- we just use a few noticeable colours for rand
	local rand_colours = {
		green, yellow, cyan, white,
		-46777, -- lighter red than "red"
		-65369, -- pink
		-39680, -- slightly darker orange (don't want it blending in to the ground as much as -23296)
	}
	local function rand_c()
		return table_rand(rand_colours)
	end
	ChoGGi.ComFuncs.RandomColourLimited = rand_c

	local markers = {}
	function ChoGGi.ComFuncs.RetObjMarkers()
		return markers
	end

	local function ClearMarker(k, v)
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
			for k, v in pairs(markers) do
				ClearMarker(k, v)
			end
			table_clear(markers)
			ResumePassEdits("ChoGGi.ComFuncs.ClearShowObj")
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
--~ 		MapDelete(true, {"ChoGGi_OVector", "ChoGGi_OSphere"})
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

	local function AddSphere(pt, colour)
		local pos = tostring(pt)
		if not IsValid(markers[pos]) then
			markers[pos] = nil
		end

		if markers[pos] then
			-- update with new colour
			markers[pos]:SetColor(colour)
		else
			local sphere = OSphere:new()
			sphere:SetPos(pt)
			sphere:SetRadius(50 * guic)
			sphere:SetColor(colour)
			markers[pos] = sphere
		end
		return markers[pos]
	end

	function ChoGGi.ComFuncs.ShowPoint(obj, colour)
		OSphere = OSphere or ChoGGi_OSphere
		colour = colour or rand_c()
		-- single pt
		if IsPoint(obj) and InvalidPos ~= obj then
			return AddSphere(obj, colour)
		end
		-- obj to pt
		if IsValid(obj) then
			local pt = obj:GetVisualPos()
			if IsValid(obj) and InvalidPos ~= pt then
				return AddSphere(pt, colour)
			end
		end

		-- two points
		if type(obj) ~= "table" then
			return
		end
		if IsPoint(obj[1]) and IsPoint(obj[2]) and InvalidPos ~= obj[1] and InvalidPos ~= obj[2] then
			OVector = OVector or ChoGGi_OVector
			local vector = OVector:new()
			vector:Set(obj[1], obj[2], colour or rand_c())
			markers[vector] = "vector"
			return vector
		end
	end

	-- marks pt of obj and optionally colours/moves camera
	local function ShowObj(obj, colour, skip_view, skip_colour)
		if markers[obj] then
			return markers[obj]
		end
		local is_valid = IsValid(obj)
		local is_point = IsPoint(obj)
		if not (is_valid or is_point) then
			return
		end
		OSphere = OSphere or ChoGGi_OSphere
		colour = colour or rand_c()
		local vis_pos = is_valid and obj:GetVisualPos()

		local pt = is_point and obj or vis_pos
		local sphere_obj
		if pt and pt ~= InvalidPos and not markers[pt] then
			sphere_obj = AddSphere(pt, colour)
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
	ChoGGi.ComFuncs.ShowObj = ShowObj
	-- I could add it to ShowObj, but too much fiddling
	function ChoGGi.ComFuncs.ShowQR(q, r, ...)
		if not (q or r) then
			return
		end
		return ShowObj(point(HexToWorld(q, r)), ...)
	end

end -- do
local ShowPoint = ChoGGi.ComFuncs.ShowPoint
local ShowObj = ChoGGi.ComFuncs.ShowObj
local ColourObj = ChoGGi.ComFuncs.ColourObj
local ClearShowObj = ChoGGi.ComFuncs.ClearShowObj
local RandomColourLimited = ChoGGi.ComFuncs.RandomColourLimited

function ChoGGi.ComFuncs.PopupSubMenu(menu, name, item)
	local popup = menu.popup

	-- build the new one/open it
	local submenu = g_Classes.ChoGGi_XPopupList:new({
		Opened = true,
		Id = "ChoGGi_submenu_popup",
		popup_parent = popup,
		AnchorType = "smart",
		Anchor = menu.box,
	}, terminal.desktop)
	-- Item == opened from PopupBuildMenu
	if item then
		ChoGGi.ComFuncs.PopupBuildMenu(item.submenu, submenu)
	else
		ChoGGi.ComFuncs.PopupBuildMenu(submenu, popup)
	end
	submenu:Open()
	-- add it to the popup
	popup[name] = submenu
end

function ChoGGi.ComFuncs.PopupBuildMenu(items, popup)
	local g_Classes = g_Classes
	local ViewObjectMars = ViewObjectMars
	local IsPoint = IsPoint

	local dark_menu = items.TextStyle == "ChoGGi_CheckButtonMenuOpp"
	for i = 1, #items do
		local item = items[i]

		if item.is_spacer then
			item.name = "~~~"
			item.disable = true
			item.centred = true
		end

		-- "ChoGGi_XCheckButtonMenu"
		local cls = g_Classes[item.class or "ChoGGi_XButtonMenu"]
		local button = cls:new({
			RolloverTitle = item.hint_title and item.hint_title or item.obj and RetName(item.obj) or Translate(126095410863--[[Info]]),
			RolloverText = item.hint or "",
			RolloverHint = item.hint_bottom or Translate(608042494285--[[<left_click> Activate]]),
			Text = item.name,
			Background = items.Background,
			PressedBackground = items.PressedBackground,
			FocusedBackground = items.FocusedBackground,
			TextStyle = item.disable and
				(dark_menu and "ChoGGi_ButtonMenuDisabled" or "ChoGGi_ButtonMenuDisabledDarker")
				or items.TextStyle or cls.TextStyle,
			HAlign = item.centred and "center" or "stretch",

			popup = popup,
		}, popup.idContainer)

		if items.IconPadding then
			button.idIcon:SetPadding(items.IconPadding)
		end

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
				button.idIcon:SetImageScale(IsPoint(item.image_scale) and item.image_scale or point(item.image_scale, item.image_scale))
			end
		end

		if item.clicked then
			function button.OnPress(...)
				cls.OnPress(...)
				item.clicked(item, ...)
				popup:Close()
			end
		-- "disable" stops the menu from closing when clicked
		elseif not item.disable then
			function button.OnPress(...)
				cls.OnPress(...)
				popup:Close()
			end
		end

		if item.mouseup then
			function button:OnMouseButtonUp(pt, button, ...)
				cls.OnMouseButtonUp(self, pt, button, ...)
				-- make sure cursor was in button area when mouse released
				if pt:InBox2D(self.box) then
					item.mouseup(item, self, pt, button, ...)
					popup:Close()
				end
			end
		end

		-- checkboxes (with a value (naturally))
		if item.value then

			local is_vis
			local value = DotPathToObject(item.value)

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
			g_Classes.ChoGGi_XLabel:new({
				Dock = "right",
				text = "...",
				TextStyle = items.TextStyle or cls.TextStyle,
			}, button)

			local name = "ChoGGi_submenu_" .. item.name
			submenu_func = function(self)
				ChoGGi.ComFuncs.PopupSubMenu(self, name, item)
			end
		end

		-- add our mouseenter funcs
		if item.mouseover or showobj_func or colourobj_func or pos_func or submenu_func then
			function button:OnMouseEnter(pt, child, ...)
				cls.OnMouseEnter(self, pt, child, ...)
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
					item.mouseover(self, pt, child, item, ...)
				end
				if submenu_func then
					submenu_func(self, pt, child, item, ...)
				end
			end

		end
	end
end

function ChoGGi.ComFuncs.PopupToggle(parent, popup_id, items, anchor, reopen, submenu)
	local popup = terminal.desktop[popup_id]
	if popup then
		popup:Close()
		submenu = submenu or terminal.desktop.ChoGGi_submenu_popup
		if submenu then
			submenu:Close()
		end
	end

	if not parent then
		return
	end

	if not popup or reopen then
		local cls = ChoGGi_XPopupList

		items.Background = items.Background or cls.Background
		items.FocusedBackground = items.FocusedBackground or cls.FocusedBackground
		items.PressedBackground = items.PressedBackground or cls.PressedBackground

		popup = cls:new({
			Opened = true,
			Id = popup_id,
			AnchorType = anchor or "smart",
			-- "none", "drop", "drop-right", "smart", "left", "right", "top", "bottom", "center-top", "center-bottom", "mouse"
			Anchor = parent.box,
			Background = items.Background,
			FocusedBackground = items.FocusedBackground,
			PressedBackground = items.PressedBackground,
		}, terminal.desktop)

		popup.items = items

		ChoGGi.ComFuncs.PopupBuildMenu(items, popup)

		-- when i send parent as a table with self and box coords
		parent = parent.ChoGGi_self or parent

		-- hide popup when parent closes
		CreateRealTimeThread(function()
			while IsValidXWin(popup) and IsValidXWin(parent) do
				Sleep(500)
			end
			popup:Close()
		end)

		popup:Open()

	end

	-- If we need to fiddle with it
	return popup
end

local function GetCursorOrGamePad()
	return GetUIStyleGamepad() and GetTerrainGamepadCursor() or GetTerrainCursor()
end
ChoGGi.ComFuncs.GetCursorOrGamePad = GetCursorOrGamePad
local function GetCursorOrGamePadSelectObj()
	return GetUIStyleGamepad() and SelectionGamepadObj() or SelectionMouseObj()
end
ChoGGi.ComFuncs.GetCursorOrGamePadSelectObj = GetCursorOrGamePadSelectObj

do -- Circle
	local OCircle

	-- show a circle for time and delete it
	function ChoGGi.ComFuncs.Circle(pos, radius, colour, time)
		if not OCircle then
			OCircle = ChoGGi_OCircle
		end

		local circle = OCircle:new()
		circle:SetPos(pos and pos:SetTerrainZ(10 * guic) or GetCursorOrGamePad())
		circle:SetRadius(radius or 1000)
		circle:SetColor(colour or RandomColourLimited())

		CreateRealTimeThread(function()
			Sleep(time or 50000)
			if IsValid(circle) then
				circle:delete()
			end
		end)
	end

	-- show a circle for time and delete it
	function ChoGGi.ComFuncs.Sphere(pos, colour, time)
		local orb = ShowPoint(pos and pos:SetTerrainZ(10 * guic) or GetCursorOrGamePad(), colour)

		CreateRealTimeThread(function()
			Sleep(time or 50000)
			if IsValid(orb) then
				orb:delete()
			end
		end)
	end
end -- do
local Sphere = ChoGGi.ComFuncs.Sphere

-- this is a question box without a question (WaitPopupNotification only works in-game, not main menu)
function ChoGGi.ComFuncs.MsgWait(text, title, image, ok_text, context, parent, template, thread)
	-- thread needed for WaitMarsQuestion
	if not CurrentThread() and thread ~= "skip" then
		return CreateRealTimeThread(ChoGGi.ComFuncs.MsgWait, text, title, image, ok_text, context, parent, template, "skip")
	end

--~ 	local dlg = CreateMarsQuestionBox(
	CreateMessageBox(
		type(title) == "number" and tostring(title) or title or T(1000016, "Title"),
		type(text) == "number" and tostring(text) or text or T(3718, "NONE"),
		type(ok_text) == "number" and tostring(ok_text) or ok_text,
		nil,
		parent,
		image and ValidateImage(image) or ChoGGi.library_path .. "UI/message_picture_01.png",
		context, template
	)

--~ 	-- hide cancel button since we don't care about it, and we ignore them anyways...
--~ 	dlg.idList[2]:delete()
end


-- well that's the question isn't it?
function ChoGGi.ComFuncs.QuestionBox(text, func, title, ok_text, cancel_text, image, context, parent, template, thread)
	-- thread needed for WaitMarsQuestion
	if not CurrentThread() and thread ~= "skip" then
		return CreateRealTimeThread(ChoGGi.ComFuncs.QuestionBox, text, func, title, ok_text, cancel_text, image, context, parent, template, "skip")
	end

	if not image then
		image = ChoGGi.library_path .. "UI/message_picture_01.png"
	end

	if WaitMarsQuestion(
		parent,
		type(title) == "number" and tostring(title) or title or T(1000016, "Title"),
		type(text) == "number" and tostring(text) or text or T(3718, "NONE"),
		type(ok_text) == "number" and tostring(ok_text) or ok_text,
		type(cancel_text) == "number" and tostring(cancel_text) or cancel_text,
		image and ValidateImage(image) or ChoGGi.library_path .. "UI/message_picture_01.png",
		context, template
	) == "ok" then
		if func then
			func(true, context)
		end
		return "ok"
	else
		-- user canceled / closed it
		if func then
			func(false, context)
		end
		return "cancel"
	end

end

-- positive or 1 return TrueVar || negative or 0 return FalseVar
-- ChoGGi.Consts.X = ChoGGi.ComFuncs.NumRetBool(ChoGGi.Consts.X, 0, ChoGGi.Consts.X)
function ChoGGi.ComFuncs.NumRetBool(num, true_var, false_var)
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
function ChoGGi.ComFuncs.ValueRetOpp(setting, value1, value2)
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
function ChoGGi.ComFuncs.CompareAmounts(a, b)
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
table.sort(s.command_centers, function(a, b)
	return ChoGGi.ComFuncs.CompareTableFuncs(a, b, "GetDist2D", s)
end)
]]
function ChoGGi.ComFuncs.CompareTableFuncs(a, b, func, obj)
	if not a and not b then
		return
	end
	if obj then
		return obj[func](obj, a) < obj[func](obj, b)
	else
		return a[func](a, b) < b[func](b, a)
	end
end

-- check for and remove broken objects from UICity.labels
function ChoGGi.ComFuncs.RemoveMissingLabelObjects(label)
	local UICity = UICity
	local list = UICity.labels[label] or ""
	for i = #list, 1, -1 do
		if not IsValid(list[i]) then
			table_remove(UICity.labels[label], i)
		end
	end
end

function ChoGGi.ComFuncs.RemoveMissingTableObjects(list, obj)
	if obj then
		for i = #list, 1, -1 do
			if #list[i][list] == 0 then
				table_remove(list, i)
			end
		end
	else
		for i = #list, 1, -1 do
			if not IsValid(list[i]) then
				table_remove(list, i)
			end
		end
	end
	return list
end

function ChoGGi.ComFuncs.RemoveFromLabel(label, obj)
	local UICity = UICity
	local list = UICity.labels[label] or ""
	for i = 1, #list do
		if list[i] and list[i].handle and list[i] == obj.handle then
			table_remove(UICity.labels[label], i)
		end
	end
end

-- tries to convert "65" to 65, "boolean" to boolean, "nil" to nil, or just returns "str" as "str"
local function RetProperType(value)
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
ChoGGi.ComFuncs.RetProperType = RetProperType

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

-- takes "example1 example2" and returns {[1] = "example1", [2] = "example2"}
function ChoGGi.ComFuncs.StringToTable(str)
	local temp = {}
	for i in str:gmatch("%S+") do
		temp[i] = i
	end
	return temp
end

-- value is ChoGGi.UserSettings.name
function ChoGGi.ComFuncs.SetConstsG(name, value)
	-- we only want to change it if user set value
	if value then
		-- some mods check Consts or g_Consts, so we'll just do both to be sure
		Consts[name] = value
		if g_Consts then
			g_Consts[name] = value
		end
	end
end

-- If value is the same as stored then make it false instead of default value, so it doesn't apply next time
function ChoGGi.ComFuncs.SetSavedConstSetting(setting, value)
	value = value or const[setting] or Consts[setting]
	local ChoGGi = ChoGGi
	-- If setting is the same as the default then remove it
	if ChoGGi.Consts[setting] == value then
		ChoGGi.UserSettings[setting] = nil
	else
		ChoGGi.UserSettings[setting] = value
	end
end

do -- TableCleanDupes
	local dupe_t = {}
	local temp_t = {}
	function ChoGGi.ComFuncs.TableCleanDupes(list)
		local c = 0

		-- quicker to make a new list on large tables
		if list[10000] then
			dupe_t = {}
			temp_t = {}
		else
			table_iclear(temp_t)
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

		-- Instead of returning a new table we clear the old and add the values
		table_iclear(list)
		for i = 1, #temp_t do
			list[i] = temp_t[i]
		end
	end
end -- do

-- ChoGGi.ComFuncs.RemoveFromTable(sometable, "class", "SelectionArrow")
function ChoGGi.ComFuncs.RemoveFromTable(list, cls, text)
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

-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Building, {ParSystem = true, ResourceStockpile = true}, nil, "class")
-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Unit, nil, nil, "working")
function ChoGGi.ComFuncs.FilterFromTable(list, exclude_list, include_list, name)
	if type(list) ~= "table" then
		return {}
	end
	return MapFilter(list, function(o)
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

-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Building, "IsKindOf", "Residence")
-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Unit, "IsValid", nil, true)
function ChoGGi.ComFuncs.FilterFromTableFunc(list, func, value, is_bool)
	if type(list) ~= "table" then
		return {}
	end
	return MapFilter(list, function(o)
		if is_bool then
			if _G[func](o) then
				return true
			end
		elseif o[func](o, value) then
			return true
		end
	end)
end

function ChoGGi.ComFuncs.OpenInMultiLineTextDlg(obj, parent)
	if not obj then
		return
	end

	if obj.text then
		return ChoGGi_DlgMultiLineText:new({}, terminal.desktop, obj)
	end

	if not IsKindOf(parent, "XWindow") then
		parent = nil
	end
	return ChoGGi_DlgMultiLineText:new({}, terminal.desktop, {
		text = obj,
		parent = parent,
	})
end

function ChoGGi.ComFuncs.OpenInListChoice(list)
	-- If list isn't a table or it has zero items or it doesn't have items/callback func
	local list_table = type(list) == "table"
	local items_table = type(list_table and list.items) == "table"
	if not list_table or list_table and not items_table or items_table and #list.items < 1 then
		print(
		Strings[302535920001324--[[ECM: OpenInListChoice(list) is blank... This shouldn't happen.]]], "\n", list, "\n",
			list and ValueToLuaCode(list)
		)
		return
	end
	if not IsKindOf(list.parent, "XWindow") then
		list.parent = nil
	end

	return ChoGGi_DlgListChoice:new({}, terminal.desktop, {
		list = list,
	})
end

-- return a string setting/text for menus
function ChoGGi.ComFuncs.SettingState(setting, text)
	if type(setting) == "string" and setting:find("%.") then
		-- some of the menu items passed are "table.table.exists?.setting"
		local obj = DotPathToObject(setting)
		if obj then
			setting = obj
		else
			setting = false
		end
	end

	-- we want it to return false instead of nil
	if type(setting) == "nil" then
		setting = false
	end

	if text then
		if setting then
			return "<color ChoGGi_green>" .. tostring(setting) .. "</color>: " .. text
		else
			return "<color ChoGGi_red>" .. tostring(setting) .. "</color>: " .. text
		end
	end

	return tostring(setting)
end

-- get all objects, then filter for ones within *radius*, returned sorted by dist, or *sort* for name
-- ChoGGi.ComFuncs.OpenInExamineDlg(ReturnAllNearby(1000, "class"))
function ChoGGi.ComFuncs.ReturnAllNearby(radius, sort, pt)
	radius = radius or 5000
	pt = pt or GetCursorOrGamePad()

	-- get all objects within radius
	local list = MapGet(pt, radius)

	-- sort list custom
	if sort then
		table_sort(list, function(a, b)
			return a[sort] < b[sort]
		end)
	else
		-- sort nearest
		table_sort(list, function(a, b)
			return a:GetVisualDist2D(pt) < b:GetVisualDist2D(pt)
		end)
	end

	return list
end

do -- RetObjectAtPos/RetObjectsAtPos
	local HexGridGetObject = HexGridGetObject
	local HexGridGetObjects = HexGridGetObjects

	-- q can be pt or q
	function ChoGGi.ComFuncs.RetObjectAtPos(q, r)
		if not r then
			q, r = WorldToHex(q)
		end
		return HexGridGetObject(ObjectGrid, q, r)
	end

	function ChoGGi.ComFuncs.RetObjectsAtPos(q, r)
		if not r then
			q, r = WorldToHex(q)
		end
		return HexGridGetObjects(ObjectGrid, q, r)
	end
end -- do

function ChoGGi.ComFuncs.RetSortTextAssTable(list, for_type)
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
		for _, v in pairs(list) do
			c = c + 1
			temp_table[c] = v
		end
	end

	-- and send back sorted
	table_sort(temp_table)
	return temp_table
end

do -- Ticks
	local times = {}
	local GetPreciseTicks = GetPreciseTicks
	local max_int = max_int

	local function TickStart(id)
		times[id] = GetPreciseTicks()
	end
	local function TickEnd(id, name)
		print(id, ":", GetPreciseTicks() - (times[id] or max_int), name)
		times[id] = nil
	end
	ChoGGi.ComFuncs.TickStart = TickStart
	ChoGGi.ComFuncs.TickEnd = TickEnd

	function ChoGGi.ComFuncs.PrintFuncTime(func, ...)
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
	for id, cargo in pairs(settings) do
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

	local function UpdateProfile(preset,list)
		for id, preset_p in pairs(preset) do
			if id ~= "None" and id ~= "random" then
				list[id] = {}
				local profile = list[id]
				for key, value in pairs(preset_p) do
					profile[key] = value
				end
			end
		end
	end

	-- make copies of spon/comm profiles
	function ChoGGi.ComFuncs.UpdateTablesSponComm()
		local Tables = ChoGGi.Tables
		local Presets = Presets

		table_clear(Tables.Sponsors)
		table_clear(Tables.Commanders)
		UpdateProfile(Presets.MissionSponsorPreset.Default,Tables.Sponsors)
		UpdateProfile(Presets.CommanderProfilePreset.Default,Tables.Commanders)
	end

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
		ClassDescendantsList("MysteryBase", function(class)
			local cls_obj = g_Classes[class]
			local scenario_name = cls_obj.scenario_name or Strings[302535920000009--[[Missing Scenario Name]]]
			local display_name = Translate(cls_obj.display_name) or Strings[302535920000010--[[Missing Name]]]
			local description = Translate(cls_obj.rollover_text) or Strings[302535920000011--[[Missing Description]]]

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
		local c1, c2, c3, c4, c5, c6 = 0, 0, 0, 0, 0, 0
		local TraitPresets = TraitPresets
		for id, t in pairs(TraitPresets) do
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
		for cargo_id, cargo in pairs(CargoPreset) do
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
	return
		-- m = min, n = max
		(n and (AsyncRand(n - m + 1) + m))
		-- OR if not n then m = max, min = 0
		or (m and AsyncRand(m))
		-- OR number between 0 and max_int
		or AsyncRand()
end
ChoGGi.ComFuncs.Random = Random

--~ function ChoGGi.ComFuncs.OpenKeyPresserDlg()
--~ 	ChoGGi_KeyPresserDlg:new({}, terminal.desktop, {})
--~ end

function ChoGGi.ComFuncs.CreateSetting(str, setting_type)
	local setting = DotPathToObject(str, nil, true)
	if type(setting) == setting_type then
		return true
	end
end

do -- SelObject/SelObjects
	local MapFindNearest = MapFindNearest
	local radius4h = const.HexSize / 4

	-- returns whatever is selected > moused over > nearest object to cursor
	-- single selection
	function ChoGGi.ComFuncs.SelObject(radius, pt)
		if not UICity then
			return
		end
		-- single selection
		local obj = SelectedObj or GetCursorOrGamePadSelectObj()

		if obj then
			-- If it's multi then return the first one
			if obj:IsKindOf("MultiSelectionWrapper") then
				return obj.objects[1]
			end
		else
			-- radius selection
			pt = pt or GetCursorOrGamePad()
			obj = MapFindNearest(pt, pt, radius or radius4h)
		end

		return obj
	end

	-- returns an indexed table of objects, add a radius to get objs close to cursor
	function ChoGGi.ComFuncs.SelObjects(radius, pt)
		if not UICity then
			return empty_table
		end
		local objs = SelectedObj or GetCursorOrGamePadSelectObj()

		if not radius and objs then
			if objs:IsKindOf("MultiSelectionWrapper") then
				return objs.objects
			else
				return {objs}
			end
		end

		pt = pt or GetCursorOrGamePad()
		return MapGet(pt, radius or radius4h, "attached", false)
	end
end
local SelObject = ChoGGi.ComFuncs.SelObject
local SelObjects = ChoGGi.ComFuncs.SelObjects

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
		-- I need to override so i can reset zoom and other settings.
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
	-- don't care about the actions/want to leave them in editor menu, but we don't want the keys
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
	-- auto-add all the TriggerDisaster ones
	local ass = XShortcutsTarget.actions
	for i = 1, #ass do
		local a = ass[i]
		if a.ActionId and a.ActionId:sub(1,15) == "TriggerDisaster" then
			remove_lookup[a.ActionId] = true
		end
	end
-- re-add dev stuff to check
--~ XTemplateSpawn("CommonShortcuts", XShortcutsTarget)
--~ XTemplateSpawn("EditorShortcuts", XShortcutsTarget)
--~ XTemplateSpawn("DeveloperShortcuts", XShortcutsTarget)
--~ XTemplateSpawn("SimShortcuts", XShortcutsTarget)
--~ XTemplateSpawn("GameShortcuts", XShortcutsTarget)

	local is_list_sorted
	function ChoGGi.ComFuncs.Rebuildshortcuts()
		local XShortcutsTarget = XShortcutsTarget

		if type(XShortcutsTarget.UpdateToolbar) ~= "function" then
			return
		end

		-- remove unwanted actions
		local ass = XShortcutsTarget.actions
		for i = #ass, 1, -1 do
			local a = ass[i]
			if a.ChoGGi_ECM or remove_lookup[a.ActionId] then
				a:delete()
				table_remove(XShortcutsTarget.actions, i)
--~ 			else
--~ 				-- hide any menuitems added from devs
--~ 				a.ActionMenubar = nil
--~ 				print(a.ActionId)
			elseif removekey_lookup[a.ActionId] then
				a.ActionShortcut = nil
				a.ActionShortcut2 = nil
			end
		end

		if testing then
			-- goddamn annoying key
			local idx = table_find(XShortcutsTarget.actions, "ActionId", "actionToggleFullscreen")
			if idx then
				XShortcutsTarget.actions[idx]:delete()
				table_remove(XShortcutsTarget.actions, idx)
			end
		end

		-- and add mine
		local XAction = XAction
		local Actions = ChoGGi.Temp.Actions

		-- make my entries sorted in the keybindings menu
		if not is_list_sorted then
			local CmpLower = CmpLower
			table.sort(Actions, function(a, b)
				return CmpLower(a.ActionId, b.ActionId)
			end)
			is_list_sorted = true
		end

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
			local name = Translate(754117323318--[[Enable]]) .. " " .. Strings[302535920000002--[[ECM]]]
			XShortcutsTarget:AddAction(XAction:new{
				ActionName = name,
				ActionId = name,
				OnAction = function()
					ChoGGi.UserSettings.DisableECM = false
					ChoGGi.SettingFuncs.WriteSettings()
					print(name, ":", Strings[302535920001070--[[Restart to take effect.]]])
					ChoGGi.ComFuncs.MsgWait(
						Strings[302535920001070--[[Restart to take effect.]]],
						name
					)
				end,
				ActionShortcut = "Ctrl-Shift-0",
				ActionBindable = true,
			})
			print(Strings[302535920001411--[["ECM has been disabled.
Use %s to enable it, or change DisableECM to false in %s.
See the bottom of Gameplay>Controls if you've changed the key binding."]]]
				:format("Ctrl-Shift-0", ConvertToOSPath("AppData/LocalStorage.lua"))
			)
		end

		-- add rightclick action to menuitems
		XShortcutsTarget:UpdateToolbar()
		-- got me
		XShortcutsThread = false

		if DisableECM == false then
			-- I forget why i'm toggling this...
			local dlgConsole = dlgConsole
			if dlgConsole then
				ShowConsole(not dlgConsole:GetVisible())
				ShowConsole(not dlgConsole:GetVisible())
			end
		end

	end
end -- do

do -- AttachToNearestDome
	local function CanWork(obj)
		return obj:CanWork()
	end

	-- If building requires a dome and that dome is borked then assign it to nearest dome
	function ChoGGi.ComFuncs.AttachToNearestDome(obj, force)
		if force ~= "force" and not obj:GetDefaultPropertyValue("dome_required") then
			return
		end

		-- find the nearest working dome
		local working_domes = MapFilter(UICity.labels.Dome, CanWork)
		local dome = FindNearestObject(working_domes, obj)

		-- remove from old dome (assuming it's a different dome), or the dome is invalid
		local current_dome_valid = IsValid(obj.parent_dome)
		if obj.parent_dome and not current_dome_valid
				or (current_dome_valid and dome and dome.handle ~= obj.parent_dome.handle) then
			local current_dome = obj.parent_dome
			-- remove from dome labels
			current_dome:RemoveFromLabel("InsideBuildings", obj)
			if obj:IsKindOf("Workplace") then
				current_dome:RemoveFromLabel("Workplace", obj)
			elseif obj:IsKindOf("Residence") then
				current_dome:RemoveFromLabel("Residence", obj)
			end

			if obj:IsKindOf("NetworkNode") then
				current_dome:SetLabelModifier("BaseResearchLab", "NetworkNode")
			end
			obj.parent_dome = false
		end

		-- no need to fire if there's no dome, or the above didn't remove it
		if dome and not IsValid(obj.parent_dome) then
			obj:SetDome(dome)

			-- add to dome labels
			dome:AddToLabel("InsideBuildings", obj)
			if obj:IsKindOf("Workplace") then
				dome:AddToLabel("Workplace", obj)
			elseif obj:IsKindOf("Residence") then
				dome:AddToLabel("Residence", obj)
			end

			-- spires
			if obj:IsKindOf("NetworkNode") then
				dome:SetLabelModifier("BaseResearchLab", "NetworkNode", obj.modifier)
			end
		end
	end

end -- do

-- toggle working status
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
		-- cameraRTS.GetProperties(1)

		-- size of activation area for border scrolling
		if ChoGGi.UserSettings.BorderScrollingArea then
			SetProperties(1, {ScrollBorder = ChoGGi.UserSettings.BorderScrollingArea})
		else
			-- default
			SetProperties(1, {ScrollBorder = ChoGGi.Consts.CameraScrollBorder})
		end

		if ChoGGi.UserSettings.CameraLookatDist then
			SetProperties(1, {LookatDist = ChoGGi.UserSettings.CameraLookatDist})
		else
			-- default
			SetProperties(1, {LookatDist = ChoGGi.Consts.CameraLookatDist})
		end

		-- zoom
		-- camera.GetFovY()
		-- camera.GetFovX()
		if ChoGGi.UserSettings.CameraZoomToggle then
			if type(ChoGGi.UserSettings.CameraZoomToggle) == "number" then
				SetZoomLimits(0, ChoGGi.UserSettings.CameraZoomToggle)
			else
				SetZoomLimits(0, 24000)
			end

			-- 5760x1080 doesn't get the correct zoom size till after zooming out
			if GetScreenSize():x() == 5760 then
				SetFovY(2580)
				SetFovX(7745)
			end
		else
			-- default
			SetZoomLimits(ChoGGi.Consts.CameraMinZoom, ChoGGi.Consts.CameraMaxZoom)
		end

		if ChoGGi.UserSettings.MapEdgeLimit then
			hr.CameraRTSBorderAtMinZoom = -1000
			hr.CameraRTSBorderAtMaxZoom = -1000
		else
			hr.CameraRTSBorderAtMinZoom = 1000
			hr.CameraRTSBorderAtMaxZoom = 1000
		end

		-- cameraRTS.SetProperties(1, {HeightInertia = 0})
	end
end -- do

function ChoGGi.ComFuncs.ColonistUpdateAge(c, age)
	if not IsValid(c) or type(age) ~= "string" then
		return
	end

	local ages = ChoGGi.Tables.ColonistAges
	if age == Translate(3490--[[Random]]) then
		age = ages[Random(1, 6)]
	end
	-- remove all age traits
	for i = 1, #ages do
		local ageT = ages[i]
		if c.traits[ageT] then
			c:RemoveTrait(ageT)
		end
	end
	-- add new age trait
	c:AddTrait(age, true)

	-- needed for comparison
	local orig_age = c.age_trait
	-- needed for updating entity
	c.age_trait = age

	if age == "Retiree" then
		c.age = 65 -- why isn't there a MinAge_Retiree...
	else
		c.age = c:GetClassValue("MinAge_" .. age)
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

function ChoGGi.ComFuncs.ColonistUpdateGender(c, gender)
	if not IsValid(c) or type(gender) ~= "string" then
		return
	end

	local genders = ChoGGi.Tables.ColonistGenders

	if gender == Translate(3490--[[Random]]) then
		gender = genders[Random(1, 3)]
	elseif gender == Strings[302535920000800--[[MaleOrFemale]]] then
		gender = genders[Random(1, 2)]
	end
	-- remove all gender traits
	for i = 1, #genders do
		c:RemoveTrait(genders[i])
	end
	-- add new gender trait
	c:AddTrait(gender, true)
	-- needed for updating entity
	c.gender = gender
	-- set entity gender
	if gender == "OtherGender" then
		c.entity_gender = Random(1, 100) <= 50 and "Male" or "Female"
		c.fx_actor_class = c.entity_gender == "Male" and "ColonistFemale" or "ColonistMale"
	else
		c.entity_gender = gender
	end
	-- now we can set the new entity
	c:ChooseEntity()
end

function ChoGGi.ComFuncs.ColonistUpdateSpecialization(c, spec)
	if not IsValid(c) or type(spec) ~= "string" then
		return
	end

	-- children don't have spec models so they get black cubed
	if c.age_trait ~= "Child" then
		if spec == Translate(3490--[[Random]]) then
			spec = ChoGGi.Tables.ColonistSpecializations[Random(1, 6)]
		end
		c:SetSpecialization(spec)
		c:UpdateWorkplace()
		--randomly fails on colonists from rockets
		--c:TryToEmigrate()
	end
end

function ChoGGi.ComFuncs.ColonistUpdateTraits(c, bool, traits)
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
		c[func](c, traits[i], true)
	end
end

function ChoGGi.ComFuncs.ColonistUpdateRace(c, race)
	local race_type = type(race)
	if (race_type ~= "number" and race_type ~= "string") or not IsValid(c) then
		return
	end

	if race == Translate(3490--[[Random]]) then
		race = Random(1, 5)
	end
	c.race = race
	c:ChooseEntity()
end


do -- FuckingDrones (took quite a while to figure this fun one out)
	-- force drones to pickup from pile even if they have a carry cap larger then the amount stored
	local ResourceScale = const.ResourceScale

	local building
	local function SortNearest(a, b)
		if IsValid(a) and IsValid(b) then
			return building:GetVisualDist2D(a) < building:GetVisualDist2D(b)
		end
	end

	local function GetNearestIdleDrone(bld)
		if not bld or (bld and not bld.command_centers) then
			if bld.parent.command_centers then
				bld = bld.parent
			end
		end
		if not bld or (bld and not bld.command_centers) then
			return
		end

		local cc = FindNearestObject(bld.command_centers, bld)
		-- check if nearest cc has idle drones
		if cc and cc:GetIdleDronesCount() > 0 then
			cc = cc.drones
		else
			-- sort command_centers by nearest, then loop through each of them till we find an idle drone
			building = bld
			table_sort(bld.command_centers, SortNearest)
			-- get command_center with idle drones
			for i = 1, #bld.command_centers do
				if bld.command_centers[i]:GetIdleDronesCount() > 0 then
					cc = bld.command_centers[i].drones
					break
				end
			end
		end

		-- It happens
		if not cc then
			return
		end

		-- get an idle drone
		local idle_idx = table_find(cc, "command", "Idle")
		if idle_idx then
			return cc[idle_idx]
		end
		idle_idx = table_find(cc, "command", "WaitCommand")
		if idle_idx then
			return cc[idle_idx]
		end
	end
	ChoGGi.ComFuncs.GetNearestIdleDrone = GetNearestIdleDrone

	function ChoGGi.ComFuncs.FuckingDrones(obj,single)
		if not IsValid(obj) then
			return
		end

		-- Come on, Bender. Grab a jack. I told these guys you were cool.
		-- Well, if jacking on will make strangers think I'm cool, I'll do it.

		local is_single = single == "single" or obj:IsKindOf("SingleResourceProducer")
		local stored = obj:GetStoredAmount()
--~ 		-- mines/farms/factories
--~ 		if is_single then
--~ 			stored = obj:GetAmountStored()
--~ 		else
--~ 			stored = obj:GetStoredAmount()
--~ 		end

		-- only fire if more then one resource
		if stored > 1000 then
			local parent
			local request
			local resource
			if is_single then
				parent = obj.parent
				request = obj.stockpiles[obj:GetNextStockpileIndex()].supply_request
				resource = obj.resource_produced
			else
				parent = obj
				request = obj.supply_request
				resource = obj.resource
			end

			local drone = GetNearestIdleDrone(parent)
			if not drone then
				return
			end

			local carry = g_Consts.DroneResourceCarryAmount * ResourceScale
			-- round to nearest 1000 (don't want uneven stacks)
			stored = (stored - stored % 1000) / 1000 * 1000
			-- If carry is smaller then stored then they may not pickup (depends on storage)
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

function ChoGGi.ComFuncs.SetMechanizedDepotTempAmount(obj, amount)
	amount = amount or 10
	local resource = obj.resource
	local io_stockpile = obj.stockpiles[obj:GetNextStockpileIndex()]
	local io_supply_req = io_stockpile.supply[resource]
	local io_demand_req = io_stockpile.demand[resource]

	io_stockpile.max_z = amount
	amount = (amount * 10) * const.ResourceScale
	io_supply_req:SetAmount(amount)
	io_demand_req:SetAmount(amount)
end

do -- GetAllAttaches
	local objlist = objlist
	local attach_dupes = {}
	local attaches_list, attaches_count
	local parent_obj
--~ 	local skip = {"GridTile", "GridTileWater", "BuildingSign", "ExplorableObject", "TerrainDeposit", "DroneBase", "Dome"}
	local skip = {"ExplorableObject", "TerrainDeposit", "DroneBase", "Dome"}

	local function AddAttaches(obj, only_include)
		for _, a in pairs(obj) do
			if not attach_dupes[a] and IsValid(a) and a ~= parent_obj
				and (not only_include or only_include and a:IsKindOf(only_include))
				and not a:IsKindOfClasses(skip)
			then
				attach_dupes[a] = true
				attaches_count = attaches_count + 1
				attaches_list[attaches_count] = a
			end
		end
	end

	local mark
	local function ForEach(a, parent_cls, only_include)
		if not attach_dupes[a] and a ~= parent_obj
			and (not only_include or only_include and a:IsKindOf(only_include))
			and not a:IsKindOfClasses(skip)
		then
			attach_dupes[a] = true
			attaches_count = attaches_count + 1
			attaches_list[attaches_count] = a
			if mark then
				a.ChoGGi_Marked_Attach = parent_cls
			end
			-- add level limit?
			if a.ForEachAttach then
				a:ForEachAttach(ForEach, a.class)
			end
		end
	end

	function ChoGGi.ComFuncs.GetAllAttaches(obj, mark_attaches, only_include, safe)
		mark = mark_attaches

		table_clear(attach_dupes)
		if not IsValid(obj) then
			-- I always use #attach_list so "" is fine by me
			return ""
		end

		-- we use objlist instead of {} for delete all button in examine
		attaches_list = objlist:new()
		attaches_count = 0
		parent_obj = obj

		-- add regular attachments
		if obj.ForEachAttach then
			obj:ForEachAttach(ForEach, obj.class, only_include)
		end

		if safe then
			local attaches = obj:GetAttaches() or ""
			for i = 1, #attaches do
				local a = attaches[i]
				ForEach(a, a.class, only_include)
			end

		else
			-- add any non-attached attaches (stuff that's kinda attached, like the concrete arm thing)
			AddAttaches(obj, only_include)
			-- and the anim_obj added in gagarin
			if IsValid(obj.anim_obj) then
				AddAttaches(obj.anim_obj, only_include)
			end
			-- pastures
			if obj.current_herd then
				AddAttaches(obj.current_herd, only_include)
			end
		end

		-- remove original obj if it's in the list
		local idx = table_find(attaches_list, obj)
		if idx then
			table_remove(attaches_list, idx)
		end

		return attaches_list
	end
end -- do
local GetAllAttaches = ChoGGi.ComFuncs.GetAllAttaches

local function MapGet_ChoGGi(label, area, ...)
	local objs = UICity.labels[label] or {}
	if #objs == 0 then
		local g_cls = g_Classes[label]
		-- If it isn't in g_Classes and isn't a CObject then MapGet will return *everything* (think gary oldman in professional)
		if g_cls and g_cls:IsKindOf("CObject") then
			-- area can be: "map" = only objs spawned on map, or true = objs on map and off map (objs spawned at invalid location)
			return MapGet(area or true, label, ...)
			-- use obj:SetPos(pos) to move objs to map (and away with pos = InvalidPos())
		end
	end
	return objs
end
ChoGGi.ComFuncs.MapGet = MapGet_ChoGGi
-- remove 16.0
ChoGGi.ComFuncs.RetAllOfClass = MapGet_ChoGGi
-- remove 16.0

do -- SaveOldPalette/RestoreOldPalette/GetPalette/RandomColour/ObjectColourRandom/ObjectColourDefault/ChangeObjectColour
	local color_ass = {}
	local colour_funcs = {}

	local function SaveOldPalette(obj)
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
	ChoGGi.ComFuncs.SaveOldPalette = SaveOldPalette
	colour_funcs.SetColours = function(obj, choice)
		SaveOldPalette(obj)
		for i = 1, 4 do
			obj:SetColorizationMaterial(i,
				choice[i].value,
				choice[i+8].value,
				choice[i+4].value
			)
		end
		obj:SetColorModifier(choice[13].value)
	end

	local function SetChoGGiPalette(obj, c)
		obj:SetColorModifier(c[-1])
		obj:SetColorizationMaterial(1, c[1][1], c[1][2], c[1][3])
		obj:SetColorizationMaterial(2, c[2][1], c[2][2], c[2][3])
		obj:SetColorizationMaterial(3, c[3][1], c[3][2], c[3][3])
		obj:SetColorizationMaterial(4, c[4][1], c[4][2], c[4][3])
	end
	ChoGGi.ComFuncs.SetChoGGiPalette = SetChoGGiPalette

	local function RestoreOldPalette(obj)
		if not IsValid(obj) then
			return
		end
		if obj.ChoGGi_origcolors then
			SetChoGGiPalette(obj, obj.ChoGGi_origcolors)
			obj.ChoGGi_origcolors = nil
		end
	end
	ChoGGi.ComFuncs.RestoreOldPalette = RestoreOldPalette
	colour_funcs.RestoreOldPalette = RestoreOldPalette

	local function GetPalette(obj)
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
	ChoGGi.ComFuncs.GetPalette = GetPalette

	local function RandomColour(amount)
		if amount and type(amount) == "number" and amount > 1 then
			-- temp associative table of colour ids
			table_clear(color_ass)
			-- Indexed list of colours we return
			local colour_list = {}
			-- when this reaches amount we return the list
			local c = 0
			-- loop through the amount once
			for _ = 1, amount do
				-- 16777216: https://en.wikipedia.org/wiki/Color_depth#True_color_(24-bit)
				-- we skip the alpha values
				local colour = AsyncRand(16777217) + -16777216
				if not color_ass[colour] then
					color_ass[colour] = true
					c = c + 1
				end
			end
			-- then make sure we're at count (
			while c < amount do
				local colour = AsyncRand(16777217) + -16777216
				if not color_ass[colour] then
					color_ass[colour] = true
					c = c + 1
				end
			end
			-- convert ass to idx list
			c = 0
			for colour in pairs(color_ass) do
				c = c + 1
				colour_list[c] = colour
			end

			return colour_list
		end

		-- return a single colour
		return AsyncRand(16777217) + -16777216
	end
	ChoGGi.ComFuncs.RandomColour = RandomColour

	function ChoGGi.ComFuncs.ObjectColourRandom(obj)
		-- If fired from action menu
		if IsKindOf(obj, "XAction") then
			obj = SelObject()
		else
			obj = obj or SelObject()
		end

		if not IsValid(obj) or obj and not obj:IsKindOf("ColorizableObject") then
			return
		end
		local attaches = {}
		local c = 0

		local a_list = GetAllAttaches(obj)
		for i = 1, #a_list do
			local a = a_list[i]
			if a:IsKindOf("ColorizableObject") then
				c = c + 1
				attaches[c] = {obj = a, c = {}}
			end
		end

		-- random is random after all, so lets try for at least slightly different colours
		-- you can do a max of 4 colours on each object
		local colours = RandomColour((c * 4) + 4)
		-- attach obj to list
		c = c + 1
		attaches[c] = {obj = obj, c = {}}

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
				-- object, 1-4 , Color, Roughness, Metallic
				obj:SetColorizationMaterial(1, c[1], Random(-128, 127), Random(-128, 127))
				obj:SetColorizationMaterial(2, c[2], Random(-128, 127), Random(-128, 127))
				obj:SetColorizationMaterial(3, c[3], Random(-128, 127), Random(-128, 127))
				obj:SetColorizationMaterial(4, c[4], Random(-128, 127), Random(-128, 127))
			end
		end

	end

	function ChoGGi.ComFuncs.ObjectColourDefault(obj)
		-- If fired from action menu
		if IsKindOf(obj, "XAction") then
			obj = SelObject()
		else
			obj = obj or SelObject()
		end

		if not obj then
			return
		end

		if IsValid(obj) and obj:IsKindOf("ColorizableObject") then
			RestoreOldPalette(obj)
		end

		local attaches = GetAllAttaches(obj)
		for i = 1, #attaches do
			RestoreOldPalette(attaches[i])
		end

	end

	-- make sure we're in the same grid
	local function CheckGrid(fake_parent, func, obj, obj_bld, choice, c_air, c_water, c_elec)
		-- this is ugly, i should clean it up
		if not c_air and not c_water and not c_elec then
			colour_funcs[func](obj, choice)
		else
			if c_air and obj_bld.air and fake_parent.air and obj_bld.air.grid.elements[1].building == fake_parent.air.grid.elements[1].building then
				colour_funcs[func](obj, choice)
			end
			if c_water and obj_bld.water and fake_parent.water and obj_bld.water.grid.elements[1].building == fake_parent.water.grid.elements[1].building then
				colour_funcs[func](obj, choice)
			end
			if c_elec and obj_bld.electricity and fake_parent.electricity and obj_bld.electricity.grid.elements[1].building == fake_parent.electricity.grid.elements[1].building then
				colour_funcs[func](obj, choice)
			end
		end
	end

	function ChoGGi.ComFuncs.ChangeObjectColour(obj, parent, dialog)
		if not obj or obj and not obj:IsKindOf("ColorizableObject") then
			MsgPopup(
				Strings[302535920000015--[[Can't colour %s.]]]:format(RetName(obj)),
				T(3595, "Color")
			)
			return
		end
		local pal = GetPalette(obj)

		local item_list = {}
		local c = 0
		for i = 1, 4 do
			local text = "Color" .. i
			c = c + 1
			item_list[c] = {
				text = text,
				value = pal[text],
				hint = Strings[302535920000017--[[Use the colour picker (dbl right-click for instant change).]]],
			}
			text = "Roughness" .. i
			c = c + 1
			item_list[c] = {
				text = text,
				value = pal[text],
				hint = Strings[302535920000018--[[Don't use the colour picker: Numbers range from -128 to 127.]]],
			}
			text = "Metallic" .. i
			c = c + 1
			item_list[c] = {
				text = text,
				value = pal[text],
				hint = Strings[302535920000018--[[Don't use the colour picker: Numbers range from -128 to 127.]]],
			}
		end
		c = c + 1
		item_list[c] = {
			text = "X_BaseColor",
			value = 6579300,
			obj = obj,
			hint = Strings[302535920000019--[["Single colour for object (this colour will interact with the other colours).
	If you want to change the colour of an object you can't with 1-4."]]],
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end

			if choice[13] then

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
				table_sort(choice, function(a, b)
					return a.text < b.text
				end)

				-- used to check for grid connections
				local choice1 = choice[1]
				local c_air = choice1.list_checkair
				local c_water = choice1.list_checkwater
				local c_elec = choice1.list_checkelec

				local colour_func = "SetColours"
				if choice1.check2 then
					colour_func = "RestoreOldPalette"
				end

				-- all of type checkbox
				if choice1.check1 then
					local labels = MapGet_ChoGGi(label)
					for i = 1, #labels do
						local lab_obj = labels[i]
						if parent then
							local attaches = GetAllAttaches(lab_obj)
							for j = 1, #attaches do
								CheckGrid(fake_parent, colour_func, attaches[j], lab_obj, choice, c_air, c_water, c_elec)
							end
						else
							CheckGrid(fake_parent, colour_func, lab_obj, lab_obj, choice, c_air, c_water, c_elec)
						end
					end

				-- single building change
				else
					CheckGrid(fake_parent, colour_func, obj, obj, choice, c_air, c_water, c_elec)
				end

				MsgPopup(
					Strings[302535920000020--[[Colour is set on %s]]]:format(RetName(obj)),
					T(3595, "Color"),
					{objects = obj}
				)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Translate(174--[[Color Modifier]]) .. ": " .. RetName(obj),
			hint = Strings[302535920000022--[["If number is 8421504 then you probably can't change that colour.

You can copy and paste numbers if you want."]]],
			parent = dialog,
			custom_type = 2,
			checkboxes = {
				{
					title = Strings[302535920000023--[[All of type]]],
					hint = Strings[302535920000024--[[Change all objects of the same type.]]],
				},
				{
					title = Strings[302535920000025--[[Default Colour]]],
					hint = Strings[302535920000026--[[if they're there; resets to default colours.]]],
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

do -- DeleteObject
	local DoneObject = DoneObject
	local DeleteThread = DeleteThread
	local DestroyBuildingImmediate = DestroyBuildingImmediate
	local FlattenTerrainInBuildShape = FlattenTerrainInBuildShape
	local HasAnySurfaces = HasAnySurfaces
	local ApplyAllWaterObjects = ApplyAllWaterObjects
	local terrain_HasRestoreHeight = terrain.HasRestoreHeight
	local terrain_UpdateWaterGridFromObject = terrain.UpdateWaterGridFromObject
	local EntitySurfaces_Height = EntitySurfaces.Height
	local procall = procall

	local DeleteObject

	local function DeleteLabelObjs(obj, label)
		SuspendPassEdits("ChoGGi.ComFuncs.DeleteLabelObjs")
		local objs = obj.labels[label] or ""
		for i = #objs, 1, -1 do
			local obj = objs[i]
			if not obj.passage_obj then
				DeleteObject(obj, true)
			end
		end
		ResumePassEdits("ChoGGi.ComFuncs.DeleteLabelObjs")
	end

	local function ExecFunc(obj, funcname, ...)
		if type(obj[funcname]) == "function" then
			obj[funcname](obj, ...)
		end
	end

	local function DeleteFunc(obj, skip_demo)
		if not IsValid(obj) then
			return
		end

		-- buildings, colonists, and passages need to be removed first
		if obj:IsKindOf("Dome") and not obj:CanDemolish() then
			DeleteLabelObjs(obj, "Building")
			DeleteLabelObjs(obj, "Colonist")
			local connected_domes = obj.connected_domes
			if connected_domes then
				for bad_obj in pairs(connected_domes) do
					if not IsValid(bad_obj) then
						-- remove invalid obj from dome list
						table.remove_entry(connected_domes[bad_obj], "handle", bad_obj.handle)
					-- obj stuck outside the map area ("holding area" for off planet rockets and so on)
					elseif (bad_obj:GetPos() or point20) == InvalidPos and not (bad_obj:IsKindOf("Colonist") and IsValid(bad_obj.holder)) then
						-- stick in dome for user to remove
						DeleteObject(bad_obj)
					end
				end
			end
			-- try deleting again
			DeleteObject(obj)

			if not obj:CanDemolish() then
				MsgPopup(
					Strings[302535920001354--[["<green>%s</green> is a Dome with stuff still in it (crash if deleted)."]]]:format(RetName(obj)),
					Strings[302535920000489--[["Delete Object(s)"]]]
				)
				return
			end
		end

		-- actually delete the whole passage
		if obj:IsKindOf("Passage") then
			for i = #obj.elements, 1, -1 do
				DeleteObject(obj.elements[i], true)
			end
			for i = #obj.elements_under_construction, 1, -1 do
				DeleteObject(obj.elements_under_construction[i], true)
			end
		end

		local is_deposit = obj:IsKindOf("Deposit")
		local is_water = obj:IsKindOf("TerrainWaterObject")
		local is_waterspire = obj:IsKindOf("WaterReclamationSpire") and not IsValid(obj.parent_dome)

		if not is_waterspire then
			-- some stuff will leave holes in the world if they're still working
			procall(ExecFunc, obj, "SetWorking")
		end

--~ 		procall(ExecFunc, obj, "RecursiveCall", true, "Done")

		-- remove leftover water
		if is_water then
			if IsValid(obj.water_obj) then
				terrain_UpdateWaterGridFromObject(obj.water_obj)
			end
			ApplyAllWaterObjects()
		end

		-- stop any threads (reduce log spam)
		for _, value in pairs(obj) do
			if type(value) == "thread" then
				DeleteThread(value)
			end
		end

		-- surface metal
		if is_deposit and obj.group then
			for i = #obj.group, 1, -1 do
				obj.group[i]:delete()
			end
		end

		-- ground n whatnot
		procall(ExecFunc, obj, "RestoreTerrain")
		procall(ExecFunc, obj, "Destroy")

		-- do we need to flatten the ground beneath
		if obj.GetFlattenShape then
			local shape = obj:GetFlattenShape()
			if shape ~= FallbackOutline then
				if HasAnySurfaces(obj, EntitySurfaces_Height, true)
				and not terrain_HasRestoreHeight() then
					FlattenTerrainInBuildShape(shape, obj)
				end
			end
		end

		procall(ExecFunc, obj, "SetDome", false)
		procall(ExecFunc, obj, "RemoveFromLabels")

		procall(ExecFunc, obj, "Gossip", "done")
		procall(ExecFunc, obj, "SetHolder", false)

		-- demo to the rescue
		obj.can_demolish = true
		obj.indestructible = false
		if not skip_demo and obj.DoDemolish then
			DestroyBuildingImmediate(obj)
		end

		-- I did ask nicely
		if IsValid(obj) then
			DoneObject(obj)
		end
	end

	function ChoGGi.ComFuncs.DeleteObject(objs, skip_demo)
		if not DeleteObject then
			DeleteObject = ChoGGi.ComFuncs.DeleteObject
		end

		if IsKindOf(objs, "XAction") then
			objs = SelObjects()
		else
			objs = objs or SelObjects()
		end

		if IsValid(objs) then
			CreateRealTimeThread(DeleteFunc, objs, skip_demo)
		elseif type(objs) == "table" then
			SuspendPassEdits("ChoGGi.ComFuncs.DeleteObject")
			CreateRealTimeThread(function()
				for i = #objs, 1, -1 do
					DeleteFunc(objs[i], skip_demo)
				end
			end)
			ResumePassEdits("ChoGGi.ComFuncs.DeleteObject")
		end

--~ 		-- hopefully i can remove all log spam one of these days
--~ 		local name = RetName(obj)
--~ 		if name then
--~ 			printC("DeleteObject", name, "DeleteObject")
--~ 		end

	end
end -- do
local DeleteObject = ChoGGi.ComFuncs.DeleteObject

do -- EmptyMechDepot
	local angle_x = {
		[0] = 500,
		[3600] = 500,
		[7200] = 0,
		[10800] = -600,
		[14400] = 0,
		[18000] = 500,
	}
	local angle_y = {
		[0] = 0,
		[3600] = 500,
		[7200] = 500,
		[10800] = 0,
		[14400] = -500,
		[18000] = -500,
	}
	-- sticks small depot in front of mech depot and moves all resources to it (max of 20 000)
	function ChoGGi.ComFuncs.EmptyMechDepot(obj, skip_delete)
		-- If fired from action menu
		if IsKindOf(obj, "XAction") then
			obj = SelObject()
		else
			obj = IsKindOf(obj, "MechanizedDepot") and obj or SelObject()
		end

		if not obj or not IsKindOf(obj, "MechanizedDepot") then
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
		local newx = angle_x[angle]
		local newy = angle_y[angle]

		-- yeah guys. lets have two names for a resource and use them interchangeably, it'll be fine...
		local res2 = res
		if res == "PreciousMetals" then
			res2 = "RareMetals"
		end

		local x, y, z = stock:GetVisualPosXYZ()
		-- so it doesn't look weird make sure it's on a hex point

		-- create new depot, and set max amount to stored amount of old depot
		local newobj = PlaceObj("UniversalStorageDepot", {
			"template_name", "Storage" .. res2,
			"storable_resources", {res},
			"max_storage_per_resource", amount,
			-- so it doesn't look weird make sure it's on a hex point
			"Pos", HexGetNearestCenter(point(x + newx, y + newy, z)),
		})

		-- make it align with the depot
		newobj:SetAngle(angle)
		-- clean out old depot
		obj:CheatEmpty()
		-- give it a bit before filling
		CreateGameTimeThread(function()
			local time = 0
			repeat
				Sleep(250)
				time = time + 25
			until type(newobj.requester_id) == "number" or time > 5000
			-- since we set new depot max amount to old amount we can just CheatFill it
			newobj:CheatFill()
			-- goodbye to old depot
			if not skip_delete then
				Sleep(250)
				DeleteObject(obj)
			end
		end)

	end
end -- do

-- returns the near hex grid for object placement
function ChoGGi.ComFuncs.CursorNearestHex(pt)
	return HexGetNearestCenter(pt or GetCursorOrGamePad())
end

function ChoGGi.ComFuncs.DeleteAllAttaches(obj)
	if obj.DestroyAttaches then
		obj:DestroyAttaches()
	end
end

do -- RetNearestResource/FindNearestResource
	local res_funcs = {}
	local res_mechdepot = {}
	local AllResourcesList = AllResourcesList
	for i = 1, #AllResourcesList do
		local res = AllResourcesList[i]
		res_funcs[res] = "GetStored_" .. res
		res_mechdepot[res] = "MechanizedDepot" .. res
	end
	local GetStored, res_amount, res_resource
	local function FilterTable(depot)
		-- check if depot has the resource
		if (depot.resource == res_resource or table_find(depot.resource, res_resource))
			-- check if depot has resource amount
			and depot[GetStored] and depot[GetStored](depot) >= res_amount
		then
			return true
		end
	end

	local stockpiles_table = {}
	local stockpiles
	local function RetNearestResourceDepot(resource, obj, list, amount, skip_stocks)
		GetStored = res_funcs[resource] or "GetStored_" .. resource
		res_resource = resource

		if list then
			stockpiles = list
			res_amount = amount
		else
			-- attached stockpiles/stockpiles left from removed objects
			if skip_stocks then
				stockpiles = MapGet("map", "ResourceStockpile", "ResourceStockpileLR")
			else
				table_iclear(stockpiles_table)
				stockpiles = stockpiles_table
			end
			res_amount = amount or 1000

			local labels = UICity.labels
			-- every resource has a mech depot
			table_append(stockpiles, labels[res_mechdepot[resource] or "MechanizedDepot" .. resource])

			-- labels.UniversalStorageDepot includes the "other" depots, but not the below three
			if resource == "BlackCube" then
				table_append(stockpiles, labels.BlackCubeDumpSite)
			elseif resource == "MysteryResource" then
				table_append(stockpiles, labels.MysteryDepot)
			elseif resource == "WasteRock" then
				table_append(stockpiles, labels.WasteRockDumpSite)
			else
				table_append(stockpiles, labels.UniversalStorageDepot)
			end
		end

		return FindNearestObject(stockpiles, obj:GetPos():SetInvalidZ(), FilterTable)
	end
	ChoGGi.ComFuncs.RetNearestResourceDepot = RetNearestResourceDepot

	function ChoGGi.ComFuncs.FindNearestResource(obj)
		-- If fired from action menu
		if IsKindOf(obj, "XAction") then
			obj = SelObject()
		else
			obj = obj or SelObject()
		end

		if not IsValid(obj) then
			MsgPopup(
				Strings[302535920000027--[[Nothing selected]]],
				Strings[302535920000028--[[Find Resource]]]
			)
			return
		end

		-- build list of resources
		local item_list = {}
		local ResourceDescription = ResourceDescription
		local res = ChoGGi.Tables.Resources
		local TagLookupTable = const.TagLookupTable
		for i = 1, #res do
			local item = ResourceDescription[table_find(ResourceDescription, "name", res[i])]
			item_list[i] = {
				text = Translate(item.display_name),
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
				local nearest = RetNearestResourceDepot(value, obj)
				-- If there's no resource then there's no "nearest"
				if nearest then
					-- the power of god
					ViewObjectMars(nearest)
					ChoGGi.ComFuncs.AddBlinkyToObj(nearest)
				else
					MsgPopup(
						Strings[302535920000029--[[Error: Cannot find any %s.]]]:format(choice[1].text),
						T(15, "Resource")
					)
				end

			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000031--[[Find Nearest Resource]]] .. ": " .. RetName(obj),
			hint = Strings[302535920000032--[[Select a resource to find]]],
			skip_sort = true,
			custom_type = 7,
		}
	end
end

do -- BuildingConsumption
	local function AddConsumption(obj, name, class)
		if not obj:IsKindOf(class) then
			return
		end
		local tempname = "ChoGGi_mod_" .. name
		-- If this is here we know it has what we need so no need to check for mod/consump
		if obj[tempname] then
			local mod = obj.modifications[name]
			if mod[1] then
				mod = mod[1]
			end
			if mod.IsKindOf then
				local orig = obj[tempname]
				if mod:IsKindOf("ObjectModifier") then
					mod:Change(orig.amount, orig.percent)
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
	local function RemoveConsumption(obj, name, class)
		if not obj:IsKindOf(class) then
			return
		end
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
				mod:Change(0, 0)
			end
		end
		obj:SetBase(name, 0)
	end

	function ChoGGi.ComFuncs.RemoveBuildingWaterConsump(obj)
		RemoveConsumption(obj, "water_consumption", "LifeSupportConsumer")
		if obj:IsKindOf("LandscapeLake") then
			obj.irrigation = obj:GetDefaultPropertyValue("irrigation") * -1
			ChoGGi.ComFuncs.ToggleWorking(obj)
		end
	end
	function ChoGGi.ComFuncs.AddBuildingWaterConsump(obj)
		AddConsumption(obj, "water_consumption", "LifeSupportConsumer")
		if obj:IsKindOf("LandscapeLake") then
			obj.irrigation = obj:GetDefaultPropertyValue("irrigation")
			ChoGGi.ComFuncs.ToggleWorking(obj)
		end
	end
	function ChoGGi.ComFuncs.RemoveBuildingElecConsump(obj)
		RemoveConsumption(obj, "electricity_consumption", "ElectricityConsumer")
	end
	function ChoGGi.ComFuncs.AddBuildingElecConsump(obj)
		AddConsumption(obj, "electricity_consumption", "ElectricityConsumer")
	end
	function ChoGGi.ComFuncs.RemoveBuildingAirConsump(obj)
		RemoveConsumption(obj, "air_consumption", "LifeSupportConsumer")
	end
	function ChoGGi.ComFuncs.AddBuildingAirConsump(obj)
		AddConsumption(obj, "air_consumption", "LifeSupportConsumer")
	end
end -- do

function ChoGGi.ComFuncs.CollisionsObject_Toggle(obj, skip_msg)
	-- If fired from action menu
	if IsKindOf(obj, "XAction") then
		obj = SelObject()
		skip_msg = nil
	else
		obj = obj or SelObject()
	end

	if not IsValid(obj) then
		if not skip_msg then
			MsgPopup(
				Strings[302535920000027--[[Nothing selected]]],
				Strings[302535920000968--[[Collisions]]]
			)
		end
		return
	end
	local collision = const.efCollision + const.efApplyToGrids

	local which
	-- hopefully give it a bit more speed
	SuspendPassEdits("ChoGGi.ComFuncs.CollisionsObject_Toggle")
	-- re-enable col on obj and any attaches
	if obj.ChoGGi_CollisionsDisabled then
		-- collision on object
		obj:SetEnumFlags(collision)
		-- and any attaches
		if obj.ForEachAttach then
			obj:ForEachAttach(function(a)
				a:SetEnumFlags(collision)
			end)
		end
		obj.ChoGGi_CollisionsDisabled = nil
		which = Translate(12227--[[Enabled]])
	else
		obj:ClearEnumFlags(collision)
		if obj.ForEachAttach then
			obj:ForEachAttach(function(a)
				a:ClearEnumFlags(collision)
			end)
		end
		obj.ChoGGi_CollisionsDisabled = true
		which = Translate(847439380056--[[Disabled]])
	end
	ResumePassEdits("ChoGGi.ComFuncs.CollisionsObject_Toggle")

	if not skip_msg then
		MsgPopup(
			Strings[302535920000969--[[Collisions %s on %s]]]:format(which, RetName(obj)),
			Strings[302535920000968--[[Collisions]]],
			{objects = obj}
		)
	end
end

function ChoGGi.ComFuncs.ToggleCollisions(cls)
	-- pretty much the only thing I use it for, but just in case
	cls = cls or "LifeSupportGridElement"
	local CollisionsObject_Toggle = ChoGGi.ComFuncs.CollisionsObject_Toggle
	-- hopefully give it a bit more speed
	SuspendPassEdits("ChoGGi.ComFuncs.ToggleCollisions")
	MapForEach("map", cls, function(o)
		CollisionsObject_Toggle(o, true)
	end)
	ResumePassEdits("ChoGGi.ComFuncs.ToggleCollisions")
end

do -- AddXTemplate/RemoveXTemplateSections
	local function RemoveTableItem(list, name, value)
		local idx = table_find(list, name, value)
		if idx then
			if not type(list[idx]) == "function" then
				list[idx]:delete()
			end
			table_remove(list, idx)
		end
	end
	ChoGGi.ComFuncs.RemoveTableItem = RemoveTableItem

	-- check for and remove old object (XTemplates are created on new game/new dlc ?)
	local function RemoveXTemplateSections(list, name, value)
		RemoveTableItem(list, name, value or true)
	end
	ChoGGi.ComFuncs.RemoveXTemplateSections = RemoveXTemplateSections

	local empty_func = empty_func
	local function RetTrue()
		return true
	end
	local function RetParent(self)
		return self.parent
	end
	local function AddTemplate(xt, name, pos, list)
		if not xt or not name or not list then
			local f = ObjPropertyListToLuaCode
			print(Strings[302535920001383--[[AddXTemplate borked template name: %s template: %s list: %s]]]:format(name and f(name), template and f(template), list and f(list)))
			return
		end
		local stored_name = "ChoGGi_Template_" .. name

		RemoveXTemplateSections(xt, stored_name)
		pos = pos or #xt
		if pos < 1 then
			pos = 1
		end
		table.insert(xt, pos, PlaceObj("XTemplateTemplate", {
			-- legacy ref
			stored_name, true,
			-- new ref
			"Id", stored_name,
			"__condition", list.__condition or RetTrue,
			"__context_of_kind", list.__context_of_kind or "",
			"__template", list.__template or "InfopanelActiveSection",
			"Title", list.Title or Translate(1000016--[[Title]]),
			"Icon", list.Icon or "UI/Icons/gpmc_system_shine.tga",
			"RolloverTitle", list.RolloverTitle or Translate(126095410863--[[Info]]),
			"RolloverText", list.RolloverText or Translate(126095410863--[[Info]]),
			"RolloverHint", list.RolloverHint or "",
			"OnContextUpdate", list.OnContextUpdate or empty_func,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", RetParent,
				"func", list.func or empty_func,
			})
		}))
	end

	-- new	xt, 		name, 		pos, 	list
		--~ AddXTemplate(XTemplates.ipColonist[1], "LockworkplaceColonist", nil, {
	-- old: name, template, list, toplevel
		--~ AddXTemplate("SolariaTelepresence_sectionWorkplace1", "sectionWorkplace", {
	function ChoGGi.ComFuncs.AddXTemplate(xt, name, pos, list)
		if type(xt) == "string" then
			if list then
				AddTemplate(XTemplates[name], xt, nil, pos)
			else
				AddTemplate(XTemplates[name][1], xt, nil, pos)
			end
		else
			AddTemplate(xt, name, pos, list)
		end
	end
end -- do

local function CheatsMenu_Toggle()
	local menu = XShortcutsTarget
	if ChoGGi.UserSettings.KeepCheatsMenuPosition then
		ChoGGi.UserSettings.KeepCheatsMenuPosition = menu:GetPos()
	end
	if menu:GetVisible() then
		menu:SetVisible()
	else
		menu:SetVisible(true)
	end
	ChoGGi.ComFuncs.SetCheatsMenuPos()
end
ChoGGi.ComFuncs.CheatsMenu_Toggle = CheatsMenu_Toggle

do -- UpdateConsoleMargins
	local IsEditorActive = IsEditorActive
	local box = box

	local margins = GetSafeMargins()
	-- normally visible
	local margin_vis = box(10, 80, 10, 65) + margins
	-- console hidden
	local margin_hidden = box(10, 80, 10, 10) + margins
	local margin_vis_editor_log = box(10, 80, 10, 45) + margins
	local margin_vis_con_log = box(10, 80, 10, 115) + margins
	local con_margin_editor = box(0, 0, 0, 50) + margins
	local con_margin_norm = box(0, 0, 0, 0) + margins
--~ box(left/x, top/y, right/w, bottom/h) :minx() :miny() :sizex() :sizey()
	if Platform.durango then
		margin_vis = box(60, 80, 10, 65) + margins
		margin_hidden = box(60, 80, 10, 10) + margins
		margin_vis_editor_log = box(60, 80, 10, 45) + margins
		margin_vis_con_log = box(60, 80, 10, 115) + margins
		con_margin_norm = box(50, -50, 0, 0) + margins
	end

	function ChoGGi.ComFuncs.UpdateConsoleMargins(console_vis)
		local e = IsEditorActive()
		-- editor mode adds a toolbar to the bottom, so we go above it
		if dlgConsole then
			dlgConsole:SetMargins(e and con_margin_editor or con_margin_norm)
		end
		-- move log text above the buttons i added and make sure log text stays below the cheat menu
		if dlgConsoleLog then
			if console_vis then
				dlgConsoleLog.idText:SetMargins(e and margin_vis_con_log or margin_vis)
			else
				dlgConsoleLog.idText:SetMargins(e and margin_vis_editor_log or margin_hidden)
			end
		end
	end
end -- do

do -- Editor toggle
	local editor_active

	function ChoGGi.ComFuncs.Editor_Toggle()
		if Platform.durango then
			print(Strings[302535920001574--[[Crashes on XBOX!]]])
			MsgPopup(Strings[302535920001574--[[Crashes on XBOX!]]])
			return
		end

		-- force editor to toggle once (makes status text work properly the "first" toggle instead of the second)
		local idx = table_find(terminal.desktop, "class", "EditorInterface")
		if not idx then
			EditorState(1, 1)
			EditorDeactivate()
		end

		if IsEditorActive() then
			EditorDeactivate()
			editor_active = false
			Platform.developer = false
			-- restore cheats menu
			XShortcutsTarget:SetVisible()
			XShortcutsTarget:SetVisible(true)
		else
			editor_active = true
			Platform.developer = true
			table.change(hr, "Editor", {
				ResolutionPercent = 100,
				DynResTargetFps = 0,
				EnablePreciseSelection = 1,
				ObjectCounter = 1,
				VerticesCounter = 1,
				FarZ = 1500000
			})
			XShortcutsSetMode("Editor", function()
				EditorDeactivate()
			end)
			EditorState(1, 1)
		end

		ChoGGi.ComFuncs.UpdateConsoleMargins()

		camera.Unlock(1)
		ChoGGi.ComFuncs.SetCameraSettings()
	end

	function ChoGGi.ComFuncs.TerrainEditor_Toggle()
		if Platform.durango then
			print(Strings[302535920001574--[[Crashes on XBOX!]]])
			MsgPopup(Strings[302535920001574--[[Crashes on XBOX!]]])
			return
		end
		ChoGGi.ComFuncs.Editor_Toggle()
		local ToggleCollisions = ChoGGi.ComFuncs.ToggleCollisions
		if editor_active then
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
			Flight_OnHeightChanged()
		end
	end

	function ChoGGi.ComFuncs.PlaceObjects_Toggle()
		if Platform.durango then
			print(Strings[302535920001574--[[Crashes on XBOX!]]])
			MsgPopup(Strings[302535920001574--[[Crashes on XBOX!]]])
			return
		end
		ChoGGi.ComFuncs.Editor_Toggle()
		if editor_active then
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
end -- do

-- set task request to new amount (for some reason changing the "limit" will also boost the stored amount)
-- this will reset it back to whatever it was after changing it.
function ChoGGi.ComFuncs.SetTaskReqAmount(obj, value, task, setting, task_num)
--~ ChoGGi.ComFuncs.SetTaskReqAmount(rocket, value, "export_requests", "max_export_storage")
	-- If it's in a table, it's almost always [1], i'm sure i'll have lots of crap to fix on any update anyways, so screw it
	if type(obj[task]) == "userdata" then
		task = obj[task]
	else
		task = obj[task][task_num or 1]
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

function ChoGGi.ComFuncs.ReturnEditorType(list, key, value)
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

	function ChoGGi.ComFuncs.AddBlinkyToObj(obj, timeout)
		if not IsValid(obj) then
			return
		end
		-- If it was attached to something deleted, or fresh start
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
			-- If it's larger then a dome, but isn't a BaseBuilding then we'll just ignore it (DomeGeoscapeWater)
			if offset > 10000 and not obj:IsKindOf("BaseBuilding") or offset < 250 then
				offset = 250
			end
		end
		-- attach blinky so it's noticeable
		obj:Attach(blinky_obj, spot)
		blinky_obj:SetAttachOffset(point(0, 0, offset))
		-- hide blinky after we select something else or timeout, we don't delete since we move it from obj to obj
		blinky_thread = CreateRealTimeThread(function()
			WaitMsg("SelectedObjChange", timeout or 10000)
			blinky_obj:SetVisible()
		end)
	end
end -- do

function ChoGGi.ComFuncs.PlaceLastSelectedConstructedBld()
	local obj = ChoGGi.ComFuncs.SelObject()
	local Temp = ChoGGi.Temp

	if obj then
		Temp.LastPlacedObject = obj
	elseif Temp.LastPlacedObject then
		obj = Temp.LastPlacedObject
	else
		obj = UICity and UICity.LastConstructedBuilding
	end

	if obj and obj.class then
		local obj_class = ChoGGi.ComFuncs.RetTemplateOrClass(obj)
		if obj_class == "ConstructionSite" then
			obj_class = obj.building_class
		end
		ChoGGi.ComFuncs.ConstructionModeSet(obj_class)
	end
end

-- place item under the mouse for construction
function ChoGGi.ComFuncs.ConstructionModeSet(itemname)
	-- make sure it's closed so we don't mess up selection
	if GetDialog("XBuildMenu") then
		CloseDialog("XBuildMenu")
	end
	-- fix up some names
	itemname = ChoGGi.Tables.ConstructionNamesListFix[itemname] or itemname

	-- n all the rest
	local igi = Dialogs.InGameInterface
	if not igi or not igi:GetVisible() then
		return
	end

	local bld_template = BuildingTemplates[itemname]
	if not bld_template then
		return
	end
	local _, _, can_build, action = UIGetBuildingPrerequisites(bld_template.build_category, bld_template, true)

	local dlg = Dialogs.XBuildMenu
	local name = bld_template.id ~= "" and bld_template.id or bld_template.template_name or bld_template.template_class
	if action then
		action(dlg, {
			enabled = can_build,
			name = name,
			construction_mode = bld_template.construction_mode
		})
	-- ?
	else
		igi:SetMode("construction", {
			template = name,
			selected_dome = dlg and dlg.context.selected_dome
		})
	end
	CloseDialog("XBuildMenu")
end

function ChoGGi.ComFuncs.DeleteLargeRocks()
	local function CallBackFunc(answer)
		if answer then
			SuspendPassEdits("ChoGGi.ComFuncs.DeleteLargeRocks")
			MapDelete(true, {"Deposition", "WasteRockObstructorSmall", "WasteRockObstructor"})
			ResumePassEdits("ChoGGi.ComFuncs.DeleteLargeRocks")
		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning]]) .. "!\n" .. Strings[302535920001238--[[Removes rocks for that smooth map feel.]]],
		CallBackFunc,
		Translate(6779--[[Warning]]) .. ": " .. Strings[302535920000855--[[Last chance before deletion!]]]
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
		Translate(6779--[[Warning]]) .. "!\n" .. Strings[302535920001238--[[Removes rocks for that smooth map feel.]]],
		CallBackFunc,
		Translate(6779--[[Warning]]) .. ": " ..Strings[302535920000855--[[Last chance before deletion!]]]
	)
end

-- build and show a list of attachments for changing their colours
function ChoGGi.ComFuncs.CreateObjectListAndAttaches(obj)
	-- If fired from action menu
	if IsKindOf(obj, "XAction") then
		obj = SelObject()
	else
		obj = obj or SelObject()
	end

	if not obj or obj and not obj:IsKindOf("ColorizableObject") then
		MsgPopup(
			Strings[302535920001105--[[Select/mouse over an object (buildings, vehicles, signs, rocky outcrops).]]],
			T(3595, "Color")
		)
		return
	end

	local item_list = {}
	local c = 0

	-- has no Attaches so just open as is
	if obj.CountAttaches and obj:CountAttaches() == 0 then
		ChoGGi.ComFuncs.ChangeObjectColour(obj)
		return
	else
		c = c + 1
		item_list[c] = {
			text = " " .. obj.class,
			value = obj.class,
			obj = obj,
			hint = Strings[302535920001106--[[Change main object colours.]]],
		}

		local attaches = GetAllAttaches(obj)
		for i = 1, #attaches do
			local a = attaches[i]
			if a:IsKindOf("ColorizableObject") then
				c = c + 1
				item_list[c] = {
					text = a.class,
					value = a.class,
					parentobj = obj,
					obj = a,
					hint = Strings[302535920001107--[[Change colours of an attached object.]]] .. "\n"
						.. Strings[302535920000955--[[Handle]]] .. ": " .. (a.handle or ""),
				}
			end
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		items = item_list,
		title = Translate(174--[[Color Modifier]]) .. ": " .. RetName(obj),
		hint = Strings[302535920001108--[[Double click to open object/attachment to edit (select to flash object).]]],
		custom_type = 1,
		custom_func = function(sel, dialog)
			ChoGGi.ComFuncs.ChangeObjectColour(sel[1].obj, sel[1].parentobj, dialog)
		end,
		select_flash = true,
	}
end

function ChoGGi.ComFuncs.OpenGedApp(name)
	if type(name) ~= "string" then
		name = "XWindowInspector"
	end
	OpenGedApp(name, terminal.desktop)
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

function ChoGGi.ComFuncs.SetTableValue(tab, id, id_name, item, value)
	local idx = table_find(tab, id, id_name)
	if idx then
		tab[idx][item] = value
		return tab[idx]
	end
end

do -- PadNumWithZeros
	local pads = objlist:new()
	-- 100, 00000 = "00100"
	function ChoGGi.ComFuncs.PadNumWithZeros(num, pad)
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

		return TableConcat(pads)
	end
end -- do

function ChoGGi.ComFuncs.RemoveObjs(class, reason)
	-- If there's a reason then check if it's suspending
	local not_sus = reason and not s_SuspendPassEditsReasons[reason]
	-- If it isn't then suspend it
	if not_sus then
		-- suspending pass edits makes deleting much faster
		SuspendPassEdits(reason)
	end

	if type(class) == "table" then
		local g_Classes = g_Classes
		local MapDelete = MapDelete

		for _ = 1, #class do
			-- If it isn't a valid class then Map* will return all objects :(
			if g_Classes[class] then
				MapDelete(true, class)
			end
		end
	else
		if g_Classes[class] then
			MapDelete(true, class)
		end
	end

	if not_sus then
		ResumePassEdits(reason)
	end
end

do -- SpawnColonist
	local Msg = Msg
	local GenerateColonistData = GenerateColonistData
	local GetRandomPassablePoint = GetRandomPassablePoint

	function ChoGGi.ComFuncs.SpawnColonist(old_c, building, pos, city)
		city = city or UICity

		local colonist
		if old_c then
			colonist = GenerateColonistData(city, old_c.age_trait, false, {
				gender = old_c.gender,
				entity_gender = old_c.entity_gender,
				no_traits	=	"no_traits",
				no_specialization = true,
			})
			-- we set all the set gen doesn't (it's more for random gen after all
			colonist.birthplace = old_c.birthplace
			colonist.death_age = old_c.death_age
			colonist.name = old_c.name
			colonist.race = old_c.race
			for trait_id in pairs(old_c.traits) do
				if trait_id and trait_id ~= "" then
					colonist.traits[trait_id] = true
				end
			end
		else
			-- GenerateColonistData(city, age_trait, martianborn, gender, entity_gender, no_traits)
			colonist = GenerateColonistData(city)
		end

		Colonist:new(colonist)
		Msg("ColonistBorn", colonist)

		-- can't fire till after :new()
		if old_c then
			colonist:SetSpecialization(old_c.specialist)
		end
		colonist:SetPos((pos
			or building and GetPassablePointNearby(building:GetPos())
			or GetRandomPassablePoint()):SetTerrainZ()
		)

		-- If age/spec is different this updates to new entity
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
	local XInput_IsControllerConnected = XInput.IsControllerConnected
	local XInput_IsCtrlButtonPressed = XInput.IsCtrlButtonPressed

	local function IsControlPressed()
		return IsKeyPressed(vkControl) or osx and IsKeyPressed(vkLwin)
	end
	ChoGGi.ComFuncs.IsControlPressed = IsControlPressed
	ChoGGi.ComFuncs.IsCtrlPressed = IsControlPressed
	function ChoGGi.ComFuncs.IsShiftPressed()
		return IsKeyPressed(vkShift)
	end
	function ChoGGi.ComFuncs.IsAltPressed()
		return IsKeyPressed(vkAlt)
	end
	function ChoGGi.ComFuncs.IsGamepadButtonPressed(button)
		return XInput_IsCtrlButtonPressed(XInput_IsControllerConnected(s_XInputControllersConnected-1), button)
	end
end -- do

-- if it's an object than we can Clone() it, otherwise copy it
function ChoGGi.ComFuncs.CopyTable(list)
	local new
	if list.class and g_Classes[list.class] then
		new = list:Clone()
	else
		new = {}
	end

	for key, value in pairs(list) do
		new[key] = value
	end
	return new
end

-- associative tables only, otherwise table.is_iequal(t1, t1)
function ChoGGi.ComFuncs.TableIsEqual(t1, t2)
	-- see which one is longer, we use that as the looper
	local c1, c2 = 0, 0
	for _ in pairs(t1) do
		c1 = c1 + 1
	end
	for _ in pairs(t2) do
		c1 = c1 + 1
	end

	local is_equal = true
	if c1 >= c2 then
		for key, value in pairs(t1) do
			if value ~= t2[key] then
				is_equal = false
				break
			end
		end
	else
		for key, value in pairs(t2) do
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
		terrain = {
			category_StonesRocksCliffs = true,
			entity = {
				material_type = "Rock",
			},
		},
	}

	-- local instead of global is quicker
	local EntityData = EntityData
	local EntityLoadEntities = EntityLoadEntities
	local SetEntityFadeDistances = SetEntityFadeDistances

	function ChoGGi.ComFuncs.LoadEntity(name, path, mod, template)
		EntityData[name] = entity_templates[template or "decal"]

		EntityLoadEntities[#EntityLoadEntities + 1] = {
			mod,
			name,
			path
		}
		SetEntityFadeDistances(name, -1, -1)
	end
end -- do


-- this only adds a parent, no ___BuildingUpdate or anything
-- AddParentToClass(DontBuildHere, "InfopanelObj")
function ChoGGi.ComFuncs.AddParentToClass(class_obj, parent_name)
	local p = class_obj.__parents
	if not table_find(p, parent_name) then
		p[#p+1] = parent_name
	end
end

function ChoGGi.ComFuncs.RetSpotPos(obj, building, spot)
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
	if obj then
		return obj.template_name ~= "" and obj.template_name or obj.class
	end
	return ""
end

do -- ToggleBldFlags
	local function ToggleBldFlags(obj, flag)
		local func
		if obj:GetGameFlags(flag) == flag then
			func = "ClearGameFlags"
		else
			func = "SetGameFlags"
		end

		obj[func](obj, flag)
		local attaches = GetAllAttaches(obj)
		for i = 1, #attaches do
			local a = attaches[i]
			if not (a:IsKindOf("BuildingSign") or a:IsKindOf("GridTile") or a:IsKindOf("GridTileWater")) then
				a[func](a, flag)
			end
		end
	end
	ChoGGi.ComFuncs.ToggleBldFlags = ToggleBldFlags

	function ChoGGi.ComFuncs.ToggleConstructEntityView(obj)
		ToggleBldFlags(obj, 65536)
	end
	function ChoGGi.ComFuncs.ToggleEditorEntityView(obj)
		ToggleBldFlags(obj, 2)
	end
end -- do

function ChoGGi.ComFuncs.DeleteObjectQuestion(obj)
	local name = RetName(obj)
	local function CallBackFunc(answer)
		if answer then
			-- remove select from it
			if SelectedObj == obj then
				SelectObj()
			end

			-- map objects
			if IsValidThread(obj) then
				DeleteThread(obj)
			elseif IsValid(obj) then
				DeleteObject(obj)
			-- xwindows
			elseif obj.Close then
				obj:Close()
			-- whatever
			else
				DoneObject(obj)
			end

		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		T(6779, "Warning") .. "!\n" .. Strings[302535920000414--[[Are you sure you wish to delete %s?]]]:format(name) .. "?",
		CallBackFunc,
		T(6779, "Warning") .. ": " .. Strings[302535920000855--[[Last chance before deletion!]]],
		T(5451, "DELETE") .. ": " .. name,
		T(6879, "Cancel") .. " " .. T(502364928914, "Delete")
	)
end

function ChoGGi.ComFuncs.RuinObjectQuestion(obj)
	local name = RetName(obj)
	local obj_type
	if obj:IsKindOf("BaseRover") then
		obj_type = T(7825, "Destroy this Rover.")
	elseif obj:IsKindOf("Drone") then
		obj_type = T(7824, "Destroy this Drone.")
	else
		obj_type = T(7822, "Destroy this building.")
	end

	local function CallBackFunc(answer)
		if answer then
			if obj:IsKindOf("Dome") and not obj:CanDemolish() then
				MsgPopup(
					Strings[302535920001354--[["<green>%s</green> is a Dome with stuff still in it (crash if deleted)."]]]:format(name),
					Strings[302535920000489--[[Delete Object(s)]]]
				)
				return
			end

			obj.can_demolish = true
			obj.indestructible = false
			obj.demolishing_countdown = 0
			obj.demolishing = true
			obj:DoDemolish()
			-- probably not needed
			DestroyBuildingImmediate(obj)

		end
	end
	ChoGGi.ComFuncs.QuestionBox(
		T(6779, "Warning") .. "!\n" .. obj_type .. "\n" .. name,
		CallBackFunc,
		T(6779, "Warning") .. ": " .. obj_type,
		obj_type .. " " .. name,
		T(1176, "Cancel Destroy")
	)
end

do -- ImageExts
	-- easier to keep them in one place
	local ext_list = {
		dds = true,
		tga = true,
		png = true,
		jpg = true,
		jpeg = true,
	}
	-- ImageExts()[str:sub(-3):lower()]
	function ChoGGi.ComFuncs.ImageExts()
		return ext_list
	end
end -- do

do -- IsPosInMap
	local construct

	function ChoGGi.ComFuncs.IsPosInMap(pt)
		construct = construct or ChoGGi.ComFuncs.ConstructableArea()
		return pt:InBox2D(construct)
	end
end -- do

do -- PolylineSetParabola
	-- copy n pasta from Lua/Dev/MapTools.lua
	local Min = Min
	local ValueLerp = ValueLerp
	local function parabola(x)
		return 4 * x - x * x / 25
	end
	local guim10 = 10 * guim
	local white = white
	local vertices = {}

	function ChoGGi.ComFuncs.PolylineSetParabola(line, from, to, colour)
		if not line then
			return
		end
		local parabola_h = Min(from:Dist(to), guim10)
		local pos_lerp = ValueLerp(from, to, 100)
		local steps = 10
		local c = 0
		table_iclear(vertices)
		for i = 0, steps do
			local x = i * (100 / steps)
			local pos = pos_lerp(x)
			pos = pos:AddZ(parabola(x) * parabola_h / 100)
			c = c + 1
			vertices[c] = pos
		end
		line:SetMesh(vertices, colour or white)
	end
end -- do

-- "idLeft", "idMiddle", "idRight"
function ChoGGi.ComFuncs.RetHudButton(side)
	side = side or "idLeft"

	local xt = XTemplates
	local idx = table_find(xt.HUD[1], "Id", "idBottom")
	if not idx then
		print("ChoGGi RetHudButton: Missing HUD control idBottom")
		return
	end
	xt = xt.HUD[1][idx]
	idx = table_find(xt, "Id", side)
	if not idx then
		print("ChoGGi RetHudButton: Missing HUD control " .. side)
		return
	end
	return xt[idx][1]
end

do -- RetMapSettings
	local GetRandomMapGenerator = GetRandomMapGenerator
	local FillRandomMapProps = FillRandomMapProps

	function ChoGGi.ComFuncs.RetMapSettings(gen, params, ...)
		if not params then
			params = g_CurrentMapParams
		end
		if gen == true then
			gen = GetRandomMapGenerator() or {}
		end

		return FillRandomMapProps(gen, params, ...), params, gen
	end
end -- do

do -- RetMapBreakthroughs

--~ 	local function UnlockAnom()
--~ 		local objs = UICity.labels.Anomaly or ""
--~ 		local c = 0
--~ 		for i = #objs, 1, -1 do
--~ 			local obj = objs[i]
--~ 			if obj:IsKindOf("SubsurfaceAnomaly_breakthrough") then
--~ 				print(obj.breakthrough_tech)
--~ 				obj:CheatScan()
--~ 				c = c + 1
--~ 			end
--~ 		end
--~ 		print("Anomaly Count", c)
--~ 		-- 8 on ground
--~ 		-- 3 omega
--~ 		-- 4 planetary
--~ 		-- other 5 from meteors?
--~ 	end
--~ 	UnlockAnom()

	local StableShuffle = StableShuffle
	local CreateRand = CreateRand
	local breakthrough_count, orig_break_list
	local remove_added = {}
	local translated_tech

	function ChoGGi.ComFuncs.RetMapBreakthroughs(gen, omega)
		-- build list of names once
		if not translated_tech then
			translated_tech = {}
			local TechDef = TechDef
			for tech_id, tech in pairs(TechDef) do
				if tech.group == "Breakthroughs" then
					translated_tech[tech_id] = Translate(tech.display_name)
				end
			end
			-- breakthroughs per map are 20? in total (4 planetary, 3 omega, 8 on the ground, 5 Storybits?)
			breakthrough_count = const.BreakThroughTechsPerGame
				+ const.OmegaTelescopeBreakthroughsCount
				+ Consts.PlanetaryBreakthroughCount
			orig_break_list = table.imap(Presets.TechPreset.Breakthroughs, "id")
		end

		-- start with a clean copy of breaks
		local break_order = table_copy(orig_break_list)
		StableShuffle(break_order, CreateRand(true, gen.Seed, "ShuffleBreakThroughTech"), 100)

		while #break_order > breakthrough_count do
			break_order[#break_order] = nil
		end

		local tech_list = {}

		table_clear(remove_added)

		local c = #break_order - 3 -- 3=omega
		for i = 1, c do
			local id = break_order[i]
			-- translate tech
			tech_list[i] = translated_tech[id]
			remove_added[id] = true
		end

--~ 		ex(break_order)
--~ 	OmegaTelescope.UnlockBreakthroughs({city = UICity}, 3)

		if omega then
			for i = c, 1, -1 do
				if remove_added[break_order[i]] then
					table_remove(break_order, i)
				end
			end

			-- use the previously shuffled break_order
			StableShuffle(break_order, CreateRand(true, gen.Seed, "OmegaTelescope"), 100)
			for i = c+1, c+3 do
				tech_list[i] = translated_tech[table_remove(break_order)]
			end
		end

		return tech_list
	end
end -- do

do -- RetObjectEntity
	local GetSpecialistEntity = GetSpecialistEntity
	local IsValidEntity = IsValidEntity

	function ChoGGi.ComFuncs.RetObjectEntity(obj)
		if not (obj and obj:IsKindOf("CObject")) then
			return
		end

		local entity
		if obj:IsKindOf("Colonist") then
			entity = GetSpecialistEntity(obj.specialist, obj.entity_gender, obj.race, obj.age_trait, obj.traits)
		else
			entity = obj:GetEntity()
		end

		if IsValidEntity(entity) then
			return entity
		end
	end
end -- do

function ChoGGi.ComFuncs.DisastersStop()
	CheatStopDisaster()

	local missles = g_IncomingMissiles or empty_table
	for missle in pairs(missles) do
		missle:ExplodeInAir()
	end

	if g_DustStorm then
		StopDustStorm()
		g_DustStormType = false
	end

	if g_ColdWave then
		StopColdWave()
		g_ColdWave = false
	end

	if g_RainDisaster then
		StopRainsDisaster()
		g_RainDisaster = false
	end

	-- might help me prevent log spam if I copy n paste elsewhere?
	local objs

	objs = g_DustDevils or ""
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	objs = g_MeteorsPredicted or ""
	for i = #objs, 1, -1 do
		local o = objs[i]
		Msg("MeteorIntercepted", o)
		o:ExplodeInAir()
	end

	objs = g_IonStorms or ""
	for i = #objs, 1, -1 do
		objs[i]:delete()
		table_remove(g_IonStorms, i)
	end

  if g_RainDisaster then
		StopRainsDisaster()
  end

	-- make sure rains stop (remove this after an update or two)
  local rain_type = "toxic"
  local disaster_data = RainsDisasterThreads[rain_type]
  if not disaster_data then
    return
  end
  DeleteThread(disaster_data.soil_thread)
  DeleteThread(disaster_data.main_thread)
  DeleteThread(disaster_data.activation_thread)
  disaster_data.activation_thread = false
	FinishRainProcedure(rain_type)
end

function ChoGGi.ComFuncs.RetTableValue(obj, key)
	local meta = getmetatable(obj)
	if meta and meta.__index then
		-- some stuff like mod.env uses the metatable from _G.__index and causes sm to log an error (still works fine though)
		if type(key) == "string" then
			-- PropObjGetProperty works better on class funcs, but it can mess up on some tables so only use it for strings)
			return PropObjGetProperty(obj, key)
		else
			return rawget(obj, key)
		end
	else
		return obj[key]
	end
end

do -- BuildableHexGrid
	-- this is somewhat from Lua\hex.lua: debug_build_grid()
	-- sped up to work with being attached to the mouse pos
	local IsValid = IsValid
	local grid_objs = {}
	local grid_objs_c = 0
	local Temp = ChoGGi.Temp
	local OHexSpot, XText
	-- for uneven terrain in construction
	local shape_data = {
		point(-1, 0),
		point(-1, 1),
		point(0, -1),
		point(0, 0),
		point(0, 1),
		point(1, -1),
		point(1, 0),
	}
	local shape_data_c = #shape_data
	-- (self, shape_data, pos, angle)
	-- stripped down version of ConstructionController:IsTerrainFlatForPlacement
	local CalcBuildableGrid = CalcBuildableGrid
	local l_UnbuildableZ, l_g_BuildableZ
	local function IsTerrainNotFlatForPlacement(q_i, r_i)
		local original_z = false

		if not l_UnbuildableZ then
			l_UnbuildableZ = buildUnbuildableZ()
			l_g_BuildableZ = g_BuildableZ
			if not l_g_BuildableZ then
				CalcBuildableGrid()
				l_g_BuildableZ = g_BuildableZ
			end
		end

		for i = 1, shape_data_c do
			local q, r = shape_data[i]:xy()
			q, r = q_i+q, r_i+r

			local z = l_g_BuildableZ:get(q+r/2, r)
			if not original_z then
				original_z = z
			end
			if z == l_UnbuildableZ or z ~= original_z then
				return true
			end
		end
	end

	local function CleanUp()
		-- kill off thread
		if IsValidThread(Temp.grid_thread) then
			DeleteThread(Temp.grid_thread)
		end
		-- just in case
		Temp.grid_thread = false

		-- SuspendPassEdits errors out if there's no map
		if UICity then
			SuspendPassEdits("ChoGGi.ComFuncs.BuildableHexGrid_CleanUp")
			for i = 1, grid_objs_c do
				local o = grid_objs[i]
				if IsValid(o) then
					o:delete()
				end
			end
			ResumePassEdits("ChoGGi.ComFuncs.BuildableHexGrid_CleanUp")
			-- clear out xwin text
			local parent = terminal.desktop.ChoGGi_BuildableHexGrid
			if IsValidXWin(parent) then
				parent:Close()
			end
		end
--~ 		table_iclear(grid_objs)
	end

	-- If grid is left on when map changes it gets real laggy
	OnMsg.ChangeMap = CleanUp
	-- make sure grid isn't saved in persist
	OnMsg.SaveGame = CleanUp

	function ChoGGi.ComFuncs.BuildableHexGrid(action)
		local is_valid_thread = IsValidThread(Temp.grid_thread)

		local u = ChoGGi.UserSettings
		local grid_pos

		-- If not fired from action
		if IsKindOf(action, "XAction") then
			if action.setting_mask == "position" then
				grid_pos = type(u.DebugGridPosition) == "number" and u.DebugGridPosition or 0
			end
		else
			-- always start clean
			if is_valid_thread then
				CleanUp()
				is_valid_thread = false
			end
			-- If it's false then we don't want to start it again
			if action == false then
				return
			end
		end

		if not OHexSpot then
			OHexSpot = ChoGGi_OHexSpot
		end
		if not XText then
			XText = ChoGGi_XText_Follow
		end

		local grid_opacity = type(u.DebugGridOpacity) == "number" and u.DebugGridOpacity or 15
		local grid_size = type(u.DebugGridSize) == "number" and u.DebugGridSize or 25

--~ 		-- 125 = 47251 objects (had a crash at 250, and it's not like you need one that big)
--~ 		if grid_size > 256 then
--~ 			grid_size = 256
--~ 		end

		-- already running
		if is_valid_thread then
			CleanUp()
		else
			-- this loop section is just a way of building the table and applying the settings once instead of over n over in the while loop

			grid_objs_c = 0

			local parent = terminal.desktop
			if not IsValidXWin(parent.ChoGGi_BuildableHexGrid) then
				parent.ChoGGi_BuildableHexGrid = XWindow:new({
					Id = "ChoGGi_BuildableHexGrid",
				}, parent)
			end
			parent = parent.ChoGGi_BuildableHexGrid

			local q, r = 1, 1
			local z = -q - r
			SuspendPassEdits("ChoGGi.ComFuncs.BuildableHexGrid")
			local colour = RandomColourLimited()
			for q_i = q - grid_size, q + grid_size do
				for r_i = r - grid_size, r + grid_size do
					for z_i = z - grid_size, z + grid_size do
						if q_i + r_i + z_i == 0 then
							local hex = OHexSpot:new()
							hex:SetOpacity(grid_opacity)
--~ 							hex:SetNoDepthTest(true)

							grid_objs_c = grid_objs_c + 1
							grid_objs[grid_objs_c] = hex
							-- add text_obj
							if grid_pos then
								local text_obj = XText:new(nil, parent)
								text_obj:SetTextColor(colour)
								text_obj:FollowObj(hex)
								-- easy access
								hex.text_obj = text_obj
							end
						end
					end
				end
			end
			ResumePassEdits("ChoGGi.ComFuncs.BuildableHexGrid")

			-- off we go
			Temp.grid_thread = CreateRealTimeThread(function()
				-- local all the globals we use more than once for some speed
				CalcBuildableGrid()
				local g_BuildableZ = g_BuildableZ
				local UnbuildableZ = buildUnbuildableZ()

				local red = red
				local green = green
				local yellow = yellow
				local blue = blue

				local ObjectGrid = ObjectGrid
				local const_HexSize = const.HexSize

				local g_DontBuildHere = g_DontBuildHere

				local last_q, last_r
				-- 0, 0 to make sure it updates the first time
				local old_pt, pt = point(0, 0)

				while Temp.grid_thread do
					-- only update if cursor moved a hex
					pt = GetCursorOrGamePad()
					if old_pt:Dist2D(pt) > const_HexSize then
						old_pt = pt

						local q, r = WorldToHex(pt)
						if last_q ~= q or last_r ~= r then
							local z = -q - r
							local c = 0

							for q_i = q - grid_size, q + grid_size do
								for r_i = r - grid_size, r + grid_size do
									for z_i = z - grid_size, z + grid_size do
										if q_i + r_i + z_i == 0 then
											-- get next hex marker from list, and move it to pos
											c = c + 1
											local hex = grid_objs[c]
											local pos = point(HexToWorld(q_i, r_i))
											hex:SetPos(pos)

											-- green = pass/build, yellow = no pass/build, blue = pass/no build, red = no pass/no build

											local obj = HexGridGetObject(ObjectGrid, q_i, r_i)
											-- skip! (CameraObj, among others?)
											if obj and obj.GetEntity and obj:GetEntity() == "InvisibleObject" then
												obj = nil
											end
											-- showing position grid instead of buildable grid
											if grid_pos then
												if grid_pos == 0 then
													hex.text_obj:SetText((q_i-q) .. "," .. (r_i-r))
												else
													hex.text_obj:SetText(q_i .. "," .. r_i)
												end
											else
												-- geysers
												if obj == g_DontBuildHere then
													hex:SetColorModifier(blue)
												else
													-- returns UnbuildableZ if it isn't buildable
													local build_z = g_BuildableZ:get(q_i + r_i / 2, r_i)

													-- check adjacent hexes for height diff, and slopes over 1024? aren't passable (let alone buildable)
													if build_z == UnbuildableZ or IsTerrainNotFlatForPlacement(q_i, r_i) or HexSlope(q_i, r_i) > 1024 then
														hex:SetColorModifier(red)
													-- stuff that can be pathed? (or dump sites which IsPassable returns false for)
--~ 													obj:IsKindOf("WasteRockStockpileUngridedNoBlockPass") then
													elseif terrain_IsPassable(pos) or obj and obj.class == "WasteRockDumpSite" then
														if build_z ~= UnbuildableZ and not obj then
															hex:SetColorModifier(green)
														else
															hex:SetColorModifier(blue)
														end
													-- any objs left aren't passable
													elseif obj then
														hex:SetColorModifier(red)
													else
														hex:SetColorModifier(yellow)
													end
												end
											end

										end
									end -- z_i
								end -- r_i
							end -- q_i

							last_q = q
							last_r = r
						else
							WaitMsg("OnRender")
						end
					end -- pt ~= old_pt

					-- might as well make it smoother (and suck up some yummy cpu), i assume nobody is going to leave it on
					WaitMsg("OnRender")
				end -- while
			end) -- grid_thread
		end
	end
end

function ChoGGi.ComFuncs.SetWinObjectVis(obj,visible)
	-- XWindow:GetVisible()
	if obj.target_visible then
		-- It's visible and we don't want it visible
		if not visible then
			obj:SetVisible()
		end
	else
		-- It's not visible and we want it visible
		if visible then
			obj:SetVisible(true)
		end
	end
end

-- dbg_PlantRandomVegetation(choice.value) copy pasta
function ChoGGi.ComFuncs.PlantRandomVegetation(amount)
	SuspendPassEdits("ChoGGi.ComFuncs.PlantRandomVegetation")
	-- might help speed it up?
	SuspendTerrainInvalidations("ChoGGi.ComFuncs.PlantRandomVegetation")

  local presets = {}
  local presets_c = 0
  local veg_preset_lookup = veg_preset_lookup
  for i = 1, #veg_preset_lookup do
		local veg = veg_preset_lookup[i]
    if veg.group ~= "Lichen" and veg.group ~= "Vegetable" then
			presets_c = presets_c + 1
			presets[presets_c] = veg
    end
  end

	local HexToWorld = HexToWorld
	local DoesContainVegetation = DoesContainVegetation
	local CanVegGrowAt_C = rawget(_G,"Vegetation_CanVegetationGrowAt_C")
	local CanVegetationGrowAt = CanVegetationGrowAt
	local PlaceVegetation = PlaceVegetation

	local ObjectGrid = ObjectGrid
	local LandscapeGrid = LandscapeGrid
	local VegetationGrid = VegetationGrid
	local HexMapWidth = HexMapWidth
  local twidth, theight = terrain.GetMapSize()
  local total_elements = HexMapWidth * HexMapHeight

	-- stored placed
	local exists = {}

  amount = amount or 100
  for i = 1, amount do
    local idx = Random(99999999) % total_elements
    local x = idx % HexMapWidth
    local y = idx / HexMapWidth
		if not exists[x..y] then
			local q = x - y / 2
			local r = y
			local wx, wy = HexToWorld(q, r)
			if twidth > wx and theight > wy then
				local p = presets[Random(presets_c) + 1]
				local data = VegetationGrid:get(x, y)
				if not DoesContainVegetation(data)
						and CanVegGrowAt_C and CanVegGrowAt_C(ObjectGrid, LandscapeGrid, data, q, r)
						or CanVegetationGrowAt(data, q, r) then
					PlaceVegetation(q, r, p)
					exists[x..y] = true
				else
					i = i - 1
				end
			else
				i = i - 1
			end
		end
  end

	ResumePassEdits("ChoGGi.ComFuncs.PlantRandomVegetation")
	ResumeTerrainInvalidations("ChoGGi.ComFuncs.PlantRandomVegetation")
end

function ChoGGi.ComFuncs.GetDialogECM(class)
	local ChoGGi_dlgs_opened = ChoGGi_dlgs_opened
	for dlg in pairs(ChoGGi_dlgs_opened) do
		if dlg:IsKindOf(class) then
			return dlg
		end
	end
end

function ChoGGi.ComFuncs.CloseDialogsECM(skip)
	local desktop = terminal.desktop
	for i = #desktop, 1, -1 do
		local dlg = desktop[i]
		if dlg ~= skip and dlg:IsKindOf("ChoGGi_XWindow") then
			dlg:Close()
		end
	end
end

function ChoGGi.ComFuncs.SetLandScapingLimits(force, skip_objs, out_of_bounds)
	local cs = ConstructionStatus
	if force or ChoGGi.UserSettings.RemoveLandScapingLimits then
		cs.LandscapeTooLarge.type = "warning"
		cs.LandscapeUnavailable.type = "warning"
		cs.LandscapeLowTerrain.type = "warning"
		cs.LandscapeRampUnlinked.type = "warning"
		-- some people don't want it I suppose
		if not skip_objs then
			cs.BlockingObjects.type = "warning"
		end
		-- can cause crashing
		if testing or out_of_bounds then
			cs.LandscapeOutOfBounds.type = "warning"
		end
	else
		-- restore originals
		local orig_cs = ChoGGi.Tables.ConstructionStatus
		cs.LandscapeTooLarge.type = orig_cs.LandscapeTooLarge.type
		cs.LandscapeUnavailable.type = orig_cs.LandscapeUnavailable.type
		cs.LandscapeLowTerrain.type = orig_cs.LandscapeLowTerrain.type
		cs.BlockingObjects.type = orig_cs.BlockingObjects.type
		cs.LandscapeRampUnlinked.type = orig_cs.LandscapeRampUnlinked.type
		cs.LandscapeOutOfBounds.type = orig_cs.LandscapeOutOfBounds.type
	end
end

function ChoGGi.ComFuncs.SetBuildingLimits(force)
	local cs = ConstructionStatus
	if force or ChoGGi.UserSettings.RemoveBuildingLimits then
		for id, status in pairs(cs) do
			if id:sub(1, 9) ~= "Landscape" and status.type == "error" then
				status.type = "warning"
			end
		end
	else
		local orig_cs = ChoGGi.Tables.ConstructionStatus
		for id, status in pairs(cs) do
			if id:sub(1, 9) ~= "Landscape" and status.type == "warning" then
				cs[id].type = orig_cs[id].type
			end
		end
	end
end

-- bottom toolbar button in menus (new game, planetary, etc)
function ChoGGi.ComFuncs.RetToolbarButton(params)
	return XTextButton:new({
		Id = params.id,
		Text = params.text or T(126095410863, "Info"),
		FXMouseIn = "ActionButtonHover",
		FXPress = "ActionButtonClick",
		FXPressDisabled = "UIDisabledButtonPressed",
		HAlign = "center",
		Background = 0,
		FocusedBackground = 0,
		RolloverBackground = 0,
		PressedBackground = 0,
		RolloverZoom = 1100,
		TextStyle = params.text_style or "Action",
		MouseCursor = "UI/Cursors/Rollover.tga",
		RolloverTemplate = "Rollover",
		RolloverTitle = params.roll_title,
		RolloverText = params.roll_text,
		OnPress = params.onpress,
	}, params.parent)
end

-- save a game with attachments (res cubes in storage depots) that have an origin point above 65535 and goodbye save game.
function ChoGGi.ComFuncs.IsAttachAboveHeightLimit(obj)
	-- we only want to check attachments
	if not obj:GetParent() then
		return
	end

	if obj:GetZ() + obj:GetAttachOffset():z() > 65535 then
		return true
	end
end

function ChoGGi.ComFuncs.GetShortcut(id)
	if not id then
		return ""
	end
	-- just in case I change it or something
	id = "ECM" .. id

	local keys = GetShortcuts(id)
	if keys then
		return keys[1]
	end
	return ""
end

do -- CleanInfoAttachDupes
	local DoneObject = DoneObject
	local dupe_list = {}

	function ChoGGi.ComFuncs.CleanInfoAttachDupes(list, cls)
		table_clear(dupe_list)
		SuspendPassEdits("ChoGGi.ComFuncs.CleanInfoAttachDupes")

		-- clean up dupes in order of older
		for i = 1, #list do
			local mark = list[i]
			if not cls or cls and mark:IsKindOf(cls) then

				local pos = tostring(mark:GetPos())
				local dupe = dupe_list[pos]
				if dupe then
					DoneObject(dupe)
				else
					dupe_list[pos] = mark
				end

			end
		end

		-- remove removed items
		list:Validate()
		ResumePassEdits("ChoGGi.ComFuncs.CleanInfoAttachDupes")
	end
	function ChoGGi.ComFuncs.CleanInfoXwinDupes(list, cls)
		table_clear(dupe_list)

		-- clean up dupes in order of older
		for i = #list, 1, -1 do
			local mark = list[i]
			if not cls or cls and mark:IsKindOf(cls) then

				local pos = tostring(mark.FindModifier and mark:FindModifier("follow_obj").target:GetPos())
				if pos then
					local dupe = dupe_list[pos]
					if dupe then
						dupe:Close()
					else
						dupe_list[pos] = mark
					end
				end

			end
		end
	end
end -- do

do -- ObjHexShape_Toggle
	local HexRotate = HexRotate
	local HexToWorld = HexToWorld
	local point = point

	local OHexSpot, XText
	local parent
	local FallbackOutline = FallbackOutline

	-- function Dome:GenerateWalkablePoints() (mostly)
	local function BuildShape(obj, shape, depth_test, hex_pos, colour1, colour2, offset)
		local dir = HexAngleToDirection(obj:GetAngle())
		local cq, cr = WorldToHex(obj)

		local c = #obj.ChoGGi_shape_obj
		for i = 1, #shape do
			local sq, sr = shape[i]:xy()
			local q, r = HexRotate(sq, sr, dir)
			local pt = point(HexToWorld(cq + q, cr + r)):SetTerrainZ(offset)

			local hex = OHexSpot:new()
			hex:SetOpacity(25)
			hex:SetPos(pt)

			if colour1 then
				hex:SetColorModifier(colour1)
			end

			-- wall hax off
			if not depth_test then
				hex:SetNoDepthTest(true)
			end

			-- pos text
			if hex_pos then
				local text_obj = XText:new(nil, parent)
				if colour2 then
					text_obj:SetTextColor(colour2)
				end
				text_obj:FollowObj(hex)

				-- easy access
				hex.text_obj = text_obj
				text_obj:SetText(sq .. "," .. sr)
			end

			c = c + 1
			obj.ChoGGi_shape_obj[c] = hex
		end
	end

	local function ObjHexShape_Clear(obj)
		if type(obj) ~= "table" then
			return
		end
		SuspendPassEdits("ChoGGi.ComFuncs.ObjHexShape_Clear")
		if obj.ChoGGi_shape_obj then
			obj.ChoGGi_shape_obj:Destroy()
			obj.ChoGGi_shape_obj = nil
			if IsValidXWin(obj.ChoGGi_shape_obj_xwin) then
				obj.ChoGGi_shape_obj_xwin:Close()
				obj.ChoGGi_shape_obj_xwin = nil
			end
			return true
		end
		ResumePassEdits("ChoGGi.ComFuncs.ObjHexShape_Clear")
	end
	ChoGGi.ComFuncs.ObjHexShape_Clear = ObjHexShape_Clear

	function ChoGGi.ComFuncs.ObjHexShape_Toggle(obj, params)
		params = params or {shape = FallbackOutline}
		if not IsValid(obj) or not params.skip_return then
			return
		end
		if not params.skip_clear then
			if (ObjHexShape_Clear(obj) and not params.skip_return) then
				return
			end
		end

		obj.ChoGGi_shape_obj = obj.ChoGGi_shape_obj or objlist:new()
		params.colour1 = params.colour1 or RandomColourLimited()
		params.colour2 = params.colour2 or RandomColourLimited()
		params.offset = params.offset or 1

		if not OHexSpot then
			OHexSpot = ChoGGi_OHexSpot
		end
		if not XText then
			XText = ChoGGi_XText_Follow
		end

		if not IsValidXWin(obj.ChoGGi_shape_obj_xwin) then
			local parent = terminal.desktop
			local id = "ChoGGi_ObjHexShape_Toggle" .. obj.handle
			parent[id] = XWindow:new({Id = id}, parent)
			obj.ChoGGi_shape_obj_xwin = parent[id]
		end
		parent = obj.ChoGGi_shape_obj_xwin

		SuspendPassEdits("ChoGGi.ComFuncs.ObjHexShape_Toggle")
		BuildShape(
			obj,
			params.shape,
			params.depth_test,
			params.hex_pos,
			params.colour1,
			params.colour2,
			params.offset
		)
		ResumePassEdits("ChoGGi.ComFuncs.ObjHexShape_Toggle")
		if not params.skip_clear then
			ChoGGi.ComFuncs.CleanInfoXwinDupes(obj.ChoGGi_shape_obj_xwin)
			ChoGGi.ComFuncs.CleanInfoAttachDupes(obj.ChoGGi_shape_obj, "ChoGGi_OHexSpot")
		end

		return obj.ChoGGi_shape_obj
	end
end -- do

function ChoGGi.ComFuncs.ModEditorActive()
	local m = mapdata
	-- you can save the mod map and play it, so we also check for other stuff
	if m.id == "Mod" and m.markers and m.NetHash then
		return true
	end
end

function ChoGGi.ComFuncs.UpdateDepotCapacity(obj, max_store, storable)
	max_store = max_store or obj.max_storage_per_resource
	storable = storable or obj.storable_resources

	for i = 1, #storable do
		local resource_name = storable[i]
		local demand = obj.demand
		if demand and demand[resource_name] then
			demand[resource_name]:SetAmount(0)
			demand[resource_name]:SetAmount(max_store)
		end
	end
end

function ChoGGi.ComFuncs.GetModEnabled(mod_id)
	return table_find(ModsLoaded, "id", mod_id)
end

function ChoGGi.ComFuncs.SetBuildingTemplates(template, key, value)
	BuildingTemplates[template][key] = value
	ClassTemplates.Building[template][key] = value
end

function ChoGGi.ComFuncs.ReplaceClassFunc(class, func_name, func_to_call)
	-- ClassDescendantsList("BaseRover")
	class = ClassDescendantsList(class)
	local g = _G
	-- shouldn't be any dupes?
	local orig_funcs = {}
	for i = 1, #class do
		-- get cls obj and backup the func we're hitchhiking on
		local cls_obj = g[class[i]]
		local orig_func = cls_obj[func_name]
		if not orig_funcs[orig_func] then
			orig_funcs[orig_func] = true
			-- actual func override
			cls_obj[func_name] = function(self, ...)
				-- return your func being called and send it the backuped func
				return func_to_call(orig_func, self, ...)
			end
		end
	end
end

do -- path markers
	local path_classes = {"Movable", "CargoShuttle"}
	local randcolours = {}
	local colourcount = 0
	local dupewppos = {}
	-- default height of waypoints (maybe flag_height isn't the best name as i stopped using them)
	local flag_height = 50
	local OPolyline

	local function ShowWaypoints(waypoints, colour, obj, skip_height, obj_pos)
		colour = tonumber(colour) or RandomColourLimited()
		-- also used for line height
		if not skip_height then
			flag_height = flag_height + 4
		end

		obj_pos = obj_pos or obj:GetVisualPos()
		local obj_terrain = terrain_GetHeight(obj_pos) or 0
		local obj_height = (obj:GetObjectBBox():sizez() / 2) or 0
		if obj:IsKindOf("CargoShuttle") then
			obj_height = obj_pos:z() - obj_terrain
		end

		-- some objects don't have pos as waypoint
		local wp_c = #waypoints
		if waypoints[wp_c] ~= obj_pos then
			wp_c = wp_c + 1
			waypoints[wp_c] = obj_pos
		end

		-- build a list of points that aren't high in the sky
		for i = 1, wp_c do
			local wp = waypoints[i]
			local z = wp:z()
			if not z or z and z < obj_terrain then
				waypoints[i] = wp:SetTerrainZ(obj_height + flag_height)
			end
		end
		-- and spawn the line
		local spawnline = OPolyline:new()
		spawnline:SetMesh(waypoints, colour)
		spawnline:SetPos(AveragePoint2D(waypoints))

		obj.ChoGGi_Stored_Waypoints[#obj.ChoGGi_Stored_Waypoints+1] = spawnline
	end -- end of ShowWaypoints

	local function SetWaypoint(obj, setcolour, skip_height)
		local path = {}

		-- we need to build a path for shuttles (and figure out a way to get their dest properly...)
		local is_shuttle = obj:IsKindOf("CargoShuttle")
		if is_shuttle then

			-- going to pickup colonist
			if obj.command == "GoHome" then
				path[1] = obj.hub:GetPos()
			elseif obj.command == "Transport" then
				-- 2 is pickup loc, 3 is drop off
				path[1] = obj.transport_task and ((obj.transport_task[2] and obj.transport_task[2]:GetBuilding():GetPos()) or (obj.transport_task[3] and obj.transport_task[3]:GetBuilding():GetPos()))
			elseif obj.is_colonist_transport_task then
				path[1] = obj.transport_task and (obj.transport_task.dest_pos or obj.transport_task.colonist:GetPos())
			else
				path[1] = obj:GetDestination()
			end

			-- jumper shuttles after first leg
			if type(path[1]) ~= "userdata" then
				path[1] = obj:GetDestination()
			end

			local c = #path

			-- the next four points it's going to after current_spline
			if type(obj.next_spline) == "table" then
				for i = 1, #obj.next_spline do
					c = c + 1
					path[c] = obj.next_spline[i]
				end
			end

			-- where the line starts
			c = c + 1
			path[c] = obj:GetPos()

		else
			-- rovers/drones/colonists
			if obj.GetPath then
				path = obj:GetPath()
			else
				ChoGGi.ComFuncs.OpenInExamineDlg(obj, nil, Strings[302535920000467--[[Path Markers]]])
				print(Translate(6779--[[Warning]]), ":", Strings[302535920000869--[[This %s doesn't have GetPath function, something is probably borked.]]]:format(RetName(obj)))
			end
		end

		-- we have a path so add some colours, and build the waypoints
		if path then
			local colour
			if setcolour then
				colour = setcolour
			else
				if #randcolours < 1 then
					colour = RandomColourLimited()
				else
					-- we want to make sure all grouped waypoints are a different colour (or at least slightly diff)
					colour = randcolours[#randcolours]
					randcolours[#randcolours] = nil
					-- table.remove(t) removes and returns the last value of the table
				end
			end

			if not IsObjlist(obj.ChoGGi_Stored_Waypoints) then
				obj.ChoGGi_Stored_Waypoints = objlist:new()
			end

			if not obj.ChoGGi_WaypointPathAdded then
				-- used to reset the colour later on
				obj.ChoGGi_WaypointPathAdded = obj:GetColorModifier()
				obj.ChoGGi_WaypointPathAdded_storedcolour = colour
			end

			-- colour it up
			obj:SetColorModifier(obj.ChoGGi_WaypointPathAdded_storedcolour or colour)

			-- and lastly make sure path is sorted correctly
			-- end is where the obj is, and start is where the dest is
			if is_shuttle then
				table_sort(path, function(a, b)
					return obj:GetVisualDist2D(a) > obj:GetVisualDist2D(b)
				end)
			end

			-- send path off to make wp
			ShowWaypoints(
				path,
				colour,
				obj,
				skip_height,
				obj.GetVisualPos and obj:GetVisualPos() or obj:GetPos()
			)
		end
	end
	ChoGGi.ComFuncs.SetWaypoint = SetWaypoint

	local function SetPathMarkersGameTime_Thread(obj, handles, delay)
		local colour = RandomColourLimited()
		if not IsObjlist(obj.ChoGGi_Stored_Waypoints) then
			obj.ChoGGi_Stored_Waypoints = objlist:new()
		end

		while handles[obj.handle] do
			SuspendPassEdits("ChoGGi.ComFuncs.SetPathMarkersGameTime_Thread")
			SetWaypoint(obj, colour, true)
			ResumePassEdits("ChoGGi.ComFuncs.SetPathMarkersGameTime_Thread")
			if delay == 0 or delay == -1 then
				-- If we only do one then it'll be invis unless paused
				-- 2+ is too much ficker
				WaitMsg("OnRender")
				WaitMsg("OnRender")
				-- If you like bears then you'd figure the third is just right... ah well twofer
			else
				Sleep(delay)
			end

			if obj.ChoGGi_Stored_Waypoints then
				SuspendPassEdits("ChoGGi.ComFuncs.SetPathMarkersGameTime_Thread")
				-- deletes all wp objs
				obj.ChoGGi_Stored_Waypoints:Destroy()
				-- clears table list
				obj.ChoGGi_Stored_Waypoints:Clear()
				ResumePassEdits("ChoGGi.ComFuncs.SetPathMarkersGameTime_Thread")
			end

			-- break thread when obj isn't valid
			if not IsValid(obj) then
				handles[obj.handle] = nil
				break
			end
		end
	end

	local function AddObjToGameTimeMarkers(obj, handles, delay, skip)
		if skip or obj:IsKindOfClasses(path_classes) then

			if handles[obj.handle] then
				-- already exists so remove thread
				handles[obj.handle] = nil
			elseif IsValid(obj) then
				-- continous loooop of object for pathing it
				handles[obj.handle] = CreateGameTimeThread(SetPathMarkersGameTime_Thread, obj, handles, delay)
			end
		end
	end

	local function SetPathMarkersGameTime(obj, menu_fired, menu_delay)
		if not OPolyline then
			OPolyline = ChoGGi_OPolyline
		end

		local delay = 500
		-- If fired from action menu (or shortcut)
		if IsKindOf(obj, "XAction") then
			obj = SelectedObj or SelObjects(1500)
			menu_fired = true
		else
			obj = obj or SelectedObj or SelObjects(1500)
			delay = type(menu_delay) == "number" and menu_delay or delay
		end
		if obj and obj.objects then
			obj = obj.objects
		end
		if not next(obj) then
			obj = nil
		end

		if obj then
			local handles = ChoGGi.Temp.UnitPathingHandles or {}
			if #obj == 1 then
				-- single obj
				obj = obj[1]
 			elseif obj[2] then
				-- multiselect
				for i = 1, #obj do
					AddObjToGameTimeMarkers(obj[i], handles, delay)
				end
				return
			end
			-- single not in a table list (true because we already checked the kindof)
			if obj:IsKindOfClasses(path_classes) then
				return AddObjToGameTimeMarkers(obj, handles, delay, true)
			end
		end

		if menu_fired then
			MsgPopup(
				Strings[302535920000871--[[Doesn't seem to be an object that moves.]]],
				Strings[302535920000872--[[Pathing]]],
				{objects = obj}
			)
		end
	end
	ChoGGi.ComFuncs.SetPathMarkersGameTime = SetPathMarkersGameTime

	local function RemoveWPDupePos(cls, obj)
		if not IsObjlist(obj.ChoGGi_Stored_Waypoints) then
			return
		end

		-- remove dupe pos
		for i = 1, #obj.ChoGGi_Stored_Waypoints do
			local wp = obj.ChoGGi_Stored_Waypoints[i]

			if wp.class == cls then
				local pos = tostring(wp:GetPos())
				if dupewppos[pos] then
					dupewppos[pos]:SetColorModifier(6579300)
					wp:delete()
				else
					dupewppos[pos] = wp
				end
			end
		end
		-- remove removed
		obj.ChoGGi_Stored_Waypoints:Validate()
	end

	local function ClearColourAndWP(cls, skip)
		-- remove all thread refs so they stop
		table_clear(ChoGGi.Temp.UnitPathingHandles or empty_table)
		-- and waypoints/colour
		local objs = MapGet_ChoGGi(cls)
		for i = 1, #objs do
			local obj = objs[i]

			if not skip and obj.ChoGGi_WaypointPathAdded then
				obj:SetColorModifier(obj.ChoGGi_WaypointPathAdded)
				obj.ChoGGi_WaypointPathAdded = nil
				obj.ChoGGi_WaypointPathAdded_storedcolour = nil
			end

			local stored = obj.ChoGGi_Stored_Waypoints
			if IsObjlist(stored) then
				-- deletes all objs
				stored:Destroy()
				-- clears table list
				stored:Clear()
			end
			-- remove ref
			obj.ChoGGi_Stored_Waypoints = nil

		end
	end

	-- remove any waypoints in the same pos
	local function ClearAllDupeWP(cls)
		local objs = MapGet_ChoGGi(cls)
		for i = 1, #objs do
			local obj = objs[i]
			if obj and obj.ChoGGi_Stored_Waypoints then
				RemoveWPDupePos("WayPoint", obj)
				RemoveWPDupePos("Sphere", obj)
			end
		end
	end
	local function CleanDupes()
		SuspendPassEdits("ChoGGi.ComFuncs.Pathing_CleanDupes")
		ClearAllDupeWP("CargoShuttle")
		ClearAllDupeWP("Unit")
		ClearAllDupeWP("Colonist")
		ResumePassEdits("ChoGGi.ComFuncs.Pathing_CleanDupes")
	end
	ChoGGi.ComFuncs.Pathing_CleanDupes = CleanDupes

	local function StopAndRemoveAll(skip)
		if not skip then
			ChoGGi.Temp.PathMarkers_new_objs_loop = false
		end
		SuspendPassEdits("ChoGGi.ComFuncs.Pathing_StopAndRemoveAll")

		-- reset all the base colours/waypoints
		ClearColourAndWP("CargoShuttle", skip)
		ClearColourAndWP("Unit", skip)
		ClearColourAndWP("Colonist", skip)
		-- and pets for Unit Thoughts (seems they're not "Unit"y enough)
--~ 		ClearColourAndWP("BasePet", skip)
		if #MapGet_ChoGGi("ChoGGi_Alien") > 0 then
			ClearColourAndWP("ChoGGi_Alien", skip)
		end

		-- remove any extra lines
		ChoGGi.ComFuncs.RemoveObjs("ChoGGi_OPolyline")

		ResumePassEdits("ChoGGi.ComFuncs.Pathing_StopAndRemoveAll")

		-- reset stuff
		flag_height = 50
		randcolours = {}
		colourcount = 0
		dupewppos = {}
	end
	ChoGGi.ComFuncs.Pathing_StopAndRemoveAll = StopAndRemoveAll

	local function SetMarkers(list, check, delay)
		if check then
			for i = 1, #list do
				SetPathMarkersGameTime(list[i], nil, delay)
			end
		else
			for i = 1, #list do
				SetWaypoint(list[i])
			end
		end
	end
	ChoGGi.ComFuncs.Pathing_SetMarkers = SetMarkers

end -- do

-- Drone:GetTarget()
function ChoGGi.ComFuncs.GetTarget(obj)
	local target = obj.target or obj.goto_target
	local text

	local is_point = IsPoint(target)
	if is_point or (type(target) == "table" and target[1]) then
		local q, r
		if is_point then
			q, r = WorldToHex(target)
		else
			-- when goto_target is a table (last one is dest)
			q, r = WorldToHex(target[#target])
		end

		text = q .. ", " .. r
	else
		while IsValid(target) and target:HasMember("parent") and target.parent and target.parent ~= target do
			target = target.parent
		end
		if target ~= false then
			text = RetName(target)
		end
	end

	if text then
		return "(" .. text .. ")"
	end
end

function ChoGGi.ComFuncs.GetNearestObj(obj, list)
	local obj_pos = obj:GetVisualPos()

	-- get nearest
	local length = max_int
	local nearest = list[1]
	local new_length, spot
	for i = 1, #list do
		spot = list[i]
		new_length = spot:GetVisualPos():Dist2D(obj_pos)
		if new_length < length then
			length = new_length
			nearest = spot
		end
	end

	-- and done
	return nearest
end

--~ ChoGGi.ComFuncs.MapDelete("ShuttleHub")
function ChoGGi.ComFuncs.MapDelete(class)
	SuspendPassEdits("ChoGGi.ComFuncs.MapDelete")
	local objs = UICity.labels[class] or ""
	if #objs > 0 then
		for i = #objs, 1, -1 do
			DeleteObject(objs[i])
		end
	elseif IsKindOf(g_Classes[class], "CObject") then
		-- If it isn't in g_Classes and isn't a CObject then MapGet will return *everything*
		MapDelete(true, class)
	end

	ResumePassEdits("ChoGGi.ComFuncs.MapDelete")
end

function ChoGGi.ComFuncs.ReloadLua()
	if not ModsLoaded then
		return
	end
	-- get list of enabled mods
	local enabled = table.icopy(ModsLoaded)
	-- turn off all mods
	AllModsOff()
	-- re-enable ecm/lib (or we get black screen of nadda)
	TurnModOn(ChoGGi.id)
	TurnModOn(ChoGGi.id_lib)
	-- reload lua code
	ModsReloadItems()
	-- enable disabled mods
	for i = 1, #enabled do
		TurnModOn(enabled[i].id)
	end
	-- reload lua code
	ModsReloadItems()
end

-- needs an indexed list or a label
function ChoGGi.ComFuncs.CycleSelectedObjects(list, count)
	if not count then
		list = UICity.labels[list] or empty_table
		count = #list
	end

	if list and count > 0 then
		local idx = SelectedObj and table_find(list, SelectedObj) or 0
		idx = (idx % count) + 1
		local next_obj = list[idx]

		ViewAndSelectObject(next_obj)
		XDestroyRolloverWindow()
	end
end

do -- IsDroneIdle/GetIdleDrones/DroneHubLoad
	local idle_drone_cmds = {
		Idle = true,
		-- fresh drone (only lasts a little bit)
		Start = true,
		-- go back to controller
		GoHome = true,
		-- doesn't have a controller
		WaitingCommand = true,
	}
	local DroneLoadLowThreshold = const.DroneLoadLowThreshold
	local DroneLoadMediumThreshold = const.DroneLoadMediumThreshold
	local DroneLoadExtra = DroneLoadMediumThreshold * 100

	function ChoGGi.ComFuncs.IsDroneIdle(drone)
		return idle_drone_cmds[drone.command]
	end
	local function IsDroneIdle(_, drone)
		return idle_drone_cmds[drone.command]
	end
	local function IsDroneWorking(_, drone)
		return not drone:IsDisabled()
	end
	function ChoGGi.ComFuncs.GetIdleDrones()
		return table_ifilter(table_icopy(UICity.labels.Drone or empty_table), IsDroneIdle)
	end

	-- -1 = borked, 0 = low, 1 = medium, 2 = high, empty = 3
	-- higher the laptime the more load (use order = true to return lap_time first)
	function ChoGGi.ComFuncs.DroneHubLoad(hub, order)
		local drone_load = -1
		local lap_time = -1
		if hub.working then
			-- no working drones / empty hub
			local drones = hub.drones
			if #drones == 0 or #table_ifilter(drones, IsDroneWorking) < 1 then
				drone_load = 3
				lap_time = DroneLoadExtra
			else
				lap_time = Max(hub.lap_time, GameTime() - hub.lap_start)
--~ 				local lap_time = hub:CalcLapTime()
				if lap_time < DroneLoadLowThreshold then
					drone_load = 0
				elseif lap_time < DroneLoadMediumThreshold then
					drone_load = 1
				else
					drone_load = 2
				end
			end
		end
		if order then
			return lap_time, drone_load
		end
		return drone_load, lap_time
	end
end

function ChoGGi.ComFuncs.PlacePolyline(points, colours, set_default_pos)
	local line = ChoGGi_OPolyline:new{
		max_vertices = #points
	}
	line:SetMesh(points, colours)
	-- objects spawn off-map
	if set_default_pos then
		line:SetPos(AveragePoint2D(line.vertices))
	end
	return line
end

-- https://gist.github.com/Uradamus/10323382
function ChoGGi.ComFuncs.FisherYates_Shuffle(list, min)
	-- I don't think there's any 0 based tables in SM, but just in case
	if not min then
		min = 1
	end
  for i = #list, 2, -1 do
    local j = Random(min, i)
    list[i], list[j] = list[j], list[i]
  end
end
do -- RGBtoColour
	local values = {}
	local c = 0

	-- input as text "0,0,0"
	function ChoGGi.ComFuncs.RGBtoColour(text)
		-- remove any spaces/newlines etc
		text = text:gsub("[%s%c]", "")
		-- grab the values
		values = {}
		c = 0

		-- loop through all the numbers
		for d in text:gmatch("%d+") do
			c = c + 1
			values[c] = tonumber(d)
		end

		local colour, obj_type = RetProperType(RGB(values[1], values[2], values[3]))
		if obj_type == "number" then
			return colour
		else
			-- fallback
			return 0
		end
	end
end

function ChoGGi.ComFuncs.ResetHumanCentipedes()
	local objs = UICity.labels.Colonist or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- only need to do people walking outside (pathing issue), and if they don't have a path (not moving or walking into an invis wall)
		if obj:IsValidPos() and not obj:GetPath() then
			-- too close and they keep doing the human centipede
			obj:SetCommand("Goto",
				GetPassablePointNearby(obj:GetVisualPos()+point(Random(-1000, 1000), Random(-1000, 1000)))
			)
		end
	end
end

function ChoGGi.ComFuncs.ToggleBreadcrumbs(obj)
	if not IsValid(obj) then
		print("ToggleBreadcrumbs Not valid:", obj)
		return
	end

	if IsValidThread(obj.ChoGGi_breadcrumbThread) then
		DeleteThread(obj.ChoGGi_breadcrumbThread)
		obj.ChoGGi_breadcrumbThread = nil
		return
	end

	obj.ChoGGi_breadcrumbThread = CreateGameTimeThread(function()
		local colour = RandomColourLimited()
		local last_pos
		while true do
			local pos = obj:GetVisualPos()
			if tostring(last_pos) ~= tostring(pos) then
				Sphere(pos, colour, 15000)
				last_pos = pos
			end
			Sleep(1500)
		end
	end)
end

--

-- bugged
--~ function ChoGGi.ComFuncs.SendDroneToCC(drone, new_hub)
--~ 	local old_hub = drone.command_center
--~ 	if old_hub == new_hub then
--~ 		return
--~ 	end
--~ 	-- ultra valid
--~ 	if IsValid(old_hub) and IsValid(new_hub) and IsValid(drone)
--~ 	-- if drone dist to new hub is further than dist to old hub than pack and unpack, otherwise SetCommandCenter() to drive over
--~ 		and drone:GetDist(old_hub) < drone:GetDist(new_hub)
--~ 	then
--~ 		-- DroneControl:ConvertDroneToPrefab()
--~ 		if drone.demolishing then
--~ 			drone:ToggleDemolish()
--~ 		end
--~ 		drone.can_demolish = false
--~ 		UICity.drone_prefabs = UICity.drone_prefabs + 1
--~ 		table.remove_entry(old_hub.drones, drone)
--~ 		SelectionArrowRemove(drone)
--~ 		drone:SetCommand("DespawnAtHub")

--~ 		-- wait till drone is sucked up
--~ 		while IsValid(drone) do
--~ 			Sleep(1000)
--~ 		end
--~ 		-- spawn drone from prefab at new hub
--~ 		if UICity.drone_prefabs > 0 then
--~ 			new_hub:UseDronePrefab()
--~ 		end
--~ 	else
--~ 		-- close enough to drive
--~ 		drone:SetCommandCenter(hub)
--~ 	end
--~ end
