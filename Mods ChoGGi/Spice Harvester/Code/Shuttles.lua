-- See LICENSE for terms

SpiceHarvester = {
	-- Melanger colour
	Color = -11328253,
	-- shuttle colours
	Color1 = -12247037,
	Color2 = -11196403,
	Color3 = -13297406,
	Max_Shuttles = 50,
}

local Random
local WaitMsg = WaitMsg
local MapCount = MapCount
local DoneObject = DoneObject
local Sleep = Sleep
local IsValid = IsValid
local PlaySound = PlaySound
local GetSoundDuration = GetSoundDuration
local GetHeight = terrain.GetHeight

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	Random = ChoGGi.ComFuncs.Random
end

function SpiceHarvester.SpawnShuttle(hub)
	local sh = SpiceHarvester
	for _, s_i in pairs(hub.shuttle_infos) do
		if MapCount("map", "CargoShuttle") >= (sh.Max_Shuttles or 50) then
			return
		end

		-- ShuttleInfo:Launch(task)
		local hub = s_i.hub
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

		-- brown stained bugs
		shuttle:SetColorizationMaterial(1, sh.Color1 or -12247037, Random(-128,127), Random(-128,127))
		shuttle:SetColorizationMaterial(2, sh.Color2 or -11196403, Random(-128,127), Random(-128,127))
		shuttle:SetColorizationMaterial(3, sh.Color3 or -13297406, Random(-128,127), Random(-128,127))

		-- follow that cursor little minion
		shuttle:SetCommand("SpiceHarvester_FollowHarvester")
		-- stored refs to them in the harvester for future use?
		return shuttle
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
	-- define the landing spots
	local slots = {}
	local spot_name = self.landing_spot_name or ""
	if spot_name ~= "" then
		for i = 1, self.ChoGGi_SlotAmount do
			slots[i] = {
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
	if IsValid(self) then
		self:PlayFX("GroundExplosion", "start")
		local snd = PlaySound("Mystery Bombardment ExplodeTarget", "ObjectOneshot", nil, 0, false, self, 1000)
		self:PlayFX("Dust", "end")
		Sleep(50)
		self:SetVisible(false)
		Sleep(GetSoundDuration(snd))
--~ 		Sleep(5000)
		self:PlayFX("GroundExplosion", "end")
		DoneObject(self)
	end
end

function SpiceHarvester_CargoShuttle:SpiceHarvester_FollowHarvester()

	-- dust thread
	CreateRealTimeThread(function()
		-- we're done if the host harvester is gone
		while IsValid(self.SpiceHarvester_Harvester) do
			-- real time threads don't pause when the game is paused
			if SpiceHarvester.game_paused then
				WaitMsg("MarsResume")
				SpiceHarvester.game_paused = false
			end

			-- check if our height is low enough for some dust kickup
			local pos = self:GetVisualPos()
			if pos and (pos:z() - GetHeight(pos)) < 1500 then
				-- cough cough
				self:PlayFX("Dust", "start")
				-- break loop if game is paused or height is changed to above 1500, otherwise dust
				while IsValid(self) do
					pos = self:GetVisualPos()
					if SpiceHarvester.game_paused or (pos:z() - GetHeight(pos)) > 1500 then
						break
					end
					Sleep(1000)
				end
				-- loop is done so we can stop the dust
				self:PlayFX("Dust", "end")
			end
			Sleep(1000)

		end -- while valid Harvester
	end)

	-- movement thread
	while IsValid(self.SpiceHarvester_Harvester) do
		if SpiceHarvester.game_paused then
			WaitMsg("MarsResume")
			SpiceHarvester.game_paused = false
		end
		self.hover_height = Random(800,20000)
		local x,y = self.SpiceHarvester_Harvester:GetVisualPosXYZ()
		local path = self:CalcPath(
			self:GetVisualPos(),
			point(x+Random(-25000,25000), y+Random(-25000,25000))
		)

		self:WaitFollowPath(path)
		Sleep(Random(2500,10000))
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
SpiceHarvester_CargoShuttle.SetTransportTask = empty_func
-- gives an error when we spawn shuttle since i'm using a fake task, so we just return true instead
function SpiceHarvester_CargoShuttle:OnTaskAssigned()
	return true
end

-- remove from existing games as we don't use it anymore (it was from personal shuttles)
function OnMsg.LoadGame()
	UICity.SpiceHarvester = nil
end
