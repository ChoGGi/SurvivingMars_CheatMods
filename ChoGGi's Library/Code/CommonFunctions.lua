-- See LICENSE for terms

local S = ChoGGi.Strings
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

local AsyncRand = AsyncRand
local IsValid = IsValid
local GetTerrainCursor = GetTerrainCursor
local FilterObjectsC = FilterObjectsC
local StringFormat = string.format
local TableRemove = table.remove
local TableFind = table.find

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

-- changes a function to also post a Msg for use with OnMsg
function ChoGGi.ComFuncs.AddMsgToFunc(class_name,func_name,msg_str,...)
	-- anything i want to pass onto the msg
	local varargs = ...
	-- save orig
	ChoGGi.ComFuncs.SaveOrigFunc(class_name,func_name)
	-- local stuff
	local StringFormat = StringFormat
	local select = select
	local Msg = Msg
	-- we want to local this after SaveOrigFunc just in case
	local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
	-- redefine it
	_G[class_name][func_name] = function(...)
		-- I just care about adding self to the msgs
		Msg(msg_str,select(1,...),varargs)

--~ 		-- use to debug if getting an error
--~ 		local params = {...}
--~ 		-- pass on args to orig func
--~ 		if not pcall(function()
--~ 			return ChoGGi_OrigFuncs[StringFormat("%s_%s",class_name,func_name)](table.unpack(params))
--~ 		end) then
--~ 			print("Function Error: ",StringFormat("%s_%s",class_name,func_name))
--~ 			ChoGGi.ComFuncs.OpenInExamineDlg{params}
--~ 		end

		return ChoGGi_OrigFuncs[StringFormat("%s_%s",class_name,func_name)](...)
	end
end

do -- Translate
	local T,_InternalTranslate = T,_InternalTranslate
	local type,select = type,select
	local StringFormat = StringFormat
	-- translate func that always returns a string
	function ChoGGi.ComFuncs.Translate(...)
		local str
		local stype = type(select(1,...))
		if stype == "userdata" or stype == "number" then
			str = _InternalTranslate(T{...})
		else
			str = _InternalTranslate(...)
		end
		-- just in case a
		if type(str) ~= "string" then
			local arg2 = select(2,...)
			if type(arg2) == "string" then
				return arg2
			end
			-- done fucked up (just in case b)
			return StringFormat("%s < Missing locale string id",...)
		end
		-- and done
		return str
	end
end -- do
local Trans = ChoGGi.ComFuncs.Translate

do -- CheckText
	-- check if text is already translated or needs to be, and return the text
	local type = type
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
		if ret:find("Missing locale string id") then
			ret = tostring(fallback or text)
		end
		-- have at it
		return ret
	end
end -- do
local CheckText = ChoGGi.ComFuncs.CheckText

do -- RetName
	local IsObjlist,type,tostring = IsObjlist,type,tostring
	-- try to return a decent name for the obj, failing that return a string
	function ChoGGi.ComFuncs.RetName(obj)
		if type(obj) == "table" then

			local name_type = type(obj.name)
			-- custom name from user (probably)
			if name_type == "string" and obj.name ~= "" then
				return obj.name
			-- colonist names
			elseif name_type == "table" and #obj.name == 3 then
				return StringFormat("%s %s",Trans(obj.name[1]),Trans(obj.name[3]))

			-- translated name
			elseif obj.display_name and obj.display_name ~= "" then
				return Trans(obj.display_name)

			-- encyclopedia_id
			elseif obj.encyclopedia_id and obj.encyclopedia_id ~= "" then
				return obj.encyclopedia_id
			-- plain old id
			elseif obj.id and obj.id ~= "" then
				return obj.id
			elseif obj.Id and obj.Id ~= "" then
				return obj.Id

			-- class template name
			elseif obj.template_name and obj.template_name ~= "" then
				return obj.template_name
			-- class
			elseif obj.class and obj.class ~= "" then
				return obj.class

			-- added this here as doing tostring lags the shit outta kansas if this is a large objlist (could also be from just having a large string for something?)
			elseif IsObjlist(obj) then
				return "objlist"
			end

		end

		-- falling back baby
		return tostring(obj)
--~ 		-- limit length of string in case it's a large one?
--~ 		return tostring(obj):sub(1,150)
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
function ChoGGi.ComFuncs.DotNameToObject(str,root,create)
	-- there's always one
	if str == "_G" then
		return _G
	end
	-- always start with _G
	local obj = root or _G
	-- https://www.lua.org/pil/14.1.html
	for name,match in str:gmatch("([%w_]+)(.?)") do
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
	local ChoGGi = ChoGGi
	if not ChoGGi.Temp.MsgPopups then
		ChoGGi.Temp.MsgPopups = {}
	end
	local g_Classes = g_Classes
	-- build our popup
	local timeout = 10000
	if size then
		timeout = 30000
	end
	local params = {
		expiration = timeout,
--~		 {expiration = max_int},
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
		image = type(tostring(icon):find(".tga")) == "number" and icon or StringFormat("%sUI/TheIncal.png",ChoGGi.LibraryPath)
	}
	table.set_defaults(data, params)
	table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
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
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, params.cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
		ChoGGi.Temp.MsgPopups[#ChoGGi.Temp.MsgPopups+1] = popup

		-- large amount of text option (four long lines o' text, or is it five?)
		if size then
			--larger text limit
			popup.idText.Margins = box(0,0,0,-500)
			--resize title, or move it?
			popup.idTitle.Margins = box(0,-20,0,0)
			--check if this is doing something
			Sleep(0)
			--size/pos of background image
			popup[1].scale = point(2800,2600)
			popup[1].Margins = box(-5,-30,0,-5)
			--update dialog size
			popup:InvalidateMeasure()
			--i don't care for sounds
--~			 if type(params.fx_action) == "string" and params.fx_action ~= "" then
--~				 PlayFX(params.fx_action)
--~			 end
		end
	end)
end
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

do -- ShowMe
	local IsPoint = IsPoint
	local green = green
	local guic = guic
	local IsPointInBounds = terrain.IsPointInBounds
	local ViewObjectMars = ViewObjectMars

	local markers = {}
	function ChoGGi.ComFuncs.ClearShowMe()
		-- some markers have been added
		if next(markers) then
			for k, v in pairs(markers) do
				if IsValid(k) then
					if v == "point" or v == "vector" then
						k:delete()
					else
						k:SetColorModifier(v)
					end
					markers[k] = nil
				end
			end
		-- could be from a saved game so remove any objects on the map
		else
			SuspendPassEdits("ChoGGi_Vector")
			SuspendPassEdits("ChoGGi_Sphere")
			MapDelete("map", "ChoGGi_Vector")
			MapDelete("map", "ChoGGi_Sphere")
			ResumePassEdits("ChoGGi_Vector")
			ResumePassEdits("ChoGGi_Sphere")
		end
	end

	local clear = ChoGGi.ComFuncs.ClearShowMe
	function ChoGGi.ComFuncs.ShowMe(o, color, time, both)
		if not o then
			return clear()
		end
		local g_Classes = g_Classes
		color = color or green

		if type(o) == "table" and #o == 2 then
			if IsPoint(o[1]) and IsPointInBounds(o[1]) and IsPoint(o[2]) and IsPointInBounds(o[2]) then
				local m = g_Classes.ChoGGi_Vector:new()
				m:Set(o[1], o[2], color)
				markers[m] = "vector"
				o = m
			end
		else
			-- both is for objs i also want a sphere over
			if IsPoint(o) or both then
				local o2 = IsPoint(o) and o or IsValid(o) and o:GetVisualPos()
				if o2 and IsPointInBounds(o2) then
					local m = g_Classes.ChoGGi_Sphere:new()
					m:SetPos(o2)
					m:SetRadius(50 * guic)
					m:SetColor(color)
					markers[m] = "point"
					if not time then
						ViewObjectMars(o2)
					end
--~ 					o2 = m
				end
			end

			if IsValid(o) and both ~= "single" then
				markers[o] = markers[o] or o:GetColorModifier()
				o:SetColorModifier(color)
				local pos = o:GetVisualPos()
				if not time and IsPointInBounds(pos) then
					ViewObjectMars(pos)
				end
			end
		end
	end
end -- do
local ShowMe = ChoGGi.ComFuncs.ShowMe
local ClearShowMe = ChoGGi.ComFuncs.ClearShowMe

function ChoGGi.ComFuncs.PopupBuildMenu(items,popup)
	local g_Classes = g_Classes
	local ViewObjectMars = ViewObjectMars
	local black = black

	for i = 1, #items do
		local item = items[i]
		-- "ChoGGi_CheckButtonMenu"
		local cls = g_Classes[item.class or "ChoGGi_ButtonMenu"]

		local button = cls:new({
			TextColor = black,
			RolloverTitle = item.hint_title and CheckText(item.hint_title,item.obj and RetName(item.obj) or S[126095410863--[[Info--]]]),
			RolloverText = CheckText(item.hint,""),
			Text = CheckText(item.name),
		}, popup.idContainer)

		if item.image then
			button.idIcon:SetImage(item.image)
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

		local showme_func
		if item.showme then
			showme_func = function(self, pt, child)
				ClearShowMe()
				ShowMe(item.showme, nil, true, true)
			end
		end

		local pos_func
		if item.pos then
			pos_func = function(self, pt, child)
				ViewObjectMars(item.pos)
			end
		end

		-- my ugly submenu hack
		local submenu_func
		if item.submenu then
			local name = StringFormat("ChoGGi_submenu_%s",item.name)
			submenu_func = function(self, pt, child)
				if popup[name] then
					popup[name]:Close()
				end
				popup[name] = g_Classes.XPopupList:new({
					Opened = true,
					Id = "ChoGGi_submenu_popup",
					popup_parent = popup,
					ZOrder = max_int - 1000,
					LayoutMethod = "VList",
					MaxItems = 8,
					AnchorType = "right",
					Anchor = self.box,
				}, terminal.desktop)
				ChoGGi.ComFuncs.PopupBuildMenu(item.submenu,popup[name])
				popup[name]:Open()
			end
		end

		-- add our mouseenter funcs
		if showme_func or pos_func or submenu_func then
			function button:OnMouseEnter(pt, child)
				cls.OnMouseEnter(self, pt, child)
				if showme_func then
					showme_func(self, pt, child)
				end
				if pos_func then
					pos_func(self, pt, child)
				end
				if submenu_func then
					submenu_func(self, pt, child)
				end
			end
		end
	end
end

function ChoGGi.ComFuncs.PopupToggle(parent,popup_id,items,anchor,reopen,submenu)
	local popup = rawget(terminal.desktop,popup_id)
	if popup then
		popup:Close()
		local submenu = rawget(terminal.desktop,"ChoGGi_submenu_popup")
		if submenu then
			submenu:Close()
		end
	end

	if not parent then
		return
	end

	if not popup or reopen then

		popup = XPopupList:new({
			Opened = true,
			Id = popup_id,
			-- -1000 is for XRollovers which get max_int
			ZOrder = max_int - 1000,
			LayoutMethod = "VList",
			-- "top" for the console, default "none"
			AnchorType = anchor or "top",
			-- "none","smart","left","right","top","center-top","bottom","mouse"
			Anchor = parent.box,

		}, terminal.desktop)

		ChoGGi.ComFuncs.PopupBuildMenu(items,popup,popup_id)

		popup:Open()
	--~			 return popup
	end
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

-- centred msgbox with Ok, and optional image
local WaitPopupNotification = WaitPopupNotification
function ChoGGi.ComFuncs.MsgWait(text,title,image)
	local PopupNotificationPresets = PopupNotificationPresets
	-- add my fake preset popup
	PopupNotificationPresets.ChoGGi_TempPopup = {
		title = CheckText(title,S[1000016--[[Title--]]]),
		text = CheckText(text,text),
		name = "ChoGGi_TempPopup",
		-- so it appears on screen instead of in a little popup
		start_minimized = false,
	}
	if image then
		PopupNotificationPresets.ChoGGi_TempPopup.image = image
	end

	-- we need a thread for the wait
	CreateRealTimeThread(function()
		WaitPopupNotification("ChoGGi_TempPopup")
		-- and remove my preset after (if there's an image we don't want it added to the next msg)
		PopupNotificationPresets.ChoGGi_TempPopup = nil
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
			image,
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
	table.sort(Items,
		function(a,b)
			return ChoGGi.ComFuncs.CompareTableValue(a,b,"text")
		end
	)
--]]
function ChoGGi.ComFuncs.CompareTableValue(a,b,name)
	if not a and not b then
		return
	end
	if type(a[name]) == type(b[name]) then
		return a[name] < b[name]
	else
		return tostring(a[name]) < tostring(b[name])
	end
