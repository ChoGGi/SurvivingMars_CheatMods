-- See LICENSE for terms

local options

local UpdateRate
-- fired when settings are changed/init
local function ModOptions()
	UpdateRate()

	if not GameState.gameplay then
		return
	end
	-- update spawn times
	local CalcNextSpawnProject = CalcNextSpawnProject
	local day = UICity.day
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

UpdateRate = function()
	-- ClassesPostprocess fires earlier than ModsReloaded (well probably just for me)
	if not options then
		return
	end

	local POIPresets = POIPresets
	for id, poi in pairs(POIPresets) do
		poi.spawn_period.from = options:GetProperty(id .. "_Min")
		poi.spawn_period.to = options:GetProperty(id .. "_Max")
	end
end

OnMsg.ClassesPostprocess = UpdateRate
-- could do load game, but I think from mod options is better
--~ OnMsg.LoadGame = UpdateRate
