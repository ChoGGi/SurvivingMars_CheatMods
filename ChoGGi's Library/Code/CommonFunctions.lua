-- See LICENSE for terms

--~ local TableConcat = ChoGGi.ComFuncs.TableConcat -- added in Init.lua
local S = ChoGGi.Strings

local AsyncRand = AsyncRand
local IsValid = IsValid
local GetTerrainCursor = GetTerrainCursor
local FilterObjectsC = FilterObjectsC
local StringFormat = string.format

-- simplest entity object possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local, so who knows)
DefineClass.ChoGGi_HexSpot = {
	__parents = {"CObject"},
	entity = "GridTile"
}

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
	--build the popup
	local data = {
		id = AsyncRand(),
		title = CheckText(title),
		text = CheckText(text,S[3718--[[NONE--]]]),
		image = type(tostring(icon):find(".tga")) == "number" and icon or StringFormat("%sCode/TheIncal.png",ChoGGi.LibraryPath)
	}
	table.set_defaults(data, params)
	table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
	if objects then
		if type(objects) ~= "table" then
			objects = {objects}
		end
		params.cycle_objs = objects
	end
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
--~ local MsgPopup = ChoGGi.ComFuncs.MsgPopup

function ChoGGi.ComFuncs.PopupToggle(parent,popup_id,items,anchor,reopen)
	local popup = rawget(terminal.desktop,popup_id)
	local opened = popup
	if opened then
		popup:Close()
	end

	if not parent then
		return
	end

	if not opened or reopen then
		local ChoGGi = ChoGGi
		local g_Classes = g_Classes
		local ShowMe = ChoGGi.ComFuncs.ShowMe
		local ClearShowMe = ChoGGi.ComFuncs.ClearShowMe
		local DotNameToObject = ChoGGi.ComFuncs.DotNameToObject
		local ViewObjectMars = ViewObjectMars
		local black = black
		local IsKeyPressed = terminal.IsKeyPressed
		local vkShift = const.vkShift

		popup = g_Classes.XPopupList:new({
			-- default to showing it, since we close it ourselves
			Opened = true,
			Id = popup_id,
			-- -1000 is for XRollovers which get max_int
			ZOrder = max_int - 1000,
			LayoutMethod = "VList",
		}, terminal.desktop)

		-- hide any highlights
		function popup.OnKillFocus(pop,new_focus)
			ClearShowMe()
			if not reopen or reopen and not IsKeyPressed(vkShift) then
				g_Classes.XPopupList.OnKillFocus(pop,new_focus)
				popup:Close()
			end
		end

		for i = 1, #items do
			local item = items[i]
			local cls = g_Classes[item.class or "ChoGGi_ButtonMenu"]
			-- defaults to ChoGGi_ButtonMenu. class = "ChoGGi_CheckButtonMenu",

			local button = cls:new({
				TextColor = black,
				RolloverTitle = item.hint_title and CheckText(item.hint_title,item.obj and RetName(item.obj) or S[126095410863--[[Info--]]]),
				RolloverText = CheckText(item.hint,""),
				Text = CheckText(item.name),
				OnMouseButtonUp = function()
					popup:Close()
				end,
			}, popup.idContainer)

			if item.image then
				button.idIcon:SetImage(item.image)
			end

			if item.clicked then
				function button.OnMouseButtonDown(...)
					cls.OnMouseButtonDown(...)
					item.clicked(...)
				end
			end

			if item.showme then
				function button.OnMouseEnter(self, pt, child)
					cls.OnMouseEnter(self, pt, child)
					ClearShowMe()
					ShowMe(item.showme, nil, true, true)
				end
			end

			if item.pos then
				function button.OnMouseEnter(self, pt, child)
					cls.OnMouseEnter(self, pt, child)
					ViewObjectMars(item.pos)
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

		end

		popup:SetAnchor(parent.box)
		-- top for the console, XPopupList defaults to smart which just looks ugly for console
		popup:SetAnchorType(anchor or "top")
	--~		 "smart",
	--~		 "left",
	--~		 "right",
	--~		 "top",
	--~		 "center-top",
	--~		 "bottom",
	--~		 "mouse"

		popup:Open()
		popup:SetFocus()
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
	text = CheckText(text,text)
	title = CheckText(title,S[1000016--[[Title--]]])

	local PopupNotificationPresets = PopupNotificationPresets

	local preset
	if image then
		preset = "ChoGGi_TempPopup"
		local temppop = {
			name = preset,
			image = image,
		}
		PopupNotificationPresets[preset] = temppop
	end

	CreateRealTimeThread(function()
		WaitPopupNotification(preset, {title = title, text = text})
		if preset then
			PopupNotificationPresets[preset] = nil
		end
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
			table.remove(UICity.labels[label],i)
		end
	end
end

function ChoGGi.ComFuncs.RemoveMissingTableObjects(list,obj)
	if obj then
		for i = #list, 1, -1 do
			if #list[i][list] == 0 then
				table.remove(list,i)
			end
		end
	else
		for i = #list, 1, -1 do
			if not IsValid(list[i]) then
				table.remove(list,i)
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
			table.remove(UICity.labels[label],i)
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

-- while ChoGGi.ComFuncs.CheckForTypeInList(terminal.desktop,"Examine") do
function ChoGGi.ComFuncs.CheckForTypeInList(list,cls)
	if type(list) ~= "table" then
		return false
	end
	local ret = false
	for i = 1, #list do
		if list[i]:IsKindOf(cls) then
			ret = true
		end
	end
	return ret
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
-- function ChoGGi.ComFuncs.SetConstsG(Name,Value,IsResearched)
function ChoGGi.ComFuncs.SetConstsG(name,value)
	--we only want to change it if user set value
	if value then
		--some mods change Consts or g_Consts, so we'll just do both to be sure
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

custom_type = 1 : updates selected item with custom value type, hides ok/cancel buttons, dblclick fires custom_func with {self.sel}, and sends back all items
custom_type = 2 : colour selector
custom_type = 3 : updates selected item with custom value type, and sends back selected item.
custom_type = 4 : updates selected item with custom value type, and sends back all items
custom_type = 5 : for Lightmodel: show colour selector when listitem.editor = color,pressing check2 applies the lightmodel without closing dialog, dbl rightclick shows lightmodel lists and lets you pick one to use in new window
custom_type = 6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)
custom_type = 7 : dblclick fires custom_func with {self.sel} (wrapped in a table, so we can use CallBackFunc for either)

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
	local block = false
	local restrict = false

	local rtotal = 0
	for _,_ in pairs(settings.restricttraits or empty_table) do
		rtotal = rtotal + 1
	end

	local rcount = 0
	for trait,_ in pairs(traits or empty_table) do
		if settings.restricttraits[trait] then
			rcount = rcount + 1
		end
		if settings.blocktraits[trait] then
			block = true
		end
	end
	--restrict is empty so allow all or since we're restricting then they need to be the same
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
			q, r = WorldToHex(pos or GetTerrainCursor())
		end
		return HexGridGetObject(ObjectGrid, q, r)
	end

	function ChoGGi.ComFuncs.RetObjectsAtPos(pos,q,r)
		if pos then
			q, r = WorldToHex(pos or GetTerrainCursor())
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

