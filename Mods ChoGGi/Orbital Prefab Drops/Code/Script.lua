-- See LICENSE for terms

-- default options
OrbitalPrefabDrops = {
	PrefabOnly = true,
	Outside = true,
	Inside = false,
	DetachRockets = true,
	DetachRocketsPassages = false,
	RocketDamage = false,
}

local StringFormat = string.format
local Sleep = Sleep
local PlayFX = PlayFX
local PlaySound = PlaySound
local StopSound = StopSound
local IsValid = IsValid
local CreateGameTimeThread = CreateGameTimeThread
local MovePointAway = MovePointAway
local SetRollPitchYaw = SetRollPitchYaw
local AsyncRand = AsyncRand
local atan = atan
local point = point

local final_speed = 10*guim
local pt500 = point(0,0,500)
local pt1000 = point(0,0,1000)
local pt1580 = point(0,0,1580)
local pt1565 = point(0,0,1565)
local guim20 = 20*guim
local times9060 = 90*60
local times36060 = 360*60

local function RoverSink(rover,spawn_pos)
	-- sinks in while prefab_top is rising
	rover:SetPos(spawn_pos - pt1580,1000)
	Sleep(1000)
	-- bye bye rover
	DoneObject(rover)
end

local function DecalRemoval(land_decal)
	local delta = const.DayDuration / 20
	for opacity = 100, 0, -5 do
		Sleep(delta)
		if not IsValid(land_decal) then
			return
		end
		land_decal:SetOpacity(opacity, delta)
	end
	DoneObject(land_decal)
end

local function RocketDetach(self,missile,dir,cause_dmg)
	local pos = missile:GetPos()
	missile:Detach()
	PlayFX("Move", "end", missile, nil, nil, dir)
	local dest_pos = GetRandomPassableAround(pos, 30000)
	if dest_pos then
		dest_pos = dest_pos:SetZ(terrain.GetHeight(dest_pos))
		-- slow them down a bit randomly (2K to 10K)
		local travel_time = missile:GetTimeToImpact() + AsyncRand(8000) + 2000
		-- some sort of parachute object would be nice (skip if explode happens)
		missile:SetPos(dest_pos, travel_time)
		local norm_dir = point(dir:y(), -dir:x(), 0)
		missile:SetAxis(norm_dir)
		missile:SetAngle(times9060 + atan(dir:z(), dir:Len2D()))
		WaitMsg(missile, travel_time)
		PlayFX("DomeExplosion", "start", missile)
		local snd = PlaySound("Mystery Bombardment ExplodeAir", "ObjectOneshot", nil, 0, false, self)
		if cause_dmg then
			missile:Explode()
		end
		if IsValid(missile) then
			StopSound(snd)
			DoneObject(missile)
		end
		MapDelete(dest_pos, guim20, missile.explode_decal_name)
		local explode_decal = PlaceObject(missile.explode_decal_name)
		explode_decal:SetPos(dest_pos)
		explode_decal:SetAngle(AsyncRand(times36060))
		explode_decal:SetScale(15 + AsyncRand(20))
		local fade_time = missile.explode_decal_fade
		for opacity = 100, 0, -5 do
			Sleep(fade_time / 20)
			if not IsValid(explode_decal) then
				return
			end
			explode_decal:SetOpacity(opacity)
		end
		DoneObject(explode_decal)
	end
end

local orig_ConstructionSite_GameInit = ConstructionSite.GameInit

