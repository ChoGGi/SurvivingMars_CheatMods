-- See LICENSE for terms

local Sleep = Sleep
local PlayFX = PlayFX
local PlaySound = PlaySound
local IsValid = IsValid
local CreateGameTimeThread = CreateGameTimeThread
local MovePointAway = MovePointAway
local final_speed = 10*guim
local pt1000 = point(0,0,1000)

local orig_ConstructionSite_GameInit = ConstructionSite.GameInit
function ConstructionSite:GameInit()
	if self.prefab then
		-- hide the actual site for now
		self:SetOpacity(0)

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
				if prefab:GetSpotName(i) == "Workrover" then
					local offset = prefab:GetSpotPos(i)-MovePointAway(
						pos,
						prefab:GetSpotPos(i),
						-1925
					)
					local x = offset:x()
					if x < 0 and x > -20 then
						x = 0
					end
--~ 					local rocket = PlaceObject("BombardMissile")
					local rocket = PlaceObject("BombardMissile",{start = pos, dest = spawn_pos})
					rocket:SetScale(400)
					prefab:Attach(rocket)
					rocket:SetAttachOffset(point(x,offset:y(),75))
					prefab.rockets[#prefab.rockets] = rocket
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

			Sleep(250)
			-- oh look a construction site
			self:SetOpacity(100)
			-- it's like jebus
			spawn_pos = spawn_pos - pt1000
			self:SetPos(spawn_pos)
			spawn_pos = spawn_pos + pt1000
			self:SetPos(spawn_pos,3000)
			-- fire off the usual stuff so the drones make with the building
			orig_ConstructionSite_GameInit(self)
		end)
	else
		orig_ConstructionSite_GameInit(self)
	end
end
