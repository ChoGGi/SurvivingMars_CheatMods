-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed!")
	return
end

local mod_MaxRivals

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_MaxRivals = CurrentModOptions:GetProperty("MaxRivals")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function StartupCode()
	-- abort if there's no rivals
	if not RivalAIs then
		return
	end

	-- The devs added a check for non-existant keys in the hr table (and _G, but that's another story)
	-- using rawset bypasses the check and prevents log spam (Trying to create new value hr.PlanetColony5Longitude)
	if not hr.PlanetColony5Longitude then
		local rawset = rawset
		local hr = hr
		for i = 5, 20 do
			rawset(hr, "PlanetColony" .. i .. "Longitude", 0)
			rawset(hr, "PlanetColony" .. i .. "Latitude", 0)
		end
	end

	-- we only add more if there's three rivals already
	local count = table.count(RivalAIs)
	if count ~= 3 then
		return
	end

	-- spawn all the rest
	local SpawnRivalAI = SpawnRivalAI
	for _ = 1, (#Presets.DumbAIDef.MissionSponsors - 2) do
		-- stop spawning when we're maxed out
		if count >= mod_MaxRivals then
			break
		end
		-- defaults to random rival
		SpawnRivalAI()
		count = count + 1
	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
