-- See LICENSE for terms

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	local POIPresets = POIPresets
	for id, poi in pairs(POIPresets) do
		local min = options:GetProperty(id .. "_Min")
		local max = options:GetProperty(id .. "_Max")

		-- some mod added a POI without a min/max spawn time
		if min and max then
			-- just to be safe
			if min > max then
				max = min + 1
			end

			poi.spawn_period.from = min
			poi.spawn_period.to = max
		end

	end

	if not UIColony then
		return
	end

	-- update spawn times
	local day = UIColony.day
	local CalcNextSpawnProject = CalcNextSpawnProject
	local g_SpecialProjectNextSpawn = g_SpecialProjectNextSpawn
	for id, item in pairs(g_SpecialProjectNextSpawn) do
		-- If the next spawn time is larger then the max option then recalc
		if item.day > (day + options:GetProperty(id .. "_Max")) then
			CalcNextSpawnProject(id)
		end
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