do -- ShowMe
	local IsPoint = IsPoint
	local green = green
	local guic = guic
	local IsPointInBounds = terrain.IsPointInBounds
	local ViewObjectMars = ViewObjectMars

	local markers = {}
	function ChoGGi.ComFuncs.ClearShowMe()
		for k, v in pairs(markers) do
			if IsValid(k) then
				if v == "point" then
					k:delete()
				else
					k:SetColorModifier(v)
				end
				markers[k] = nil
			end
		end
	end

	function ChoGGi.ComFuncs.ShowMe(o, color, time, both)
		if not o then
			return ChoGGi.ComFuncs.ClearShowMe()
		end
		local g_Classes = g_Classes
		color = color or green

		if type(o) == "table" and #o == 2 then
			if IsPoint(o[1]) and IsPointInBounds(o[1]) and IsPoint(o[2]) and IsPointInBounds(o[2]) then
				local m = g_Classes.Vector:new()
				m:Set(o[1], o[2], color)
				markers[m] = "vector"
				o = m
			end
		else
			-- both is for objs i also want a sphere over
			if IsPoint(o) or both then
				local o2 = IsPoint(o) and o or IsValid(o) and o:GetVisualPos()
				if o2 and IsPointInBounds(o2) then
					local m = g_Classes.Sphere:new()
					m:SetPos(o2)
					m:SetRadius(50 * guic)
					m:SetColor(color)
					markers[m] = "point"
					if not time then
						ViewObjectMars(o2)
					end
					o2 = m
				end
			end

			if IsValid(o) then
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