end

--[[
table.sort(s.command_centers,
	function(a,b)
		return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",s)
	end
)
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
		text = StringFormat("%s----------------- %s: %s\r\n",text,list[i].id,i)
		for j = 1, #list[i] do
			text = StringFormat("%s%s: %s\r\n",text,list[i][j].id,j)
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
	local tab = UICity.labels[label] or ""
	for i = 1, #tab do
		if tab[i] and tab[i].handle and tab[i] == obj.handle then
			TableRemove(UICity.labels[label],i)
		end
	end
end
do -- bool
	acmpd = false
	acsac = false
	local Sleep = Sleep
	CreateRealTimeThread(function()
		while not dlgConsole do
			Sleep(50)
		end
		dlgConsole:Exec("ChoGGi.Temp.AccountStorage=AccountStorage\nChoGGi.Temp.SaveAccountStorage=SaveAccountStorage",true)
		acmpd = ChoGGi.Temp.AccountStorage.ModPersistentData
		acsac = ChoGGi.Temp.SaveAccountStorage
	end)
end

function toboolean(str)
	if str == "true" then
		return true
	elseif str == "false" then
		return false
	end
	return 0/0
end

-- tries to convert "65" to 65, "boolean" to boolean, "nil" to nil, or just returns "str" as "str"
function ChoGGi.ComFuncs.RetProperType(value)
	-- number?
	local num = tonumber(value)
	if num then
		return num
	end
	-- stringy boolean
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	end
	-- nadda
	if value == "nil" then
		return
	end
	-- then it's a string (probably)
	return value
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

it returns percentages in decimal for ease of mathing (SM removed the math.functions from lua)
ie: SupportiveCommunity is -70 this returns it as 0.7
it also returns negative amounts as positive (I prefer num - Amt, not num + NegAmt)
--]]
function ChoGGi.ComFuncs.ReturnTechAmount(tech,prop)
	local techdef = TechDef[tech] or ""
	for i = 1, #techdef do
		if techdef[i].Prop == prop then
			tech = techdef[i]
			local RetObj = {}

			if tech.Percent then
				local percent = tech.Percent
				if percent < 0 then
					percent = percent * -1 -- -50 > 50
				end
				RetObj.p = (percent + 0.0) / 100 -- (50 > 50.0) > 0.50
			end

			if tech.Amount then
				if tech.Amount < 0 then
					RetObj.a = tech.Amount * -1 -- always gotta be positive
				else
					RetObj.a = tech.Amount
				end
			end

			--With enemies you know where they stand but with Neutrals, who knows?
			if RetObj.a == 0 then
				return RetObj.p
			elseif RetObj.p == 0.0 then
				return RetObj.a
			end
		end
	end
end

--[[
	--need to see if research is unlocked
	if IsResearched and UICity:IsTechResearched(IsResearched) then
		--boolean consts
		Value = ChoGGi.ComFuncs.ReturnTechAmount(IsResearched,Name)
		--amount
		Consts["TravelTimeMarsEarth"] = Value
	end
--]]
function ChoGGi.ComFuncs.SetConstsG(name,value)
	-- we only want to change it if user set value
	if value then
		--some mods check Consts or g_Consts, so we'll just do both to be sure
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
		return empty_table
	end
	local temp_t = {}
	local dupe_t = {}
	local c = 0

	for i = 1, #list do
		if not dupe_t[list[i]] then
			c = c + 1
			temp_t[c] = list[i]
			dupe_t[list[i]] = true
		end
	end

	return temp_t
end

function ChoGGi.ComFuncs.RetTableNoClassDupes(list)
	if type(list) ~= "table" then
		return empty_table
	end
	local CompareTableValue = ChoGGi.ComFuncs.CompareTableValue
	table.sort(list,
		function(a,b)
			return CompareTableValue(a,b,"class")
		end
	)
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

-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Building or "",{ParSystem = true,ResourceStockpile = true},nil,"class")
-- ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Unit or "",nil,nil,"working")
function ChoGGi.ComFuncs.FilterFromTable(list,exclude_list,include_list,name)
	if type(list) ~= "table" then
		return empty_table
	end
	return FilterObjectsC({
		filter = function(o)
			if exclude_list or include_list then
				if exclude_list and include_list then
					if not exclude_list[o[name]] then
						return o
					elseif include_list[o[name]] then
						return o
					end
				elseif exclude_list then
					if not exclude_list[o[name]] then
						return o
					end
				elseif include_list then
					if include_list[o[name]] then
						return o
					end
				end
			else
				if o[name] then
					return o
				end
			end
		end,
	},list)
end

-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Building,"IsKindOf","Residence")
-- ChoGGi.ComFuncs.FilterFromTableFunc(UICity.labels.Unit or "","IsValid",nil,true)
function ChoGGi.ComFuncs.FilterFromTableFunc(list,func,value,is_bool)
	if type(list) ~= "table" then
		return empty_table
	end
	return FilterObjectsC({
		filter = function(o)
			if is_bool then
				if _G[func](o) then
					return o
				end
			elseif o[func](o,value) then
				return o
			end
		end
	},list)
