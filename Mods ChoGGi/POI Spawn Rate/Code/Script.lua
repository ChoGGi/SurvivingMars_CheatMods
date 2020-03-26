-- See LICENSE for terms

local options

local function UpdateRate()
	options = CurrentModOptions
	ModOptions()

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
			min = max
		end

		poi.spawn_period.from = min
		poi.spawn_period.to = max
	end
end

-- fired when settings are changed/init
local function ModOptions()
	UpdateRate()

	if not GameState.gameplay then
		return
	end

	-- update spawn times
	local day = UICity.day
	local CalcNextSpawnProject = CalcNextSpawnProject
	local g_SpecialProjectNextSpawn = g_SpecialProjectNextSpawn
	for id, item in pairs(g_SpecialProjectNextSpawn) do
		-- if the next spawn time is larger then the max option then recalc
		if item.day > (day + options:GetProperty(id .. "_Max")) then
			CalcNextSpawnProject(id)
		end
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

OnMsg.ClassesPostprocess = UpdateRate
-- could do load game, but I think from mod options is better
--~ OnMsg.LoadGame = UpdateRate
