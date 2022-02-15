-- See LICENSE for terms

-- DLC installed
if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed!")
	return
end

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod or not UIColony.underground_map_unlocked then
		return
	end

	local map = GameMaps[UIColony.underground_map_id]

	local objs = map.realm:MapGet("map", "CaveInRubble")
	for i = 1, #objs do
		local obj = objs[i]

		local points = {}
		local c = 0

		-- average pos of work spots to lower to ground
		local start_id, id_end = obj:GetAllSpots(obj:GetState())
		for j = start_id, id_end do
			local text_str = obj:GetSpotName(j)
			if text_str == "Workdrone" then
				c = c + 1
				points[c] = obj:GetSpotPos(j)
			end
		end
		local avg_pos = AveragePoint2D(points)
		obj:SetPos(avg_pos:SetZ(map.terrain:GetHeight(avg_pos)))
	end

end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
--~ -- Switch between different maps (can happen before UICity)
--~ OnMsg.ChangeMapDone = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game UIColony
	if not UICity then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
