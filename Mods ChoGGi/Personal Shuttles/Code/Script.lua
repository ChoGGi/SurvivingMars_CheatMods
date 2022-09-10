-- See LICENSE for terms

-- local some stuff that's called a lot
local tostring = tostring
local point = point
local Sleep = Sleep
local GameTime = GameTime
local DeleteThread = DeleteThread
local PlayFX = PlayFX
local IsValid = IsValid
local GetCursorWorldPos = GetCursorWorldPos

local Random = ChoGGi.ComFuncs.Random

PersonalShuttles = {
	time_limit = const.DayDuration * 4,
	attacker_color1 = -2031616,
	attacker_color2 = -16777216,
	attacker_color3 = -9043968,
	friend_colour1 = -16711941,
	friend_colour2 = -16760065,
	friend_colour3 = -1,
	-- I wouldn't set this too high...
	max_shuttles = 50,
	-- switch to drop item on pickup
	drop_toggle = false,
}

-- custom shuttletask
DefineClass.PersonalShuttles_ShuttleFollowTask = {
	__parents = {"InitDone"},
	state = "new",
	shuttle = false,
	scanning = false, -- from explorer code for AnalyzeAnomaly
	dest_pos = false, -- there isn't one, but adding one prevents log spam
}

DefineClass.PersonalShuttle = {
	__parents = {"CargoShuttle"},
	defence_thread_DD = false,
	-- set from shuttlehub
	recall_shuttle = false,
	-- attached carry object
	carried_obj = false,
	-- should it pickup item with pickup enabled
	pickup_toggle = false,
	-- build up of time to sleep between mouse
	idle_time = 0,
	-- we don't want to abort flying thread if it's the same dest
	old_dest = false,
	-- fix most jerky moving
	first_idle = 0,

	-- attack stuff
	shoot_range = 25 * guim,
	reload_time = const.HourDuration,
	track_thread = false,

	-- attached obj offsets
	offset_rover = point(0, 0, 400),
	offset_drone = point(0, 0, 325),
	offset_other = point(0, 0, 350),
}

-- If it idles it'll go home, so we return my command till we remove thread
function PersonalShuttle:Idle()
	self:SetCommand("FollowMouse")
	Sleep(1000)
end

function PersonalShuttle:GameInit()

	self.city = self.hub.city or MainCity
	self.city:AddToLabel("PersonalShuttle", self)

	-- gagarin likes it dark
	self:SetColorModifier(-1)

	local ps = PersonalShuttles

	-- If it's an attack shuttle
	if MainCity.PersonalShuttles.shuttle_threads[self.handle] then
		self.defence_thread_DD = CreateGameTimeThread(function()
			while IsValid(self) and not self.destroyed do
				if self.working then
					self:PersonalShuttles_DefenceTickD(ps)
				end
				Sleep(2500)
			end
		end)
	end

end

function PersonalShuttle:Done()
	(self.city or MainCity):RemoveFromLabel("PersonalShuttle", self)
end

-- gets rid of error in log
--~ function PersonalShuttle:SetTransportTask()end
PersonalShuttle.SetTransportTask = empty_func
-- gives an error when we spawn shuttle since i'm using a fake task, so we just return true instead
function PersonalShuttle:OnTaskAssigned()
	return true
end

-- dustdevil thread for rockets
function PersonalShuttle:PersonalShuttles_DefenceTickD(ps)
	if MainCity.PersonalShuttles.shuttle_threads[self.handle] then
		return self:DefenceTick(ps.shuttle_rocket_DD)
	end
end

-- 	Movable.Goto(object, pt) -- Unit.Goto is a command, use this instead for direct control

-- get shuttle to follow mouse
function PersonalShuttle:FollowMouse()

	local PersonalShuttles = PersonalShuttles
	-- always start it off as pickup
	if not IsValid(self.carried_obj) then
		self.pickup_toggle = true
	end
	self.idle_time = 0

	self.old_dest = false
	self.first_idle = 0

	-- following mouse loop
	repeat
		local pos = self:GetVisualPos()
		local dest = GetCursorWorldPos()

		self:GotoPos(pos, dest)

		local obj = SelectedObj
		if IsValid(obj) and obj ~= self then
			self:SelectedObject(obj, pos, dest)
		end

		self.idle_time = self.idle_time + 10
		Sleep(250 + self.idle_time)
		-- 4 sols then send it back home (or if we recalled it)
	until self.recall_shuttle or (GameTime() - self.time_now) > PersonalShuttles.time_limit

	-- buh-bye little flying companion
	self:SetCommand("GoHome")
