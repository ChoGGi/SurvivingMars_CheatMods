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

-- if we use global func more then once: make them local for that small bit o' speed
local select,tostring,type,pcall,table = select,tostring,type,pcall,table
local Mods = Mods

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

-- hello
SpiceHarvester = {
  _LICENSE = LICENSE,
  email = "SM_Mods@choggi.org",
  id = "ChoGGi_SpiceHarvester",
	ModPath = CurrentModPath,
  -- orig funcs that we replace
  OrigFuncs = {},
  -- CommonFunctions.lua
  ComFuncs = {
    Concat = Concat,
    TableConcat = TableConcat,
  },
  Temp = {},
  UserSettings = {
		Color = -11328253,
		Color1 = -12247037,
		Color2 = -11196403,
		Color3 = -13297406,
		Max_Shuttles = 50,
	},
}
local SpiceHarvester = SpiceHarvester

local type,pcall,table,tostring = type,pcall,table,tostring

local CreateRealTimeThread = CreateRealTimeThread
local AsyncRand = AsyncRand

do -- Translate
	local T,_InternalTranslate = T,_InternalTranslate
	local type,select = type,select
	-- translate func that always returns a string
	function SpiceHarvester.ComFuncs.Translate(...)
		local str
		if type(select(1,...)) == "userdata" then
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
local T = SpiceHarvester.ComFuncs.Translate

-- backup orginal function for later use (checks if we already have a backup, or else problems)
function SpiceHarvester.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local SpiceHarvester = SpiceHarvester
  if Func then
    local newname = Concat(ClassOrFunc,"_",Func)
    if not SpiceHarvester.OrigFuncs[newname] then
      SpiceHarvester.OrigFuncs[newname] = g_Classes[ClassOrFunc][Func]
    end
  else
    if not SpiceHarvester.OrigFuncs[ClassOrFunc] then
      SpiceHarvester.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

local AsyncRand = AsyncRand
function SpiceHarvester.ComFuncs.Random(m, n)
	-- m = min, n = max
	return AsyncRand(n - m + 1) + m
end

