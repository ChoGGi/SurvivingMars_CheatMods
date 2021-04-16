-- See LICENSE for terms

-- fired when settings are changed/init
local function UnlockBreaks(newgame)
	local UICity = UICity
	if not UICity then
		return
	end

	CreateRealTimeThread(function()
		-- add delay for new games, alien imprints (and others?), and plateaus == building sinking to height of rest of map
		if newgame then
			WaitMsg("LoadingScreenPreClose")
		end

		local options = CurrentModOptions
		local func = options:GetProperty("BreakthroughsResearched") and UICity.SetTechResearched or UICity.SetTechDiscovered
		local bt = Presets.TechPreset.Breakthroughs
		for i = 1, #bt do
			local id = bt[i].id
			if options:GetProperty(id) then
				func(UICity, id)
			end
		end
	end)

end

local function ModOptions(newgame)
	if CurrentModOptions:GetProperty("AlwaysApplyOptions") then
		UnlockBreaks(newgame)
	end
end

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		UnlockBreaks()
	end
end
function OnMsg.CityStart()
	ModOptions(true)
end

OnMsg.ModsReloaded = ModOptions
OnMsg.LoadGame = ModOptions
