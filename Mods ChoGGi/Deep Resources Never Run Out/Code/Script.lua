-- See LICENSE for terms

local mod_UndergroundDeposits
local mod_MaxGrade

local MaxFillAll

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_UndergroundDeposits = CurrentModOptions:GetProperty("UndergroundDeposits")
	mod_MaxGrade = CurrentModOptions:GetProperty("MaxGrade")

	MaxFillAll()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local max = 500000 * const.ResourceScale

-- depth_layer: 2 = core, 1 = underground
local function MaxDeposits(objs)
	for i = 1, #objs do
		local obj = objs[i]
		if obj.depth_layer == 1 and mod_UndergroundDeposits then
			obj.max_amount = max
			if mod_MaxGrade then
				obj.grade = "Very High"
			end

		elseif obj.depth_layer == 2 then
			obj.max_amount = max
			if mod_MaxGrade then
				obj.grade = "Very High"
			end
		end
	end
end

local function RefillAllDeposits(objs)
	for i = 1, #objs do
		local obj = objs[i]

		if obj.depth_layer == 1 and mod_UndergroundDeposits then
			obj:CheatRefill()

		elseif obj.depth_layer == 2 then
			obj:CheatRefill()
		end

	end
end

-- needed
if not TerrainDeposit.CheatRefill then
	function TerrainDeposit:CheatRefill()
		self.amount = self.max_amount
	end
end

MaxFillAll = function()
	local UIColony = UIColony
	if UIColony then
		MaxDeposits(UIColony.city_labels.labels.SubsurfaceDeposit or "")
		RefillAllDeposits(UIColony.city_labels.labels.SubsurfaceDeposit or "")
		MaxDeposits(UIColony.city_labels.labels.TerrainDeposit or "")
		RefillAllDeposits(UIColony.city_labels.labels.TerrainDeposit or "")
	end
end

-- saved games
OnMsg.LoadGame = MaxFillAll
-- new sol
function OnMsg.NewDay()
	RefillAllDeposits(UIColony.city_labels.labels.SubsurfaceDeposit or "")
	RefillAllDeposits(UIColony.city_labels.labels.TerrainDeposit or "")
end

--
local function DepositRevealed(obj)
	if obj.depth_layer == 1 and mod_UndergroundDeposits then
		obj.max_amount = max
		if mod_MaxGrade then
			obj.grade = "Very High"
		end
		obj:CheatRefill()

	elseif obj.depth_layer == 2 then
		obj.max_amount = max
		if mod_MaxGrade then
			obj.grade = "Very High"
		end
		obj:CheatRefill()
	end
end

OnMsg.WaterDepositRevealed = DepositRevealed
OnMsg.SubsurfaceDepositRevealed = DepositRevealed

-- needed till they add a Msg like above
local ChoOrig_SpawnDeposit = TerrainDepositMarker.SpawnDeposit
function TerrainDepositMarker.SpawnDeposit(...)
	local deposit = ChoOrig_SpawnDeposit(...)
	DepositRevealed(deposit)
	return deposit
end
