-- See LICENSE for terms

local skip = {
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
	local g_RivalAIs = RivalAIs or empty_table
	local count = 0
	for id in pairs(g_RivalAIs) do
		count = count + 1
		-- add 'em to the skip table for spawn loop below
		skip[id] = true
	end

	-- we only add more if there's three rivals already
	if count ~= 3 then
		return
	end

	-- skip current sponsor
	skip[g_CurrentMissionParams.idMissionSponsor] = true

	local SpawnRivalAI = SpawnRivalAI
	local rival_colonies = MissionParams.idRivalColonies.items

	-- spawn all the rest
	for i = 1, #rival_colonies do
		local rival = rival_colonies[i]
		if not skip[rival.id] then
			SpawnRivalAI(rival)
		end
	end

end

function OnMsg.CityStart()
	StartupCode()
end

function OnMsg.LoadGame()
	StartupCode()
end
