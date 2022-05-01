-- See LICENSE for terms

local table = table
local AsyncRand = AsyncRand
local floatfloor = floatfloor
local HexShapeRadius = HexShapeRadius
local DestroyBuildingImmediate = DestroyBuildingImmediate
local const_HexHeight = const.HexHeight

local mod_EnableMod
local mod_ImpactRange
local mod_DomeAsteroidDeath
local mod_DestructionPercent
local mod_ExtraFractures

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_ImpactRange = options:GetProperty("ImpactRange")
	mod_DomeAsteroidDeath = options:GetProperty("DomeAsteroidDeath")
	mod_DestructionPercent = options:GetProperty("DestructionPercent") / 100.0
	mod_ExtraFractures = options:GetProperty("ExtraFractures")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_BaseMeteor_GetQuery = BaseMeteor.GetQuery
function BaseMeteor:GetQuery(...)
	local ChoOrig_range = self.range
	self.range = self.range * mod_ImpactRange
	local ret = {ChoOrig_BaseMeteor_GetQuery(self, ...)}
	self.range = ChoOrig_range
	return table.unpack(ret)
end

local ChoOrig_BaseMeteor_CrackDome = BaseMeteor.CrackDome
function BaseMeteor:CrackDome(dome, ...)
	for _ = 1, mod_ExtraFractures do
		ChoOrig_BaseMeteor_CrackDome(self, dome)
	end

	local objs = dome.labels.Buildings
	if not objs then
		dome:SetMalfunction()
		return
	end
	objs = table.icopy(objs)
	table.shuffle(objs, AsyncRand)

	local objs_count = #objs
	-- how many to kill
	if objs_count > 1 then
		objs_count = floatfloor(mod_DestructionPercent * objs_count)
	end

	if mod_DomeAsteroidDeath then
		-- kill all buildings in dome
		for i = 1, objs_count do
			DestroyBuildingImmediate(objs[i])
		end

		-- Zardoz comes for you
		local units = GetRealm(self):MapGet(dome, (HexShapeRadius(dome:GetBuildShape()) * const_HexHeight), "Unit")
		for i = 1, #units do
			local unit = units[i]
			-- drones/rovers (don't park your rovers right next to your domes)
			if unit:IsKindOf("DroneBase") then
				unit:SetCommand("Dead", false, "meteor")
			else
				-- Colonist/Pet
				unit:SetCommand("Die", "meteor")
			end
		end
	else
		-- malfunction every building in dome
		for i = 1, objs_count do
			objs[i]:SetMalfunction()
		end
	end

	-- crash if a dome with stuff in it is demo'd so we can only malfunction (and I'm lazy)
	dome:SetMalfunction()
end
