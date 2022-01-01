-- See LICENSE for terms

-- fired when settings are changed/init
local function UnlockBreaks(newgame)
	local UIColony = UIColony
	if not UIColony then
		return
	end

	CreateRealTimeThread(function()
		-- add delay for new games, alien imprints (and others?), and plateaus == building sinking to height of rest of map
		if newgame then
			WaitMsg("LoadingScreenPreClose")
		end

		local options = CurrentModOptions
		local func = options:GetProperty("BreakthroughsResearched") and UIColony.SetTechResearched or UIColony.SetTechDiscovered

		local bt = Presets.TechPreset.Breakthroughs
		for key in pairs(bt) do
			if type(key) == "string" then
				if options:GetProperty(key) then
					func(UIColony, key)
				end
			end
		end
	end)

end

local function ModOptions(newgame, from_mod_options)
	if from_mod_options or CurrentModOptions:GetProperty("AlwaysApplyOptions") then
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
function OnMsg.ModsReloaded()
	ModOptions(nil, true)
end

OnMsg.LoadGame = ModOptions