do -- Ticks
	local times = {}
	local GetPreciseTicks = GetPreciseTicks
	function ChoGGi.ComFuncs.TickStart(id)
		times[id] = GetPreciseTicks()
	end
	function ChoGGi.ComFuncs.TickEnd(id)
		print(id,": ",GetPreciseTicks() - times[id])
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
	local AsyncFileToString = _G.AsyncFileToString
	local GetLogFile = GetLogFile
	function ChoGGi.ComFuncs.ShowConsoleLogWin(visible)
		if visible and not dlgChoGGi_ConsoleLogWin then
			dlgChoGGi_ConsoleLogWin = ChoGGi_ConsoleLogWin:new({}, terminal.desktop,{})

			-- update it with console log text
			local dlg = dlgConsoleLog
			if dlg then
				dlgChoGGi_ConsoleLogWin.idText:SetText(dlg.idText:GetText())
			elseif not ChoGGi.blacklist then
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

-- "some.some.some.etc" = returns etc as object
function ChoGGi.ComFuncs.DotNameToObject(str,root,create)
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

function ChoGGi.ComFuncs.CreateSetting(str,setting_type)
	local setting = ChoGGi.ComFuncs.DotNameToObject(str,nil,true)
	if type(setting) == setting_type then
		return true
	end
end

--returns whatever is selected > moused over > nearest non particle object to cursor (the selection hex is a ParSystem)
function ChoGGi.ComFuncs.SelObject()
	local c = GetTerrainCursor()
	return SelectedObj or SelectionMouseObj() or MapFindNearest(c, c, 1500)
end

-- removes all the dev shortcuts/etc and adds mine
function ChoGGi.ComFuncs.Rebuildshortcuts(Actions,ECM)
	local XShortcutsTarget = XShortcutsTarget

	-- remove all built-in shortcuts (pretty much just a cutdown copy of ReloadShortcuts)
	XShortcutsTarget.actions = {}
	-- re-add certain ones
	if not Platform.ged then
		if XTemplates.GameShortcuts then
			XTemplateSpawn("GameShortcuts", XShortcutsTarget)
		end
	elseif XTemplates.GedShortcuts then
		XTemplateSpawn("GedShortcuts", XShortcutsTarget)
	end

	if ECM then
		-- remove stuff from GameShortcuts
		local table_remove = table.remove
		for i = #XShortcutsTarget.actions, 1, -1 do
			-- removes pretty much all the dev actions added, and leaves the game ones intact
			local id = XShortcutsTarget.actions[i].ActionId
			if id and (not id:starts_with("action") --[[or id:starts_with("actionPOC")--]] or id == "actionToggleFullscreen") then
				table_remove(XShortcutsTarget.actions,i)
			end
		end
	end

	-- and add mine
	local XAction = XAction
	local Actions = Actions or ChoGGi.Temp.Actions

--~ Actions = {}
--~ Actions[#Actions+1] = {
--~	 ActionId = "ChoGGi_ShowConsoleTilde",
--~	 OnAction = function()
--~	 local dlgConsole = dlgConsole
--~	 if dlgConsole then
--~		 ShowConsole(not dlgConsole:GetVisible())
--~	 end
--~	 end,
--~	 ActionShortcut = ChoGGi.Defaults.KeyBindings.ShowConsoleTilde,
--~ }

	for i = 1, #Actions do
		-- and add to the actual actions
		XShortcutsTarget:AddAction(XAction:new(Actions[i]))
	end

	-- add rightclick action to menuitems
	XShortcutsTarget:UpdateToolbar()
	-- got me
	XShortcutsThread = false
end

