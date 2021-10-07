-- See LICENSE for terms

local GetRandomPassableAround = GetRandomPassableAround

local function CheckObjs(obj)
	-- check if there's a deposit below it
	local pos = obj:GetPos()
	local objs = GetRealm(obj):MapGet(pos, 100)
	local UICity = UICity
	for i = 1, #objs do
		-- found one
		if objs[i]:IsKindOf("SubsurfaceDeposit") then
			obj:SetPos(GetRandomPassableAround(pos, 1000, 999, UICity):SetTerrainZ())
			break
		end
	end
end

local ChoOrig_SpawnObject = SA_SpawnAnomaly.SpawnObject
function SA_SpawnAnomaly.SpawnObject(...)
	local anomaly = ChoOrig_SpawnObject(...)
	CheckObjs(anomaly)
	return anomaly
end

-- fix existing ones
GlobalVar("g_ChoGGi_FixCubeAnomalyOnDeposit", false)
local function StartupCode()
	if g_ChoGGi_FixCubeAnomalyOnDeposit then
		return
	end

	local objs = MapGet("map", "SubsurfaceAnomaly")
	for i = 1, #objs do
		CheckObjs(objs[i])
	end

	g_ChoGGi_FixCubeAnomalyOnDeposit = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