end

function ChoGGi.ComFuncs.OpenInMultiLineTextDlg(context)
	if not context then
		return
	end

	return ChoGGi_MultiLineTextDlg:new({}, terminal.desktop,context)
end

--[[
get around to merging some of these types into funcs?

custom_type = 1 : updates selected item with custom value type, hides ok/cancel buttons, dblclick fires custom_func with {self.sel}, and sends back all items on ok
custom_type = 2 : colour selector
custom_type = 3 : updates selected item with custom value type, and sends back selected item.
custom_type = 4 : updates selected item with custom value type, and sends back all items
custom_type = 5 : for Lightmodel: show colour selector when listitem.editor = color,pressing check2 applies the lightmodel without closing dialog, dbl rightclick shows lightmodel lists and lets you pick one to use in new window
custom_type = 6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)
custom_type = 7 : dblclick fires custom_func with {self.sel} (wrapped in a table, so we can use CallBackFunc for either)
custom_type = 8 : same as 7, but dbl rightclick fires custom_func, and dbl click fires ok as normally

ChoGGi.ComFuncs.OpenInListChoice{
	callback = CallBackFunc,
	items = ItemList,
	title = "Title",
	hint = StringFormat("Current: %s",hint),
	multisel = true,
	custom_type = custom_type,
	custom_func = CustomFunc,
	close_func = function()end,
	check = {
		{
			title = "Check1",
			hint = "Check1Hint",
			checked = true,
--~ 			func = function()end,
		},
		{
			title = "Check2",
			hint = "Check2Hint",
			checked = true,
		},
	},
	skip_sort = true,
	height = 800.0,
	width = 100.0,
}
--]]
function ChoGGi.ComFuncs.OpenInListChoice(list)
	-- if table isn't a table or it doesn't have items/callback func or it has zero items
	if not list or (list and type(list) ~= "table" or not list.callback or not list.items) or #list.items < 1 then
		print(S[302535920001324--[[ECM: OpenInListChoice(list) is blank... This shouldn't happen.--]]])
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

	return StringFormat("%s: %s",setting,CheckText(S[text],text))
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
function ChoGGi.ComFuncs.ReturnAllNearby(radius,sort,pos)
	radius = radius or 5000
	pos = pos or GetTerrainCursor()

	-- get all objects within radius
	local list = MapGet(pos,radius)

	-- sort list custom
	if sort then
		table.sort(list,
			function(a,b)
				return a[sort] < b[sort]
			end
		)
	else
		-- sort nearest
		table.sort(list,
			function(a,b)
				return a:GetDist2D(pos) < b:GetDist2D(pos)
			end
		)
	end

	return list
end

do -- RetObjectAtPos/RetObjectsAtPos
	local WorldToHex = WorldToHex
	local HexGridGetObject = HexGridGetObject
	local HexGridGetObjects = HexGridGetObjects

	function ChoGGi.ComFuncs.RetObjectAtPos(pos,q,r)
		if pos then
			q, r = WorldToHex(pos)
		end
		return HexGridGetObject(ObjectGrid, q, r)
	end

	function ChoGGi.ComFuncs.RetObjectsAtPos(pos,q,r)
		if pos then
			q, r = WorldToHex(pos)
		end
		return HexGridGetObjects(ObjectGrid, q, r)
	end
end -- do

function ChoGGi.ComFuncs.RetSortTextAssTable(list,for_type)
	local temp_table = {}
	local c = 0

	-- add
	if for_type then
		for k,_ in pairs(list or empty_table) do
			c = c + 1
			temp_table[c] = k
		end
	else
		for _,v in pairs(list or empty_table) do
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
	function ChoGGi.ComFuncs.TickEnd(id)
		print(id,":",GetPreciseTicks() - times[id])
		times[id] = nil
	end
end -- do

function ChoGGi.ComFuncs.SelectConsoleLogText()
	local dlgConsoleLog = dlgConsoleLog
	if not dlgConsoleLog then
		return
	end
	local text = dlgConsoleLog.idText:GetText()
	if text:len() == 0 then
		print(S[302535920000692--[[Log is blank (well not anymore).--]]])
		return
	end

	ChoGGi.ComFuncs.OpenInMultiLineTextDlg{text = text}
end

do -- ShowConsoleLogWin
	local AsyncFileToString
	if not blacklist then
		AsyncFileToString = AsyncFileToString
	end

	local GetLogFile = GetLogFile
	function ChoGGi.ComFuncs.ShowConsoleLogWin(visible)
		if visible and not dlgChoGGi_ConsoleLogWin then
			dlgChoGGi_ConsoleLogWin = ChoGGi_ConsoleLogWin:new({}, terminal.desktop,{})

			-- update it with console log text
			local dlg = dlgConsoleLog
			if dlg then
				dlgChoGGi_ConsoleLogWin.idText:SetText(dlg.idText:GetText())
			elseif not blacklist then
				--if for some reason consolelog isn't around, then grab the log file
				local err,str = AsyncFileToString(GetLogFile())
				if not err then
					dlgChoGGi_ConsoleLogWin.idText:SetText(str)
				end
			end

		end

		local dlg = dlgChoGGi_ConsoleLogWin
		if dlg then
			dlg:SetVisible(visible)

			--size n position
			local size = ChoGGi.UserSettings.ConsoleLogWin_Size
			local pos = ChoGGi.UserSettings.ConsoleLogWin_Pos
			--make sure dlg is within screensize
			if size then
				dlg:SetSize(size)
			end
			if pos then
				dlg:SetPos(pos)
			else
				dlg:SetPos(point(100,100))
			end

		end
	end
end -- do

do -- UpdateDataTables
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

	function ChoGGi.ComFuncs.UpdateDataTables(cargo_update)
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
		-- we only need to call when ResupplyItemDefinitions is built (start of new games)
		if cargo_update == true then
			-- values rocket checks
			Tables.Cargo = {}
			-- defaults
			Tables.CargoPresets = {}

			local ResupplyItemDefinitions = ResupplyItemDefinitions
			for i = 1, #ResupplyItemDefinitions do
				local meta = getmetatable(ResupplyItemDefinitions[i]).__index
				Tables.Cargo[i] = meta
				Tables.Cargo[meta.id] = meta
			end

			-- used to check defaults for cargo
			c = 0
			for cargo_id,cargo in pairs(CargoPreset) do
				c = c + 1
				Tables.CargoPresets[c] = cargo
				Tables.CargoPresets[cargo_id] = cargo
			end
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

function ChoGGi.ComFuncs.GetObjects(query, obj, query_width, ignore_classes)

	if type(query) ~= "table" then
		return MapGet(true,query)
	end
--~ 	MapGet(true,s.class)
--~ 	MapGet( GetTerrainCursor(), 100*guim, "Tree" )
	return GetObjects({
		class = query.class,
		classes = query.classes,
		area = query.area,
		areapoint1 = query.areapoint1,
		areapoint2 = query.areapoint2,
		arearadius = query.arearadius,
		areafilter = query.areafilter,
		hexradius = query.hexradius,
		collection = query.collection,
		attached = query.attached,
		recursive = query.recursive,
		enum_flags_any = query.enum_flags_any,
		game_flags_all = query.game_flags_all,
		class_flags_all = query.class_flags_all,
		filter = query.filter,
	}, obj, query_width, ignore_classes)
--~		 area = "realm",
--~ "realm" = every object
--~ "outsiders" = prefab markers
--~ "detached" = invalid positions
--~ "line" = ?
--~		 areapoint1 = self.point0,
--~		 areapoint2 = self.point1,
--~		 arearadius = 100,
--~			 areafilter = function(o)
--~				 return o:GetParent() == nil
--~			 end,
--~		 class = "Object",
--~		 classes = {"EditorDummy","Text"},
--~		 hexradius = self.exploitation_radius,
--~		 collection = self.Index,
--~		 attached = false,
--~		 recursive = true,
--~		 enum_flags_any = const.efBakedTerrainDecal,
--~		 class_flags_all = const.cfLuaObject,
--~		 game_flags_all = const.gofPermanent,
--~		 filter = function(o)
--~			 return not IsKindOf(o, "Collection")
--~		 end,

end

function ChoGGi.ComFuncs.OpenKeyPresserDlg()
	ChoGGi_KeyPresserDlg:new({}, terminal.desktop,{})
end

function ChoGGi.ComFuncs.CreateSetting(str,setting_type)
	local setting = ChoGGi.ComFuncs.DotNameToObject(str,nil,true)
	if type(setting) == setting_type then
		return true
	end
end

-- returns whatever is selected > moused over > nearest object to cursor
function ChoGGi.ComFuncs.SelObject(radius)
	local obj = SelectedObj or SelectionMouseObj()
	if not obj then
		local pt = GetTerrainCursor()
		obj = MapFindNearest(pt,pt,radius or 1500)
	end
	return obj
end

function ChoGGi.ComFuncs.Rebuildshortcuts(Actions)
	local XShortcutsTarget = XShortcutsTarget

	-- remove all built-in shortcuts (pretty much just a cutdown copy of ReloadShortcuts)
	XShortcutsTarget.actions = {}
	-- re-add certain ones
	if Platform.ged and XTemplates.GedShortcuts then
		XTemplateSpawn("GedShortcuts", XShortcutsTarget)
	elseif XTemplates.GameShortcuts then
		XTemplateSpawn("GameShortcuts", XShortcutsTarget)
	end

	-- remove stuff from GameShortcuts
	for i = #XShortcutsTarget.actions, 1, -1 do
		-- removes pretty much all the dev actions added, and leaves the game ones intact
		local a = XShortcutsTarget.actions[i]
		local g = a.ActionId:sub(1,2) == "G_"
		if a.ActionId and (not a.ActionId:starts_with("action") and not g or a.ActionId == "G_CompleteConstructions") then
			TableRemove(XShortcutsTarget.actions,i)
		elseif g then
			-- hide the orig cheats
			a.ActionMenubar = nil
		end
	end
	if testing then
		TableRemove(XShortcutsTarget.actions,table.find(XShortcutsTarget.actions,"ActionId","actionToggleFullscreen"))
	end

	-- and add mine
	local XAction = XAction
	local Actions = ChoGGi.Temp.Actions

--~ Actions = {}
--~ Actions[#Actions+1] = {
--~	 ActionId = "ChoGGi_ShowConsoleTilde",
--~	 OnAction = function()
--~	 local dlgConsole = dlgConsole
--~	 if dlgConsole then
--~		 ShowConsole(not dlgConsole:GetVisible())
--~	 end
--~	 end,
--~	 ActionShortcut = "~",
--~ }

	local DisableECM = ChoGGi.UserSettings.DisableECM
	for i = 1, #Actions do
		local a = Actions[i]
		-- added by ECM
		if a.IsECM then
			-- can we enable ECM actions?
			if not DisableECM then
				-- and add to the actual actions
				XShortcutsTarget:AddAction(XAction:new(a))
			end
		else
			XShortcutsTarget:AddAction(XAction:new(a))
		end
	end

	-- add rightclick action to menuitems
	XShortcutsTarget:UpdateToolbar()
	-- got me
	XShortcutsThread = false

	-- if it's bool then ECM is active
	if type(DisableECM) == "boolean" and not DisableECM then
		-- i forget why i'm toggling this...
		local dlgConsole = dlgConsole
		if dlgConsole then
			ShowConsole(not dlgConsole:GetVisible())
			ShowConsole(not dlgConsole:GetVisible())
		end
	end
end

do -- RetThreadInfo/FindThreadFunc
	local GedInspectorFormatObject = GedInspectorFormatObject
	local IsValidThread = IsValidThread
	local pairs = pairs
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
			str = StringFormat("%s\n%s %s: %s",str,funcs[i].func,S[302535920001359--[[debug.getinfo() level--]]],funcs[i].level)
		end
		return str
	end

	-- find/return func if str in func name
	function ChoGGi.ComFuncs.FindThreadFunc(thread,str)
--~ 		if not IsValidThread then
--~ 			return
--~ 		end
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

-- check if tech is researched before we get value
do -- get tech stuff
	local ChoGGi = ChoGGi
	local r = ChoGGi.Consts.ResourceScale
	function ChoGGi.ComFuncs.GetSpeedDrone()
		local UICity = UICity
		local MoveSpeed = ChoGGi.Consts.SpeedDrone

		if UICity and UICity:IsTechResearched("LowGDrive") then
			local p = ChoGGi.ComFuncs.ReturnTechAmount("LowGDrive","move_speed")
			MoveSpeed = MoveSpeed + MoveSpeed * p
		end
		if UICity and UICity:IsTechResearched("AdvancedDroneDrive") then
			local p = ChoGGi.ComFuncs.ReturnTechAmount("AdvancedDroneDrive","move_speed")
			MoveSpeed = MoveSpeed + MoveSpeed * p
		end

		return MoveSpeed
	end

	function ChoGGi.ComFuncs.GetFuelRocket()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("AdvancedMartianEngines") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("AdvancedMartianEngines","launch_fuel")
			return ChoGGi.Consts.LaunchFuelPerRocket - (a * r)
		end
		return ChoGGi.Consts.LaunchFuelPerRocket
	end

	function ChoGGi.ComFuncs.GetSpeedRC()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("LowGDrive") then
			local p = ChoGGi.ComFuncs.ReturnTechAmount("LowGDrive","move_speed")
			return ChoGGi.Consts.SpeedRC + ChoGGi.Consts.SpeedRC * p
		end
		return ChoGGi.Consts.SpeedRC
	end

	function ChoGGi.ComFuncs.GetCargoCapacity()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("FuelCompression") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("FuelCompression","CargoCapacity")
			return ChoGGi.Consts.CargoCapacity + a
		end
		return ChoGGi.Consts.CargoCapacity
	end
	--
	function ChoGGi.ComFuncs.GetCommandCenterMaxDrones()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("DroneSwarm") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("DroneSwarm","CommandCenterMaxDrones")
			return ChoGGi.Consts.CommandCenterMaxDrones + a
		end
		return ChoGGi.Consts.CommandCenterMaxDrones
	end
	--
	function ChoGGi.ComFuncs.GetDroneResourceCarryAmount()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("ArtificialMuscles") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("ArtificialMuscles","DroneResourceCarryAmount")
			return ChoGGi.Consts.DroneResourceCarryAmount + a
		end
		return ChoGGi.Consts.DroneResourceCarryAmount
	end
	--
	function ChoGGi.ComFuncs.GetLowSanityNegativeTraitChance()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("SupportiveCommunity") then
			local p = ChoGGi.ComFuncs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
			--[[
			LowSanityNegativeTraitChance = 30%
			SupportiveCommunity = -70%
			--]]
			local LowSan = ChoGGi.Consts.LowSanityNegativeTraitChance + 0.0 --SM has no math.funcs so + 0.0
			return p*LowSan/100*100
		end
		return ChoGGi.Consts.LowSanityNegativeTraitChance
	end
	--
	function ChoGGi.ComFuncs.GetMaxColonistsPerRocket()
		local UICity = UICity
		local PerRocket = ChoGGi.Consts.MaxColonistsPerRocket
		if UICity and UICity:IsTechResearched("CompactPassengerModule") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("CompactPassengerModule","MaxColonistsPerRocket")
			PerRocket = PerRocket + a
		end
		if UICity and UICity:IsTechResearched("CryoSleep") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("CryoSleep","MaxColonistsPerRocket")
			PerRocket = PerRocket + a
		end
		return PerRocket
	end
	--
	function ChoGGi.ComFuncs.GetNonSpecialistPerformancePenalty()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("GeneralTraining") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
			return ChoGGi.Consts.NonSpecialistPerformancePenalty - a
		end
		return ChoGGi.Consts.NonSpecialistPerformancePenalty
	end
	--
	function ChoGGi.ComFuncs.GetRCRoverMaxDrones()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("RoverCommandAI") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("RoverCommandAI","RCRoverMaxDrones")
			return ChoGGi.Consts.RCRoverMaxDrones + a
		end
		return ChoGGi.Consts.RCRoverMaxDrones
	end
	--
	function ChoGGi.ComFuncs.GetRCTransportGatherResourceWorkTime()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("TransportOptimization") then
			local p = ChoGGi.ComFuncs.ReturnTechAmount("TransportOptimization","RCTransportGatherResourceWorkTime")
			return ChoGGi.Consts.RCTransportGatherResourceWorkTime * p
		end
		return ChoGGi.Consts.RCTransportGatherResourceWorkTime
	end
	--
	function ChoGGi.ComFuncs.GetRCTransportStorageCapacity()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("TransportOptimization") then
			local a = ChoGGi.ComFuncs.ReturnTechAmount("TransportOptimization","max_shared_storage")
			return ChoGGi.Consts.RCTransportStorageCapacity + (a * r)
		end
		return ChoGGi.Consts.RCTransportStorageCapacity
	end
	--
	function ChoGGi.ComFuncs.GetTravelTimeEarthMars()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("PlasmaRocket") then
			local p = ChoGGi.ComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeEarthMars")
			return ChoGGi.Consts.TravelTimeEarthMars * p
		end
		return ChoGGi.Consts.TravelTimeEarthMars
	end
	--
	function ChoGGi.ComFuncs.GetTravelTimeMarsEarth()
		local UICity = UICity
		if UICity and UICity:IsTechResearched("PlasmaRocket") then
			local p = ChoGGi.ComFuncs.ReturnTechAmount("PlasmaRocket","TravelTimeMarsEarth")
			return ChoGGi.Consts.TravelTimeMarsEarth * p
		end
		return ChoGGi.Consts.TravelTimeMarsEarth
	end
end

-- if building requires a dome and that dome is borked then assign it to nearest dome
function ChoGGi.ComFuncs.AttachToNearestDome(obj)
	local workingdomes = ChoGGi.ComFuncs.FilterFromTable(UICity.labels.Dome,nil,nil,"working")

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

		--size of activation area for border scrolling
		if ChoGGi.UserSettings.BorderScrollingArea then
			SetProperties(1,{ScrollBorder = ChoGGi.UserSettings.BorderScrollingArea})
		else
			--default
			SetProperties(1,{ScrollBorder = 5})
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
			--default
			SetZoomLimits(400,15000)
		end

		--SetProperties(1,{HeightInertia = 0})
	end
end -- do

function ChoGGi.ComFuncs.ShowBuildMenu(which)
	local BuildCategories = BuildCategories

	--make sure we're not in the main menu (deactiving mods when going back to main menu would be nice, check for a msg to use?)
	if not Dialogs.PinsDlg then
		return
	end

	local dlg = Dialogs.XBuildMenu
	if dlg then
		--opened so check if number corresponds and if so hide the menu
		if dlg.category == BuildCategories[which].id then
			CloseDialog("XBuildMenu")
		end
	else
		OpenXBuildMenu()
	end
	dlg = Dialogs.XBuildMenu
	dlg:SelectCategory(BuildCategories[which])
	--have to fire twice to highlight the icon
	dlg:SelectCategory(BuildCategories[which])
end

function ChoGGi.ComFuncs.ColonistUpdateAge(c,age)
	if age == S[3490--[[Random--]]] then
		age = ChoGGi.Tables.ColonistAges[Random(1,6)]
	end
	--remove all age traits
	c:RemoveTrait("Child")
	c:RemoveTrait("Youth")
	c:RemoveTrait("Adult")
	c:RemoveTrait("Middle Aged")
	c:RemoveTrait("Senior")
	c:RemoveTrait("Retiree")
	--add new age trait
	c:AddTrait(age)

	--needed for comparison
	local orig_age = c.age_trait
	--needed for updating entity
	c.age_trait = age

	if age == "Retiree" then
		c.age = 65 --why isn't there a base_MinAge_Retiree...
	else
		c.age = c[StringFormat("base_MinAge_%s",age)]
	end

	if age == "Child" then
		--there aren't any child specialist entities
		c.specialist = "none"
		--only children live in nurseries
		if orig_age ~= "Child" then
			c:SetResidence(false)
		end
	end
	--only children live in nurseries
	if orig_age == "Child" and age ~= "Child" then
		c:SetResidence(false)
	end
	--now we can set the new entity
	c:ChooseEntity()
	--and (hopefully) prod them into finding a new residence
	c:UpdateWorkplace()
	c:UpdateResidence()
	--c:TryToEmigrate()
end

function ChoGGi.ComFuncs.ColonistUpdateGender(c,gender,cloned)
	local ChoGGi = ChoGGi
	if gender == S[3490--[[Random--]]] then
		gender = ChoGGi.Tables.ColonistGenders[Random(1,5)]
	elseif gender == S[302535920000800--[[MaleOrFemale--]]] then
		gender = ChoGGi.Tables.ColonistGenders[Random(4,5)]
	end
	--remove all gender traits
	c:RemoveTrait("OtherGender")
	c:RemoveTrait("Android")
	c:RemoveTrait("Clone")
	c:RemoveTrait("Male")
	c:RemoveTrait("Female")
	--add new gender trait
	c:AddTrait(gender)
	--needed for updating entity
	c.gender = gender
	--set entity gender
	if gender == "Male" or gender == "Female" then
		c.entity_gender = gender
	else --random
		if cloned then
			c.entity_gender = cloned
		else
			if Random(1,2) == 1 then
				c.entity_gender = "Male"
			else
				c.entity_gender = "Female"
			end
		end
	end
	--now we can set the new entity
	c:ChooseEntity()
end

function ChoGGi.ComFuncs.ColonistUpdateSpecialization(c,spec)
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
	if race == S[3490--[[Random--]]] then
		race = Random(1,5)
	end
	c.race = race
	c:ChooseEntity()
end

-- toggle visiblity of console log
function ChoGGi.ComFuncs.ToggleConsoleLog()
	local log = dlgConsoleLog
	if log then
		if log:GetVisible() then
			log:SetVisible(false)
		else
			log:SetVisible(true)
		end
	else
		dlgConsoleLog = ConsoleLog:new({}, terminal.desktop)
	end
end

--[[
		local tab = UICity.labels.BlackCubeStockpiles or ""
		for i = 1, #tab do
			ChoGGi.ComFuncs.FuckingDrones(tab[i])
		end
--]]
--force drones to pickup from object even if they have a large carry cap
function ChoGGi.ComFuncs.FuckingDrones(obj)
	local ChoGGi = ChoGGi
	local r = ChoGGi.Consts.ResourceScale
	--Come on, Bender. Grab a jack. I told these guys you were cool.
	--Well, if jacking on will make strangers think I'm cool, I'll do it.

	if not obj then
		return
	end

	local stored
	local p
	local request
	local resource
	--mines/farms/factories
	if obj.class == "SingleResourceProducer" then
		p = obj.parent
		stored = obj:GetAmountStored()
		request = obj.stockpiles[obj:GetNextStockpileIndex()].supply_request
		resource = obj.resource_produced
	elseif obj.class == "BlackCubeStockpile" then
		p = obj
		stored = obj:GetStoredAmount()
		request = obj.supply_request
		resource = obj.resource
	end

	--only fire if more then one resource
	if stored > 1000 then
		local drone = ChoGGi.ComFuncs.GetNearestIdleDrone(p)
		if not drone then
			return
		end

		local carry = g_Consts.DroneResourceCarryAmount * r
		--round to nearest 1000 (don't want uneven stacks)
		stored = (stored - stored % 1000) / 1000 * 1000
		--if carry is smaller then stored then they may not pickup (depends on storage)
		if carry < stored or
			--no picking up more then they can carry
			stored > carry then
				stored = carry
		end
		--pretend it's the user doing it (for more priority?)
		drone:SetCommandUserInteraction(
			"PickUp",
			request,
			false,
			resource,
			stored
		)
	end
end

function ChoGGi.ComFuncs.GetNearestIdleDrone(bld)
	local ChoGGi = ChoGGi
	if not bld or (bld and not bld.command_centers) then
		return
	end

	--check if nearest cc has idle drones
	local cc = FindNearestObject(bld.command_centers,bld)
	if cc and cc:GetIdleDronesCount() > 0 then
		cc = cc.drones
	else
		--sort command_centers by nearest dist
		table.sort(bld.command_centers,
			function(a,b)
				return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",bld.command_centers)
			end
		)
		--get command_center with idle drones
		for i = 1, #bld.command_centers do
			if bld.command_centers[i]:GetIdleDronesCount() > 0 then
				cc = bld.command_centers[i].drones
				break
			end
		end
	end
	--it happens...
	if not cc then
		return
	end

	--get an idle drone
	for i = 1, #cc do
		if cc[i].command == "Idle" or cc[i].command == "WaitCommand" then
			return cc[i]
		end
	end
end

function ChoGGi.ComFuncs.SaveOldPalette(obj)
	if not obj.ChoGGi_origcolors and obj:IsKindOf("ColorizableObject") then
		obj.ChoGGi_origcolors = {
			{obj:GetColorizationMaterial(1)},
			{obj:GetColorizationMaterial(2)},
			{obj:GetColorizationMaterial(3)},
			{obj:GetColorizationMaterial(4)},
		}
	end
end
function ChoGGi.ComFuncs.RestoreOldPalette(obj)
	if obj.ChoGGi_origcolors then
		local c = obj.ChoGGi_origcolors
		obj:SetColorizationMaterial(1, c[1][1], c[1][2], c[1][3])
		obj:SetColorizationMaterial(2, c[2][1], c[2][2], c[2][3])
		obj:SetColorizationMaterial(3, c[3][1], c[3][2], c[3][3])
		obj:SetColorizationMaterial(4, c[4][1], c[4][2], c[4][3])
		obj.ChoGGi_origcolors = nil
	end
end

function ChoGGi.ComFuncs.GetPalette(obj)
	local pal = {}
	pal.Color1, pal.Roughness1, pal.Metallic1 = obj:GetColorizationMaterial(1)
	pal.Color2, pal.Roughness2, pal.Metallic2 = obj:GetColorizationMaterial(2)
	pal.Color3, pal.Roughness3, pal.Metallic3 = obj:GetColorizationMaterial(3)
	pal.Color4, pal.Roughness4, pal.Metallic4 = obj:GetColorizationMaterial(4)
	return pal
end

function ChoGGi.ComFuncs.RandomColour(amount)
	if amount and type(amount) == "number" then
		local RetTableNoDupes = ChoGGi.ComFuncs.RetTableNoDupes
		local Random = Random -- ChoGGi.ComFuncs.Random

		local colours = {}
		local c = 0
		-- populate list with amount we want
		for _ = 1, amount do
			c = c + 1
			colours[c] = Random(-16777216,0) -- 24bit colour
		end

		-- now remove all dupes and add more till we hit amount
		repeat
			-- then loop missing amount
			c = #colours
			for _ = 1, amount - #colours do
				c = c + 1
				colours[c] = Random(-16777216,0)
			end
			-- remove dupes
			colours = RetTableNoDupes(colours)
		until #colours == amount

		return colours
	end

	-- return a single colour
	return Random(-16777216,0)
end

function ChoGGi.ComFuncs.ObjectColourRandom(obj)
	if not obj or obj and not obj:IsKindOf("ColorizableObject") then
		return
	end
	local ChoGGi = ChoGGi
	local attaches = {}
	local c = 0

	-- add regular attachments
	if obj:IsKindOf("ComponentAttach") then
		obj:ForEachAttach("ColorizableObject",function(a)
			c = c + 1
			attaches[c] = {obj = a,c = {}}
		end)
	end

	-- add any non-attached attaches
	local IsValid = IsValid
	for _,a in pairs(obj) do
		if IsValid(a) and a:IsKindOf("ColorizableObject") then
			c = c + 1
			attaches[c] = {obj = a,c = {}}
		end
	end

	-- random is random after all, so lets try for at least slightly different colours
	-- you can do 4 colours on each object
	local colours = ChoGGi.ComFuncs.RandomColour((c * 4) + 4)
	-- attach obj to list
	c = c + 1
	attaches[c] = {obj = obj,c = {}}

	-- add colours to each colour table attached to each obj
	local cc = 0
	local ac = 1
	for i = 1, #colours do
		-- add 1 to colour count
		cc = cc + 1
		-- add colour to attach colours
		attaches[ac].c[cc] = colours[i]

		if cc == 4 then
			-- when we get to four increment attach colours num, and reset colour count
			cc = 0
			ac = ac + 1
		end
	end

	local Random = Random
	for i = 1, c do
		obj = attaches[i].obj
		local c = attaches[i].c

		-- likely can only change basecolour
		if obj:GetColorizationMaterial(1) == 8421504 and obj:GetColorizationMaterial(2) == 8421504 and obj:GetColorizationMaterial(3) == 8421504 and obj:GetColorizationMaterial(4) == 8421504 then
			obj:SetColorModifier(c[1])
		else
			if not obj.ChoGGi_origcolors then
				ChoGGi.ComFuncs.SaveOldPalette(obj)
			end
			-- object,1,Color, Roughness, Metallic
			obj:SetColorizationMaterial(1, c[1], Random(-255,255), Random(-255,255))
			obj:SetColorizationMaterial(2, c[2], Random(-255,255), Random(-255,255))
			obj:SetColorizationMaterial(3, c[3], Random(-255,255), Random(-255,255))
			obj:SetColorizationMaterial(4, c[4], Random(-255,255), Random(-255,255))
		end
	end -- for

end

function ChoGGi.ComFuncs.SetDefColour(obj)
	obj:SetColorModifier(6579300)
	if obj.ChoGGi_origcolors then
		local c = obj.ChoGGi_origcolors
		obj:SetColorizationMaterial(1, c[1][1], c[1][2], c[1][3])
		obj:SetColorizationMaterial(2, c[2][1], c[2][2], c[2][3])
		obj:SetColorizationMaterial(3, c[3][1], c[3][2], c[3][3])
		obj:SetColorizationMaterial(4, c[4][1], c[4][2], c[4][3])
	end
end

function ChoGGi.ComFuncs.ObjectColourDefault(obj)
	obj = obj or ChoGGi.ComFuncs.SelObject()
	if not obj then
		return
	end
	local SetDefColour = ChoGGi.ComFuncs.SetDefColour

	if IsValid(obj) and obj:IsKindOf("ColorizableObject") then
		SetDefColour(obj)
	end
	-- regular attaches
	if obj:IsKindOf("ComponentAttach") then
		obj:ForEachAttach("ColorizableObject",function(a)
			SetDefColour(a)
		end)
	end
	-- other attaches
	local IsValid = IsValid
	for _,a in pairs(obj) do
		if IsValid(a) and a:IsKindOf("ColorizableObject") then
			SetDefColour(a)
		end
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
--~ 		ChoGGi.ComFuncs.DeleteObject(oldobj)
	end)

end

do -- ChangeObjectColour
	--they get called a few times so
	local function SetOrigColours(obj)
		ChoGGi.ComFuncs.RestoreOldPalette(obj)
		--6579300 = reset base color
		obj:SetColorModifier(6579300)
	end
	local function SetColours(obj,choice)
		ChoGGi.ComFuncs.SaveOldPalette(obj)
		for i = 1, 4 do
			local color = choice[i].value
			local roughness = choice[i+8].value
			local metallic = choice[i+4].value
			obj:SetColorizationMaterial(i,color,roughness,metallic)
		end
		obj:SetColorModifier(choice[13].value)
	end
	--make sure we're in the same grid
	local function CheckGrid(fake_parent,Func,obj,obj_bld,choice)
		--used to check for grid connections
		local check_air = choice[1].checkair
		local check_water = choice[1].checkwater
		local check_elec = choice[1].checkelec

		if check_air and obj_bld.air and fake_parent.air and obj_bld.air.grid.elements[1].building == fake_parent.air.grid.elements[1].building then
			Func(obj,choice)
		end
		if check_water and obj_bld.water and fake_parent.water and obj_bld.water.grid.elements[1].building == fake_parent.water.grid.elements[1].building then
			Func(obj,choice)
		end
		if check_elec and obj_bld.electricity and fake_parent.electricity and obj_bld.electricity.grid.elements[1].building == fake_parent.electricity.grid.elements[1].building then
			Func(obj,choice)
		end
		if not check_air and not check_water and not check_elec then
			Func(obj,choice)
		end
	end

	function ChoGGi.ComFuncs.ChangeObjectColour(obj,parent,dialog)
		local ChoGGi = ChoGGi
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
			text = StringFormat("Metallic%s",i)
			c = c + 1
			ItemList[c] = {
				text = text,
				value = pal[text],
				hint = 302535920000018--[[Don't use the colour picker: Numbers range from -255 to 255.--]],
			}
			text = StringFormat("Roughness%s",i)
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
	If you want to change the colour of an object you can't with 1-4 (like drones)."--]],
		}

		local function CallBackFunc(choice)
			if #choice < 1 then
				return
			end
			local value = choice[1].value

			if #choice == 13 then
				--needed to set attachment colours
				local label = obj.class
				local fake_parent
				if parent then
					label = parent.class
					fake_parent = parent
				else
					fake_parent = obj.parentobj
				end
				if not fake_parent then
					fake_parent = obj
				end

				--store table so it's the same as was displayed
				table.sort(choice,
					function(a,b)
						return ChoGGi.ComFuncs.CompareTableValue(a,b,"text")
					end
				)
				--All of type checkbox
				if choice[1].check1 then
					local tab = UICity.labels[label] or ""
					for i = 1, #tab do
						if parent then
							local attaches = tab[i]:GetAttaches(obj.class) or ""
							for j = 1, #attaches do
								--if Attaches[j].class == obj.class then
									if choice[1].check2 then
										CheckGrid(fake_parent,SetOrigColours,attaches[j],tab[i],choice)
									else
										CheckGrid(fake_parent,SetColours,attaches[j],tab[i],choice)
									end
								--end
							end
						else --not parent
							if choice[1].check2 then
								CheckGrid(fake_parent,SetOrigColours,tab[i],tab[i],choice)
							else
								CheckGrid(fake_parent,SetColours,tab[i],tab[i],choice)
							end
						end --parent
					end
				else --single building change
					if choice[1].check2 then
						CheckGrid(fake_parent,SetOrigColours,obj,obj,choice)
					else
						CheckGrid(fake_parent,SetColours,obj,obj,choice)
					end
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

--returns the near hex grid for object placement
function ChoGGi.ComFuncs.CursorNearestHex(pt)
	return HexGetNearestCenter(pt or GetTerrainCursor())
end

function ChoGGi.ComFuncs.DeleteAllAttaches(obj)
	if obj:IsKindOf("ComponentAttach") then
		obj:DestroyAttaches()
	end
end

do -- FindNearestResource
	local MapGet = MapGet
	local FindNearestObject = FindNearestObject

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
			if #choice < 1 then
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
				stockpiles = FilterObjectsC({
					filter = function(o)
						if o[GetStored] and o[GetStored](o) > 999 then
							return o
						end
					end,
				},stockpiles)
				-- attached stockpiles/stockpiles left from removed objects
				table.append(stockpiles,
					MapGet("map",{"ResourceStockpile","ResourceStockpileLR"}, function(o)
						if o.resource == value and o:GetStoredAmount() > 999 then
							return o
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
end -- do

do -- DeleteObject
	local IsValid = IsValid
	local function DeleteObject_ExecFunc(obj,funcname,param)
		if obj[funcname] then
			obj[funcname](obj,param)
		end
	end

	function ChoGGi.ComFuncs.DeleteObject(obj,editor_delete)
		local ChoGGi = ChoGGi

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

		-- deleting domes will freeze game if they have anything in them.
		local dome = obj:IsKindOf("Dome")
		if dome and #obj.labels.Buildings > 0 then
			print(S[302535920001354--[["This dome (%s) has buildings, which = crash if removed..."--]]]:format(RetName(obj)))
			return
		end

		-- some stuff will leave holes in the world if they're still working
		DeleteObject_ExecFunc(obj,"ToggleWorking")

		obj.can_demolish = true
		obj.indestructible = false

		if obj.DoDemolish then
			pcall(function()
				DestroyBuildingImmediate(obj)
			end)
		end

		if obj:IsKindOf("Deposit") and obj.group then
			for i = #obj.group, 1, -1 do
				obj.group[i]:delete()
				obj.group[i] = nil
			end
		end

		DeleteObject_ExecFunc(obj,"Destroy")
		DeleteObject_ExecFunc(obj,"SetDome",false)
		DeleteObject_ExecFunc(obj,"RemoveFromLabels")
		DeleteObject_ExecFunc(obj,"Done")
		DeleteObject_ExecFunc(obj,"Gossip","done")
		DeleteObject_ExecFunc(obj,"SetHolder",false)

		-- only fire for stuff with holes in the ground (takes too long otherwise)
		if IsKindOfClasses("MoholeMine","ShuttleHub","MetalsExtractor") then
			DeleteObject_ExecFunc(obj,"DestroyAttaches","")
		end

		-- I did ask nicely
		if IsValid(obj) then
			obj:delete()
		end
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
	local function AddGrid(UICity,name,info)
		local c = #info.tables
		for i = 1, #UICity[name] do
			c = c + 1
			info.tables[c] = UICity[name][i]
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
		--only need to do people walking outside (pathing issue), and if they don't have a path (not moving or walking into an invis wall)
		if objs[i]:IsValidPos() and not objs[i]:GetPath() then
			--too close and they keep doing the human centipede
			local x,y,_ = objs[i]:GetVisualPosXYZ()
			objs[i]:SetCommand("Goto", GetPassablePointNearby(point(x+Random(-5000,5000),y+Random(-5000,5000))))
		end
	end
end

function ChoGGi.ComFuncs.CollisionsObject_Toggle(obj,skip_msg)
	obj = obj or ChoGGi.ComFuncs.SelObject()
	if not obj then
		if not skip_msg then
			MsgPopup(
				302535920000967--[[Nothing selected.--]],
				302535920000968--[[Collisions--]]
			)
		end
		return
	end
	-- not sure why i have the efApplyToGrids...
	local coll = const.efCollision + const.efApplyToGrids

	local which
	-- re-enable col on obj and any attaches
	if obj.ChoGGi_CollisionsDisabled then
		obj:SetEnumFlags(coll)
		if obj:IsKindOf("ComponentAttach") then
			obj:ForEachAttach(function(a)
				a:SetEnumFlags(coll)
			end)
		end
		obj.ChoGGi_CollisionsDisabled = nil
		which = S[460479110814--[[Enabled--]]]
	else
		obj:ClearEnumFlags(coll)
		if obj:IsKindOf("ComponentAttach") then
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

	for key,value in pairs(GetMemoryInfo()) do
		cm = cm + 1
		mem[cm] = StringFormat("%s: %s\n",key,value)
	end

	local hw = {}
	local chw = 0
	for key,value in pairs(GetHardwareInfo(0)) do
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

-- check for and remove old object (XTemplates are created on new game/new dlc ?)
function ChoGGi.ComFuncs.RemoveXTemplateSections(list,name)
	local idx = TableFind(list, name, true)
	if idx then
		list[idx]:delete()
		table.remove(list,idx)
	end
end

function ChoGGi.ComFuncs.AddXTemplate(name,template,list,toplevel)
	if not name or not template or not list then
		print("AddXTemplate borked template: ", name, template, list)
		return
	end
	local stored_name = StringFormat("ChoGGi_Template_%s",name)
	local XTemplates = XTemplates

	if toplevel then
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates[template],stored_name)
		XTemplates[template][#XTemplates[template]+1] = PlaceObj("XTemplateTemplate", {
			stored_name, true,
			"__condition", list.__condition or function()
				return true
			end,
			"__context_of_kind", list.__context_of_kind or "",
			"__template", list.__template or "InfopanelSection",
			"Title", list.Title or S[1000016--[[Title--]]],
			"Icon", list.Icon or "UI/Icons/gpmc_system_shine.tga",
			"RolloverTitle", list.RolloverTitle or S[126095410863--[[Info--]]],
			"RolloverText", list.RolloverText or S[126095410863--[[Info--]]],
			"RolloverHint", list.RolloverHint or "",
			"OnContextUpdate", list.OnContextUpdate or function()end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
						return self.parent
					end,
				"func", list.func or function()end,
			})
		})
	else
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates[template][1],stored_name)
		XTemplates[template][1][#XTemplates[template][1]+1] = PlaceObj("XTemplateTemplate", {
			stored_name, true,
			"__condition", list.__condition or function()
				return true
			end,
			"__context_of_kind", list.__context_of_kind or "",
			"__template", list.__template or "InfopanelSection",
			"Title", list.Title or S[1000016--[[Title--]]],
			"Icon", list.Icon or "UI/Icons/gpmc_system_shine.tga",
			"RolloverTitle", list.RolloverTitle or S[126095410863--[[Info--]]],
			"RolloverText", list.RolloverText or S[126095410863--[[Info--]]],
			"RolloverHint", list.RolloverHint or "",
			"OnContextUpdate", list.OnContextUpdate or function()end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
						return self.parent
					end,
				"func", list.func or function()end,
			})
		})
	end