end

-- where are we going
function PersonalShuttle:GotoPos(pos, dest)
	-- too quick and it's jerky *or* mouse making small movements
	if self.in_flight then
		if self.idle_time < 125 then
			return
--~ 		elseif self.idle_time > 100 and self.old_pos == pos then
--~ 		--
		elseif self.old_dest and not (self.idle_time > 125 and self.old_pos == pos) then
--~ 			local ox, oy = self.old_dest:xy()
--~ 			local x, y = dest:xy()
--~ 			if point(ox, oy):Dist2D(point(x, y)) < 1000 then
			if self.old_dest:Dist2D(dest) < 1000 then
				if self.first_idle < 25 then
					self.first_idle = self.first_idle + 1
					return self.idle_time
				end
			end
		end
	end
	self.first_idle = 0

	-- don't try to fly if pos or dest are the same
	if tostring(pos) == tostring(dest) then
		return
	end

	-- check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
	-- and if we move when we're too close it's jerky
	local dest_x, dest_y = dest:xy()
--~ 	local dist = pos:Dist2D(point(dest_x, dest_y)) > 5000
	local dist = pos:Dist2D(dest) > 5000
	if dist or self.idle_time > 250 then
		-- rest on ground
		self.hover_height = 0

		-- If idle is ticking up
		if self.idle_time > 250 then
			if not self.is_landed then
				self:SetState("fly")
				Sleep(250)
				self:PlayFX("Dust", "start")
				self:PlayFX("Waiting", "start")
				local land = pos:SetTerrainZ()
				self:FlyingFace(land, 2500)
				self:SetPos(land, 4000)
				Sleep(750)
				self.is_landed = self:GetPos()
				self:PlayFX("Dust", "end")
				self:PlayFX("Waiting", "end")
				self:SetState("idle")

			end
			Sleep(500 + self.idle_time)
		end

		-- mouse moved far enough then wake up and fly
		if dist then

			-- reset idle count
			self.idle_time = 0
			-- we don't want to skim the ground (default is 3K, but this one likes living life on the edge)
			self.hover_height = 1500

			-- want to be kinda random
			local path = self:CalcPath(
				pos,
				point(dest_x+Random(-2500, 2500), dest_y+Random(-2500, 2500), self.hover_height)
			)

			if self.is_landed then
				self.is_landed = nil
				self:PlayFX("DomeExplosion", "start")
				-- self:PersonalShuttles_TakeOff()
			end

			-- abort previous flight if dest is different
			if self.in_flight and dest ~= self.old_dest then
				self.old_dest = dest
				self.in_flight = nil
				DeleteThread(FlyingObjs[self])

			-- we don't want to start a new flight if we're flying and the dest isn't different
			elseif not self.in_flight then
				-- the actual flight
				self.in_flight = true
				self:FollowPathCmd(path)
				while self.next_spline do
					Sleep(1000)
				end
				self.in_flight = nil
			end

		end

		-- hmm?
		self:SetState("idle")

	end

	self.old_pos = pos
	self.old_dest = dest
end

