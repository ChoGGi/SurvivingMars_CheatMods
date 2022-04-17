-- See LICENSE for terms

local GetCity = GetCity
local AsyncRand = AsyncRand
local GetRandomPassableAround = GetRandomPassableAround

local mod_EnableMod
local mod_MaxDeposits

local min, max = 0, 21600
local function SpawnConcreteChunks(obj)
	local city = GetCity(obj)
	for _ = 1, mod_MaxDeposits do
		local pos = GetRandomPassableAround(
			obj,
			8000, 500, city
		)

		local deposit = SurfaceDepositConcrete:new()
		deposit:SetPos(pos)
		deposit:SetAngle(AsyncRand(max - min + 1) + min)
	end
end

GlobalVar("g_ChoGGi_SurfaceConcrete_Spawned", false)

local function StartupCode()
	if not mod_EnableMod or g_ChoGGi_SurfaceConcrete_Spawned then
		return
	end

	SuspendPassEdits("ChoGGi_SurfaceConcrete_Spawning")
	-- Asteroids have concrete right?
	local objs = UIColony:GetCityLabels("TerrainDepositMarker")
	for i = 1, #objs do
		local obj = objs[i]
		-- Only spawn deposit chunks around visible deposits
		if IsValid(obj.placed_obj) then
			SpawnConcreteChunks(obj)
		end
	end
	ResumePassEdits("ChoGGi_SurfaceConcrete_Spawning")

	g_ChoGGi_SurfaceConcrete_Spawned = true
end
function OnMsg.CityStart()
	CreateRealTimeThread(function()
		-- CityStart happens before the game map is generated, DepositsSpawned happens everytime a sector is scanned.
		WaitMsg("DepositsSpawned")
		StartupCode()
	end)
end

OnMsg.LoadGame = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_MaxDeposits = CurrentModOptions:GetProperty("MaxDeposits")

	-- Make sure we're in-game UIColony
	if not UICity then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_TerrainDepositMarker_SpawnDeposit = TerrainDepositMarker.SpawnDeposit
function TerrainDepositMarker:SpawnDeposit(...)
	if mod_EnableMod then
		SuspendPassEdits("ChoGGi_SurfaceConcrete_Spawning")
		SpawnConcreteChunks(self)
		ResumePassEdits("ChoGGi_SurfaceConcrete_Spawning")
	end
	return ChoOrig_TerrainDepositMarker_SpawnDeposit(self, ...)
end
