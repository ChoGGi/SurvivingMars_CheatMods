-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print("All Rivals needs DLC Installed: Space Race!")
	return
end

local mod_MaxRivals

-- fired when settings are changed/init
local function ModOptions()
	mod_MaxRivals = CurrentModOptions:GetProperty("MaxRivals")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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