end

function ChoGGi.ComFuncs.SetCommanderBonuses(sType)
	local currentname = g_CurrentMissionParams.idCommanderProfile
	local comm = MissionParams.idCommanderProfile.items[currentname]
	local bonus = Presets.CommanderProfilePreset.Default[sType]
	local tab = bonus or ""
	local c = #comm

	for i = 1, #tab do
		CreateRealTimeThread(function()
			c = c + 1
			comm[c] = tab[i]
		end)
	end
end

function ChoGGi.ComFuncs.SetSponsorBonuses(sType)
	local ChoGGi = ChoGGi

	local currentname = g_CurrentMissionParams.idMissionSponsor
	local sponsor = MissionParams.idMissionSponsor.items[currentname]
	local bonus = Presets.MissionSponsorPreset.Default[sType]
	--bonuses multiple sponsors have (CompareAmounts returns equal or larger amount)
	if sponsor.cargo then
		sponsor.cargo = ChoGGi.ComFuncs.CompareAmounts(sponsor.cargo,bonus.cargo)
	end
	if sponsor.additional_research_points then
		sponsor.additional_research_points = ChoGGi.ComFuncs.CompareAmounts(sponsor.additional_research_points,bonus.additional_research_points)
	end

	local c = #sponsor
	if sType == "IMM" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","FoodPerRocketPassenger",
			"Amount",9000
		})
	elseif sType == "NASA" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","SponsorFundingPerInterval",
			"Amount",500
		})
	elseif sType == "BlueSun" then
		sponsor.rocket_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.rocket_price,bonus.rocket_price)
		sponsor.applicants_price = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_price,bonus.applicants_price)
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_GrantTech",{
			"Field","Physics",
			"Research","DeepMetalExtraction"
		})
	elseif sType == "CNSA" then
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
	elseif sType == "ISRO" then
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
	elseif sType == "ESA" then
		sponsor.funding_per_tech = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_tech,bonus.funding_per_tech)
		sponsor.funding_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.funding_per_breakthrough,bonus.funding_per_breakthrough)
	elseif sType == "SpaceY" then
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
	elseif sType == "NewArk" then
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_ModifyLabel",{
			"Label","Consts",
			"Prop","BirthThreshold",
			"Percent",-50
		})
	elseif sType == "Roscosmos" then
		sponsor.modifier_name1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_name1,bonus.modifier_name1)
		sponsor.modifier_value1 = ChoGGi.ComFuncs.CompareAmounts(sponsor.modifier_value1,bonus.modifier_value1)
		c = c + 1
		sponsor[c] = PlaceObj("TechEffect_GrantTech",{
			"Field","Robotics",
			"Research","FueledExtractors"
		})
	elseif sType == "Paradox" then
		sponsor.applicants_per_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.applicants_per_breakthrough,bonus.applicants_per_breakthrough)
		sponsor.anomaly_bonus_breakthrough = ChoGGi.ComFuncs.CompareAmounts(sponsor.anomaly_bonus_breakthrough,bonus.anomaly_bonus_breakthrough)
	end
