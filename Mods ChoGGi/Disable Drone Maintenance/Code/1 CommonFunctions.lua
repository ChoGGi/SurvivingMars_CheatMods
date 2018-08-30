-- See LICENSE for terms

local LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [DisableDroneMaintenance]

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

local TableConcat
-- just in case they remove oldTableConcat
pcall(function()
  TableConcat = oldTableConcat
end)
-- thanks for replacing concat... what's wrong with using table.concat2?
TableConcat = TableConcat or table.concat

-- this is used instead of "str .. str"; anytime you do that lua will hash the new string, and store it till exit (which means this is faster, and uses less memory)
local concat_table = {}
local function Concat(...)
  -- sm devs added a c func to clear tables, which does seem to be faster than a lua loop
  table.iclear(concat_table)
  -- build table from args
  local concat_value
  local concat_type
  for i = 1, select("#",...) do
    concat_value = select(i,...)
    -- no sense in calling a func more then we need to
    concat_type = type(concat_value)
    if concat_type == "string" or concat_type == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TableConcat(concat_table)
end

-- Everything stored in one global table
DisableDroneMaintenance = {
  _LICENSE = LICENSE,
  email = "SM_Mods@DisableDroneMaintenance.org",
  id = "ChoGGi_DisableDroneMaintenance",
  ModPath = CurrentModPath,

  -- CommonFunctions.lua
  ComFuncs = {
    TableConcat = TableConcat,
    Concat = Concat,
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
local DisableDroneMaintenance = DisableDroneMaintenance

-- I want a translate func to always return a string
do -- Translate
	local T,_InternalTranslate = T,_InternalTranslate
	local type,select = type,select
	-- translate func that always returns a string
	function DisableDroneMaintenance.ComFuncs.Translate(...)
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
			return Concat(select(1,...)," < Missing locale string id")
		end
		return str
	end
end -- do
local T = DisableDroneMaintenance.ComFuncs.Translate

-- returns object name or at least always some string
function DisableDroneMaintenance.ComFuncs.RetName(obj)
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
			return TableConcat{
				T(obj.name[1]),
				" ",
				T(obj.name[3]),
			}

		-- translated name
		elseif obj.display_name and obj.display_name ~= "" then
			return T(obj.display_name)

		-- encyclopedia_id
		elseif type(obj.encyclopedia_id) == "string" then
			return obj.encyclopedia_id

		elseif type(obj.id) == "string" then
			return obj.id

		-- class
		elseif type(obj.class) == "string" then
			return obj.class

		-- added this here as doing tostring lags the shit outta kansas if this is a large objlist
		elseif IsObjlist(obj) then
			return "objlist"
		end

	end

	return tostring(obj)
end

-- check if text is already translated or needs to be, and return the text
function DisableDroneMaintenance.ComFuncs.CheckText(text,fallback)
	if type(text) == "string" then
		return text
	else
		text = S[text]
	end
	-- probably missing locale id
	if type(text) ~= "string" then
		text = tostring(fallback or "")
	end
	return text
end
local CheckText = DisableDroneMaintenance.ComFuncs.CheckText

--~ function .ComFuncs.PopupToggle(parent,popup_id,items)
local ViewObjectMars = ViewObjectMars
function DisableDroneMaintenance.ComFuncs.PopupToggle(parent,popup_id,items,anchor)
	local opened_popup = rawget(terminal.desktop,popup_id)
	if opened_popup then
		opened_popup:Close()
	else
		local DisableDroneMaintenance = DisableDroneMaintenance
		local g_Classes = g_Classes
		local ClearShowMe = DisableDroneMaintenance.ComFuncs.ClearShowMe
		local ShowMe = DisableDroneMaintenance.ComFuncs.ShowMe
		local ConvertNameToObject = DisableDroneMaintenance.ComFuncs.ConvertNameToObject
		local black = black

		local popup = g_Classes.XPopupList:new({
			-- default to showing it, since we close it ourselves
			Opened = true,
			Id = popup_id,
			-- -1000 is for XRollovers which get max_int
			ZOrder = max_int - 1000,
			LayoutMethod = "VList",
		}, terminal.desktop)

		for i = 1, #items do
			local item = items[i]
			local cls = g_Classes[item.class or "DisableDroneMaintenance_ButtonMenu"]
			-- defaults to DisableDroneMaintenance_ButtonMenu. class = "DisableDroneMaintenance_CheckButtonMenu",
			local button = cls:new({
				TextColor = black,
				RolloverText = CheckText(item.hint),
				Text = CheckText(item.name),
				OnMouseButtonUp = function()
					popup:Close()
				end,
			}, popup.idContainer)

			if item.clicked then
				button.OnMouseButtonDown = item.clicked
			end

			if item.showme then
				function button.OnMouseEnter(self, pt, child)
					cls.OnMouseEnter(self, pt, child)
					ClearShowMe()
					ShowMe(item.showme, nil, true, true)
				end
			elseif item.pos then
				function button.OnMouseEnter(self, pt, child)
					cls.OnMouseEnter(self, pt, child)
					ViewObjectMars(item.pos)
				end
			end

			-- checkboxes (with a value (naturally))
			if item.value then

				local is_vis
				local value = ConvertNameToObject(item.value)

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

		popup:Open()
		popup:SetFocus()
	end
end

local markers = {}
function DisableDroneMaintenance.ComFuncs.ClearShowMe()
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

local green = green
local IsPointInBounds = terrain.IsPointInBounds
function DisableDroneMaintenance.ComFuncs.ShowMe(o, color, time, both)
	if not o then
		return DisableDroneMaintenance.ComFuncs.ClearShowMe()
	end
	local g_Classes = g_Classes

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
				m:SetColor(color or green)
				markers[m] = "point"
				if not time then
					ViewObjectMars(o2)
				end
				o2 = m
			end
		end

		if IsValid(o) then
			markers[o] = markers[o] or o:GetColorModifier()
			o:SetColorModifier(color or green)
			local pos = o:GetVisualPos()
			if not time and IsPointInBounds(pos) then
				ViewObjectMars(pos)
			end
		end
	end
end

-- "some.some.some.etc" = returns etc as object
-- https://www.lua.org/pil/14.1.html
function DisableDroneMaintenance.ComFuncs.ConvertNameToObject(name)
	-- always start with _G
	local obj = _G
	for str, match in name:gmatch("([%w_]+)(.?)") do
		-- . means we're not at the end yet
		if match == "." then
			-- something in the table is missing so return
			if not obj[str] then
				return
			end
			-- get the next table in the name
			obj = obj[str]
		else
			-- no more . so we got the object
			return obj[str]
		end
	end
end
