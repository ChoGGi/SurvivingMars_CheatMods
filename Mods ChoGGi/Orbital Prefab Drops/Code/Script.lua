-- See LICENSE for terms

-- default options (only outside prefabs)
OrbitalPrefabDrops = {
	PrefabOnly = true,
	Outside = true,
	Inside = false,
	DetachRockets = true,
	DetachRocketsPassages = false,
}

local Sleep = Sleep
local PlayFX = PlayFX
local PlaySound = PlaySound
local IsValid = IsValid
local CreateGameTimeThread = CreateGameTimeThread
local MovePointAway = MovePointAway
local AsyncRand = AsyncRand
local StringFormat = string.format

local final_speed = 10*guim
local pt1000 = point(0,0,1000)
local guim20 = 20*guim
local times9060 = 90*60

local orig_ConstructionSite_GameInit = ConstructionSite.GameInit

-- the rocket drop func (everything in one basket)
local function YamatoHasshin(self)
	local const = const
	-- hide the actual site for now
	self:SetVisible()

	-- pretty much a copy n paste of AttackRover:Spawn()
	CreateGameTimeThread(function()
		local ar = AttackRover
		local city = self.city or UICity

		local spawn_pos = self:GetVisualPos()
		local blinky = RotatyThing:new()
		blinky:SetPos(spawn_pos+point(0,0,500))

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

		local prefab = PlaceObject("StirlingGenerator")
		-- just large enough to cover rover (shrinking the rover doesn't work out too well)
		prefab:SetScale(158)
		prefab:SetPos(pos)
		prefab.rockets = {}

		local id_start, id_end = prefab:GetAllSpots(0)
		for i = id_start, id_end do
			-- if even number (so we skip half of them)
			if i % 2 == 0 and prefab:GetSpotName(i) == "Workrover" then
				-- the spots are a bit uneven, but hopefully no one pays too close attention to detail
				local offset = prefab:GetSpotPos(i)-MovePointAway(
					pos,
					prefab:GetSpotPos(i),
					-1925
				)
				local x = offset:x()
				if x < 0 and x > -20 then
					x = 0
				end
				local rocket = PlaceObject("BombardMissile",{start = pos, dest = spawn_pos})
				rocket:SetScale(400)
				prefab:Attach(rocket)
				rocket:SetAttachOffset(point(x,offset:y(),75))
				prefab.rockets[#prefab.rockets+1] = rocket
				PlayFX("Move", "start", rocket, nil, nil, dir)

			end
		end

		local rover = PlaceObject("FakeAttackRover")
--~ 			rover:SetScale(63)
		rover:SetPos(pos)
		rover:Attach(prefab)

		PlayFX("Meteor", "start", rover, nil, nil, dir)

		flight_dist = spawn_pos:Dist(pos)
		local flight_speed = ar.spawn_flight_speed - city:Random(2500,10000)
		local total_time = MulDivRound(1000, flight_dist, flight_speed)
		local land_time = MulDivRound(1000, ar.spawn_land_dist, flight_speed)
		local pitch = -atan(dir:Len2D(), dir:z())
		local yaw = 180*60 + atan(dir:y(), dir:x())
		SetRollPitchYaw(rover, 0, pitch, yaw, 0)
		-- remove sign from prefab
		while not prefab.electricity do
			Sleep(5)
		end
		prefab:AttachSign(false,"SignNoPowerProducer")
--~ 			for sign in pairs(prefab.signs) do
--~ 				prefab:AttachSign(false,sign)
--~ 			end

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
			for i = #prefab.rockets, 1, -1 do
				CreateGameTimeThread(function()
					local missile = prefab.rockets[i]
					local pos = missile:GetPos()
					missile:Detach()
					PlayFX("Move", "end", missile, nil, nil, dir)
					local dest_pos = GetRandomPassableAround(pos, 30000)
					if dest_pos then
						dest_pos = dest_pos:SetZ(terrain.GetHeight(dest_pos))
						-- slow them down a bit randomly (2K to 5K)
						local travel_time = missile:GetTimeToImpact() + AsyncRand(10000 - 2000 + 1) + 2000
						missile:SetPos(dest_pos, travel_time)
						local norm_dir = point(dir:y(), -dir:x(), 0)
						missile:SetAxis(norm_dir)
						missile:SetAngle(times9060 + atan(dir:z(), dir:Len2D()))
						WaitMsg(missile, travel_time)
						PlayFX("DomeExplosion", "start", missile)
						PlaySound("Mystery Bombardment ExplodeAir", "ObjectOneshot", nil, 0, false, self)
						missile:Explode()
						if IsValid(missile) then
							DoneObject(missile)
						end
						MapDelete(dest_pos, guim20, missile.explode_decal_name)
						local explode_decal = PlaceObject(missile.explode_decal_name)
						explode_decal:SetPos(dest_pos)
						explode_decal:SetAngle(AsyncRand(360*60))
						explode_decal:SetScale(50 + AsyncRand(50))
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
				end)
			end
		end

		PlayFX("Land", "start", rover)
		local accel, land_time = rover:GetAccelerationAndTime(spawn_pos, final_speed, flight_speed)
		rover:SetAcceleration(accel)
		rover:SetPos(spawn_pos, land_time)
		SetRollPitchYaw(rover, 0, 0, yaw, land_time)
		Sleep(land_time)
		PlaySound("Mystery Bombardment ExplodeTarget", "ObjectOneshot", nil, 0, false, self)
		PlayFX("GroundExplosion", "start", rover)
		PlayFX("Land", "end", rover)
		PlayFX("GroundExplosion", "end", rover)

		PlayFX("Meteor", "end", rover, nil, nil, dir)
		DoneObject(rover)

		local land_decal = PlaceObject(ar.land_decal_name)
		land_decal:SetPos(spawn_pos)
		land_decal:SetAngle(AsyncRand(360*60))
		land_decal:SetScale(15)
		CreateGameTimeThread(function()
			local delta = const.DayDuration / 20
			for opacity = 100, 0, -5 do
				Sleep(delta)
				if not IsValid(land_decal) then
					return
				end
				land_decal:SetOpacity(opacity, delta)
			end
			DoneObject(land_decal)
		end)

		-- let just a slight bit of smoke clear
		Sleep(250)

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

	-- we always allow prefabs (that's the mod...), but check if inside/outside are allowed
	local opd = OrbitalPrefabDrops
	if self.prefab and (outside and opd.Outside or inside and opd.Inside) then
		YamatoHasshin(self)
	-- same but if prefab only is disabled
	elseif not grid and not opd.PrefabOnly and (outside and opd.Outside or inside and opd.Inside) then
		YamatoHasshin(self)
	else
		orig_ConstructionSite_GameInit(self)
	end
end

--~ local function StartupCode()

--~ end

--~ function OnMsg.CityStart()
--~ 	StartupCode()
--~ end

--~ function OnMsg.LoadGame()
--~ 	StartupCode()
--~ end
