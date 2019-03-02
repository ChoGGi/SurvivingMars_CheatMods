-- See LICENSE for terms

local skip_lookup = {
	random = true,
	none = true,
	default = true,
}

local function StartupCode()
	-- abort if there's no rivals
	if not RivalAIs then
		return
	end

	-- get current rival count
	local RivalAIs = RivalAIs
	local count = 0
	for id in pairs(RivalAIs) do
		count = count + 1
		-- add 'em to the skip_lookup table for spawn loop below
		skip_lookup[id] = true
	end

	-- we only add more if there's three rivals already
	if count ~= 3 then
		return
	end

	-- skip current sponsor
	skip_lookup[g_CurrentMissionParams.idMissionSponsor] = true

	local SpawnRivalAI = SpawnRivalAI

	-- spawn all the rest
	local rival_colonies = MissionParams.idRivalColonies.items
	for i = 1, #rival_colonies do
		local rival = rival_colonies[i]
		if not skip_lookup[rival.id] then
			SpawnRivalAI(rival)
		end
	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
