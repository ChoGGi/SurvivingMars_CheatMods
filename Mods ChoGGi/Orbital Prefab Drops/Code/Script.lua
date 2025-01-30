-- See LICENSE for terms

-- the landing func can be spammed a bit if you want to (passages), so it won't hurt to local all the funcs called for a slight bit of speed up
local AsyncRand = AsyncRand
local atan = atan
local cos = cos
local CreateGameTimeThread = CreateGameTimeThread
local GetDomeAtHex = GetDomeAtHex
local GetGameMap = GetGameMap
local IsValid = IsValid
local Max = Max
local MulDivRound = MulDivRound
local PlaceObjectIn = PlaceObjectIn
local PlaceParticles = PlaceParticles
local PlayFX = PlayFX
local point = point
local SetLen = SetLen
local SetRollPitchYaw = SetRollPitchYaw
local sin = sin
local Sleep = Sleep
local WorldToHex = WorldToHex

local mod_EnableMod
local mod_PrefabOnly
local mod_Outside
local mod_Inside
local mod_DomeCrack
local mod_ModelType

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_PrefabOnly = options:GetProperty("PrefabOnly")
	mod_Outside = options:GetProperty("Outside")
	mod_Inside = options:GetProperty("Inside")
	mod_DomeCrack = options:GetProperty("DomeCrack")
	mod_ModelType = options:GetProperty("ModelType")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local models = {
	"SupplyPod",
	"Hex1_Placeholder",
	"SupplyPod",
	"SupplyPod",
}
if g_AvailableDlc.gagarin then
	models[3] = "ArcPod"
	models[4] = "DropPod"
end

-- Also called from YamatoHasshin()
local ChoOrig_ConstructionSite_GameInit = ConstructionSite.GameInit

local delta = const.DayDuration / 20
local function DecalRemoval(land_decal)
	if not land_decal then
		return
	end

	for opacity = 100, 0, -5 do
		Sleep(delta)
		if not IsValid(land_decal) then
			return
		end
		land_decal:SetOpacity(opacity, delta)
	end
	land_decal:delete()
end

