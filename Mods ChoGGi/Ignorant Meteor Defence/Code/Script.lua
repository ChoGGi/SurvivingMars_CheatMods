-- See LICENSE for terms

local table = table
local GetRealm = GetRealm

local mod_EnableMod
local mod_IgnoreAnomalies
local mod_IgnoreMetals
local mod_IgnorePolymers
local mod_IgnoreNoBuildings

-- true = remove, false = keep
local function TestRemoveMeteor(meteor)
	if mod_IgnoreNoBuildings then
		local q = {meteor:GetQuery()}
		-- Remove Units from the query since they move around so it's a waste to bother checking
		-- close enough, lua rev 1010999
		if q[3] == "Drone" then
			table.remove(q, 3)
		end
		if q[3] == "Colonist" then
			table.remove(q, 3)
		end
		-- an idle rover could be considered worth more than a meteor
--~ 		if q[4] == "BaseRover" then
--~ 			table.remove(q, 4)
--~ 		end

		local objs = GetRealm(meteor):MapGet(table.unpack(q))
		if #objs < 1 then
			return false
		end
	end

	local deposit_type = meteor.deposit_type
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
		if TestRemoveMeteor(meteor) then
			-- "re"fire the msg that we blocked in :Track()
			Msg("Meteor", meteor)
		end
	end
end

OnMsg.CityStart = CheckMeteors
OnMsg.LoadGame = CheckMeteors

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_IgnoreAnomalies = options:GetProperty("IgnoreAnomalies")
	mod_IgnoreMetals = options:GetProperty("IgnoreMetals")
	mod_IgnorePolymers = options:GetProperty("IgnorePolymers")
	mod_IgnoreNoBuildings = options:GetProperty("IgnoreNoBuildings")

	-- make sure we're in-game
	if not UIColony then
		return
	end

	CheckMeteors()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function AbortDefence(func, self, meteor, ...)
	if mod_EnableMod and not TestRemoveMeteor(meteor) then
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