-- the rocket drop func (everything in one basket)
local function YamatoHasshin(self)
	local const = const
	-- hide the actual site for now
	self:SetVisible()

	-- pretty much a copy n paste of AttackRover:Spawn()... okay not anymore, but I swear it was
	CreateGameTimeThread(function()
		local ar = AttackRover
		local city = self.city or UICity
		-- where the prefab is
		local spawn_pos = self:GetVisualPos()
		-- let people know something is happening
		local blinky = RotatyThing:new()
		blinky:SetPos(spawn_pos+pt500)

		-- get dir and angle of container
		local dir = point(city:Random(-4096, 4096), city:Random(-4096, 4096))
		local angle = city:Random(ar.spawn_min_angle, ar.spawn_max_angle)
		local s, c = sin(angle), cos(angle)
		local flight_dist = ar.spawn_flight_dist
		if c == 0 then
			dir = point(0, 0, flight_dist)
		else
			dir = SetLen(dir:SetZ(MulDivRound(dir:Len2D(), s, c)), flight_dist)
		end

		local pos = spawn_pos + dir
		spawn_pos = terrain.GetIntersection(pos, spawn_pos)

		local prefab_top = PlaceObject("Hex1_Placeholder")
--~ prefab_top:SetScale(158)
--~ prefab_top:SetPos(c())
		local prefab_bot = PlaceObject("Hex1_Placeholder")
--~ prefab_top.___TOP = true
--~ prefab_bot.___BOT = true
		-- just large enough to cover rover (shrinking the rover doesn't work out too well)
		prefab_top:SetScale(158)
		prefab_bot:SetScale(158)
		prefab_top.rockets = {}

		-- easy way to get some flame on
		local rover = PlaceObject("FakeAttackRover")
		rover:SetPos(pos)
		-- stick the containers around the rover
		rover:Attach(prefab_top)
		rover:Attach(prefab_bot)
		-- flip bottom around and move it up so they're merged into one (hex model has no bottom)
		SetRollPitchYaw(prefab_bot, 0, 10800, 0)
		-- just enough to cover the wheels
		prefab_bot:SetAttachOffset(pt1565)

		-- get list of spot positions for rockets
--~ 		local id_start, id_end = prefab_top:GetAllSpots(0)
--~ 		for i = id_start, id_end do
		for i = 0, 13 do
			-- only do even numbers (so we skip half of them)
			if i % 2 == 0 and prefab_top:GetSpotName(i) == "Workrover" then
				-- the spots are a bit uneven, but hopefully no one pays too close attention to detail
				local spot_posi = prefab_top:GetSpotPos(i)
				local offset = spot_posi-MovePointAway(
					pos,
					spot_posi,
					-1925
				)
				local x = offset:x()
				if x < 0 and x > -20 then
					x = 0
				end
				local rocket = PlaceObject("BombardMissile")
				rocket:SetScale(400)
				prefab_top:Attach(rocket)
				rocket:SetAttachOffset(point(x,offset:y(),75))
				prefab_top.rockets[#prefab_top.rockets+1] = rocket
				PlayFX("Move", "start", rocket, nil, nil, dir)
			end
		end

		PlayFX("Meteor", "start", rover, nil, nil, dir)
		flight_dist = spawn_pos:Dist(pos)
		local flight_speed = ar.spawn_flight_speed - city:Random(2500,10000)
		local total_time = MulDivRound(1000, flight_dist, flight_speed)
		local land_time = MulDivRound(1000, ar.spawn_land_dist, flight_speed)
		local pitch = -atan(dir:Len2D(), dir:z())
		local yaw = 180*60 + atan(dir:y(), dir:x())
		SetRollPitchYaw(rover, 0, pitch, yaw, 0)

		rover:SetPos(spawn_pos, total_time)
		Sleep(total_time - land_time)

		-- mid-way boom
		PlaySound("Object StorageDepotFuel Explosion", "ObjectOneshot", nil, 0, false, rover)
		PlayFX("AirExplosion", "start", rover)
		-- byebye blinky
		DoneObject(blinky)
		-- detach rockets and let them fall to ground and explode?
		local opd = OrbitalPrefabDrops
		local pass = self.building_class == "PassageGridElement"
		if opd.DetachRockets and not pass or pass and opd.DetachRocketsPassages then
			for i = #prefab_top.rockets, 1, -1 do
				CreateGameTimeThread(RocketDetach,self,prefab_top.rockets[i],dir,opd.RocketDamage)
			end
		end

		PlayFX("Land", "start", rover)
		local accel, land_time = rover:GetAccelerationAndTime(spawn_pos, final_speed, flight_speed)
		rover:SetAcceleration(accel)
		rover:SetPos(spawn_pos, land_time)
		SetRollPitchYaw(rover, 0, 0, yaw, land_time)
		Sleep(land_time)
		-- landed time go boom
		PlaySound("Mystery Bombardment ExplodeTarget", "ObjectOneshot", nil, 0, false, self)
		PlayFX("GroundExplosion", "start", rover)

		local land_decal = PlaceObject(ar.land_decal_name)
		land_decal:SetPos(spawn_pos)
		land_decal:SetAngle(AsyncRand(times36060))
		land_decal:SetScale(40 + AsyncRand(50))
		CreateGameTimeThread(DecalRemoval,land_decal)

		PlayFX("Land", "end", rover)
		PlayFX("GroundExplosion", "end", rover)
		PlayFX("Meteor", "end", rover, nil, nil, dir)

		CreateGameTimeThread(RoverSink,rover,spawn_pos)
		-- stick the site underground by it's height then make it rise from the dead
		local height_pt = point(0,0,ObjectHierarchyBBox(self):sizez())
		if not height_pt:z() then
			height_pt = pt1000
		end
		spawn_pos = spawn_pos - height_pt
		self:SetPos(spawn_pos)
		-- oh look a construction site
		self:SetVisible(true)
		spawn_pos = spawn_pos + height_pt
		-- it's like jebus
		self:SetPos(spawn_pos,3000)
		-- fire off the usual stuff so the drones make with the building
		orig_ConstructionSite_GameInit(self)

	end)
end

function ConstructionSite:GameInit()
	-- is inner or outer building
	local outside,inside
	for i = 1, 3 do
		local label = self.building_class_proto[StringFormat("label%s",i)]
		if label == "OutsideBuildings" then
		 outside = true
		 break
		elseif label == "InsideBuildings" then
		 inside = true
		 break
		end
	end
	-- it's a dome/rover
	if not outside and not inside then
		outside = true
	end

	-- cables/pipes don't work that well, passages are fine, but with the detaching rockets it gets pretty busy
	local grid = self.building_class ~= "PassageGridElement" and self.building_class:find("GridElement") or self.building_class:find("Switch")

	local opd = OrbitalPrefabDrops
	-- we always allow prefabs (that's the mod...), but check if inside/outside are allowed
	if self.prefab and (outside and opd.Outside or inside and opd.Inside) then
		YamatoHasshin(self)
	-- same but if prefab only is disabled
	elseif not grid and not opd.PrefabOnly and (outside and opd.Outside or inside and opd.Inside) then
		YamatoHasshin(self)
	else
		orig_ConstructionSite_GameInit(self)
	end
end
