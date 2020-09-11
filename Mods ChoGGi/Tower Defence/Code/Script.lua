-- See LICENSE for terms

local Sleep = Sleep
local IsValid = IsValid
local PlaceObject = PlaceObject
local GetPassablePointNearby = GetPassablePointNearby
local table_remove = table.remove

local Random = ChoGGi.ComFuncs.Random

-- redefined AttackRover to blow up after it's out of ammo or too old
DefineClass.TowerDefense_Rover = {
	__parents = {"AttackRover"},
	attack_range = 500*guim,
}

-- sometimes they get stuck in the mountains so we blow them up after a Sol
function TowerDefense_Rover:GameInit(...)
	self.TowerDefense_spawned_sol = UICity.day
	return AttackRover.GameInit(self,...)
end

local function SuicideByRocket(obj)
	obj:SetCommand("Dead")
	obj:FireRocket({target = obj},nil,true)
	repeat
		Sleep(500)
	until obj.suicide_by_rocket
	obj.city:RemoveFromLabel("HostileAttackRovers", obj)
	obj.city:RemoveFromLabel("Rover", obj)
	DeleteThread(obj.track_thread)
	obj:delete()
end

function TowerDefense_Rover:FireRocket(luaobj, rocket_class, byebye)
	rocket_class = rocket_class or "RocketProjectile"

	self:SetAnim(1, "attackStart")
	Sleep(self:TimeToAnimEnd())
	self:SetAnim(1, "attackIdle")
	Sleep(500)
	local rocket = PlaceObject(rocket_class, luaobj)
	local spot = self:GetSpotBeginIndex("Rocket")
	local pos = self:GetSpotLoc(spot)
	rocket.shooter = self
	rocket:SetPos(pos)
	rocket.move_dir = axis_z
	rocket:StartMoving()

	PlayFX("MissileFired", "start", self, nil, pos, axis_z)

	self:SetAnim(1, "attackEnd")
	Sleep(self:TimeToAnimEnd())
	if byebye then
		self.suicide_by_rocket = true
	-- get rid of any ones that're out of ammo
	elseif not self.attacks_remaining or self.attacks_remaining == 0 then
		CreateGameTimeThread(SuicideByRocket,self)
	end
end

local function LoadMapSectorsStats()
	local UICity = UICity
	if not UICity then
		return
	end

	-- store amounts per save here
	if not UICity.ChoGGi_TowerDefense then
		-- build list of out map sectors (all of 1 and 10, and the top/bottom from the rest
		local g_MapSectors = g_MapSectors
		local sector_table = {}
		local c = 0

		local function AddOneTen(sector)
			for i = 1, #sector do
				c = c + 1
				sector_table[c] = sector[i]
			end
		end
		AddOneTen(g_MapSectors[1])
		AddOneTen(g_MapSectors[10])

		local function AddFirstLast(sector)
			c = c + 1
			sector_table[c] = sector[1]
			c = c + 1
			sector_table[c] = sector[10]
		end
		AddFirstLast(g_MapSectors[2])
		AddFirstLast(g_MapSectors[3])
		AddFirstLast(g_MapSectors[4])
		AddFirstLast(g_MapSectors[5])
		AddFirstLast(g_MapSectors[6])
		AddFirstLast(g_MapSectors[7])
		AddFirstLast(g_MapSectors[8])
		AddFirstLast(g_MapSectors[9])

		UICity.ChoGGi_TowerDefense = {
			rovers_next = 5,
			ammo_next = 4,
			sectors = sector_table,
			count = c,
		}
	end
end

OnMsg.MapSectorsReady = LoadMapSectorsStats
OnMsg.LoadGame = LoadMapSectorsStats

local function RemoveOldRovers(label,sol)
	for i = #(label or ""), 1, -1 do
		local r = label[i]
		if not IsValid(r) then
			table_remove(label,i)
		elseif r.class == "TowerDefense_Rover" and r.TowerDefense_spawned_sol ~= sol then
			CreateGameTimeThread(SuicideByRocket,r)
		end
	end

end

function OnMsg.NewDay(sol)
	CreateGameTimeThread(function()
		-- let other stuff go first
		Sleep(1000)

		if sol > 24 and not IsTechDiscovered("DefenseTower") then
			UICity:SetTechDiscovered("DefenseTower")
		end

		if sol < 49 then
			return
		end

		local UICity = UICity

		-- remove any old rovers stuck in the mountains
		RemoveOldRovers(UICity.labels.HostileAttackRovers,sol)
		RemoveOldRovers(UICity.labels.Rover,sol)

		-- just in case
		if not UICity.ChoGGi_TowerDefense then
			LoadMapSectorsStats()
		end

		local stats = UICity.ChoGGi_TowerDefense
		for _ = 1, #stats.rovers_next do
			-- add a bit of a random delay
			Sleep(Random(2500,10000))
			-- muhhahahaha
			local r = PlaceObject("TowerDefense_Rover", {
--~ 				spawn_pos = GetRandomPassableAround(stats.sectors[Random(1,stats.count)]:GetVisualPos(), 250),
				spawn_pos = GetPassablePointNearby(stats.sectors[Random(1,stats.count)]:GetVisualPos()),
				attacks_remaining = stats.ammo_next,
			})
			-- need to make 'em nasty
			Sleep(250)
			r:SetCommand("Idle")
		end

		-- bump the stats
		stats.rovers_next = stats.rovers_next + 1
		stats.ammo_next = stats.ammo_next + 2

		-- I doubt anyone will make it to max_int rovers, but what the hell
		if stats.rovers_next < 0 then
			stats.rovers_next = 5
		end
		if stats.ammo_next < 0 then
			stats.ammo_next = 4
		end

	end)
end
