-- See LICENSE for terms

local mod_HitChance
local mod_FireRate
local mod_ProtectRange
local mod_ShootRange
local mod_RotateSpeed
local mod_BeamTime

local function UpdateLasers()
	local objs =  UICity.labels.MDSLaser or ""
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


-- fired when settings are changed/init
local function ModOptions()
	mod_HitChance = CurrentModOptions:GetProperty("HitChance")
	mod_FireRate = CurrentModOptions:GetProperty("FireRate")
	mod_ProtectRange = CurrentModOptions:GetProperty("ProtectRange") * guim
	mod_ShootRange = CurrentModOptions:GetProperty("ShootRange") * guim
	mod_RotateSpeed = CurrentModOptions:GetProperty("RotateSpeed") * 60
	mod_BeamTime = CurrentModOptions:GetProperty("BeamTime")

	-- make sure we're ingame
	if not UICity then
		return
	end
	UpdateLasers()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = UpdateLasers
OnMsg.LoadGame = UpdateLasers
