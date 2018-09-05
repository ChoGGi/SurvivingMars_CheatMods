-- See LICENSE for terms

local LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]]

-- just in case they remove oldTableConcat
local TableConcat
pcall(function()
  TableConcat = oldTableConcat
end)
TableConcat = TableConcat or table.concat

-- Everything stored in one global table
PinExpander = {
  _LICENSE = LICENSE,
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_PinExpander",
  ModPath = CurrentModPath,

  -- CommonFunctions.lua
  ComFuncs = {
    TableConcat = TableConcat,
  },
  -- orig funcs that we replace
  OrigFuncs = {},
  -- /Code/_Functions.lua
  CodeFuncs = {},
  -- /Code/*Menu.lua and /Code/*Func.lua
  MenuFuncs = {},
  -- OnMsgs.lua
  MsgFuncs = {},
  -- InfoPaneCheats.lua
  InfoFuncs = {},
  -- Defaults.lua
  SettingFuncs = {},
  -- temporary settings that aren't saved to SettingsFile
  Temp = {
    -- collect msgs to be displayed when game is loaded
    StartupMsgs = {},
  },
  -- settings that are saved to SettingsFile
  UserSettings = {
    BuildingSettings = {},
    Transparency = {},
  },
}

local PinExpander = PinExpander
-- devs didn't bother changing droid font to one that supports unicode, so we do this for not eng
-- pretty sure anything using droid is just for dev work so...
if GetLanguage() ~= "English" then
	local string = string
	-- first get the unicode font name
	local f = TranslationTable[984--[[SchemeBk, 15, aa--]]]
	f = f:sub(1,f:find(",")-1)
	PinExpander.font = f

	-- replace any fonts using droid
	local __game_font_styles = __game_font_styles
	__game_font_styles[false] = string.format("%s, 12, aa",f)
	__game_font_styles.Editor9 = string.format("%s, 9, aa",f)
	__game_font_styles.Editor11Bold = string.format("%s, 11, bold, aa",f)
	__game_font_styles.Editor11 = string.format("%s, 11, aa",f)
	__game_font_styles.Editor12Bold = string.format("%s, 12, bold, aa",f)
	__game_font_styles.Editor12 = string.format("%s, 12, aa",f)
	__game_font_styles.Editor13 = string.format("%s, 13, aa",f)
	__game_font_styles.Editor13Bold = string.format("%s, 13, bold, aa",f)
	__game_font_styles.Editor14 = string.format("%s, 14, aa",f)
	__game_font_styles.Editor14Bold = string.format("%s, 14, bold, aa",f)
	__game_font_styles.Editor16 = string.format("%s, 16, aa",f)
	__game_font_styles.Editor16Bold = string.format("%s, 16, bold, aa",f)
	__game_font_styles.Editor17 = string.format("%s, 17, aa",f)
	__game_font_styles.Editor17Bold = string.format("%s, 17, bold, aa",f)
	__game_font_styles.Editor18 = string.format("%s, 18, aa",f)
	__game_font_styles.Editor18Bold = string.format("%s, 18, bold, aa",f)
	__game_font_styles.Editor21Bold = string.format("%s, 21, bold, aa",f)
	__game_font_styles.Editor32Bold = string.format("%s, 32, bold",f)
	__game_font_styles.Rollover = string.format("%s, 14, bold, aa",f)
--~	 __game_font_styles.DesignerCaption = string.format("%s, 18, bold, aa",f)
--~	 __game_font_styles.DesignerPropEditor = string.format("%s,f,", 12, aa"")
	__game_font_styles.Console = string.format("%s, 13, bold, aa",f)
--~	 __game_font_styles.UAMenu = string.format("%s, 14, aa",f)
--~	 __game_font_styles.UAToolbar = string.format("%s, 14, bold, aa",f)
	__game_font_styles.EditorCaption = string.format("%s, 14, bold, aa",f)

	-- normally called when translation is changed, but i try to keep Init.lua simple
	InitGameFontStyles()
end

-- if user has ECM enabled then use functions from it instead
local function DotNameToObject(str,root,create)
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

do -- Translate
	local T,_InternalTranslate = T,_InternalTranslate
	local type,select = type,select
	local StringFormat = string.format
	-- translate func that always returns a string
	PinExpander.ComFuncs.Translate = function(...)
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
local Trans = PinExpander.ComFuncs.Translate

do -- RetName
	local IsObjlist = IsObjlist
	-- returns object name or at least always some string
	PinExpander.ComFuncs.RetName = function(obj)
		if obj == _G then
			return "_G"
		end

		if type(obj) == "table" then

			local name_type = type(obj.name)
			-- custom name from user (probably)
			if name_type == "string" and obj.name ~= "" then
				return obj.name
			-- colonist names
			elseif name_type == "table" and #obj.name == 3 then
				return string.format("%s %s",Trans(obj.name[1]),Trans(obj.name[3]))

			-- translated name
			elseif obj.display_name and obj.display_name ~= "" then
				return Trans(obj.display_name)

			-- encyclopedia_id
			elseif obj.encyclopedia_id and obj.encyclopedia_id ~= "" then
				return obj.encyclopedia_id

			-- plain old id
			elseif obj.id and obj.id ~= "" then
				return obj.id

			-- class
			elseif obj.class and obj.class ~= "" then
				return obj.class

			-- added this here as doing tostring lags the shit outta kansas if this is a large objlist
			elseif IsObjlist(obj) then
				return "objlist"
			end

		end

		-- falling back baby
		return tostring(obj)
	end
end -- do

do -- CheckText
	-- check if text is already translated or needs to be, and return the text
	local type = type
	PinExpander.ComFuncs.CheckText = function(text,fallback)
		local ret
		-- no sense in translating a string
		if type(text) == "string" then
			return text
		else
--~ 			ret = S[text]
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
local CheckText = PinExpander.ComFuncs.CheckText

do -- ShowMe
	local IsPoint = IsPoint
	local green = green
	local guic = guic
	local IsPointInBounds = terrain.IsPointInBounds
	local ViewObjectMars = ViewObjectMars

	local markers = {}
	PinExpander.ComFuncs.ClearShowMe = function()
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

	PinExpander.ComFuncs.ShowMe = function(o, color, time, both)
		if not o then
			return PinExpander.ComFuncs.ClearShowMe()
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

function PinExpander.ComFuncs.PopupToggle(parent,popup_id,items,anchor,reopen)
	local popup = rawget(terminal.desktop,popup_id)
	local opened = popup
	if opened then
		popup:Close()
	end

	if not parent then
		return
	end

	if not opened or reopen then
		local PinExpander = PinExpander
		local g_Classes = g_Classes
		local ShowMe = PinExpander.ComFuncs.ShowMe
		local ClearShowMe = PinExpander.ComFuncs.ClearShowMe
		local DotNameToObject = PinExpander.ComFuncs.DotNameToObject
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
			local cls = g_Classes[item.class or "PinExpander_ButtonMenu"]
			-- class = "PinExpander_CheckButtonMenu",
			local button = cls:new({
				TextColor = black,
				RolloverText = CheckText(item.hint),
				RolloverTitle = CheckText(item.hint_title),
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