function PersonalShuttle:DropCargo(obj, pos, dest)
	local carried = self.carried_obj

	-- If fired from recall
	dest = dest or GetPassablePointNearby(self:GetPos())
	pos = pos or self:GetPos()

	-- drop it off nearby
	self:WaitFollowPath(self:CalcPath(pos, dest))

	self:PlayFX("ShuttleUnload", "start", carried)
	carried:Detach()
	-- doesn't work if we use this with CalcPath
	dest = HexGetNearestCenter(dest)
	-- don't want to be floating above the ground
	carried:SetPos(dest:SetTerrainZ(), 2500)

	-- we don't want stuff looking weird (drones/rovers can move on their own)
	if obj and obj:IsKindOf("ResourceStockpileBase") then
		carried:SetAngle(0)
	end

	Sleep(2500)
	self:PlayFX("ShuttleUnload", "end", carried)

	-- so drones will empty resource piles
	if carried.ConnectToCommandCenters then
		carried:ConnectToCommandCenters()
	end
	WaitMsg("OnRender")

	-- restore our fake drone override command
	if carried.ChoGGi_SetCommand then
		carried.SetCommand = carried.ChoGGi_SetCommand
		carried.ChoGGi_SetCommand = nil
	end

	if carried.Idle then
		carried:SetCommand("Idle")
	end

	self.carried_obj = nil
	-- make it able to pick up again without having to press the button
	self.pickup_toggle = true

	MainCity.PersonalShuttles.shuttle_carried[carried.handle] = nil
end

local function IdleDroneInAir()
	Sleep(1000)
end

-- pickup/dropoff/scan
function PersonalShuttle:SelectedObject(obj, pos, dest)
	-- Anomaly scanning
	if obj:IsKindOf("SubsurfaceAnomaly") then
		-- scan nearby SubsurfaceAnomaly
		local anomaly = NearestObject(pos, GetRealm(self):MapGet("map", "SubsurfaceAnomaly"), 2000)
		-- make sure it's the right one, and not already being scanned by another
		if anomaly and obj == anomaly and not MainCity.PersonalShuttles.shuttle_scanning_anomaly[anomaly.handle] then
			PlayFX("ArtificialSunCharge", "start", anomaly)
			MainCity.PersonalShuttles.shuttle_scanning_anomaly[anomaly.handle] = true
			self:AnalyzeAnomaly(anomaly)
			PlayFX("ArtificialSunCharge", "end", anomaly)
		end
	-- resource moving

	-- are we carrying, and is pickup set to drop?
	elseif IsValid(self.carried_obj) and self.pickup_toggle == false then
		self:DropCargo(obj, pos, dest)

	-- If it's marked for pickup and shuttle is set to pickup and it isn't already carrying then grab it
	elseif obj.PersonalShuttles_PickUpItem and self.pickup_toggle and not IsValid(self.carried_obj) then

		-- goto item
		self:WaitFollowPath(self:CalcPath(pos, obj:GetVisualPos()))

		if not MainCity.PersonalShuttles.shuttle_carried[obj.handle] then
			MainCity.PersonalShuttles.shuttle_carried[obj.handle] = true

			-- select shuttle instead of carried
			SelectObj(self)
			-- remove pickup mark from it
			obj.PersonalShuttles_PickUpItem = nil
			-- PlayFX of beaming, transport one i think
			self:PlayFX("ShuttleLoad", "start", obj)
			obj:SetPos(self:GetVisualPos(), 2500)
			Sleep(2500)
			-- pick it up
			self:Attach(obj, self:GetSpotBeginIndex("Origin"))
			-- offset attach
			if obj:IsKindOf("BaseRover") then
				obj:SetAttachOffset(self.offset_rover)
			elseif obj:IsKindOf("Drone") then
				obj:SetAttachOffset(self.offset_drone)
				obj.ChoGGi_SetCommand = obj.SetCommand
				obj.SetCommand = IdleDroneInAir
			else
				obj:SetAttachOffset(self.offset_other)
			end

			if PersonalShuttles.drop_toggle then
				-- switch to drop, so next selected item will be where we drop it
				self.pickup_toggle = false
			end

			-- and remember not to pick up more than one
			self.carried_obj = obj
			self:PlayFX("ShuttleLoad", "end", obj)

		end

	end
end

function PersonalShuttle:FireRocket(target)
	local pos = self:GetSpotPos(1)
	local angle, axis = self:GetSpotRotation(1)
	local rocket = PlaceObjectIn("RocketProjectile", self:GetMapID(), {
		shooter = self,
		target = target,
	})
	rocket:Place(pos, axis, angle)
	rocket:StartMoving()
	PlayFX("MissileFired", "start", self, nil, pos, rocket.move_dir)
	return rocket
end

