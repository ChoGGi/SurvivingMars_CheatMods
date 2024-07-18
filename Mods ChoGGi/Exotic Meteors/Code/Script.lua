-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

local bb_dlc = g_AvailableDlc.picard

local mod_EnableMod
local mod_RocksChance
local mod_MetalsChance
local mod_RareMetalsChance
local mod_ExoticMineralsChance
local mod_PolymersChance
local mod_AnomalyChance

local function ModOptions(id)
	-- Id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_RocksChance = CurrentModOptions:GetProperty("RocksChance")
	mod_MetalsChance = CurrentModOptions:GetProperty("MetalsChance")
	mod_RareMetalsChance = CurrentModOptions:GetProperty("RareMetalsChance")
	mod_ExoticMineralsChance = CurrentModOptions:GetProperty("ExoticMineralsChance")
	mod_PolymersChance = CurrentModOptions:GetProperty("PolymersChance")
	mod_AnomalyChance = CurrentModOptions:GetProperty("AnomalyChance")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_GenerateMeteor = GenerateMeteor
function GenerateMeteor(...)
	if not mod_EnableMod then
		return ChoOrig_GenerateMeteor(...)
	end

	local result, meteor = pcall(ChoOrig_GenerateMeteor, ...)
	if result then
		local chance = SessionRandom:Random(100)

		if chance < mod_RocksChance then
			meteor.deposit_type = "Rocks"
		elseif chance < mod_RocksChance + mod_MetalsChance then
			meteor.deposit_type = "Metals"
		elseif chance < mod_RocksChance + mod_MetalsChance + mod_PolymersChance then
			meteor.deposit_type = "Polymers"
		elseif chance < mod_RocksChance + mod_MetalsChance + mod_PolymersChance + mod_RareMetalsChance then
			meteor.deposit_type = "PreciousMetals"
		elseif chance < mod_RocksChance + mod_MetalsChance + mod_PolymersChance + mod_RareMetalsChance + mod_ExoticMineralsChance then
			if bb_dlc then
				meteor.deposit_type = "PreciousMinerals"
			else
				meteor.deposit_type = "PreciousMetals"
			end
		else
			meteor.deposit_type = "Anomaly"
		end
	end

	return meteor
end

-- I could add new prefabs, or I could just override the func and change the resource
BaseMeteorSmall.prefabs.PreciousMetals = { "Any.Gameplay.MeteorImpMetalS_01", "Any.Gameplay.MeteorImpMetalS_03" }
BaseMeteorLarge.prefabs.PreciousMetals = { "Any.Gameplay.MeteorImpMetalB_01", "Any.Gameplay.MeteorImpMetalB_03" }
BaseMeteorSmall.prefabs.PreciousMinerals = { "Any.Gameplay.MeteorImpPolyS_01", "Any.Gameplay.MeteorImpPolyS_03" }
BaseMeteorLarge.prefabs.PreciousMinerals = { "Any.Gameplay.MeteorImpPolyB_01", "Any.Gameplay.MeteorImpPolyB_03" }

-- the game has some blank entities it uses, and they don't show up on impact.
-- I should add this to Fix Bugs...
local missing_entity_lookup = {
	SurfaceDepositMetals_03 = "SurfaceDeposit_Asteroid_Iron_01",
	SurfaceDepositMetals_04 = "SurfaceDeposit_Asteroid_Iron_02",
	SurfaceDepositMetals_05 = "SurfaceDeposit_Asteroid_Iron_03",
	SurfaceDeposit_Asteroid_RareMinerals_04 = "SurfaceDepositRareMinerals_01",
	SurfaceDeposit_Asteroid_RareMinerals_05 = "SurfaceDepositRareMinerals_02",
	SurfaceDeposit_Asteroid_Metals_04 = "SurfaceDepositIronMeteor_01",
	SurfaceDeposit_Asteroid_Metals_05 = "SurfaceDepositIronMeteor_01",
}
local missing_entity_lookup_nodlc = {
	SurfaceDepositMetals_03 = "SurfaceDepositMetals_01",
	SurfaceDepositMetals_04 = "SurfaceDepositMetals_02",
	SurfaceDepositMetals_05 = "RocksSlate_07",
}

local meteor_type
local ChoOrig_PlacePrefab = PlacePrefab
local ChoFake_PlacePrefab = function(...)
	if not meteor_type then
		return ChoOrig_PlacePrefab(...)
	end

	local err, bbox, objs = ChoOrig_PlacePrefab(...)
	for i = 1, #objs do
		local obj = objs[i]
		if obj:IsKindOf("SurfaceDepositMarker") then
			if meteor_type == "PreciousMetals" or meteor_type == "PreciousMinerals" then
				obj.resource = meteor_type

				-- it always shows 0 for rare metals...
				if meteor_type == "PreciousMetals" then
					obj.max_amount = SessionRandom:Random(1, 8) * const.ResourceScale
				end

				if bb_dlc then
					obj.entity = obj.entity:gsub("SurfaceDepositPolymers", "SurfaceDeposit_Asteroid_RareMinerals")
						:gsub("SurfaceDepositMetals", "SurfaceDeposit_Asteroid_Metals")
				else
					obj.entity = obj.entity:gsub("SurfaceDepositMetals", "RocksLightSmall")
				end
				-- variant does nothing for these
				obj.entity_variant = obj.entity
			end

			-- Fix blank entities for all meteorites
			local missing
			if bb_dlc then
				missing = missing_entity_lookup[obj.entity]
			else
				missing = missing_entity_lookup_nodlc[obj.entity]
			end
			if missing then
				obj.entity = missing
				obj.entity_variant = missing
			end

		end
	end
	return err, bbox, objs
end

local ChoOrig_BaseMeteor_SpawnPrefab = BaseMeteor.SpawnPrefab
function BaseMeteor:SpawnPrefab(...)
	if not mod_EnableMod then
		return ChoOrig_BaseMeteor_SpawnPrefab(self, ...)
	end

	-- override func that gens prefab and replace resource type, then return as usual
	PlacePrefab = ChoFake_PlacePrefab
	meteor_type = self.deposit_type
	local _, ret_value = pcall(ChoOrig_BaseMeteor_SpawnPrefab, self, ...)
	PlacePrefab = ChoOrig_PlacePrefab
	meteor_type = nil

	return ret_value
end