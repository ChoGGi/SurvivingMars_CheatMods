-- See LICENSE for terms

local RetMapType = ChoGGi_Funcs.Common.RetMapType
local max_resource = 500000 * const.ResourceScale


local mod_EnableMod
local mod_SkipAsteroids
local mod_UndergroundDeposits
local mod_MaxGrade

local MaxFillAll

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_SkipAsteroids = CurrentModOptions:GetProperty("SkipAsteroids")
	mod_UndergroundDeposits = CurrentModOptions:GetProperty("UndergroundDeposits")
	mod_MaxGrade = CurrentModOptions:GetProperty("MaxGrade")

	MaxFillAll()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- depth_layer: 2 = core, 1 = underground
local function MaxDeposits(objs)


	for i = 1, #objs do
		local obj = objs[i]
		-- check for ast
		if not mod_SkipAsteroids or mod_SkipAsteroids and RetMapType(obj) ~= "asteroid" then
			if obj.depth_layer == 1 and mod_UndergroundDeposits then
				obj.max_amount = max_resource
				if mod_MaxGrade then
					obj.grade = "Very High"
				end

			elseif obj.depth_layer == 2 then
				obj.max_amount = max_resource
				if mod_MaxGrade then
					obj.grade = "Very High"
				end
			end
		end
	end
end

local function RefillAllDeposits(objs)
	for i = 1, #objs do
		local obj = objs[i]
		if not mod_SkipAsteroids or mod_SkipAsteroids and RetMapType(obj) ~= "asteroid" then

			if obj.depth_layer == 1 and mod_UndergroundDeposits then
				obj:CheatRefill()

			elseif obj.depth_layer == 2 then
				obj:CheatRefill()
			end

		end

	end
end

MaxFillAll = function()
	if not mod_EnableMod then
		return
	end

	if UIColony then
		local labels = UIColony.city_labels.labels

		MaxDeposits(labels.SubsurfaceDeposit or "")
		RefillAllDeposits(labels.SubsurfaceDeposit or "")
		MaxDeposits(labels.TerrainDeposit or "")
		RefillAllDeposits(labels.TerrainDeposit or "")
	end
end

-- saved games
OnMsg.LoadGame = MaxFillAll
-- new sol
function OnMsg.NewDay()
	if not mod_EnableMod then
		return
	end

	local labels = UIColony.city_labels.labels
	RefillAllDeposits(labels.SubsurfaceDeposit or "")
	RefillAllDeposits(labels.TerrainDeposit or "")
end

--
local function DepositRevealed(obj)
	if not mod_EnableMod then
		return
	end

	if mod_SkipAsteroids and RetMapType(obj) == "asteroid" then
		return
	end

	if obj.depth_layer == 1 and mod_UndergroundDeposits then
		obj.max_amount = max_resource
		if mod_MaxGrade then
			obj.grade = "Very High"
		end
		obj:CheatRefill()

	elseif obj.depth_layer == 2 then
		obj.max_amount = max_resource
		if mod_MaxGrade then
			obj.grade = "Very High"
		end
		obj:CheatRefill()
	end
end

OnMsg.WaterDepositRevealed = DepositRevealed
OnMsg.SubsurfaceDepositRevealed = DepositRevealed
-- Added below
OnMsg.TerrainDepositRevealed = DepositRevealed

-- needed till they add a Msg like above
local ChoOrig_TerrainDepositMarker_SpawnDeposit = TerrainDepositMarker.SpawnDeposit
function TerrainDepositMarker.SpawnDeposit(...)
	if not mod_EnableMod then
		return ChoOrig_TerrainDepositMarker_SpawnDeposit(...)
	end

	local deposit = ChoOrig_TerrainDepositMarker_SpawnDeposit(...)
	Msg("TerrainDepositRevealed", deposit)
	return deposit
end

-- The other stuff has the CheatRefill() func, TerrainDeposit doesn't, so added for ease of use
if not TerrainDeposit.CheatRefill then
	function TerrainDeposit:CheatRefill()
		self.amount = self.max_amount
	end
end
