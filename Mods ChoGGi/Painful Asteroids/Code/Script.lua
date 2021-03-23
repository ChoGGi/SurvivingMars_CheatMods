-- See LICENSE for terms

local table = table
local AsyncRand = AsyncRand
local floatfloor = floatfloor
local MapGet = MapGet
local HexShapeRadius = HexShapeRadius
local DestroyBuildingImmediate = DestroyBuildingImmediate
local const_HexHeight = const.HexHeight

local mod_EnableMod
local mod_ImpactRange
local mod_DomeAsteroidDeath
local mod_DestructionPercent
local mod_ExtraFractures

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_ImpactRange = options:GetProperty("ImpactRange")
	mod_DomeAsteroidDeath = options:GetProperty("DomeAsteroidDeath")
	mod_DestructionPercent = options:GetProperty("DestructionPercent") / 100.0
	mod_ExtraFractures = options:GetProperty("ExtraFractures")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_BaseMeteor_GetQuery = BaseMeteor.GetQuery
function BaseMeteor:GetQuery(...)
	local orig_range = self.range
	self.range = self.range * mod_ImpactRange
	local ret = {orig_BaseMeteor_GetQuery(self, ...)}
	self.range = orig_range
	return table.unpack(ret)
end

local orig_BaseMeteor_CrackDome = BaseMeteor.CrackDome
function BaseMeteor:CrackDome(dome, ...)
	for i = 1, mod_ExtraFractures do
		orig_BaseMeteor_CrackDome(self, dome)
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
		local units = MapGet(dome, (HexShapeRadius(dome:GetBuildShape()) * const_HexHeight), "Unit")
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
