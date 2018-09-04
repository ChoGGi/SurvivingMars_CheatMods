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

-- hello
LockWorkplace = {
  _LICENSE = LICENSE,
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_LockWorkplace",
	ModPath = CurrentModPath,
  -- CommonFunctions.lua
  ComFuncs = {
    -- thanks for replacing concat... what's wrong with using table.concat2?
    TableConcat = TableConcat,
  },
}

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
	-- translate func that always returns a string
	LockWorkplace.ComFuncs.Trans = DotNameToObject("ChoGGi.ComFuncs.Translate") or function(...)
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
			return string.format("%s < Missing locale string id",select(1,...))
		end
		return str
	end
end -- do
local Trans = LockWorkplace.ComFuncs.Translate

do -- RetName
	local IsObjlist = IsObjlist
	-- returns object name or at least always some string
	LockWorkplace.ComFuncs.RetName = DotNameToObject("ChoGGi.ComFuncs.RetName") or function(obj)
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

LockWorkplace.ComFuncs.RemoveXTemplateSections = DotNameToObject("ChoGGi.ComFuncs.RemoveXTemplateSections") or function(list,name)
	local idx = table.find(list, name, true)
	if idx then
		table.remove(list,idx)
	end
end

