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
		if rules.ChoGGi_MaxThreatsDustDevils then
			mapdata.MapSettings_DustDevils = "DustDevils_VeryHigh"
		end
	end

	return orig_FillRandomMapProps(gen, params, ...)
end

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_LowResources then
		return
	end

	PlaceObj("GameRules", {
		description = T(692, "Resources") .. " "
			.. T(0, " will always be the lowest level."),
		display_name = T(0, "Low Resources"),
		group = "Default",
		id = "ChoGGi_LowResources",
	})

	PlaceObj("GameRules", {
		description = T(3983, "Disasters") .. " "
			.. T(0, " will always be the highest level."),
		display_name = T(0, "Max Threats"),
		group = "Default",
		id = "ChoGGi_MaxThreats",
	})

	PlaceObj("GameRules", {
		description = T(4142, "Dust Devils") .. " "
			.. T(0, " will always be the highest level."),
		display_name = T(0, "Max Threats") .. " " .. T(4142, "Dust Devils"),
		group = "Default",
		id = "ChoGGi_MaxThreatsDustDevils",
	})
end
