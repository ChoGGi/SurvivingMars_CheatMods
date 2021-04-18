-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	-- ClassesPostprocess fires earlier than ModsReloaded (well probably just for me)
	if not options then
		return
	end

	local POIPresets = POIPresets
	for id, poi in pairs(POIPresets) do
		local min = options:GetProperty(id .. "_Min")
		local max = options:GetProperty(id .. "_Max")

		-- just to be safe
		if min > max then
			max = min + 1
		end

		poi.spawn_period.from = min
		poi.spawn_period.to = max
	end

	-- stop options from blanking out from ClassesPostprocess
	if #options.properties == 0 then
		options.properties = nil
	end

	if not UICity then
		return
	end

	-- update spawn times
	local day = UICity.day
	local CalcNextSpawnProject = CalcNextSpawnProject
	local g_SpecialProjectNextSpawn = g_SpecialProjectNextSpawn
	for id, item in pairs(g_SpecialProjectNextSpawn) do
		-- If the next spawn time is larger then the max option then recalc
		if item.day > (day + options:GetProperty(id .. "_Max")) then
			CalcNextSpawnProject(id)
		end
	end
end

-- load default/saved settings
OnMsg.ClassesPostprocess = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end