-- the rocket drop func (everything in one basket)
local guim = guim
local function YamatoHasshin(site, ...)

	-- stick the site underground by it's height then make it rise from the dead
	local site_height = point(0, 0, site:GetObjectBBox():sizez())
	if not site_height:z() then
		site_height = point(0, 0, 1500)
	end

	-- hide the actual site for now
	site:SetVisible()
	local city = site.city or UICity
	-- where the prefab is
	local spawn_pos = site:GetVisualPos()
	-- let people know something is happening
	local blinky = PlaceParticles("Rocket_Pos")
	blinky:SetColorModifier(green)
	blinky:SetPos(spawn_pos)

	local ar = AttackRover
	local sr = SupplyRocket

	-- pretty much a copy n paste of AttackRover:Spawn()... okay not anymore, but I swear it was
	CreateGameTimeThread(function(...)
		local gamemap = GetGameMap(site)

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

		local starting_pos = spawn_pos + dir
		spawn_pos = gamemap.terrain:GetIntersection(starting_pos, spawn_pos)
		local hover_pos = spawn_pos + site_height

		local pod = InvisibleObject:new()
--~ 		ex(pod)

		pod:ChangeEntity(models[mod_ModelType])
		pod:SetColorizationMaterial(1, -12845056, 0, 128)
		pod:SetColorizationMaterial(2, -16777216, 0, 128)
		pod:SetColorizationMaterial(3, -10053783, 0, 128)

		pod.fx_actor_base_class = "FXRocket"
		pod.fx_actor_class = "SupplyRocket"
		pod:SetPos(starting_pos)

		flight_dist = spawn_pos:Dist(starting_pos)
		local flight_speed = ar.spawn_flight_speed - city:Random(2500, 10000)
		local total_time = MulDivRound(1000, flight_dist, flight_speed)
		local land_time = MulDivRound(1000, ar.spawn_land_dist, flight_speed)
		local pitch = -atan(dir:Len2D(), dir:z())
		local yaw = 180*60 + atan(dir:y(), dir:x())
		SetRollPitchYaw(pod, 0, pitch, yaw, 0)

		pod:SetPos(hover_pos, total_time)
		PlayFX("RocketLand", "start", pod)
		Sleep(total_time - land_time)

		-- StartDustThread needs these
		pod.dust_radius = sr.dust_radius / 2
		pod.dust_tick = sr.dust_tick
		pod.total_dust_time = sr.total_dust_time
		pod.total_land_dust_amount = sr.total_land_dust_amount
		sr.StartDustThread(pod, pod.total_land_dust_amount, Max(0, total_time - pod.total_dust_time))

		-- mid-way
		PlayFX("RocketLand", "pre-hit-ground2", pod, false, spawn_pos)
		local accel
		accel, land_time = pod:GetAccelerationAndTime(spawn_pos, 10*guim, flight_speed)
		pod:SetAcceleration(accel)
		pod:SetPos(hover_pos, land_time)
		SetRollPitchYaw(pod, 0, 0, yaw, land_time)
		PlayFX("RocketLand", "pre-hit-ground", pod, false, spawn_pos)

		-- just for you ski
		local quarter = land_time/4
		Sleep(quarter*3)
		PlayFX("RocketLand", "hit-ground", pod, false, spawn_pos)
		if mod_DomeCrack then
			local dome = GetDomeAtHex(gamemap.object_hex_grid, WorldToHex(spawn_pos))
			if dome then
				local bm = BaseMeteor
				local _, dome_pt, dome_normal = bm.HitsDome(dome, spawn_pos)
				bm.CrackDome(dome, dome, dome_pt, dome_normal)
			end
		end
		Sleep(quarter)

		local land_decal = PlaceObjectIn(ar.land_decal_name, city.map_id)
		land_decal:SetPos(spawn_pos)
		land_decal:SetAngle(AsyncRand((360*60)+1))
		land_decal:SetScale(40 + AsyncRand(50))
		CreateGameTimeThread(DecalRemoval, land_decal)

		-- byebye blinky
		blinky:delete()

		PlayFX("RocketLand", "end", pod)

		-- stupid bad prefab
		if IsValid(site) then
			-- use shuttle fx up arrow thing
			pod.fx_actor_class = "Shuttle"
			PlayFX("ShuttleUnload", "start", pod, false, spawn_pos)

			spawn_pos = spawn_pos - site_height
			site:SetPos(spawn_pos)
			-- oh look a construction site
			site:SetVisible(true)
			spawn_pos = spawn_pos + site_height
			-- It's like jebus
			site:SetPos(spawn_pos, 3000)

			-- fire off the usual stuff so the drones make with the building
			ChoOrig_ConstructionSite_GameInit(site, ...)
		end
		PlayFX("ShuttleUnload", "end", pod, false, spawn_pos)

		pod.fx_actor_class = "SupplyRocket"
		PlayFX("RocketEngine", "start", pod)
		Sleep(sr.warm_up/2)
		PlayFX("RocketEngine", "end", pod)

		PlayFX("RocketLaunch", "start", pod)
    local time
		accel, time = pod:GetAccelerationAndTime(starting_pos, flight_speed, 1)
		SetRollPitchYaw(pod, 0, pitch, yaw, time/4)
		pod:SetAcceleration(accel)
		pod:SetPos(starting_pos, time)
		Sleep(time)

		PlayFX("RocketLaunch", "end", pod)
		-- bye bye pod
		pod:delete()

	end, ...)
end

function ConstructionSite:GameInit(...)
	if not mod_EnableMod then
		return ChoOrig_ConstructionSite_GameInit(self, ...)
	end

	-- Is inner or outer building
	local outside, inside
	for i = 1, 3 do
		local label = self.building_class_proto["label" .. i]

		if label == "OutsideBuildings" then
		 outside = true
		 break
		elseif label == "InsideBuildings" then
		 inside = true
		 break
		end

	end
	-- It's a dome/rover
	if not outside and not inside then
		outside = true
	end

	-- cables/pipes don't work that well, passages are fine, but with the detaching rockets it gets pretty busy
	local grid = self.building_class:find("GridElement") or self.building_class:find("Switch")

	-- we always allow prefabs (that's the mod...), but check if inside/outside are allowed
	if self.prefab and (outside and mod_Outside or inside and mod_Inside) then
		YamatoHasshin(self, ...)
	-- same but if prefab only is disabled
	elseif not grid and not mod_PrefabOnly and (outside and mod_Outside or inside and mod_Inside) then
		YamatoHasshin(self, ...)
	else
		ChoOrig_ConstructionSite_GameInit(self, ...)
	end
end
