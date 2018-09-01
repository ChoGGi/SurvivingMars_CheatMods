-- new games
function OnMsg.CityStart()
	GridConstructionController.max_hex_distance_to_allow_build = 1000
	const.PassageConstructionGroupMaxSize = 1000
end
-- loaded games
function OnMsg.LoadGame()
	GridConstructionController.max_hex_distance_to_allow_build = 1000
	const.PassageConstructionGroupMaxSize = 1000
end
