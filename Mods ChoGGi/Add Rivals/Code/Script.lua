-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed!")
	return
end

local PickUnusedAISponsor = ChoGGi.ComFuncs.PickUnusedAISponsor

local mod_EnableMod
local mod_AddRivals

local function AddRivals()
	if not mod_EnableMod then
		return
	end

	-- The devs added a check for non-existant keys in the hr table (and _G, but that's another story)
	-- using rawset bypasses the check and prevents log spam (Trying to create new value hr.PlanetColony6Longitude)
	if not hr.PlanetColony5Longitude then
		local rawset = rawset
		local hr = hr
		for i = 5, 20 do
			rawset(hr, "PlanetColony" .. i .. "Longitude", 0)
			rawset(hr, "PlanetColony" .. i .. "Latitude", 0)
		end
	end

	-- add stuff missing from saves
	if not g_CurrentMissionParams.idRivalColonies then
		g_CurrentMissionParams.idRivalColonies = {
			"random",
			"random",
			"random"
		}
	end
	if not RivalAIs then
		RivalAIs = {}
	end
	local RivalAIs = RivalAIs

	local rival_count = table.count(RivalAIs)
	local def_count = #Presets.DumbAIDef.MissionSponsors
	-- Already maxed out
	if rival_count == def_count then
		return
	end

	local SpawnRivalAI = SpawnRivalAI
	for _ = 1, def_count do
		-- Stop spawning when we're maxed out
		if rival_count >= def_count or rival_count >= mod_AddRivals then
			break
		end

		-- Random rival
		local sponsor = PickUnusedAISponsor()
		if sponsor then
			SpawnRivalAI(sponsor)
		end
		rival_count = rival_count + 1
	end

end
OnMsg.LoadGame = AddRivals

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_AddRivals = CurrentModOptions:GetProperty("AddRivals")

	-- make sure we're in-game
	if not UIColony then
		return
	end

	AddRivals()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
