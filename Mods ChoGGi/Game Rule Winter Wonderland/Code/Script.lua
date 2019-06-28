-- See LICENSE for terms

local orig_FillRandomMapProps = FillRandomMapProps
function FillRandomMapProps(gen, ...)
	local map = orig_FillRandomMapProps(gen, ...)

	if gen and IsGameRuleActive("ChoGGi_WinterWonderland") then
		gen.ColdAreaMargin = 0
		gen.ColdAreaChance = 100
		-- double max map size
		gen.ColdAreaSize = range(1214400, 1214400)
		gen.ColdAreaCount = 10
	end

	return map
end


function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_WinterWonderland then
		return
	end

	PlaceObj("GameRules", {
		description = T(486621856457, "A team of Scientists argues over the satellite data as you quietly ponder the situation. It's going to be a long winter."),
		display_name = T(293468065101, "Winter Wonderland"),
		flavor = T{"<grey><text><newline><right>Haemimont Games</grey><left>",
			text = T(838846202028, "I know! Let's organize a winter festival!"),
		},
		group = "Default",
		id = "ChoGGi_WinterWonderland",
	})
end

local function StartupCode()
	if IsGameRuleActive("ChoGGi_WinterWonderland") then
		GrantTech("SubsurfaceHeating")
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
