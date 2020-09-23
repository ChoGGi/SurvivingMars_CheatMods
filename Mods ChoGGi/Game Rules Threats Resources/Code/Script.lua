-- See LICENSE for terms

-- 46S180W res min
-- 0S111W devil/storm max
-- 18N35W meteor/cold max

local orig_FillRandomMapProps = FillRandomMapProps
function FillRandomMapProps(gen, params, ...)
	if gen then
		local rules = g_CurrentMissionParams.idGameRules or empty_table

		if rules.ChoGGi_LowResources then
			local params = g_CurrentMapParams
			params.Concrete = 0
			params.Metals = 0
			params.Polymers = 0
			params.PreciousMetals = 0
			params.Water = 0
		end
		if rules.ChoGGi_MaxThreats then
			mapdata.MapSettings_ColdWave = "ColdWave_VeryHigh"
			mapdata.MapSettings_DustStorm = "DustStorm_VeryHigh"
			mapdata.MapSettings_Meteor = "Meteor_VeryHigh"
		end
	end

	return orig_FillRandomMapProps(gen, params, ...)
end

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_LowResources then
		return
	end

	PlaceObj("GameRules", {
		description = T{302535920011369, "<str> will always be the lowest level.",
			str = T(692, "Resources"),
		},
		display_name = T(302535920011370, "Low Resources"),
		group = "Default",
		id = "ChoGGi_LowResources",
	})

	PlaceObj("GameRules", {
		description = T{302535920011371, "<str> will always be the highest level.",
			str = T(3983, "Disasters"),
		},
		display_name = T(302535920011372, "Max Threats"),
		group = "Default",
		id = "ChoGGi_MaxThreats",
	})
end

-- prevent blank mission profile screen
function OnMsg.LoadGame()
	local GameRulesMap = GameRulesMap
	local rules = g_CurrentMissionParams.idGameRules or empty_table
	for rule_id in pairs(rules) do
		-- If it isn't in the map then it isn't a valid rule
		if not GameRulesMap[rule_id] then
			rules[rule_id] = nil
		end
	end
end