end

do -- flightgrids
	local Flight_DbgLines
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
		line:SetDepthTest(false)
		line:SetPos(AveragePoint2D(points))
		Flight_DbgLines = Flight_DbgLines or {}
		Flight_DbgLines[#Flight_DbgLines+1] = line
	end

	local function Flight_DbgClear()
		if Flight_DbgLines then
			for i = 1, #Flight_DbgLines do
				Flight_DbgLines[i]:delete()
			end
			Flight_DbgLines = false
		end
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
			local pos_c
			local pos_t
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
		-- restore to original pos by toggling menu
		ChoGGi.ComFuncs.CheatsMenu_Toggle()
		ChoGGi.ComFuncs.CheatsMenu_Toggle()
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

function ChoGGi.ComFuncs.Editor_Toggle()
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

do -- AddScrollDialogXTemplates
	-- get around to finishing this (scrollable selection panel)
	local GetSafeAreaBox = GetSafeAreaBox
	function ChoGGi.ComFuncs.AddScrollDialogXTemplates(obj)
		local g_Classes = g_Classes

		obj.idChoGGi_ScrollArea = g_Classes.XWindow:new({
			Id = "idChoGGi_ScrollArea",
		}, obj)

		obj.idChoGGi_ScrollV = g_Classes.ChoGGi_SleekScroll:new({
			Id = "idChoGGi_ScrollV",
			Target = "idChoGGi_ScrollBox",
			Dock = "left",
		}, obj.idChoGGi_ScrollArea)

		local safe = GetSafeAreaBox():maxy()
		obj.idChoGGi_ScrollBox = g_Classes.XScrollArea:new({
			Id = "idChoGGi_ScrollBox",
			VScroll = "idChoGGi_ScrollV",
			LayoutMethod = "VList",
			MaxHeight = ((safe * ChoGGi.Temp.UIScale) / 2) - 25,
		}, obj.idChoGGi_ScrollArea)

		-- move content list to scrollarea
		obj.idContent:SetParent(obj.idChoGGi_ScrollBox)

	end
end -- do

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
	-- if it's in a table, it's almost always [1], i'm sure i'll have lots of shit to fix on any update anyways, so fuck it
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
		-- at least number is number, and i don't give a shit about the rest
		return value
	end
end

function ChoGGi.ComFuncs.UpdateServiceComfortBld(obj,service_stats)
	if not obj or not service_stats then
		return
	end

	local type = type
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
	local WaitMsg = WaitMsg
	local blinky_obj
	local blinky_thread
	function ChoGGi.ComFuncs.AddBlinkyToObj(obj,timeout)
		if not IsValid(obj) then
			return
		end
		-- if it was attached to something deleted, or fresh start
		if not IsValid(blinky_obj) then
			blinky_obj = ChoGGi_RotatyThing:new()
		end
		-- stop any previous countdown
		DeleteThread(blinky_thread)
		-- make it visible incase it isn't
		blinky_obj:SetOpacity(100)
		-- pick a spot to show it
		local spot
		local offset = 0
		if obj:HasSpot("Top") then
			spot = obj:GetSpotBeginIndex("Top")
		else
			spot = obj:GetSpotBeginIndex("Origin")
			local bb = obj:GetEntityBBox()
			offset = bb:sizey()
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
			blinky_obj:SetOpacity(0)
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
	local function AnimDebug_Show(obj,colour)
		local text = PlaceObject("Text")
		text:SetColor(colour or ChoGGi.ComFuncs.RandomColour())
		text:SetFontId(UIL.GetFontID(StringFormat("%s, 14, bold, aa",ChoGGi.font)))
		text:SetCenter(true)
		local orient = Orientation:new()

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

	local function AnimDebug_ShowAll(cls)
		local objs = UICity.labels[cls] or ""
		for i = 1, #objs do
			AnimDebug_Show(objs[i])
		end
	end

	local function AnimDebug_Hide(obj)
		obj:ForEachAttach(function(a)
			if a.ChoGGi_AnimDebug then
				a:delete()
			end
		end)
	end

	local function AnimDebug_HideAll(cls)
		local objs = UICity.labels[cls] or ""
		for i = 1, #objs do
			AnimDebug_Hide(objs[i])
		end
	end

	function ChoGGi.ComFuncs.ShowAnimDebug_Toggle(sel)
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

--~	 print(tempname)
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

do -- DeleteLargeRocks/DeleteSmallRocks
	-- got me what pass edits are, but they speed it up crazy fast (50k ticks to 500)
	local function CallBackFuncLarge(answer)
		if answer then
			SuspendPassEdits("Deposition")
			SuspendPassEdits("WasteRockObstructorSmall")
			SuspendPassEdits("WasteRockObstructor")
			MapDelete("map", {"Deposition","WasteRockObstructorSmall","WasteRockObstructor"})
			ResumePassEdits("Deposition")
			ResumePassEdits("WasteRockObstructorSmall")
			ResumePassEdits("WasteRockObstructor")
		end
	end
	local function CallBackFuncSmall(answer)
		if answer then
			SuspendPassEdits("StoneSmall")
			MapDelete("map", "StoneSmall")
			ResumePassEdits("StoneSmall")
		end
	end

	function ChoGGi.ComFuncs.DeleteLargeRocks()
		ChoGGi.ComFuncs.QuestionBox(
			StringFormat("%s!\n%s",S[6779--[[Warning--]]],S[302535920001238--[[Removes rocks for that smooth map feel.--]]]),
			CallBackFuncLarge,
			StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000855--[[Last chance before deletion!--]]])
		)
	end

	function ChoGGi.ComFuncs.DeleteSmallRocks()
		ChoGGi.ComFuncs.QuestionBox(
			StringFormat("%s!\n%s",S[6779--[[Warning--]]],S[302535920001238--[[Removes rocks for that smooth map feel.--]]]),
			CallBackFuncSmall,
			StringFormat("%s: %s",S[6779--[[Warning--]]],S[302535920000855--[[Last chance before deletion!--]]])
		)
	end
