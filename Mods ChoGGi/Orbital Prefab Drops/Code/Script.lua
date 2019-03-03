-- See LICENSE for terms

-- default options
OrbitalPrefabDrops = {
	PrefabOnly = true,
	Outside = true,
	Inside = false,
	DomeCrack = true,
	ModelType = 1,
}
local models = {"SupplyPod","Hex1_Placeholder","ArcPod"}


local Sleep = Sleep
local PlayFX = PlayFX
local IsValid = IsValid
local CreateGameTimeThread = CreateGameTimeThread
local MovePointAway = MovePointAway
local SetRollPitchYaw = SetRollPitchYaw
local AsyncRand = AsyncRand
local atan = atan
local point = point
local GetDomeAtHex = GetDomeAtHex
local WorldToHex = WorldToHex
local ObjectHierarchyBBox = ObjectHierarchyBBox

local BaseMeteor = BaseMeteor
local pt1000 = point(0,0,1000)
local pt1500 = point(0,0,1500)
local times36060 = 360*60
local times18060 = 180*60
-- from AttackRover
local final_speed = 10*guim

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

local orig_ConstructionSite_GameInit = ConstructionSite.GameInit

-- the rocket drop func (everything in one basket)
local function YamatoHasshin(site)

	-- stick the site underground by it's height then make it rise from the dead
	local site_bbox = ObjectHierarchyBBox(site,const.efCollision)
	if not site_bbox:sizez() then
		site_bbox = site:GetObjectBBox()
	end

	local site_height = point(0,0,site_bbox:sizez())
	if not site_height:z() then
		site_height = pt1500
	end

	local const = const
	-- hide the actual site for now
	site:SetVisible()
	local opd = OrbitalPrefabDrops
	local city = site.city or UICity
	-- where the prefab is
	local spawn_pos = site:GetVisualPos()
	-- let people know something is happening
	local blinky = PlaceParticles("Rocket_Pos")
	blinky:SetColorModifier(green)
--~ 	blinky:SetScale(100)
	blinky:SetPos(spawn_pos)

	local ar = AttackRover
	local sr = SupplyRocket
--~ -- landing/takeoff parameters
--~ orbital_altitude = 2500*guim,
--~ orbital_velocity = 100*guim,
--~ -- second set for the first rocket
--~ orbital_altitude_first = 400*guim,
--~ orbital_velocity_first = 43*guim,
--~ warm_up = 10000,

