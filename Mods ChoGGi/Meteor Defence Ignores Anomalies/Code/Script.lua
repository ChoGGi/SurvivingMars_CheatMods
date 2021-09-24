-- See LICENSE for terms

local mod_EnableMod
local mod_IgnoreAnomalies
local mod_IgnoreMetals
local mod_IgnorePolymers

local function TestRemoveMeteor(deposit_type)
	-- it's usually rocks
	if deposit_type == "Rocks" then
		return true
	elseif deposit_type == "Metals" and mod_IgnoreMetals then
		return false
	elseif deposit_type == "Polymers" and mod_IgnorePolymers then
		return false
	elseif deposit_type == "Anomaly" and mod_IgnoreAnomalies then
		return false
	end

	return true
end

local function CheckMeteors()
	if not mod_EnableMod then
		return
	end

	local meteors = g_MeteorsPredicted or ""
	for i = #meteors, 1, -1 do
		local meteor = meteors[i]
		if TestRemoveMeteor(meteor.deposit_type) then
			-- refire the msg that we blocked in :Track()
			Msg("Meteor", meteor)
		end
	end
end

OnMsg.CityStart = CheckMeteors
OnMsg.LoadGame = CheckMeteors

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_IgnoreAnomalies = options:GetProperty("IgnoreAnomalies")
	mod_IgnoreMetals = options:GetProperty("IgnoreMetals")
	mod_IgnorePolymers = options:GetProperty("IgnorePolymers")

	-- make sure we're in-game
	if not UICity then
		return
	end

	CheckMeteors()
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
	if mod_EnableMod and not TestRemoveMeteor(meteor.deposit_type) then
		return
	end

	return func(self, meteor, ...)
end

local ChoOrig_MDSLaser_Track = MDSLaser.Track
function MDSLaser:Track(meteor, ...)
	return AbortDefence(ChoOrig_MDSLaser_Track, self, meteor, ...)
end

local ChoOrig_DefenceTower_Track = DefenceTower.Track
function DefenceTower:Track(meteor, ...)
	return AbortDefence(ChoOrig_DefenceTower_Track, self, meteor, ...)
end
