-- See LICENSE for terms

local IsGameRuleActive = IsGameRuleActive

-- make sure there's one (broad) cold area
local orig_FillRandomMapProps = FillRandomMapProps
function FillRandomMapProps(gen, ...)
	local map = orig_FillRandomMapProps(gen, ...)

	if gen and IsGameRuleActive("ChoGGi_WinterWonderland") then
		gen.ColdAreaChance = 100
		gen.ColdAreaCount = 1
		-- max map size * 4 (make sure everything is covered no matter where the area is)
		gen.ColdAreaSize = range(4857600, 4857600)
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

-- trand func from City.lua>function CreateRand(stable, ...) doesn't like < 2
function OnMsg.ClassesPostprocess()
	local orig_MapSector_new = MapSector.new
	function MapSector:new(...)
		local sector = orig_MapSector_new(self, ...)
		-- good thing avg_heat is added when the sector is created
		if sector.avg_heat == 0 and IsGameRuleActive("ChoGGi_WinterWonderland") then
			sector.avg_heat = 2
		end
		return sector
	end
end
