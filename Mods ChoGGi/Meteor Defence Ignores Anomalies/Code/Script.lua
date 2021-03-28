-- See LICENSE for terms

local mod_EnableMod
local mod_IgnoreAnomalies
local mod_IgnoreMetals
local mod_IgnorePolymers

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_IgnoreAnomalies = options:GetProperty("IgnoreAnomalies")
	mod_IgnoreMetals = options:GetProperty("IgnoreMetals")
	mod_IgnorePolymers = options:GetProperty("IgnorePolymers")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function AbortDefence(func, self, meteor, ...)
	if mod_EnableMod then
		local deposit_type = meteor.deposit_type
		if deposit_type == "Metals" and mod_IgnoreMetals then
			return
		elseif deposit_type == "Polymers" and mod_IgnorePolymers then
			return
		elseif deposit_type == "Anomaly" and mod_IgnoreAnomalies then
			return
		end
	end

	return func(self, meteor, ...)
end

local orig_MDSLaser_Track = MDSLaser.Track
function MDSLaser:Track(meteor, ...)
	return AbortDefence(orig_MDSLaser_Track, self, meteor, ...)
end

local orig_DefenceTower_Track = DefenceTower.Track
function DefenceTower:Track(meteor, ...)
	return AbortDefence(orig_DefenceTower_Track, self, meteor, ...)
end
