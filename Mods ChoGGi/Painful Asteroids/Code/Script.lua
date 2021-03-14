-- See LICENSE for terms

local table_unpack = table.unpack
local MapGet = MapGet
local HexShapeRadius = HexShapeRadius
local DestroyBuildingImmediate = DestroyBuildingImmediate
local const_HexHeight = const.HexHeight

local mod_EnableMod
local mod_ImpactRange
local mod_DomeAsteroidDeath

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_ImpactRange = options:GetProperty("ImpactRange")
	mod_DomeAsteroidDeath = options:GetProperty("DomeAsteroidDeath")
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
	return table_unpack(ret)
end

local orig_BaseMeteor_CrackDome = BaseMeteor.CrackDome
function BaseMeteor:CrackDome(dome, ...)
	-- little extra damage doesn't bother me
	orig_BaseMeteor_CrackDome(self, dome, ...)

	local objs = dome.labels.Buildings or ""
	if mod_DomeAsteroidDeath then
		-- kill all buildings in dome
		for i = 1, #objs do
			DestroyBuildingImmediate(objs[i])
		end

		-- Zardoz comes for you
		local units = MapGet(dome, HexShapeRadius(dome:GetBuildShape()) * const_HexHeight, "Unit")
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
		for i = 1, #objs do
			objs[i]:SetMalfunction()
		end
	end

	-- crash if a dome with stuff in it is demo'd so we can only malfunction (and I'm lazy)
	dome:SetMalfunction()
end
