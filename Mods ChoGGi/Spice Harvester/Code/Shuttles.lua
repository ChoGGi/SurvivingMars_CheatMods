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

local DoneObject = DoneObject
local Sleep = Sleep
local IsValid = IsValid
local PlaySound = PlaySound
local GetSoundDuration = GetSoundDuration

local Random = ChoGGi.ComFuncs.Random
local GetCursorWorldPos = GetCursorWorldPos

function SpiceHarvester.SpawnShuttle(hub)
	local sh = SpiceHarvester
	for _, s_i in pairs(hub.shuttle_infos) do
		if GetRealm(hub):MapCount("map", "CargoShuttle") >= (sh.Max_Shuttles or 50) then
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
				dest_pos = GetCursorWorldPos() or GetRandomPassable()
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
		shuttle:SetColorizationMaterial(1, sh.Color1 or -12247037, Random(-128, 127), Random(-128, 127))
		shuttle:SetColorizationMaterial(2, sh.Color2 or -11196403, Random(-128, 127), Random(-128, 127))
		shuttle:SetColorizationMaterial(3, sh.Color3 or -13297406, Random(-128, 127), Random(-128, 127))

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
	dust_thread = false,
	attack_radius = 50 * const.ResourceScale,
	-- It'll change after
	min_wait_rock_attack = 100,
}
DefineClass.SpiceHarvester_ShuttleFollowTask = {
	__parents = {"InitDone"},
	state = "new",
	shuttle = false,
	-- there isn't one, but adding this prevents log spam
	dest_pos = false,
}

-- guess this is what happens when you spawn and attach a dronehub to a random vehicle
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

function SpiceHarvester_CargoShuttle:SpiceHarvester_FollowHarvester()

	-- dust thread
	self.dust_thread = CreateGameTimeThread(function()
		-- we're done if the host harvester is gone
		local terrain = GetGameMap(self).terrain

		while self.dust_thread do
			-- check if our height is low enough for some dust kickup
			local pos = self:GetVisualPos()
			if pos and (pos:z() - terrain:GetHeight(pos)) < 1500 then
				-- cough cough
				self:PlayFX("Dust", "start")
				-- break loop if game is paused or height is changed to above 1500, otherwise dust
				while IsValid(self) do
					pos = self:GetVisualPos()
					if UISpeedState == "pause" or (pos:z() - terrain:GetHeight(pos)) > 1500 then
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

	self.min_wait_rock_attack = Random(50, 75)
	local count_before_attack = 0

	-- movement thread
	while IsValid(self.SpiceHarvester_Harvester) do
		count_before_attack = count_before_attack + 1
		-- shoot a rock
		if count_before_attack >= self.min_wait_rock_attack then
			count_before_attack = 0

			local pos = self:GetVisualPos()
			local worm = GetRealm(self):MapGet("map", "WasteRockObstructorSmall", function(o)
				return pos:Dist2D(o:GetPos()) <= self.attack_radius
			end)
			if worm[1] then
				self:AttackWorm(table.rand(worm))
			end
		end

		self.hover_height = Random(800, 20000)
		local x, y = self.SpiceHarvester_Harvester:GetVisualPosXYZ()
		local dest = point(x+Random(-25000, 25000), y+Random(-25000, 25000))
		self:FlyingFace(dest, 2500)
		self:PlayFX("Waiting", "end")
		self:SetState("idle") -- level tubes
		self:FollowPathCmd(self:CalcPath(self:GetVisualPos(), dest))

		while self.next_spline do
			Sleep(1000)
		end
		self:SetState("fly")
		self:PlayFX("Waiting", "start")
		Sleep(Random(2500, 10000))
	end

	-- soundless sleep
	self:GoodByeCruelWorld()
end

function SpiceHarvester_CargoShuttle:AttackWorm(worm)
	if not IsValid(worm) then
		return
	end

	local pos = self:GetSpotPos(1)
	local angle, axis = self:GetSpotRotation(1)
	local rocket = PlaceObjectIn("RocketProjectile", self:GetMapID(), {
		shooter = self,
		target = worm,
	})
	rocket:Place(pos, axis, angle)
	rocket:StartMoving()
	PlayFX("MissileFired", "start", self, nil, pos, rocket.move_dir)
	CreateGameTimeThread(function()
		while rocket.move_thread do
			Sleep(500)
		end
		-- make it pretty
		PlayFX("GroundExplosion", "start", worm, nil, worm:GetPos())
		worm:delete()
	end)
end

function SpiceHarvester_CargoShuttle:Idle()
	Sleep(1000)
end

function SpiceHarvester_CargoShuttle:GoodByeCruelWorld()
	if IsValid(self) then
		self:PlayFX("GroundExplosion", "start")
		local snd = PlaySound("Mystery Bombardment ExplodeTarget", "ObjectOneshot", nil, 0, false, self, 1000)
		self:PlayFX("Dust", "end")
		Sleep(50)
		self:SetVisible(false)
		Sleep(GetSoundDuration(snd))
		self:PlayFX("GroundExplosion", "end")
		DoneObject(self)
	end
end

function SpiceHarvester_CargoShuttle:Done()
	if IsValidThread(self.dust_thread) then
		DeleteThread(self.dust_thread)
	end
	self.dust_thread = false
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
