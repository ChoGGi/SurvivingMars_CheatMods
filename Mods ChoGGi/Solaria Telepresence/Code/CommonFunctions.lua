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
SolariaTelepresence = {
  _LICENSE = LICENSE,
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_SolariaTelepresence",
	ModPath = CurrentModPath,

  -- orig funcs that we replace
  OrigFuncs = {},
  -- CommonFunctions.lua
  ComFuncs = {
    -- thanks for replacing concat... what's wrong with using table.concat2?
    TableConcat = TableConcat,
  },
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
local SolariaTelepresence = SolariaTelepresence

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
	SolariaTelepresence.ComFuncs.Translate = function(...)
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
local Trans = SolariaTelepresence.ComFuncs.Translate

-- shows a popup msg with the rest of the notifications
-- objects can be a single obj, or {obj1,obj2,etc}
	SolariaTelepresence.ComFuncs.MsgPopup = function(text,title,icon,size,objects)
	local SolariaTelepresence = SolariaTelepresence
	if not SolariaTelepresence.Temp.MsgPopups then
		SolariaTelepresence.Temp.MsgPopups = {}
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
		text = CheckText(text,Trans(3718--[[NONE--]])),
		image = type(tostring(icon):find(".tga")) == "number" and icon or string.format("%sCode/TheIncal.png",SolariaTelepresence.ModPath)
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
		SolariaTelepresence.Temp.MsgPopups[#SolariaTelepresence.Temp.MsgPopups+1] = popup
	end)
end

-- well that's the question isn't it?
SolariaTelepresence.ComFuncs.QuestionBox = function(text,func,title,ok_msg,cancel_msg,image,context,parent)
	-- thread needed for WaitMarsQuestion
	CreateRealTimeThread(function()
		if WaitMarsQuestion(
			parent,
			CheckText(title,Trans(1000016--[[Title--]])),
			CheckText(text,Trans(3718--[[NONE--]])),
			CheckText(ok_msg,Trans(6878--[[OK--]])),
			CheckText(cancel_msg,Trans(6879--[[Cancel--]])),
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

SolariaTelepresence.ComFuncs.FilterFromTable = function(list,exclude_list,include_list,name)
	if #list < 1 then
		return
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

SolariaTelepresence.ComFuncs.CompareTableValue = function(a,b,name)
	if not a and not b then
		return
	end
	if type(a[name]) == type(b[name]) then
		return a[name] < b[name]
	else
		return tostring(a[name]) < tostring(b[name])
	end
end


do -- RetName
	local IsObjlist = IsObjlist
	-- try to return a decent name for the obj, failing that return some sort of string
	SolariaTelepresence.ComFuncs.RetName = function(obj)
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
--~ 		return tostring(obj):sub(1,150) --limit length of string in case it's a large one
		return tostring(obj)
	end
end -- do


SolariaTelepresence.ComFuncs.PopupToggle = function(parent,popup_id,items,anchor)
	local opened_popup = rawget(terminal.desktop,popup_id)
	if opened_popup then
		opened_popup:Close()
	else
		local g_Classes = g_Classes
		local ViewObjectMars = ViewObjectMars
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
			local cls = g_Classes[item.class or "SolariaTelepresence_ButtonMenu"]
			-- defaults to ChoGGi_ButtonMenu. class = "SolariaTelepresence_CheckButtonMenu",
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
--~ 				function button.OnMouseEnter(self, pt, child)
--~ 					cls.OnMouseEnter(self, pt, child)
--~ 					ClearShowMe()
--~ 					ShowMe(item.showme, nil, true, true)
--~ 				end
			elseif item.pos then
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

SolariaTelepresence.ComFuncs.RemoveXTemplateSections = function(list,name)
	local idx = table.find(list, name, true)
	if idx then
		table.remove(list,idx)
	end
end

-- backup orginal function for later use (checks if we already have a backup, or else problems)
local SolariaTelepresence_OrigFuncs = SolariaTelepresence.OrigFuncs
local function SaveOrigFunc(class_name,func_name)
	local new_name = string.format("%s_%s",class_name,func_name)
	if not SolariaTelepresence_OrigFuncs[new_name] then
		SolariaTelepresence_OrigFuncs[new_name] = _G[class_name][func_name]
	end
end

function OnMsg.ClassesBuilt()

  --so we can build without NoNearbyWorkers limit
  SaveOrigFunc("ConstructionController","UpdateConstructionStatuses")
  function ConstructionController:UpdateConstructionStatuses(dont_finalize)
    --send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
    SolariaTelepresence_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,"dont_finalize")

    local status = self.construction_statuses

    if self.is_template then
      local cobj = rawget(self.cursor_obj, true)
      local tobj = setmetatable({
        [true] = cobj,
        ["city"] = UICity
      }, {
        __index = self.template_obj
      })
      tobj:GatherConstructionStatuses(self.construction_statuses)
    end

    -- remove errors we want to remove
    local statusNew = {}
    local ConstructionStatus = ConstructionStatus
    if type(status) == "table" and #status > 0 then
      for i = 1, #status do

        if status[i] ~= ConstructionStatus.NoNearbyWorkers then
          statusNew[#statusNew+1] = status[i]
        end

      end
    end
    -- make sure we don't get errors down the line
    if type(statusNew) == "boolean" then
      statusNew = {}
    end

    self.construction_statuses = statusNew
    status = self.construction_statuses

    if not dont_finalize then
      self:FinalizeStatusGathering(status)
    else
      return status
    end
  end

end
