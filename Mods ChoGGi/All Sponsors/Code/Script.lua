-- See LICENSE for terms

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

	-- we only add more if there's three rivals already
	local count = table.count(RivalAIs)
	if count ~= 3 then
		return
	end

	local SpawnRivalAI = SpawnRivalAI

	-- spawn all the rest
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
