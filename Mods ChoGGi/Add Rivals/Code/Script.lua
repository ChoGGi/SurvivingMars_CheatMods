-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print("Add Rivals needs DLC Installed: Space Race!")
	return
end

local SpawnRivalAI = SpawnRivalAI

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
	-- already maxed out
	if rival_count == def_count then
		return
	end

	for _ = 1, def_count do
		-- stop spawning when we're maxed out
		if rival_count >= def_count or rival_count >= mod_AddRivals then
			break
		end

		-- defaults to random rival
		SpawnRivalAI()
		rival_count = rival_count + 1
	end

end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_AddRivals = CurrentModOptions:GetProperty("AddRivals")

	-- make sure we're in-game
	if not UICity then
		return
	end

	AddRivals()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.LoadGame = AddRivals
