-- See LICENSE for terms

MarkDepositGround = {
	HideSigns = false,
	AlienAnomaly = false,
	ShowConstruct = true,
}

MarkDepositGround.UpdateOpacity = function(label,value)
	value = value and 0 or 100
	local deposits = UICity.labels[label] or ""
	for i = 1, #deposits do
		local d = deposits[i]
		d:SetOpacity(value)
		if not d.ground_is_marked then
			MarkDepositGround.UpdateDeposit(d)
		end
	end
end

local AsyncRand = AsyncRand
local GridOpFree = GridOpFree
local AsyncSetTypeGrid = AsyncSetTypeGrid
local sqrt = sqrt
local MulDivRound = MulDivRound

local TerrainTextures = TerrainTextures
local NoisePreset = DataInstances.NoisePreset

local table_find = table.find
local texture_metal = table_find(TerrainTextures, "name", "RockDark") + 1
local texture_mpres = table_find(TerrainTextures, "name", "GravelDark") + 1
local texture_water = table_find(TerrainTextures, "name", "Spider") + 1

MarkDepositGround.UpdateDeposit = function(d)
	if d:IsKindOf("EffectDeposit") then
		return
	end

	local pattern = NoisePreset.ConcreteForm:GetNoise(128, AsyncRand())
	pattern:land_i(NoisePreset.ConcreteNoise:GetNoise(128, AsyncRand()))

	if d:IsKindOf("SubsurfaceDepositMetals") then
		pattern:mul_i(texture_metal, 1)
	elseif d:IsKindOf("SubsurfaceDepositPreciousMetals") then
		pattern:mul_i(texture_mpres, 1)
	elseif d:IsKindOf("SubsurfaceDepositWater") then
		pattern:mul_i(texture_water, 1)
	else
		return
	end

	pattern:sub_i(1, 1)
	pattern = GridOpFree(pattern, "repack", 8)

	local scale = 100
	if d.max_amount == 500000000 then
		scale = 200
	elseif d.max_amount == 100000000 then
		scale = 150
	elseif d.max_amount == 50000000 then
		scale = 135
	elseif d.max_amount == 25000000 then
		scale = 120
	else
		scale = sqrt(MulDivRound(d.max_amount/1000, 10, 10))
	end

	scale = scale + 20

	AsyncSetTypeGrid{
		type_grid = pattern,
		pos = d:GetPos(),
		scale = scale,
		centered = true,
		invalid_type = -1,
	}

	-- we only want it to fire once per deposit
	d.ground_is_marked = true
end

local function HideSigns()
	-- gotta use SetOpacity as SetVisible is set when you zoom out
	local value = MarkDepositGround.HideSigns and 0 or 100

	MarkDepositGround.UpdateOpacity("SubsurfaceDeposit",value)
	MarkDepositGround.UpdateOpacity("EffectDeposit",value)

	local deposits = UICity.labels.TerrainDeposit or ""
	for i = 1, #deposits do
		deposits[i]:SetOpacity(value)
	end

	deposits = UICity.labels.EffectDeposit or ""
	for i = 1, #deposits do
		local d = deposits[i]
		if d.ChoGGi_alien then
			d:ChangeEntity(d.ChoGGi_alien)
			d:SetScale(100)
			d:SetAngle(0)
			d.ChoGGi_alien = nil
		end
	end
end

OnMsg.CityStart = HideSigns
OnMsg.LoadGame = HideSigns

-- update as they become visible
function OnMsg.SubsurfaceDepositRevealed(d)
	d:SetOpacity(MarkDepositGround.HideSigns and 0 or 100)
	if not d.ground_is_marked then
		MarkDepositGround.UpdateDeposit(d)
	end
end

-- concrete deposits don't spawn till map sector scanned
local orig_TerrainDepositMarker_SpawnDeposit = TerrainDepositMarker.SpawnDeposit
function TerrainDepositMarker:SpawnDeposit(...)
	local d = orig_TerrainDepositMarker_SpawnDeposit(self,...)
	d:SetOpacity(MarkDepositGround.HideSigns and 0 or 100)
	return d
end

-- same with anomalies
local orig_SubsurfaceAnomalyMarker_SpawnDeposit = SubsurfaceAnomalyMarker.SpawnDeposit
function SubsurfaceAnomalyMarker:SpawnDeposit(...)
	local a = orig_SubsurfaceAnomalyMarker_SpawnDeposit(self,...)
	if MarkDepositGround.AlienAnomaly then
		CreateRealTimeThread(function()
			-- needs a delay for some reason
			Sleep(50)
			a.ChoGGi_alien = a:GetEntity()
			a:ChangeEntity("GreenMan")
			a:SetScale(500)
			a:SetAngle(AsyncRand())
		end)
	end
	return a
end
