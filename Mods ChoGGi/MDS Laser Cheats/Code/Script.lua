-- See LICENSE for terms

local mod_HitChance
local mod_FireRate
local mod_ProtectRange
local mod_ShootRange
local mod_RotateSpeed
local mod_BeamTime

local function UpdateLasers()
	local objs =  UIColony.city_labels.labels.MDSLaser or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.hit_chance = mod_HitChance
		obj.cooldown = mod_FireRate
		obj.protect_range = mod_ProtectRange
		obj.shoot_range = mod_ShootRange
		obj.rot_speed = mod_RotateSpeed
		obj.beam_time = mod_BeamTime
	end
end
OnMsg.CityStart = UpdateLasers
OnMsg.LoadGame = UpdateLasers

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_HitChance = options:GetProperty("HitChance")
	mod_FireRate = options:GetProperty("FireRate")
	mod_ProtectRange = options:GetProperty("ProtectRange")
	mod_ShootRange = options:GetProperty("ShootRange")
	mod_RotateSpeed = options:GetProperty("RotateSpeed") * 60
	mod_BeamTime = options:GetProperty("BeamTime")

	-- make sure we're in-game
	if not UIColony then
		return
	end
	UpdateLasers()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