-- pretty much a direct copynpaste from explorer (just removed stuff that's rover only)
function PersonalShuttle:AnalyzeAnomaly(anomaly)
	if not IsValid(self) then
		return
	end

	self:SetState("idle")
	self:SetPos(self:GetVisualPos())
	self:Face(anomaly:GetPos(), 200)
	local layers = anomaly.depth_layer or 1
	self.scan_time = layers * g_Consts.RCRoverScanAnomalyTime
	local progress_time = MulDivRound(anomaly.scanning_progress, self.scan_time, 100)
	self.scanning_start = GameTime() - progress_time
	RebuildInfopanel(self)
	self:PushDestructor(function(self)
		if IsValid(anomaly) then
			anomaly.scanning_progress = self:GetScanAnomalyProgress()
			if anomaly.scanning_progress >= 100 then
				self:Gossip("ScanAnomaly", anomaly.class, anomaly.handle)
				anomaly:ScanCompleted(self)
				anomaly:delete()
			end
		end
		if IsValid(anomaly) and anomaly == SelectedObj then
			Msg("UIPropertyChanged", anomaly)
		end
		-- self:StopFX()
		self.scanning = false
		self.scanning_start = false
	end)
	local time = self.scan_time - progress_time
	-- self:StartFX("Scan", anomaly)
	self.scanning = true
	while time > 0 and IsValid(self) and IsValid(anomaly) do
		Sleep(1000)
		time = time - 1000
		anomaly.scanning_progress = self:GetScanAnomalyProgress()
		if anomaly == SelectedObj then
			Msg("UIPropertyChanged", anomaly)
		end
	end
	self:PopAndCallDestructor()
	MainCity.PersonalShuttles.shuttle_scanning_anomaly[anomaly.handle] = nil
end

function PersonalShuttle:GetScanAnomalyProgress()
	return self.scanning_start and MulDivRound(GameTime() - self.scanning_start, 100, self.scan_time) or 0
end

function PersonalShuttle:DefenceTick(already_fired)

	if type(already_fired) ~= "table" then
		print("Personal Shuttles Error: shuttle_rocket_DD isn't a table")
	end

	-- list of dustdevils on map
	local hostiles = g_DustDevils or empty_table
	if IsValidThread(self.track_thread) then
		return
	end
	for i = 1, #hostiles do
		local obj = hostiles[i]

		-- get dist (added * 10 as it didn't see to target at the range of it's hex grid)
		-- It could be from me increasing protection radius, or just how it targets meteors
		if IsValid(obj) and self:GetVisualDist(obj) <= self.shoot_range * 10 then
			-- check if tower is working
			if not IsValid(self) or not self.working or self.destroyed then
				return
			end

			-- follow = small ones attached to majors
			if not obj.follow and not already_fired[obj.handle] then
			-- If not already_fired[obj.handle] then
				-- aim the tower at the dustdevil
				if self.class == "DefenceTower" then
					self:OrientPlatform(obj:GetVisualPos(), 7200)
				end
				-- fire in the hole
				local rocket = self:FireRocket(obj)
				-- store handle so we only launch one per devil
				already_fired[obj.handle] = obj
				-- seems like safe bets to set
				self.meteor = obj
				self.is_firing = true
				-- sleep till rocket explodes
				CreateGameTimeThread(function()
					while rocket.move_thread do
						Sleep(500)
					end
					if obj:IsKindOf("BaseMeteor") then
						-- make it pretty
						PlayFX("AirExplosion", "start", obj, nil, obj:GetPos())
						Msg("MeteorIntercepted", obj)
						obj:ExplodeInAir()
					else
						-- make it pretty
						PlayFX("AirExplosion", "start", obj, obj:GetAttaches()[1], obj:GetPos())
						-- kill the devil object
						obj:delete()
					end
					self.meteor = false
					self.is_firing = false
				end)
				-- back to the usual stuff
				Sleep(self.reload_time)
				return true
			end
		end
	end

	-- remove devil handles only if they're actually gone
	if already_fired[1] then
		CreateGameTimeThread(function()
			for i = #already_fired, 1, -1 do
				if not IsValid(already_fired[i]) then
					already_fired[i] = nil
				end
			end
		end)
	end
end