--~ function SpiceHarvester.ComFuncs.MsgPopup(text,title,icon,size,objects)
--~ 	local SpiceHarvester = SpiceHarvester
--~ 	if not SpiceHarvester.Temp.MsgPopups then
--~ 		SpiceHarvester.Temp.MsgPopups = {}
--~ 	end
--~ 	local g_Classes = g_Classes
--~ 	-- build our popup
--~ 	local timeout = 10000
--~ 	if size then
--~ 		timeout = 30000
--~ 	end
--~ 	local params = {
--~ 		expiration = timeout,
--~ 	}
--~ 	-- if there's no interface then we probably shouldn't open the popup
--~ 	local dlg = Dialogs.OnScreenNotificationsDlg
--~ 	if not dlg then
--~ 		local igi = Dialogs.InGameInterface
--~ 		if not igi then
--~ 			return
--~ 		end
--~ 		dlg = OpenDialog("OnScreenNotificationsDlg", igi)
--~ 	end
--~ 	--build the popup
--~ 	local data = {
--~ 		id = AsyncRand(),
--~ 		title = CheckText(title),
--~ 		text = CheckText(text,S[3718--[[NONE--]]]),
--~ 		image = type(tostring(icon):find(".tga")) == "number" and icon or Concat(SpiceHarvester.ModPath,"Code/TheIncal.tga")
--~ 	}
--~ 	table.set_defaults(data, params)
--~ 	table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
--~ 	if objects then
--~ 		if type(objects) ~= "table" then
--~ 			objects = {objects}
--~ 		end
--~ 		params.cycle_objs = objects
--~ 	end
--~ 	--and show the popup
--~ 	CreateRealTimeThread(function()
--~ 		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
--~ 		popup:FillData(data, nil, params, params.cycle_objs)
--~ 		popup:Open()
--~ 		dlg:ResolveRelativeFocusOrder()
--~ 		SpiceHarvester.Temp.MsgPopups[#SpiceHarvester.Temp.MsgPopups+1] = popup
--~ 	end)
--~ end

local GetRandomPassable = GetRandomPassable
local GetTerrainCursor = GetTerrainCursor

function SpiceHarvester.ComFuncs.SpawnShuttle(hub)
  for _, s_i in pairs(hub.shuttle_infos) do
    if s_i:CanLaunch() and s_i.hub and s_i.hub.has_free_landing_slots then
      -- ShuttleInfo:Launch(task)
      local hub = s_i.hub
      -- LRManagerInstance
      local shuttle = SpiceHarvester_CargoShuttle:new{
        hub = hub,
        transport_task = SpiceHarvester_ShuttleFollowTask:new{
          state = "ready_to_follow",
          dest_pos = GetTerrainCursor() or GetRandomPassable()
        },
        info_obj = s_i
      }
      s_i.shuttle_obj = shuttle
      local slot = hub:ReserveLandingSpot(shuttle)
      shuttle:SetPos(slot.pos)
      -- CargoShuttle:Launch()
      shuttle:PushDestructor(function(s)
        hub:ShuttleLeadOut(s)
        hub:FreeLandingSpot(s)
      end)
      local amount = 0
      for _ in pairs(UICity.SpiceHarvester.CargoShuttleThreads) do
        amount = amount + 1
      end
      if amount <= SpiceHarvester.UserSettings.Max_Shuttles or 50 then
        UICity.SpiceHarvester.CargoShuttleThreads[shuttle.handle] = true
        shuttle:SetColor1(SpiceHarvester.UserSettings.Color1 or -12247037)
        shuttle:SetColor2(SpiceHarvester.UserSettings.Color2 or -11196403)
        shuttle:SetColor3(SpiceHarvester.UserSettings.Color3 or -13297406)
        -- easy way to get amount of shuttles about
        UICity.SpiceHarvester.CargoShuttleThreads[#UICity.SpiceHarvester.CargoShuttleThreads+1] = true
        shuttle.SpiceHarvester_FollowHarvesterShuttle = true
        shuttle.SpiceHarvester_Harvester = hub.ChoGGi_Parent
        -- follow that cursor little minion
        shuttle:SetCommand("SpiceHarvester_FollowHarvester")
        -- nice n slow
        shuttle.max_speed = 1000

        -- return it so we can do viewpos on it for menu item
        return shuttle
      end
    end
  end
end

DefineClass.SpiceHarvester_ShuttleHub = {
	__parents = {"ShuttleHub"},
}

-- guess this is what happens when you spawn and attach a hub to a random vehicle
function SpiceHarvester_ShuttleHub:InitLandingSpots()
	--define the landing spots
	local slots = {}
	local spot_name = self.landing_spot_name or ""
	if spot_name ~= "" then
		for _ = 1, self.ChoGGi_SlotAmount do
			slots[#slots + 1] = {
				reserved_by = false,
				pos = self.ChoGGi_Parent:GetSpotPos(1),
			}
		end
	end
	self.landing_slots = slots
	self.free_landing_slots = #slots
	self.has_free_landing_slots = #slots > 0
end

DefineClass.SpiceHarvester_CargoShuttle = {
	__parents = {"CargoShuttle"},
}

-- gets rid of error in log when they're removed
function SpiceHarvester_CargoShuttle:SetTransportTask()
end

function SpiceHarvester_CargoShuttle:SpiceHarvester_FollowHarvester()
	local GetHeight = terrain.GetHeight
	local IsValid = IsValid
	CreateGameTimeThread(function()
		while IsValid(self.SpiceHarvester_Harvester) do
			Sleep(1000)
			local pos1 = self:GetVisualPos()
			if pos1:z() - GetHeight(pos1) < 1500 then
				self:PlayFX("Dust", "start")
				while IsValid(self) do
					Sleep(1000)
					local pos2 = self:GetVisualPos()
					if pos2:z() - GetHeight(pos2) > 1500 then
						break
					end
				end
				self:PlayFX("Dust", "end")
			end
		end
	end)

	repeat
		self.hover_height = Random(800,15000)
		if IsValid(self.SpiceHarvester_Harvester) then
			local x,y,_ = self.SpiceHarvester_Harvester:GetVisualPosXYZ()
			self:FollowPathCmd(self:CalcPath(self:GetVisualPos(), point(x+Random(-25000,25000),y+Random(-25000,25000))))
			Sleep(Random(2500,10000))
		else
			self.SpiceHarvester_FollowHarvesterShuttle = false
		end
	until not self.SpiceHarvester_FollowHarvesterShuttle or not self.SpiceHarvester_Harvester

	CreateRealTimeThread(function()
		self:PlayFX("GroundExplosion", "start")
		PlaySound("Mystery Bombardment ExplodeAir", "ObjectOneshot", nil, 0, false, self, 1000)
		self:PlayFX("Dust", "end")
		self:PlayFX("GroundExplosion", "end")
		Sleep(50)
		self:SetVisible(false)
		Sleep(2500)
		DoneObject(self)
	end)

end

-- custom shuttletask
DefineClass.SpiceHarvester_ShuttleFollowTask = {
	__parents = {"InitDone"},
	state = "new",
	shuttle = false,
	dest_pos = false, --there isn't one, but adding this prevents log spam
}
