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
local CreateRealTimeThread = CreateRealTimeThread
local AsyncRand = AsyncRand
local GetRandomPassable = GetRandomPassable
local GetTerrainCursor = GetTerrainCursor

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

function SpiceHarvester.ComFuncs.Random(m, n)
	-- m = min, n = max
	return AsyncRand(n - m + 1) + m
end
local Random = SpiceHarvester.ComFuncs.Random

-- well that's the question isn't it?
function SpiceHarvester.ComFuncs.QuestionBox(text,func,title,ok_msg,cancel_msg,image,context,parent)
	-- thread needed for WaitMarsQuestion
	CreateRealTimeThread(function()
		if WaitMarsQuestion(
			parent,
			title,
			text,
			ok_msg,
			cancel_msg,
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

function SpiceHarvester.ComFuncs.SpawnShuttle(hub)
	local UserSettings = SpiceHarvester.UserSettings
  for _, s_i in pairs(hub.shuttle_infos) do
--~     if s_i:CanLaunch() and s_i.hub and s_i.hub.has_free_landing_slots then
      -- ShuttleInfo:Launch(task)
      local hub = s_i.hub
      if MapCount("map", "SpiceHarvester_CargoShuttle") <= UserSettings.Max_Shuttles or 50 then

				-- LRManagerInstance
				local shuttle = SpiceHarvester_CargoShuttle:new{
					-- we kill off shuttles if this isn't valid
					SpiceHarvester_Harvester = hub.ChoGGi_Parent,
					-- lets take it nice n slow
					max_speed = 1000,
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

				-- shit stained bugs
        shuttle:SetColor1(UserSettings.Color1 or -12247037)
        shuttle:SetColor2(UserSettings.Color2 or -11196403)
        shuttle:SetColor3(UserSettings.Color3 or -13297406)

        -- follow that cursor little minion
--~ 				shuttle:SpiceHarvester_FollowHarvester()
				shuttle:SetCommand("SpiceHarvester_FollowHarvester")
				-- stored refs to them in the harvester for future use?
        return shuttle
      end
--~     end
  end
end

DefineClass.SpiceHarvester_ShuttleHub = {
	__parents = {"ShuttleHub"},
}
DefineClass.SpiceHarvester_CargoShuttle = {
	__parents = {"CargoShuttle"},
}
DefineClass.SpiceHarvester_ShuttleFollowTask = {
	__parents = {"InitDone"},
	state = "new",
	shuttle = false,
	-- there isn't one, but adding this prevents log spam
	dest_pos = false,
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

function SpiceHarvester_CargoShuttle:GoodByeCruelWorld()
	self:PlayFX("GroundExplosion", "start")
	PlaySound("Mystery Bombardment ExplodeTarget", "ObjectOneshot", nil, 0, false, self, 1000)
	self:PlayFX("Dust", "end")
	Sleep(50)
	self:SetVisible(false)
	Sleep(5000)
	self:PlayFX("GroundExplosion", "end")
	DoneObject(self)
end

function SpiceHarvester_CargoShuttle:SpiceHarvester_FollowHarvester()
	local IsValid = IsValid

	-- dust thread
	CreateRealTimeThread(function()
		local GetHeight = terrain.GetHeight
		while IsValid(self.SpiceHarvester_Harvester) do
			if SpiceHarvester.game_paused then
				Sleep(1000)
			else
				local pos1 = self:GetVisualPos()
				if pos1 and (pos1:z() - GetHeight(pos1)) < 1500 then
					self:PlayFX("Dust", "start")
					while IsValid(self) do
						if SpiceHarvester.game_paused then
							break
						end -- sleep if
						local pos2 = self:GetVisualPos()
						if (pos2:z() - GetHeight(pos2)) > 1500 then
							break
						end
						Sleep(1000)
					end -- while play dust
					self:PlayFX("Dust", "end")
				end
				Sleep(1000)
			end -- sleep if
		end -- while valid
	end)

	-- movement thread
	while IsValid(self.SpiceHarvester_Harvester) do
		if SpiceHarvester.game_paused then
			Sleep(1000)
		else
			self.hover_height = Random(800,20000)
			local x,y,_ = self.SpiceHarvester_Harvester:GetVisualPosXYZ()
			local path = self:CalcPath(
				self:GetVisualPos(),
				point(x+Random(-25000,25000), y+Random(-25000,25000))
			)

			local temp = CreateGameTimeThread(function()
				self:FollowPathCmd(path)
			end)
			repeat
				Sleep(500)
			until not IsValidThread(temp)
			Sleep(Random(2500,10000))
		end
	end

	-- soundless sleep
	if IsValid(self) then
		self:GoodByeCruelWorld()
	end

end

function SpiceHarvester_CargoShuttle:Idle()
	Sleep(1000)
end

-- gets rid of error in log
function SpiceHarvester_CargoShuttle:SetTransportTask()
end
-- gives an error when we spawn shuttle since i'm using a fake task, so we just return true instead
function SpiceHarvester_CargoShuttle:OnTaskAssigned()
	return true
end

-- remove from existing games as we don't use it anymore (it was from personal shuttles)
function OnMsg.LoadGame()
	local UICity = UICity
	if UICity.SpiceHarvester then
		UICity.SpiceHarvester = nil
	end
end