--~ -- pre-hit ground moments, all are relative to hit-ground
--~ pre_hit_ground = 10000,
--~ pre_hit_ground2 = 13000,
--~ pre_hit_groud_decal = 0,


	-- pretty much a copy n paste of AttackRover:Spawn()... okay not anymore, but I swear it was
	CreateGameTimeThread(function()

		-- get dir and angle of container
		local dir = point(city:Random(-4096, 4096), city:Random(-4096, 4096))
		local angle = city:Random(ar.spawn_min_angle/2, ar.spawn_max_angle/2)
		local s, c = sin(angle), cos(angle)
		local flight_dist = ar.spawn_flight_dist
		if c == 0 then
			dir = point(0, 0, flight_dist)
		else
			dir = SetLen(dir:SetZ(MulDivRound(dir:Len2D(), s, c)), flight_dist)
		end

		local pos = spawn_pos + dir
		spawn_pos = terrain.GetIntersection(pos, spawn_pos)
		local hover_pos = spawn_pos + site_height

		local pod = PlaceObject("Hex1_Placeholder")
		pod.landing_particle = blinky

		pod:ChangeEntity(models[opd.ModelType])
		pod:SetColorizationMaterial(1,-12845056, 0,128)
		pod:SetColorizationMaterial(2,-16777216, 0,128)
		pod:SetColorizationMaterial(3,-10053783, 0,128)

		pod.fx_actor_base_class = "FXRocket"
		pod.fx_actor_class = "SupplyRocket"
		pod:SetPos(pos)

		flight_dist = spawn_pos:Dist(pos)
		local flight_speed = ar.spawn_flight_speed - city:Random(2500,10000)
		local total_time = MulDivRound(1000, flight_dist, flight_speed)
		local land_time = MulDivRound(1000, ar.spawn_land_dist, flight_speed)
		local pitch = -atan(dir:Len2D(), dir:z())
		local yaw = times18060 + atan(dir:y(), dir:x())
		SetRollPitchYaw(pod, 0, pitch, yaw, 0)

		pod:SetPos(hover_pos, total_time)
		PlayFX("RocketLand", "start", pod)
		Sleep(total_time - land_time)

		-- mid-way
		PlayFX("RocketLand", "pre-hit-ground2", pod, false, spawn_pos)
		local accel, land_time = pod:GetAccelerationAndTime(spawn_pos, final_speed, flight_speed)
		pod:SetAcceleration(accel)
		pod:SetPos(hover_pos, land_time)
		SetRollPitchYaw(pod, 0, 0, yaw, land_time)
--~ 		Sleep(Max(0, site.pre_hit_ground2 - site.pre_hit_ground))
		PlayFX("RocketLand", "pre-hit-ground", pod, false, spawn_pos)

		-- just for you ski
		local quarter = land_time/4
		Sleep(quarter*3)
		PlayFX("RocketLand", "hit-ground", pod, false, spawn_pos)
		if opd.DomeCrack then
			local dome = GetDomeAtHex(WorldToHex(spawn_pos))
			if dome then
				local _, dome_pt, dome_normal = BaseMeteor.HitsDome(dome,spawn_pos)
				BaseMeteor.CrackDome(dome, dome, dome_pt, dome_normal)
			end
		end
		Sleep(quarter)

		local land_decal = PlaceObject(ar.land_decal_name)
		land_decal:SetPos(spawn_pos)
		land_decal:SetAngle(AsyncRand(times36060))
		land_decal:SetScale(40 + AsyncRand(50))
		CreateGameTimeThread(DecalRemoval,land_decal)

		-- byebye blinky
		DoneObject(blinky)

		PlayFX("RocketLand", "end", pod)

		-- stupid bad prefab
		if IsValid(site) then
			-- use shuttle fx up arrow thing
			pod.fx_actor_class = "Shuttle"
--~ 			PlayFX("Dust", "start", pod)
			PlayFX("ShuttleUnload", "start", pod, false, spawn_pos)

			spawn_pos = spawn_pos - site_height
			site:SetPos(spawn_pos)
			-- oh look a construction site
			site:SetVisible(true)
			spawn_pos = spawn_pos + site_height
			-- it's like jebus
			site:SetPos(spawn_pos,3000)

--~ 			PlayFX("Dust", "end", pod)
			-- fire off the usual stuff so the drones make with the building
			orig_ConstructionSite_GameInit(site)
		end
		PlayFX("ShuttleUnload", "end", pod, false, spawn_pos)

		pod.fx_actor_class = "SupplyRocket"
		PlayFX("RocketEngine", "start", pod)
		Sleep(sr.warm_up/2)
		PlayFX("RocketEngine", "end", pod)

		PlayFX("RocketLaunch", "start", pod)
		local a, t = pod:GetAccelerationAndTime(pos, flight_speed, 0)
		SetRollPitchYaw(pod, 0, pitch, yaw, t/4)
		pod:SetAcceleration(a)
		pod:SetPos(pos, t)

		Sleep(t)
		PlayFX("RocketLaunch", "end", pod)
		-- bye bye pod
		DoneObject(pod)

	end)
end

function ConstructionSite:GameInit()
	-- is inner or outer building
	local outside,inside
	for i = 1, 3 do
		local label = self.building_class_proto[string.format("label%s",i)]
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
	local grid = self.building_class:find("GridElement") or self.building_class:find("Switch")

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