end -- do

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

	-- has no Attaches so just open as is
	if obj:GetNumAttaches() == 0 then
		ChoGGi.ComFuncs.ChangeObjectColour(obj)
		return
	else
		ItemList[#ItemList+1] = {
			text = StringFormat(" %s",obj.class),
			value = obj.class,
			obj = obj,
			hint = 302535920001106--[[Change main object colours.--]],
		}
		-- check and add attachments
		if obj:IsKindOf("ComponentAttach") then
			obj:ForEachAttach(function(a)
				if a:IsKindOf("ColorizableObject") then
					ItemList[#ItemList+1] = {
						text = a.class,
						value = a.class,
						parentobj = obj,
						obj = a,
						hint = StringFormat("%s\n%s: %s",S[302535920001107--[[Change colours of an attached object.--]]],S[302535920000955--[[Handle--]]],a.handle),
					}
				end
			end)
		end
		-- any attaches not attached in the traditional sense (or that GetAttaches says fuck you to)
		local IsValid = IsValid
		for _,attach in pairs(obj) do
			if IsValid(attach) and attach:IsKindOf("ColorizableObject") then
				ItemList[#ItemList+1] = {
					text = attach.class,
					value = attach.class,
					parentobj = obj,
					obj = attach,
					hint = 302535920001107--[[Change colours of an attached object.--]],
				}
			end
		end

	end

	local function FiredOnMenuClick(sel,dialog)
		ChoGGi.ComFuncs.ChangeObjectColour(sel[1].obj,sel[1].parentobj,dialog)
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = function()end,
		items = ItemList,
		title = StringFormat("%s: %s",S[174--[[Color Modifier--]]],RetName(obj)),
		hint = 302535920001108--[[Double click to open object/attachment to edit (select to flash object).--]],
		custom_type = 1,
		custom_func = FiredOnMenuClick,
		select_flash = true,
	}
end

function ChoGGi.ComFuncs.ToggleCollisions(cls)
	-- pretty much the only thing I use it for, but just in case
	cls = cls or "LifeSupportGridElement"
	local CollisionsObject_Toggle = ChoGGi.ComFuncs.CollisionsObject_Toggle
	-- hopefully give it a bit more speed
	SuspendPassEdits(cls)
	MapForEach("map",cls,function(o)
		CollisionsObject_Toggle(o,true)
	end)
	ResumePassEdits(cls)
end
